---ģ����
---@class TestModule: ModuleType
local TestModule = ModuleBase:createModule('test')

--- ����ģ�鹳��
function TestModule:onLoad()
    _G.__test_i = (_G.__test_i or 0) + 1
    self:logInfo('load', _G.__test_i)
    --self:testTech();
  self:regCallback("VSEnemyCreateEvent", function(...)
    self:logDebug("VSEnemyCreateEvent", ...);
    return {-1,0,-1,0,-1,0,-1,0,-1,0}
  end)
end

function TestModule:testTech()
    local index = Tech.GetTechIndex(60);
    self:logDebug("TECH_Index", index);
    self:logDebug("TECH_Id", CONST.TECH_ID, Tech.GetData(index, CONST.TECH_ID));
    self:logDebug("TECH_NAME", CONST.TECH_NAME, Tech.GetData(index, CONST.TECH_NAME));
end

--- ж��ģ�鹳��
function TestModule:onUnload()
    self:logInfo('unload')
end

return TestModule;
