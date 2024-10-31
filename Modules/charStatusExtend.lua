---@class CharStatusExtend : ModuleType
local CharStatusExtend = ModuleBase:createModule('charStatusExtend')

local Allow = {
  [CONST.CHAR_���Ѫ] = CONST.CHAR_���Ѫ,
  [CONST.CHAR_���ħ] = CONST.CHAR_���ħ,
  [CONST.CHAR_������] = CONST.CHAR_������,
  [CONST.CHAR_������] = CONST.CHAR_������,
  [CONST.CHAR_����] = CONST.CHAR_����,
  [CONST.CHAR_����] = CONST.CHAR_����,
  [CONST.CHAR_�ظ�] = CONST.CHAR_�ظ�,
  [CONST.CHAR_ʵ�ʷ���] = CONST.CHAR_ʵ�ʷ���,
  [CONST.CHAR_ʵ�ʱ�ɱ] = CONST.CHAR_ʵ�ʱ�ɱ,
  [CONST.CHAR_ʵ������] = CONST.CHAR_ʵ������,
  [CONST.CHAR_ʵ������] = CONST.CHAR_ʵ������,
  [CONST.CHAR_ʵ�ʿ���] = CONST.CHAR_ʵ�ʿ���,
  [CONST.CHAR_ʵ�ʿ���] = CONST.CHAR_ʵ�ʿ���,
  [CONST.CHAR_ʵ�ʿ���] = CONST.CHAR_ʵ�ʿ���,
  [CONST.CHAR_ʵ�ʿ�˯] = CONST.CHAR_ʵ�ʿ�˯,
  [CONST.CHAR_ʵ�ʿ�ʯ] = CONST.CHAR_ʵ�ʿ�ʯ,
  [CONST.CHAR_ʵ�ʿ���] = CONST.CHAR_ʵ�ʿ���,
  [CONST.CHAR_����] = CONST.CHAR_ʵ�ʷ���,
  [CONST.CHAR_��ɱ] = CONST.CHAR_ʵ�ʱ�ɱ,
  [CONST.CHAR_����] = CONST.CHAR_ʵ������,
  [CONST.CHAR_����] = CONST.CHAR_ʵ������,
  [CONST.CHAR_����] = CONST.CHAR_ʵ�ʿ���,
  [CONST.CHAR_����] = CONST.CHAR_ʵ�ʿ���,
  [CONST.CHAR_����] = CONST.CHAR_ʵ�ʿ���,
  [CONST.CHAR_��˯] = CONST.CHAR_ʵ�ʿ�˯,
  [CONST.CHAR_��ʯ] = CONST.CHAR_ʵ�ʿ�ʯ,
  [CONST.CHAR_����] = CONST.CHAR_ʵ�ʿ���,
};

function CharStatusExtend:onLoad()
  self:logInfo('load');
  self:regCallback('AfterCalcCharaStatusEvent', Func.bind(self.onStatusUpdate, self));
end

---������ʱ����
---@param charIndex number
---@param t number ��ӦCONST.����_*
---@param val number ����ֵ
---@return boolean �Ƿ�ɹ�
function CharStatusExtend:addCharStatus(charIndex, t, val)
  t = Allow[t];
  if (t == nil) then
    return false;
  end
  Char.SetTempData(charIndex, 'CSE:Enable', 1);
  Char.SetTempData(charIndex, "CSE:" .. t, tonumber(val));
  if (t == CONST.CHAR_���Ѫ or t == CONST.CHAR_���ħ) then
    Char.SetTempData(charIndex, "CSE:L" .. t, Char.GetData(charIndex, t));
  end
  return true;
end

---�Ƴ���ʱ����
---@param charIndex number
function CharStatusExtend:clearCharStatus(charIndex)
  Char.SetTempData(charIndex, 'CSE:Enable', nil);
  for i, v in pairs(Allow) do
    Char.SetTempData(charIndex, 'CSE:' .. v, nil);
    if (tonumber(v) == CONST.CHAR_���Ѫ or tonumber(v) == CONST.CHAR_���ħ) then
      Char.SetTempData(charIndex, "CSE:L" .. v, nil);
    end
  end
end

function CharStatusExtend:onStatusUpdate(charIndex)
  if (Char.GetTempData(charIndex, "CSE:Enable") == 1) then
    local t = { CONST.CHAR_������, CONST.CHAR_������, CONST.CHAR_����, CONST.CHAR_����, CONST.CHAR_�ظ�,
      CONST.CHAR_ʵ�ʷ���, CONST.CHAR_ʵ�ʱ�ɱ, CONST.CHAR_ʵ������, CONST.CHAR_ʵ������, CONST.CHAR_ʵ�ʿ���, CONST.CHAR_ʵ�ʿ���,
      CONST.CHAR_ʵ�ʿ���, CONST.CHAR_ʵ�ʿ�˯, CONST.CHAR_ʵ�ʿ�ʯ, CONST.CHAR_ʵ�ʿ��� };
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
        local vxL = tonumber(Char.GetTempData(charIndex, "CSE:L" .. v[1])) or -1;
        Char.SetTempData(charIndex, "CSE:L" .. v[1], nil);
        local vo = Char.GetData(charIndex, v[1]);
        local full = vo == Char.GetData(charIndex, v[2]) and vo == vxL;
        Char.SetData(charIndex, v[1], vo + vx);
        if full then
          Char.SetData(charIndex, v[2], vo + vx);
        end
      end
    end
  end
end

function CharStatusExtend:onUnload()
  self:logInfo('unload');
end

return CharStatusExtend;
