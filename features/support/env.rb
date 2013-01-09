#$test_site = "http://env2.ks.kuali.org" # TODO: This needs some serious re-thinking. Should come from a yaml config file instead of being explicitly declared here.
$test_site = "http://localhost:8081/ks-with-rice-bundled-dev"

$: << File.dirname(__FILE__)+'/../../lib'

require 'sambal-kuali'

World Foundry
World StringFactory
World DateFactory
World Workflows

client = Selenium::WebDriver::Remote::Http::Default.new
client.timeout = 15 # seconds – default is 60

if ENV['HEADLESS']
  require 'headless'
  headless = Headless.new
  headless.start
  at_exit do
    headless.destroy
  end

  #After do | scenario |
  #  if scenario.failed?
  #    @browser.close
  #    browser = Watir::Browser.new :firefox, :http_client => client
  #    @browser = browser
  #  end
  #end

end

browser = Watir::Browser.new :firefox, :http_client => client

Before do
  @browser = browser
end

at_exit { browser.close }
