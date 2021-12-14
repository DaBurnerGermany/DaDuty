Config = {}
Config.DrawDistance = 7.5
Config.Locale = 'en'
Config.EnteredMarkerDistance = 0.6

--[[
if set to config.createOffDutyOnStartUp = true -> start script and check for no server errors 
  -> if errors happen upgrade the Config.CreateWaittime and Retry

if config.createOffDutyOnStartUp = false
  -> insert data manually.. Prefix must be the same as Config.OffDutyPrefix
  f.e. Prefix = "off-" off-police , Prefix = "off" offpolice
]]--
Config.createOffDutyOnStartUp = true 
Config.CreateWaittime = 100     --waittime if your server log throws deadlock on startup of script
Config.OffDutySalery = 0
Config.OffDutyPrefix = "off-"
Config.OffDutyName = "Off-Duty"
Config.HotKey = "E"


Config.notifications = {
  DefaultFiveM = true,
  BtwLouis = false,
  Custom = false
}


Config.Jobs = {
  ["police"] = {
    {x = 444.53, y = -979.59, z = 30.69} --Mission Row PD
  }
  ,["ambulance"] = {
    {  x = -257.85, y = 6332.12, z = 32.43} --Pillbox-Hill MD
  }
}


Translations={
  ["de"] = {
    ["go_inoff_duty"] = "Drücke [E] um In/Außer Dienst zu gehen."
    ,["got_in_duty"] = "In Dienst gegangen."
    ,["got_off_duty"] = "Außer Dienst gegangen."
  }
  ,["en"] = {
    ["go_inoff_duty"] = "Press [E] to go off/in duty."
    ,["got_in_duty"] = "Entered service."
    ,["got_off_duty"] = "Went off-duty."
  }
}