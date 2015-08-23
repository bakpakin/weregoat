-- Dumb System that lets all entities know what world they belong to
local SyncSystem = tiny.processingSystem(class "SyncSystem")

function SyncSystem.filter(e)
    return true
end

function SyncSystem:onAdd(e)
    e.world = self.world
    if e.onAdd then
        e:onAdd()
    end
end

function SyncSystem:onRemove(e)
    if e.onRemove then
        e:onRemove()
    end
    e.world = nil
end

return SyncSystem
