# zUI
![Curseforge](https://www.curseforge.com/wow/addons)

zUI is a lightweight modification of World of Warcraft Blizzard UI.

### Features
- **Actionbar**
  - Removed action bar gryphons.
  - Removed extra buttons background.
  - Disabled auto adding spell in action bar.
  - Option to move right action bar button to main bar.
  - Option to hide macro names.
  - Option to hide hotkeys.
  - Option to hide page arrow button.
  - Option to hide XP bar.
- **Queue Timer**
  - Shows time remaining in queue.
- **Castbar**
  - Show spell icon in left side of the cast bar.
  - Cast bar timer.
  - Adjust scale of cast bar for awareness.
    - Cast bar configuration in: *\World of Warcraft\_retail_\Interface\AddOns\zUI\modules\castbar.lua*.
    ```lua
    CastingBarFrame.Icon:SetSize(38, 38) -- line 8, scale.
    FocusFrameSpellBar:SetScale(1.50) -- line 41, focus scale.
    TargetFrameSpellBar:SetScale(1.50) -- line 42, target scale.
    CastingBarFrame.Icon:SetPoint("RIGHT", CastingBarFrame, "LEFT", -10, 5) -- line 9, move spell icon.
    CastingBarFrame.timer:SetPoint("LEFT", CastingBarFrame, "RIGHT", 5, 0) -- line 14, move spell timer.
    CastingBarFrame.timer:SetFont("FONTS\\FRIZQT__.TTF", 16, "THICKOUTLINE") -- line 13, change font.

    ```
- **Chat**
  - Abbreviated chat channels.
  - Disable tab flashing.
  - Chat fade hide.
  - Chat can now be move at the end of the screen.
  - Option to hide editbox background.
  - Option to hide Chat frame buttons/Voice button.
- **Coordinates**
  - Show coordinates and player position on mouseover at the top border of the map.
- **EasyDelete**
  - Add DELETE word when deleting valuable item.
- **Grid**
  - type `/zl` to overlay grid on-screen to aid in aligning the user interface.
- **Latency**
  - Shows `fps` and `latency`
    - Latency configuration in: *\World of Warcraft\_retail_\Interface\AddOns\zUI\modules\latency.lua*.
    ```lua
    zUILatency.text:SetPoint("CENTER", zUILatency) -- line 28, change position.
    zUILatency.text:SetFont("FONTS\\FRIZQT__.TTF", 11, "OUTLINE") -- line 29, change font.
    zUILatency.text:SetTextColor(color.r, color.g, color.b) -- line 30, change color.
    ```
- **Mail**
  - Show total gold collected from mail.
- **Nameplates**
  - Changed friendly player nameplate size.
  - Added health percentage.
    - Nameplates configuration in: *\World of Warcraft\_retail_\Interface\AddOns\zUI\modules\nameplate.lua*.
    ```lua
    C_NamePlate.SetNamePlateFriendlySize(90, 30) -- line 4, friendly player nameplate size.
    frame.health:SetSize(170, 16) -- line 16, percent text size.
    frame.health:SetPoint("CENTER", frame.healthBar) -- line 20, percent text position.
    frame.health.text:SetVertexColor(1, 1, 1) -- line 21, percent text color.
    frame.health.text:SetFont("FONTS\\FRIZQT__.TTF", 11, "OUTLINE") -- line 22, percent text font.
    ```
- **Tooltip**
  - Show target of target in tooltip
  - Tooltip configuration in : *\World of Warcraft\_retail_\Interface\AddOns\zUI\modules\tooltip.lua*.
  ```lua
  GameTooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -85, 50) -- line 55, move tooltip position.
  ```
- **Unitframes**
  - Transparent unitframe background.
  - Option to have class color frame.
  - Option to hide pvp icon.
  - Option to disable feedback text.
  - Option to show combat indicator icon.
  - Option to Set rare dragon in player portrait.
- **Others**
  - Move player debuff in: *\World of Warcraft\_retail_\Interface\AddOns\zUI\modules\buffs.lua*.
  ```lua
  DebuffButton1:SetPoint("TOP", UIParent, "TOPLEFT", 475, -215) -- line 8, move player debuff position.
  ```
