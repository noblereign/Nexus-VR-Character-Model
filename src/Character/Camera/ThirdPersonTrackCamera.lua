--[[
TheNexusAvenger

Third person camera that moves with the player.
--]]
--!strict

--Workaround for Roblox's CoreGuis relying on HeadLocked.
--https://devforum.roblox.com/t/coregui-vr-components-rely-on-headlocked-being-true/100460
local USE_HEAD_LOCKED_WORKAROUND = false

local THIRD_PERSON_ZOOM = 10



local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local VRService = game:GetService("VRService")


local ThirdPersonTrackCamera = {}
ThirdPersonTrackCamera.__index = ThirdPersonTrackCamera



--[[
Creates a third-person camera object.
--]]
function ThirdPersonTrackCamera.new(): any
    return setmetatable({}, ThirdPersonTrackCamera)
end

--[[
Enables the camera.
--]]
function ThirdPersonTrackCamera:Enable(): ()
    self.FetchInitialCFrame = true
end

--[[
Disables the camera.
--]]
function ThirdPersonTrackCamera:Disable(): ()
    self.FetchInitialCFrame = nil
end

--[[
Updates the camera.
--]]
function ThirdPersonTrackCamera:UpdateCamera(HeadsetCFrameWorld: CFrame): ()
    --Set the initial CFrame to use.
    if self.FetchInitialCFrame then
        self.BaseFaceAngleY = math.atan2(-HeadsetCFrameWorld.LookVector.X, -HeadsetCFrameWorld.LookVector.Z)
        self.BaseCFrame = CFrame.new(HeadsetCFrameWorld.Position) * CFrame.Angles(0, self.BaseFaceAngleY, 0)
        self.FetchInitialCFrame = nil
    end

    --Get the scale.
    local Scale = 1
    local Character = Players.LocalPlayer.Character
    if Character then
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            local BodyHeightScale = Humanoid:FindFirstChild("BodyHeightScale")
            if BodyHeightScale then
                Scale = BodyHeightScale.Value
            end
        end
    end

    --Calculate the third person CFrame.
    local HeadsetRelative = self.BaseCFrame:Inverse() * HeadsetCFrameWorld
    local TargetCFrame = self.BaseCFrame * CFrame.new(0, 0, -THIRD_PERSON_ZOOM * Scale) * CFrame.Angles(0, math.pi, 0) * HeadsetRelative

    --Update the camaera.
    Workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
    Workspace.CurrentCamera.HeadLocked = false
    if USE_HEAD_LOCKED_WORKAROUND then
        local HeadCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
        Workspace.CurrentCamera.HeadLocked = true
        Workspace.CurrentCamera.CFrame = TargetCFrame * (CFrame.new(HeadCFrame.Position * (Workspace.CurrentCamera.HeadScale - 1)) * HeadCFrame):Inverse()
    else
        Workspace.CurrentCamera.HeadLocked = false
        Workspace.CurrentCamera.CFrame = TargetCFrame
    end
end



return ThirdPersonTrackCamera