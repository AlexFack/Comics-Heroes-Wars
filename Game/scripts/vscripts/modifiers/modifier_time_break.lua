if modifier_imba_chronosphere_ally_slow == nil then
	modifier_imba_chronosphere_ally_slow = class({})
end

function modifier_imba_chronosphere_ally_slow:OnCreated( kv )
	if IsServer() then
	end
end

function modifier_imba_chronosphere_ally_slow:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS
	}
	return funcs
end

function modifier_imba_chronosphere_ally_slow:GetModifierProjectileSpeedBonus()
	return -1200
end

function modifier_imba_chronosphere_ally_slow:IsHidden()
	return false
end