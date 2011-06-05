Given /^a space "([^"]*)"$/ do |name|
  DB.save! Space.new(name: name)
end