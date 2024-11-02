-->> Services
local tweenService = game:GetService("TweenService");

-->> References
local toolsModule = require(script.Parent.Parent:WaitForChild("ToolsModule"));

local tools = script.Parent;
local toolsContainer = tools:WaitForChild("ToolsContainer");

-->> Functions & Events
local createPlanet = toolsContainer:WaitForChild("CreatePlanet");
createPlanet:WaitForChild("Events")
createPlanet.Events.MouseEnter:Connect(function()
	tweenService:Create(createPlanet, TweenInfo.new(0.1, Enum.EasingStyle.Exponential), {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	}):Play()
	
	tweenService:Create(createPlanet:WaitForChild("BottomText"), TweenInfo.new(0.1, Enum.EasingStyle.Exponential), {
		TextColor3 = Color3.fromRGB(8, 8, 8)
	}):Play()
	
	tweenService:Create(createPlanet:WaitForChild("TopText"), TweenInfo.new(0.1, Enum.EasingStyle.Exponential), {
		TextColor3 = Color3.fromRGB(8, 8, 8)
	}):Play()
	
	tweenService:Create(createPlanet:WaitForChild("Icon"), TweenInfo.new(0.1, Enum.EasingStyle.Exponential), {
		ImageColor3 = Color3.fromRGB(8, 8, 8)
	}):Play()
end)

createPlanet.Events.MouseLeave:Connect(function()
	tweenService:Create(createPlanet, TweenInfo.new(0.1, Enum.EasingStyle.Exponential), {
		BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	}):Play()
	
	tweenService:Create(createPlanet:WaitForChild("BottomText"), TweenInfo.new(0.1, Enum.EasingStyle.Exponential), {
		TextColor3 = Color3.fromRGB(255, 255, 255)
	}):Play()

	tweenService:Create(createPlanet:WaitForChild("TopText"), TweenInfo.new(0.1, Enum.EasingStyle.Exponential), {
		TextColor3 = Color3.fromRGB(255, 255, 255)
	}):Play()

	tweenService:Create(createPlanet:WaitForChild("Icon"), TweenInfo.new(0.1, Enum.EasingStyle.Exponential), {
		ImageColor3 = Color3.fromRGB(255, 255, 255)
	}):Play()
end)

createPlanet.Events.MouseButton1Down:Connect(function()
	toolsModule:CreatePlanet()
	tweenService:Create(createPlanet, TweenInfo.new(0.1, Enum.EasingStyle.Exponential), {
		BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	}):Play()
	
	tweenService:Create(createPlanet:WaitForChild("BottomText"), TweenInfo.new(0.1, Enum.EasingStyle.Exponential), {
		TextColor3 = Color3.fromRGB(255, 255, 255)
	}):Play()

	tweenService:Create(createPlanet:WaitForChild("TopText"), TweenInfo.new(0.1, Enum.EasingStyle.Exponential), {
		TextColor3 = Color3.fromRGB(255, 255, 255)
	}):Play()

	tweenService:Create(createPlanet:WaitForChild("Icon"), TweenInfo.new(0.1, Enum.EasingStyle.Exponential), {
		ImageColor3 = Color3.fromRGB(255, 255, 255)
	}):Play()
end)

local editPlanets = toolsContainer:WaitForChild("EditPlanets");
editPlanets:WaitForChild("Events")
editPlanets.Events.MouseEnter:Connect(function()
	tweenService:Create(editPlanets, TweenInfo.new(0.1, Enum.EasingStyle.Exponential), {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	}):Play()
	
	tweenService:Create(editPlanets:WaitForChild("BottomText"), TweenInfo.new(0.1, Enum.EasingStyle.Exponential), {
		TextColor3 = Color3.fromRGB(8, 8, 8)
	}):Play()

	tweenService:Create(editPlanets:WaitForChild("TopText"), TweenInfo.new(0.1, Enum.EasingStyle.Exponential), {
		TextColor3 = Color3.fromRGB(8, 8, 8)
	}):Play()

	tweenService:Create(editPlanets:WaitForChild("Icon"), TweenInfo.new(0.1, Enum.EasingStyle.Exponential), {
		ImageColor3 = Color3.fromRGB(8, 8, 8)
	}):Play()
end)

editPlanets.Events.MouseLeave:Connect(function()
	tweenService:Create(editPlanets, TweenInfo.new(0.1, Enum.EasingStyle.Exponential), {
		BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	}):Play()

	tweenService:Create(editPlanets:WaitForChild("BottomText"), TweenInfo.new(0.1, Enum.EasingStyle.Exponential), {
		TextColor3 = Color3.fromRGB(255, 255, 255)
	}):Play()

	tweenService:Create(editPlanets:WaitForChild("TopText"), TweenInfo.new(0.1, Enum.EasingStyle.Exponential), {
		TextColor3 = Color3.fromRGB(255, 255, 255)
	}):Play()

	tweenService:Create(editPlanets:WaitForChild("Icon"), TweenInfo.new(0.1, Enum.EasingStyle.Exponential), {
		ImageColor3 = Color3.fromRGB(255, 255, 255)
	}):Play()
end)

editPlanets.Events.MouseButton1Down:Connect(function()
	toolsModule:EditPlanets()
	tweenService:Create(editPlanets, TweenInfo.new(0.1, Enum.EasingStyle.Exponential), {
		BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	}):Play()

	tweenService:Create(editPlanets:WaitForChild("BottomText"), TweenInfo.new(0.1, Enum.EasingStyle.Exponential), {
		TextColor3 = Color3.fromRGB(255, 255, 255)
	}):Play()

	tweenService:Create(editPlanets:WaitForChild("TopText"), TweenInfo.new(0.1, Enum.EasingStyle.Exponential), {
		TextColor3 = Color3.fromRGB(255, 255, 255)
	}):Play()

	tweenService:Create(editPlanets:WaitForChild("Icon"), TweenInfo.new(0.1, Enum.EasingStyle.Exponential), {
		ImageColor3 = Color3.fromRGB(255, 255, 255)
	}):Play()
end)