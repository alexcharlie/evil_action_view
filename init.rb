require 'evil_action_view'
require 'evil_action_part'

if File.exist?(part_path = File.join(RAILS_ROOT, 'app', 'parts'))
  Dependencies.load_paths << part_path
end