module SpaceHelpers
  def space_by_name(name)
    Space.where(name: name).first!
  end
end

World(SpaceHelpers) if respond_to?(:World)
