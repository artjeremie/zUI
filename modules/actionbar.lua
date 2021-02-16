local _, zUI = ...
local m = zUI:CreateModule("Actionbar")

local eventHandler = CreateFrame("Frame", nil, UIParent)
eventHandler:SetScript("OnEvent", function(self, event, ...)
	return self[event](self, ...)
end)

function m:OnLoad()
	eventHandler:RegisterEvent("PLAYER_LOGIN")

	-- Hide artwork
	MainMenuBarArtFrameBackground.BackgroundSmall:SetAlpha(0)
	MainMenuBarArtFrameBackground.BackgroundLarge:SetAlpha(0)
	MainMenuBarArtFrameBackground.QuickKeybindGlowLarge:SetAlpha(0)
	MainMenuBarArtFrameBackground.QuickKeybindGlowSmall:SetAlpha(0)
	MultiBarBottomLeft.QuickKeybindGlow:SetAlpha(0)
	MultiBarBottomRight.QuickKeybindGlow:SetAlpha(0)
	MainMenuBarArtFrame.RightEndCap:Hide()
	MainMenuBarArtFrame.LeftEndCap:Hide()
	MainMenuBarArtFrame.PageNumber:Hide()
	StanceBarLeft:SetAlpha(0)
	StanceBarRight:SetAlpha(0)
	StanceBarMiddle:SetAlpha(0)
	SlidingActionBarTexture0:SetAlpha(0)
	SlidingActionBarTexture1:SetAlpha(0)

	-- Extra buttons hide background
	ExtraActionButton1.style:SetAlpha(0)
	ZoneAbilityFrame.Style:SetAlpha(0)
	ZoneAbilityFrame.Style:Hide()

	-- Adjust gap between main & bottom right bars to accomodate extra buttons
	MultiBarBottomRightButton1:ClearAllPoints()
	MultiBarBottomRightButton1:SetPoint("LEFT", ActionButton12, "CENTER", 89, 0)
	MultiBarBottomRightButton7:ClearAllPoints()
	MultiBarBottomRightButton7:SetPoint("LEFT", MultiBarBottomLeftButton12, "CENTER", 89, 0)

	-- Hide xp bar. Don't touch MainMenuBar
	MainMenuBarArtFrameBackground:ClearAllPoints()
	MainMenuBarArtFrameBackground:SetPoint("LEFT", MainMenuBar)

	hooksecurefunc(StatusTrackingBarManager, "LayoutBar", function(self, bar)
		bar:SetPoint("BOTTOM", MainMenuBarArtFrameBackground, 0, select(5, bar:GetPoint()))
	end)

	-- MainMenuBar blocks click action on some moved buttons
	MainMenuBar:EnableMouse(false)

	-- UIParent_ManageFramePosition will ignore a frame if it's user-placed
	MultiBarBottomLeft:SetMovable(true)
	MultiBarBottomLeft:SetUserPlaced(true)

	-- Fix position of pet bar
	local petAnchor = CreateFrame("Frame", nil, PetActionBarFrame)
	petAnchor:SetSize(509, 43)
	for i = 1, 10 do
		local button = _G["PetActionButton" .. i]
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", petAnchor, "BOTTOMLEFT", 36, 2)
		else
			button:SetPoint("LEFT", "PetActionButton" .. i - 1, "RIGHT", 8, 0)
		end
	end

	-- Fix position of stance bar
	StanceBarFrame.ignoreFramePositionManager = true

	hooksecurefunc("UIParent_ManageFramePosition", function(index)
		if InCombatLockdown() then
			return
		end

		if index == "PETACTIONBAR_YPOS" then
			petAnchor:SetPoint(
				"BOTTOMLEFT",
				MainMenuBarArtFrameBackground,
				"TOPLEFT",
				30,
				SHOW_MULTI_ACTIONBAR_1 and 40 or -2
			)
		elseif index == "StanceBarFrame" then
			StanceBarFrame:SetPoint(
				"BOTTOMLEFT",
				MainMenuBarArtFrameBackground,
				"TOPLEFT",
				30,
				SHOW_MULTI_ACTIONBAR_1 and 40 or -2
			)
		end
	end)

	-- Fix texture size on stance bar when bottom left bar is disabled
	local sizeHook = false

	local function widthFunc(self)
		if sizeHook then
			return
		end
		sizeHook = true
		self:SetWidth(52)
		sizeHook = false
	end

	local function heightFunc(self)
		if sizeHook then
			return
		end
		sizeHook = true
		self:SetHeight(52)
		sizeHook = false
	end

	for i = 1, NUM_STANCE_SLOTS do
		hooksecurefunc(_G["StanceButton" .. i]:GetNormalTexture(), "SetWidth", widthFunc)
		hooksecurefunc(_G["StanceButton" .. i]:GetNormalTexture(), "SetHeight", heightFunc)
	end

	self.buttons = {}
	for i = 1, 12 do
		tinsert(self.buttons, _G["ActionButton" .. i])
		tinsert(self.buttons, _G["MultiBarBottomLeftButton" .. i])
		tinsert(self.buttons, _G["MultiBarBottomRightButton" .. i])
		tinsert(self.buttons, _G["MultiBarLeftButton" .. i])
		tinsert(self.buttons, _G["MultiBarRightButton" .. i])
	end

	local function updateHotkeys(self)
		if m.db.hideHotkeys then
			self.HotKey:Hide()
		end
	end

	for _, button in pairs(self.buttons) do
		hooksecurefunc(button, "UpdateHotkeys", updateHotkeys)
	end

	hooksecurefunc("ActionButton_UpdateRangeIndicator", updateHotkeys)
	hooksecurefunc("PetActionButton_SetHotkeys", updateHotkeys)

	self:HideXPBar(self.db.hideXPBar)
	self:HideArrows(self.db.hideArrows)
	self:HideHotkeys(self.db.hideHotkeys)
	self:HideMacroNames(self.db.hideMacroNames)
	self:EnableExtraButtons(self.db.extraButtons)
	self:DisableAutoAddSpell(self.db.disableAutoAddSpell)
end

function eventHandler:PLAYER_LOGIN()
	if InCombatLockdown() then
		return
	end

	-- moving the bar here because PLAYER_LOGIN is called after layout-local.txt settings
	MultiBarBottomLeft:ClearAllPoints()
	MultiBarBottomLeft:SetPoint("BOTTOMLEFT", ActionButton1, "TOPLEFT", 0, 6)
end

function m:HideHotkeys(hide)
	self.db.hideHotkeys = hide
	for _, button in ipairs(self.buttons) do
		button:UpdateHotkeys(button.buttonType)
	end
	for i = 1, 10 do
		PetActionButton_SetHotkeys(_G["PetActionButton" .. i])
	end
end

function m:HideMacroNames(hide)
	self.db.hideMacroNames = hide
	for _, button in ipairs(self.buttons) do
		button.Name:SetShown(not hide)
	end
end

function m:HideArrows(hide)
	self.db.hideArrows = hide
	ActionBarDownButton:SetAlpha(hide and 0 or 1)
	ActionBarUpButton:SetAlpha(hide and 0 or 1)
end

function m:HideXPBar(hide)
	self.db.hideXPBar = hide
	StatusTrackingBarManager:SetAlpha(hide and 0 or 1)
	MainMenuBarArtFrameBackground:SetPoint("BOTTOM", hide and UIParent or MainMenuBar, 0, hide and 3 or 0)
end

function m:EnableExtraButtons(enable)
	self.db.extraButtons = enable

	if enable then
		MultiBarLeftButton12:ClearAllPoints()
		MultiBarLeftButton12:SetPoint("LEFT", MultiBarBottomLeftButton12, "RIGHT", 6, 0)
		MultiBarRightButton12:ClearAllPoints()
		MultiBarRightButton12:SetPoint("LEFT", ActionButton12, "RIGHT", 6, 0)
		ActionBarDownButton:ClearAllPoints()
		ActionBarUpButton:ClearAllPoints()
		ActionBarUpButton:SetPoint("BOTTOM", MultiBarRightButton12, "RIGHT", 14, -1)
		ActionBarDownButton:SetPoint("TOP", MultiBarRightButton12, "RIGHT", 14, -1)
	else
		MultiBarLeftButton12:ClearAllPoints()
		MultiBarLeftButton12:SetPoint("TOP", MultiBarLeftButton11, "BOTTOM", 0, -6)
		MultiBarRightButton12:ClearAllPoints()
		MultiBarRightButton12:SetPoint("TOP", MultiBarRightButton11, "BOTTOM", 0, -6)
		ActionBarDownButton:ClearAllPoints()
		ActionBarUpButton:ClearAllPoints()
		ActionBarUpButton:SetPoint("BOTTOM", ActionButton12, "RIGHT", 14, -1)
		ActionBarDownButton:SetPoint("TOP", ActionButton12, "RIGHT", 14, -1)
	end
end

function m:DisableAutoAddSpell(disabled)
	self.db.disableAutoAddSpell = disabled
	if disabled then
		IconIntroTracker:UnregisterEvent("SPELL_PUSHED_TO_ACTIONBAR")
	else
		IconIntroTracker:RegisterEvent("SPELL_PUSHED_TO_ACTIONBAR")
	end
end

function m:OnProfileChange()
	self:HideXPBar(self.db.hideXPBar)
	self:HideArrows(self.db.hideArrows)
	self:HideHotkeys(self.db.hideHotkeys)
	self:HideMacroNames(self.db.hideMacroNames)
	self:EnableExtraButtons(self.db.extraButtons)
	self:DisableAutoAddSpell(self.db.disableAutoAddSpell)
end

m.defaultSettings = {
  hideHotkeys = true,
  hideMacroNames = true,
	hideArrows = true,
	hideXPBar = false,
	extraButtons = true,
	disableAutoAddSpell = true,
}

m.optionsTable = {
  hideHotkeys = {
		name = "Hotkeys",
    desc = "Hides actionbar hotkeys.",
		type = "toggle",
		width = "full",
		order = 1,
		set = function(info, val)
			m.db.hideHotkeys = val
			m:HideHotkeys(val)
		end,
	},
  hideMacroNames = {
		name = "Macro Names",
    desc = "Hides actionbar macro names.",
		type = "toggle",
		width = "full",
		order = 2,
		set = function(info, val)
			m.db.hideMacroNames = val
			m:HideMacroNames(val)
		end,
	},
  hideArrows = {
		name = "Page Buttons",
    desc = "Hides actionbar arrow page indicator button.",
		type = "toggle",
		width = "full",
		order = 3,
		set = function(info, val)
			m.db.hideArrows = val
			m:HideArrows(val)
		end,
	},
	hideXPBar = {
		name = "XP Bar",
    desc = "Hides experience bar.",
		type = "toggle",
		width = "full",
		order = 4,
		set = function(info, val)
			m.db.hideXPBar = val
			m:HideXPBar(val)
		end,
	},
	extraButtons = {
		name = "Extra Buttons",
		desc = "Moves the 12th button of right actionbars",
		type = "toggle",
		width = "full",
		order = 5,
		set = function(info, val)
			m:EnableExtraButtons(val)
		end,
	},
	disableAutoAddSpell = {
		name = "Spell Push To Actionbar",
		desc = "Disable auto adding spells that's not in actionbar",
		type = "toggle",
		width = "full",
		order = 6,
		set = function(info, val)
			m:DisableAutoAddSpell(val)
		end,
	},
}
