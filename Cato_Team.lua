Cato_Team = {
   canHide = false, canPosition = false, canPreview = false,
   userData = {},
}

function Cato_Team:init()
   -- self.scoreboardFound = getProps('Scoreboard').visible ~= nil
   self.scoreboardFound = true
   self:createConsoleVariable('binds', 'int', 0)
   self:createConsoleVariable('say', 'string', '')
end

function Cato_Team:drawWidget()
   local teamBinds = consoleGetVariable('ui_Cato_Team_binds')
   if teamBinds ~= 0 then
      if showScores and not self.teaming then
            self.teaming = true
            if hasTeams then
               if teamBinds == 1 then
                  consolePerformCommand('bind game mousewheelup ui_Cato_Team_say ^5HIGH')
                  consolePerformCommand('bind game mousewheeldown ui_Cato_Team_say ^5LOW')
                  consolePerformCommand('bind game mouse3 ui_Cato_Team_say ^5MID^7/^5WATER')
                  consolePerformCommand('bind game mouse5 ui_Cato_Team_say ^5POWERUP ^7SOON')
               elseif teamBinds == 2 then
                  consolePerformCommand('bind game mousewheelup ui_Cato_Team_say ^7BASE ^2SAFE')
                  consolePerformCommand('bind game mousewheeldown ui_Cato_Team_say ^7BASE ^1UNSAFE')
                  consolePerformCommand('bind game mouse3 ui_Cato_Team_say ^2ENEMY ^7AT OUR ^oMEGA')
                  consolePerformCommand('bind game mouse5 +crouch')
               end
            end
            consolePerformCommand('ui_hide_widget Scoreboard')
            -- if self.teamPreScoreboard then
            --    consolePerformCommand('ui_hide_widget Scoreboard')
            -- end
      elseif (not showScores or isInMenu()) and self.teaming then
         consolePerformCommand('-showscores')
         consolePerformCommand('ui_Cato_Team_binds 0')
         self.teaming = false
         consolePerformCommand('bind game mousewheelup weapon 3')
         consolePerformCommand('bind game mousewheeldown weapon 7')
         consolePerformCommand('unbind game mouse3 +crouch')
         consolePerformCommand('bind game mouse5 +crouch')
         consolePerformCommand('ui_show_widget Scoreboard')
         -- if self.teamPreScoreboard then
         --    consolePerformCommand('ui_show_widget Scoreboard')
         -- end
      end
   else
      -- self.teamPreBind = consoleGetVariable('r_fov')
      -- self.teamPreScoreboard = self.scoreboardFound and getProps('Scoreboard').visible
   end

   local teamSay = consoleGetVariable('ui_Cato_Team_say')
   if teamSay ~= '' then
      if hasTeams and localPov and povPlayer and povPlayer.state == PLAYER_STATE_INGAME then
         -- #A    Armor. Current Armor level. #a (lower case) does not change color according to Armor level.
         local armorChatType = 'No Armor'
         local armorChatColor = '^0'
         if povPlayer.armorProtection == 2 then
            armorChatType = 'RA'
            armorChatColor = '^1'
         elseif povPlayer.armorProtection == 1 then
            armorChatType = 'YA'
            armorChatColor = '^3'
         elseif povPlayer.armorProtection == 0 then
            armorChatType = 'GA'
            armorChatColor = '^2'
         end
         teamSay = gsub(teamSay, '#ArmorType', armorChatColor .. armorChatType)
         teamSay = gsub(teamSay, '#Armor', armorChatColor .. povPlayer.armor)

         -- #H    Health. Current Health level. #h (lower case) does not change color according to Health level.
         local damage = damageToKill(povPlayer.health, povPlayer.armor, povPlayer.armorProtection)
         local healthChatColor = '^7'
         if damage <= 80 then
            healthChatColor = '1'
         elseif damage <= 100 then
            healthChatColor = '3'
         end
         teamSay = gsub(teamSay, '#Health', healthChatColor .. povPlayer.health)

         -- #C    Corpse. The location where you last died.
         --

         -- #D    Damaged by. The last enemy to score a hit on you.
         --

         -- #E    Enemy Presence. Detailed information on all enemies in your FOV.
         --

         -- #F    Nearest Friendly Player's \name. Not the same as #N which uses \nicks when available. It's recommended to use #N instead of #F.
         -- #N    Nearest Friendly Player's \nick. Uses your nearest team mate's \name should he not have set his \nick. It's recommended to use #N instead of #F.
         local nearestFriendName = povPlayer.name
         -- local nearestFriendDistance = nil
         local nearestFriendDistance = huge
         for _, p in ipairs(players) do
            if p.state == PLAYER_STATE_INGAME and p.connected and p.index ~= povPlayer.index and p.team == povPlayer.team then
               local playerDistance = sqrt(pow(p.position.x - povPlayer.position.x, 2) + pow(p.position.y - povPlayer.position.y, 2) + pow(p.position.z - povPlayer.position.z, 2))
               -- if nearestFriendDistance == nil or playerDistance < nearestFriendDistance then
               if playerDistance < nearestFriendDistance then
                  nearestFriendName = p.name
                  nearestFriendDistance = playerDistance
               end
            end
         end
         teamSay = gsub(teamSay, '#NearestFriendNameShort', nearestFriendName:sub(1, 5))
         teamSay = gsub(teamSay, '#NearestFriendName', nearestFriendName)

         -- #I    Nearest Item. Shows the nearest "significant" (weapon, armor, powerup, or MH) available item, including dropped items.
         -- #L    Location. Many maps have terrible target_location entities e.g. PG on PRO-Q3DM6 shows as YA. This shows the nearest "significant" item spawn (weapon, armor, powerup, flag or MH), whether the item is there or not.
         local KimiLocation = 'THIS/HERE'
         -- if KimiLocations ~= nil and KimiLocations.getLocation ~= nil and KimiLocations.nvgColorText ~= nil and map_locations ~= nil and map_locations[world.mapTitle] ~= nil then
         --    KimiLocation = KimiLocations:getLocation(pIndex)
         -- end
         teamSay = gsub(teamSay, '#L', KimiLocation)

         -- weapons
         -- {
         --     [1]
         --     {
         --         string name                       
         --         number damagePerPellet            
         --         number maxAmmo                    
         --         number lowAmmoWarning             
         --         color                             
         --         {
         --             number r                      
         --             number g                      
         --             number b                      
         --             number a                      
         --         }
         --         number ammo                       
         --         boolean pickedup                  
         --         boolean isAllowed                 i.e. is there a weapon mask
         --     }
         --     ...
         -- }


         -- #M    Ammo Wanted. Lists all types of ammo for weapons you have that are empty or nearly so.
         -- #W    Weapon. #w (lower case) does not change color according to Ammo level. Lists the current weapon and ammo you have.
         local weaponsChat = ''
         -- for _, w in ipairs(povPlayer.weapons) do
         --    local ammoLow = w.lowAmmoWarning
         --    local ammo = w.ammo

         --    local weaponName = w.name:gsub('[a-z|\\s]', '')
         --    local ammoChatColor = '^7'
         --    -- if ammo <= 0 then
         --    --    ammoChatColor = '^0'
         --    -- elseif ammo <= ammoLow / 2 then
         --    if ammo <= ammoLow / 2 then
         --       ammoChatColor = '^1'
         --    elseif ammo <= ammoLow then
         --       ammoChatColor = '^3'
         --    end
         -- end
         -- teamSay = teamSay:gsub('#M', '^mBG^0: '..ammo[2]..' ^bSG^0: ^7 '..ammo[3]..' ^iGL^0: ^7 '..ammo[4]..' ^aRL^0: ^7 '..ammo[6]..' ^qIC^0: ^7 '..ammo[7]..' ^rPG^0: ^7 '..ammo[5]..' ^eBR^0: ^7 '..ammo[8]..'')
         teamSay = teamSay:gsub('#W', 'weaps')

         -- #P    Last Pickup.
         teamSay = teamSay:gsub('#P', '#Pickup')

         -- #S    Item in Sights. Item that you are aiming at directly. Distance to the item is irrelevant.
         --

         -- #T    Target. The last enemy you hit.
         --

         -- #U    PowerUps. Powerups you carry - Includes flags.
         teamSay = teamSay:gsub('#U', 'pups')

         -- #V    Victim. The last enemy you killed.
         --
         consolePerformCommand('sayteam ' .. teamSay)
      end
      self:setConsoleVariable('say', '')
   end

end

CatoHUD:registerWidget('Cato_Team', Cato_Team)

------------------------------------------------------------------------------------------------------------------------
