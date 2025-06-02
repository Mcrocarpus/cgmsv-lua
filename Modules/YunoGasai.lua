---我妻由乃！
local Module = ModuleBase:createModule('YunoGasai')
local loopManager = getModule("loopManager")
local tree = BT.createTree("YunoGasai", "test.json", {})

function run()
  tree:run()
end

function Module:onLoad()
  self:logInfo('load')
  self.npc = self:NPC_createNormal("我妻由乃", 160580, { map = 1000, x = 225, y = 84, direction = 4, mapType = 0 });
  self:regCallback("TalkEvent", Func.bind(self.onTalkEvent, self));

  loopManager:regCommand("YunoGasai", run, 0, 3000)
  --巡逻+搜索敌人
  --追踪敌人
  --进入战斗
  --战斗中
  ----战斗失败
  ----延迟几秒？
  ----继续追击 or 怪物重置

  ----战斗成功
  ----怪物消失几秒
  ----怪物重置
end

function Module:onTalkEvent(player, msg)

end

function Module:onUnload()
  self:logInfo('unload');
end

return Module;
