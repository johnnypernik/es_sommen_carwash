--DO-NOT-EDIT-BELLOW-THIS-LINE--
ESX 						= nil
PlayerData					= {}

Key = 38 -- ENTER

vehicleWashStation = {
	{25.83, -1391.86, 27.50}
}

Drawing = setmetatable({}, Drawing)
Drawing.__index = Drawing

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function ()
	Citizen.Wait(0)
	for i = 1, #vehicleWashStation do
		garageCoords = vehicleWashStation[i]
		stationBlip = AddBlipForCoord(garageCoords[1], garageCoords[2], garageCoords[3])
		SetBlipSprite(stationBlip, 100) -- 100 = carwash
		SetBlipAsShortRange(stationBlip, true)
	end
    return
end)

Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(0)
		if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then 
			for i = 1, #vehicleWashStation do
				garageCoords2 = vehicleWashStation[i]
				DrawMarker(1, garageCoords2[1], garageCoords2[2], garageCoords2[3], 0, 0, 0, 0, 0, 0, 5.0, 5.0, 2.0, 0, 157, 0, 155, 0, 0, 2, 0, 0, 0, 0)
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), garageCoords2[1], garageCoords2[2], garageCoords2[3], true ) < 10 then
					Drawing.draw3DText(garageCoords2[1], garageCoords2[2], garageCoords2[3] +1.0, 'Tryck på ~g~[E] ~w~för att tvätta bilen. Det kostar ~r~250Kr', 6, 0.2, 0.2, 255, 255, 255, 215)
					if IsControlJustPressed(1, Key) then
						ESX.UI.Menu.CloseAll()
					    ESX.UI.Menu.Open(
					        'default', GetCurrentResourceName(), 'tvat',
					        {
					            title    = 'Är du säker på att du vill tvätta din bil?',
					            align    = 'Center',
					            elements = { 
					                { label = 'Ja', value = 'ja' },
					                { label = 'Nej', value = 'nej' }
					            }
					        },
					    function(data, menu)
					        local value = data.current.value

					        if value == 'ja' then
					            TriggerServerEvent('es_carwash:checkmoney')
					            menu.close()
					        elseif value == 'nej' then
					        	menu.close()
					        end	
					    end,
					    function(data, menu)
					        menu.close()
					    end)   	
					end
				end
			end
		end
	end
end)

RegisterNetEvent('es_carwash:success')
AddEventHandler('es_carwash:success', function (price)
	local playerPed = GetVehiclePedIsUsing(GetPlayerPed(-1))
	local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
	SetEntityCoords(GetVehiclePedIsUsing(GetPlayerPed(-1)), 25.94, -1391.88, 27.97)
	SetEntityHeading(GetPlayerPed(-1), 90.02)
	FreezeEntityPosition(playerPed, true)
	DoScreenFadeOut(1000)
	Citizen.Wait(500)
	DoScreenFadeIn(1000)
	TriggerEvent('malte-cinema:activate')
	AttachCamToEntity(cam, playerPed, 2.0,4.5,3.0, true)
	SetCamRot(cam, -25.0,0.0,240.0)
	RenderScriptCams(true, false, 0, 1, 0)	
	TriggerServerEvent('es_sommen_carwash:sync', GetPlayerServerId(PlayerId()), 'vatten', 26.04, -1391.78, 29.95)
	TriggerServerEvent('es_sommen_carwash:sync', GetPlayerServerId(PlayerId()), 'vatten', 24.20, -1391.78, 29.95)
	TriggerServerEvent('es_sommen_carwash:sync', GetPlayerServerId(PlayerId()), 'vatten', 28.20, -1391.78, 29.95)
	TriggerEvent("pNotify:SendNotification",{
	    text = ('Bilen håller på att tvättas!'),
		type = "success",
		timeout = (5000),
		layout = "topCenter",
		queue = "global"
	})
    Citizen.Wait(15000)
	WashDecalsFromVehicle(GetVehiclePedIsUsing(GetPlayerPed(-1)), 1.0)
	SetVehicleDirtLevel(GetVehiclePedIsUsing(GetPlayerPed(-1)))
	TriggerEvent("pNotify:SendNotification",{
	    text = ('Din bil är nu REN!'),
		type = "error",
		timeout = (5000),
		layout = "bottomCenter",
		queue = "global"
	})
    DoScreenFadeOut(1000)
	Citizen.Wait(500)
	DoScreenFadeIn(1000)
	TriggerEvent('malte-cinema:activate')
	RenderScriptCams(false, false, 0, 1, 0)
	FreezeEntityPosition(playerPed, false)
end)

RegisterNetEvent('es_carwash:notenoughmoney')
AddEventHandler('es_carwash:notenoughmoney', function (moneyleft)
	TriggerEvent("pNotify:SendNotification",{
	    text = ("Du har inte tillräckligt med pengar! Du behöver " .. moneyleft .. " SEK!"),
		type = "error",
		timeout = (5000),
		layout = "bottomCenter",
		queue = "global"
	})	
end)

RegisterNetEvent('es_carwash:free')
AddEventHandler('es_carwash:free', function ()
	local playerPed = GetVehiclePedIsUsing(GetPlayerPed(-1))
	local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
	SetEntityCoords(GetVehiclePedIsUsing(GetPlayerPed(-1)), 25.94, -1391.88, 27.97)
	SetEntityHeading(GetPlayerPed(-1), 90.02)
	FreezeEntityPosition(playerPed, true)
	DoScreenFadeOut(1000)
	Citizen.Wait(500)
	DoScreenFadeIn(1000)
	TriggerEvent('malte-cinema:activate')
	AttachCamToEntity(cam, playerPed, 2.0,4.5,3.0, true)
	SetCamRot(cam, -25.0,0.0,240.0)
	RenderScriptCams(true, false, 0, 1, 0)	
	TriggerServerEvent('es_sommen_carwash:sync', GetPlayerServerId(PlayerId()), 'vatten', 26.04, -1391.78, 29.95)
	TriggerServerEvent('es_sommen_carwash:sync', GetPlayerServerId(PlayerId()), 'vatten', 24.20, -1391.78, 29.95)
	TriggerServerEvent('es_sommen_carwash:sync', GetPlayerServerId(PlayerId()), 'vatten', 28.20, -1391.78, 29.95)
	TriggerEvent("pNotify:SendNotification",{
	    text = ('Bilen håller på att tvättas!'),
		type = "success",
		timeout = (5000),
		layout = "topCenter",
		queue = "global"
	})
    Citizen.Wait(15000)
	WashDecalsFromVehicle(GetVehiclePedIsUsing(GetPlayerPed(-1)), 1.0)
	SetVehicleDirtLevel(GetVehiclePedIsUsing(GetPlayerPed(-1)))
	TriggerEvent("pNotify:SendNotification",{
	    text = ('Din bil är nu REN! Gratis!'),
		type = "error",
		timeout = (5000),
		layout = "bottomCenter",
		queue = "global"
	})
    DoScreenFadeOut(1000)
	Citizen.Wait(500)
	DoScreenFadeIn(1000)
	TriggerEvent('malte-cinema:activate')
	RenderScriptCams(false, false, 0, 1, 0)
	FreezeEntityPosition(playerPed, false)
end)

RegisterNetEvent('es_sommen_carwash:tvatt')
AddEventHandler('es_sommen_carwash:tvatt', function(ped, x, y, z)
		local Player = ped
		local PlayerPed = GetPlayerPed(GetPlayerFromServerId(ped))

		local particleDictionary = "core"
		local particleName = "exp_sht_steam"
		local animDictionary = 'mp_safehouseshower@male@'
		local animDictionary2 = 'mp_safehouseshower@female@'
		local animName = 'male_shower_idle_b'
		local animName2 = 'shower_idle_b'
		
		RequestNamedPtfxAsset(particleDictionary)

		while not HasNamedPtfxAssetLoaded(particleDictionary) do
			Citizen.Wait(0)
		end

		SetPtfxAssetNextCall(particleDictionary)
		
		local coords = GetEntityCoords(playerPed)
		local effect = StartParticleFxLoopedAtCoord(particleName, x, y, z+2.6, 0.0, 180.0, 0.0, 20.0, false, false, false, false)
		Wait(25)
		Wait(15000)
		DeleteEntity(prop)
		while not DoesParticleFxLoopedExist(effect) do
		Wait(5)
		end
		StopParticleFxLooped(effect, 0)
		Wait(25)
		StopParticleFxLooped(effect, 0)
		ClearPedTasks(PlayerPed)
		Wait(25)
		StopParticleFxLooped(effect, 0)
		SetPedWetnessHeight(PlayerPed, 1.0)
end)

function Drawing.draw3DText(x,y,z,textInput,fontId,scaleX,scaleY,r, g, b, a)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    SetTextColour(r, g, b, a)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

