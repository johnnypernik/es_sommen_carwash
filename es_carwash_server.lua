--Settings--

enableprice = true -- true = carwash is paid, false = carwash is free

price = 250 -- you may edit this to your liking. if "enableprice = false" ignore this one

--DO-NOT-EDIT-BELLOW-THIS-LINE--

RegisterServerEvent('es_sommen_carwash:sync')
AddEventHandler('es_sommen_carwash:sync', function(player, sync, x, y, z)
	if sync == 'vatten' then
		TriggerClientEvent('es_sommen_carwash:tvatt', -1, player, x, y, z)
	end
end)

RegisterServerEvent('es_carwash:checkmoney')
AddEventHandler('es_carwash:checkmoney', function ()
	if enableprice == true then
		TriggerEvent('es:getPlayerFromId', source, function (user)
			userMoney = user.getMoney()
			if userMoney >= price then
				user.removeMoney(price)
				TriggerClientEvent('es_carwash:success', source, price)
			else
				moneyleft = price - userMoney
				TriggerClientEvent('es_carwash:notenoughmoney', source, moneyleft)
			end
		end)
	else
		TriggerClientEvent('es_carwash:free', source)
	end
end)
