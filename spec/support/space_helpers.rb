module SpaceHelpers
  def last_space
    Space.first!
  end
end

RSpec.configure do |c|
  c.include SpaceHelpers
end
