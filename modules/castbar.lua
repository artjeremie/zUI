local zUICastbar = CreateFrame("Frame")
zUICastbar:RegisterEvent("PLAYER_LOGIN")
zUICastbar:SetScript("OnEvent", function(self, event)

	-- Player castbar icon
	CastingBarFrame.Icon:Show()
	CastingBarFrame.Icon:ClearAllPoints()
	CastingBarFrame.Icon:SetSize(38, 38)
	CastingBarFrame.Icon:SetPoint("RIGHT", CastingBarFrame, "LEFT", -10, 5)

	-- Timers
	CastingBarFrame.timer = CastingBarFrame:CreateFontString(nil)
	CastingBarFrame.timer:SetFont("FONTS\\FRIZQT__.TTF", 16, "THICKOUTLINE")
	CastingBarFrame.timer:SetPoint("LEFT", CastingBarFrame, "RIGHT", 5, 0)
	CastingBarFrame.timer:SetTextColor(0, 51, 0)
	CastingBarFrame.update = 0.1

	-- Timer function
	local function CastingBarFrame_OnUpdate_Hook(self, elapsed)
		if not self.timer then
			return
		end

		if self.update and self.update < elapsed then
			if self.casting then
				self.timer:SetText(format("%2.1f/%1.1f", max(self.maxValue - self.value, 0), self.maxValue))
			elseif self.channeling then
				self.timer:SetText(format("%.1f", max(self.value, 0)))
			else
				self.timer:SetText("")
			end
			self.update = 0.1
		else
			self.update = self.update - elapsed
		end
	end
	CastingBarFrame:HookScript("OnUpdate", CastingBarFrame_OnUpdate_Hook)
end)

-- Castbar scale, let's make em big!
FocusFrameSpellBar:SetScale(1.50)
TargetFrameSpellBar:SetScale(1.50)
