getgenv().SilentAim = {
	Settings = {
		Enabled = true,
		AimPart = "Head",
		Prediction = 0.1365,
		WallCheck = true
	},
	FOV = {
		Enabled = true,
		Size = 100,
		Filled = false,
		Thickness = 1,
		Transparency = 1,
		Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
	}
}
local lp = game:GetService("Players").LocalPlayer
local cc = game:GetService("Workspace").CurrentCamera
local mouse = lp:GetMouse()
getgenv().PredictionBackUp = getgenv().SilentAim.Settings.Prediction
local cc = game:GetService("Workspace").CurrentCamera
local mouse = lp:GetMouse()

local Utility = {
    Invite = "camlock",
    BackupInvite = "VfKf5dvSYX",
    Version = "1.0.0a",
    Method = "UpdateMousePos",
    AllowedPlaceIDs = {
        2788229376, -- Da Hood
        7213786345, -- Da Hood VC
        9825515356, -- Hood Customs
        5602055394, -- Hood Modded
        7951883376, -- Hood Modded VC
        12927359803, -- Dah Aim Trainer
        12867571492, -- KatanaHood
        7242996350, -- Da Hood Aim Trainer
        12884917481, -- Da Hood Aim Trainer VC
        11867820563, -- Dae Hood
        12618586930, -- Dat Hood
    }
}

if game.PlaceId == 2788229376 or game.PlaceId == 7213786345 then -- // Da Hood
    Utility.Method = "UpdateMousePos"
        MainRemote = game:GetService("ReplicatedStorage").MainEvent
elseif game.PlaceId == 5602055394 or game.PlaceId == 7951883376 then -- // Hood Modded
    Utility.Method = "MousePos"
        MainRemote = game:GetService("ReplicatedStorage").Bullets 
elseif game.PlaceId == 12927359803 then -- // Dah Aim Trainer
    Utility.Method = "UpdateMousePos"
        MainRemote = game:GetService("ReplicatedStorage").MainEvent
elseif game.PlaceId == 7242996350 or game.PlaceId == 12884917481 then -- // Da Hood Aim Trainer
    Utility.Method = "UpdateMousePos" 
        MainRemote = game:GetService("ReplicatedStorage").MainEvent
elseif game.PlaceId == 12867571492 then -- // Katana Hood
    Utility.Method = "UpdateMousePos"
        MainRemote = game:GetService("ReplicatedStorage").MainEvent
elseif game.PlaceId == 11867820563 then -- // Dae Hood
    Utility.Method = "UpdateMousePos"
        MainRemote = game:GetService("ReplicatedStorage").MainEvent
elseif game.PlaceId == 12618586930 then -- // Dat Hood
    Utility.Method = "UpdateMousePos"
        MainRemote = game:GetService("ReplicatedStorage").MainEvent
end

WTS = (function(Object)
	local ObjectVector = cc:WorldToScreenPoint(Object.Position)
	return Vector2.new(ObjectVector.X, ObjectVector.Y)
end)

Filter = (function(obj)
	if (obj:IsA('BasePart')) then
		return true
	end
end)

mousePosVector2 = (function()
	return Vector2.new(mouse.X, mouse.Y) 
end)

getClosestBodyPart = (function()
	local shortestDistance = math.huge
	local bodyPart = nil
	for _, v in next, game.Players:GetPlayers() do
		if (v ~= lp and v.Character and v.Character:FindFirstChild("Humanoid")) then
			for k, x in next, v.Character:GetChildren() do
				if (Filter(x)) then
					local Distance = (WTS(x) - mousePosVector2()).magnitude
					if (Distance < shortestDistance) then
						shortestDistance = Distance
						bodyPart = x
					end
				end
			end
		end
	end
	return bodyPart
end)

local FOVCircle = Drawing.new("Circle")


function updateFOV()
	FOVCircle.Radius = SilentAim.FOV.Size * 3
	FOVCircle.Visible = SilentAim.FOV.Enabled
	FOVCircle.Transparency = SilentAim.FOV.Transparency
	FOVCircle.Filled = SilentAim.FOV.Filled
	FOVCircle.Color = SilentAim.FOV.Color
	FOVCircle.Thickness = SilentAim.FOV.Thickness
	FOVCircle.Position = Vector2.new(game:GetService("UserInputService"):GetMouseLocation().X, game:GetService("UserInputService"):GetMouseLocation().Y)
	return FOVCircle
end

local plrService = game:GetService("Players")
local localPlr = plrService.LocalPlayer
local mouseLocal = localPlr:GetMouse()
local Players, Client, Mouse, Camera =
    game:GetService("Players"),
    game:GetService("Players").LocalPlayer,
    game:GetService("Players").LocalPlayer:GetMouse(),
    game:GetService("Workspace").CurrentCamera


function wallCheck(destination, ignore)
	if (getgenv().SilentAim.Settings.WallCheck) then
		local Origin = Camera.CFrame.p
		local CheckRay = Ray.new(Origin, destination - Origin)
		local Hit = game:GetService("Workspace"):FindPartOnRayWithIgnoreList(CheckRay, ignore)
		return Hit == nil
	else
		return true
	end
end

function getClosestPlayerToCursor()
	closestDist = SilentAim.FOV.Size * 3.47
	closestPlr = nil;
	for i, v in next, plrService:GetPlayers() do
		pcall(function()
			local notKO = v.Character:WaitForChild("BodyEffects")["K.O"].Value ~= true;
			local notGrabbed = v.Character:FindFirstChild("GRABBING_COINSTRAINT") == nil
			if v ~= localPlr and v.Character and v.Character.Humanoid.Health > 0 and notKO and notGrabbed then
				local screenPos, cameraVisible = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
				if cameraVisible then
					local distToMouse = (Vector2.new(mouseLocal.X, mouseLocal.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
					if distToMouse < closestDist and wallCheck(v.Character.Head.Position, {
						game:GetService("Players").LocalPlayer,
						v.Character
					}) then
						closestPlr = v
						closestDist = distToMouse
					end
				end
			end
		end)
	end
	return closestPlr, closestDist
end

spawn(function()
	while wait() do
		Plr = getClosestPlayerToCursor()
	end
end)

spawn(function()
	while wait() do
		if Plr ~= nil and Plr.Character.Humanoid.FloorMaterial ~= Enum.Material.Air then
			local Ping = math.floor(game.Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
			getgenv().SilentAim.Settings.Prediction = Ping / 1000 + 0.07
		end
	end
end)

game:GetService("RunService").Heartbeat:connect(function()
	updateFOV()
end)

local plr = game.Players.LocalPlayer
local Char = plr.Character or plr.CharacterAdded:Wait()

local function CharAdded()
Char.ChildAdded:Connect(function(tool)
    if tool:IsA("Tool") then -- add a better check for if the tool is a weapon 
        tool.Activated:Connect(function() -- fuck a :Disconnect lol
			if Plr ~= nil then
            	game:GetService("ReplicatedStorage").MainEvent:FireServer(Utility.Method, Plr.Character[SilentAim.Settings.AimPart].Position + (Plr.Character[SilentAim.Settings.AimPart].Velocity * SilentAim.Settings.Prediction))
			end
        end)
    end
end)
end

plr.CharacterAdded:Connect(function(newchar)
Char = newchar
CharAdded()
end)

CharAdded()
