-----------------------------------
-- Ability: Curing Waltz IV
-----------------------------------
 
require("scripts/globals/settings");
require("scripts/globals/status");

-----------------------------------
-- OnUseAbility
-----------------------------------

function OnUseAbility(player, target, ability)
	
	--Grabbing variables.
	local vit = target:getStat(MOD_VIT);
	local chr = player:getStat(MOD_CHR);
	local mjob = player:getMainJob(); --19 for DNC main.
	local cure = 0;

	--Performing mj check.
	if(mjob == 19) then
		cure = (vit+chr)+450;
	end

	--Reducing TP.
	local tp = player:getTP();
	tp = tp - 65;
	player:setTP(tp);

	--Applying server mods....
	cure = cure * CURE_POWER;

	--Cap the final amount to max HP.
	if((target:getMaxHP() - target:getHP()) < cure) then
		cure = (target:getMaxHP() - target:getHP());
	end
	
	--Do it
	target:addHP(cure);
	player:updateEnmityFromCure(target,cure*(240 / ( ( 31 * target:getMainLvl() / 50 ) + 6 )),cure*(40 / ( ( 31 * target:getMainLvl() / 50 ) + 6 )));
	
	return cure;
	
end;