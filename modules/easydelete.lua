local zUIEasyDelete = CreateFrame("Frame")
zUIEasyDelete:RegisterEvent("PLAYER_LOGIN")
zUIEasyDelete:SetScript("OnEvent", function(self, event)
  
  hooksecurefunc(StaticPopupDialogs["DELETE_GOOD_ITEM"], "OnShow", function(s)
    s.editBox:SetText(DELETE_ITEM_CONFIRM_STRING)
  end)
end)
