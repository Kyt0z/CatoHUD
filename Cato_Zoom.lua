------------------------------------------------------------------------------------------------------------------------
-- Math/Lua
------------------------------------------------------------------------------------------------------------------------

local floor = math.floor
local ceil = math.ceil
local abs = math.abs
local min = math.min
local max = math.max
local pow = function (x, y) return x ^ y end
-- local pow = math.pow -- deprecated
local sin = math.sin
local csc = function(x) return 1 / sin(x) end
local tan = math.tan
local atan = math.atan
-- local atan2 = function(x, y) return math.atan(y, x) end
local atan2 = math.atan2 -- deprecated
local pi = math.pi
local sqrt = math.sqrt
local deg2rad = math.rad -- function(x) return x * pi / 180 end
local rad2deg = math.deg -- function(x) return x * 180 / pi end
local huge = math.huge
local format = string.format
local gsub = string.gsub
local rep = string.rep
local sub = string.sub

local function verticalFov(fov)
   return 2 * atan((3 / 4) * tan(deg2rad(fov) / 2))
end

local function zoomSensRatio(fov, zoomFov, viewWidth, viewHeight, algorithm)
   if algorithm == 'monitordistance' then
      return atan((4 / 3) * tan(deg2rad(zoomFov) / 2)) / atan((4 / 3) * tan(deg2rad(fov) / 2))
   elseif algorithm == 'viewspeed' then
      return (csc(verticalFov(fov) / 2) / sqrt(2)) / (csc(verticalFov(zoomFov) / 2) / sqrt(2))
   elseif algorithm == 'linear' then
      return zoomFov / fov
   end

   return (atan2(viewHeight, viewWidth / tan(zoomFov / 360 * pi))) * 360 / pi / 75 -- Q3A
end

------------------------------------------------------------------------------------------------------------------------
-- Default settings
------------------------------------------------------------------------------------------------------------------------


local m_speed = consoleGetVariable('m_speed')
local r_fov = consoleGetVariable('r_fov')
local zoomFov = 40
local zoomSensMult = 1.0915740009242504 -- FIXME: 1 for release
local zoomSens = m_speed * zoomSensRatio(r_fov, zoomFov, 1440, 1080) * zoomSensMult

Cato_Zoom = {
   canHide = false, canPosition = false, canPreview = false,
   userData = {fov = zoomFov, sensitivity = zoomSens, time = 0},
}

------------------------------------------------------------------------------------------------------------------------
-- CatoHUD
------------------------------------------------------------------------------------------------------------------------

function Cato_Zoom:init()
   self:createConsoleVariable('in', 'int', 0)
   -- self.scoreboardFound = getProps('Scoreboard').visible ~= nil
   self.scoreboardFound = true
   -- consolePerformCommand('+showscores')
   -- consolePerformCommand('-showscores')
   -- consolePerformCommand('ui_show_widget Scoreboard')
   -- consolePerformCommand('m_speed 7.679449')
   -- consolePerformCommand('r_fov 105')
   -- consolePerformCommand('cl_show_gun 1')
end

function Cato_Zoom:drawWidget()
   -- TODO: Animation
   if consoleGetVariable('ui_Cato_Zoom_in') ~= 0 then
      if showScores and not self.zooming then
            self.zooming = true
            self.zoomTime = 0
            consolePerformCommand('cl_show_gun 0')
            consolePerformCommand('m_speed ' .. self.userData.sensitivity)
            if self.userData.time == 0 then
               consolePerformCommand('r_fov ' .. self.userData.fov)
            end
            if self.zoomPreScoreboard then
               consolePerformCommand('ui_hide_widget Scoreboard')
            end
      elseif (not showScores or isInMenu()) and self.zooming then
         consolePerformCommand('-showscores')
         consolePerformCommand('ui_Cato_Zoom_in 0')
         self.zooming = false
         consolePerformCommand('cl_show_gun ' .. self.zoomPreGun)
         consolePerformCommand('m_speed ' .. self.zoomPreSens)
         if self.userData.time == 0 then
            consolePerformCommand('r_fov ' .. self.zoomPreFov)
         end
         if self.zoomPreScoreboard then
            consolePerformCommand('ui_show_widget Scoreboard')
         end
      end
   elseif self.zoomTime == nil then
      self.zoomPreFov = consoleGetVariable('r_fov')
      self.zoomPreSens = consoleGetVariable('m_speed')
      self.zoomPreGun = consoleGetVariable('cl_show_gun')
      -- self.zoomPreScoreboard = self.scoreboardFound and getProps('Scoreboard').visible
      self.zoomPreScoreboard = self.scoreboardFound and true
   end
end

CatoHUD:registerWidget('Cato_Zoom', Cato_Zoom)

------------------------------------------------------------------------------------------------------------------------
