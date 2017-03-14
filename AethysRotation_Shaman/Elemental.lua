--- Localize Vars
-- Addon
local addonName, addonTable = ...;
-- AethysCore
local AC = AethysCore;
local Cache = AethysCore_Cache;
local Unit = AC.Unit;
local Player = Unit.Player;
local Target = Unit.Target;
local Spell = AC.Spell;
local Item = AC.Item;
-- AethysRotation
local AR = AethysRotation;
-- Lua
local pairs = pairs;


--- APL Local Vars
-- Spells
  if not Spell.Shaman then Spell.Shaman = {}; end
  Spell.Shaman.Elemental = {
    -- Racials
    ArcaneTorrent                 = Spell(25046),
    Berserking                    = Spell(26297),
    BloodFury                     = Spell(20572),
    GiftoftheNaaru                = Spell(59547),
    Shadowmeld                    = Spell(58984),
    -- Abilities
    ChainLightning                = Spell(188443),
    EarthShock                    = Spell(8042),
    Earthquake                    = Spell(61882),
    EarthElemental                = Spell(198103),
    ElementalFocus                = Spell(16164),
    FireElemental                 = Spell(198067),
    FlameShock                    = Spell(188389),
    FrostShock                    = Spell(196840),
    LavaBurst                     = Spell(51505),
    LightningBolt                 = Spell(188196),
    Stormkeeper                   = Spell(205495),
    Thunderstorm                  = Spell(51490),
    -- Talents
    AncestralSwiftness            = Spell(192087),
    Ascendance                    = Spell(114049),
    AscendanceBuff                = Spell(114051),
    EarthgrabTotem                = Spell(51485),
    ElementalBlast                = Spell(117014),
    LighningSurgeTotem            = Spell(192058),
    -- Artifact
    -- Defensive
    AstralShift                   = Spell(108271),
    HealingSurge                  = Spell(188070),
    -- Utility
    CleanseSpirit                 = Spell(51886),
    GhostWolf                     = Spell(2645),
    Hex                           = Spell(51514),
    Purge                         = Spell(370),
    Reincarnation                 = Spell(20608),
    SpiritWalk                    = Spell(58875),
    WaterWalking                  = Spell(546),
    WindShear                     = Spell(57994),
    -- Legendaries
    -- Misc

    -- Macros
    Macros = {}
    };
    local S = Spell.Shaman.Elemental;

    --Items 
    if not Item.Shaman then Item.Shaman = {}; end
    Item.Shaman.Elemental = {
        --Legendaries
    };
    local I = Item.Shaman.Elemental;

-- GUI Settings
  local Settings = {
    General = AR.GUISettings.General,
    Elemental = AR.GUISettings.APL.Shaman.Elemental
  };

-- Storm Tempests Nameplate cleave



--Cooldowns

--AOE

-- APL Main
local function APL ()
  -- Unit Update
  AC.GetEnemies(40); 
  --- Out of Combat
  if not Player:AffectingCombat() then
      -- Flask
      -- Food
      -- Rune
      -- PrePot w/ Bossmod Countdown
      -- Opener
  end

  --- Interrupts 
    if Settings.General.InterruptEnabled and Target:IsInterruptible() and Target:IsInRange(30) then
        if S.WindShear:IsCastable() then 
            if AR.Cast(S.WindShear, Settings.Enhancement.OffGCDasOffGCD.WindShear) then return "Cast"; end
        end
    end

  --- Legendaries


  --- In Combat
  			-- Off GCD

    if Target:Exists() and Target:IsInRange(40) and not Target:IsDeadOrGhost() then
            
        --# Single Target Action Priority List for Ascendance Spec
        --actions.ptr_single_asc=ascendance,if=dot.flame_shock.remains>buff.ascendance.duration&(time>=60|buff.bloodlust.up)&cooldown.lava_burst.remains>0&!buff.stormkeeper.up
        --if S.Ascendence:IsCastable() and Target.DebuffRemains(S.FlameShock)>Player.BuffRemains(S.Ascendance) and (time?>=60 or Player.Buff(Ascendance)) and S.LavaBurst:Cooldown()>0 and not Player.Buff(Stormkeeper)) then
        --    if AR.Cast(S.Ascendance) then return "Cast Ascendance"; end
        --actions.ptr_single_asc+=/flame_shock,if=!ticking|dot.flame_shock.remains<=gcd
        if S.FlameShock:IsCastable() and (not Target:Debuff(S.FlameShock) or Target:DebuffRemains(S.FlameShock) < 1.5) then
            if AR.Cast(S.FlameShock) then return "Cast Flame Shock"; end
        end
        --actions.ptr_single_asc+=/flame_shock,if=maelstrom>=20&remains<=buff.ascendance.duration&cooldown.ascendance.remains+buff.ascendance.duration<=duration
        if S.FlameShock:IsCastable() and Player:Maelstrom()>=20 and Target:DebuffRemains(S.FlameShock) <= Player:BuffRemains(S.Ascendance) and S.Ascendance:Cooldown()+Player:BuffRemains(S.Ascendance)<=Target:DebuffRemains(FlameShock)    then
            if AR.Cast(S.FlameShock) then return "Cast FlameShock"; end
        end
        --actions.ptr_single_asc+=/earthquake,if=buff.echoes_of_the_great_sundering.up&!buff.ascendance.up&maelstrom>=86
        --if S.Earthquake:IsCastable and Player:Maelstrom()>=86 and Player.Buff(S.Sundering)
        --  if AR.Cast(S.Earthquake) then return "Cast Earthquake"; end
        --end
        --actions.ptr_single_asc+=/earth_shock,if=maelstrom>=117|!artifact.swelling_maelstrom.enabled&maelstrom>=92
        if S.EarthShock:IsCastable() and Player:Maelstrom()>=92 then
            if AR.Cast(S.EarthShock) then return "Cast Earth Shock"; end
        end
        --# Keep SK for large or soon add waves.
        --actions.ptr_single_asc+=/stormkeeper,if=raid_event.adds.count<3|raid_event.adds.in>50
        --actions.ptr_single_asc+=/elemental_blast
        if S.ElementalBlast:IsCastable() then
            if AR.Cast(S.ElementalBlast) then return "Cast Elemental Blast"; end
        end
        --actions.ptr_single_asc+=/liquid_magma_totem,if=raid_event.adds.count<3|raid_event.adds.in>50
        --actions.ptr_single_asc+=/lightning_bolt,if=buff.power_of_the_maelstrom.up&buff.stormkeeper.up&spell_targets.chain_lightning<3
        --actions.ptr_single_asc+=/lava_burst,if=dot.flame_shock.remains>cast_time&(cooldown_react|buff.ascendance.up)
        if S.LavaBurst:IsCastable() and Target:DebuffRemains(S.FlameShock)>2.5 and (true or Player:Buff(Ascendance)) then
            if AR.Cast(S.LavaBurst) then return "Cast Lava Burst"; end
        end
        --actions.ptr_single_asc+=/flame_shock,if=maelstrom>=20&buff.elemental_focus.up,target_if=refreshable
        if S.FlameShock:IsCastable() and Player:Maelstrom()>=20 and --[[Player:Buff(ElementalFocus) and]] Target:DebuffRemains(S.FlameShock) < 9 then
            if AR.Cast(S.FlameShock) then return "Cast FlameShock"; end
        end
        --actions.ptr_single_asc+=/earth_shock,if=maelstrom>=111|!artifact.swelling_maelstrom.enabled&maelstrom>=86
        if S.EarthShock:IsCastable()  and Player:Maelstrom()>=86 then
            if AR.Cast(S.EarthShock) then return "Cast Earth Shock"; end
        end
        --actions.ptr_single_asc+=/totem_mastery,if=buff.resonance_totem.remains<10|(buff.resonance_totem.remains<(buff.ascendance.duration+cooldown.ascendance.remains)&cooldown.ascendance.remains<15)
        --actions.ptr_single_asc+=/earthquake,if=buff.echoes_of_the_great_sundering.up
        --if S.Earthquake:IsCastable() and Player.Buff(S.Sundering) then
        --    if AR.Cast(S.Earthquake) then return "Cast Earthquake"; end
        --end
        --actions.ptr_single_asc+=/lava_beam,if=active_enemies>1&spell_targets.lava_beam>1
        --actions.ptr_single_asc+=/lightning_bolt,if=buff.power_of_the_maelstrom.up&spell_targets.chain_lightning<3
        --actions.ptr_single_asc+=/chain_lightning,if=active_enemies>1&spell_targets.chain_lightning>1
        --actions.ptr_single_asc+=/lightning_bolt
        if S.LightningBolt:IsCastable() then
            if AR.Cast(S.LightningBolt) then return "Cast Lightning Bolt"; end
        end
        --actions.ptr_single_asc+=/flame_shock,moving=1,target_if=refreshable
        --actions.ptr_single_asc+=/earth_shock,moving=1
        --actions.ptr_single_asc+=/flame_shock,moving=1,if=movement.distance>6
        

    end
end

AR.SetAPL(262, APL);