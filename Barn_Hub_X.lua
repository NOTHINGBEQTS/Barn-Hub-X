if game.PlaceId == 126884695634066 then

local Rayfield = loadstring(game:HttpGet('https://serius.menu/rayfield'))()

local MainWindow = Rayfield:CreateWindow({
   Name = "Main",
   Icon = 0,
   LoadingTitle = "loading...",
   LoadingSubtitle = "by kiyoshi",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Barn hub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "Barn hub",
      Subtitle = "Key System",
      Note = "Key = AlwaysTheSameKey",
      FileName = "Barn hub",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"AlwaysTheSameKey"} 
   }
})

local MainTab = MainWindow:CreateTab("main", 4483362458)

-- Hello Button
local Button = MainTab:CreateButton({
   Name = "Print Hello",
   Callback = function()
      print('hello')
   end,
})

-- Infinite Jump Toggle
local InfiniteJumpEnabled = false
local JumpConnection

local Toggle = MainTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
      InfiniteJumpEnabled = Value
      if InfiniteJumpEnabled then
         if JumpConnection then JumpConnection:Disconnect() end
         JumpConnection = game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == Enum.KeyCode.Space then
               game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            end
         end)
      else
         if JumpConnection then JumpConnection:Disconnect() end
      end
   end,
})

-- Walkspeed Slider
local Slider = MainTab:CreateSlider({
   Name = "Walkspeed",
   Range = {16, 250},
   Increment = 10,
   Suffix = "Walkspeed",
   CurrentValue = 16,
   Flag = "Slider1",
   Callback = function(Value)
      local player = game:GetService("Players").LocalPlayer
      if player.Character and player.Character:FindFirstChild("Humanoid") then
         player.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

-- Auto Farm Features
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local character = player.Character or player.CharacterAdded:Wait()

local CONFIG = {
    AUTO_PICKUP_PETS = true,
    AUTO_USE_TOY = true,
    AUTO_GROW_GARDEN = true,
    PICKUP_RANGE = 50,
    TOY_USE_INTERVAL = 5,
    GARDEN_GROW_INTERVAL = 1,
    SCRIPT_ENABLED = true,
}

local lastToyUseTime = 0
local lastGardenGrowTime = 0

-- Find Nearest Pet
local function findNearestPet()
    local nearestPet = nil
    local nearestDistance = CONFIG.PICKUP_RANGE
    
    local petsFolder = workspace:FindFirstChild("Pets") or workspace:FindFirstChild("Animals")
    if not petsFolder then return nil end
    
    for _, pet in pairs(petsFolder:GetChildren()) do
        if pet:FindFirstChild("Humanoid") or pet:FindFirstChild("PrimaryPart") then
            local petPosition = pet.PrimaryPart and pet.PrimaryPart.Position or pet.Position
            local distance = (character.PrimaryPart.Position - petPosition).Magnitude
            
            if distance < nearestDistance then
                nearestDistance = distance
                nearestPet = pet
            end
        end
    end
    
    return nearestPet
end

-- Pickup Pet
local function pickupPet(pet)
    if not pet or not CONFIG.AUTO_PICKUP_PETS or not CONFIG.SCRIPT_ENABLED then return end
    
    local petPosition = pet.PrimaryPart and pet.PrimaryPart.Position or pet.Position
    character.PrimaryPart.CFrame = CFrame.new(petPosition + Vector3.new(0, 3, 0))
    
    wait(0.1)
    mouse.Target = pet
    mouse:TriggerButton1Down()
    wait(0.05)
    mouse:TriggerButton1Up()
end

-- Use Toy
local function useToy()
    if not CONFIG.AUTO_USE_TOY or not CONFIG.SCRIPT_ENABLED then return end
    
    local currentTime = tick()
    if currentTime - lastToyUseTime < CONFIG.TOY_USE_INTERVAL then return end
    
    lastToyUseTime = currentTime
    
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return end
    
    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") and string.find(string.lower(item.Name), "toy") then
            item.Parent = character
            wait(0.2)
            
            if item:FindFirstChild("Handle") then
                local equip = item:FindFirstChild("Equip") or item:FindFirstChild("Use")
                if equip then
                    equip:FireServer()
                else
                    local remote = item:FindFirstChildOfClass("RemoteEvent")
                    if remote then
                        remote:FireServer()
                    end
                end
            end
            return
        end
    end
end

-- Grow Garden
local function growGarden()
    if not CONFIG.AUTO_GROW_GARDEN or not CONFIG.SCRIPT_ENABLED then return end
    
    local currentTime = tick()
    if currentTime - lastGardenGrowTime < CONFIG.GARDEN_GROW_INTERVAL then return end
    
    lastGardenGrowTime = currentTime
    
    local garden = workspace:FindFirstChild("Garden") or workspace:FindFirstChild("Farm")
    if not garden then return end
    
    for _, plant in pairs(garden:GetDescendants()) do
        if plant:IsA("BasePart") and (string.find(string.lower(plant.Name), "plant") or 
            string.find(string.lower(plant.Name), "crop") or 
            string.find(string.lower(plant.Name), "flower")) then
            
            character.PrimaryPart.CFrame = CFrame.new(plant.Position + Vector3.new(0, 3, 0))
            wait(0.1)
            
            mouse.Target = plant
            mouse:TriggerButton1Down()
            wait(0.05)
            mouse:TriggerButton1Up()
            wait(0.2)
        end
    end
end

-- Toggle Script
local function toggleScript()
    CONFIG.SCRIPT_ENABLED = not CONFIG.SCRIPT_ENABLED
    print("[Auto Script] Script is now " .. (CONFIG.SCRIPT_ENABLED and "ENABLED" or "DISABLED"))
end

-- Keybind (P to toggle)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.P then
        toggleScript()
    end
end)

-- Main Loop
RunService.Heartbeat:Connect(function()
    if not CONFIG.SCRIPT_ENABLED or not character or not character.PrimaryPart then return end
    
    if CONFIG.AUTO_PICKUP_PETS then
        local nearestPet = findNearestPet()
        if nearestPet then
            pickupPet(nearestPet)
        end
    end
    
    if CONFIG.AUTO_USE_TOY then
        useToy()
    end
    
    if CONFIG.AUTO_GROW_GARDEN then
        growGarden()
    end
end)

-- Character Respawn
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    print("[Auto Script] Character respawned")
end)

end
