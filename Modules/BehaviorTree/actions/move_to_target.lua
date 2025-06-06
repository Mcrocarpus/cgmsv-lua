-- MoveToTarget

local bret = require "lua.libs.behavior3lua.behavior3.behavior_ret"

local M    = {
  name = "MoveToTarget",
  type = "Action",
  desc = "移动到目标",
  input = { "目标" },
  doc = [[
        + 向目标移动
    ]]
}

local function getDirection(startX, startY, endX, endY)
  if endX == startX and endY == startY then
    return -1
  end
  local dx = endX - startX
  local dy = endY - startY
  local radians = math.atan2(dy, dx)
  local degrees = radians * 180 / math.pi
  degrees = degrees + 90
  if degrees < 0 then
    degrees = degrees + 360
  end
  local direction = math.fmod(degrees / 45, 8)
  -- print(dx, dy, direction)
  return direction
end

local function walkMove(owner, node1, x2, y2)
  local dir = getDirection(node1:getX(), node1:getY(), x2, y2)
  return NLG.WalkMove(owner, dir)
end

function M.run(node, env, target)
  -- print("move to target ", target)
  if not target then
    return bret.FAIL
  end

  local owner = env.owner
  local finder = env.finder
  local ownerX = Char.GetData(owner, CONST.对象_X)
  local ownerY = Char.GetData(owner, CONST.对象_Y)
  local targetX = Char.GetData(target, CONST.对象_X)
  local targetY = Char.GetData(target, CONST.对象_Y)
  local path = finder:getPath(ownerX, ownerY, targetX, targetY)

  if not path then
    -- print("move to target no path")
    return bret.FAIL
  end
  local nodes = path._nodes
  if #nodes < 2 then
    return bret.SUCCESS
  end

  --临时方法
  if walkMove(owner, nodes[1], nodes[2]:getX(), nodes[2]:getY()) != 0 then
    if walkMove(owner, nodes[1], nodes[1]:getX(), nodes[2]:getY()) != 0 then
      walkMove(owner, nodes[1], nodes[2]:getX(), nodes[1]:getY())
    end
  end
  print("move to target move once")
  return bret.SUCCESS
end

return M
