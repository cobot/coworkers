Given /^a space "([^"]*)"$/ do |name|
  DB.save! Space.new(name: name, id: name.gsub(/\W+/, '_'))
end