zUILatency = CreateFrame("Frame", "StatsFrame", UIParent)
zUILatency:ClearAllPoints()
zUILatency:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 45)

local zUIStatus = CreateFrame("Frame")
zUIStatus:RegisterEvent("PLAYER_LOGIN")
zUIStatus:SetScript("OnEvent", function(self, event)
  
  local color
  if customColor == false then
    color = {r = 1, g = 1, b = 1}
  else
    local _, class = UnitClass("player")
    color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
  end
  
  local function statusFps()
    return "|c00ffffff" .. floor(GetFramerate()) .. "|r fps"
  end
  
  local function statusLatency()
    return "|c00ffffff" .. select(3, GetNetStats()) .. "|r ms"
  end
  
  zUILatency:SetWidth(50)
  zUILatency:SetHeight(14)
  zUILatency.text = zUILatency:CreateFontString(nil, "BACKGROUND")
  zUILatency.text:SetPoint("CENTER", zUILatency)
  zUILatency.text:SetFont("FONTS\\FRIZQT__.TTF", 11, "OUTLINE")
  zUILatency.text:SetTextColor(color.r, color.g, color.b)
  
  local lastUpdate = 0
  
  local function update(self, elapsed)
    lastUpdate = lastUpdate + elapsed
    if lastUpdate > 1 then
      lastUpdate = 0
      if showClock == true then
        zUILatency.text:SetText(statusFps() .. " " .. statusLatency())
      else
        zUILatency.text:SetText(statusFps() .. " " .. statusLatency())
      end
      self:SetWidth(zUILatency.text:GetStringWidth())
      self:SetHeight(zUILatency.text:GetStringHeight())
    end
  end
  
  zUILatency:SetScript("OnUpdate", update)
end)
