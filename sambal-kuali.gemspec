spec = Gem::Specification.new do |s|
  s.name = 'sambal-kuali'
  s.version = '0.0.6'
  s.summary = %q{rSmart's test framework for testing Kuali Student}
  s.description = %q{This gem is used for creating test scripts for Kuali Student.}
  s.files = Dir.glob("**/**/**")
  s.authors = ["Abraham Heward", "Mike Wyers", "Adam Campbell"]
  s.email = %w{"aheward@rsmart.com" "mike.wyers@utoronto.ca", "acampbell@rsmart.com"}
  s.homepage = 'https://github.com/rSmart'
  s.add_dependency 'test-factory', '>= 0.0.2'
  s.required_ruby_version = '>= 1.9.2'
end