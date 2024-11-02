local orbits = {}

coroutine.wrap(function()
	local runService = game:GetService("RunService");
	local currentTime = 0
	while true do
		local dt = runService.RenderStepped:Wait()
		currentTime += dt
		for id, orbit in next, orbits do
			orbit.Angle = (currentTime*orbit.OrbitVelocity*360/(2*math.pi*orbit.OrbitRadius)) % 360
			local amplitude = -(orbit.Orbited.Size.X/2 + orbit.Orbiter.Size.X/2 + orbit.OrbitRadius)
			local angleRadians = orbit.Angle/180*math.pi
			local minorAxis = 1
			local majorAxis = 1 + orbit.Eccentricity
			local fociiShift = math.sqrt(majorAxis^2 - minorAxis^2)
			orbit.Orbiter.Position = orbit.Orbited.Position + Vector3.new(math.cos(angleRadians)*amplitude*majorAxis - fociiShift*amplitude, 0, math.sin(angleRadians)*amplitude)
			local torqueVector = orbit.Torque*currentTime/180*math.pi
			orbit.Orbiter.CFrame = CFrame.new(orbit.Orbiter.Position) * CFrame.Angles(torqueVector.X, torqueVector.Y, torqueVector.Z)
		end;
	end;	
end)()

local currentId = 0

local orbit = {}
orbit.__index = orbit

function orbit.new(orbited: Instance, orbiter: Instance, orbitRadius: Studs, orbitVelocity: Number, eccentricity: Number, torque: Vector3)
	local self = {}
	self.Orbited = orbited
	self.Orbiter = orbiter
	self.OrbitRadius = orbitRadius
	self.OrbitVelocity = orbitVelocity
	self.Eccentricity = eccentricity
	self.Angle = 0
	self.Torque = torque
	self.Id = currentId
	currentId = currentId + 1
	return setmetatable(self, orbit)
end;

function orbit:Update(orbited: Instance, orbiter: Instance, orbitRadius: Studs, orbitVelocity: Number, eccentricity: Number, torque: Vecto3)
	self.Orbited = orbited
	self.Orbiter = orbiter
	self.OrbitRadius = orbitRadius
	self.OrbitVelocity = orbitVelocity
	self.Eccentricity = eccentricity
	self.Angle = 0
	self.Torque = torque
end;

function orbit:Start()
	orbits[self.Id] = self
end;

function orbit:Stop()
	orbits[self.Id] = nil
end;

return orbit