Cato_Weapon = {
   canHide = false, canPosition = false, canPreview = false,
   userData = {},
}

function Cato_Weapon:init()
   self:createConsoleVariable('text_time_1', 'string', '1') -- melee
   self:createConsoleVariable('text_time_2', 'string', '1') -- burst
   self:createConsoleVariable('text_time_3', 'string', '1') -- shotgun
   self:createConsoleVariable('text_time_4', 'string', '1') -- grenade
   self:createConsoleVariable('text_time_5', 'string', '1') -- plasma
   self:createConsoleVariable('text_time_6', 'string', '1') -- rocket
   self:createConsoleVariable('text_time_7', 'string', '1') -- ion
   self:createConsoleVariable('text_time_8', 'string', '1') -- bolt
   self:createConsoleVariable('text_time_9', 'string', '1') -- stake
end

function Cato_Weapon:drawWidget()
   local povPlayer = players[playerIndexCameraAttachedTo]
   if not povPlayer then return end

   local damageNumberTime = consoleGetVariable('ui_Cato_Weapon_text_time_' .. povPlayer.weaponIndexSelected)
   -- consolePrint('cl_text_time for weapon ' .. povPlayer.weaponIndexSelected .. ' is "' .. damageNumberTime .. '"')
   -- if povPlayer.weaponIndexSelected == 7 and povPlayer.buttons.attack then
   if damageNumberTime ~= '' then
      if tonumber(damageNumberTime) < 0 then
         if povPlayer.buttons.attack then
            consolePerformCommand('cl_text_time ' .. string.sub(damageNumberTime, 2, -1))
         end
      else
         consolePerformCommand('cl_text_time ' .. damageNumberTime)
      end
   end
end

CatoHUD:registerWidget('Cato_Weapon', Cato_Weapon)

------------------------------------------------------------------------------------------------------------------------
