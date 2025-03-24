---�ƽ��Թ�ģ��
---@class GoldMazeModule: ModuleType
local GoldMazeModule = ModuleBase:createModule('gold_maze')

local MAX_LEVEL = 99;
local ENCOUNT_RATE = 1.88;
local MIN_SIZE = 40;
local MAX_SIZE = 70;
local BOSS_MAP = CONST.��ͼ����_��ͨ;
local BOSS_FLOOR = 592;
local BOSS_FLOOR_X = 2;
local BOSS_FLOOR_Y = 7;
local ENTRY_MAPID = CONST.��ͼ����_��ͨ;
local ENTRY_FLOOR = 11015;
local ENTRY_X = 53;
local ENTRY_Y = 50;
local ENTRY_NPC = 10000;
local ENTRY_DIR = 0;
local ENTRY_ITEMID = 20212095;
local BOSS = 880048;
local ENEMY = { 880014, 880015, 880016, 880017, 880018 };
local WHITE_LIST = {
    ['�˺�'] = true,
};

function GoldMazeModule:onLoad()
    self:SetLogLevel(5);
    _G.loggerLevel = 5;
    self:logInfo('���ػƽ��Թ�ģ��')
    self.MapList = {} -- �洢�������ɵĵ�ͼfloor
    -- �������NPC
    self:createEntranceNPC()
    -- ע���¼�
    self:regCallback("ItemBoxLootEvent", Func.bind(self.onItemBoxLoot, self))
    self:regCallback("ItemBoxEncountRateEvent", Func.bind(self.onItemBoxEncountRate, self))
    -- self:regCallback("WarpEvent", Func.bind(self.onWarpEvent, self))
    self:regCallback("ItemDropRateEvent", Func.bind(self.ItemDropRateEvent, self));

    -- ������ͼ����ѭ��
    local onEliteWin = self:regCallback(Func.bind(self.onEliteWin, self))
    self.onEliteWinKey = onEliteWin;

    local adminCommands = getModule("adminCommands") ---@type AdminCommands
    if adminCommands then
        adminCommands:regCommand("gold_maze", function(charIndex, args)
            if args[1] == 'encount_rate' then
                ENCOUNT_RATE = tonumber(args[2])
            elseif args[1] == 'max_size' then
                MAX_SIZE = tonumber(args[2])
            elseif args[1] == 'min_size' then
                MIN_SIZE = tonumber(args[2])
            elseif args[1] == 'level' then
                MAX_LEVEL = tonumber(args[2])
            end
        end)
    end
end

function GoldMazeModule:onUnload()
    self:logInfo('unload')
    local adminCommands = getModule("adminCommands") ---@type AdminCommands
    if adminCommands then
        adminCommands:unloadCommand("gold_maze");
    end
    -- NL.DelNpc(self.npc);
    for floor, _ in pairs(self.MapList) do
        self:logDebug("clear up", floor)
        local players = NLG.GetMapPlayer(CONST.��ͼ����_LUAMAP, floor)
        if type(players) == "table" then
            for _, charIndex in pairs(players) do
                Char.Warp(charIndex, ENTRY_MAPID, ENTRY_FLOOR, ENTRY_X, ENTRY_Y);
            end
        end
        -- Map.SetExtData(CONST.��ͼ����_LUAMAP, floor, "GoldMapVar", nil)
        Map.DelLuaMap(floor)
    end
end

function GoldMazeModule:createEntranceNPC()
    local position = {
        x = ENTRY_X,
        y = ENTRY_Y,
        map = ENTRY_FLOOR,
        mapType = ENTRY_MAPID,
        direction = ENTRY_DIR
    }
    local charIndex = self:NPC_createNormal("�ƽ��Թ�����", ENTRY_NPC, position)

    -- ע��Ի��¼�
    self:NPC_regTalkedEvent(charIndex, function(npc, player)
        self:startAdventure(player)
    end)
    self.npc = charIndex;
    local loopFnIndex = self:regCallback(Func.bind(self.onMapCleanLoop, self))
    Char.SetLoopEvent(nil, loopFnIndex, charIndex, 1000) -- ȫ��ѭ��
end

function GoldMazeModule:createMap(level)
    -- �����µ�ͼ
    local w = NLG.Rand(MIN_SIZE, MAX_SIZE)
    local h = NLG.Rand(MIN_SIZE, MAX_SIZE)
    local floor = -1;
    for i = 1, 5 do
        floor = Map.MakeMazeMap(nil, nil,
            w, h,
            "�ƽ��Թ�" .. level .. "��",
            -- 307
            10,
            10,
            10, 20,
            10, 20,
            9682, 100, 0,
            0, 0, 0, 0, 0,
            215
        )
        if floor >= 0 then
            break;
        end
    end
    if floor == -1 then return -1 end
    self:logDebug("create floor", floor)

    local wx, wy = -1, -1
    for i = 1, 100 do
        -- �������͵�
        local tx, ty = Map.GetAvailablePos(CONST.��ͼ����_LUAMAP, floor)
        if tx >= 0 or ty >= 0 then
            self:logDebug("create warp", i, tx, ty);
            if Map.IsWalkable(CONST.��ͼ����_LUAMAP, floor, tx - 2, ty + 2) == 1 or i == 100 then
                wx, wy = tx, ty
                break
            end
            if Map.IsWalkable(CONST.��ͼ����_LUAMAP, floor, tx + 2, ty - 2) == 1 then
                tx, ty = tx + 2, ty - 2;
                wx, wy = tx + 2, ty - 2;
                break
            end
        end
    end

    if wx < 0 or wy < 0 then
        Map.DelLuaMap(floor);
        self:logInfo("create warp failed");
        return -1;
    end

    -- ���õ�ͼ����
    Map.SetExtData(CONST.��ͼ����_LUAMAP, floor, "GoldMapVar", 1)
    self.MapList[floor] = true
    Map.SetImage(CONST.��ͼ����_LUAMAP, floor, wx, wy, nil, 17990)
    Map.SetExtData(CONST.��ͼ����_LUAMAP, floor, "GoldMapVarX", wx)
    Map.SetExtData(CONST.��ͼ����_LUAMAP, floor, "GoldMapVarY", wy)

    -- ������ñ���
    local max = NLG.Rand(0, 5);
    for i = 1, max do
        local type = self:getBoxType()
        local itemIndex = Item.MakeItem(type)
        local x, y = Map.GetAvailablePos(CONST.��ͼ����_LUAMAP, floor)
        Obj.AddItem(CONST.��ͼ����_LUAMAP, floor, x, y, itemIndex)
        self:logDebug("Create Itembox", floor, x, y, itemIndex, type)
    end
    return floor;
end

function GoldMazeModule:startAdventure(leaderIndex)
    -- �������Ƿ�����ս
    local partyMembers = self:getPartyMembers(leaderIndex)

    local whitelist = false;
    for _, member in ipairs(partyMembers) do
        local cdk = Char.GetData(member, CONST.����_CDK);
        if WHITE_LIST[cdk] == true then
            whitelist = true
            break;
        end
    end

    if not whitelist then
        for _, member in ipairs(partyMembers) do
            local lastDate = Char.GetExtData(member, "GoldMapDate") or 0
            if tonumber(lastDate) >= tonumber(os.date("%Y%m%d")) then
                self:logInfo(lastDate, os.date("%Y%m%d"))
                -- Char.SetExtData(member, "GoldMapDate", nil)
                NLG.SystemMessage(member, "�����Ѿ���ս���ƽ��Թ���")
                return
            end
        end
    end

    local floor = self:createMap(1);
    if floor < 0 then
        for _, member in ipairs(partyMembers) do
            NLG.SystemMessage(member, "�����Թ�ʧ��")
        end
        return
    end

    -- �����������
    for _, member in ipairs(partyMembers) do
        Char.SetTempData(member, "GoldMapLevel", 1)
        Char.SetTempData(member, "GoldMapMembers", #partyMembers)
        Char.SetExtData(member, "GoldMapDate", os.date("%Y%m%d"))
        -- �������
        Char.GiveItem(member, ENTRY_ITEMID, 1, true)
    end

    -- �������
    local x, y = Map.GetAvailablePos(CONST.��ͼ����_LUAMAP, floor)
    Char.Warp(partyMembers[1], CONST.��ͼ����_LUAMAP, floor, x, y)
end

function GoldMazeModule:onItemBoxLoot(charIndex, mapId, floor, x, y, boxType)
    if Map.GetExtData(mapId, floor, "GoldMapVar") ~= 1 then return 0 end
    local partyMode = Char.GetData(charIndex, CONST.����_���ģʽ)
    if partyMode == CONST.���ģʽ_�ӳ� or partyMode == CONST.���ģʽ_�� then
        local level = tonumber(Char.GetTempData(charIndex, "GoldMapLevel")) or 1

        local lootType = self:getBoxLootType(boxType)
        if lootType == "encounter" then
            self:startEncounter(charIndex, level, "normal")
        elseif lootType == "elite" then
            self:startEncounter(charIndex, level, "elite")
        elseif lootType == "next" then
            self:nextLevel(charIndex)
        end
        return 1 -- ����Ĭ����Ʒ
    end
    return 0;
end

function GoldMazeModule:onItemBoxEncountRate(charIndex, mapId, floor, X, Y, rate, boxType)
    if Map.GetExtData(mapId, floor, "GoldMapVar") == 1 then
        return 0 -- �ر�Ĭ������
    end
    return rate
end

function GoldMazeModule:onWarpEvent(charIndex)
    local members = self:getPartyMembers(charIndex);
    charIndex = members[1];
    local sMapId, sFloor, sX, sY;
    sMapId = Char.GetData(charIndex, CONST.����_��ͼ����);
    sFloor = Char.GetData(charIndex, CONST.����_��ͼ);
    sX = Char.GetData(charIndex, CONST.����_X);
    sY = Char.GetData(charIndex, CONST.����_Y);
    local mapVar = Map.GetExtData(sMapId, sFloor, "GoldMapVar")
    if mapVar ~= 1 then return false end
    local x = Map.GetExtData(sMapId, sFloor, "GoldMapVarX")
    local y = Map.GetExtData(sMapId, sFloor, "GoldMapVarY")

    if x ~= sX or y ~= sY then
        return false
    end
    local allPresent = self:validateParty(charIndex);

    if allPresent then
        local level = tonumber(Char.GetTempData(charIndex, "GoldMapLevel")) or 1
        if level < MAX_LEVEL then
            self:startNextMap(charIndex)
            return true;
        end
    else
        NLG.SystemMessage(charIndex, "�ȵ�������Ķ��Ѱ�");
        -- Char.Warp(charIndex, sMapId, sFloor, sX, sY);
    end
    return false
end

function GoldMazeModule:onMapCleanLoop()
    for floor, _ in pairs(table.copy(self.MapList)) do
        local players = NLG.GetMapPlayer(CONST.��ͼ����_LUAMAP, floor)
        if type(players) ~= "table" or #players == 0 then
            -- ��ͼ������ɾ��
            self:logDebug("delete", floor)
            Map.SetExtData(CONST.��ͼ����_LUAMAP, floor, "GoldMapVar", nil)
            Map.DelLuaMap(floor)
            self.MapList[floor] = nil
            goto continue
        end

        -- �������ƶ���������
        for _, charIndex in ipairs(players) do
            local currentX = Char.GetData(charIndex, CONST.����_X)
            local currentY = Char.GetData(charIndex, CONST.����_Y)
            local lastX = tonumber(Char.GetTempData(charIndex, "GoldMapLastX")) or currentX
            local lastY = tonumber(Char.GetTempData(charIndex, "GoldMapLastY")) or currentY
            -- ������һ������
            Char.SetTempData(charIndex, "GoldMapLastX", currentX)
            Char.SetTempData(charIndex, "GoldMapLastY", currentY)

            local dx = math.abs(currentX - lastX)
            local dy = math.abs(currentY - lastY)
            local totalDistance = dx + dy

            if totalDistance >= 1 then
                if self:onWarpEvent(players[1]) then
                    goto continue
                end

                local partyMode = Char.GetData(charIndex, CONST.����_���ģʽ)
                if partyMode == CONST.���ģʽ_�ӳ� or partyMode == CONST.���ģʽ_�� then
                    local chance = totalDistance * ENCOUNT_RATE -- ÿ��10%����
                    if NLG.Rand(1, 100) <= chance then
                        self:startEncounter(charIndex, Char.GetTempData(charIndex, "GoldMapLevel"), "normal")
                    end
                end
            end
        end

        ::continue::
    end
end

-- ��������
function GoldMazeModule:getPartyMembers(leaderIndex)
    local members = {}
    local partyMode = Char.GetData(leaderIndex, CONST.����_���ģʽ)
    if partyMode == CONST.���ģʽ_�ӳ� or partyMode == CONST.���ģʽ_��Ա then
        for i = 0, 4 do
            local member = Char.GetPartyMember(leaderIndex, i)
            if member ~= -1 then table.insert(members, member) end
        end
    else
        members = { leaderIndex }
    end
    return members
end

function GoldMazeModule:validateParty(leaderIndex)
    local recordedNum = tonumber(Char.GetTempData(leaderIndex, "GoldMapMembers") or 0)
    local actualNum = #self:getPartyMembers(leaderIndex)
    return recordedNum == actualNum
end

function GoldMazeModule:getBoxType()
    local rand = NLG.Rand(1, 100)
    if rand <= 60 then return 18002 end -- ��ͨ����
    if rand <= 90 then return 18004 end -- �ڱ���
    return 18003                        -- �ױ���
end

function GoldMazeModule:getBoxLootType(boxType)
    local rand = NLG.Rand(1, 100)
    if boxType == 18002 then -- ��ͨ
        if rand <= 80 then return "encounter" end
        if rand <= 95 then return "elite" end
        return "next"
    elseif boxType == 18004 then -- ��
        if rand <= 50 then return "encounter" end
        if rand <= 90 then return "elite" end
        return "next"
    else -- ��
        if rand <= 50 then return "encounter" end
        if rand <= 80 then return "elite" end
        return "next"
    end
end

function GoldMazeModule:startEncounter(charIndex, level, type)
    local partyMembers = self:getPartyMembers(charIndex)
    local hasItem = true
    for _, member in ipairs(partyMembers) do
        if Char.HaveItem(member, ENTRY_ITEMID) < 0 then
            hasItem = false
            break
        end
    end
    local enemies, lvList, avg = {}, {}, {}
    if not hasItem or type == "boss" then
        for i = 1, 10 do
            table.insert(enemies, BOSS)
            table.insert(lvList, 999)
            table.insert(avg, 0)
        end
    else
        if type == "elite" then
            level = math.floor(level + 50);
        end
        local count = NLG.Rand(1, 10)
        for i = 1, count do
            table.insert(enemies, ENEMY[math.random(#ENEMY)])
            table.insert(lvList, level)
            table.insert(avg, 0)
        end
    end

    local battleIndex = Battle.PVE(charIndex, charIndex, nil, enemies, lvList, avg)

    if type == "elite" or type == "��Ӣ" then
        Battle.SetWinEvent(nil, self.onEliteWinKey, battleIndex)
    end
end

function GoldMazeModule:nextLevel(charIndex)
    local currentMapId = Char.GetData(charIndex, CONST.����_��ͼ����)
    local currentFloor = Char.GetData(charIndex, CONST.����_��ͼ)
    if currentMapId == CONST.��ͼ����_LUAMAP and self.MapList[currentFloor] then
        local allPresent = self:validateParty(charIndex);
        if allPresent then
            self:startNextMap(charIndex)
        else
            NLG.SystemMessage(charIndex, "�ȵ�������Ķ��Ѱ�");
        end
    end
end

function GoldMazeModule:startNextMap(leaderIndex)
    local level = tonumber(Char.GetTempData(leaderIndex, "GoldMapLevel")) + 1;
    local newFloor = -1
    for _ = 1, 3 do
        newFloor = self:createMap(level)
        if newFloor >= 0 then
            break
        end
    end
    local partyMembers = self:getPartyMembers(leaderIndex)
    if newFloor < 0 then
        for _, member in ipairs(partyMembers) do
            NLG.SystemMessage(member, "������ͼʧ��");
        end
        return
    end
    local x, y = Map.GetAvailablePos(CONST.��ͼ����_LUAMAP, newFloor)
    for _, member in ipairs(partyMembers) do
        Char.SetTempData(member, "GoldMapLevel", level);
        Char.SetTempData(charIndex, "GoldMapLastX", nil)
        Char.SetTempData(charIndex, "GoldMapLastY", nil)
    end
    if level > MAX_LEVEL then
        Char.Warp(partyMembers[1], BOSS_MAP, BOSS_FLOOR, BOSS_FLOOR_X, BOSS_FLOOR_Y)
    else
        -- self:logDebug("warp to ", CONST.��ͼ����_LUAMAP, newFloor, x, y)
        Char.Warp(partyMembers[1], CONST.��ͼ����_LUAMAP, newFloor, x, y)
    end
end

function GoldMazeModule:onEliteWin(battleIndex, charIndex)
    local add = NLG.Rand(0, 5);
    if add > 0 then
        local level = tonumber(Char.GetTempData(charIndex, "GoldMapLevel") or 1) + add;
        Char.SetTempData(charIndex, "GoldMapLevel", level);
    end

    self:nextLevel(charIndex);
end

function GoldMazeModule:ItemDropRateEvent(battleIndex, enemyIndex, charaIndex, itemId, rate)
    if itemId == 20212093 then
        local lv = Char.GetData(charaIndex, CONST.����_�ȼ�) or 20
        local rate = math.max((lv - 20), 1) * 10000
        -- ����rate��10000��1000000����
        rate = math.min(math.max(rate, 10000), 1000000)
        return rate
    end
end

return GoldMazeModule
