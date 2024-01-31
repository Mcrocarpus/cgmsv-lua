---@class CharStatusExtend:ModuleBase
local CharStatusExtend = ModuleBase:createModule('charStatusExtend')

local Allow = {
  ['' .. CONST.CHAR_���Ѫ] = 1,
  ['' .. CONST.CHAR_���ħ] = 1,
  ['' .. CONST.CHAR_������] = 1,
  ['' .. CONST.Char_������] = 1,
  ['' .. CONST.Char_����] = 1,
  ['' .. CONST.CHAR_����] = 1,
  ['' .. CONST.CHAR_�ظ�] = 1,
};

function CharStatusExtend:onLoad()
  self:logInfo('load');
  self:regCallback('AfterCalcCharaStatusEvent', Func.bind(self.onStatusUpdate, self));
end

function CharStatusExtend:addCharStatus(charIndex, t, val)
  if (Allow[t .. ''] ~= 1) then
    return false;
  end
  Char.SetTempData(charIndex, 'CSE:Enable', 1);
  Char.SetTempData(charIndex, "CSE:" .. t, tonumber(val));
  return true;
end

function CharStatusExtend:clearCharStatus(charIndex)
  Char.SetTempData(charIndex, 'CSE:Enable', nil);
  for i, v in pairs(Allow) do
    Char.SetTempData(charIndex, 'CSE:' .. i, nil);
  end
end

function CharStatusExtend:onStatusUpdate(charIndex)
  if (Char.GetTempData(charIndex, "CSE:Enable") == 1) then
    local fullFp = Char.GetData(charIndex, CONST.CHAR_���ħ) == Char.GetData(charIndex, CONST.CHAR_ħ);
    local t = { CONST.CHAR_������, CONST.Char_������, CONST.Char_����, CONST.CHAR_����, CONST.CHAR_�ظ� };
    for i, v in ipairs(t) do
      local vx = tonumber(Char.GetTempData(charIndex, "CSE:" .. v)) or 0;
      if (vx ~= 0 and vx ~= nil) then
        Char.SetData(charIndex, v, Char.GetData(charIndex, v) + vx);
      end
    end
    local t2 = { { CONST.CHAR_���Ѫ, CONST.CHAR_Ѫ }, { CONST.CHAR_���ħ, CONST.CHAR_ħ } }
    for i, v in ipairs(t2) do
      local vx = tonumber(Char.GetTempData(charIndex, "CSE:" .. v[1])) or 0;
      if (vx ~= 0 and vx ~= nil) then
        local full = Char.GetData(charIndex, v[1]) == Char.GetData(charIndex, v[2]);
        local val = Char.GetData(charIndex, v[1]) + vx;
        Char.SetData(charIndex, v[1], val);
        if full then
          Char.GetData(charIndex, v[2], val);
        end
      end
    end
  end
end

function CharStatusExtend:onUnload()
  self:logInfo('unload');
end
