--[[Made by Mickeystix with love <3]]
QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local cutRates = Config.CutScale

RegisterServerEvent('mickey-playerbilling:server:BillPlayer')
AddEventHandler('mickey-playerbilling:server:BillPlayer', function(playerId, price)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local OtherPlayer = QBCore.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "doctor" then
        if OtherPlayer ~= nil then
            OtherPlayer.Functions.RemoveMoney("bank", price, "paid-medical-bills")
            TriggerClientEvent('QBCore:Notify', OtherPlayer.PlayerData.source, "You have received a Medical Bill for $"..price)
            payOutEMS(src, playerId, price)
        end
    end
end)

QBCore.Commands.Add("mbill", "Send a Medical bill to the player", {{name="id", help="Player ID"},{name="price", help="Bill price"}}, true, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "doctor" or Player.PlayerData.job.name == "ambulance" then
        local playerId = tonumber(args[1])
        local price = tonumber(args[2])
        if price > 0 then
            TriggerClientEvent("mickey-playerbilling:client:BillCommand", source, playerId, price)
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Price must be higher than 0")
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "This command is for Medical services!")
    end
end)


function payOutEMS(source, playerId, price)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Grade = Player.PlayerData.job.grade.level
    local OtherPlayer = QBCore.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "doctor" then
        local cutAmount = math.floor((price * cutRates[tonumber(Grade)].rate)+0.5)
        local rate = cutRates[Grade].rate * 100
        TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, "You have received "..rate.."%: $"..cutAmount)
        Player.Functions.AddMoney("bank", cutAmount, "received-medbill-cut")
    end
end