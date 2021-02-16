local zUIWatch = CreateFrame("Frame")
zUIWatch:RegisterEvent("PLAYER_LOGIN")
zUIWatch:SetScript("OnEvent", function(self, event)
  
  -- Stopwatch
  Stopwatch_Toggle()
  StopwatchFrame:SetFrameStrata(BACKGROUND)
end)
