-->> Services
local playerGui = script.Parent;

-->> References
local cameraScript = playerGui:WaitForChild("CameraScript");
local focus = cameraScript:WaitForChild("Focus");

local toolsScreenGui = playerGui:WaitForChild("Tools"); 

local planetMesh = script:WaitForChild("PlanetMesh");
local planetFrame = script:WaitForChild("PlanetFrame");

local galaxy = workspace:WaitForChild("Galaxy");

local orbitModule = require(playerGui:WaitForChild("OrbitModule"));

-->> Constants
local materials = {}
for index, material in next, Enum.Material:GetEnumItems() do
	materials[material.Name:lower()] = material
end;


local EMPTY_BOX_COLOR = Color3.fromRGB(80, 50, 0);
local CORRECT_BOX_COLOR = Color3.fromRGB(0, 85, 0);
local MISTAKE_BOX_COLOR = Color3.fromRGB(170, 0, 0);

-->> Module
local tools = {}

local createPlanet = playerGui:WaitForChild("CreatePlanet");
function tools:CreatePlanet()
	if not game:IsLoaded() then
		game.Loaded:Wait()
	end
	
	local connections = {}
	toolsScreenGui.Enabled = false
	createPlanet.Enabled = true
	local newPlanet = planetMesh:Clone()
	newPlanet.Anchored = true
	newPlanet.Size = Vector3.one*10
	newPlanet.Position = Vector3.zero
	newPlanet.Parent = galaxy
	focus.Value = newPlanet
	local newPlanetTrail = newPlanet:WaitForChild("Trail");
	local highlight = Instance.new("Highlight")
	highlight.FillTransparency = 1
	highlight.Parent = newPlanet
	local customizations = createPlanet.Container.Customizations;
		
	-->> Style
	local planetName = "";
	local planetColorR = 0;
	local planetColorG = 0;
	local planetColorB = 0;
	local function UpdatePlanetName()
		planetName = customizations.NameCustomization.TextBoxContainer.TextBox.Text;
		if planetName == "" or galaxy:FindFirstChild(planetName) then
			newPlanet.Name = "UNNAMED"
			customizations.NameCustomization.TextBoxContainer.BackgroundColor3 = MISTAKE_BOX_COLOR
		else
			customizations.NameCustomization.TextBoxContainer.BackgroundColor3 = CORRECT_BOX_COLOR
			newPlanet.Name = planetName
		end;
	end;
	
	table.insert(connections, customizations.NameCustomization.TextBoxContainer.TextBox:GetPropertyChangedSignal("Text"):Connect(UpdatePlanetName))
	UpdatePlanetName()
	
	local function UpdatePlanetRadius()
		local planetRadius = customizations.RadiusCustomization.TextBoxContainer.TextBox.Text;
		if tonumber(planetRadius) then
			customizations.RadiusCustomization.TextBoxContainer.BackgroundColor3 = CORRECT_BOX_COLOR
			newPlanet.Size = Vector3.one*tonumber(planetRadius)
			newPlanetTrail:Clear()
		else
			customizations.RadiusCustomization.TextBoxContainer.BackgroundColor3 = MISTAKE_BOX_COLOR
		end;
	end;

	table.insert(connections, customizations.RadiusCustomization.TextBoxContainer.TextBox:GetPropertyChangedSignal("Text"):Connect(UpdatePlanetRadius))
	UpdatePlanetRadius()
	
	local function UpdatePlanetMaterial()
		local planetMaterial = customizations.MaterialCustomization.TextBoxContainer.TextBox.Text:lower()
		if planetMaterial ~= "" and materials[planetMaterial] then
			customizations.MaterialCustomization.TextBoxContainer.BackgroundColor3 = CORRECT_BOX_COLOR
			newPlanet.Material = materials[planetMaterial]
		else
			customizations.MaterialCustomization.TextBoxContainer.BackgroundColor3 = planetMaterial == "" and EMPTY_BOX_COLOR or MISTAKE_BOX_COLOR
			newPlanet.Material = Enum.Material.SmoothPlastic
		end;
	end;

	table.insert(connections, customizations.MaterialCustomization.TextBoxContainer.TextBox:GetPropertyChangedSignal("Text"):Connect(UpdatePlanetMaterial))
	UpdatePlanetMaterial()
	
	local surfaceTextures = script.SurfaceTextures;
	local currentSurfaceTexture = nil;
	local function UpdatePlanetSurfaceTexture()
		local planetSurfaceTexture = customizations.SurfaceTextureCustomization.TextBoxContainer.TextBox.Text;
		if surfaceTextures:FindFirstChild(planetSurfaceTexture) then
			customizations.SurfaceTextureCustomization.TextBoxContainer.BackgroundColor3 = CORRECT_BOX_COLOR
			if currentSurfaceTexture then
				currentSurfaceTexture:Destroy()	
			end;
			
			currentSurfaceTexture = surfaceTextures:FindFirstChild(planetSurfaceTexture):Clone()
			currentSurfaceTexture.Parent = newPlanet
		else
			customizations.SurfaceTextureCustomization.TextBoxContainer.BackgroundColor3 = planetSurfaceTexture == "" and EMPTY_BOX_COLOR or MISTAKE_BOX_COLOR
			if currentSurfaceTexture then
				currentSurfaceTexture:Destroy()
			end;
		end;
	end;

	table.insert(connections, customizations.SurfaceTextureCustomization.TextBoxContainer.TextBox:GetPropertyChangedSignal("Text"):Connect(UpdatePlanetSurfaceTexture))
	UpdatePlanetSurfaceTexture()
	
	local function UpdatePlanetColor()
		if tonumber(planetColorR) and tonumber(planetColorR) >= 0 and tonumber(planetColorR) <= 100 then
			if tonumber(planetColorG) and tonumber(planetColorG) >= 0 and tonumber(planetColorG) <= 100 then
				if tonumber(planetColorB) and tonumber(planetColorB) >= 0 and tonumber(planetColorB) <= 100 then
					local rgbColor = Color3.fromRGB(255*(planetColorR/100), 255*(planetColorG/100), 255*(planetColorB/100))
					newPlanet.Color = rgbColor
					customizations.ColorCustomization.ColorDisplay.BackgroundColor3 = rgbColor
					customizations.ColorCustomization.ColorDisplay.Visible = true
					return
				end;
			end;
		end;
		
		newPlanet.Color = Color3.fromRGB(255, 255, 255)
		customizations.ColorCustomization.ColorDisplay.Visible = false
	end;
	
	local function PlanetColorRChanged()
		planetColorR = customizations.ColorCustomization.RContainer.TextBox.Text
		if planetColorR == "" then
			customizations.ColorCustomization.RContainer.BackgroundColor3 = EMPTY_BOX_COLOR
		else
			if tonumber(planetColorR) >= 0 and tonumber(planetColorR) <= 100 then
				customizations.ColorCustomization.RContainer.BackgroundColor3 = CORRECT_BOX_COLOR
			else
				customizations.ColorCustomization.RContainer.BackgroundColor3 = MISTAKE_BOX_COLOR
			end;
		end;

		UpdatePlanetColor()
	end;
	
	table.insert(connections, customizations.ColorCustomization.RContainer.TextBox:GetPropertyChangedSignal("Text"):Connect(PlanetColorRChanged))
	
	local function PlanetColorGChanged()
		planetColorG = customizations.ColorCustomization.GContainer.TextBox.Text
		if planetColorG == "" then
			customizations.ColorCustomization.GContainer.BackgroundColor3 = EMPTY_BOX_COLOR
		else
			if tonumber(planetColorG) >= 0 and tonumber(planetColorG) <= 100 then
				customizations.ColorCustomization.GContainer.BackgroundColor3 = CORRECT_BOX_COLOR
			else
				customizations.ColorCustomization.GContainer.BackgroundColor3 = MISTAKE_BOX_COLOR
			end;
		end;

		UpdatePlanetColor()
	end;
	
	table.insert(connections, customizations.ColorCustomization.GContainer.TextBox:GetPropertyChangedSignal("Text"):Connect(PlanetColorGChanged))
	
	local function PlanetColorBChanged()
		planetColorB = customizations.ColorCustomization.BContainer.TextBox.Text
		if planetColorB == "" then
			customizations.ColorCustomization.BContainer.BackgroundColor3 = EMPTY_BOX_COLOR
		else
			if tonumber(planetColorB) >= 0 and tonumber(planetColorB) <= 100 then
				customizations.ColorCustomization.BContainer.BackgroundColor3 = CORRECT_BOX_COLOR
			else
				customizations.ColorCustomization.BContainer.BackgroundColor3 = MISTAKE_BOX_COLOR
			end;
		end;

		UpdatePlanetColor()
	end;
	
	table.insert(connections, customizations.ColorCustomization.BContainer.TextBox:GetPropertyChangedSignal("Text"):Connect(PlanetColorBChanged))
		
	PlanetColorRChanged()
	PlanetColorGChanged()
	PlanetColorBChanged()
	
	-->> Orbit

	local newOrbit = nil;
	local orbitPlanet = customizations.OrbitPlanetCustomization.TextBoxContainer.TextBox.Text;
	local orbitRadius = customizations.OrbitRadiusCustomization.TextBoxContainer.TextBox.Text;
	local orbitVelocity = customizations.OrbitVelocityCustomization.TextBoxContainer.TextBox.Text;
	local orbitEccentricity = customizations.EccentricityCustomization.TextBoxContainer.TextBox.Text;
	local orbitPitch = tonumber(customizations.TorqueCustomization.PitchContainer.TextBox.Text) or 0;
	local orbitYaw = tonumber(customizations.TorqueCustomization.YawContainer.TextBox.Text) or 0;
	local orbitRoll = tonumber(customizations.TorqueCustomization.RollContainer.TextBox.Text) or 0;
	local function UpdateOrbit()
		local orbitPlanetValue = orbitPlanet
		local orbitRadiusValue = tonumber(orbitRadius)
		local orbitVelocityValue = tonumber(orbitVelocity)
		local orbitEccentricityValue = tonumber(orbitEccentricity) or 0
		local orbitPitchValue = tonumber(orbitPitch) or 0
		local orbitYawValue = tonumber(orbitYaw) or 0
		local orbitRollValue = tonumber(orbitRoll) or 0
		
		if galaxy:FindFirstChild(orbitPlanetValue) and orbitRadiusValue and orbitVelocityValue and (orbitEccentricityValue and orbitEccentricityValue >= 0 and orbitEccentricityValue <= 1) and orbitPitchValue and orbitYawValue and orbitRollValue then
			if newOrbit then
				newOrbit:Update(galaxy:FindFirstChild(orbitPlanetValue), newPlanet, orbitRadiusValue, orbitVelocityValue, orbitEccentricityValue, Vector3.new(orbitPitchValue, orbitYawValue, orbitRollValue))
			else
				newOrbit = orbitModule.new(galaxy:FindFirstChild(orbitPlanet), newPlanet, orbitRadiusValue, orbitVelocityValue, orbitEccentricityValue, Vector3.new(orbitPitchValue, orbitYawValue, orbitRollValue))
			end;
			
			newOrbit:Start()
			newPlanetTrail:Clear()
		else
			if newOrbit then
				newOrbit:Stop()
				newPlanetTrail:Clear()
			end;
		end;
	end;

	local function UpdateOrbitPlanet()
		orbitPlanet = customizations.OrbitPlanetCustomization.TextBoxContainer.TextBox.Text;
		if galaxy:FindFirstChild(orbitPlanet) and not (orbitPlanet == planetName) then
			customizations.OrbitPlanetCustomization.TextBoxContainer.BackgroundColor3 = CORRECT_BOX_COLOR
		else
			customizations.OrbitPlanetCustomization.TextBoxContainer.BackgroundColor3 = MISTAKE_BOX_COLOR
		end;
		
		UpdateOrbit()
	end;
	
	table.insert(connections, customizations.OrbitPlanetCustomization.TextBoxContainer.TextBox:GetPropertyChangedSignal("Text"):Connect(UpdateOrbitPlanet))
	UpdateOrbitPlanet()
	
	local function UpdateOrbitRadius()
		orbitRadius = customizations.OrbitRadiusCustomization.TextBoxContainer.TextBox.Text;
		if tonumber(orbitRadius) then
			customizations.OrbitRadiusCustomization.TextBoxContainer.BackgroundColor3 = CORRECT_BOX_COLOR
		else
			customizations.OrbitRadiusCustomization.TextBoxContainer.BackgroundColor3 = MISTAKE_BOX_COLOR
		end;
		
		UpdateOrbit()
	end;

	table.insert(connections, customizations.OrbitRadiusCustomization.TextBoxContainer.TextBox:GetPropertyChangedSignal("Text"):Connect(UpdateOrbitRadius))
	UpdateOrbitRadius()
	
	local function UpdateOrbitVelocity()
		orbitVelocity = customizations.OrbitVelocityCustomization.TextBoxContainer.TextBox.Text;
		if tonumber(orbitVelocity) then
			customizations.OrbitVelocityCustomization.TextBoxContainer.BackgroundColor3 = CORRECT_BOX_COLOR
		else
			customizations.OrbitVelocityCustomization.TextBoxContainer.BackgroundColor3 = MISTAKE_BOX_COLOR
		end;
		
		UpdateOrbit()
	end;

	table.insert(connections, customizations.OrbitVelocityCustomization.TextBoxContainer.TextBox:GetPropertyChangedSignal("Text"):Connect(UpdateOrbitVelocity))
	UpdateOrbitVelocity()
	
	local function UpdateOrbitEccentricity()
		orbitEccentricity = customizations.EccentricityCustomization.TextBoxContainer.TextBox.Text;
		if orbitEccentricity == "" then
			customizations.EccentricityCustomization.TextBoxContainer.BackgroundColor3 = EMPTY_BOX_COLOR
		elseif tonumber(orbitEccentricity) and tonumber(orbitEccentricity) >= 0 and tonumber(orbitEccentricity) <= 1 then
			customizations.EccentricityCustomization.TextBoxContainer.BackgroundColor3 = CORRECT_BOX_COLOR
		else
			customizations.EccentricityCustomization.TextBoxContainer.BackgroundColor3 = MISTAKE_BOX_COLOR
		end;
		
		UpdateOrbit()
	end;

	table.insert(connections, customizations.EccentricityCustomization.TextBoxContainer.TextBox:GetPropertyChangedSignal("Text"):Connect(UpdateOrbitEccentricity))
	UpdateOrbitEccentricity()
	
	local function UpdateOrbitPitch()
		orbitPitch = customizations.TorqueCustomization.PitchContainer.TextBox.Text
		if orbitPitch == "" then
			customizations.TorqueCustomization.PitchContainer.BackgroundColor3 = EMPTY_BOX_COLOR
		elseif tonumber(orbitPitch) then
			customizations.TorqueCustomization.PitchContainer.BackgroundColor3 = CORRECT_BOX_COLOR
		else
			customizations.TorqueCustomization.PitchContainer.BackgroundColor3 = MISTAKE_BOX_COLOR
		end;
		
		UpdateOrbit()
	end;

	table.insert(connections, customizations.TorqueCustomization.PitchContainer.TextBox:GetPropertyChangedSignal("Text"):Connect(UpdateOrbitPitch))
	UpdateOrbitPitch()
	
	local function UpdateOrbitYaw()
		orbitYaw = customizations.TorqueCustomization.YawContainer.TextBox.Text
		if orbitYaw == "" then
			customizations.TorqueCustomization.YawContainer.BackgroundColor3 = EMPTY_BOX_COLOR
		elseif tonumber(orbitYaw) then
			customizations.TorqueCustomization.YawContainer.BackgroundColor3 = CORRECT_BOX_COLOR
		else
			customizations.TorqueCustomization.YawContainer.BackgroundColor3 = MISTAKE_BOX_COLOR
		end;
		
		UpdateOrbit()
	end;

	table.insert(connections, customizations.TorqueCustomization.YawContainer.TextBox:GetPropertyChangedSignal("Text"):Connect(UpdateOrbitYaw))
	UpdateOrbitYaw()
	
	local function UpdateOrbitRoll()
		orbitRoll = customizations.OrbitPlanetCustomization.TextBoxContainer.TextBox.Text
		if orbitRoll == "" then
			customizations.TorqueCustomization.RollContainer.BackgroundColor3 = EMPTY_BOX_COLOR
		elseif tonumber(orbitRoll) then
			customizations.TorqueCustomization.RollContainer.BackgroundColor3 = CORRECT_BOX_COLOR
		else
			customizations.TorqueCustomization.RollContainer.BackgroundColor3 = MISTAKE_BOX_COLOR
		end;
		
		UpdateOrbit()
	end;

	table.insert(connections, customizations.TorqueCustomization.RollContainer.TextBox:GetPropertyChangedSignal("Text"):Connect(UpdateOrbitRoll))
	UpdateOrbitRoll()
	
	UpdateOrbit()
	

	table.insert(connections, createPlanet.Container.Cancel.MouseButton1Down:Connect(function()
		for _, connection in next, connections do
			connection:Disconnect()
		end;
		
		focus.Value = nil
		createPlanet.Enabled = false
		toolsScreenGui.Enabled= true
		newPlanet:Destroy()
		if newOrbit then
			newOrbit:Stop()
			newOrbit = nil
		end;
	end))
	
	table.insert(connections, createPlanet.Container.Save.MouseButton1Down:Connect(function()
		for _, connection in next, connections do
			connection:Disconnect()
		end;
		
		focus.Value = nil
		createPlanet.Enabled = false
		toolsScreenGui.Enabled= true
		highlight:Destroy()
	end))
end;

local editPlanets = playerGui:WaitForChild("EditPlanets");
function tools:EditPlanets()
	if not game:IsLoaded() then
		game.Loaded:Wait()
	end

	local connections = {}
	toolsScreenGui.Enabled = false
	editPlanets.Enabled = true
	
	for _, instance in next, editPlanets.Container.Planets:GetChildren() do
		if instance:IsA("Frame") then
			instance:Destroy()
		end;
	end;
	
	local planetsCount = 0
	local function EnableNoPlanetsText()
		editPlanets.Container.Planets.NoPlanetsText.Visible = not (planetsCount > 0)
	end;
	
	EnableNoPlanetsText()
	
	local planetsInstances = {}
	for _, instance in next, galaxy:GetChildren() do
		planetsCount += 1
		EnableNoPlanetsText()
		local newPlanetFrame = planetFrame:Clone()
		newPlanetFrame:WaitForChild("PlanetNameText").Text = instance.Name
		newPlanetFrame.Parent = editPlanets.Container.Planets
		
		table.insert(connections, newPlanetFrame.SpectateButton.MouseButton1Click:Connect(function()
			if focus.Value == instance then
				focus.Value = nil
				newPlanetFrame.SpectateButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
			else
				focus.Value = instance
				newPlanetFrame.SpectateButton.ImageColor3 = Color3.fromRGB(8, 8, 8)
			end;
		end))
		
		table.insert(connections, newPlanetFrame.DeleteButton.MouseButton1Click:Connect(function()
			newPlanetFrame:Destroy()
			instance:Destroy()
			planetsCount -= 1
			EnableNoPlanetsText()
		end))
		
		table.insert(planetsInstances, instance)
	end;
	
	table.insert(connections, editPlanets.Container.Back.MouseButton1Down:Connect(function()
		for _, connection in next, connections do
			connection:Disconnect()
		end;
		
		editPlanets.Enabled = false
		toolsScreenGui.Enabled = true
	end))
end;

return tools