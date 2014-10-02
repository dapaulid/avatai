require "framework/Game"
require "framework/Vector"
require "framework/ColorsRGB"

local game = Game()

local Colors = {}
Colors.Grid = {100, 100, 100}

local viewport = Vector(0, 0)
local cellsize = 16
local scale = 1.0

Gui = {}

function Gui.ShowGame(aGame)
  game = aGame
end

function ViewToCell(x, y)
  return 1 + ((Vector(x, y) - viewport) / (cellsize*scale)):floor()
end

function love.mousepressed( x, y, mb )
  if mb == "l" then
    CellClicked(ViewToCell(x, y))
  elseif mb == "wu" then
     scale = scale * 0.75
  elseif mb == "wd" then
     scale = scale / 0.75
  end
end

function CellClicked(p)
  local cell = game.world:GetCell(p)
  if cell then
    if cell == game.world.tiles.empty then
      if love.keyboard.isDown("lshift") then
        game.world:SetCell(p, game.world.tiles.food)
      else 
        game.world:SetCell(p, game.world.tiles.wall)
      end
    else
      game.world:ClearCell(p)
    end
  end
end

function DrawGrid()

  love.graphics.setColor(Colors.Grid)
  
  local width, height = game.world.grid:GetDimensions()
  for x=0,width do
    love.graphics.line(x*cellsize, 0, x*cellsize, height*cellsize)  
  end
  for y=0,height do
    love.graphics.line(0, y*cellsize, width*cellsize, y*cellsize)  
  end
  
end

function DrawCells()
  for x=1,game.world.grid:GetWidth() do
    for y=1,game.world.grid:GetHeight() do
      DrawCell(Vector(x, y))
    end
  end
end

function DrawCell(p, color)
  local cell = game.world:GetCell(p)
  love.graphics.setColor(color or cell.color)
  love.graphics.rectangle("fill", (p.x-1)*cellsize, (p.y-1)*cellsize, cellsize, cellsize)
end

function DrawMarkup()
  --for k, l in pairs(world.views) do
  --  for i, v in ipairs(l) do
  --    DrawCell(v.p, colorsRGB.Alpha("yellow", 100))
  --  end
  --end
end

local lastMousePos = nil
function HandleScrolling()
  local mousePos = Vector(love.mouse.getPosition())
  if lastMousePos and love.mouse.isDown("r") then
    viewport = viewport + (mousePos - lastMousePos)
  end
  lastMousePos = mousePos
end

local lastCellPos = Vector(0, 0)
function HandleMousePressed()
  local p = ViewToCell(love.mouse.getPosition())
  if p ~= lastCellPos then
    if love.mouse.isDown("l") then
      CellClicked(p)
    end
    lastCellPos = p
  end
end

function love.load()
  
  -- center grid in view  
  viewport =  0.5 * 
    (Vector(love.graphics.getDimensions()) - 
     Vector(game.world.grid:GetDimensions()) * cellsize)
  
end

local timeSinceLastTick = 0 -- seconds
local tickInterval = 0.25    -- seconds

function love.update(dt)
  timeSinceLastTick = timeSinceLastTick + dt
  if timeSinceLastTick >= tickInterval then
    game:Update()
    timeSinceLastTick = 0
  end
end

function love.draw()

  HandleScrolling()
  HandleMousePressed()

  local width, height = love.graphics.getDimensions()

  --love.graphics.translate(width * 0.5, height * 0.5)
  
  love.graphics.translate(viewport.x, viewport.y)
  love.graphics.scale(scale)

  DrawCells()
  DrawGrid()
  DrawMarkup()

end


