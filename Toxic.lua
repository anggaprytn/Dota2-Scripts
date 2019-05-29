local Toxic =  {}
Toxic.tick = 999999
Toxic.option = Menu.AddOption({ "Utility", "Toxic Script"}, "Enable", "Auto GGWP")

function Toxic.OnDraw()
    if not Menu.IsEnabled(Toxic.option) then return end
    local myHero = Heroes.GetLocal()
    if not myHero then return end

	if Toxic.tick< GameRules.GetGameTime() then
		Engine.ExecuteCommand("chatwheel_say 76")
		Toxic.tick = 999999
	end
end


function Toxic.OnChatEvent(chatEvent)
	--Log.Write("type:"..chatEvent.type.." value:"..chatEvent.value)
	if chatEvent.type==0 and chatEvent.players[2] == Player.GetPlayerID(Players.GetLocal()) then
		Toxic.tick = GameRules.GetGameTime()+0.5
	end
	--Log.Write (#chatEvent.players..":"..chatEvent.players[1]..","..chatEvent.players[2]..","..chatEvent.players[3]..","..chatEvent.players[4]..","..chatEvent.players[5]..","..chatEvent.players[6])
end

return Toxic
