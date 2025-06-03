-- MoveToPos

local bret = require 'lua.libs.behavior3lua.behavior3.behavior_ret'

local M = {
  name = 'MoveToPos',
  type = 'Action',
  desc = '移动到坐标',
  args = {
    {
      name = 'map',
      type = 'int',
      desc = '地图类型'
    },
    {
      name = 'floor',
      type = 'int',
      desc = '地图'
    },
    {
      name = 'x',
      type = 'int',
      desc = 'x坐标'
    },
    {
      name = 'y',
      type = 'int',
      desc = 'y坐标'
    },
  },
  doc = [[
        + 怪物刷新
    ]]
}

function M.run(node, env)
  local args = node.args
  local owner = env.owner
  Char.SetData(owner, CONST.对象_地图类型, args.map)
  Char.SetData(owner, CONST.对象_地图, args.floor)
  Char.SetData(owner, CONST.对象_X, args.x)
  Char.SetData(owner, CONST.对象_Y, args.y)
  NLG.UpChar(owner)
  return bret.SUCCESS
end

return M
