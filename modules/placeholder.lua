-- This is for testing purposes

--[[
--== ACTION_CAMERA ==--
SetCVar("actioncam", on)
SetCVar("test_cameraDynamicPitch", 1)
SetCVar("test_cameraDynamicPitchBaseFovPad", 0.3)
 
UIParent:UnregisterEvent("EXPERIMENTAL_CVAR_CONFIRMATION_NEEDED")
--++ END ++--
--]]

--[[
--== ACTIONBAR_RANGE_COLOR ==--
if InCombatLockdown() then
return UIParent:RegisterEvent("PLAYER_REGEN_ENABLED", "OnEnable")
end
UIParent:UnregisterEvent("PLAYER_REGEN_ENABLED")
 
local function UpdateRange(self, hasrange, inrange)
local Icon = self.icon
local NormalTexture = self.NormalTexture
local ID = self.action
 
if not ID then
return
end
 
local IsUsable, NotEnoughMana = IsUsableAction(ID)
local HasRange = hasrange
local InRange = inrange
 
if IsUsable then
if (HasRange and InRange == false) then
Icon:SetVertexColor(0.8, 0.1, 0.1)
 
NormalTexture:SetVertexColor(0.8, 0.1, 0.1)
else
Icon:SetVertexColor(1.0, 1.0, 1.0)
 
NormalTexture:SetVertexColor(1.0, 1.0, 1.0)
end
elseif NotEnoughMana then
Icon:SetVertexColor(0.1, 0.3, 1.0)
 
NormalTexture:SetVertexColor(0.1, 0.3, 1.0)
else
Icon:SetVertexColor(0.3, 0.3, 0.3)
 
NormalTexture:SetVertexColor(0.3, 0.3, 0.3)
end
end
 
do
hooksecurefunc("ActionButton_UpdateRangeIndicator", UpdateRange)
end
--]]
