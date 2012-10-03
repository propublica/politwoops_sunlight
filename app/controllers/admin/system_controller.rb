class Admin::SystemController < Admin::AdminController

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
      if exists 
        mtime = File.mtime(path)
        ago = Time.now - mtime
        if ago < 0:
          status = 'restarting'
        elsif ago <= configuration[:heartbeat_interval]
          status = 'running'
        else
          status = 'dead'
        end
      else
        status = 'dead'
      end
      {
        :worker => w,
        :status => status,
        :last_seen => ago.nil? ? nil : mtime.to_s
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
end

