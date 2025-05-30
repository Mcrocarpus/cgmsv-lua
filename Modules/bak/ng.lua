---模块类
---@class ngModule: ModuleType
local ngModule = ModuleBase:createModule('ng')

-- 普通玩家命令
local commandsNormal = {}

local function addFrame(charIndex)
  --Char.DischargeParty(charIndex);
  Char.SetData(charIndex, CONST.CHAR_声望, 200000);
end

local function identity(player)
  local Count = 0
  for itemSlot = 8, 27 do
    local ItemIndex = Char.GetItemIndex(player, itemSlot)
    if ItemIndex > 0 then
      local money = Char.GetData(player, CONST.CHAR_金币);
      local itemLv = Item.GetData(ItemIndex, CONST.道具_等级);
      local price = itemLv * 200;
      if Item.GetData(ItemIndex, CONST.道具_已鉴定) == 0 and money >= (itemLv * 200) then
        Count = Count + 1
        Char.SetData(player, CONST.CHAR_金币, money - price);
        Item.SetData(ItemIndex, CONST.道具_已鉴定, 1)
        NLG.SystemMessage(player, "[系统] 您鉴定的道具等级为" .. itemLv .. "级。扣除魔币" .. price .. "G");
        NLG.SystemMessage(player, "[系统] 你身上的 " .. Item.GetData(ItemIndex, CONST.道具_鉴前名) .. "已鉴定为 " .. Item.GetData(ItemIndex, CONST.道具_名字))
        Item.UpItem(player, itemSlot);
        NLG.UpChar(player);
        return ;
      end
    end
  end
  if Count == 0 then
    NLG.SystemMessage(player, "[系统] 你身上没有需要鉴定的物品【或你的钱不足以鉴定此道具】");
    return ;
  end
  return
end

local function repairEquipment(player)
  local Count = 0
  for ItemSlot = 8, 8 do
    local ItemIndex = Char.GetItemIndex(player, ItemSlot)
    local money = Char.GetData(player, CONST.CHAR_金币);
    local itemLv = Item.GetData(ItemIndex, CONST.道具_等级);
    local itemName = Item.GetData(ItemIndex, CONST.道具_名字);
    local itemDur = Item.GetData(ItemIndex, CONST.道具_耐久);
    local itemMaxDur = Item.GetData(ItemIndex, CONST.道具_最大耐久);
    local repairedDur = itemMaxDur - itemDur
    --local decMaxDur = repairedDur * 1
    local price = repairedDur * 10
    local itemType = Item.GetData(ItemIndex, CONST.道具_类型);
    if money > price and itemMaxDur > itemDur and itemType >= 0 and itemType <= 14 then
      Count = Count + 1
      Char.SetData(player, CONST.CHAR_金币, money - price);
      --Item.SetData(ItemIndex, CONST.道具_耐久, itemDur + xhnj);
      --Item.UpItem(player, ItemSlot);
      -- local djnj1 = Item.GetData(ItemIndex,CONST.道具_耐久);
      -- local djzdnj1 = Item.GetData(ItemIndex,CONST.道具_最大耐久);
      Item.SetData(ItemIndex, CONST.道具_耐久, itemMaxDur);
      Item.SetData(ItemIndex, CONST.道具_最大耐久, itemMaxDur);
      NLG.SystemMessage(player, "[系统] 您修理的装备【" .. itemName .. "】恢复了【" .. repairedDur .. "】耐久。扣除魔币【" .. price .. "G】");
      Item.UpItem(player, ItemSlot);
      NLG.UpChar(player);
      return
    end
  end
  if Count == 0 then
    NLG.SystemMessage(player, "[系统] 你道具栏第一格没有要恢复耐久的装备或者您的修理魔币不足。");
    return
  end
  return
end

local function spriteRepair(player)
  local ZH = Char.GetData(player, CONST.CHAR_掉魂);
  local money = Char.GetData(player, CONST.CHAR_金币);
  local LV = Char.GetData(player, CONST.CHAR_等级);
  local ZHMB = ZH * 200;
  local ZHMBKC = ZHMB * LV
  if ZH <= 0 then
    NLG.SystemMessage(player, "你没有掉魂。");
  end
  if money >= ZHMBKC and ZH > 0 then
    Char.SetData(player, CONST.CHAR_金币, money - ZHMBKC);
    Char.SetData(player, CONST.CHAR_掉魂, 0);
    Char.FeverStop(player);
    NLG.UpChar(player);
    NLG.SystemMessage(player, "招魂完成。招魂数量为【" .. ZH .. "】费用为【" .. ZHMBKC .. "】魔币。");
  end
  if money < ZHMBKC then
    NLG.SystemMessage(player, "连钱都没有你还招魂，一边尿尿玩泥巴去吧。【招魂价格计算 掉魂*1000*等级】");
  end
end

local function healthRepair(player)
  local i = Char.GetData(player, CONST.CHAR_受伤);
  local money = Char.GetData(player, CONST.CHAR_金币);
  if (Char.GetData(player, CONST.CHAR_受伤) < 1) then
    NLG.SystemMessage(player, "您未受伤。");
    return ;
  end
  if (money >= 200) and (Char.GetData(player, CONST.CHAR_受伤) > 0 and Char.GetData(player, CONST.CHAR_受伤) < 26) then
    Char.SetData(player, CONST.CHAR_受伤, 0);
    Char.SetData(player, CONST.CHAR_金币, money - 200);
    NLG.UpdateParty(player);
    NLG.UpChar(player);
    NLG.SystemMessage(player, "恭喜你治疗完毕。");
    NLG.SystemMessage(player, "扣除200魔币。");
    return ;
  end
  if (money >= 400) and (Char.GetData(player, CONST.CHAR_受伤) > 24 and Char.GetData(player, CONST.CHAR_受伤) < 51) then
    Char.SetData(player, CONST.CHAR_受伤, 0);
    Char.SetData(player, CONST.CHAR_金币, money - 400);
    NLG.UpdateParty(player);
    NLG.UpChar(player);
    NLG.SystemMessage(player, "恭喜你治疗完毕。");
    NLG.SystemMessage(player, "扣除400魔币。");
    return ;
  end
  if (money >= 800) and (Char.GetData(player, CONST.CHAR_受伤) > 49 and Char.GetData(player, CONST.CHAR_受伤) < 76) then
    Char.SetData(player, CONST.CHAR_受伤, 0);
    Char.SetData(player, CONST.CHAR_金币, money - 800);
    NLG.UpdateParty(player);
    NLG.UpChar(player);
    NLG.SystemMessage(player, "恭喜你治疗完毕。");
    NLG.SystemMessage(player, "扣除800魔币。");
    return ;
  end
  if (money >= 1000) and (Char.GetData(player, CONST.CHAR_受伤) > 74 and Char.GetData(player, CONST.CHAR_受伤) < 101) then
    Char.SetData(player, CONST.CHAR_受伤, 0);
    Char.SetData(player, CONST.CHAR_金币, money - 1000);
    NLG.UpdateParty(player);
    NLG.UpChar(player);
    NLG.SystemMessage(player, "恭喜你治疗完毕。");
    NLG.SystemMessage(player, "扣除1000魔币。");
    return ;
  else
    NLG.SystemMessage(player, "对不起！您的魔币不足，治疗价格为【白伤200】【黄伤400】【紫伤800】【红伤1000】！");
    return ;
  end
  return 0
end

function commandsNormal.where(charIndex, args)
  local target = charIndex;
  if #args == 1 then
    target = tonumber(args[1])
  end
  NLG.TalkToCli(charIndex, -1, target ..
    ' 地图:' .. tostring(Char.GetData(target, CONST.CHAR_地图)) .. '/' .. tostring(Char.GetData(target, CONST.CHAR_地图类型)) ..
    ', X:' .. tostring(Char.GetData(target, CONST.CHAR_X)) ..
    ', Y:' .. tostring(Char.GetData(target, CONST.CHAR_Y)) ..
    ', 方向:' .. tostring(Char.GetData(target, CONST.CHAR_方向))
  )
end

function commandsNormal.char(charIndex, args)
  if args[1] == 'healthRepair' then
    return healthRepair(charIndex)
  elseif args[1] == 'spriteRepair' then
    return spriteRepair(charIndex)
  elseif args[1] == 'addFrame' then
    return addFrame(charIndex)
  end
end

-- function commandsNormal.rank4(charIndex)
--   if Char.GetData(charIndex, CONST.CHAR_职阶) == 3 and Char.GetData(charIndex, CONST.CHAR_等级) >= 100 then
--     Char.SetData(charIndex, CONST.CHAR_职阶, 4);
--     Char.SetData(charIndex, CONST.CHAR_职业, Char.GetData(charIndex, CONST.CHAR_职业) + 1);
--     NLG.UpChar(charIndex);
--   end
-- end

function commandsNormal.item(charIndex, args)
  if args[1] == 'sort' then
    NLG.SortItem(charIndex)
    NLG.UpChar(charIndex);
  elseif args[1] == 'identity' then
    return identity(charIndex)
  elseif args[1] == 'repair' then
    return repairEquipment(charIndex)
  end
end

--function commandsNormal.changeSex(charIndex, args)
--  print( Char.GetData(charIndex, CONST.CHAR_形象), Char.GetData(charIndex, CONST.CHAR_原形), Char.GetData(charIndex, CONST.CHAR_原始图档))
--  --if args[1] then
--  --  Char.SetData(charIndex, CONST.CHAR_形象, args[1]);
--  --else
--  --  Char.SetData(charIndex, CONST.CHAR_形象, Char.GetData(charIndex, CONST.CHAR_原形));
--  --end
--end

function commandsNormal.daka(charIndex)
  Char.SetData(charIndex, CONST.CHAR_卡时, 99 * 3600);
  if Char.IsFeverTime(charIndex) == 1 then
    Char.FeverStop(charIndex)
  else
    Char.FeverStart(charIndex)
  end
  NLG.UpChar(charIndex)
end

function commandsNormal.redoDp(charIndex)
  local total = (Char.GetData(charIndex, CONST.CHAR_等级) - 1) * 4 + 30;
  local s = { CONST.CHAR_体力, CONST.CHAR_力量, CONST.CHAR_强度, CONST.CHAR_速度, CONST.CHAR_魔法 }
  for i, v in pairs(s) do
    Char.SetData(charIndex, v, 0);
  end
  Char.SetData(charIndex, CONST.CHAR_升级点, total);
  NLG.UpChar(charIndex)
end

function commandsNormal.encount(charIndex)
  Battle.Encount(charIndex, charIndex);
end

function commandsNormal.goHome(charIndex)
  --Char.DischargeParty(charIndex);
  Char.Warp(charIndex, 0, 1000, 236, 88);
end

local function getPetBp(player, args)
  local hasPet = false;
  for i = args[2] or 0, args[2] or 4 do
    local pet = Char.GetPet(player, i);
    if (pet >= 0) then
      hasPet = true;
      local arr_rank1 = Pet.GetArtRank(pet, CONST.PET_体成);
      local arr_rank11 = Pet.FullArtRank(pet, CONST.PET_体成);
      local arr_rank2 = Pet.GetArtRank(pet, CONST.PET_力成);
      local arr_rank21 = Pet.FullArtRank(pet, CONST.PET_力成);
      local arr_rank3 = Pet.GetArtRank(pet, CONST.PET_强成);
      local arr_rank31 = Pet.FullArtRank(pet, CONST.PET_强成);
      local arr_rank4 = Pet.GetArtRank(pet, CONST.PET_敏成);
      local arr_rank41 = Pet.FullArtRank(pet, CONST.PET_敏成);
      local arr_rank5 = Pet.GetArtRank(pet, CONST.PET_魔成);
      local arr_rank51 = Pet.FullArtRank(pet, CONST.PET_魔成);
      local a1 = (arr_rank1 - arr_rank11);
      local a2 = (arr_rank2 - arr_rank21);
      local a3 = (arr_rank3 - arr_rank31);
      local a4 = (arr_rank4 - arr_rank41);
      local a5 = (arr_rank5 - arr_rank51);
      local a6 = a1 + a2 + a3 + a4 + a5;
      local a61 = arr_rank1 + arr_rank2 + arr_rank3 + arr_rank4 + arr_rank5;
      NLG.SystemMessage(player, Char.GetData(pet, CONST.CHAR_名字) .. "总:" .. a61 .. "（" .. a6 .. ')')
      NLG.SystemMessage(player, "体:" .. arr_rank1 .. "(" .. a1 .. ") 力:" .. arr_rank2 .. "(" .. a2 .. ") 强:" .. arr_rank3 .. "(" .. a3 .. ") 敏:" ..
        arr_rank4 .. "(" .. a4 .. ") 魔:" .. arr_rank5 .. "(" .. a5 .. ")");
    end
  end
  if not args[2] then
    if hasPet then
      NLG.SystemMessage(player, "-----------------------------------");
    else
      NLG.SystemMessage(player, "没有宠物");
    end
  end
end

local function petRebirth(player, args)
  local pet = Char.GetPet(player, tonumber(args[2]));
  if pet >= 0 then
    local s = { CONST.PET_体成, CONST.PET_力成, CONST.PET_强成, CONST.PET_敏成, CONST.PET_魔成 };
    for i, v in pairs(s) do
      local r = Pet.FullArtRank(pet, v);
      Pet.SetArtRank(pet, v, r - math.random(0, 4))
    end
    Pet.ReBirth(player, pet);
    local arr_rank1 = Pet.GetArtRank(pet, CONST.PET_体成);
    local arr_rank11 = Pet.FullArtRank(pet, CONST.PET_体成);
    local arr_rank2 = Pet.GetArtRank(pet, CONST.PET_力成);
    local arr_rank21 = Pet.FullArtRank(pet, CONST.PET_力成);
    local arr_rank3 = Pet.GetArtRank(pet, CONST.PET_强成);
    local arr_rank31 = Pet.FullArtRank(pet, CONST.PET_强成);
    local arr_rank4 = Pet.GetArtRank(pet, CONST.PET_敏成);
    local arr_rank41 = Pet.FullArtRank(pet, CONST.PET_敏成);
    local arr_rank5 = Pet.GetArtRank(pet, CONST.PET_魔成);
    local arr_rank51 = Pet.FullArtRank(pet, CONST.PET_魔成);
    local a1 = (arr_rank1 - arr_rank11);
    local a2 = (arr_rank2 - arr_rank21);
    local a3 = (arr_rank3 - arr_rank31);
    local a4 = (arr_rank4 - arr_rank41);
    local a5 = (arr_rank5 - arr_rank51);
    local a6 = a1 + a2 + a3 + a4 + a5;
    local a61 = arr_rank1 + arr_rank2 + arr_rank3 + arr_rank4 + arr_rank5;
    NLG.SystemMessage(player, Char.GetData(pet, CONST.CHAR_名字) .. "总:" .. a61 .. "（" .. a6 .. ')')
    NLG.SystemMessage(player, "体:" .. arr_rank1 .. "(" .. a1 .. ") 力:" .. arr_rank2 .. "(" .. a2 .. ") 强:" .. arr_rank3 .. "(" .. a3 .. ") 敏:" ..
      arr_rank4 .. "(" .. a4 .. ") 魔:" .. arr_rank5 .. "(" .. a5 .. ")");
  end
end

function commandsNormal.pet(player, args)
  if args[1] == 'bp' then
    return getPetBp(player, args);
  elseif string.lower(args[1] or '') == 'rebirth' then
    return petRebirth(player, args);
  end
end

function commandsNormal.bank(player, args)
  NLG.OpenBank(player, player);
end

function ngModule:handleTalkEvent(charIndex, msg)
  self:logDebug('ng', charIndex, msg);
  local command = msg:match('^/([%w]+)')
  if commandsNormal[command] then
    local arg = msg:match('^/[%w]+ +(.+)$')
    arg = arg and string.split(arg, ' ') or {}
    commandsNormal[command](charIndex, arg);
    return 0
  end
  return 1;
end

--- 加载模块钩子
function ngModule:onLoad()
  self:logInfo('load')
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self))
end

--- 卸载模块钩子
function ngModule:onUnload()
  self:logInfo('unload')
end

return ngModule;
