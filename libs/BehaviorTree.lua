BT = {}
_G.BT = BT

BT.Tree = dofile('lua/libs/behavior3lua/behavior3/behavior_tree.lua')
BT.Node = dofile('lua/libs/behavior3lua/behavior3/behavior_node.lua')
BT.Process = dofile('lua/libs/behavior3lua/behavior3/sample_process.lua')

function BT.loadTree(path)
    local file, err = io.open(path, 'r')
    assert(file, err)
    local str = file:read('*a')
    file:close()
    return JSON.decode(str)
end
