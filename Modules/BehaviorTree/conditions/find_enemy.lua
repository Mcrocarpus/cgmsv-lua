-- FindEnemy

local bret = require "lua.libs.behavior3lua.behavior3.behavior_ret"

local M = {
    name = "FindEnemy",
    type = "Condition",
    desc = "查找敌人",
    args = {
        {
            name = 'x',
            type = 'int?',
            desc = 'x'
        },
        {
            name = 'y',
            type = 'int?',
            desc = 'y'
        },
        {
            name = 'map',
            type = 'int?',
            desc = 'map'
        },
        {
            name = 'floor',
            type = 'int?',
            desc = 'floor'
        },
    },
    output = {"目标CharIndex"},
    doc = [[
        + 找到返回目标CharIndex
        + 没找到返回失败
    ]]
}

local function ret(r)
    return r and bret.SUCCESS or bret.FAIL
end

function M.run(node, env)
    local args = node.args
    local x, y = env.owner.x, env.owner.y
    local w, h = args.w, args.h
    local list = env.ctx:find(function(t)
        if t == env.owner then
            return false
        end
        local tx, ty = t.x, t.y
        return math.abs(x - tx) <= w and math.abs(y - ty) <= h
    end, args.count)

    local enemy = list[1]
    return ret(enemy), enemy
end

return M