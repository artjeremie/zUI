local _, zUI = ...
local m = zUI:CreateModule("Camera")

local eventHandler = CreateFrame("Frame", nil, UIParent)
eventHandler:SetScript("OnEvent", function(self, event, ...)
  return self[event](self, ...)
end)

function m:OnLoad()
  eventHandler:RegisterEvent("PLAYER_LOGIN")
  
  function eventHandler:PLAYER_LOGIN()
    -- Action camera
    UIParent:UnregisterEvent("EXPERIMENTAL_CVAR_CONFIRMATION_NEEDED")
  end
  
  function m:MaxCamDistance(disabled)
    self.db.maxCamDistance = disabled
    if disabled then
      SetCVar("cameraDistanceMaxZoomFactor", 2.6)
    else
      SetCVar("cameraDistanceMaxZoomFactor", 1.9)
    end
  end
end

function m:EnableActionCamera(disabled)
  self.db.enableActionCamera = disabled
  if disabled then
    SetCVar("actioncam", on)
    SetCVar("test_cameraDynamicPitch", 1)
    SetCVar("test_cameraDynamicPitchBaseFovPad", 0.35)
    SetCVar("CameraKeepCharacterCentered", 0)
  else
    SetCVar("actioncam", off)
    SetCVar("test_cameraDynamicPitch", 0)
    SetCVar("test_cameraDynamicPitchBaseFovPad", 0.4)
    SetCVar("CameraKeepCharacterCentered", 1)
  end
end

function m:OnProfileChange()
  self:MaxCamDistance(self.db.maxCamDistance)
  self:EnableActionCamera(self.db.enableActionCamera)
end

m.defaultSettings = {
  maxCamDistance = true,
  enableActionCamera = false,
}

m.optionsTable = {
  maxCamDistance = {
    name = "Camera Distance",
    desc = "Set camera zoom distance to max(2.6).",
    type = "toggle",
    width = "full",
    order = 1,
    set = function(info, val)
      m:MaxCamDistance(val)
    end,
  },
  enableActionCamera = {
    name = "Action Camera",
    desc = "\"Experimental feature\", Set to \"Allow Dynamic Camera Movement\" in Accessibility.",
    type = "toggle",
    width = "full",
    order = 2,
    set = function(info, val)
      m:EnableActionCamera(val)
    end,
  },
}
