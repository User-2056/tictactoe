local RunService = game:GetService("RunService")

-- Build the door model
local model = Instance.new("Model")
model.Name = "SpinningDoor"
model.Parent = workspace

local function makePart(name, size, position, color, material)
	local part = Instance.new("Part")
	part.Name = name
	part.Size = size
	part.CFrame = CFrame.new(position)
	part.Anchored = true
	part.BrickColor = BrickColor.new(color)
	part.Material = material or Enum.Material.Wood
	part.Parent = model
	return part
end

-- Frame (reddish brown wood)
makePart("FrameLeft",  Vector3.new(0.5, 7.5, 0.5), Vector3.new(0,   3.75, 0), "Reddish brown")
makePart("FrameRight", Vector3.new(0.5, 7.5, 0.5), Vector3.new(4.5, 3.75, 0), "Reddish brown")
makePart("FrameTop",   Vector3.new(5.5, 0.5, 0.5), Vector3.new(2.25, 7.75, 0), "Reddish brown")

-- Door panel (medium brown, hinges on left side)
local door = makePart("DoorPanel", Vector3.new(4, 7, 0.2), Vector3.new(2.25, 3.75, 0), "Medium brown")

-- Hinge is at the left edge of the door (right edge of left frame post)
local hingePos = Vector3.new(0.25, 3.75, 0)
local doorHalfWidth = 2  -- half of 4-stud door width

local angle = 0

RunService.Heartbeat:Connect(function(dt)
	angle = angle + math.rad(60) * dt  -- 60 degrees per second
	door.CFrame = CFrame.new(hingePos)
		* CFrame.Angles(0, angle, 0)
		* CFrame.new(doorHalfWidth, 0, 0)
end)
