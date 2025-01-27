LinkLuaModifier("modifier_manhattan_energy_surge", "abilities/manhattan_energy_surge.lua", 0)

manhattan_energy_surge = class({})

function manhattan_energy_surge:GetBehavior() return self:GetCaster():HasScepter() and DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_NO_TARGET or DOTA_ABILITY_BEHAVIOR_UNIT_TARGET end

function manhattan_energy_surge:OnSpellStart()
    if IsServer() then
        if self:GetCaster():HasScepter() then
            for _, enemy in pairs(FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self:GetSpecialValueFor("cast_range"), self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), 0, false)) do
                enemy:AddNewModifier(self:GetCaster(), self, "modifier_knockback", {
                    center_x = enemy:GetAbsOrigin(),
                    center_y = enemy:GetAbsOrigin(),
                    center_z = enemy:GetAbsOrigin(),
                    duration = self:GetSpecialValueFor("stun_duration"),
                    knockback_duration = self:GetSpecialValueFor("stun_duration"),
                    knockback_height = 300
                })
                enemy:AddNewModifier(self:GetCaster(), self, "modifier_manhattan_energy_surge", {duration = self:GetSpecialValueFor("stun_duration")})
            end

            local particle = ParticleManager:CreateParticle("particles/manhattan_energy_surge.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
            ParticleManager:SetParticleControl(particle, 0, self:GetCaster():GetAbsOrigin())
            ParticleManager:SetParticleControl(particle, 1, Vector(self:GetSpecialValueFor("cast_range"), self:GetSpecialValueFor("cast_range"), self:GetSpecialValueFor("cast_range")))
            ParticleManager:SetParticleControl(particle, 11, Vector(self:GetSpecialValueFor("cast_range"), self:GetSpecialValueFor("cast_range"), self:GetSpecialValueFor("cast_range")))


        else
            self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_knockback", {
                center_x = self:GetCursorTarget():GetAbsOrigin(),
                center_y = self:GetCursorTarget():GetAbsOrigin(),
                center_z = self:GetCursorTarget():GetAbsOrigin(),
                duration = self:GetSpecialValueFor("stun_duration"),
                knockback_duration = self:GetSpecialValueFor("stun_duration"),
                knockback_height = 100
            })
            self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_manhattan_energy_surge", {duration = self:GetSpecialValueFor("stun_duration")})
        end
    end
end



modifier_manhattan_energy_surge = class({
    IsHidden = function() return true end,
    IsPurgable = function() return true end
})

function modifier_manhattan_energy_surge:OnCreated()
    self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("stun_duration"))

    local particle = ParticleManager:CreateParticle("particles/manhattan_energy_surge_1.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
    ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 1, Vector(128, 128, 128))
end

function modifier_manhattan_energy_surge:OnIntervalThink()
    if IsServer() then
        self:StartIntervalThink(-1)

        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf", PATTACH_ABSORIGIN, self:GetParent())
        ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())

        local int_mult = self:GetCaster():GetIntellect() * self:GetAbility():GetSpecialValueFor("int_mult")
        local mana_spend = int_mult + self:GetCaster():GetMana() / 100 * self:GetAbility():GetSpecialValueFor("mana_to_damage")

        self:GetParent():SpendMana(mana_spend, self:GetAbility())

        ApplyDamage({
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            damage = mana_spend + self:GetAbility():GetSpecialValueFor("base_damage"),
            damage_type = self:GetAbility():GetAbilityDamageType(),
            ability = self:GetAbility()
        })
    end
end
