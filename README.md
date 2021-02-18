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
    - Set the cast bar scale in *\World of Warcraft\_retail_\Interface\AddOns\zUI\modules\castbar.lua*.
    - line 8 ```javascript
    CastingBarFrame.Icon:SetSize(38, 38)
    ``` for player.
    - line 41 and 42 `FocusFrameSpellBar:SetScale(1.50), TargetFrameSpellBar:SetScale(1.50)` for focus and target.
    - Move spell icon in line 9 `CastingBarFrame.Icon:SetPoint("RIGHT", CastingBarFrame, "LEFT", -10, 5)`.
    - Move spell timer in line 14 `CastingBarFrame.timer:SetPoint("LEFT", CastingBarFrame, "RIGHT", 5, 0)`.
    - Change font in line 13 `CastingBarFrame.timer:SetFont("FONTS\\FRIZQT__.TTF", 16, "THICKOUTLINE")`.
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
  - type /zl to overlay grid on-screen to aid in aligning the user interface.

