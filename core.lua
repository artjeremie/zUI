local addonName, zUI = ...

zUI.modules = {}

local eventHandler = CreateFrame("Frame", nil, UIParent)
eventHandler:SetScript("OnEvent", function(self, event, ...)
  return self[event](self, ...)
end)
eventHandler:RegisterEvent("ADDON_LOADED")

zUI.defaultSettings = {
  profile = {},
}

zUI.optionsTable = {
  name = "|cff00ff00z|r|cff009cffUI|r",
  type = "group",
  childGroups = "tab",
  validate = function()
    if InCombatLockdown() then
      return "You can't change settings while in combat!"
    else
      return true
    end
  end,
  args = {},
}

function zUI:CreateModule(m)
  self.modules[m] = {}
  return self.modules[m]
end

function zUI:OnProfileChange()
  for m, _ in pairs(self.modules) do
    self.modules[m].db = self.db.profile[m]
    if self.modules[m].OnProfileChange then
      self.modules[m]:OnProfileChange()
    end
  end
end

function eventHandler:ADDON_LOADED(addon)
  if addon ~= addonName then
    return
  end
  
  local i = 0
  for m, _ in pairs(zUI.modules) do
    zUI.optionsTable.args[m] = {
      name = m,
      type = "group",
      order = i,
      get = function(info)
        return zUI.modules[m].db[info[#info]]
      end,
      args = zUI.modules[m].optionsTable,
    }
    
    zUI.defaultSettings.profile[m] = zUI.modules[m].defaultSettings
    
    i = i + 1
  end
  
  zUI.db = LibStub("AceDB-3.0"):New("zUIDB", zUI.defaultSettings, true)
  zUI.optionsTable.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(zUI.db)
  LibStub("AceConfig-3.0"):RegisterOptionsTable("zUI", zUI.optionsTable)
  LibStub("AceConfigDialog-3.0"):AddToBlizOptions("zUI", "|cff00c0ffzUI|r")
  LibStub("AceConfigDialog-3.0"):SetDefaultSize("zUI", 400, 410)
  zUI.db.RegisterCallback(zUI, "OnProfileChanged", "OnProfileChange")
  zUI.db.RegisterCallback(zUI, "OnProfileCopied", "OnProfileChange")
  zUI.db.RegisterCallback(zUI, "OnProfileReset", "OnProfileChange")
  
  SLASH_ZUI1 = "/zu"
  SLASH_ZUI2 = "/zui"
  SlashCmdList["ZUI"] = function()
    LibStub("AceConfigDialog-3.0"):Open("zUI")
  end
  
  for m, _ in pairs(zUI.modules) do
    zUI.modules[m].db = zUI.db.profile[m]
    if zUI.modules[m].OnLoad then
      zUI.modules[m]:OnLoad()
    end
  end
end
