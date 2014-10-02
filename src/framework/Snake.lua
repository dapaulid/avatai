--------------------------------------------------------------------------------
-- Class Snake implementation
--------------------------------------------------------------------------------
Snake = {}
Snake.__index = Snake

--------------------------------------------------------------------------------
-- Requires
-------------------------------------------------------------------------------- 
require "framework/Log"
require "framework/Vector"
require "framework/Queue"
require "framework/SnakeRules"

--------------------------------------------------------------------------------
-- Locals
-------------------------------------------------------------------------------- 
local directions = {
	left  = Vector( -1,  0 ),
	right = Vector(  1,  0 ),
	up    = Vector(  0, -1 ),
	down  = Vector(  0,	 1 ),
}

--------------------------------------------------------------------------------
-- Constructor
-------------------------------------------------------------------------------- 
function Snake.Create(id, ai)

	local self = setmetatable({}, Snake)
	
	self.world = nil
	self.id = id
	self.ai = ai
	self.type = "snake"
	self.color = nil
	self.position = nil
	self.body = nil
	self.alive = false
	self.age = 0
	self.growby = 0
	
	return self
end

function Snake:Prepare(world, position)

	-- Remove snake from any old world or place
	self:Remove()

	-- Set world parameters
	self.world = world
	self.position = position
	
	-- Set head of snake
	self.body = Queue()
	self.body:Push(self.position)
	self.world:SetCell(self.position, self)
	
	-- Prepare to grow to initial length
	self.growby = SnakeRules.initiallength - 1
	
	-- Become alive
	self.alive = true
	self.age = 0
end

function Snake:Remove()
	
	if self.world then
	
		-- Remove body
		while self:Length() > 0 do
			self.world:ClearCell(self.body:Pop())
		end
		
		-- Reset state variables
		self.position = nil
	end
end

function Snake:Tick()

	-- Process only snakes that are still alive
	if not self.alive then
		return
	end

	-- Get the snake's current view of the world
	local view = self.world:CalcView(self.position, SnakeRules.viewradius)
	
	-- Let AI compute direction of this move
	local dir = self.ai:Move(self.position, view)
	
	-- Check for valid direction
	if dir and directions[dir] then
	
		-- Compute next position
		local newpos = self.position + directions[dir]
		
		-- Check what we find there
		local cell = self.world:GetCell(newpos)
		if not cell then
			Log("%s: Ran into the Void at %s", self.id, newpos)
			self:Die()
			return
		end
		
		if cell.type == "empty" then
			-- OK, just go on
		elseif cell.type == "food" then
			-- Yummie!
      Log("%s: Eating food!", self.id)			
			self.growby = self.growby + SnakeRules.foodvalue
		else
			-- That's something bad
			Log("%s: Ran into a %s", self.id, cell.type)
			self:Die()
			return
		end
		
		-- When we got here the move is fine!
		
		-- Move head
		self.position = newpos
		self.body:Push(self.position)
		self.world:SetCell(self.position, self)

		-- Handle tail
		if self.growby == 0 then
			-- Snake is not growing, so move tail
			self.world:ClearCell(self.body:Pop())
		else
			-- Snake is growing, so tail does not move
			self.growby = self.growby - 1
		end
	 
		-- Become a tick older
		self.age = self.age + 1
	 
	else
		Log("Invalid move direction: %s", dir)
		self:Die()
	end

end

function Snake:Length()
	return self.body and self.body:Count() or 0
end

function Snake:Die()
	self.alive = false
	Log("Snake '%s' died at age %d with length %d.", 
	 self.id, self.age, self:Length())
end

setmetatable(Snake, { __call = function(_, ...) return Snake.Create(...) end })