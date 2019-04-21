if not ares_shadow_realm then ares_shadow_realm = class({}) end

function ares_shadow_realm:OnAbilityPhaseStart()
  if IsServer() then
    self.vLoc = self:GetCaster():GetCursorPosition()
  end
  return true
end

function ares_shadow_realm:OnSpellStart()
	local radius = self:GetSpecialValueFor( "radius" )

  self:GetCaster():SetAbsOrigin(self.vLoc)
  FindClearSpaceForUnit(self:GetCaster(), self.vLoc, true)

	local nFXIndex = ParticleManager:CreateParticle( "particles/hero_ares/ares_shadow_realm_ground.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( nFXIndex, 0,  self:GetCaster():GetAbsOrigin())
  ParticleManager:SetParticleControl( nFXIndex, 1,  Vector(500, 1, 0))
  ParticleManager:SetParticleControl( nFXIndex, 3,  self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex( nFXIndex )

  local nearby_units = FindUnitsInRadius (self:GetCaster():GetTeam(), self:GetCaster():GetAbsOrigin (), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
  for i, target in ipairs (nearby_units) do  --Restore health and play a particle effect for every found ally.
      ApplyDamage ( { victim = target, attacker = self:GetCaster(), ability = self, damage = self:GetAbilityDamage(), damage_type = DAMAGE_TYPE_PURE})
  end

	EmitSoundOn( "Hero_Sylph.Shadow_Realm", self:GetCaster() )
end
