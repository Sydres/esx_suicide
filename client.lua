ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

      ESX.PlayerData = ESX.GetPlayerData()
end)


function SuicideMenu()
    local elements ={
      {label = ('Suicide by pills'), value = 'pills'},
      {label = ('Suicide by gun'), value = 'gun'},
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'SuicideMenu', {
      title = 'Suicide Menu',
      align = 'top-left',
      elements = elements
    }, function(data,menu)
      local action = data.current.value
      local lib = 'mp_suicide'
      local playerPed = PlayerPedId()

      if action == 'pills' then
        menu.close()
        ESX.Streaming.RequestAnimDict(lib, function()
          TaskPlayAnim(playerPed, lib, 'pill', 8.0, -8.0, -1, 0, 0, false, false, false)
        end)
        Citizen.Wait(3500)
        SetEntityHealth(playerPed, 0)
      elseif action == 'gun' then
        menu.close()
        Gun()
      end

    end,
    function(data, menu)
      menu.close()
    end)
end

local validWeapons = {
	-- Pistols
	'WEAPON_PISTOL',
	'WEAPON_PISTOL_MK2',
	'WEAPON_COMBATPISTOL',
	'WEAPON_APPISTOL',
	'WEAPON_PISTOL50',
	'WEAPON_SNSPISTOL',
	'WEAPON_SNSPISTOL_MK2',
	'WEAPON_REVOLVER',
	'WEAPON_REVOLVER_MK2',
	'WEAPON_HEAVYPISTOL',
	'WEAPON_VINTAGEPISTOL',
	'WEAPON_MARKSMANPISTOL',

}

function Gun()
	Citizen.CreateThread(function()
		local playerPed = GetPlayerPed(-1)

		local canSuicide = false
		local foundWeapon = nil

		for i=1, #validWeapons do
			if HasPedGotWeapon(playerPed, GetHashKey(validWeapons[i]), false) then
				if GetAmmoInPedWeapon(playerPed, GetHashKey(validWeapons[i])) > 0 then
					canSuicide = true
					foundWeapon = GetHashKey(validWeapons[i])

					break
				end
			end
		end

		if canSuicide then
			if not HasAnimDictLoaded('mp_suicide') then
				RequestAnimDict('mp_suicide')

				while not HasAnimDictLoaded('mp_suicide') do
					Wait(1)
				end
			end

			SetCurrentPedWeapon(playerPed, foundWeapon, true)

			TaskPlayAnim(playerPed, "mp_suicide", "pistol", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )

			Wait(750)

			SetPedShootsAtCoord(playerPed, 0.0, 0.0, 0.0, 0)
			SetEntityHealth(playerPed, 0)
		end
	end)
end

RegisterCommand('suicidemenu', function()
  SuicideMenu()
end)
