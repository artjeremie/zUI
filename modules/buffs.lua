-- Player buff frame, let's make em big!
BuffFrame:SetScale(1.1)

-- Move debuff
hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", function()
	if DebuffButton1 then
		DebuffButton1:ClearAllPoints()
		DebuffButton1:SetPoint("TOP", UIParent, "TOPLEFT", 475, -215)
	end
end)

--[[
-- Debuff grow right
hooksecurefunc("DebuffButton_UpdateAnchors", function(bn,i)
  if i>1 then
    b=_G[bn..i]
    b:ClearAllPoints()
    if mod(i,8)==1 then
      b:SetPoint("TOP",_G[bn..(i-8)],"BOTTOM",0,-15)
    else
      b:SetPoint("LEFT",_G[bn..(i-1)],"RIGHT",5,0)
    end
  end
end)
--]]
