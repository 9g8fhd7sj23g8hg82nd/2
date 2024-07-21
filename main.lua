repeat task.wait() until game:IsLoaded()
loadstring(game:HttpGet("https://raw.githubusercontent.com/9g8fhd7sj23g8hg82nd/2/main/antiafk.lua"))()

local webhookUrl = 'https://discord.com/api/webhooks/1264595689430581258/Aj84hYn1zE1Re6RXHnGzgUF6K1X2RzpS1k31sbjocq8dLXpIiDzr4BV4XACawpkmDJbw'
local HttpService = game:GetService('HttpService')
local player = game.Players.LocalPlayer
local username = player.Name
local userId = player.UserId

local function sendMessageToWebhook(gemsValue, level, serverCount)
    local currentTime = os.date("%Y-%m-%d %H:%M:%S", os.time())
    
    local messageData = {
        embeds = {
            {
                title = username .. ' - ' .. tostring(userId),  -- Title of the embed with username and userID
                color = tonumber('0x00ff44'),  -- Embed color in hexadecimal
                fields = {
                    {
                        name = "Gems",
                        value = '**' .. gemsValue .. '**',
                        inline = true
                    },
                    {
                        name = "Level",
                        value = '**' .. level .. '**',
                        inline = true
                    },
                    {
                        name = "Server Count",
                        value = '**' .. serverCount .. '**',
                        inline = true
                    }
                },
                footer = {
                    text = currentTime  -- Only the time
                }
            }
        }
    }

    local response = syn.request({
        Url = webhookUrl,
        Method = 'POST',
        Headers = {
            ['Content-Type'] = 'application/json'
        },
        Body = HttpService:JSONEncode(messageData)
    })

    if response and response.StatusCode == 204 then
        print("Message sent successfully.")
    else
        print("Failed to send message. Status code:", response.StatusCode)
    end
end

local function extractAndSend()
    local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Find the gems label
    local gemsLabel = playerGui:FindFirstChild("Store")
        and playerGui.Store:FindFirstChild("Frame")
        and playerGui.Store.Frame:FindFirstChild("HeaderFrame")
        and playerGui.Store.Frame.HeaderFrame:FindFirstChild("LeftFrame")
        and playerGui.Store.Frame.HeaderFrame.LeftFrame:FindFirstChild("ImageButton")
        and playerGui.Store.Frame.HeaderFrame.LeftFrame.ImageButton:FindFirstChild("CreditsLabel")

    -- Find the level label
    local levelLabel = playerGui:FindFirstChild("Menu")
        and playerGui.Menu:FindFirstChild("BattlePassButton")
        and playerGui.Menu.BattlePassButton:FindFirstChild("LevelFrame")
        and playerGui.Menu.BattlePassButton.LevelFrame:FindFirstChild("LevelTextLabel")

    if gemsLabel and gemsLabel:IsA("TextLabel") then
        local gemsValue = gemsLabel.Text

        if levelLabel and levelLabel:IsA("TextLabel") then
            local level = levelLabel.Text
            local serverCount = #game.Players:GetPlayers()  -- Number of players in the server

            if string.match(gemsValue, "%d+") then
                sendMessageToWebhook(gemsValue, level, serverCount)
            else
                print("No valid gems amount found.")
            end
        else
            print("Level label not found.")
        end
    else
        print("Gems label not found.")
    end
end

local function buyCase(caseName)
    local args = {
        [1] = caseName
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("Collection"):WaitForChild("BuyCase"):InvokeServer(unpack(args))
end

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

local function periodicUpdate()
    while true do
        pcall(extractAndSend)         -- Safely call extractAndSend() to handle errors
        task.wait(900)                -- Wait for 15 minutes (900 seconds) before calling again
    end
end

-- Start the loops in separate threads
spawn(mainLoop)
spawn(periodicUpdate)
