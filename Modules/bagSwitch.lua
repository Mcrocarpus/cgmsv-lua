---�������� for cgmsv 24.9e���ϰ汾
---@class BagSwitch : ModuleType
local BagSwitch = ModuleBase:createModule('bagSwitch');


local MENU = 0;
local BAG_LIST = 1;
local ITEM_MOVE = 1000;

--- ����ģ�鹳��
function BagSwitch:onLoad()
    self:logInfo('load')
    self.dummyNPC = self:NPC_createNormal('DummyNPC', 10000, { x = 0, y = 0, map = 777, mapType = 0, direction = 0 });
    self:regCallback('ProtocolOnRecv', Func.bind(self.onProtoHook, self), 'SWITMM');
    self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self))
    self:NPC_regWindowTalkedEvent(self.dummyNPC, Func.bind(self.onWindowTalked, self));
end

--- ж��ģ�鹳��
function BagSwitch:onUnload()
    self:logInfo('unload')
end

function BagSwitch:handleTalkEvent(charIndex, msg)
    if (string.lower(tostring(msg)) == "/itemswitch") then
        self:OpenMenu(charIndex)
        return 0;
    end
    return 1;
end

function BagSwitch:onProtoHook(fd)
    local charIndex = Protocol.GetCharIndexFromFd(fd);
    self:OpenMenu(charIndex);
    return 1;
end

function BagSwitch:OpenMenu(charIndex)
    local ch = self:Chara(charIndex);
    ch[CONST.����_WindowBuffer2] = 1;
    local menu = self:NPC_buildSelectionText("�������� ", {
        "�л�����",
        "�ƶ���Ʒ"
    })
    NLG.ShowWindowTalked(charIndex, self.dummyNPC,
        CONST.����_ѡ���, CONST.BUTTON_ȷ���ر�,
        0, menu);
end

function BagSwitch:onWindowTalked(npc, player, seqNo, btnClick, line)
    local ch = self:Chara(player);
    line = tonumber(line)
    btnClick = tonumber(btnClick)
    if seqNo == MENU then
        self:onMenu(ch, line, btnClick);
    end
    if seqNo == BAG_LIST then
        self:onSwitchBag(ch, line, btnClick);
    end
end

---@param ch CharaWrapper
---@param selection number
---@param buttonClick number
function BagSwitch:onMenu(ch, selection, buttonClick)
    if selection == 1 then
        ch:ShowWindowTalked(self.dummyNPC,
            self:NPC_buildSelectionText("ѡ�񱳰�", { "1", "2", "3", "4" }),
            {
                button = CONST.BUTTON_�ر�,
                type = CONST.����_ѡ���,
                seqNo = BAG_LIST,
            })
        return
    end
    if selection == 2 then
        ch[CONST.����_WindowBuffer2] = 0;
        self:onMoveItem(ch, 10, -1);
    end
end

---@param ch CharaWrapper
---@param selection number
---@param buttonClick number
function BagSwitch:onSwitchBag(ch, selection, buttonClick)
    if buttonClick == CONST.BUTTON_�ر� or buttonClick == CONST.BUTTON_�� then
        return
    end
    selection = selection - 1;
    if selection < 0 then
        return
    end
    local cur = Char.GetBagPage(ch.charaIndex);
    if cur == selection then
        NLG.SystemMessage(ch.charaIndex, "�����л�����")
        return
    end
    NLG.SystemMessage(ch.charaIndex, "�л�������" .. (selection + 1))
    Char.SwitchBag(ch.charaIndex, selection)
end

---@param ch CharaWrapper
---@param selection number
---@param buttonClick number
function BagSwitch:onMoveItem(ch, selection, buttonClick)
    if buttonClick == CONST.BUTTON_�ر� or buttonClick == CONST.BUTTON_�� then
        return
    end
    selection = selection - 1;
    if selection < 0 then
        return
    end
    
    if selection == 10 then
        local iPage = ch[CONST.����_WindowBuffer2];
        Char.GetItemIndex()
    end
end

return BagSwitch;
