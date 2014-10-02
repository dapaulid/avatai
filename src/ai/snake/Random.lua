--------------------------------------------------------------------------------
-- Class SnakeAI implementation
--------------------------------------------------------------------------------
local SnakeAI = {}
SnakeAI.__index = SnakeAI

--------------------------------------------------------------------------------
-- Locals
-------------------------------------------------------------------------------- 
local ScriptInfo = {
	label   = "Random Snake AI",
	version = "1.0",
	author  = "D. Pauli",
	mail    = "dapaulid@gmail.com"
}

local Directions = {
  { name = "left",  v = Vector(-1,  0) },
  { name = "right", v = Vector( 1,  0) },
  { name = "up",    v = Vector( 0, -1) },
  { name = "down",  v = Vector( 0,  1) },
}

--------------------------------------------------------------------------------
-- Constructor
-------------------------------------------------------------------------------- 
function SnakeAI.Create()
	local self = setmetatable({}, SnakeAI)

	-- initialize member variables here
	self.info = ScriptInfo
	self.direction = nil
	self.view = nil	
	
	return self
end

--------------------------------------------------------------------------------
-- Helper function to determine if the given coordinate is safe to move to
-- @param position: (x, y) coordinate to check
-- @return true if the snake can enter the cell without dying
-------------------------------------------------------------------------------- 
function SnakeAI:IsSafe(p)
  local cell = self.view:Get(p)
  return cell == "empty" or cell == "food"
end

--------------------------------------------------------------------------------
-- Determine the next move of the snake
-- @param position: (x, y) coordinate of the snake's head
-- @return direction of the move: "left", "right", "up" or "down"
-------------------------------------------------------------------------------- 
function SnakeAI:Move(position, view)

  -- Remember current view
  self.view = view
  
  -- Compute directions where it is safe to move
  local safedirs = {}
  for i, dir in ipairs(Directions) do
    if self:IsSafe(position + dir.v) then
      table.insert(safedirs, dir.name)
    end
  end
  
  -- Randomly pick a safe direction
	self.direction = safedirs[math.random(#safedirs)]
	
	-- Return it
	return self.direction
end

--------------------------------------------------------------------------------
-- Definition of implicit constructor
-------------------------------------------------------------------------------- 
setmetatable(SnakeAI, { __call = function(_, ...) return SnakeAI.Create(...) end })

return SnakeAI
--------------------------------------------------------------------------------
-- End of file
--------------------------------------------------------------------------------
