require 'test-factory'

$: << File.dirname(__FILE__)+'/sambal-kuali'
require 'sambal-kuali/kuali_base_page'
Dir["#{File.dirname(__FILE__)}/sambal-kuali/*.rb"].each {|f| require f }
Dir["#{File.dirname(__FILE__)}/sambal-kuali/pages/*.rb"].each {|f| require f }
Dir["#{File.dirname(__FILE__)}/sambal-kuali/data_objects/*.rb"].each {|f| require f }