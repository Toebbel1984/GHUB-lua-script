EnablePrimaryMouseButtonEvents(true);

-- =========================================================
-- M3 + G1 = Recoil Toggle
-- M3 + G2 = Center Toggle
-- M3 + G3 = Spiral Toggle
-- M3 + G4 = Infinity Toggle
-- Left Click on M3 executes active mode
-- =========================================================

-- =========================
-- CONFIG
-- =========================
local Debug = 1

-- Recoil Mode
local RecoilEnabled = 0
local RecoilDown = 4
local RecoilMaxShots = 150
local RecoilSleepDown = 6
local RecoilSleepRecover = 8

local RecoilBaseOffset = 3
local RecoilRandomMin = 5
local RecoilRandomMax = 16
local RecoilSmoothness = 0.65      -- 0.0 = wild, 1.0 = very smooth
local RecoilHorizontalBias = 0     -- negative = left, positive = right

-- Center Mode
local CenterEnabled = 0
local CenterSleep = 2

-- Spiral Mode
local SpiralEnabled = 0
local SpiralStartRadius = 12
local SpiralMaxRadius = 111
local SpiralAngleStep = 0.22
local SpiralRadiusStep = 1.4
local SpiralSleep = 4
local SpiralReturnToCenter = 0     -- 1 = reset after every spiral loop

-- Infinity Mode
local InfinityEnabled = 0
local InfinitySize = 100
local InfinityStep = 0.75
local InfinitySleep = 25

-- Circle Mode
local CircleEnabled = 0
local CircleRadius = 50
local CircleSpeed = 0.85
local CircleSleep = 10

-- Only one mode active at a time
local ExclusiveModes = true

-- =========================
-- INTERNAL
-- =========================
local ScriptName = "Mouse FX Pro+"
local ScriptVersion = "1.1"

local recoilJitterX = 0
local recoilJitterY = 0

-- =========================
-- HELPERS
-- =========================
local function Clamp(v, minV, maxV)
    if v < minV then return minV end
    if v > maxV then return maxV end
    return v
end

local function Toggle(v)
    if v == 0 then
        return 1
    else
        return 0
    end
end

local function BoolText(v)
    if v == 1 then
        return "ON"
    else
        return "OFF"
    end
end

local function DisableAllModes()
    RecoilEnabled = 0
    CenterEnabled = 0
    SpiralEnabled = 0
    InfinityEnabled = 0
    CircleEnabled = 0
end

local function RoundSigned(v)
    if v >= 0 then
        return math.floor(v + 0.5)
    else
        return math.ceil(v - 0.5)
    end
end

local function GetActiveModeName()
    if RecoilEnabled == 1 then return "Recoil" end
    if CenterEnabled == 1 then return "Center" end
    if SpiralEnabled == 1 then return "Spiral" end
    if InfinityEnabled == 1 then return "Infinity" end
    if CircleEnabled == 1 then return "Circle" end
    return "None"
end

local function SafeRandom(minV, maxV)
    if minV > maxV then
        local t = minV
        minV = maxV
        maxV = t
    end
    return math.random(minV, maxV)
end

local function RandomFloat(minV, maxV)
    local r = math.random(0, 10000) / 10000
    return minV + (maxV - minV) * r
end

local function Lerp(a, b, t)
    return a + (b - a) * t
end

local function Announce(text)
    if Debug == 1 then
        OutputLogMessage("\n[INFO] %s\n", text)
    end
end

local function LogStatus(event, arg)
    if Debug ~= 1 then return end
    if GetMKeyState() ~= 3 then return end

    local x, y = GetMousePosition()
    local BoxWidth = 42

    local function BoxLine(text)
        OutputLogMessage("\t\t┃ %-" .. BoxWidth .. "s ┃\n", tostring(text))
    end

    ClearLog()

    OutputLogMessage("\t\t┏" .. string.rep("━", BoxWidth + 6) .. "┓\n")
    BoxLine(ScriptName .. " v" .. ScriptVersion)
    OutputLogMessage("\t\t┣" .. string.rep("━", BoxWidth + 6) .. "┫\n")
    BoxLine("Event       : " .. tostring(event))
    BoxLine("Arg         : " .. tostring(arg))
    BoxLine("M-Key       : " .. tostring(GetMKeyState()))
    BoxLine("Active Mode : " .. GetActiveModeName())
    OutputLogMessage("\t\t┣" .. string.rep("━", BoxWidth + 6) .. "┫\n")
    BoxLine("Recoil      : " .. BoolText(RecoilEnabled))
    BoxLine("Center      : " .. BoolText(CenterEnabled))
    BoxLine("Spiral      : " .. BoolText(SpiralEnabled))
    BoxLine("Infinity    : " .. BoolText(InfinityEnabled))
    BoxLine("Circle      : " .. BoolText(CircleEnabled))
    OutputLogMessage("\t\t┣" .. string.rep("━", BoxWidth + 6) .. "┫\n")
    BoxLine("Cursor      : " .. x .. ", " .. y)
    OutputLogMessage("\t\t┗" .. string.rep("━", BoxWidth + 6) .. "┛\n")
end

-- =========================
-- BETTER RECOIL JITTER
-- =========================
local function ResetRecoilJitter()
    recoilJitterX = 0
    recoilJitterY = 0
end

local function GetSmoothJitter()
    local targetX = RandomFloat(-RecoilRandomMax, RecoilRandomMax) + RecoilHorizontalBias
    local targetY = RandomFloat(RecoilRandomMin, RecoilRandomMax)

    recoilJitterX = Lerp(recoilJitterX, targetX, 1.0 - RecoilSmoothness)
    recoilJitterY = Lerp(recoilJitterY, targetY, 1.0 - RecoilSmoothness)

    local jitterX = math.floor(recoilJitterX + (recoilJitterX >= 0 and 0.5 or -0.5))
    local jitterY = math.floor(recoilJitterY + 0.5)

    return jitterX, jitterY
end

-- =========================
-- MODES
-- =========================

function CircleMouse()
    local angle = 0

    -- Startpunkt der Kreisbahn relativ zum aktuellen Mauspunkt
    local lastX = math.cos(angle) * CircleRadius
    local lastY = math.sin(angle) * CircleRadius

    -- Restfehler gegen Drift
    local fracX = 0
    local fracY = 0

    while IsMouseButtonPressed(1) do
        angle = angle + CircleSpeed
        if angle >= (2 * math.pi) then
            angle = angle - (2 * math.pi)
        end

        local curX = math.cos(angle) * CircleRadius
        local curY = math.sin(angle) * CircleRadius

        local dx = (curX - lastX) + fracX
        local dy = (curY - lastY) + fracY

        local moveX = RoundSigned(dx)
        local moveY = RoundSigned(dy)

        fracX = dx - moveX
        fracY = dy - moveY

        MoveMouseRelative(moveX, moveY)

        lastX = curX
        lastY = curY

        Sleep(CircleSleep)
    end
end

function SpiralMouse()
    local angle = 0
    local radius = SpiralStartRadius
    local radiusDirection = 1 -- 1 = größer, -1 = kleiner

    -- Startpunkt der Spirale relativ zum aktuellen Mauspunkt
    local lastX = math.cos(angle) * radius
    local lastY = math.sin(angle) * radius

    -- Restfehler gegen Drift
    local fracX = 0
    local fracY = 0

    while IsMouseButtonPressed(1) do
        -- Winkel immer nur vorwärts
        angle = angle + SpiralAngleStep

        -- Radius separat steuern
        radius = radius + (SpiralRadiusStep * radiusDirection)

        if radius >= SpiralMaxRadius then
            radius = SpiralMaxRadius
            radiusDirection = -1
        elseif radius <= SpiralStartRadius then
            radius = SpiralStartRadius
            radiusDirection = 1
        end

        local curX = math.cos(angle) * radius
        local curY = math.sin(angle) * radius

        local dx = (curX - lastX) + fracX
        local dy = (curY - lastY) + fracY

        local moveX = RoundSigned(dx)
        local moveY = RoundSigned(dy)

        fracX = dx - moveX
        fracY = dy - moveY

        MoveMouseRelative(moveX, moveY)

        lastX = curX
        lastY = curY

        Sleep(SpiralSleep)
    end
end

function InfinityMouse()
    local t = 0

    local sinT = math.sin(t)
    local cosT = math.cos(t)
    local denom = 1 + sinT * sinT

    -- Startpunkt der Infinity-Bahn relativ zum aktuellen Mauspunkt
    local lastX = InfinitySize * cosT / denom
    local lastY = InfinitySize * sinT * cosT / denom

    -- Restfehler gegen Drift
    local fracX = 0
    local fracY = 0

    while IsMouseButtonPressed(1) do
        t = t + InfinityStep

        sinT = math.sin(t)
        cosT = math.cos(t)
        denom = 1 + sinT * sinT

        local curX = InfinitySize * cosT / denom
        local curY = InfinitySize * sinT * cosT / denom

        local dx = (curX - lastX) + fracX
        local dy = (curY - lastY) + fracY

        local moveX = RoundSigned(dx)
        local moveY = RoundSigned(dy)

        fracX = dx - moveX
        fracY = dy - moveY

        MoveMouseRelative(moveX, moveY)

        lastX = curX
        lastY = curY

        Sleep(InfinitySleep)
    end
end

function DoRecoil()
    local shotCount = 0
    ResetRecoilJitter()

    repeat
        shotCount = shotCount + 1

        if shotCount <= RecoilMaxShots then
            MoveMouseRelative(0, RecoilDown)
        end

        local jitterX, jitterY = GetSmoothJitter()

        Sleep(RecoilSleepDown)
        MoveMouseRelative(jitterX, jitterY)
        Sleep(RecoilSleepRecover)
        MoveMouseRelative(-jitterX, -jitterY)

    until not IsMouseButtonPressed(1)
end

function ForceCenterMouse()
    repeat
        MoveMouseTo(32767, 32767)
        Sleep(CenterSleep)
    until not IsMouseButtonPressed(1)
end

-- =========================
-- TOGGLE HANDLING
-- =========================

local function ToggleCircle()
    local wasEnabled = CircleEnabled
    if ExclusiveModes then DisableAllModes() end
    CircleEnabled = (wasEnabled == 1) and 0 or 1
    Announce("Circle = " .. BoolText(CircleEnabled))
end

local function ToggleRecoil()
    local wasEnabled = RecoilEnabled
    if ExclusiveModes then DisableAllModes() end
    RecoilEnabled = (wasEnabled == 1) and 0 or 1
    Announce("Recoil = " .. BoolText(RecoilEnabled))
end

local function ToggleCenter()
    local wasEnabled = CenterEnabled
    if ExclusiveModes then DisableAllModes() end
    CenterEnabled = (wasEnabled == 1) and 0 or 1
    Announce("Center = " .. BoolText(CenterEnabled))
end

local function ToggleSpiral()
    local wasEnabled = SpiralEnabled
    if ExclusiveModes then DisableAllModes() end
    SpiralEnabled = (wasEnabled == 1) and 0 or 1
    Announce("Spiral = " .. BoolText(SpiralEnabled))
end

local function ToggleInfinity()
    local wasEnabled = InfinityEnabled
    if ExclusiveModes then DisableAllModes() end
    InfinityEnabled = (wasEnabled == 1) and 0 or 1
    Announce("Infinity = " .. BoolText(InfinityEnabled))
end

-- =========================
-- MAIN EVENT
-- =========================
function OnEvent(event, arg)
    local current_mkey = GetMKeyState()

    if event == "PROFILE_ACTIVATED" then
        math.randomseed(GetRunningTime())
        ClearLog()
        OutputLogMessage("\n%s v%s loaded\n\n", ScriptName, ScriptVersion)
    end

    if event == "G_PRESSED" and current_mkey == 3 then
        if arg == 1 then
            ToggleRecoil()
        elseif arg == 2 then
            ToggleCenter()
        elseif arg == 3 then
            ToggleSpiral()
        elseif arg == 4 then
            ToggleInfinity()
        elseif arg == 5 then
            ToggleCircle()
        end
    end

    if event == "MOUSE_BUTTON_PRESSED" and arg == 1 and current_mkey == 3 then
        if RecoilEnabled == 1 then
            DoRecoil()
        elseif CenterEnabled == 1 then
            ForceCenterMouse()
        elseif SpiralEnabled == 1 then
            SpiralMouse()
        elseif InfinityEnabled == 1 then
            InfinityMouse()
        elseif CircleEnabled == 1 then
            CircleMouse()
        end
    end

    LogStatus(event, arg)
end
