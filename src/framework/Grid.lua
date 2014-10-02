--------------------------------------------------------------------------------
-- Class Grid implementation
--------------------------------------------------------------------------------
Grid = {}
Grid.__index = Grid

--------------------------------------------------------------------------------
-- Constructor
-------------------------------------------------------------------------------- 
function Grid.Create()
  local self = setmetatable({}, Grid)

  self:Clear()

  return self
end

--------------------------------------------------------------------------------
-- Clear all grid contents
-------------------------------------------------------------------------------- 
function Grid:Clear()
  self.minX = nil  
  self.minY = nil
  self.maxX = nil  
  self.maxY = nil
  self.cells = {}
end

--------------------------------------------------------------------------------
-- Get element at given (x, y) coordinate
-------------------------------------------------------------------------------- 
function Grid:GetCell(x, y)
  return self.cells[x] and self.cells[x][y] or nil
end

function Grid:Get(p)
  return self:GetCell(p.x, p.y)
end

--------------------------------------------------------------------------------
-- Set element at given (x, y) coordinate
-------------------------------------------------------------------------------- 
function Grid:SetCell(x, y, value)
  if value then
  
    self.minX = self.minX and math.min(self.minX, x) or x
    self.minY = self.minY and math.min(self.minY, y) or y
    self.maxX = self.maxX and math.max(self.maxX, x) or x
    self.maxY = self.maxY and math.max(self.maxY, y) or y
  
    self.cells[x] = self.cells[x] or {}
    self.cells[x][y] = value
  elseif self.cells[x] then
    self.cells[x][y] = nil
  end
end

function Grid:Set(p, value)
  self:SetCell(p.x, p.y, value)
end

function Grid:GetWidth()
  return self.maxX - self.minX + 1
end

function Grid:GetHeight()
  return self.maxY - self.minY + 1
end

function Grid:GetDimensions()
  return self:GetWidth(), self:GetHeight()
end

--------------------------------------------------------------------------------
-- Definition of implicit constructor
-------------------------------------------------------------------------------- 
setmetatable(Grid, { __call = function(_, ...) return Grid.Create(...) end })

--------------------------------------------------------------------------------
-- End of file
--------------------------------------------------------------------------------
