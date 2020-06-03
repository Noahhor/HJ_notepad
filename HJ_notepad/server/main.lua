local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","HJ_notepad")

local savedNotes = {

  
}

TriggerEvent('server:LoadsNote')


--#Delete comments to use from inventory
-- ESX.RegisterUsableItem('notepad', function(source)
--   local _source  = source
--   local xPlayer   = ESX.GetPlayerFromId(_source)
--   TriggerClientEvent('HJ_notepad:note', _source)
--   TriggerClientEvent('HJ_notepad:OpenNotepadGui', _source)
-- end)

RegisterCommand("Note", function(source, args, rawCommand)
  local _source = source
  local user_id = vRP.getUserId({source})
  local item    = vRP.hasInventoryItem({user_id,"HJ_notepad",1})
if item then
    TriggerClientEvent('HJ_notepad:note', _source)
    TriggerClientEvent('HJ_notepad:OpenNotepadGui', _source)
    TriggerEvent('server:LoadsNote')
else
  vRPclient.notify(player,{"Du har ingen notepad"})
end
    
end)


RegisterNetEvent("server:LoadsNote")
AddEventHandler("server:LoadsNote", function()
   TriggerClientEvent('HJ_notepad:updateNotes', -1, savedNotes)
end)

RegisterNetEvent("server:newNote")
AddEventHandler("server:newNote", function(text, x, y, z)
      local import = {
        ["text"] = ""..text.."",
        ["x"] = x,
        ["y"] = y,
        ["z"] = z,
      }
      table.insert(savedNotes, import)
      TriggerEvent("server:LoadsNote")
end)

RegisterNetEvent("server:updateNote")
AddEventHandler("server:updateNote", function(noteID, text)
  savedNotes[noteID]["text"]=text
  TriggerEvent("server:LoadsNote")
end)

RegisterNetEvent("server:destroyNote")
AddEventHandler("server:destroyNote", function(noteID)
  table.remove(savedNotes, noteID)
  TriggerEvent("server:LoadsNote")
end)

