local _, zUI = ...
local m = zUI:CreateModule("Misc")

local eventHandler = CreateFrame("Frame", nil, UIParent)
eventHandler:SetScript("OnEvent", function(self, event, ...)
	return self[event](self, ...)
end)

function m:OnLoad()
	-- Short slash command to reload UI
	SLASH_ZUI_RELOAD1 = "/zr"
	SlashCmdList["ZUI_RELOAD"] = ReloadUI

	-- Fstack
	SLASH_FRAMESTK1 = "/fs"
	SlashCmdList["FRAMESTK"] = function()
		LoadAddOn("Blizzard_Debugtools")
		FrameStackTooltip_Toggle()
	end

	-- Leave group
	SLASH_LEAVEGROUP1 = "/lg"
	SlashCmdList["LEAVEGROUP"] = function()
		SendChatMessage("Thanks for the Group", "SAY")
		C_PartyInfo.LeaveParty()
	end

	-- Random mount
	SLASH_RANDOMMOUNT1 = "/rm"
	SlashCmdList["RANDOMMOUNT"] = function()
		C_MountJournal.SummonByID(0)
	end

	-- Raid frames extender
	local n, w, h = "CompactUnitFrameProfilesGeneralOptionsFrame"
	h, w = _G[n .. "HeightSlider"], _G[n .. "WidthSlider"]
	h:SetMinMaxValues(1, 150)
	w:SetMinMaxValues(1, 150)

	-- Damage font
	DAMAGE_TEXT_FONT = "Interface\\AddOns\\zUI\\media\\font.ttf"

	-- Hide minimap zoom icons
	MinimapZoomIn:Hide()
	MinimapZoomOut:Hide()

	-- Enable zooming on minimap with scrollwheel
	Minimap:EnableMouseWheel(true)
	Minimap:SetScript("OnMouseWheel", function(self, arg1)
		if arg1 > 0 then
			Minimap_ZoomIn()
		else
			Minimap_ZoomOut()
		end
	end)

	-- Move minimap and hide some stuff
	MiniMapWorldMapButton:Hide()
	MinimapBorderTop:Hide()
  --[[
	MinimapCluster:ClearAllPoints()
	MinimapCluster:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -5, -14)
  --]]
	-- Move minimap zone text
	MinimapZoneText:ClearAllPoints()
	MinimapZoneText:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -20, -7)
	MinimapZoneText:SetFont("FONTS\\FRIZQT__.TTF", 10, "OUTLINE")

	-- Dampening indicator for arena. using the eventHandler frame because why not
	local updateInterval = 5
	local dampeningText = GetSpellInfo(110310)
	eventHandler:SetSize(200, 12)
	eventHandler:SetPoint("TOP", UIWidgetTopCenterContainerFrame, "BOTTOM", 0, -2)
	eventHandler.text = eventHandler:CreateFontString(nil, "BACKGROUND")
	eventHandler.text:SetFontObject(GameFontNormalSmall)
	eventHandler.text:SetAllPoints()
	eventHandler.timeSinceLastUpdate = 0

	eventHandler:SetScript("OnUpdate", function(self, elapsed)
		self.timeSinceLastUpdate = self.timeSinceLastUpdate + elapsed

		if self.timeSinceLastUpdate > updateInterval then
			self.timeSinceLastUpdate = 0

			self.text:SetText(dampeningText .. ": " .. C_Commentator.GetDampeningPercent() .. "%")
		end
	end)

	eventHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
	eventHandler:RegisterEvent("MERCHANT_SHOW")

	self:OnProfileChange()
end

function m:OnProfileChange()
  self:ShowGreetings(self.db.showGreetings)
  self:HideUIErrorsFrame(self.db.hideUIErrorsFrame)
  self:HideLootFrame(self.db.hideLootFrame)
	self:HideLossOfControlBackground(self.db.hideLOCBackground)	
	self:HideBags(self.db.hideBags)
	self:HideGlow(self.db.hideGlow)
	self:HideEffects(self.db.hideEffects)
  self:HideMapFade(self.db.hideMapFade)
  self:HideScriptErrors(self.db.hideScriptErrors)
end

-- Show dampening indicator in arenas only
function eventHandler:PLAYER_ENTERING_WORLD()
	self:SetShown(select(2, IsInInstance()) == "arena")
	if m.queuedPostureCheck then
		m.queuedPostureCheck = false
		C_Timer.After(5, m.PostureCheckCallback)
	end
end

-- Auto sell grey items
function eventHandler:MERCHANT_SHOW()
	totalPrice = 0
	for bags = 0, 4 do
		for slots = 1, GetContainerNumSlots(bags) do
			CurrentItemLink = GetContainerItemLink(bags, slots)
			if CurrentItemLink then
				_, _, itemRarity, _, _, _, _, _, _, _, itemSellPrice = GetItemInfo(CurrentItemLink)
				_, itemCount = GetContainerItemInfo(bags, slots)

				if itemRarity == 0 and itemSellPrice ~= 0 then
					totalPrice = totalPrice + (itemSellPrice * itemCount)
					UseContainerItem(bags, slots)
					PickupMerchantItem()
				end
			end
		end
	end

	if totalPrice ~= 0 then
		print("Sold your gray items for " .. GetCoinTextureString(totalPrice))
	end

	-- Repairs
	if (CanMerchantRepair()) then
		local cost = GetRepairAllCost()
		if cost > 0 then
			local money = GetMoney()
			if money > cost then
				RepairAllItems()
				print("Repairing all items for " .. GetCoinTextureString(cost))
			else
				print("Not enough gold to cover the repair cost.")
			end
		end
	end
end

function m:ShowGreetings(disabled)
	self.db.showGreetings = disabled
	if disabled then
		print("")
	else
		print("Welcome to |cff00ff00z|r|cff009cffUI|r use |CFFFAC025/zl|r for grids & |CFFFAC025/zr|r to reload.")
	end
end

function m:HideUIErrorsFrame(disabled)
	self.db.hideUIErrorsFrame = disabled
	if disabled then
		UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
	else
		UIErrorsFrame:RegisterEvent("UI_ERROR_MESSAGE")
	end
end

function m:HideLootFrame(disabled)
	self.db.hideLootFrame = disabled
	if disabled then
		AlertFrame:UnregisterEvent("LOOT_ITEM_ROLL_WON")
		AlertFrame:UnregisterEvent("SHOW_LOOT_TOAST")
		BossBanner:UnregisterEvent("ENCOUNTER_LOOT_RECEIVED")
		BossBanner:UnregisterEvent("BOSS_KILL")
	else
		AlertFrame:RegisterEvent("LOOT_ITEM_ROLL_WON")
		AlertFrame:RegisterEvent("SHOW_LOOT_TOAST")
		BossBanner:RegisterEvent("ENCOUNTER_LOOT_RECEIVED")
		BossBanner:RegisterEvent("BOSS_KILL")
	end
end

function m:HideLossOfControlBackground(hide)
	self.db.hideLOCBackground = hide
	LossOfControlFrame.blackBg:SetAlpha(hide and 0 or 1)
	LossOfControlFrame.RedLineTop:SetAlpha(hide and 0 or 1)
	LossOfControlFrame.RedLineBottom:SetAlpha(hide and 0 or 1)
end

function m:HideBags(hide)
	self.db.hideBags = hide
	MicroButtonAndBagsBar:SetShown(not hide)
end

function m:HideGlow(hide)
	self.db.hideGlow = hide
	SetCVar("ffxGlow", hide and 0 or 1)
end

function m:HideEffects(hide)
	self.db.hideEffects = hide
	SetCVar("ffxDeath", hide and 0 or 1)
	SetCVar("ffxNether", hide and 0 or 1)
end

function m:HideMapFade(hide)
	self.db.hideMapFade = hide
	SetCVar("mapFade", hide and 0 or 1)
end

function m:HideScriptErrors(hide)
	self.db.hideScriptErrors = hide
	SetCVar("scriptErrors", hide and 0 or 1)
end

m.defaultSettings = {
	showGreetings = false,
  hideUIErrorsFrame = true,
  hideLootFrame = true,
  hideLOCBackground = true,
  hideBags = true,
	hideGlow = true,
	hideEffects = true,
  hideMapFade = true,
  hideScriptErrors = true,
}

m.optionsTable = {
	showGreetings = {
		name = "Greetings",
    desc = "Disable chat greetings on login.",
		type = "toggle",
		width = "full",
		order = 1,
		set = function(info, val)
			m:ShowGreetings(val)
		end,
	},
  hideUIErrorsFrame = {
		name = "UI Errors",
		desc = "Disable errors like (Out of range spells, etc). This doesn't disable Quest Objectives!",
		type = "toggle",
		width = "full",
		order = 2,
		set = function(info, val)
			m:HideUIErrorsFrame(val)
		end,
	},
  hideLootFrame = {
		name = "Loot Frame",
		desc = "Disable annoying loot roll won and boss banner.",
		type = "toggle",
		width = "full",
		order = 3,
		set = function(info, val)
			m:HideLootFrame(val)
		end,
	},
	hideLOCBackground = {
		name = "Loss of Control Background",
		desc = "Hides the black background in \"Loss of Control Alerts\".",
		type = "toggle",
		width = "full",
		order = 4,
		set = function(info, val)
			m:HideLossOfControlBackground(val)
		end,
	},
	hideBags = {
		name = "Bag Micro Button",
    desc = "Hides bag micro button.",
		type = "toggle",
		width = "full",
		order = 5,
		set = function(info, val)
			m:HideBags(val)
		end,
	},
	hideGlow = {
		name = "Screen Glow Effect",
		desc = "Disable \"ffxGlow\", full screen glow effect.",
		type = "toggle",
		width = "full",
		order = 6,
		set = function(info, val)
			m:HideGlow(val)
		end,
	},
	hideEffects = {
		name = "Death Desaturation Effects",
		desc = "Disable effects such as \"blurry\" invisibility and death effect.",
		type = "toggle",
		width = "full",
		order = 7,
		set = function(info, val)
			m:HideEffects(val)
		end,
	},
  hideMapFade = {
    name = "Map Fade",
    desc = "Disable map fade while using the map.",
    type = "toggle",
    width = "full",
    order = 8,
    set = function(info, val)
      m:HideMapFade(val)
    end,
  },
  hideScriptErrors = {
    name = "LUA Script Errors",
    desc = "Enable showing of lua script errors.",
    type = "toggle",
    width = "full",
    order= 10,
    set = function(info, val)
      m:HideScriptErrors(val)
    end,
  },
}
