-- Init

local bret = require 'lua.libs.behavior3lua.behavior3.behavior_ret'

local M = {
  name = 'MoveToPos',
  type = 'Action',
  desc = '移动到坐标',
  args = {
    {
      name = 'x',
      type = 'int',
      desc = 'x坐标'
    },
    {
      name = 'y',
      type = 'int',
      desc = 'y坐标'
    }
  }
}

function M.run(node, env)
  local args = node.args
  local owner = env.owner
  owner.x = args.x
  owner.y = args.y
  return bret.SUCCESS
end

return M
