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
    local typeEffect = EFFECT_DISEASE;
    if(target:hasStatusEffect(typeEffect) == false) then
         local statmod = MOD_INT;
        local resist = applyPlayerResistance(mob,skill,target,mob:getMod(statmod)-target:getMod(statmod),0,ELE_ICE);
        if(resist > 0.1) then
            skill:setMsg(MSG_ENFEEB_IS);
            target:addStatusEffect(typeEffect,1,0,180);--power=20;tic=0;duration=120;
        else
            skill:setMsg(MSG_MISS); -- resist !
        end
    else
        skill:setMsg(MSG_NO_EFFECT); -- no effect
    end
    return typeEffect;
end;