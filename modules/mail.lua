local msgPre = "Gold collected from Mail! "
local zUIMail = CreateFrame("Frame")
local moneyInMail = 0
local moneyOverall = 0

zUIMail:RegisterEvent("MAIL_SHOW")
zUIMail:RegisterEvent("CLOSE_INBOX_ITEM")
zUIMail:RegisterEvent("MAIL_CLOSED")

zUIMail:SetScript("OnEvent", function(self, event, ...)
  if event == "MAIL_SHOW" then
    moneyCurrent = GetMoney()
  elseif event == "CLOSE_INBOX_ITEM" then
    C_Timer.After(0.5, function()
      moneyNew = GetMoney()
      if moneyNew ~= moneyCurrent then
        moneyInMail = moneyNew - moneyCurrent
        moneyOverall = moneyOverall + moneyInMail
        moneyCurrent = GetMoney()
      end
    end)
  elseif event == "MAIL_CLOSED" then
    C_Timer.After(1, function()
      if moneyOverall > 0 then
        print(msgPre .. GetCoinTextureString(moneyOverall))
        moneyInMail = 0
        moneyOverall = 0
      end
    end)
  end
end)
