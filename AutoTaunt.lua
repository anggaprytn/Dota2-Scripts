local AutoTaunt = {
	OptionEnable = Menu.AddOption({"Anggaprytn", "Taunt Spam"}, "1. Enable", "Enable/Disable this script.")
}

local NextJob = 0
local MyHero = nil

function AutoTaunt.OnScriptLoad()
	NextJob = 0
	MyHero = nil
end

function AutoTaunt.OnGameEnd()
	NextJob = 0
	MyHero = nil
end

function AutoTaunt.OnUpdate()
	if Menu.IsEnabled(AutoTaunt.OptionEnable) == false then return end

	if MyHero == nil or MyHero ~= Heroes.GetLocal() then
		NextJob = 0
		MyHero = Heroes.GetLocal()
		
		return
	end

	if Entity.IsAlive(MyHero) then
		if NextJob < GameRules.GetGameTime() then
			Engine.ExecuteCommand("use_item_client current_hero taunt")
			
			NextJob = GameRules.GetGameTime() + 8.0
		end
	end
end

return AutoTaunt