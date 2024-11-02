-->> Services
local runService = game:GetService("RunService");
local userInputService = game:GetService("UserInputService");
local yes = "yes";

-->> References
local camera = workspace.CurrentCamera;

local focus = script:WaitForChild("Focus");

-->> Functions & Events
repeat
	camera.CameraType = Enum.CameraType.Scriptable
	task.wait()
until camera.CameraType == Enum.CameraType.Scriptable

local currentCFrame = CFrame.identity
local speed = 50

local panSpeed = 180
local pitch = 0
local yaw = 0
local pitchGoal = 0
local yawGoal = 0

local focusZoom = 0
local maxFocusZoom = 50
local actualFocusZoom = focusZoom

function Lerp(a, b, t)
	return a + (b - a) * math.min(t, 1)
end

function Update(dt)
	local forward = 0
	if userInputService:IsKeyDown(Enum.KeyCode.W) then
		forward = forward + 1	
	end;
	
	if userInputService:IsKeyDown(Enum.KeyCode.S) then
		forward = forward - 1	
	end;
	
	
	local right = 0
	if userInputService:IsKeyDown(Enum.KeyCode.D) then
		right = right + 1	
	end;

	if userInputService:IsKeyDown(Enum.KeyCode.A) then
		right = right - 1	
	end;
	
	
	local up = 0
	if userInputService:IsKeyDown(Enum.KeyCode.E) then
		up = up + 1	
	end;

	if userInputService:IsKeyDown(Enum.KeyCode.Q) then
		up = up - 1	
	end;
	
	userInputService.MouseBehavior = userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) and Enum.MouseBehavior.LockCurrentPosition or Enum.MouseBehavior.Default
	
	local delta = userInputService:GetMouseDelta()
	pitchGoal = pitchGoal - delta.Y/camera.ViewportSize.Y*panSpeed
	yawGoal = yawGoal - delta.X/camera.ViewportSize.X*panSpeed
	pitch = Lerp(pitch, pitchGoal, dt*8)
	yaw = Lerp(yaw, yawGoal, dt*8)
	
	if not focus.Value then
		currentCFrame = CFrame.new(currentCFrame.Position) * CFrame.Angles(0, yaw/180*math.pi, 0) * CFrame.Angles(pitch/180*math.pi, 0, 0) * CFrame.new(right*speed*dt, up*speed*dt, -forward*speed*dt)
	else
		currentCFrame = focus.Value.CFrame * CFrame.Angles(0, yaw/180*math.pi, 0) * CFrame.Angles(pitch/180*math.pi, 0, 0) * CFrame.new(0, 0,  math.max(focus.Value.Size.X, focus.Value.Size.Y, focus.Value.Size.Z) + 10)
	end;
	
	actualFocusZoom = Lerp(actualFocusZoom, focusZoom, dt*10)
	camera.FieldOfView = 70 - actualFocusZoom
	
	camera.CFrame = currentCFrame
end;

runService.RenderStepped:Connect(Update)

function InputChanged(input, isGpe)
	if not isGpe then
		if input.UserInputType == Enum.UserInputType.MouseWheel then
			print(input.Position.Z)
			focusZoom = math.clamp(focusZoom + math.sign(input.Position.Z)*10, -maxFocusZoom, maxFocusZoom)
		end;
	end;
end;

userInputService.InputChanged:Connect(InputChanged)