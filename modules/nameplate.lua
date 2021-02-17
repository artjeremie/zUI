-- Friendly nameplates width and height
local zUIPlate = CreateFrame("Frame")
zUIPlate:HookScript("OnEvent", function()
  C_NamePlate.SetNamePlateFriendlySize(60, 30)
end)

zUIPlate:RegisterEvent("PLAYER_LOGIN")

-- Health percent
hooksecurefunc("CompactUnitFrame_UpdateHealth", function(frame)
  if frame.optionTable.colorNameBySelection and not frame:IsForbidden() then
    local healthPercentage = ceil((UnitHealth(frame.displayedUnit) / UnitHealthMax(frame.displayedUnit) * 100))
    
    if not frame.health then
      frame.health = CreateFrame("Frame", nil, frame)
      frame.health:SetSize(170, 16)
      frame.health.text = frame.health.text or frame.health:CreateFontString(nil, "OVERLAY")
      frame.health.text:SetAllPoints(true)
      frame.health:SetFrameStrata("HIGH")
      frame.health:SetPoint("CENTER", frame.healthBar)
      frame.health.text:SetVertexColor(1, 1, 1)
      frame.health.text:SetFont("FONTS\\FRIZQT__.TTF", 11, "OUTLINE")
    end
    
    frame.health.text:Show()
    frame.health.text:SetText(healthPercentage .. "%")
  end
end)
