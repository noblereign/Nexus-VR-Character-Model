--[[
TheNexusAvenger

Visual indicator for the end of aiming.
--]]
--!strict

local BEACON_SPEED_MULTIPLIER = 2



local Workspace = game:GetService("Workspace")

local Beacon = {}
Beacon.__index = Beacon

export type Beacon = {
    new: () -> (Beacon),

    Update: (self: Beacon, CenterCFrame: CFrame, HoverPart: BasePart) -> (),
    Hide: (self: Beacon) -> (),
    Destroy: (self: Beacon) -> (),
}



--[[
Creates a beacon.
--]]
function Beacon.new(): Beacon
    --Create the object.
    local self = {}
    setmetatable(self, Beacon)

    --Create the parts.
    self.Sphere = Instance.new("Part")
    self.Sphere.Transparency = 1
    self.Sphere.Material = Enum.Material.Neon
    self.Sphere.Anchored = true
    self.Sphere.CanCollide = false
    self.Sphere.Size = Vector3.new(0.5, 0.5, 0.5)
    self.Sphere.Shape = Enum.PartType.Ball
    self.Sphere.Parent = Workspace.CurrentCamera

    self.ConstantRing = Instance.new("ImageHandleAdornment")
    self.ConstantRing.Adornee = self.Sphere
    self.ConstantRing.Size = Vector2.new(2, 2)
    self.ConstantRing.Image = "rbxasset://textures/ui/VR/VRPointerDiscBlue.png"
    self.ConstantRing.Visible = false
    self.ConstantRing.Parent = self.Sphere

    self.MovingRing = Instance.new("ImageHandleAdornment")
    self.MovingRing.Adornee = self.Sphere
    self.MovingRing.Size = Vector2.new(2, 2)
    self.MovingRing.Image = "rbxasset://textures/ui/VR/VRPointerDiscBlue.png"
    self.MovingRing.Visible = false
    self.MovingRing.Parent = self.Sphere

    --Return the object.
    return (self :: any) :: Beacon
end

--[[
Updates the beacon at a given CFrame.
--]]
function Beacon:Update(CenterCFrame: CFrame, HoverPart: BasePart): ()
    --Calculate the size for the current time.
    local Height = 0.4 + (-math.cos(tick() * 2 * BEACON_SPEED_MULTIPLIER) / 8)
    local BeaconSize = 2 * ((tick() * BEACON_SPEED_MULTIPLIER) % math.pi) / math.pi

    --Update the size and position of the beacon.
    self.Sphere.CFrame = CenterCFrame * CFrame.new(0, Height, 0)
    self.ConstantRing.CFrame = CFrame.new(0, -Height, 0) * CFrame.Angles(math.pi / 2, 0, 0)
    self.MovingRing.CFrame = CFrame.new(0, -Height, 0) * CFrame.Angles(math.pi / 2, 0, 0)
    self.MovingRing.Transparency = BeaconSize / 2
    self.MovingRing.Size = Vector2.new(BeaconSize, BeaconSize)

    --Update the beacon color.
    local BeaconColor = Color3.fromRGB(0, 170, 0)
    if HoverPart then
        local VRBeaconColor = HoverPart:FindFirstChild("VRBeaconColor") :: Color3Value
        if VRBeaconColor then
            BeaconColor = VRBeaconColor.Value
        elseif (HoverPart:IsA("Seat") or HoverPart:IsA("VehicleSeat")) and not HoverPart.Disabled then
            BeaconColor = Color3.fromRGB(0, 170, 255)
        end
    end
    self.Sphere.Color = BeaconColor

    --Show the beacon.
    self.Sphere.Transparency = 0
    self.ConstantRing.Visible = true
    self.MovingRing.Visible = true
end

--[[
Hides the beacon.
--]]
function Beacon:Hide(): ()
    --Hide the beacon.
    self.Sphere.Transparency = 1
    self.ConstantRing.Visible = false
    self.MovingRing.Visible = false
end

--[[
Destroys the beacon.
--]]
function Beacon:Destroy(): ()
    self.Sphere:Destroy()
end



return (Beacon :: any) :: Beacon