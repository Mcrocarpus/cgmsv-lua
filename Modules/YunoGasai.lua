---�������ˣ�
local Module = ModuleBase:createModule('YunoGasai')

function Module:onLoad()
  self:logInfo('load')
  self.npc = self:NPC_createNormal("��������", 160580, { map = 1000, x = 225, y = 84, direction = 4, mapType = 0 });
  self:regCallback("TalkEvent", Func.bind(self.onTalkEvent, self));
  self.tree = BT.createTree("YunoGasai","",{})
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
