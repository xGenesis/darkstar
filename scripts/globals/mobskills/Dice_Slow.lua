---------------------------------------------
--  Goblin Dice
--
--  Description: Stun
--  Type: Physical (Blunt)
--
--
---------------------------------------------
require("/scripts/globals/settings");
require("/scripts/globals/status");
require("/scripts/globals/monstertpmoves");
---------------------------------------------
function OnMobSkillCheck(target,mob,skill)
    return 0;
end;

function OnMobWeaponSkill(target, mob, skill)
    local slowed = false;
    local sleeped = false;

    local typeEffect = EFFECT_SLOW;
    if(target:hasStatusEffect(typeEffect) == false) then
        local statmod = MOD_INT;
        local resist = applyPlayerResistance(mob,skill,target,mob:getMod(statmod)-target:getMod(statmod),0,ELE_ICE);
        if(resist > 0.1) then
            slowed = true;
            skill:setMsg(MSG_ENFEEB_IS);
            target:delStatusEffect(EFFECT_HASTE);
            target:addStatusEffect(typeEffect,25,0,120);--power=20;tic=0;duration=120;
        end
    else
        skill:setMsg(MSG_NO_EFFECT); -- no effect
    end

    if(target:hasStatusEffect(EFFECT_SLEEP_I) == false) then

        local statmod = MOD_INT;
        local resist = applyPlayerResistance(mob,skill,target,mob:getMod(statmod)-target:getMod(statmod),0,ELE_DARK);
        if(resist > 0.1) then
            sleeped = true;
            target:addStatusEffect(EFFECT_SLEEP_I,1,0,math.random(20,30));--power=20;tic=0;duration=120;
        end
    end

    skill:setMsg(MSG_ENFEEB_IS);
    if(sleeped) then
        return EFFECT_SLEEP_I;
    else if(slowed) then
        return EFFECT_SLOW;
    else
        skill:setMsg(MSG_MISS); -- no effect
    end

    return typeEffect;
end;