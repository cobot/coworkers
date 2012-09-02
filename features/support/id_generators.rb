module IdGenerators
  def next_id
    @id ||= 0
    @id += 1
    @id.to_s
  end
end

World(IdGenerators) if respond_to?(:World)
