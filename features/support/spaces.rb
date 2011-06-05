module SpacesHelper
  def space_by_name(name)
    DB.first! Space.by_name(name)
  end
end

World(SpacesHelper)