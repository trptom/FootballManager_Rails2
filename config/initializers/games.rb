GAMES = {
}.merge(YAML::load_file(File.open(Rails.root.join('config', 'games', '3.yml')))["games"])
 .merge(YAML::load_file(File.open(Rails.root.join('config', 'games', '4.yml')))["games"])
 .merge(YAML::load_file(File.open(Rails.root.join('config', 'games', '18.yml')))["games"])