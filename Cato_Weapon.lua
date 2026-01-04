Cato_Weapon = {
   canHide = false, canPosition = false, canPreview = false,
   userData = {},
}

function Cato_Weapon:init()
   self:createConsoleVariable('debug', 'int', 0)
   self:createConsoleVariable('text_time_1_equip', 'float', 3.000000) -- melee
   self:createConsoleVariable('text_time_1_shoot', 'float', 3.000000) -- melee
   self:createConsoleVariable('text_time_2_equip', 'float', 3.000000) -- burst
   self:createConsoleVariable('text_time_2_shoot', 'float', 3.000000) -- burst
   self:createConsoleVariable('text_time_3_equip', 'float', 3.000000) -- shotgun
   self:createConsoleVariable('text_time_3_shoot', 'float', 3.000000) -- shotgun
   self:createConsoleVariable('text_time_4_equip', 'float', 3.000000) -- grenade
   self:createConsoleVariable('text_time_4_shoot', 'float', 3.000000) -- grenade
   self:createConsoleVariable('text_time_5_equip', 'float', 3.000000) -- plasma
   self:createConsoleVariable('text_time_5_shoot', 'float', 3.000000) -- plasma
   self:createConsoleVariable('text_time_6_equip', 'float', 3.000000) -- rocket
   self:createConsoleVariable('text_time_6_shoot', 'float', 3.000000) -- rocket
   self:createConsoleVariable('text_time_7_equip', 'float', 3.000000) -- ion
   self:createConsoleVariable('text_time_7_shoot', 'float', 0.250000) -- ion
   self:createConsoleVariable('text_time_8_equip', 'float', 3.000000) -- bolt
   self:createConsoleVariable('text_time_8_shoot', 'float', 3.000000) -- bolt
   self:createConsoleVariable('text_time_9_equip', 'float', 3.000000) -- stake
   self:createConsoleVariable('text_time_9_shoot', 'float', 3.000000) -- stake
   self:createConsoleVariable('empty', 'int', 0) -- empty check
   self.noSwitchSoundDelay = 0.0
end

function Cato_Weapon:drawWidget()
   local povPlayer = players[playerIndexCameraAttachedTo]
   if not povPlayer then return end

   local weaponIndexSelected = povPlayer.weaponIndexSelected
   local weaponIndexWeaponChangingTo = povPlayer.weaponIndexweaponChangingTo
   local weaponSelectionIntensity = povPlayer.weaponSelectionIntensity

   if povPlayer.buttons.attack and povPlayer.weapons[weaponIndexSelected].ammo > 0 then
      consolePerformCommand(
         'cl_text_time ' .. consoleGetVariable('ui_Cato_Weapon_text_time_' .. weaponIndexSelected .. '_shoot')
      )
   else
      consolePerformCommand(
         'cl_text_time ' .. consoleGetVariable('ui_Cato_Weapon_text_time_' .. weaponIndexSelected .. '_equip')
      )
   end

   --

   if self.noSwitchSoundDelay > 0 then
      self.noSwitchSoundDelay = self.noSwitchSoundDelay - deltaTime
   end

   local emptyWeaponIndex = consoleGetVariable('ui_Cato_Weapon_empty')
   if emptyWeaponIndex ~= 0 then
      consolePerformCommand('ui_Cato_Weapon_empty 0')
      local weapon = povPlayer.weapons[emptyWeaponIndex]

      if weapon and (not weapon.pickedup or weapon.ammo == 0) and self.noSwitchSoundDelay <= 0.0 then
         playSound('CatoHUD/click')
         self.noSwitchSoundDelay = 0.150
      end
   end

   --

   if consoleGetVariable('ui_Cato_Weapon_debug') ~= 0 then
      local optsColor = Color(255, 255, 255)
      local text = string.format(
         '%d -> %d (%.06f), cl_text_time %.06f, self.noSwitchSoundDelay = %.06f',
         weaponIndexSelected,
         weaponIndexWeaponChangingTo,
         weaponSelectionIntensity,
         consoleGetVariable('cl_text_time'),
         self.noSwitchSoundDelay
      )

      -- -- nvgTextAlign(nvgHorizontalAlign(anchorX), nvgVerticalAlign(anchorY))
      nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_TOP)

      nvgFillColor(Color(0, 0, 0, optsColor.a * 3))
      nvgFontBlur(2)
      nvgText(0, 40, text)

      nvgFillColor(optsColor)
      nvgFontBlur(0)
      nvgText(0, 40, text)
   end
end

CatoHUD:registerWidget('Cato_Weapon', Cato_Weapon)

------------------------------------------------------------------------------------------------------------------------
