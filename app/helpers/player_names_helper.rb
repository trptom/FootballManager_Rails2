# coding:utf-8

module PlayerNamesHelper
  
  # Deletes all records from database for specified country and fills database
  # by data contained in link:../../config/names path.
  #
  # ==== Attributes
  # _country_:: country which names should be reloaded. When null, all countries
  #             in database which have names file in link:../../config/names
  #             will be reloaded.
  def fill_in_names(country = nil)
    shortcut = country;
    if country.kind_of?(Country)
      shortcut = country.shortcut
    end
    
    if shortcut == nil
      for c in Country.all
        fill_in_names(c)
      end
    else
      path = Rails.root.join('config', 'names', "#{shortcut}.yml")
      
      if (File.exist?(path))
        file = YAML::load_file(File.open(path))["name"]

        items = [
          { :name => "first", :type => :first },
          { :name => "second", :type => :second },
          { :name => "last", :type => :last },
          { :name => "pseudonym", :type => :pseudonym }
        ]

        # fill in list of data
        data = {}

        for item in items
          arr = file[item[:name]]

          if arr != nil # in some countries pseudonyms or second names can be empty
            file[item[:name]].each do |name|
              if data[name] == nil
                data[name] = {
                  :name => name,
                  :first => false,
                  :second => false,
                  :last => false,
                  :pseudonym => false
                }
              end

              data[name][item[:type]] = true
            end
          end
        end

        # when country param was string, replace it by country instance
        if !country.kind_of?(Country)
          country = Country.where(:shortcut => country).first
        end

        # delete old items
        PlayerName.destroy_all(:country_id => country.id)

        # create new items
        for name in data
          PlayerName.new(
            :name_str => "Tomáš",
            :first_name => data[:first],
            :second_name => data[:second],
            :last_name => data[:last],
            :pseudonym => data[:pseudonym],
            :country => country,
            :frequency => NAME_FREQUENCY_MAX
          ).save
        end
      end
    end
  end
end
