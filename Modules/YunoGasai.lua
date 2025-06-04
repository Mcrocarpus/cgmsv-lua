---�������ˣ�
local Module = ModuleBase:createModule('YunoGasai')

local loopManager = getModule("loopManager") ---@type loopManager

function Module:onLoad()
  self:logInfo('load')
  self:regCallback("TalkEvent", Func.bind(self.onTalkEvent, self));
  self:init()
  --Ѳ��+��������
  --׷�ٵ���
  --����ս��
  --ս����
  ----ս��ʧ��
  ----�ӳټ���
  ----����׷�� or ��������

  ----ս���ɹ�
  ----������ʧ����
  ----��������
end

---��ʼ����Ϊ��
function Module:init()
  BT.reInitProcess(function()
    local process = require "lua.Modules.BehaviorTree.process"
    return process
  end)
  self.npc = self:NPC_createNormal("��������", 160580, { map = 1000, x = 240, y = 88, direction = 4, mapType = 0 });
  local env = {
    owner = self.npc,
    time_count = 0,
    finder = self:getFinder(),
  }
  self.tree = BT.createTree("YunoGasai", "YunoGasai.json", env)
  run = function()
    self.tree:run()
  end
  loopManager:regCommand("YunoGasai", run, 0, 100)
end

---��ʼ��Ѱ·
---@return metatable @finder
function Module:getFinder()
  local walkable = 1
  local Grid = require("lua.Modules.jumper.grid")
  local Pathfinder = require("lua.Modules.jumper.pathfinder")
  local grid = Grid(self:cookMap(0, 1000))
  local finder = Pathfinder(grid, 'ASTAR', walkable)
  -- finder:setTunnelling(true)
  return finder
end

---�����ϰ���ͼ
---@param map integer
---@param floor integer
---@return table @�ϰ���ͼ
function Module:cookMap(map, floor)
  local list = {}
  local sizeX, sizeY = Map.GetMapSize(map, floor)
  for y = 1, sizeY do
    list[y] = {}
    for x = 1, sizeX do
      list[y][x] = Map.IsWalkable(map, floor, x, y)
    end
  end
  return list
end

function Module:onTalkEvent(player, msg)

end

function Module:onUnload()
  self:logInfo('unload');
  loopManager:unRegCommand("YunoGasai")
end

return Module;
