require 'heroku/command/run'
require 'describer'
require 'bootstrapper'

$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), '../../../vendor/json_pure/lib'))
require 'json/pure'

# invoke commands without fucking "run"
class Heroku::Command::Json < Heroku::Command::Run

  def bootstrap
    Heroku::Helpers.action "Bootstrapping using heroku.json" do
    json = File.read('heroku.json')
    json = JSON.parse(json)
    bootstrapper = Bootstrapper.new(api, app, json)
    bootstrapper.bootstrap
    end
  end

  alias_command 'bootstrap', 'json:bootstrap'

  def describe
    Heroku::Helpers.action "Describing #{app} to heroku.json" do
      describer = Describer.new(api, app)
      json = describer.describe
      File.write('heroku.json', JSON.pretty_generate(json))
    end
  end

  alias_command 'describe', 'json:describe'

end

