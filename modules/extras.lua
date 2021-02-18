local zUIStopWatch = CreateFrame("Frame")
zUIStopWatch:RegisterEvent("PLAYER_LOGIN")
zUIStopWatch:SetScript("OnEvent", function(self, event)
  
  -- Stopwatch
  Stopwatch_Toggle()
  StopwatchFrame:SetFrameStrata(BACKGROUND)
end)
