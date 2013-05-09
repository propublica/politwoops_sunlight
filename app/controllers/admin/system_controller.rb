class Admin::SystemController < Admin::AdminController
  include ApplicationHelper

  def status
    # Checks heartbeat files found in the configuration.
    # If the file exists and the timestamp is current, the worker
    # is running and can be restarted via the web interface.
    # If the file is missing (the worker failed to restart) or the 
    # file exists but the timestamp is old (the process exited abnormally)
    # then the process will have to be restarted by the admin.

    expected_heartbeats = configuration[:heartbeats_expected]
    @worker_statuses = expected_heartbeats.map do |w|
      path = File.join(configuration[:heartbeats_directory], w)
      exists = File.exists? path
      traceback = nil
      started = nil
      if exists 
        begin
          heartbeat_contents = File.new(path).read()
          meta = JSON.parse(heartbeat_contents)
          started = Time.parse(meta.fetch('started'))
        rescue JSON::ParserError => e
          traceback = heartbeat_contents
        end

        mtime = File.mtime(path)
        ago = (Time.now - mtime).floor
        if ago < 0:
          status = 'restarting'
        elsif ago <= (configuration[:heartbeat_interval] * 1.10) # Allow 10% error
          status = 'running'
        else
          status = 'dead'
        end
      else
        status = 'dead'
      end
      
      if status == 'dead'
        if worker_checker(w)
          status == 'running'
        end
      end

      {
        :worker => w,
        :status => status,
        :last_seen => ago.nil? ? nil : mtime.strftime("%Y-%m-%dT%H:%M:%S%z"),
        :started => started.nil? ? nil : started.strftime("%Y-%m-%dT%H:%M:%S%z"),
        :uptime => (status == 'running' && started != nil) ? duration_abbrev(mtime - started).to_s : nil,
        :traceback => started.nil? ? traceback : nil
      }
    end

    @last_tweet = Tweet.order("modified DESC").first

    respond_to do |format|
      format.html { render :template => "admin/system/status" }
      format.json { render :json => { :workers => @worker_statuses, :last_tweet => @last_tweet.format } }
    end
  end

  def restart
    if params[:worker].empty?
      flash[:error] = "No such worker!"
      return redirect_to :action => "status"
    end

    expected_heartbeats = configuration[:heartbeats_expected]
    if not expected_heartbeats.include? params[:worker]
      flash[:error] = "No such worker!"
      return redirect_to :action => "status"
    end

    path = File.join(configuration[:heartbeats_directory], params[:worker])
    if File.exists? path
      future = Time.now + configuration[:heartbeat_interval] * 2
      File.utime future, future, path
      flash[:error] = "Worker restarting"
      return redirect_to :action => "status", :alert => "Worker restarting."
    else
      flash[:error] = "Worker is dead and it can't be restarted."
      return redirect_to :action => "status"
    end
  end

  def report
    if params[:worker].empty?
      flash[:error] = "Worker restarting"
      return redirect_to :action => "status"
    end

    flash[:error] = "Problem reported, thanks."
    return redirect_to :action => "status"
  end

  def start
    if params[:worker].nil? or params[:worker].empty?
      flash[:error] = "Worker restarting"
      return redirect_to :action => "status"
    end
    if worker_checker(params[:worker])
      flash[:error] = "Worker already started"
      return redirect_to :action => "status"
    end

    cmd = ''
    
    if configuration[:python_ve_directory] != nil &&  configuration[:python_ve_directory] != ''
      cmd += '. ' + configuration[:python_ve_directory] + 'bin/activate && '
    end
  cmd +=  'cd ' + configuration[:workers_directory] + ' && '  
  if params[:worker] == 'tweets-client.py'
    cmd += '. ' + 'bin/check'
    #cmd += configuration[:python_path] + ' bin/' + params[:worker] + ' --restart --output ' + configuration[:workers_log_directory] + params[:worker] + '.log >>' + configuration[:workers_log_directory] + params[:worker] +'.err 2>&1 & '
  elsif params[:worker] == 'politwoops-worker.py'
    cmd += '. ' +  'bin/check-worker'
  else  
    cmd += configuration[:python_path] + ' bin/' + params[:worker] + ' --output ' + configuration[:workers_log_directory] + params[:worker] + '.log &'
  end

  #res = %x[ #{cmd} ]
  res = system(cmd)

    return redirect_to :action => "status"
  end

  def worker_checker(worker)
    checker = 'pgrep -f ' + worker
    res = %x[ #{checker} ]
    if res.nil? or res.length <= 0 or res == 0
      return false
    else
      return true
    end
  end

end