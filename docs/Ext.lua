---@meta _

---����Moduleģ��
function loadModule(string) end

---������ͨLUA
function useModule(string) end

---��ȡģ��
---@param name string ģ��ID
---@return ModuleBase|any
function getModule(name) end

---����ģ��
---@param name string ģ��ID
function reloadModule(name) end

---ж��ģ��
---@param name string ģ��ID
function unloadModule(name) end

--- ע��ȫ���¼�
---@param eventName string
---@param fn function|OrderedCallback
---@param moduleName string
---@param extraSign string
---@return number ȫ��ע��Index
function regGlobalEvent(eventName, fn, moduleName, extraSign) end

--- ע��ȫ���¼�
---@param eventName string
---@param fn function|OrderedCallback
---@return number ȫ��ע��Index
function regGlobalEvent(eventName, fn) end

--- �Ƴ�ȫ���¼�
---@param eventName string
---@param fnIndex number ȫ��ע��Index
---@param moduleName string|nil
---@param extraSign string|nil
function removeGlobalEvent(eventName, fnIndex, moduleName, extraSign) end

--- �Ƴ�ȫ���¼�
---@param eventName string
---@param fnIndex number ȫ��ע��Index
function removeGlobalEvent(eventName, fnIndex) end

---@class OrderedCallback
---@field order number
---@field fn function
---@field type string
---@field index number

---@return OrderedCallback|function
---@param fn function
---@param order number Խ��Խ����ִ��
function OrderedCallback(fn, order) end

---������ת����string��ʽ����ʶ��ת�������
---@param s string|number
---@return string|nil @string��ʽ���� ʧ�ܷ���'null'
function SQL.sqlValue(s) end

---ִ��ָ����Mysql��ѯ��
---@param sql  string Ҫִ�е�Mysql��ѯ��䡣
---@return string[][] @table[a][b]aΪ������bΪ����
function SQL.querySQL(sql, returnNil) end

---������Migration
---@param type string ���ͱ�ʶ
---@param version number �汾��
---@param name string ����
---@return Migration @Migration����
function newMigration(type, version, name) end

---@class Migration
Migration = {}

---���Migration����
---@param sql string sql
---@param paramList (number|string)[] �����б�
---@param opt {ignoreCheck:boolean,checkFn:fun(res):boolean} opt
function Migration:AddStep(sql, paramList, opt) end

---ִ��
---@param useTrans boolean �Ƿ�������
---@return number @�ɹ�����1 ʧ�ܷ���0
function Migration:Execute(useTrans) end
