
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")


local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BlockAllButtonGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local buttonFrame = Instance.new("Frame")
buttonFrame.Name = "BlockAllButton"
buttonFrame.Size = UDim2.new(0, 200, 0, 80)
buttonFrame.Position = UDim2.new(0.5, -100, 0.5, -40)
buttonFrame.BackgroundColor3 = Color3.new(0.8, 0, 0)
buttonFrame.BorderSizePixel = 0
buttonFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = buttonFrame


local textLabel = Instance.new("TextLabel")
textLabel.Name = "ButtonText"
textLabel.Size = UDim2.new(1, 0, 1, 0)
textLabel.BackgroundTransparency = 1
textLabel.Text = "BLOCK ALL"
textLabel.Font = Enum.Font.SourceSansBold
textLabel.TextSize = 24
textLabel.TextColor3 = Color3.new(1, 1, 1)
    
local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.new(0, 0, 0)
uiStroke.Thickness = 2
uiStroke.Parent = textLabel
textLabel.Parent = buttonFrame

local isDragging = false
local dragStart = nil
local startPos = nil

local function updateInput(input)
    local delta = input.Position - dragStart
    buttonFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

buttonFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStart = input.Position
        startPos = buttonFrame.Position
        
        buttonFrame.BackgroundColor3 = Color3.new(1, 0.2, 0.2) 
        
        local connection
        connection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isDragging = false
                buttonFrame.BackgroundColor3 = Color3.new(0.8, 0, 0) 
                if connection then
                    connection:Disconnect()
                end
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging then
        updateInput(input)
    end
end)


local clickDebounce = false

local function onButtonClicked()
    if clickDebounce then return end
    clickDebounce = true
    
    local tween = TweenService:Create(buttonFrame, TweenInfo.new(0.1), {
        Size = UDim2.new(0, 180, 0, 72)
    })
    tween:Play()
    tween.Completed:Wait()
  
    local blockAllEvent = game.ReplicatedStorage:WaitForChild("BlockAllEvent")
    blockAllEvent:FireServer()
  
    local tweenBack = TweenService:Create(buttonFrame, TweenInfo.new(0.1), {
        Size = UDim2.new(0, 200, 0, 80)
    })
    tweenBack:Play()
    
    task.wait(0.5)
    clickDebounce = false
end


textLabel.MouseButton1Click:Connect(onButtonClicked)
buttonFrame.MouseButton1Click:Connect(onButtonClicked)

textLabel.Active = true
textLabel.Selectable = true
