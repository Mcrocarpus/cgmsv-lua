---�������ˣ�
local Module = ModuleBase:createModule('YunoGasai')

local loopManager = getModule("loopManager") ---@type loopManager
local tree

function Module:onLoad()
  self:logInfo('load')
  self:regCallback("TalkEvent", Func.bind(self.onTalkEvent, self));
  self:init()
  loopManager:regCommand("YunoGasai", run, 0, 3000)
  --Ѳ��+��������
  --׷�ٵ���
  --����ս��
  --ս����
  ----ս��ʧ��
  ----�ӳټ��룿
  ----����׷�� or ��������

  ----ս���ɹ�
  ----������ʧ����
  ----��������
end

function run()
  tree:run()
end

function Module:init()
  self.npc = self:NPC_createNormal("��������", 160580, { map = 1000, x = 225, y = 84, direction = 4, mapType = 0 });
  tree = BT.createTree("YunoGasai", "YunoGasai.json", { owner = self.npc })
  loopManager:regCommand("YunoGasai", run, 0, 3000)
end

function Module:onTalkEvent(player, msg)

end

function Module:onUnload()
  self:logInfo('unload');
end

return Module;
