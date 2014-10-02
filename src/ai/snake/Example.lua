--------------------------------------------------------------------------------
-- Class SnakeAI implementation
--------------------------------------------------------------------------------
local SnakeAI = {}
SnakeAI.__index = SnakeAI

--------------------------------------------------------------------------------
-- Locals
-------------------------------------------------------------------------------- 
local ScriptInfo = {
	label   = "Sample Snake AI",
	version = "1.0",
	author  = "D. Pauli",
	mail    = "dapaulid@gmail.com"
}

--------------------------------------------------------------------------------
-- Constructor
-------------------------------------------------------------------------------- 
function SnakeAI.Create()
	local self = setmetatable({}, SnakeAI)

	-- initialize member variables here
	self.info = ScriptInfo
	self.direction = nil	
	
	return self
end

--------------------------------------------------------------------------------
-- Determine the next move of the snake
-- @param position: (x, y) coordinate of the snake's head
-- @return direction of the move: "left", "right", "up" or "down"
-------------------------------------------------------------------------------- 
function SnakeAI:Move(position, view)

	self.direction = "right"
	
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
