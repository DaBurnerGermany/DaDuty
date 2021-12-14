local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}


--- action functions
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil


--- esx
ESX                           = nil
local PlayerData              = {}
local playerJob = nil 
local playerJob_main = nil 


local isInStampSpot = false
local currentStampSpot = nil
local messageSent = false



Citizen.CreateThread(function ()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
    PlayerData = ESX.GetPlayerData()
  end

  while PlayerData == nil do
    PlayerData = ESX.GetPlayerData()
    Citizen.Wait(0)
  end
end)

RegisterNetEvent('setduty:getPlayer')
AddEventHandler('setduty:getPlayer', function()
  PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  ESX.PlayerData.job = job
  PlayerData = ESX.GetPlayerData()
end)


Citizen.CreateThread(function()
	while true do
		if ESX ~= nil and ESX.PlayerData ~= nil and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name ~= nil and ESX.PlayerData.job.name ~= playerJob then
			playerJob = ESX.PlayerData.job.name
      playerJob_main = getJobName(ESX.PlayerData.job.name)
		end
		Citizen.Wait(1000)
	end
end)



RegisterNetEvent("DaDuty:notification")
AddEventHandler("DaDuty:notification", function(notificationtext)
	if Config.notifications.BtwLouis then
		TriggerEvent('notifications', '#07b95e', '', notificationtext)
	elseif Config.notifications.DefaultFiveM then
		SetNotificationTextEntry('STRING')
		AddTextComponentString(notificationtext)
		DrawNotification(false, true)
  elseif Config.notifications.Custom then
    --here your custom code...
  end

end)





-- draw markers
Citizen.CreateThread(function()
	while true do		
    
		Citizen.Wait(1)

    local SleepNoCfg = false


		local playerCoords = GetEntityCoords(PlayerPedId())
		local executeSleep = true


    if playerJob_main ~= nil then 

      local ped = PlayerPedId()
      local playerCoords = GetEntityCoords(ped)

      local jobSpots = Config.Jobs[playerJob_main]

      if jobSpots ~= nil then
        for key, spot in pairs(jobSpots) do
          local distance = Vdist(playerCoords, spot.x, spot.y, spot.z)
          if distance < Config.DrawDistance then
              DoDrawMarker(spot)
              executeSleep = false
          end
        end

        if executeSleep then
          Citizen.Wait(1000)
        end
      else
        SleepNoCfg = true
      end
    else
      SleepNoCfg = true
    end 

    if SleepNoCfg == true then
      Citizen.Wait(250)
    end
			

	end
end)


function getJobName(jobname)
  local offduty = IsOffDuty(jobname, Config.OffDutyPrefix)

  local retjobname = ""

  if offduty == true then
    retjobname = getInDutyName(jobname, Config.OffDutyPrefix)
  else
    retjobname = jobname
  end 

  return retjobname
end

function IsOffDuty(Jobname, Prefix)
  return string.sub(Jobname,1,string.len(Prefix))==Prefix
end
function getInDutyName(Jobname, Prefix)
  return string.sub(Jobname,1 + string.len(Prefix), string.len(Jobname))
end



function DoDrawMarker(spot)
  DrawMarker(
    30
    , spot.x
    , spot.y
    , spot.z
    , 0.0
    , 0.0
    , 0.0
    , 2.0
    , 2.0
    , 0.5
    , 0.6
    , 0.6
    , 0.6
    , 255 -- red of marker
    , 0-- green of marker
    , 0-- blue of marker
    , 255 -- alpha
    , false
    , true
    , 2
    , true
    , nil
    , nil
    , false
  )
end




-- show notification
Citizen.CreateThread(function()  
  while true do
      Citizen.Wait(350)

      isInStampSpot = false

      if playerJob_main ~= nil then 

        local ped = PlayerPedId()
        local playerCoords = GetEntityCoords(ped)

        local jobSpots = Config.Jobs[playerJob_main]

        if jobSpots ~= nil then
          for key, spot in pairs(jobSpots) do
            local distance = Vdist(playerCoords, spot.x, spot.y, spot.z)

            if distance <=  Config.EnteredMarkerDistance then
              isInStampSpot = true
              currentStampSpot = jobSpots[key]

              if not messageSent then
                messageSent = true
                TriggerEvent("DaDuty:notification", Translations[Config.Locale].go_inoff_duty)
              end
            end
          end 
        end 
      end 

      if not isInStampSpot then
        messageSent = false
        currentStampSpot = nil
      end
    end 
end)



Citizen.CreateThread(function()

  while true do
      Citizen.Wait(1)

      if isInStampSpot then
        local player = PlayerPedId()
          if not IsPedInAnyVehicle(player) then
            if IsControlJustPressed(0, Keys[Config.HotKey]) then
              TriggerServerEvent('DaDuty:go-onoff')
            end 
          end
      end
      
  end

end)