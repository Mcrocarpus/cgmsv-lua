local Module = ModuleBase:createModule('template')

function Module:onLoad()
	self:logInfo('load')
	self.npc = self:NPC_createNormal("template", 101024, { map = 1000, x = 225, y = 84, direction = 4, mapType = 0 });
	self:regCallback("TalkEvent", Func.bind(self.onTalkEvent, self));
	self:regCallback("ItemString", Func.bind(self.onItemUseEvent, self), 'LUA_usetemplate');
	self:NPC_regTalkedEvent(self.npc, Func.bind(self.onTalkedEvent, self));
	self:NPC_regWindowTalkedEvent(self.npc, Func.bind(self.onWindowTalkedEvent, self))
end

function Module:onTalkedEvent(npc, player)
	
end

function Module:onWindowTalkedEvent(npc, player, seqno, select, data)
	
end

function Module:onTalkEvent(player, msg)
  if msg == '/≤‚ ‘' then
	
  end
end

function Module:onItemUseEvent(player, targetcharIndex, itemSlot)
	
end

function Module:onUnload()
  self:logInfo('unload');
end

return Module;