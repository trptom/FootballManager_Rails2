class Params < ActiveRecord::Base
  attr_accessible :param_name, :param_value
  
  serialize :param_value
  
  @@data_cache = {}
  
  def self.get(name)
    if (@@data_cache[name] == nil)
      @@data_cache[name] = Params.where(:param_name => name).first.param_value
    end
    return @@data_cache[name]
  end
  
  def self.set(name, data)
    item = Params.where(:param_name => name).first
    item.param_value = data
    if item.save
      @@data_cache[name] = data
    else
      @@data_cache[name] = nil
    end
  end
  
  def self.season
    return self.get("season")[:value]
  end
  
  def self.season_day
    return self.get("season_day")[:value]
  end
  
  def self.inc_season
    val = self.season
    self.set("season", { :value => (val+1) })
  end
  
  def self.inc_season_day
    val = self.season_day
    self.set("season_day", { :value => (val+1) })
  end
end
