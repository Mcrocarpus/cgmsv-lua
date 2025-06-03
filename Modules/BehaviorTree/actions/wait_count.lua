-- WaitCount

local bret = require 'lua.libs.behavior3lua.behavior3.behavior_ret'

local M = {
  name = 'WaitCount',
  type = 'Action',
  desc = '等待次数',
  args = {
    {
      name = 'count',
      type = 'int',
      desc = '次数'
    },
  },
  doc = [[
        + 等待count次
    ]]
}

function M.run(node, env)
  env.time_count = env.time_count + 1
  if env.time_count >= node.args.count then
    return bret.SUCCESS
  end
  return bret.RUNNING
end

return M
