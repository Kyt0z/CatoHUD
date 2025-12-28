Cato_Weapon = {
   canHide = false, canPosition = false, canPreview = false,
   userData = {},
}

function Cato_Weapon:init()
   self:createConsoleVariable('text_time_1_equip', 'float', 1.000000) -- melee
   self:createConsoleVariable('text_time_1_shoot', 'float', 1.000000) -- melee
   self:createConsoleVariable('text_time_2_equip', 'float', 1.000000) -- burst
   self:createConsoleVariable('text_time_2_shoot', 'float', 1.000000) -- burst
   self:createConsoleVariable('text_time_3_equip', 'float', 1.000000) -- shotgun
   self:createConsoleVariable('text_time_3_shoot', 'float', 1.000000) -- shotgun
   self:createConsoleVariable('text_time_4_equip', 'float', 1.000000) -- grenade
   self:createConsoleVariable('text_time_4_shoot', 'float', 1.000000) -- grenade
   self:createConsoleVariable('text_time_5_equip', 'float', 1.000000) -- plasma
   self:createConsoleVariable('text_time_5_shoot', 'float', 1.000000) -- plasma
   self:createConsoleVariable('text_time_6_equip', 'float', 1.000000) -- rocket
   self:createConsoleVariable('text_time_6_shoot', 'float', 1.000000) -- rocket
   self:createConsoleVariable('text_time_7_equip', 'float', 1.000000) -- ion
   self:createConsoleVariable('text_time_7_shoot', 'float', 1.000000) -- ion
   self:createConsoleVariable('text_time_8_equip', 'float', 1.000000) -- bolt
   self:createConsoleVariable('text_time_8_shoot', 'float', 1.000000) -- bolt
   self:createConsoleVariable('text_time_9_equip', 'float', 1.000000) -- stake
   self:createConsoleVariable('text_time_9_shoot', 'float', 1.000000) -- stake
end

function Cato_Weapon:drawWidget()
   local povPlayer = players[playerIndexCameraAttachedTo]
   if not povPlayer then return end

   local weaponIndexSelected = povPlayer.weaponIndexSelected
   if povPlayer.buttons.attack and povPlayer.weapons[weaponIndexSelected].ammo > 0 then
      consolePerformCommand(
         'cl_text_time ' .. consoleGetVariable('ui_Cato_Weapon_text_time_' .. weaponIndexSelected .. '_shoot')
      )
   else
      consolePerformCommand(
         'cl_text_time ' .. consoleGetVariable('ui_Cato_Weapon_text_time_' .. weaponIndexSelected .. '_equip')
      )
   end
end

CatoHUD:registerWidget('Cato_Weapon', Cato_Weapon)

------------------------------------------------------------------------------------------------------------------------
