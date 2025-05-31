---循环管理
local Module = ModuleBase:createModule('loopManager')

--循环函数
local commands = {}
local CD = 1000

function Module:onLoad()
	self:logInfo('load')
	self.npc = self:NPC_createNormal("loopManager", 101024, { map = 777, x = 1, y = 1, direction = 5, mapType = 0 });
	self.LoopEventCallBack = self:regCallback(Func.bind(self.onLoopEvent, self));
	Char.SetLoopEvent(nil, self.LoopEventCallBack, self.npc, CD);
end

function Module:onLoopEvent(charIndex)
	for key, value in pairs(commands) do
		value.time = value.time + CD
		if value.time >= value.delta then
			value.time = value.time - value.delta
			local ok, ret = pcall(value.fn)
			if ok then
				value.count = value.count - 1
				if value.count == 0 then
					commands[key] = nil;
				end
			else
				self:logErrorF("loopManager::%s run failed: %s", key, ret);
				commands[key] = nil;
			end
		end
	end
end

---注册循环函数
---@param key string
---@param fn function 循环函数
---@param count integer 循环次数，小于等于0时无限循环
---@param delta integer 循环间隔
function Module:regCommand(key, fn, count, delta)
	commands[key] = { fn = fn, count = count, delta = delta, time = 0 }
end

---取消注册循环函数
---@param key string
function Module:unRegCommand(key)
	commands[key] = nil;
end

function Module:onUnload()
	self:logInfo('unload');
end

return Module;
