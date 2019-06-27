local HakeForFun = {}
local KostyaUtils = require("KostyaUtils/Utils")
HakeForFun.TrigerActiv                  = Menu.AddOption({"Anggaprytn","hake Fun"}, "00) On / Off script", "")
HakeForFun.TrigerActivHigh_Five         = Menu.AddOption({"Anggaprytn","hake Fun"}, "01) High Five On / Off", "")

HakeForFun.myHero = nil

function HakeForFun.OnUpdate()
    HakeForFun.CanWork = false
    if not Menu.IsEnabled(HakeForFun.TrigerActiv) or not Engine.IsInGame() or not Heroes.GetLocal() then return end
    if not HakeForFun.myHero or not NPCs.Contains(HakeForFun.myHero) or HakeForFun.myHero ~= Heroes.GetLocal() then
        HakeForFun.myHero = Heroes.GetLocal()
    end
    if (HakeForFun.myHero and not NPCs.Contains(HakeForFun.myHero)) or not HakeForFun.myHero then return end
    HakeForFun.High_Five()
    HakeForFun.CanWork = true
end

function HakeForFun.High_Five()
    if not Entity.IsAlive(HakeForFun.myHero) then return end
    local ability = NPC.GetAbility(HakeForFun.myHero, "high_five")
    if not KostyaUtils.CanUseSkill(HakeForFun.myHero, ability) then return end
    local findFriend = false
    local radius = Ability.GetLevelSpecialValueForFloat(ability, "acknowledge_range")
    local heroes = Heroes.InRadius(Entity.GetAbsOrigin(HakeForFun.myHero), radius, Entity.GetTeamNum(HakeForFun.myHero), Enum.TeamType.TEAM_BOTH)
    if not heroes then return end
    for i,j in pairs(heroes) do
        if j and Heroes.Contains(j) and Entity.IsAlive(j) and NPC.HasModifier(j, "modifier_high_five_requested") then
            findFriend = true
        end
    end
    if not findFriend then return end
    Ability.CastNoTarget(ability)
end

function HakeForFun.init()

end
function HakeForFun.OnGameStart()
    HakeForFun.init() 
end
function HakeForFun.OnGameEnd()
    HakeForFun.init()
end
HakeForFun.init()

return HakeForFun
