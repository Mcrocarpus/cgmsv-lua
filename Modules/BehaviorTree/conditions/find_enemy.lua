-- FindEnemy

local bret = require "lua.libs.behavior3lua.behavior3.behavior_ret"
local abs = math.abs
local pow = math.pow

local M = {
    name = "FindEnemy",
    type = "Condition",
    desc = "查找敌人",
    args = {
        {
            name = "distance",
            type = "int",
            desc = "追踪距离"
        }
    },
    input = { "map", "floor", "x", "y", },
    output = { "目标CharIndex" },
    doc = [[
        + 找到返回目标CharIndex
        + 没找到返回失败
    ]]
}

local function ret(r)
    return r and bret.SUCCESS or bret.FAIL
end

function M.run(node, env, map, floor, x, y)
    local players = NLG.GetMapPlayer(map, floor)
    if not players[1] then
        return bret.FAIL, nil
    end
    table.sort(players, function(a, b)
        dxa = Char.GetData(a, CONST.对象_X) - x
        dya = Char.GetData(a, CONST.对象_Y) - y
        dxb = Char.GetData(b, CONST.对象_X) - x
        dyb = Char.GetData(b, CONST.对象_Y) - y
        return (dxa * dxa + dya * dya) < (dxb * dxb + dyb * dyb)
    end)
    local enemy = players[1]
    distance = pow(Char.GetData(enemy, CONST.对象_X) - x, 2) + pow(Char.GetData(enemy, CONST.对象_Y) - y, 2)
    return ret(distance < node.args.distance), enemy
end

return M
