--------------------------------------------------------------------------------
-- Class Queue implementation
--------------------------------------------------------------------------------
Queue = {}
Queue.__index = Queue

--------------------------------------------------------------------------------
-- Constructor
-------------------------------------------------------------------------------- 
function Queue.Create()
  local self = setmetatable({}, Queue)
  self.head = -1
  self.tail = 0
  return self
end

--------------------------------------------------------------------------------

function Queue:Push(value)
  local head = self.head + 1
  self.head = head
  self[head] = value
end

--------------------------------------------------------------------------------

function Queue:Pop()
  local tail = self.tail
  if self:Count() > 0 then
    local value = self[tail]
    self[tail] = nil
    self.tail = tail + 1
    return value
  else
    return nil
  end
end

--------------------------------------------------------------------------------

function Queue:Count()
  return self.head - self.tail + 1
end

--------------------------------------------------------------------------------
-- Definition of implicit constructor
-------------------------------------------------------------------------------- 
setmetatable(Queue, { __call = function(_, ...) return Queue.Create(...) end })

--------------------------------------------------------------------------------
-- End of file
--------------------------------------------------------------------------------