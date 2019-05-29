local Blocker = {}

Blocker.Key = Menu.AddKeyOption({"Utility"}, "Creep Blocker", Enum.ButtonCode.KEY_SPACE)
local lastStop = 0
local sleep = 0
local camera = false

function Blocker.OnUpdate()
    local myHero = Heroes.GetLocal()
    if not myHero then return end
    if not Menu.IsKeyDown(Blocker.Key) then return end
    local creeps = NPC.GetUnitsInRadius(myHero, 500, Enum.TeamType.TEAM_FRIEND)
    local myOrigin = Entity.GetAbsOrigin(myHero)
    local movePosition = nil
    local distanceNum = 500
    for i, npc in ipairs(creeps) do
        if NPC.IsCreep(npc) and not Entity.IsDormant(npc) and Entity.IsAlive(npc) then
            local creepOrigin = Entity.GetAbsOrigin(npc)
            local movesTo = Blocker.GetPredictedPosition(npc, 0.66)
            local distance = (myOrigin - creepOrigin):Length()
            if distance <= distanceNum and NPC.IsRunning(npc) then
                movePosition = movesTo
                distanceNum = distance
            end
        end
    end
    if movePosition then
        if os.clock() > sleep then
            Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION, myHero, movePosition, nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_HERO_ONLY)
        end
        local distance2 = (movePosition - myOrigin):Length()
        local speed = Blocker.GetMoveSpeed(myHero)
        if os.clock() >= lastStop and distance2 >= 10 and distance2 <= 150 then
            lastStop = getRandomNumber(0.25, 0.5)
            sleep = getRandomNumber(0.05, 0.2)
            Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_STOP, myHero, movePosition, nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_HERO_ONLY)
        end
    end
end

function Blocker.GetPredictedPosition(npc, delay)
    local pos = Entity.GetAbsOrigin(npc)
    if not NPC.IsRunning(npc) or not delay then return pos end
    local totalLatency = (NetChannel.GetAvgLatency(Enum.Flow.FLOW_INCOMING) + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING))
    delay = delay + totalLatency
    local dir = Entity.GetRotation(npc):GetForward():Normalized()
    local speed = Blocker.GetMoveSpeed(npc)
    return pos + dir:Scaled(speed * delay)
end

function Blocker.GetMoveSpeed(npc)
    local baseSpeed = NPC.GetBaseSpeed(npc)
    local bonusSpeed = NPC.GetMoveSpeed(npc) - NPC.GetBaseSpeed(npc)
    return baseSpeed + bonusSpeed
end

function getRandomNumber(min, max)
    return math.floor(math.random() * (max - min + 0.05) ) + min + os.clock()
end

return Blocker
