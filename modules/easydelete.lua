local zUIEasyDel = CreateFrame("Frame")
zUIEasyDel:RegisterEvent("PLAYER_LOGIN")
zUIEasyDel:SetScript("OnEvent", function(self, event)
  
  hooksecurefunc(StaticPopupDialogs["DELETE_GOOD_ITEM"], "OnShow", function(s)
    s.editBox:SetText(DELETE_ITEM_CONFIRM_STRING)
  end)
end)
