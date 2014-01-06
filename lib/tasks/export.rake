namespace :politicians do
    require 'csv'

    desc 'Export a politicians as records in a CSV file.'
    task :export => :environment do

        # make separator configurable
        target_file = ENV.fetch('CSV') rescue abort("You must specify a file with CSV=some_file.csv")
        separator = ENV.fetch('CSV_SEP', ',')
        CSV.open(target_file, 'wb', :col_sep => separator) do |csv|
            csv << [
                'user_name',
                'account_type',
                'state',
                'party',
                'office',
                'first_name',
                'last_name',
                'middle_name',
                'suffix'
            ]
            Politician.all.each do |pol|
                csv << [
                    pol.user_name,
                    pol.account_type && pol.account_type.name,
                    pol.state,
                    pol.party && pol.party.name,
                    pol.office && pol.office.title,
                    pol.first_name,
                    pol.last_name,
                    pol.middle_name,
                    pol.suffix
                ]
            end
        end
    end

end

