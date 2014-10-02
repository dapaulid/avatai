World = {}
World.__index = World

require "framework/Grid"
require "framework/Vector"
require "framework/ColorsRGB"

Directions = {
	Left	 = Vector(-1,	0),
	Right	= Vector( 1,	0),
	Up		 = Vector( 0, -1),
	Down	 = Vector( 0,	1),
}

function World.Create()
	local self = setmetatable({}, World)

  self.grid = Grid()
	self.alive = false
	self.age = 0
	self.views = {}
	self.entities = {}
	self.tiles = {
		empty = {type = "empty", color = colorsRGB.white},
		wall	= {type = "wall", color = colorsRGB.gray},
		food	= {type = "food", color = colorsRGB.brown},
	}
	
	return self
end

function World:Clear()
  self.grid:Clear()
  self.entities = {}
end

function World:AddEntity(entity, p)
	local state = {}

	self.entities[entity] = state
	entity:Prepare(self, p)	
	
	Log("Added entity at %s", p)
end

function World:RemoveEntity(entity)
	entity:Remove()
	self.entities[entity] = nil
end

function World:RemoveEntityAt(p)
	self:RemoveEntity(self:GetCell(p))
end

function World:SetCell(p, value)
	self.grid:Set(p, value)
end

function World:GetCell(p)
	return self.grid:Get(p)
end

function World:ClearCell(p)
	self.grid:Set(p, self.tiles.empty)
end

function World:Tick()

	-- Initially assume world is dead after this tick
	self.alive = false
	
	-- Process all entities
	for entity, state in pairs(self.entities) do
		entity:Tick()
		
		-- World is alive if at least one entity is alive
		self.alive = self.alive or entity.alive
	end

	-- Increase tick counter
	self.age = self.age + 1
end

function World:CalcView(p, r)
	local view = Grid()
	
	for x=p.x-r,p.x+r do
		for y=p.y-r,p.y+r do
			local q = Vector(x, y)
			if math.floor(Vector.distance(p, q) + 0.5) <= r then
				local cell = self.grid:Get(q)
				if cell then
					view:Set(q, cell.type)
				end
			end
		end
	end
	
	return view
end

setmetatable(World, { __call = function(_, ...) return World.Create(...) end })