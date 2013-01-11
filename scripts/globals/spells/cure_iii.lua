-----------------------------------------
-- Spell: Cure III
-- Restores target's HP.
-- Shamelessly stolen from http://members.shaw.ca/pizza_steve/cure/Cure_Calculator.html
-----------------------------------------

require("scripts/globals/settings");
require("scripts/globals/status");
require("scripts/globals/magic");

-----------------------------------------
-- OnSpellCast
-----------------------------------------

function onSpellCast(caster,target,spell)
	local divisor = 0;
	local constant = 0;
	local basepower = 0;
	local power = 0;
	local basecure = 0;
	local final = 0;

	local minCure = 130;
	if(USE_OLD_CURE_FORMULA == true) then
		power = getCurePowerOld(caster);
		rate = 1;
		constant = 70;
		if(power > 300) then
				rate = 15.6666;
				constant = 180.43;
		elseif(power > 180) then
				rate = 2;
				constant = 115;
		end
	else
		power = getCurePower(caster);
		if(power < 125) then
			divisor = 2.2
			constant = 130;
			basepower = 70;
		elseif(power < 200) then
			divisor =  75/65;
			constant = 155;
			basepower = 125;
		elseif(power < 300) then
			divisor = 2.5;
			constant = 220;
			basepower = 200;
		elseif(power < 700) then
			divisor = 5;
			constant = 260;
			basepower = 300;
		else
			divisor = 999999;
			constant = 340;
			basepower = 0;
		end
	end

	if(target:getRank() ~= nil) then
		if(USE_OLD_CURE_FORMULA == true) then
			basecure = getBaseCure(power,divisor,constant);
		else
			basecure = getBaseCure(power,divisor,constant,basepower);
		end
		final = getCureFinal(caster,spell,basecure,minCure,false);
		if(caster:hasStatusEffect(EFFECT_AFFLATUS_SOLACE) and target:hasStatusEffect(EFFECT_STONESKIN) == false) then
			local solaceStoneskin = 0;
			local equippedBody = caster:getEquipID(SLOT_BODY);
			if(equippedBody == 11186) then
				solaceStoneskin = math.floor(final * 0.30);
			elseif(equippedBody == 11086) then
				solaceStoneskin = math.floor(final * 0.35);
			else
				solaceStoneskin = math.floor(final * 0.25);
			end
			target:addStatusEffect(EFFECT_STONESKIN,solaceStoneskin,0,25);
		end;
		final = final + (final * target:getMod(MOD_CURE_POTENCY_RCVD));
		local diff = (target:getMaxHP() - target:getHP());
		if(final > diff) then
			final = diff;
		end
		target:addHP(final);
		caster:updateEnmityFromCure(target,final);
	else
		if(target:isUndead()) then
			spell:setMsg(2);
			local dmg = calculateMagicDamage(130,1,caster,spell,target,HEALING_MAGIC_SKILL,MOD_MND,false);
			local resist = applyResistance(caster,spell,target,caster:getMod(MOD_MND)-target:getMod(MOD_MND),HEALING_MAGIC_SKILL,1.0);
			dmg = dmg*resist;
			dmg = addBonuses(caster,spell,target,dmg);
			dmg = adjustForTarget(target,dmg);
			dmg = finalMagicAdjustments(caster,target,spell,dmg);
			final = dmg;
			target:delHP(final);
			caster:updateEnmityFromDamage(target,final);
		else
			final = 0;
		end
	end
	return final;
end;