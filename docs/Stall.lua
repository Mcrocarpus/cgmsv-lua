---@meta _

---������̯
---@param charIndex number ��̯����index��
---@param name string ��������
---@param desc string ��������
---@param itemPriceList table �������߼۸��
---@param petPriceList table �������߼۸��
function Stall.Start(charIndex, name, desc, itemPriceList, petPriceList) end


---�رհ�̯
---@param charIndex number ��̯����index��
function Stall.End(charIndex) end


---�������
---@param charIndex number ��̯����index��
---@param pos number λ�� 0-19
function Stall.BuyItem(charIndex, pos) end


---�������
---@param charIndex number ��̯����index��
---@param pos number λ�� 0-4
function Stall.BuyPet(charIndex, pos) end


---����������ߵļ۸�
---@param charIndex number ��̯����index��
---@param pos number λ�� 0-19
function Stall.GetItemPrice(charIndex, pos) end


---�����������ļ۸�
---@param charIndex number ��̯����index��
---@param pos number λ�� 0-4
function Stall.GetPetPrice(charIndex, pos) end