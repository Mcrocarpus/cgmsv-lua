-- FindEnemy

local bret = require "lua.libs.behavior3lua.behavior3.behavior_ret"
local abs = math.abs
local pow = math.pow

local M = {
    name = "FindEnemy",
    type = "Condition",
    desc = "���ҵ���",
    args = {
        {
            name = "distance",
            type = "int",
            desc = "׷�پ���"
        }
    },
    input = { "map", "floor", "x", "y", },
    output = { "Ŀ��CharIndex" },
    doc = [[
        + �ҵ�����Ŀ��CharIndex
        + û�ҵ�����ʧ��
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
        dxa = Char.GetData(a, CONST.����_X) - x
        dya = Char.GetData(a, CONST.����_Y) - y
        dxb = Char.GetData(b, CONST.����_X) - x
        dyb = Char.GetData(b, CONST.����_Y) - y
        return (dxa * dxa + dya * dya) < (dxb * dxb + dyb * dyb)
    end)
    local enemy = players[1]
    distance = pow(Char.GetData(enemy, CONST.����_X) - x, 2) + pow(Char.GetData(enemy, CONST.����_Y) - y, 2)
    return ret(distance < node.args.distance), enemy
end

return M
