-->> Services
local runService = game:GetService("RunService");
local players = game:GetService("Players");

-->> References
local galaxy = workspace:WaitForChild("Galaxy");
local camera = workspace.CurrentCamera;
local focus = script.Parent.Parent:WaitForChild("CameraScript"):WaitForChild("Focus");
local mouse = players.LocalPlayer:GetMouse();

--[[
local grid = game:GetService("Lighting"):WaitForChild("Grid");
grid.Parent = workspace
]]

local track = script.Parent:WaitForChild("Track");

local trackHighlight = script.Parent:WaitForChild("TrackHighlight");

-->> Functions & Events
if not game:IsLoaded() then
	game.Loaded:Wait()
end;

function Grid(n, t)
	return t*math.floor(n/t)
end;

function Update(dt)
	--[[
	local position = focus.Value and focus.Value.Position or camera.CFrame.Position
	position = Vector3.new(Grid(position.X, 30), 0, Grid(position.Z, 30))
	grid.Position = position
	]]
	
	local maxDotProduct = -math.huge
	local maxPlanet = nil
	for _, planet in next, galaxy:GetChildren() do
		local dirVec = (planet.Position - camera.CFrame.Position).Unit
		local mouseDirVec = (mouse.Hit.Position - camera.CFrame.Position).Unit
		local dot = mouseDirVec:Dot(dirVec)
		if dot >= 0.8 then
			if dot > maxDotProduct then
				maxDotProduct = dot
				maxPlanet = planet
			end;
		end;
	end;
	
	if maxPlanet then
		track.Visible = true
		local position = camera:WorldToViewportPoint(maxPlanet.Position)
		track.Position = UDim2.fromScale(position.X/script.Parent.AbsoluteSize.X, (position.Y - 32)/script.Parent.AbsoluteSize.Y)
		track.PlanetText.Text = maxPlanet.Name
		track.DistanceText.Text = tostring(math.floor((maxPlanet.Position - camera.CFrame.Position).Magnitude)).. "km"
		
		trackHighlight.Adornee = maxPlanet
	else
		track.Visible = false
		trackHighlight.Adornee = nil
	end;
end;

runService.RenderStepped:Connect(Update)