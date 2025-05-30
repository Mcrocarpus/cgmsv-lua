---±¦ÏäÄ£¿é
---@class ItemBoxModule: ModuleType
local ItemBoxModule = ModuleBase:createModule('itembox')

--- ¼ÓÔØÄ£¿é¹³×Ó
function ItemBoxModule:onLoad()
  self:logInfo('load')
  self:regCallback('ItemBoxGenerateEvent', function(mapType, floor, boxId, adm)
    local n = NLG.Rand(1, 100);
    -- 30% ºÚ±¦Ïä£¬30%°×±¦Ïä£¬ 40%ÆÕÍ¨±¦Ïä
    if n > 70 then
      --self:logDebug('ItemBoxGenerateEvent', mapType, floor, boxId, 18003, adm);
      return { 18003, adm }
    end
    if n > 40 then
      --self:logDebug('ItemBoxGenerateEvent', mapType, floor, boxId, 18004, adm);
      return { 18004, adm }
    end
    --self:logDebug('ItemBoxGenerateEvent', mapType, floor, boxId, 18002, adm);
    return { 18002, adm };
  end)
end

--- Ð¶ÔØÄ£¿é¹³×Ó
function ItemBoxModule:onUnload()
  self:logInfo('unload')
end

return ItemBoxModule;
