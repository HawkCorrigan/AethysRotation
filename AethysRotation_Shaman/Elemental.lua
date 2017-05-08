--- ============================ HEADER ============================
--- ======= LOCALIZE =======
  -- Addon
  local addonName, addonTable = ...;
  -- AethysCore
  local AC = AethysCore;
  local Cache = AethysCache;
  local Unit = AC.Unit;
  local Player = Unit.Player;
  local Target = Unit.Target;
  local Spell = AC.Spell;
  local Item = AC.Item;
  -- AethysRotation
  local AR = AethysRotation;
  -- Lua
  


--- ============================ CONTENT ============================
--- ======= APL LOCALS =======
  local Everyone = AR.Commons.Everyone;
  local Shaman = AR.Commons.Shaman;
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
    ElementalFocus                = Spell(16246),
    FireElemental                 = Spell(198067),
    FlameShock                    = Spell(188389),
    FrostShock                    = Spell(196840),
    LavaBurst                     = Spell(51505),
    LightningBolt                 = Spell(188196),
    PowerOfTheMaelstrom           = Spell(191861),
    Stormkeeper                   = Spell(205495),
    Thunderstorm                  = Spell(51490),
    -- Talents
    AncestralSwiftness            = Spell(192087),
    Ascendance                    = Spell(114050),
    AscendanceBuff                = Spell(114051),
    EarthgrabTotem                = Spell(51485),
    ElementalBlast                = Spell(117014),
    IceFury                       = Spell(210714),
    LightningRod                  = Spell(197209),
    LightningSurgeTotem           = Spell(192058),
    ResonanceTotem                = Spell(202192),
    TotemMastery                  = Spell(210643),
    -- Artifact
    SwellingMaelstrom             = Spell(238105),
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
    EchoesOfTheGreatSundering     = Spell(208722),
    -- Misc

    -- Macros
    Macros = {}
  };
  local S = Spell.Shaman.Elemental;
  -- Items
  if not Item.Shaman then Item.Shaman = {}; end
  Item.Shaman.Elemental = {
    -- Legendaries
    
  };
  local I = Item.Shaman.Elemental;
  -- Rotation Var
  
  -- GUI Settings
  local Settings = {
    General = AR.GUISettings.General,
    Commons = AR.GUISettings.APL.Shaman.Commons,
    Elemental = AR.GUISettings.APL.Shaman.Elemental
  };


-- ======= ACTION LISTS =======
  local function LightningRod()
  	--# Single Target Action Priority List for Lightning Rod Spec
    --actions.single_lr=flame_shock,if=!ticking|dot.flame_shock.remains<=gcd
    if S.FlameShock:IsCastable() and (not Target:Debuff(S.FlameShock) or Target:DebuffRemains(S.FlameShock)<1.5) then
      if AR.Cast(S.FlameShock) then return ""; end
    end
    --actions.single_lr+=/earthquake,if=buff.echoes_of_the_great_sundering.up&maelstrom>=86
    if S.Earthquake:IsCastable() and Player:Buff(S.EchoesOfTheGreatSundering) and Player:Maelstrom()>=86 then
      if AR.Cast(S.Earthquake) then return ""; end
    end
    --actions.single_lr+=/elemental_blast
    if S.ElementalBlast:IsCastable() then
      if AR.Cast(S.ElementalBlast) then return ""; end
    end
    --actions.single_lr+=/earth_shock,if=maelstrom>=117|!artifact.swelling_maelstrom.enabled&maelstrom>=92
    if S.EarthShock:IsCastable() and Player:Maelstrom()>=117 or ((not S.SwellingMaelstrom:ArtifactEnabled()) and Player:Maelstrom()>=92) then
      if AR.Cast(S.EarthShock) then return ""; end
    end
        --# Keep SK for large or soon add waves.
        --actions.single_lr+=/stormkeeper,if=raid_event.adds.count<3|raid_event.adds.in>50
        --actions.single_lr+=/liquid_magma_totem,if=raid_event.adds.count<3|raid_event.adds.in>50
    --actions.single_lr+=/lava_burst,if=dot.flame_shock.remains>cast_time&cooldown_react
    if S.LavaBurst:IsCastable() and Target:DebuffRemains(S.FlameShock)>1.5 then
      if AR.Cast(S.LavaBurst) then return ""; end
    end
    --actions.single_lr+=/flame_shock,if=maelstrom>=20&buff.elemental_focus.up,target_if=refreshable
    if S.FlameShock:IsCastable() and Player:Maelstrom()>=20 and Player:Buff(S.ElementalFocus) and Target:DebuffRemains(S.FlameShock)<=9 then
    	if AR.Cast(S.FlameShock) then return ""; end
    end
    --actions.single_lr+=/earth_shock,if=maelstrom>=111|!artifact.swelling_maelstrom.enabled&maelstrom>=86
    if S.EarthShock:IsCastable() and Player:Maelstrom()>=111 or ((not S.SwellingMaelstrom:ArtifactEnabled()) and Player:Maelstrom()>=86) then
      if AR.Cast(S.EarthShock) then return ""; end
    end
    --actions.single_lr+=/totem_mastery,if=buff.resonance_totem.remains<10
    if S.TotemMastery:IsCastable() and not Player:Buff(S.ResonanceTotem) then
      if AR.Cast(S.TotemMastery) then return ""; end
    end
    --# Use EQ on single target if you have a huge haste buff that increases haste above 50% and said buffs still last longer than 5 seconds OR two enemies.
    --actions.single_lr+=/earthquake,if=buff.echoes_of_the_great_sundering.up|artifact.seismic_storm.enabled&((active_enemies>1&spell_targets.chain_lightning>1)|spell_haste<=0.66&!(buff.bloodlust.up&buff.bloodlust.remains<5))
    --actions.single_lr+=/lightning_bolt,if=buff.power_of_the_maelstrom.up&spell_targets.chain_lightning<3,target_if=debuff.lightning_rod.down
    --actions.single_lr+=/lightning_bolt,if=buff.power_of_the_maelstrom.up&spell_targets.chain_lightning<3
    --actions.single_lr+=/chain_lightning,if=active_enemies>1&spell_targets.chain_lightning>1,target_if=debuff.lightning_rod.down
    --actions.single_lr+=/chain_lightning,if=active_enemies>1&spell_targets.chain_lightning>1
    --actions.single_lr+=/lightning_bolt,target_if=debuff.lightning_rod.down
    if S.LightningBolt:IsCastable() and Target:DebuffRemains(S.LightningRod)>0 then
      if AR.Cast(S.LightningBolt) then return ""; end
    end
    --actions.single_lr+=/lightning_bolt
    if S.LightningBolt:IsCastable() then
      if AR.Cast(S.LightningBolt) then return ""; end
    end
    --actions.single_lr+=/flame_shock,moving=1,target_if=refreshable
    if S.FlameShock:IsCastable() and GetUnitSpeed("player")>0 and Target:DebuffRemains(S.FlameShock)<9 then
      if AR.Cast(S.FlameShock) then return ""; end
    end
    --actions.single_lr+=/earth_shock,moving=1
    if S.EarthShock:IsCastable() and GetUnitSpeed("player")>0 then
      if AR.Cast(S.EarthShock) then return ""; end
    end
    --actions.single_lr+=/flame_shock,moving=1,if=movement.distance>6
    if S.FlameShock:IsCastable() and GetUnitSpeed("player")>0 then
      if AR.Cast(S.FlameShock) then return ""; end
    end
  end






  local function IceFury()
  	-- body
  end





  local function Ascendance()
    AC.GetEnemies(40);
    --# Single Target Action Priority List for Ascendance Spec
    --actions.single_asc=ascendance,if=dot.flame_shock.remains>buff.ascendance.duration&(time>=60|buff.bloodlust.up)&cooldown.lava_burst.remains>0&!buff.stormkeeper.up
    if S.Ascendance:IsCastable() and Target:DebuffRemains(S.FlameShock)>15 then
      if AR.Cast(S.Ascendance) then return ""; end
    end
    --actions.single_asc+=/flame_shock,if=!ticking|dot.flame_shock.remains<=gcd
    if S.FlameShock:IsCastable() and (not Target:Debuff(S.FlameShock) or Target:DebuffRemains(S.FlameShock)<1.5) then
      if AR.Cast(S.FlameShock) then return ""; end
    end
    --actions.single_asc+=/flame_shock,if=maelstrom>=20&remains<=buff.ascendance.duration&cooldown.ascendance.remains+buff.ascendance.duration<=duration
    if S.FlameShock:IsCastable() and Player:Maelstrom()>=20 and Target:DebuffRemains(S.FlameShock)<=15 and S.Ascendance:Cooldown()+15<=30 then
      if AR.Cast(S.FlameShock) then return ""; end
  end
    --actions.single_asc+=/elemental_blast
    if S.ElementalBlast:IsCastable() then
      if AR.Cast(S.ElementalBlast) then return ""; end
    end
    --actions.single_asc+=/earthquake,if=buff.echoes_of_the_great_sundering.up&!buff.ascendance.up&maelstrom>=86
    if S.Earthquake:IsCastable() and Player:Buff(S.EchoesOfTheGreatSundering) and (not Player:Buff(S.AscendanceBuff)) and Player:Maelstrom()>=86 then
      if AR.Cast(S.Earthquake) then return ""; end
    end
    --actions.single_asc+=/earth_shock,if=maelstrom>=117|!artifact.swelling_maelstrom.enabled&maelstrom>=92
    if S.EarthShock:IsCastable() and Player:Maelstrom()>=117 or ((not S.SwellingMaelstrom:ArtifactEnabled()) and Player:Maelstrom()>=92) then
      if AR.Cast(S.EarthShock) then return ""; end
    end
        --# Keep SK for large or soon add waves.
        --actions.single_asc+=/stormkeeper,if=raid_event.adds.count<3|raid_event.adds.in>50
        --actions.single_asc+=/liquid_magma_totem,if=raid_event.adds.count<3|raid_event.adds.in>50
    --actions.single_asc+=/lightning_bolt,if=buff.power_of_the_maelstrom.up&buff.stormkeeper.up&spell_targets.chain_lightning<3
    if S.LightningBolt:IsCastable() and Player:Buff(S.PowerOfTheMaelstrom) and Player:Buff(S.Stormkeeper) then
      if AR.Cast(S.LightningBolt) then return ""; end
    end
   --actions.single_asc+=/lava_burst,if=dot.flame_shock.remains>cast_time&(cooldown_react|buff.ascendance.up)
    if S.LavaBurst:IsCastable() and Target:DebuffRemains(S.FlameShock)>1.5 then
      if AR.Cast(S.LavaBurst) then return ""; end
    end
    --actions.single_asc+=/flame_shock,if=maelstrom>=20&buff.elemental_focus.up,target_if=refreshable
    if S.FlameShock:IsCastable() and Player:Maelstrom()>=20 and Player:Buff(S.ElementalFocus) and Target:DebuffRemains(S.FlameShock)<=9 then
      if AR.Cast(S.FlameShock) then return ""; end
    end
    --actions.single_asc+=/earth_shock,if=maelstrom>=111|!artifact.swelling_maelstrom.enabled&maelstrom>=86
    if S.EarthShock:IsCastable() and (Player:Maelstrom()>=111 or ((not S.SwellingMaelstrom:ArtifactEnabled()) and Player:Maelstrom()>=86)) then
      if AR.Cast(S.EarthShock) then return ""; end
    end
    --actions.single_asc+=/totem_mastery,if=buff.resonance_totem.remains<10|(buff.resonance_totem.remains<(buff.ascendance.duration+cooldown.ascendance.remains)&cooldown.ascendance.remains<15)
    if S.TotemMastery:IsCastable() and not (Player:Buff(S.ResonanceTotem) or Player:Buff(S.Ascendance)) then
      if AR.Cast(S.TotemMastery) then return ""; end
    end
    --actions.single_asc+=/earthquake,if=buff.echoes_of_the_great_sundering.up
    if S.Earthquake:IsCastable() and Player:Buff(S.EchoesOfTheGreatSundering) then
      if AR.Cast(S.Earthquake) then return ""; end
    end
    --actions.single_asc+=/lava_beam,if=active_enemies>1&spell_targets.lava_beam>1
    --actions.single_asc+=/lightning_bolt,if=buff.power_of_the_maelstrom.up&spell_targets.chain_lightning<3
    if S.LightningBolt:IsCastable() and Cache.EnemiesCount[40]<3 and Player:Buff(S.PowerOfTheMaelstrom) then
      if AR.Cast(S.LightningBolt) then return ""; end
    end
    --actions.single_asc+=/chain_lightning,if=active_enemies>1&spell_targets.chain_lightning>1
    if S.ChainLightning:IsCastable() and Cache.EnemiesCount[40]>1 then
      if AR.CastSuggested(S.ChainLightning) then return ""; end
    end
    --actions.single_asc+=/lightning_bolt
    if S.LightningBolt:IsCastable() then
      if AR.Cast(S.LightningBolt) then return ""; end
    end
    --actions.single_asc+=/flame_shock,moving=1,target_if=refreshable
    if S.FlameShock:IsCastable() and GetUnitSpeed("player")>0 and Target:DebuffRemains(S.FlameShock)<=9 then
      if AR.Cast(S.FlameShock) then return ""; end
    end
    --actions.single_asc+=/earth_shock,moving=1
    if S.EarthShock:IsCastable() and GetUnitSpeed("player")>0 then
      if AR.Cast(S.EarthShock) then return ""; end
    end
    --actions.single_asc+=/flame_shock,moving=1,if=movement.distance>6
    if S.FlameShock:IsCastable() and GetUnitSpeed("player")>0 then
      if AR.Cast(S.FlameShock) then return ""; end
    end
end

--- ======= MAIN =======
  local function APL ()
    -- Unit Update
    Everyone.AoEToggleEnemiesUpdate();
    -- Defensives
    
    -- Out of Combat
    if not Player:AffectingCombat() then
      -- Flask
      -- Food
      -- Rune
      -- PrePot w/ Bossmod Countdown
      -- Opener
      if Everyone.TargetIsValid() then
        
      end
      return;
    end
    -- In Combat
    if Everyone.TargetIsValid() then
      if S.Ascendance:IsAvailable() then
        ShouldReturn = Ascendance();
      end

      if S.LightningRod:IsAvailable() then
      	ShouldReturn = LightningRod();
      end

      if S.IceFury:IsAvailable() then
      	ShouldReturn = IceFury();
      end
    end
    if ShouldReturn then return ShouldReturn; end
    return ShouldReturn();
  end

  AR.SetAPL(262, APL);


--- ======= SIMC =======
--- Last Update: 12/31/2999

-- APL goes here
