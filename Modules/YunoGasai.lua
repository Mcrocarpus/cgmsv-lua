---�������ˣ�
local Module = ModuleBase:createModule('YunoGasai')
local loopManager = getModule("loopManager")
local tree = BT.createTree("YunoGasai", "test.json", {})

function run()
  tree:run()
end

function Module:onLoad()
  self:logInfo('load')
  self.npc = self:NPC_createNormal("��������", 160580, { map = 1000, x = 225, y = 84, direction = 4, mapType = 0 });
  self:regCallback("TalkEvent", Func.bind(self.onTalkEvent, self));

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

function Module:onTalkEvent(player, msg)

end

function Module:onUnload()
  self:logInfo('unload');
end

return Module;
