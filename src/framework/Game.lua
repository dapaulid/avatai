--------------------------------------------------------------------------------
-- Class Game implementation
--------------------------------------------------------------------------------
Game = {}
Game.__index = Game

--------------------------------------------------------------------------------
-- Requires
--------------------------------------------------------------------------------
require "framework/Snake"
require "framework/World"
require "framework/Vector" 
require "framework/Log"

--------------------------------------------------------------------------------
-- Locals
-------------------------------------------------------------------------------- 
local PlayerColors = {
  colorsRGB.blue,
  colorsRGB.red,
  colorsRGB.green,
  colorsRGB.orange,
  colorsRGB.brown,
  colorsRGB.darkviolet,
  colorsRGB.turquoise,
}

--------------------------------------------------------------------------------
-- Constructor
-------------------------------------------------------------------------------- 
function Game.Create()

	local self = setmetatable({}, Game)
	
  self.world = World()
	self.players = {}
	self.startpos = {}
	
	return self
end

function Game:LoadMap(file)
  
  local charmap = {
    [" "] = self.world.tiles.empty,
    ["X"] = self.world.tiles.wall,
    ["F"] = self.world.tiles.food,
  }
  
  local y = 1
  for line in io.lines(file) do
    for x=1,#line do
      local p = Vector(x, y)
      local ch = line:sub(x,x)
      local num = tonumber(ch)
      if num then
        self.startpos[num] = p
        self.world:SetCell(p, self.world.tiles.empty)
      else
        self.world:SetCell(p, charmap[ch])
      end
    end 
    y = y + 1
  end

  Log("Map loaded: %dx%d tiles, %d start positions",
    self.world.grid:GetWidth(), self.world.grid:GetHeight(), #self.startpos)

end

function Game:AddPlayer(scriptname)
  self.players[#self.players+1] = {
    aiclass = require(scriptname)
  }
end

function Game:Prepare()
  for i, player in ipairs(self.players) do
    local snake = Snake("Snake"..i, player.aiclass.Create())
    snake.color = PlayerColors[(i-1) % #PlayerColors + 1]
    self.world:AddEntity(snake, self.startpos[i])
  end
end

function Game:Update()
  self.world:Tick()
end

setmetatable(Game, { __call = function(_, ...) return Game.Create(...) end })