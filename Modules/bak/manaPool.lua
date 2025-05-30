---@class ManaPool: ModuleType
local ManaPool = ModuleBase:createModule('manaPool')
local itemList = {
  { name = 'Ѫ�ز��䣨1000LP��', image = 27243, price = 1500, desc = '����Ѫ��ʹ����1000��', count = 1, maxCount = 999, value = 1000, type = 'lp' },
  { name = 'Ѫ�ز��䣨10000LP��', image = 27243, price = 14500, desc = '����Ѫ��ʹ����10000��', count = 1, maxCount = 999, value = 1000, type = 'lp' },
  { name = 'Ѫ�ز��䣨100000LP��', image = 27243, price = 140000, desc = '����Ѫ��ʹ����100000��', count = 1, maxCount = 999, value = 100000, type = 'lp' },
  { name = 'ħ�ز��䣨1000FP��', image = 26206, price = 2500, desc = '����ħ��ʹ����1000��', count = 1, maxCount = 999, value = 1000, type = 'fp' },
  { name = 'ħ�ز��䣨10000FP��', image = 26206, price = 24500, desc = '����ħ��ʹ����10000��', count = 1, maxCount = 999, value = 10000, type = 'fp' },
  { name = 'ħ�ز��䣨100000FP��', image = 26206, price = 240000, desc = '����ħ��ʹ����100000��', count = 1, maxCount = 999, value = 100000, type = 'fp' },
}

--- ����ģ�鹳��
function ManaPool:onLoad()
  self:logInfo('load')
  local npc = self:NPC_createNormal('Ѫħ����վ', 101024, { map = 1000, x = 225, y = 81, direction = 4, mapType = 0 })
  self:NPC_regTalkedEvent(npc, Func.bind(self.onSellerTalked, self))
  self:NPC_regWindowTalkedEvent(npc, Func.bind(self.onSellerSelected, self));
  self:regCallback('ResetCharaBattleStateEvent', Func.bind(self.onBattleReset, self))
end

function ManaPool:onBattleReset(charIndex)
  if Char.IsDummy(charIndex) then
    return
  end
  local lpPool = tonumber(Char.GetExtData(charIndex, 'LpPool')) or 0;
  local fpPool = tonumber(Char.GetExtData(charIndex, 'FpPool')) or 0;
  if lpPool <= 0 and fpPool <= 0 then
    return
  end
  local lp = Char.GetData(charIndex, CONST.CHAR_Ѫ)  --[[@as number]]
  local maxLp = Char.GetData(charIndex, CONST.CHAR_���Ѫ)  --[[@as number]]
  local fp = Char.GetData(charIndex, CONST.CHAR_ħ)  --[[@as number]]
  local maxFp = Char.GetData(charIndex, CONST.CHAR_���ħ) --[[@as number]]
  if lpPool > 0 and lp < maxLp then
    lpPool = lpPool - maxLp + lp;
    if lpPool < 0 then
      maxLp = maxLp + lpPool;
      lpPool = 0;
    end
    NLG.SystemMessage(charIndex, '[Ѫħ��] �ѻָ�: ' .. (maxLp - lp) .. 'LP, Ѫ��ʣ��: ' .. lpPool);
  else
    maxLp = lp;
  end
  if fpPool > 0 and fp < maxFp then
    fpPool = fpPool - maxFp + fp;
    if fpPool < 0 then
      maxFp = maxFp + fpPool;
      fpPool = 0;
    end
    NLG.SystemMessage(charIndex, '[Ѫħ��] �ѻָ�: ' .. (maxFp - fp) .. 'FP, ħ��ʣ��: ' .. fpPool);
  else
    maxFp = fp;
  end
  Char.SetData(charIndex, CONST.CHAR_Ѫ, maxLp)
  Char.SetData(charIndex, CONST.CHAR_ħ, maxFp)
  NLG.UpChar(charIndex);
  local petIndex = Char.GetData(charIndex, CONST.CHAR_ս��);
  if petIndex >= 0 then
    petIndex = Char.GetPet(charIndex, petIndex);
    lp = Char.GetData(petIndex, CONST.CHAR_Ѫ)  --[[@as number]]
    maxLp = Char.GetData(petIndex, CONST.CHAR_���Ѫ)  --[[@as number]]
    fp = Char.GetData(petIndex, CONST.CHAR_ħ)  --[[@as number]]
    maxFp = Char.GetData(petIndex, CONST.CHAR_���ħ)  --[[@as number]]
    if lpPool > 0 and lp < maxLp then
      lpPool = lpPool - maxLp + lp;
      if lpPool < 0 then
        maxLp = maxLp + lpPool;
        lpPool = 0;
      end
      NLG.SystemMessage(charIndex, '[Ѫħ��] �ѻָ�����: ' .. (maxLp - lp) .. 'LP, Ѫ��ʣ��: ' .. lpPool);
    else
      maxLp = lp;
    end
    if fpPool > 0 and fp < maxFp then
      fpPool = fpPool - maxFp + fp;
      if fpPool < 0 then
        maxFp = maxFp + fpPool;
        fpPool = 0;
      end
      NLG.SystemMessage(charIndex, '[Ѫħ��] �ѻָ�����: ' .. (maxFp - fp) .. 'FP, ħ��ʣ��: ' .. fpPool);
    else
      maxFp = fp;
    end
    Char.SetData(petIndex, CONST.CHAR_Ѫ, maxLp)
    Char.SetData(petIndex, CONST.CHAR_ħ, maxFp)
    NLG.UpChar(petIndex);
  end
  Char.SetExtData(charIndex, 'LpPool', lpPool);
  Char.SetExtData(charIndex, 'FpPool', fpPool);
end

function ManaPool:onSellerTalked(npc, player)
  if NLG.CanTalk(npc, player) then
    NLG.ShowWindowTalked(player, npc, CONST.����_�̵���, CONST.BUTTON_��, 0,
      self:NPC_buildBuyWindowData(101024, 'Ѫħ����վ', '��ֵѪħ��', '��Ǯ����', '��������', itemList))
  end
end

function ManaPool:onSellerSelected(npc, player, seqNo, select, data)
  local items = string.split(data, '|');
  local lpPool = tonumber(Char.GetExtData(player, 'LpPool')) or 0;
  local fpPool = tonumber(Char.GetExtData(player, 'FpPool')) or 0;
  local gold = Char.GetData(player, CONST.CHAR_���)
  local totalGold = 0;
  local totalLp = 0;
  local totalFp = 0;
  for i = 1, #items / 2 do
    local c = itemList[items[(i - 1) * 2 + 1] + 1]
    if c then
      local count = (tonumber(items[(i - 1) * 2 + 2]) or 0);
      if c.type == 'lp' then
        totalLp = totalLp + c.value * count;
      else
        totalFp = totalFp + c.value * count;
      end
      totalGold = totalGold + c.price * count;
    end
  end
  if gold < totalGold then
    NLG.SystemMessage(player, '��Ҳ���');
    return
  end
  Char.AddGold(player, -totalGold);
  Char.SetExtData(player, 'LpPool', lpPool + totalLp);
  Char.SetExtData(player, 'FpPool', fpPool + totalFp);
  NLG.UpChar(player);
  if totalLp > 0 then
    NLG.SystemMessage(player, '[Ѫħ��] ����Ѫ��: ' .. totalLp .. ', ��: ' .. (lpPool + totalLp));
  end
  if totalFp > 0 then
    NLG.SystemMessage(player, '[Ѫħ��] ����ħ��: ' .. totalFp .. ', ��: ' .. (fpPool + totalFp));
  end
end

--- ж��ģ�鹳��
function ManaPool:onUnload()
  self:logInfo('unload')
end

return ManaPool;
