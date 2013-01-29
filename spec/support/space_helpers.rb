module SpaceHelpers
  def last_space
    DB.first!(Space.by_name)
  end
end

RSpec.configure do |c|
  c.include SpaceHelpers
end
