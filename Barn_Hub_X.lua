-- Barn Hub X - Optimized & Lag-Free
local BarnHub = {
    Version = "1.0",
    Name = "Barn Hub X",
    Settings = {
        SpeedBoost = 1,
        TeleportEnabled = true,
        AntiLag = true
    }
}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Anti-lag optimization
if BarnHub.Settings.AntiLag then
    game:GetService("Lighting").GlobalShadows = false
    game:GetService("Lighting").Brightness = 2
end

-- Speed Boost Function
function BarnHub:SetSpeed(speed)
    if character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = speed
        print("[Barn Hub] Speed set to: " .. speed)
    end
end

-- Teleport Function
function BarnHub:Teleport(x, y, z)
    if character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
        print("[Barn Hub] Teleported to: " .. x .. ", " .. y .. ", " .. z)
    end
end

-- Initialize
function BarnHub:Initialize()
    print("[" .. self.Name .. "] v" .. self.Version .. " Loaded Successfully!")
    print("[" .. self.Name .. "] Anti-Lag: " .. tostring(self.Settings.AntiLag))
    
    -- Set default speed boost
    self:SetSpeed(self.Settings.SpeedBoost)
end

BarnHub:Initialize()

return BarnHub