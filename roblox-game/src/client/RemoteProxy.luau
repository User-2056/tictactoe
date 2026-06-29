--!strict
-- RemoteProxy.luau
-- Single access point for all RemoteEvents on the client.
-- Caches WaitForChild results so no module blocks independently.

local RemoteProxy = {}

local folder: Folder
local cache: { [string]: RemoteEvent } = {}

function RemoteProxy.init(remoteFolder: Folder)
    folder = remoteFolder
end

local function get(name: string): RemoteEvent
    if not cache[name] then
        cache[name] = folder:WaitForChild(name) :: RemoteEvent
    end
    return cache[name]
end

function RemoteProxy.fire(eventName: string, ...: any)
    get(eventName):FireServer(...)
end

function RemoteProxy.connect(eventName: string, callback: (...any) -> ())
    return get(eventName).OnClientEvent:Connect(callback)
end

return RemoteProxy
