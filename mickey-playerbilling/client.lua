--[[Made by Mickeystix with love <3]]
QBCore = nil
Citizen.CreateThread(function() 
    while RepentzFW == nil do
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)
        Citizen.Wait(200)
    end
end)

RegisterNetEvent('mickey-playerbilling:client:BillCommand')
AddEventHandler('mickey-playerbilling:client:BillCommand', function(playerId, price)
    TriggerServerEvent("mickey-playerbilling:server:BillPlayer", playerId, tonumber(price))
    --TODO Convert below to or recreate it to receive money from someone rather than send it to them
    --TriggerServerEvent("gcPhone:transfer", playerId, price)
end)