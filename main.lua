repeat task.wait() until game:IsLoaded()
loadstring(game:HttpGet("https://raw.githubusercontent.com/9g8fhd7sj23g8hg82nd/2/main/antiafk.lua"))()

local function equipGunIfNotEquipped()
    local Backpack = game:GetService("Players").LocalPlayer.Backpack:GetChildren()
    local Gun = nil
    -- EquipGunIfNotEquipped
    for _, v in pairs(Backpack) do
        if v:FindFirstChildWhichIsA("Sound") then
            Gun = v
            Gun.Parent = game:GetService("Players").LocalPlayer.Character
        end
    end
end

local function shootAtPlayers()
    for _, v in pairs(workspace:GetChildren()) do
        if v:IsA("Model") and game.Players:FindFirstChild(v.Name) and v.Name ~= game.Players.LocalPlayer.Name and not v:FindFirstChild("Highlight") then
            local args = {
                [1] = Vector3.new(-265.2897033691406, 62.427940368652344, 162.05580139160156),
                [2] = Vector3.new(-219.57574462890625, 54.045166015625, 319.8157653808594),
                [3] = v.LeftLowerArm.Part,
                [4] = Vector3.new(-234.1997833251953, 58.66779708862305, 272.2261657714844)
            }

            game:GetService("ReplicatedStorage").Remotes.Shoot:FireServer(unpack(args))
        end
    end
end

local function teleportPlayer()
    local userName = game.Players.LocalPlayer.Name
    local teleport1 = CFrame.new(72.79158020019531, -280.16778564453125, -1349.8760986328125)
    local teleport2 = CFrame.new(79.333740234375, -280.16778564453125, -1349.323486328125)
    
    local group1 = {
        ["gemloser"] = true, 
        ["gemfarmahh1"] = true, 
        ["gemfarmahh3"] = true, 
        ["gemfarmahh5"] = true, 
        ["gemfarmahh7"] = true
    }
    local group2 = {
        ["gemfarmahh"] = true, 
        ["gemfarmahh2"] = true, 
        ["gemfarmahh4"] = true, 
        ["gemfarmahh6"] = true, 
        ["gemfarmahh8"] = true
    }

    if group1[userName] then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = teleport1
    elseif group2[userName] then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = teleport2
    end
end

local function mainLoop()
    while true do
        pcall(equipGunIfNotEquipped)  -- Use pcall to handle any potential errors
        pcall(shootAtPlayers)        -- Use pcall to handle any potential errors
        pcall(teleportPlayer)        -- Use pcall to handle any potential errors
        task.wait(0.5)                 -- Adjust the wait time based on your needs
    end
end

-- Start the loop in a separate thread
spawn(mainLoop)
