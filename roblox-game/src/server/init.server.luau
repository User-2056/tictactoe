local TweenService = game:GetService("TweenService")

local OPEN_TIME  = 2    -- seconds to swing open
local CLOSE_TIME = 0.3  -- seconds to snap shut
local PAUSE_OPEN = 0.8  -- pause at fully open
local PAUSE_SHUT = 1.5  -- pause at fully closed
local OPEN_ANGLE = 90   -- degrees

-- Wait for door parts to exist in the workspace
local doorModel = workspace:WaitForChild("Door")
local doorPanel = doorModel:WaitForChild("DoorPanel")

-- Store closed position; hinge is along the left edge of the panel
local closedCFrame = doorPanel.CFrame
local halfWidth    = doorPanel.Size.X / 2
local hingeCFrame  = closedCFrame * CFrame.new(-halfWidth, 0, 0)
local openCFrame   = hingeCFrame * CFrame.Angles(0, math.rad(-OPEN_ANGLE), 0) * CFrame.new(halfWidth, 0, 0)

local function animateDoor()
	-- Slowly swing open
	local openTween = TweenService:Create(
		doorPanel,
		TweenInfo.new(OPEN_TIME, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
		{ CFrame = openCFrame }
	)
	openTween:Play()
	openTween.Completed:Wait()

	task.wait(PAUSE_OPEN)

	-- Snap shut fast
	local closeTween = TweenService:Create(
		doorPanel,
		TweenInfo.new(CLOSE_TIME, Enum.EasingStyle.Back, Enum.EasingDirection.In),
		{ CFrame = closedCFrame }
	)
	closeTween:Play()
	closeTween.Completed:Wait()

	task.wait(PAUSE_SHUT)
end

while true do
	animateDoor()
end
