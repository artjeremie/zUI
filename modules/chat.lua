local _, zUI = ...
local m = zUI:CreateModule("Chat")

local eventHandler = CreateFrame("Frame", nil, UIParent)
eventHandler:SetScript("OnEvent", function(self, event, ...)
	return self[event](self, ...)
end)

function m:OnLoad()

	-- Enable arrow keys for normal and existing chat frames
	for i = 1, 50 do
		if _G["ChatFrame" .. i] then
			_G["ChatFrame" .. i .. "EditBox"]:SetAltArrowKeyMode(false)
		end
	end

	-- Lets make it short
	CHAT_SAY_GET = "[S] %s: "
	CHAT_YELL_GET = "[Y] %s: "
	CHAT_WHISPER_GET = "[F] %s: "
	CHAT_WHISPER_INFORM_GET = "[T] %s: "

	CHAT_FLAG_AFK = "[AFK] "
	CHAT_FLAG_DND = "[DND] "
	CHAT_FLAG_GM = "[GM] "

	CHAT_MONSTER_PARTY_GET = CHAT_PARTY_GET
	CHAT_MONSTER_SAY_GET = CHAT_SAY_GET
	CHAT_MONSTER_WHISPER_GET = CHAT_WHISPER_GET
	CHAT_MONSTER_YELL_GET = CHAT_YELL_GET

	local gsub = gsub
	local time = _G.time
	local newAddMsg = {}

	local rplc = {
		"[GEN]", --General
		"[T]", --Trade
		"[WD]", --WorldDefense
		"[LD]", --LocalDefense
		"[LFG]", --LookingForGroup
		"[GR]", --GuildRecruitment
		"[I]", --Instance
		"[IL]", --Instance Leader
		"[G]", --Guild
		"[P]", --Party
		"[PL]", --Party Leader
		"[PL]", --Party Leader (Guide)
		"[O]", --Officer
		"[R]", --Raid
		"[RL]", --Raid Leader
		"[RW]", --Raid Warning
		"[%1]", --Custom Channels
	}

	local chn = {
		"%[%d0?%. General.-%]",
		"%[%d0?%. Trade.-%]",
		"%[%d0?%. WorldDefense%]",
		"%[%d0?%. LocalDefense.-%]",
		"%[%d0?%. LookingForGroup%]",
		"%[%d0?%. GuildRecruitment.-%]",
		gsub(CHAT_INSTANCE_CHAT_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_INSTANCE_CHAT_LEADER_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_GUILD_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_PARTY_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_PARTY_LEADER_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_PARTY_GUIDE_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_OFFICER_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_RAID_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_RAID_LEADER_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_RAID_WARNING_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		-- Custom channels
		"%[(%d0?)%. (.-)%]",
	}

	local AddMessage = function(frame, text, ...)
		for i = 1, 17 do
			text = gsub(text, chn[i], rplc[i])
		end
		-- custom channels
		text = gsub(text, "%[(%d0?)%. .-%]", "[%1]")
		return newAddMsg[frame:GetName()](frame, text, ...)
	end

	for i = 1, 10 do
		local fcl = _G[format("%s%d", "ChatFrame", i)]
		--skip combatlog and frames with no messages registered
		if i ~= 2 then
			newAddMsg[format("%s%d", "ChatFrame", i)] = fcl.AddMessage
			fcl.AddMessage = AddMessage
		end
	end

	--Tab flasing
	FCF_FlashTab = function()
	end
	FCFTab_UpdateAlpha = function()
	end

	-- Chat fade hide
	CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
	CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0
	CHAT_FRAME_BUTTON_FRAME_MIN_ALPHA = 0
	for i = 1, 10 do
		local tab = _G[format("%s%d%s", "ChatFrame", i, "Tab")]
		tab:SetAlpha(0)
		tab.noMouseAlpha = 0
	end

	-- Chat editbox
	ChatFrame1EditBox:ClearAllPoints()
	ChatFrame1EditBox:SetPoint("BOTTOMLEFT", ChatFrame1, "TOPLEFT", -5, 2)
	ChatFrame1EditBox:SetPoint("RIGHT", ChatFrame1, 5, 0)

	-- Resize and move to end of screen
	for i = 1, 10 do
		local eb = _G[format("%s%d%s", "ChatFrame", i, "EditBox")]
		local cfs = _G[format("%s%d", "ChatFrame", i)]
		cfs:SetMinResize(100, 10)
		cfs:SetMaxResize(0, 0)
		cfs:SetClampRectInsets(0, 0, 0, 0)
		eb:SetAltArrowKeyMode(false)
	end

	self:HideEditBox(self.db.hideEditBox)
	self:HideChatFrameButtons(self.db.hideChatFrameButtons)
	self:DisableVoiceButton(self.db.disableVoiceButton)
end

function m:OnProfileChange()
	self:HideEditBox(self.db.hideEditBox)
	self:HideChatFrameButtons(self.db.hideChatFrameButtons)
	self:DisableVoiceButton(self.db.disableVoiceButton)
end

function m:HideEditBox(hide)
	self.db.hideEditBox = hide
	ChatFrame1EditBoxLeft:SetAlpha(hide and 0 or 1)
	ChatFrame1EditBoxMid:SetAlpha(hide and 0 or 1)
	ChatFrame1EditBoxRight:SetAlpha(hide and 0 or 1)
	ChatFrame1EditBox.focusLeft:SetAlpha(hide and 0 or 1)
	ChatFrame1EditBox.focusMid:SetAlpha(hide and 0 or 1)
	ChatFrame1EditBox.focusRight:SetAlpha(hide and 0 or 1)
end

function m:HideChatFrameButtons(hide)
	self.db.hideChatFrameButtons = hide
	ChatFrame1ButtonFrame:SetShown(not hide)
	ChatFrameMenuButton:SetShown(not hide)
	ChatFrameChannelButton:SetShown(not hide)
	QuickJoinToastButton:SetShown(not hide)
end

function m:DisableVoiceButton(disabled)
	self.db.disableVoiceButton = disabled
	if disabled then
		ChatFrameToggleVoiceDeafenButton:Hide()
	else
		ChatFrameToggleVoiceDeafenButton:Show()
	end
end

m.defaultSettings = {
	hideEditBox = true,
	hideChatFrameButtons = true,
	disableVoiceButton = true,
}

m.optionsTable = {
	hideEditBox = {
		name = "Edit Box",
    desc = "Hides edit box background.",
		type = "toggle",
		width = "full",
		order = 1,
		set = function(info, val)
			m:HideEditBox(val)
		end,
	},
	hideChatFrameButtons = {
		name = "Chat Buttons",
		desc = "Hides Chatbutton, QuickToast.",
		type = "toggle",
		width = "full",
		order = 2,
		set = function(info, val)
			m:HideChatFrameButtons(val)
		end,
	},
	disableVoiceButton = {
		name = "Voice Button",
    desc = "Hides chat voice button for cleaner look.",
		type = "toggle",
		width = "full",
		order = 3,
		set = function(info, val)
			m:DisableVoiceButton(val)
		end,
	},
}
