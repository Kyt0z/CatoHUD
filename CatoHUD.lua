local TEAM_ALPHA = 1
local TEAM_ZETA = 2

-- local STATE_DISCONNECTED = 0
-- local STATE_CONNECTING = 1
-- local STATE_CONNECTED = 2

-- local GAME_STATE_WARMUP = 0
-- local GAME_STATE_ACTIVE = 1
-- local GAME_STATE_ROUNDPREPARE = 2
-- local GAME_STATE_ROUNDACTIVE = 3
-- local GAME_STATE_ROUNDCOOLDOWN_SOMEONEWON = 4
-- local GAME_STATE_ROUNDCOOLDOWN_DRAW = 5
-- local GAME_STATE_GAMEOVER = 6

-- local PLAYER_STATE_INGAME = 1
-- local PLAYER_STATE_SPECTATOR = 2
-- local PLAYER_STATE_EDITOR = 3
-- local PLAYER_STATE_QUEUED = 4

local defaultFontFace = 'TitilliumWeb-Bold'
local defaultFontSizeSmall = 32
local defaultFontSizeMedium = 40
local defaultFontSizeBig = 64
local defaultFontSizeTimer = 120
local defaultFontSizeHuge = 160
local sens = consoleGetVariable('m_speed')
local fov = consoleGetVariable('r_fov')
local defaultZoomFov = 40
local defaultZoomSensMult = 1.0915740009242504 -- FIXME: 1 for release

-- TODO: Various relative offsets (such as between lines in 'FOLLOWING\nplayer') depend on the
--       font, so maybe a function that calculates the proper offset for all the default fonts?
-- local fonts = {
--    'oswald-regular',
--    'oswald-bold',
--    'roboto-regular',
--    'roboto-bold',
--    'titilliumWeb-regular',
--    'TitilliumWeb-Bold',
-- }
-- nvgFontSize(120)
-- for _, font in ipairs(fonts) do
--    nvgFontFace(font)
--    consolePrint(font)
--    for i = 0, 9 do
--       consolePrint(i .. ': ' .. nvgTextWidth(i))
--    end
-- end

----------------------------------------------------------------------------------------------------
-- Lua
----------------------------------------------------------------------------------------------------

local function consoleTablePrint(key, val, depth)
   if not depth then depth = 0 end

   if type(key) == 'table' then
      for k, v in pairs(key) do
         consoleTablePrint(k, v, depth + 1)
      end
      return
   end

   local typeval = type(val)
   local indent = rep(' ', depth)
   if typeval == 'table' then
      consolePrint(indent .. key .. ':')
      consoleTablePrint(val, nil, depth + 1)
   elseif typeval == 'boolean' then
      consolePrint(indent .. key .. ' = ' .. (val and 'true' or 'false') .. ' (' .. typeval .. ')')
   elseif typeval == 'number' or typeval == 'string' then
      consolePrint(indent .. key .. ' = ' .. val .. ' (' .. typeval .. ')')
   else
      consolePrint(indent .. key .. ' =  (' .. typeval .. ')')
   end
end

local function checkResetConsoleVariable(cvar, resetValue)
   local oldValue = consoleGetVariable(cvar)
   if oldValue ~= resetValue then
      consolePerformCommand(cvar .. ' ' .. resetValue)
   end
   return oldValue
end

----------------------------------------------------------------------------------------------------
-- Math
----------------------------------------------------------------------------------------------------

local floor = math.floor
local ceil = math.ceil
local abs = math.abs
local min = math.min
local max = math.max
local sin = math.sin
local csc = function(x) return 1 / sin(x) end
local tan = math.tan
local atan2 = math.atan2
local pi = math.pi
local deg2rad = function(x) return x * pi / 180 end
local rad2deg = function(x) return x * 180 / pi end
local format = string.format
local rep = string.rep
local sub = string.sub

local function clamp(x, minVal, maxVal)
   return max(min(x, maxVal), minVal)
end

local function round(x)
   return x >= 0 and floor(x + 0.5) or ceil(x - 0.5)
end

local function lerp(x, y, k)
   return (1 - k) * x + k * y
end

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

local function armorMax(armorProtection)
   return floor(200 * (armorProtection + 2) / 4)
end

local function armorQuality(armorProtection)
   return floor(100 * (armorProtection + 1) / (armorProtection + 2)) / 100
end

local function armorLimit(pArmorProt, iArmorProt)
   return floor(armorMax(iArmorProt) * armorQuality(iArmorProt) / armorQuality(pArmorProt))
end

-- Precalculate these constants to save time
local armorMax = {armorMax(0), armorMax(1), armorMax(2)} -- {100, 150, 200}
local armorQuality = {armorQuality(0), armorQuality(1), armorQuality(2)} -- {0.50, 0.66, 0.75}
local armorLimit = {
   {armorLimit(0, 0), armorLimit(0, 1), armorLimit(0, 2)}, -- 100, 198, 300
   {armorLimit(1, 0), armorLimit(1, 1), armorLimit(1, 2)}, --  75, 150, 227
   {armorLimit(2, 0), armorLimit(2, 1), armorLimit(2, 2)}, --  66, 132, 200
}

local function damageToKill(health, armor, armorProtection)
   return min(armor, health * (armorProtection + 1)) + health
end

----------------------------------------------------------------------------------------------------
-- Time
----------------------------------------------------------------------------------------------------

local MS_IN_S = 1000
local S_IN_M = 60
local M_IN_H = 60
local H_IN_D = 24
local D_IN_Y = 365
local D_IN_LY = 366

local S_IN_H = M_IN_H * S_IN_M
local S_IN_D = H_IN_D * S_IN_H
local S_IN_Y = D_IN_Y * S_IN_D
local S_IN_LY = D_IN_LY * S_IN_D

local MS_IN_M = MS_IN_S * S_IN_M
local MS_IN_H = MS_IN_S * S_IN_H
local MS_IN_D = MS_IN_S * S_IN_D
local MS_IN_Y = MS_IN_S * S_IN_Y
local MS_IN_LY = MS_IN_S * S_IN_LY

local function formatTimeMs(elapsed, limit, countDown)
   if countDown then
      local remaining = MS_IN_S + limit - elapsed
      return {
         hours = max(floor(remaining / MS_IN_H), 0) % 24,
         minutes = max(floor(remaining / MS_IN_M), 0) % 60,
         seconds = (floor(remaining / MS_IN_S) % 60 + 60) % 60,
      }
   end
   return {
      hours = floor((elapsed / MS_IN_H) % 24),
      minutes = floor((elapsed / MS_IN_M) % 60),
      seconds = floor((elapsed / MS_IN_S) % 60),
   }
end

local function formatDay(day)
   local ext = {'th', 'st', 'nd', 'rd'}
   local lastDigit = day % 10
   return day .. ext[(lastDigit >= 4 or (day >= 11 and day <= 13)) and 1 or lastDigit + 1]
end

local MONTHS = {
   'January', 'February', 'March', 'April', 'May', 'June',
   'July', 'August', 'September', 'October', 'November', 'December'
}
local function formatMonth(month)
   return MONTHS[month]
end

local function isLeapYear(year)
   return (year % 4 == 0 and year % 100 ~= 0) or (year % 400 == 0)
end

local function secondsInYear(year)
   return isLeapYear(year) and S_IN_LY or S_IN_Y
end

local function daysInMonth(month, year)
   if month == 2 then
      return isLeapYear(year) and 29 or 28
   end
   return 30 + month % 2
end

local function secondsInMonth(month, year)
   return S_IN_D * daysInMonth(month, year)
end

local function yearsModSince(yearFrom, yearTo, modulo)
   -- FIXME: Changing yearTo - 1 to yearTo is more optimal?
   return floor((yearTo - 1) / modulo) - floor((yearFrom - 1) / modulo)
end

function formatEpochTime(epochTimestamp, offsetUTC)
   local epochSeconds = epochTimestamp + offsetUTC
   if true then
      -- TODO: Optimization (even further)
      -- Overshoot yearTo such that epochSeconds < 0, and then add the year's seconds back to it?
      -- Test case: year is k*365 or k*366 >= yearFrom, k >= 1
      local yearFrom = 1970
      local year = yearFrom
      while epochSeconds >= secondsInYear(year) do
         year = year + floor(epochSeconds / S_IN_Y)
         local yearsMod4Since = yearsModSince(yearFrom, year, 4)
         local yearsMod100Since = yearsModSince(yearFrom, year, 100)
         local yearsMod400Since = yearsModSince(yearFrom, year, 400)
         local leapYears = yearsMod4Since - yearsMod100Since + yearsMod400Since
         local nonLeapYears = year - leapYears
         epochSeconds = epochSeconds - (leapYears * S_IN_LY + nonLeapYears * S_IN_Y)
         yearFrom = year
      end

      local month = 1
      local monthSeconds = secondsInMonth(month, year)
      while epochSeconds >= monthSeconds do
         epochSeconds = epochSeconds - monthSeconds
         month = month + 1
         monthSeconds = secondsInMonth(month, year)
      end
   else
      -- Working
      local year = 1970
      local secondsInYearCurrent = secondsInYear(year)
      while epochSeconds >= secondsInYearCurrent do
         epochSeconds = epochSeconds - secondsInYearCurrent
         year = year + 1
         secondsInYearCurrent = secondsInYear(year)
      end

      local month = 1
      local secondsInMonthCurrent = secondsInMonth(month, year)
      while epochSeconds >= secondsInMonthCurrent do
         epochSeconds = epochSeconds - secondsInMonthCurrent
         month = month + 1
         secondsInMonthCurrent = secondsInMonth(month, year)
      end
   end

   local day = floor(epochSeconds / S_IN_D)
   epochSeconds = epochSeconds - day * S_IN_D

   local hour = floor(epochSeconds / S_IN_H)
   epochSeconds = epochSeconds - hour * S_IN_H

   local minute = floor(epochSeconds / S_IN_M)
   epochSeconds = epochSeconds - minute * S_IN_M

   local second = epochSeconds
   -- epochSeconds = epochSeconds - second

   -- epochSeconds = epochTimestamp + offsetUTC
   -- local dateTime = '%s-%02d-%02d %02d:%02d:%02d'
   -- dateTime = formatdateTime, year, month, day, hour, minute, second)
   -- consolePrint(format('%s (%s)', dateTime, epochTimestamp + offsetUTC))

   -- local day = floor(epochSeconds / S_IN_D) % daysInMonth(month, year)
   -- local hour = floor(epochSeconds / S_IN_H) % H_IN_D
   -- local minute = floor(epochSeconds / S_IN_M) % M_IN_H
   -- local second = epochSeconds % S_IN_M

   return {
      year = year,
      month = month,
      day = day,
      hour = hour,
      minute = minute,
      second = second,
   }
end

----------------------------------------------------------------------------------------------------
-- Colors
----------------------------------------------------------------------------------------------------

local function Color(r, g, b, a, intensity)
   return {r = r, g = g, b = b, a = (a or 255) * (intensity or 1)}
end

local function ColorHEX(hex, intensity)
   return {
      r = tonumber('0x' .. sub(hex, 1, 2)),
      g = tonumber('0x' .. sub(hex, 3, 4)),
      b = tonumber('0x' .. sub(hex, 5, 6)),
      a = (tonumber('0x' .. sub(hex, 7, 8)) or 255) * (intensity or 1)
   }
end

local function copyColor(color, intensity)
   return Color(color.r, color.g, color.b, color.a, intensity)
end

local function lerpColor(color1, color2, k, intensity)
   return {
      r = lerp(color1.r, color2.r, k),
      g = lerp(color1.g, color2.g, k),
      b = lerp(color1.b, color2.b, k),
      a = lerp(color1.a, color2.a, k) * (intensity or 1)
   }
end

local function consoleColorPrint(color)
   consolePrint(format('(%s, %s, %s, %s)', color.r, color.g, color.b, color.a))
end

local function armorColorLerp(armor, armorProtection, colorArmor)
   -- pretty good
   -- local lerpAmount = 1
   -- for itemArmorProtection = 0, 2 do
   --    if armor < armorLimit[armorProtection + 1][itemArmorProtection + 1] then
   --       lerpAmount = lerpAmount - 1
   --    end
   -- end
   -- lerpAmount = lerpAmount * 0.33


   -- faster but slightly off (inaccurate for low GA/high RA)
   -- local lerpAmount = armor - (3 * armorLimit[armorProtection + 1][1] - armorLimit[armorProtection + 1][2]) / 2
   local function normal_round(n)
      if n - floor(n) < 0.5 then
         return floor(n)
      end
      return ceil(n)
   end
   -- local armorLowRange = armorLimit[armorProtection + 1][1]
   -- local armorMidRange = armorLimit[armorProtection + 1][2] - armorLimit[armorProtection + 1][1]
   -- local lerpAmount = armor - armorLowRange - armorMidRange / 2
   -- lerpAmount = lerpAmount / armorMidRange
   -- lerpAmount = lerpAmount + 1 - armorProtection
   -- lerpAmount = normal_round(lerpAmount)
   -- lerpAmount = lerpAmount * 0.33
   local a = armorLimit[armorProtection + 1][1]
   local b = armorLimit[armorProtection + 1][2] - a
   local lerpAmount = normal_round(((armor - a - b / 2) / b) + 1 - armorProtection) * 0.33

   -- consolePrint(lerpAmount)

   local colorToLerp = lerpAmount < 0 and Color(0, 0, 0) or Color(255, 255, 255)
   return lerpColor(colorArmor, colorToLerp, abs(lerpAmount))
end

----------------------------------------------------------------------------------------------------
-- Default settings
----------------------------------------------------------------------------------------------------

local defaultSettings = {
   ['CatoHUD'] = {
      userData = {
         offsetUTC = 2 * S_IN_H,
         noArmorColor = Color(0, 0, 0, 255),
         armorColor0 = Color(0, 255, 0),
         armorColor1 = Color(255, 255, 0),
         armorColor2 = Color(255, 0, 0),
         megaColor = Color(60, 80, 255),
         carnageColor = Color(255, 0, 188),
         resistColor = Color(124, 32, 255),
         weaponColor1 = Color(255, 255, 255),
         weaponColor2 = Color(0, 255, 255),
         weaponColor3 = Color(255, 150, 0),
         weaponColor4 = Color(99, 221, 74),
         weaponColor5 = Color(255, 0, 255),
         weaponColor6 = Color(250, 0, 0),
         weaponColor7 = Color(0, 128, 255),
         weaponColor8 = Color(255, 255, 0),
         weaponColor9 = Color(128, 0, 0),
      },
      cvars = {
         {'box_debug', 'int', 0},
         {'debug', 'int', 1},
         {'reset_widgets', 'int', 0, 0},
         {'warmuptimer_reset', 'int', 0, 0},
         {'widget_cache', 'int', 0, 0},
         {'zoom', 'int', 0, 0},
      },
   },
   ['Cato_Zoom'] = {
      userData = {
         fov = defaultZoomFov,
         sensitivity = sens * zoomSensRatio(fov, defaultZoomFov, 1440, 1080) * defaultZoomSensMult,
         time = 0,
      },
   },
   ['Cato_HealthNumber'] = {
      visible = true,
      props = {
         offset = '-40 30',
         anchor = '0 1',
         zIndex = '0',
         scale = '1',
      },
      userData = {
         anchorWidget = '',
         fontFace = defaultFontFace,
         fontSize = defaultFontSizeHuge,
         textAnchor = {x = 1},
         show = {
            dead = true,
            race = false,
            mainMenu = false,
            menu = false,
            hudOff = false,
            gameOver = false,
            freecam = false,
            editor = false,
         },
      },
   },
   ['Cato_ArmorNumber'] = {
      visible = true,
      props = {
         offset = '40 30',
         anchor = '0 1',
         zIndex = '0',
         scale = '1',
      },
      userData = {
         anchorWidget = '',
         fontFace = defaultFontFace,
         fontSize = defaultFontSizeHuge,
         textAnchor = {x = -1},
         show = {
            dead = true,
            race = false,
            mainMenu = false,
            menu = false,
            hudOff = false,
            gameOver = false,
            freecam = false,
            editor = false,
         },
      },
   },
   ['Cato_ArmorIcon'] = {
      visible = true,
      props = {
         offset = '0 -20',
         anchor = '0 1',
         zIndex = '0',
         scale = '1',
      },
      userData = {
         anchorWidget = '',
         iconSize = 24,
         show = {
            dead = true,
            race = false,
            mainMenu = false,
            menu = false,
            hudOff = false,
            gameOver = false,
            freecam = false,
            editor = false,
         },
      },
   },
   ['Cato_FPS'] = {
      visible = true,
      props = {
         offset = '-3 -5',
         anchor = '1 -1',
         zIndex = '-999',
         scale = '1',
      },
      userData = {
         anchorWidget = '',
         fontFace = defaultFontFace,
         fontSize = defaultFontSizeSmall,
         show = {
            dead = true,
            race = true,
            mainMenu = true,
            menu = true,
            hudOff = false,
            gameOver = true,
            freecam = true,
            editor = true,
         },
      },
   },
   ['Cato_Time'] = {
      visible = true,
      props = {
         offset = '0 18',
         anchor = '1 -1',
         zIndex = '-999',
         scale = '1',
      },
      userData = {
         anchorWidget = '',
         fontFace = defaultFontFace,
         fontSize = defaultFontSizeSmall,
         show = {
            dead = true,
            race = true,
            mainMenu = true,
            menu = true,
            hudOff = false,
            gameOver = true,
            freecam = true,
            editor = true,
         },
      },
   },
   ['Cato_Scores'] = {
      visible = true,
      props = {
         offset = '0 23',
         anchor = '1 -1',
         zIndex = '0',
         scale = '1',
      },
      userData = {
         anchorWidget = 'Cato_Time',
         fontFace = defaultFontFace,
         fontSize = defaultFontSizeSmall,
         show = {
            dead = true,
            race = true,
            mainMenu = false,
            menu = false,
            hudOff = false,
            gameOver = true,
            freecam = true,
            editor = false,
         },
      },
   },
   ['Cato_GameModeName'] = {
      visible = true,
      props = {
         offset = '0 23',
         anchor = '1 -1',
         zIndex = '0',
         scale = '1',
      },
      userData = {
         anchorWidget = 'Cato_Scores',
         fontFace = defaultFontFace,
         fontSize = defaultFontSizeSmall,
         show = {
            dead = true,
            race = true,
            mainMenu = false,
            menu = false,
            hudOff = false,
            gameOver = false,
            freecam = true,
            editor = false,
         },
      },
   },
   ['Cato_RulesetName'] = {
      visible = true,
      props = {
         offset = '0 23',
         anchor = '1 -1',
         zIndex = '0',
         scale = '1',
      },
      userData = {
         anchorWidget = 'Cato_GameModeName',
         fontFace = defaultFontFace,
         fontSize = defaultFontSizeSmall,
         show = {
            dead = true,
            race = true,
            mainMenu = false,
            menu = false,
            hudOff = false,
            gameOver = false,
            freecam = true,
            editor = false,
         },
      },
   },
   ['Cato_MapName'] = {
      visible = true,
      props = {
         offset = '0 23',
         anchor = '1 -1',
         zIndex = '0',
         scale = '1',
      },
      userData = {
         anchorWidget = 'Cato_RulesetName',
         fontFace = defaultFontFace,
         fontSize = defaultFontSizeSmall,
         show = {
            dead = true,
            race = true,
            mainMenu = false,
            menu = false,
            hudOff = false,
            gameOver = false,
            freecam = true,
            editor = false,
         },
      },
   },
   ['Cato_ReadyStatus'] = {
      visible = true,
      props = {
         offset = '0 145',
         anchor = '0 -1',
         zIndex = '0',
         scale = '1',
      },
      userData = {
         anchorWidget = '',
         fontFace = defaultFontFace,
         fontSize = defaultFontSizeSmall,
         show = {
            dead = true,
            race = true,
            mainMenu = false,
            menu = false,
            hudOff = false,
            gameOver = false,
            freecam = true,
            editor = false,
         },
      },
   },
   ['Cato_GameMessages'] = {
      visible = true,
      props = {
         offset = '0 -80',
         anchor = '0 0',
         zIndex = '0',
         scale = '1',
      },
      userData = {
         anchorWidget = '',
         fontFace = defaultFontFace,
         fontSize = defaultFontSizeMedium,
         show = {
            dead = true,
            race = true,
            mainMenu = false,
            menu = true,
            hudOff = false,
            gameOver = false,
            freecam = true,
            editor = false,
         },
      },
   },
   ['Cato_Speed'] = {
      visible = false,
      props = {
         offset = '0 60',
         anchor = '0 0',
         zIndex = '0',
         scale = '1',
      },
      userData = {
         anchorWidget = '',
         fontFace = defaultFontFace,
         fontSize = defaultFontSizeSmall,
         show = {
            dead = false,
            race = true,
            mainMenu = false,
            menu = false,
            hudOff = false,
            gameOver = false,
            freecam = false,
            editor = false,
         },
      },
   },
   ['Cato_LowAmmo'] = {
      visible = true,
      props = {
         offset = '0 160',
         anchor = '0 0',
         zIndex = '0',
         scale = '1',
      },
      userData = {
         anchorWidget = '',
         fontFace = defaultFontFace,
         fontSize = defaultFontSizeSmall,
         show = {
            dead = false,
            race = true,
            mainMenu = false,
            menu = false,
            hudOff = false,
            gameOver = false,
            freecam = false,
            editor = false,
         },
         preventEmptyAttack = true,
      },
   },
   ['Cato_Ping'] = {
      visible = true,
      props = {
         offset = '-3 4',
         anchor = '1 1',
         zIndex = '0',
         scale = '1',
      },
      userData = {
         anchorWidget = '',
         fontFace = defaultFontFace,
         fontSize = defaultFontSizeSmall,
         show = {
            dead = true,
            race = true,
            mainMenu = false,
            menu = false,
            hudOff = false,
            gameOver = true,
            freecam = true,
            editor = false,
         },
      },
   },
   ['Cato_PacketLoss'] = {
      visible = true,
      props = {
         offset = '-3 -16',
         anchor = '1 1',
         zIndex = '0',
         scale = '1',
      },
      userData = {
         anchorWidget = '',
         fontFace = defaultFontFace,
         fontSize = defaultFontSizeSmall,
         show = {
            dead = true,
            race = true,
            mainMenu = false,
            menu = false,
            hudOff = false,
            gameOver = true,
            freecam = true,
            editor = false,
         },
      },
   },
   ['Cato_GameTime'] = {
      visible = true,
      props = {
         offset = '0 -135',
         anchor = '0 1',
         zIndex = '0',
         scale = '1',
      },
      userData = {
         anchorWidget = '',
         countDown = false,
         hideSeconds = false,
         fontFace = defaultFontFace,
         fontSize = defaultFontSizeTimer,
         show = {
            dead = true,
            race = false,
            mainMenu = false,
            menu = false,
            hudOff = false,
            gameOver = false,
            freecam = false,
            editor = false,
         },
      },
   },
   ['Cato_FollowingPlayer'] = {
      visible = true,
      props = {
         offset = '0 0',
         anchor = '0 -1',
         zIndex = '0',
         scale = '1',
      },
      userData = {
         anchorWidget = '',
         fontFace = defaultFontFace,
         fontSize = defaultFontSizeBig,
         textAnchor = {x = 0},
         show = {
            dead = true,
            race = true,
            mainMenu = false,
            menu = false,
            hudOff = false,
            gameOver = false,
            freecam = false,
            editor = false,
         },
      },
   },
}

----------------------------------------------------------------------------------------------------
-- Widget cache
----------------------------------------------------------------------------------------------------

local indexCache = {}
local indexCacheSize = 0
local indexCacheUpdates = 0

-- Note: Calling this before initialize will fail
local function updateIndexCache(widgetName)
   -- We count every call since the entire widgets table is looped each time
   indexCacheUpdates = indexCacheUpdates + 1

   if not indexCache[widgetName] then
      indexCacheSize = indexCacheSize + 1
   end

   for widgetIndex, widget in ipairs(widgets) do
      if widget.name == widgetName then
         indexCache[widgetName] = widgetIndex
         break
      end
   end

   return indexCache[widgetName]
end

-- Note: Calling this before initialize will fail.
--       If the widget is not present, a widget cache update is triggered,
--       which loops the entire widgets table (not smart to do every frame).
local function getProps(widgetName)
   local widgetIndex = indexCache[widgetName]
   if not widgetIndex or not widgets[widgetIndex] or widgets[widgetIndex].name ~= widgetName then
      widgetIndex = updateIndexCache(widgetName)
   end

   return widgets[widgetIndex] or {}
end

local function debugIndexCache()
   local debugLines = {}
   table.insert(debugLines, 'widgets:')
   for widgetIndex, widget in ipairs(widgets) do
      if indexCache[widget.name] then
         table.insert(debugLines, '  ' .. widgetIndex .. ': ' .. widget.name)
      end
   end
   table.insert(debugLines, 'indexCache:')
   for widgetName, widgetIndex in pairs(indexCache) do
      local mismatch = ''
      if widgets[widgetIndex].name ~= widgetName then
         mismatch = '*'
      end
      table.insert(debugLines, '  ' .. widgetName .. ': ' .. widgetIndex .. mismatch)
   end
   table.insert(debugLines, 'indexCacheSize: ' .. indexCacheSize)
   table.insert(debugLines, 'indexCacheUpdates: ' .. indexCacheUpdates)
   return debugLines
end

----------------------------------------------------------------------------------------------------
-- UI/NVG
----------------------------------------------------------------------------------------------------

-- WIDGET_PROPERTIES_COL_INDENT = 250
-- WIDGET_PROPERTIES_COL_WIDTH = 560

local function getOffset(anchor, width, height)
   return {
      x = -(anchor.x + 1) * width / 2,
      y = -(anchor.y + 1) * height / 2,
   }
end

local function nvgHorizontalAlign(x)
   --    ANCHOR_LEFT = -1,    ANCHOR_CENTER = 0,    ANCHOR_RIGHT = 1
   -- NVG_ALIGN_LEFT =  0, NVG_ALIGN_CENTER = 1, NVG_ALIGN_RIGHT = 2
   return x + 1
end

local function nvgVerticalAlign(y)
   --    ANCHOR_TOP = -1,    ANCHOR_MIDDLE = 0,    ANCHOR_BOTTOM = 1
   -- NVG_ALIGN_TOP =  1, NVG_ALIGN_MIDDLE = 2, NVG_ALIGN_BOTTOM = 3 (NVG_ALIGN_BASELINE = 0)
   return y + 2
end

local function createTextElem(anchor, text, opts)
   -- FIXME: Is this a good idea?
   -- opts.size = opts.size * viewport.height / 1080
   -- Answer: NO. Scaling is fine but positioning gets fucked up. (Fixable by adjusting y?)

   nvgFontBlur(0)
   nvgFontFace(opts.font)
   nvgFontSize(opts.size)

   local draw = function(x, y)
      local anchorX = anchor.x
      local anchorY = anchor.y
      if opts.anchor then
         if opts.anchor.x then anchorX = opts.anchor.x end
         if opts.anchor.y then anchorY = opts.anchor.y end
      end
      nvgTextAlign(nvgHorizontalAlign(anchorX), nvgVerticalAlign(anchorY))
      nvgFontFace(opts.font)

      nvgFillColor(Color(0, 0, 0, opts.color.a * 3))
      nvgFontBlur(2)
      nvgFontSize(opts.size)
      nvgText(x, y, text)

      nvgFillColor(opts.color)
      nvgFontBlur(0)
      nvgFontSize(opts.size)
      nvgText(x, y, text)

      if consoleGetVariable('ui_CatoHUD_box_debug') ~= 0 then
         local width = nvgTextWidth(text)
         -- local bounds = nvgTextBounds(text)
         -- consoleTablePrint(bounds)
         -- consolePrint('')
         pos = getOffset({x = anchorX, y = anchorY}, width, opts.size)
         nvgFillColor(Color(0, 255, 0, 63))
         nvgBeginPath()
         nvgRect(pos.x, pos.y, width, opts.size)
         nvgFill()
      end
   end

   return {width = nvgTextWidth(text), height = opts.size, draw = draw}
end

local function createSvgElem(anchor, image, opts)
   -- FIXME: Is this a good idea?
   -- opts.size = opts.size * viewport.height / 1080
   -- Answer: NO. Scaling is fine but positioning gets fucked up. (Fixable by adjusting y?)

   local draw = function(x, y)
      x = x - anchor.x * opts.size
      y = y - anchor.y * opts.size

      nvgFillColor(Color(0, 0, 0, opts.color.a))
      nvgSvg(image, x, y, opts.size + 1.25)
      -- nvgSvg(image, x - 1.5, y - 1.5, opts.size)
      -- nvgSvg(image, x + 1.5, y - 1.5, opts.size)
      -- nvgSvg(image, x + 1.5, y + 1.5, opts.size)
      -- nvgSvg(image, x - 1.5, y + 1.5, opts.size)

      nvgFillColor(opts.color)
      nvgSvg(image, x, y, opts.size)

      if consoleGetVariable('ui_CatoHUD_box_debug') ~= 0 then
         pos = getOffset(anchor, 2 * opts.size, 2 * opts.size)
         nvgFillColor(Color(0, 255, 0, 63))
         nvgBeginPath()
         nvgRect(pos.x, pos.y, 2 * opts.size, 2 * opts.size)
         nvgFill()
      end
   end

   return {width = opts.size, height = opts.size, draw = draw}
end

local function nvgTextUI(pos, text, opts)
   local elem = createTextElem({x = -1, y = -1}, text, opts)
   elem.draw(pos.x, pos.y)
   pos.y = pos.y + opts.size -- padding
   return {width = elem.width, height = elem.height}
end

local function optFormatColor(color, hoverAmount, enabled, pressed)
   -- pressed is nil defaults to false
   -- enabled is nil defaults to true
   if pressed == true and color.pressed ~= nil then
      return copyColor(color.pressed)
   elseif enabled == false and color.disabled ~= nil then
      return copyColor(color.disabled)
   end
   return lerpColor(color.base, color.hover, hoverAmount or 0)
end

local function optDelimiter(pos, opts)
   pos.y = pos.y + 8 -- padding
   nvgFillColor(opts.color)
   nvgBeginPath()
   nvgRect(pos.x, pos.y, 580, 2)
   nvgFill()
   pos.y = pos.y + 10 -- padding

   if consoleGetVariable('ui_CatoHUD_box_debug') ~= 0 then
      nvgFillColor(Color(0, 255, 0, 63))
      nvgBeginPath()
      nvgRect(pos.x, pos.y - 18, 580, 18)
      nvgFill()
   end
end

local optInput = {
   checkBox = function(pos, value, opts)
      local enabled = opts.enabled == nil and true or opts.enabled

      local m = {hoverAmount = 0, leftUp = false}
      if enabled then
         m = mouseRegion(pos.x, pos.y, opts.width, opts.height, opts.id or 0)
      end

      local backgroundColor = optFormatColor(opts.bg, m.hoverAmount, enabled)
      local checkmarkColor = optFormatColor(opts.fg, m.hoverAmount, enabled)

      -- bg
      nvgBeginPath()
      nvgRect(pos.x, pos.y, opts.width, opts.height)
      nvgFillColor(backgroundColor)
      nvgFill()

      -- svg
      if value then
         local offset = round(opts.width / 2)
         local size = round(opts.height / 3.5)
         nvgFillColor(checkmarkColor)
         nvgSvg('internal/ui/icons/checkBoxTick', pos.x + offset, pos.y + offset, size)
      end

      if m.leftUp then
         playSound('internal/ui/sounds/buttonClick')
         value = not value
      end

      return value
   end,

   -- FIXME: Copied from reflexcore and modified. DIY..
   __editBox_flash = 0, -- hmm hidden globals
   __editBox_offsetX = 0,
   __editBox_offsetX_id = 0,
   editBox = function(pos, value, opts)
      local enabled = opts.enabled == nil and true or opts.enabled
      local giveFocus = (opts.giveFocus ~= nil) and opts.giveFocus or false

      local t = nil
      if enabled then
         t = textRegion(pos.x, pos.y, opts.width, opts.height, value, opts.id or 0, giveFocus)
      else
         t = {
            text = value,
            focus = false,
            apply = false,
            hoverAmount = 0,
         }
      end

      local backgroundColor = optFormatColor(opts.bg, t.hoverAmount, enabled)
      local textColor = optFormatColor(opts.fg, t.hoverAmount, enabled)

      nvgSave()

      -- bg
      nvgBeginPath()
      nvgRect(pos.x, pos.y, opts.width, opts.height)
      nvgFillColor(backgroundColor)
      nvgFill()

      -- apply font & calculate cursor pos
      nvgFontSize(32)
      nvgFontFace('titilliumWeb-regular')
      local textUntilCursor = sub(t.text, 0, t.cursor)
      local textWidthAtCursor = nvgTextWidth(textUntilCursor)

      -- text positioning (this may be a frame behind at this point, but it used for input, one what
      -- is on the screen, so that's fine)
      local offsetX = 0
      if t.focus then -- only use __editBox_offsetX if we have focus
         if __editBox_offsetX_id == t.id then
            offsetX = __editBox_offsetX
         else
            __editBox_offsetX_id = t.id
            offsetX = 0
         end
      end
      local padX = opts.height * 0.3
      local textX = pos.x + padX + offsetX
      local textY = pos.y + opts.height * 0.5

      -- handle clicking inside region to change cursor location / drag select multiple characters
      -- (note: this can update the cursor inside t)
      if (t.leftDown or t.leftHeld) and t.mouseInside then
         local textLength = string.len(t.text)
         local prevDistance = nil
         local newCursor = textLength
         for l = 0, textLength do
            local distance = abs(textX + nvgTextWidth(sub(t.text, 0, l)) - t.mousex)

            -- was prev distance closer?
            if l > 0 then
               if distance > prevDistance then
                  newCursor = l - 1
                  break
               end
            end

            prevDistance = distance
         end

         -- drag selection only if we were holding the mouse (and didn't just push it now),
         -- otherwise it's a click and we just want to go to that cursor
         local dragSelection = t.leftHeld and not t.leftDown

         -- set cursor, and read updated cursors for rendering below
         t.cursorStart, t.cursor = textRegionSetCursor(t.id, newCursor, dragSelection)
      end

      -- update these, cursor may have changed!
      textUntilCursor = sub(t.text, 0, t.cursor)
      textWidthAtCursor = nvgTextWidth(textUntilCursor)

      -- keep the cursor inside the bounds of the text entry
      if t.focus then
         -- the string buffer can be wider than this edit box, when that happens, we need to
         -- clip the texture, but also ensure that the cursor remains visible
         local cursorX = (pos.x + padX + offsetX) + textWidthAtCursor
         local endX = (pos.x + opts.width - padX)
         local cursorPast = cursorX - endX
         if cursorPast > 0 then
            offsetX = offsetX - cursorPast
         end

         local startX = pos.x + padX
         local cursorEarly = startX - cursorX
         if cursorEarly > 0 then
            offsetX = offsetX + cursorEarly
         end

         -- store into common global var, we're the entry with focus
         __editBox_offsetX = offsetX
         __editBox_offsetX_id = t.id
      else
         -- no-longer holding it, reset
         if __editBox_offsetX_id == t.id then
            __editBox_offsetX_id = 0
         end
      end

      -- update these, offset may have changed!
      textX = pos.x + padX + offsetX

      -- scissor text & cursor etc
      nvgIntersectScissor(pos.x + padX / 2, pos.y, opts.width - padX, opts.height)

      -- cursor
      if t.focus then
         local cursorFlashPeriod = 0.25

         __editBox_flash = __editBox_flash + deltaTime

         -- if cursor moves, restart flash
         if t.cursorChanged then
            __editBox_flash = 0
         end

         -- multiple selection, draw selection field
         if t.cursor ~= t.cursorStart then
            local textUntilCursorStart = sub(t.text, 0, t.cursorStart)
            local textWidthAtCursorStart = nvgTextWidth(textUntilCursorStart)

            local selX = min(textWidthAtCursor, textWidthAtCursorStart)
            local selWidth = abs(textWidthAtCursor - textWidthAtCursorStart)
            nvgBeginPath()
            nvgRect(textX + selX, textY - opts.height * 0.35, selWidth, opts.height * 0.7)
            nvgFillColor(Color(204, 204, 160, 128))
            nvgFill()
         end

         -- flashing cursor
         if __editBox_flash < cursorFlashPeriod then
            nvgBeginPath()
            nvgMoveTo(textX + textWidthAtCursor, textY - opts.height * 0.35)
            nvgLineTo(textX + textWidthAtCursor, textY + opts.height * 0.35)
            nvgStrokeColor(textColor)
            nvgStroke()
         else
            if __editBox_flash > cursorFlashPeriod * 2 then
               __editBox_flash = 0
            end
         end
      end

      -- draw text
      nvgFillColor(textColor)
      nvgTextAlign(0, 2)
      nvgText(textX, textY, t.text)

      nvgRestore()

      if t.apply then
         -- apply, return new value
         playSound("internal/ui/sounds/buttonClick")
         return t.text
      elseif t.focus then
         -- return value at time of focus started
         return t.textInitial
      end
      -- return value client passed in
      return value
   end
}

local function optRowInput(inputFunc, pos, text, value, textOpts, inputOpts)
   local diffHalf = (inputOpts.height - textOpts.size) / 2
   pos.y = pos.y + max(0, diffHalf)
   local label = nvgTextUI(pos, text, textOpts)

   local padding = label.width + 8
   pos.x = pos.x + padding
   pos.y = pos.y - label.height - diffHalf
   value = inputFunc(pos, value, inputOpts)
   pos.y = pos.y + max(label.height, inputOpts.height) -- padding
   pos.x = pos.x - padding
   return value
end

-- (:.*?:)|\^[0-9a-zA-Z]
-- :arenafp: :reflexpicardia::skull:^w' .. player.name .. ' :rocket::boom:^7:beatoff:
-- local function nvgEmojiText(props, pos, text, opts)
--
-- end

----------------------------------------------------------------------------------------------------
-- CatoHUD
----------------------------------------------------------------------------------------------------

local debugMode = nil

local povPlayer = nil
local localPlayer = nil

local localPov = nil

local gameState = nil
local gameMode = nil
local hasTeams = nil
local map = nil
local mapTitle = nil
local ruleset = nil
local gameTimeElapsed = nil
local gameTimeLimit = nil

local inReplay = nil
local previousMap = nil
local warmupTimeElapsed = 0

CatoHUD = {canHide = false, canPosition = false}

function CatoHUD:registerWidget(widgetName, widget)
   registerWidget(widgetName)

   function widget:resetProperties()
      local settings = defaultSettings[widgetName] or {}

      local showCommand = settings.visible and 'ui_show_widget' or 'ui_hide_widget'
      consolePerformCommand(showCommand .. ' ' .. widgetName)

      for prop, val in pairs(settings.props or {}) do
         consolePerformCommand('ui_set_widget_' .. prop .. ' ' .. widgetName .. ' ' .. val)
      end
   end

   function widget:checkSetUserData(reset)
      local settings = defaultSettings[widgetName] or {}

      if reset then widget.userData = nil end

      widget.userData = widget.userData or {}
      for var, val in pairs(settings.userData or {}) do
         if not widget.userData[var] or type(widget.userData[var]) ~= type(val) then
            widget.userData[var] = val
         end
      end

      saveUserData(widget.userData)
   end

   function widget:checkSetCvars(reset)
      local settings = defaultSettings[widgetName] or {}

      for _, cvar in ipairs(settings.cvars or {}) do
         if self == widget then
            widgetCreateConsoleVariable(cvar[1], cvar[2], cvar[3])
            if cvar[4] then
               widgetSetConsoleVariable(cvar[1], cvar[4])
            end
         elseif reset then
            local resetVal = cvar[4] or cvar[3]
            consolePerformCommand('ui_' .. widgetName .. '_' .. cvar[1] .. ' ' .. resetVal)
         end
      end
   end

   function widget:initialize()
      widget:resetProperties()

      -- consoleTablePrint(widgetName .. '.userData', widget.userData)
      widget:checkSetUserData()
      -- consoleTablePrint(widgetName .. '.userData', widget.userData)

      widget:checkSetCvars()

      if widget.init then
         widget:init()
      end
   end

   widget.optionsHeight = 0

   function widget:getOptionsHeight()
      return widget.optionsHeight
   end

   -- FIXME: You MUST check what happens if GoaHud is present
   function widget:drawOptions(x, y, intensity)
      local opts = {
         small = {
            size = 24,
            font = 'roboto-regular',
            color = Color(191, 191, 191, 255 * intensity),
         },
         medium = {
            size = 28,
            font = 'roboto-regular',
            color = Color(255, 255, 255, 255 * intensity),
         },
         widgetName = {
            size = 30,
            font = 'roboto-bold',
            color = Color(255, 255, 255, 255 * intensity),
         },
         warning = {
            size = 28,
            font = 'roboto-regular',
            color = Color(255, 0, 0, 255 * intensity),
         },
         delimiter = {
            color = Color(0, 0, 0, 63 * intensity),
         },
         checkBox = {
            width = 35,
            height = 35,
            bg = {
               base = Color(26, 26, 26, 255 * intensity),
               hover = Color(39, 39, 39, 255 * intensity),
            },
            fg = {
               base = Color(222, 222, 222, 255 * intensity),
               hover = Color(255, 255, 255, 255 * intensity),
               pressed = Color(200, 200, 200, 255 * intensity),
               disabled = Color(100, 100, 100, 255 * intensity),
            },
         },
         editBox = {
            width = 300,
            height = 35,
            bg = {
               base = Color(26, 26, 26, 255 * intensity),
               hover = Color(39, 39, 39, 255 * intensity),
            },
            fg = {
               base = Color(222, 222, 222, 255 * intensity),
               hover = Color(255, 255, 255, 255 * intensity),
               pressed = Color(200, 200, 200, 255 * intensity),
               disabled = Color(100, 100, 100, 255 * intensity),
            },
         },
      }
      local pos = {x = x, y = y}

      nvgTextUI(pos, widgetName, opts.widgetName)

      -- Default options
      -- NOTE: Replacing these requires canHide, canPosition to be false
      --       Must use custom variables: canVisible, canAnchor, canOffset, canScale, canZIndex?

      -- Visible

      -- Anchor/Anchor Widget/Anchor Widget Alignment
      -- NOTE: If attached, disabled widget's own anchor and copy it from parent

      -- Offset

      -- Scale

      -- Z-Index
      -- NOTE: If CatoHUD.preview, disable Z-Index (show previous value?)

      -- widget.canPreview is nil defaults to true
      if widget.canPreview ~= false then
         optDelimiter(pos, opts.delimiter)
         CatoHUD.preview = optRowInput(
            optInput.checkBox,
            pos,
            'Preview',
            CatoHUD.preview,
            opts.medium,
            opts.checkBox
         )
      end

      -- widget.canAttach is nil defaults to true
      if widget.canAttach ~= false and widget.userData and widget.userData.anchorWidget then
         -- consolePrint(widgetName)
         -- consolePrint(widget.userData.anchorWidget)
         optDelimiter(pos, opts.delimiter)
         widget.userData.anchorWidget = optRowInput(
            optInput.editBox,
            pos,
            'Attach to',
            widget.userData.anchorWidget,
            opts.medium,
            opts.editBox
         )
         -- consolePrint(widget.userData.anchorWidget)
      end

      if widget.drawOpts then
         optDelimiter(pos, opts.delimiter)
         nvgTextUI(pos, widgetName .. ' Options', opts.medium)
         widget:drawOpts(pos)
      end

      if debugMode then
         optDelimiter(pos, opts.delimiter)
         nvgTextUI(pos, 'Debug', opts.medium)

         local anchor = getProps(widgetName).anchor
         nvgTextUI(pos, 'anchor: ' .. anchor.x .. ' ' .. anchor.y, opts.small)
         nvgTextUI(pos, 'getOptionsHeight(): ' .. widget.optionsHeight, opts.small)
         for _, debugLine in ipairs(debugIndexCache()) do
            nvgTextUI(pos, debugLine, opts.small)
         end
      end

      widget.optionsHeight = pos.y - y

      saveUserData(widget.userData)
   end

   function widget:shouldShow()
      if widgetName == 'CatoHUD' then return true end
      if widgetName == 'Cato_Zoom' then return true end -- FIXME: Better solution

      if CatoHUD.preview then
         -- FIXME: preview should temporarily change zindex to -999?
         return true
      end

      -- FIXME: Combine statements. Should be more efficient?
      local widgetShow = nil
      if widget.userData and widget.userData.show then
         widgetShow = widget.userData.show
      else
         widgetShow = {}
      end

      if not widgetShow.mainMenu then
         if replayActive and replayName == 'menu' then
            return false
         end
      end

      if not widgetShow.menu then
         if loading.loadScreenVisible or isInMenu() then
            return false
         end
      end

      if not widgetShow.dead then
         if not povPlayer or povPlayer.health <= 0 then
            return false
         end
      end

      if not widgetShow.race then
         if gameMode == 'race' or gameMode == 'training' then
            return false
         end
      end

      if not widgetShow.hudOff then
         if consoleGetVariable('cl_show_hud') == 0 then
            return false
         end
      end

      if not widgetShow.gameOver then
         if gameState == GAME_STATE_GAMEOVER then
            return false
         end
      end

      if not widgetShow.freecam then
         if localPov and povPlayer and povPlayer.state ~= PLAYER_STATE_INGAME then
            return false
         end
      end

      if not widgetShow.editor then
         if povPlayer and povPlayer.state == PLAYER_STATE_EDITOR then
            return false
         end
      end

      return true
   end

   function widget:draw()
      if not widget:shouldShow() then
         return
      end

      -- if not isInMenu() then
      --    CatoHUD.preview = false
      -- end

      widget.anchor = getProps(widgetName).anchor

      local anchorWidget = _G[widget.userData and widget.userData.anchorWidget or nil]
      if anchorWidget then
         local anchorOffset = getProps(widget.userData.anchorWidget).offset or {}
         widget.x = (anchorWidget.x or 0) + (anchorOffset.x or 0)
         widget.y = (anchorWidget.y or 0) + (anchorOffset.y or 0)
      else
         widget.x = 0
         widget.y = 0
      end
      widget.width = 0
      widget.height = 0

      widget:drawWidget()
   end
end

----------------------------------------------------------------------------------------------------

function CatoHUD:init()
   local time = formatEpochTime(epochTime, CatoHUD.userData.offsetUTC)
   local offsetHours = CatoHUD.userData.offsetUTC / S_IN_H
   consolePrint(format(
      '\n| CatoHUD loaded\n| %d-%02d-%02d %02d:%02d:%02d (UTC%s)\n',
      time.year,
      time.month,
      time.day,
      time.hour,
      time.minute,
      time.second,
      offsetHours ~= 0 and (offsetHours > 0 and '+' .. offsetHours or offsetHours) or ''
   ))
end

function CatoHUD:drawWidget()
   debugMode = consoleGetVariable('ui_CatoHUD_debug') ~= 0

   povPlayer = players[playerIndexCameraAttachedTo]
   localPlayer = players[playerIndexLocalPlayer]
   localPov = playerIndexCameraAttachedTo == playerIndexLocalPlayer

   gameState = world.gameState
   gameMode = gamemodes[world.gameModeIndex].shortName
   hasTeams = gamemodes[world.gameModeIndex].hasTeams
   map = world.mapName
   mapTitle = world.mapTitle
   ruleset = world.ruleset
   gameTime = world.gameTime
   gameTimeLimit = world.gameTimeLimit

   inReplay = replayActive and replayName ~= 'menu'

   if checkResetConsoleVariable('ui_CatoHUD_reset_widgets', 0) ~= 0 then
      for widgetName, _ in pairs(defaultSettings) do
         _G[widgetName]:resetProperties()
         _G[widgetName]:checkSetUserData(true)
         _G[widgetName]:checkSetCvars(true)
      end
      consolePrint('CatoHUD widgets have been reset')
      if debugMode then consolePerformCommand('saveconfig') end
      playSound('CatoHUD/toasty')
   end

   if checkResetConsoleVariable('ui_CatoHUD_widget_cache', 0) ~= 0 then
      for _, debugLine in ipairs(debugIndexCache()) do
         consolePrint(debugLine)
      end
   end

   if map ~= previousMap then
      warmupTimeElapsed = 0
      previousMap = map
   elseif gameState == GAME_STATE_WARMUP then
      warmupTimeElapsed = warmupTimeElapsed + deltaTime * MS_IN_S
   elseif checkResetConsoleVariable('ui_CatoHUD_warmuptimer_reset', 0) ~= 0 then
      warmupTimeElapsed = 0
   else
      warmupTimeElapsed = 0
   end

   -- Parse events for:
   --    Cato_Chat
   --    Cato_GameEvents
   --    Cato_GameMessages
   --    Cato_FragMessage
   --    Cato_Toasty
   for _, event in ipairs(log) do
      -- consoleTablePrint(event)
   end

   -- Parse players for:
   --    Cato_BurstAccuracy
   --    Cato_Chat
   --    Cato_FakeBeam
   for _, p in ipairs(players) do
      -- consoleTablePrint(p)
   end
end

CatoHUD:registerWidget('CatoHUD', CatoHUD)

----------------------------------------------------------------------------------------------------

Cato_GameTime = {}

function Cato_GameTime:drawWidget()
   local opts = {
      minutes = {
         font = self.userData.fontFace,
         color = Color(255, 255, 255),
         size = self.userData.fontSize,
         anchor = {x = 1},
      },
      seconds = {
         font = self.userData.fontFace,
         color = Color(255, 255, 255),
         size = self.userData.fontSize,
         anchor = {x = -1},
      },
      delimiter = {
         font = self.userData.fontFace,
         color = Color(127, 127, 127),
         size = self.userData.fontSize,
         anchor = {x = 0},
      },
   }

   local hideSeconds = self.userData.hideSeconds

   local timeElapsed = 0
   if gameState == GAME_STATE_WARMUP then
      timeElapsed = warmupTimeElapsed
   elseif gameState == GAME_STATE_ACTIVE or gameState == GAME_STATE_ROUNDACTIVE then
      timeElapsed = gameTime
      hideSeconds = (hideSeconds and gameTimeLimit - gameTime > 30000)
   end

   local timer = formatTimeMs(timeElapsed, gameTimeLimit, self.userData.countDown)

   local minutes = createTextElem(self.anchor, timer.minutes, opts.minutes)
   local delimiter = createTextElem(self.anchor, ':', opts.delimiter)
   local seconds = hideSeconds and 'xx' or format('%02d', timer.seconds)
   seconds = createTextElem(self.anchor, seconds, opts.seconds)

   local x = self.x
   local spacing = delimiter.width / 2
   if self.anchor.x == -1 then
      x = x + minutes.width + spacing
   elseif self.anchor.x == 0 then
      x = x + 0
   elseif self.anchor.x == 1 then
      x = x - (seconds.width + spacing)
   end

   minutes.draw(x - spacing, self.y)
   delimiter.draw(x, self.y)
   seconds.draw(x + spacing, self.y)

   self.width = minutes.width + delimiter.width + seconds.width
   self.height = max(minutes.height, seconds.height, delimiter.height)
end

CatoHUD:registerWidget('Cato_GameTime', Cato_GameTime)

----------------------------------------------------------------------------------------------------

Cato_FollowingPlayer = {}

function Cato_FollowingPlayer:drawWidget()
   if not povPlayer then return end

   -- TODO: option for display on self
   if not CatoHUD.preview and localPov then return end

   local opts = {
      font = self.userData.fontFace,
      color = Color(255, 255, 255),
      size = self.userData.fontSize,
      anchor = self.userData.textAnchor,
   }

   local label = createTextElem(self.anchor, 'FOLLOWING', opts)
   local name = createTextElem(self.anchor, povPlayer.name, opts)

   local x = self.x
   if self.anchor.x == -1 then
      x = x + max(label.width, name.width) / 2
   elseif self.anchor.x == 0 then
      x = x + 0
   elseif self.anchor.x == 1 then
      x = x - (max(label.width, name.width) / 2)
   end

   local y = self.y
   local offset = opts.size / 3
   if self.anchor.y == -1 then
      y = y + 0
   elseif self.anchor.y == 0 then
      y = y - (label.height - offset) / 2
   elseif self.anchor.y == 1 then
      y = y - (name.height - offset)
   end

   label.draw(x, y)
   name.draw(x, y + label.height - offset)

   self.width = max(label.width, name.width)
   self.height = label.height + name.height
end

CatoHUD:registerWidget('Cato_FollowingPlayer', Cato_FollowingPlayer)

----------------------------------------------------------------------------------------------------

Cato_FPS = {}

function Cato_FPS:drawWidget()
   local opts = {
      font = self.userData.fontFace,
      color = Color(255, 255, 255),
      size = self.userData.fontSize,
   }

   local fps = min(round(1 / deltaTime), consoleGetVariable('com_maxfps'))

   fps = createTextElem(self.anchor, fps .. 'fps', opts)
   fps.draw(self.x, self.y)

   self.width = fps.width
   self.height = fps.height
end

CatoHUD:registerWidget('Cato_FPS', Cato_FPS)

----------------------------------------------------------------------------------------------------

Cato_Time = {}

function Cato_Time:drawWidget()
   -- epochTime only
   -- if true then
   --    local time = formatEpochTime(epochTime, CatoHUD.userData.offsetUTC)
   --    local epochSeconds = epochTime + CatoHUD.userData.offsetUTC
   --    opts.second.anchor = self.anchor
   --    epochSeconds = createTextElem(self.anchor, epochSeconds, opts.second)
   --    epochSeconds.draw(self.x, self.y)
   --    self.width = epochSeconds.width
   --    self.height = epochSeconds.height
   --    return
   -- end

   -- full datetime
   -- if true then
   --    local opts = {
   --       delimiter = {
   --          font = self.userData.fontFace,
   --          color = Color(127, 127, 127),
   --          size = self.userData.fontSize,
   --          anchor = {x = -1},
   --       },
   --       year = {
   --          font = self.userData.fontFace,
   --          color = Color(255, 255, 255),
   --          size = self.userData.fontSize,
   --          anchor = {x = -1},
   --       },
   --       month = {
   --          font = self.userData.fontFace,
   --          color = Color(255, 255, 255),
   --          size = self.userData.fontSize,
   --          anchor = {x = -1},
   --       },
   --       day = {
   --          font = self.userData.fontFace,
   --          color = Color(255, 255, 255),
   --          size = self.userData.fontSize,
   --          anchor = {x = -1},
   --       },
   --       hour = {
   --          font = self.userData.fontFace,
   --          color = Color(255, 255, 255),
   --          size = self.userData.fontSize,
   --          anchor = {x = -1},
   --       },
   --       minute = {
   --          font = self.userData.fontFace,
   --          color = Color(255, 255, 255),
   --          size = self.userData.fontSize,
   --          anchor = {x = -1},
   --       },
   --       second = {
   --          font = self.userData.fontFace,
   --          color = Color(255, 255, 255),
   --          size = self.userData.fontSize,
   --          anchor = {x = -1},
   --       },
   --    }

   --    local time = formatEpochTime(epochTime, CatoHUD.userData.offsetUTC)

   --    local day = createTextElem(self.anchor, formatDay(time.day), opts.day)
   --    local delimiterDate1 = createTextElem(self.anchor, ' ', opts.delimiter)
   --    local month = createTextElem(self.anchor, formatMonth(time.month), opts.month)
   --    self.width = self.width + day.width + delimiterDate1.width + month.width
   --    self.height = max(self.height, day.height, delimiterDate1.height, month.height)

   --    local delimiterDate2 = createTextElem(self.anchor, ' ', opts.delimiter)
   --    local year = createTextElem(self.anchor, time.year, opts.year)
   --    self.width = self.width + delimiterDate2.width + year.width
   --    self.height = max(self.height, delimiterDate2.height, year.height)

   --    local delimiter = createTextElem(self.anchor, ' ', opts.delimiter)
   --    self.width = self.width + delimiter.width
   --    self.height = max(self.height, delimiter.height)

   --    local hour = createTextElem(self.anchor, format('%02d', time.hour), opts.hour)
   --    local delimiterTime1 = createTextElem(self.anchor, ':', opts.delimiter)
   --    local minute = createTextElem(self.anchor, format('%02d', time.minute), opts.minute)
   --    self.width = self.width + hour.width + delimiterTime1.width + minute.width
   --    self.height = max(self.height, hour.height, delimiterTime1.height, minute.height)

   --    local delimiterTime2 = createTextElem(self.anchor, ':', opts.delimiter)
   --    local second = createTextElem(self.anchor, format('%02d', time.second), opts.second)
   --    self.width = self.width + delimiterTime2.width + second.width
   --    self.height = max(self.height, delimiterTime2.height, second.height)

   --    local x = self.x
   --    if self.anchor.x == -1 then
   --       x = x + 0
   --    elseif self.anchor.x == 0 then
   --       x = x - self.width / 2
   --    elseif self.anchor.x == 1 then
   --       x = x - self.width
   --    end

   --    day.draw(x, self.y)
   --    x = x + day.width
   --    delimiterDate1.draw(x, self.y)
   --    x = x + delimiterDate1.width
   --    month.draw(x, self.y)
   --    x = x + month.width

   --    delimiterDate2.draw(x, self.y)
   --    x = x + delimiterDate2.width
   --    year.draw(x, self.y)
   --    x = x + year.width

   --    delimiter.draw(x, self.y)
   --    x = x + delimiter.width

   --    hour.draw(x, self.y)
   --    x = x + hour.width
   --    delimiterTime1.draw(x, self.y)
   --    x = x + delimiterTime1.width
   --    minute.draw(x, self.y)
   --    x = x + minute.width

   --    delimiterTime2.draw(x, self.y)
   --    x = x + delimiterTime2.width
   --    second.draw(x, self.y)
   -- end

   local opts = {
      hour = {
         font = self.userData.fontFace,
         color = Color(255, 255, 255),
         size = self.userData.fontSize,
         anchor = {x = 1},
      },
      minute = {
         font = self.userData.fontFace,
         color = Color(255, 255, 255),
         size = self.userData.fontSize,
         anchor = {x = -1},
      },
      delimiter = {
         font = self.userData.fontFace,
         color = Color(127, 127, 127),
         size = self.userData.fontSize,
         anchor = {x = 0},
      },
   }

   local epochSeconds = epochTime + CatoHUD.userData.offsetUTC
   local hour = floor(epochSeconds / S_IN_H) % H_IN_D
   local delimiter = ':'
   local minute = floor(epochSeconds / S_IN_M) % M_IN_H

   hour = createTextElem(self.anchor, format('%02d', hour), opts.hour)
   delimiter = createTextElem(self.anchor, delimiter, opts.delimiter)
   minute = createTextElem(self.anchor, format('%02d', minute), opts.minute)
   self.width = self.width + hour.width + delimiter.width + minute.width
   self.height = max(self.height, hour.height, delimiter.height, minute.height)

   local x = self.x
   local spacing = delimiter.width / 2
   if self.anchor.x == -1 then
      x = x + hour.width + spacing
   elseif self.anchor.x == 0 then
      x = x + 0
   elseif self.anchor.x == 1 then
      x = x - (minute.width + spacing)
   end

   hour.draw(x - spacing, self.y)
   delimiter.draw(x, self.y)
   minute.draw(x + spacing, self.y)
end

CatoHUD:registerWidget('Cato_Time', Cato_Time)

----------------------------------------------------------------------------------------------------

Cato_Scores = {}

function Cato_Scores:drawWidget()
   local opts = {
      team = {
         font = self.userData.fontFace,
         color = ColorHEX(consoleGetVariable('cl_color_friend')),
         size = self.userData.fontSize,
         anchor = {x = 1},
      },
      enemy = {
         font = self.userData.fontFace,
         color = ColorHEX(consoleGetVariable('cl_color_enemy')),
         size = self.userData.fontSize,
         anchor = {x = -1},
      },
      delimiter = {
         font = self.userData.fontFace,
         color = Color(127, 127, 127),
         size = self.userData.fontSize,
         anchor = {x = 0},
      },
   }

   local scoreTeam = nil
   local indexTeam = nil
   local scoreEnemy = nil
   local indexEnemy = nil
   local relativeColors = consoleGetVariable('cl_colors_relative') == 1
   if hasTeams then
      if povPlayer and povPlayer.state == PLAYER_STATE_INGAME then
         indexTeam = povPlayer.team
         indexEnemy = indexTeam % 2 + 1
         if not relativeColors then
            opts.team.color = teamColors[indexTeam]
            opts.enemy.color = teamColors[indexEnemy]
         end
      else
         indexTeam = TEAM_ALPHA
         indexEnemy = TEAM_ZETA
         opts.team.color = teamColors[indexTeam]
         opts.enemy.color = teamColors[indexEnemy]
      end
      scoreTeam = world.teams[indexTeam].score
      scoreEnemy = world.teams[indexEnemy].score
   elseif gameMode == '1v1' or gameMode == 'ffa' then
      local scoreWinner = nil
      local scoreRunnerUp = nil
      local indexWinner = nil
      local indexRunnerUp = nil
      for _, p in ipairs(players) do
         if p.state == PLAYER_STATE_INGAME and p.connected then
            if scoreWinner == nil or p.score > scoreWinner then
               scoreWinner = p.score
               indexWinner = p.index
            elseif scoreRunnerUp == nil or p.score > scoreRunnerUp then
               scoreRunnerUp = p.score
               indexRunnerUp = p.index
            end
         end
      end

      scoreTeam = scoreWinner
      indexTeam = indexWinner
      scoreEnemy = scoreRunnerUp
      indexEnemy = indexRunnerUp
      if povPlayer and povPlayer.state == PLAYER_STATE_INGAME and povPlayer.connected then
         if indexWinner == povPlayer.index then
            scoreTeam = scoreWinner
            indexTeam = indexWinner
            scoreEnemy = scoreRunnerUp
            indexEnemy = indexRunnerUp
         elseif indexRunnerUp == povPlayer.index then
            scoreTeam = scoreRunnerUp
            indexTeam = indexRunnerUp
            scoreEnemy = scoreWinner
            indexEnemy = indexWinner
         else
            scoreTeam = povPlayer.score
            indexTeam = povPlayer.index
            scoreEnemy = scoreWinner
            indexEnemy = indexWinner
         end
      end

      -- Use player colors in FFA/1v1
      if not relativeColors or not povPlayer or povPlayer.state ~= PLAYER_STATE_INGAME then
         if indexTeam ~= nil then
            opts.team.color = extendedColors[players[indexTeam].colorIndices[1] + 1]
         end
         if indexEnemy ~= nil then
            opts.enemy.color = extendedColors[players[indexEnemy].colorIndices[1] + 1]
         end
      end
   elseif gameMode == 'race' then
      return -- TODO
   elseif gameMode == 'training' then
      return -- TODO
   else
      return
   end

   scoreTeam = createTextElem(self.anchor, scoreTeam or 'N/A', opts.team)
   local delimiter = createTextElem(self.anchor, '    ', opts.delimiter)
   scoreEnemy = createTextElem(self.anchor, scoreEnemy or 'N/A', opts.enemy)

   -- TODO: This alignment bs has to be figured out
   local x = self.x
   local spacing = delimiter.width / 2
   if self.anchor.x == -1 then
      x = x + scoreTeam.width + spacing
   elseif self.anchor.x == 0 then
      x = x + 0
   elseif self.anchor.x == 1 then
      x = x - (scoreEnemy.width + spacing)
   end

   scoreTeam.draw(x - spacing, self.y)
   delimiter.draw(x, self.y)
   scoreEnemy.draw(x + spacing, self.y)

   self.width = scoreTeam.width + delimiter.width + scoreEnemy.width
   self.height = max(scoreTeam.height, delimiter.height, scoreEnemy.height)
end

CatoHUD:registerWidget('Cato_Scores', Cato_Scores)

----------------------------------------------------------------------------------------------------

Cato_GameModeName = {}

function Cato_GameModeName:drawWidget()
   if not inReplay and gameState ~= GAME_STATE_WARMUP then return end

   local opts = {
      font = self.userData.fontFace,
      color = Color(255, 255, 255),
      size = self.userData.fontSize,
   }

   local gameModeName = createTextElem(self.anchor, gameMode, opts)
   gameModeName.draw(self.x, self.y)

   self.width = gameModeName.width
   self.height = gameModeName.height
end

CatoHUD:registerWidget('Cato_GameModeName', Cato_GameModeName)

----------------------------------------------------------------------------------------------------

Cato_RulesetName = {}

function Cato_RulesetName:drawWidget()
   if not inReplay and gameState ~= GAME_STATE_WARMUP then return end

   local opts = {
      font = self.userData.fontFace,
      color = Color(255, 255, 255),
      size = self.userData.fontSize,
   }

   local rulesetName = createTextElem(self.anchor, ruleset, opts)
   rulesetName.draw(self.x, self.y)

   self.width = rulesetName.width
   self.height = rulesetName.height
end

CatoHUD:registerWidget('Cato_RulesetName', Cato_RulesetName)

----------------------------------------------------------------------------------------------------

Cato_MapName = {}

function Cato_MapName:drawWidget()
   if not inReplay and gameState ~= GAME_STATE_WARMUP then return end

   local opts = {
      font = self.userData.fontFace,
      color = Color(255, 255, 255),
      size = self.userData.fontSize,
   }

   local mapName = createTextElem(self.anchor, mapTitle, opts)
   mapName.draw(self.x, self.y)

   self.width = mapName.width
   self.height = mapName.height
end

CatoHUD:registerWidget('Cato_MapName', Cato_MapName)

----------------------------------------------------------------------------------------------------

Cato_ReadyStatus = {}

function Cato_ReadyStatus:drawWidget()
   if gameState ~= GAME_STATE_WARMUP and not CatoHUD.preview then return end

   local opts = {
      font = self.userData.fontFace,
      color = Color(255, 255, 255),
      size = self.userData.fontSize,
   }

   local playersReady = 0
   local playersGame = 0
   for _, p in ipairs(players) do
      if p.state == PLAYER_STATE_INGAME and p.connected then
         playersGame = playersGame + 1
         if p.ready then
            playersReady = playersReady + 1
         end
      end
   end

   local ready = createTextElem(self.anchor, playersReady .. '/' .. playersGame .. ' ready', opts)
   ready.draw(self.x, self.y)

   self.width = ready.width
   self.height = ready.height
end

CatoHUD:registerWidget('Cato_ReadyStatus', Cato_ReadyStatus)

----------------------------------------------------------------------------------------------------

Cato_GameMessages = {}

function Cato_GameMessages:init()
   self.lastTickSeconds = -1
end

function Cato_GameMessages:drawWidget()
   local opts = {
      font = self.userData.fontFace,
      color = Color(255, 255, 255),
      size = self.userData.fontSize,
   }

   local gameMessage = nil
   if world.timerActive then
      if gameState == GAME_STATE_WARMUP or gameState == GAME_STATE_ROUNDPREPARE then
         local timer = formatTimeMs(gameTime, gameTimeLimit, true)
         if self.lastTickSeconds ~= timer.seconds then
            self.lastTickSeconds = timer.seconds
            playSound('internal/ui/match/match_countdown_tick')
         end
         gameMessage = timer.seconds
      elseif gameState == GAME_STATE_ACTIVE or gameState == GAME_STATE_ROUNDACTIVE then
         if gameTime < 2500 then
            local overTimeCount = world.overTimeCount
            if overTimeCount <= 0 then
               gameMessage = (gameMode == 'race' or gameMode == 'training') and 'GO' or 'FIGHT'
            else
               gameMessage = 'OVERTIME #' .. overTimeCount
            end
         end
      elseif gameState == GAME_STATE_ROUNDCOOLDOWN_SOMEONEWON then
         if povPlayer ~= nil then
            local name = hasTeams and world.teams[povPlayer.team].name or povPlayer.name
            gameMessage = name .. ' WINS'
         else
            gameMessage = 'Round Over'
         end
      elseif gameState == GAME_STATE_ROUNDCOOLDOWN_DRAW then
         gameMessage = 'DRAW'
      end
   end

   if CatoHUD.preview then
      if gameMessage == nil then
         gameMessage = '(Game Message)'
      end
   elseif gameMessage == nil or isInMenu() then
      return
   end

   gameMessage = createTextElem(self.anchor, gameMessage, opts)
   gameMessage.draw(self.x, self.y)

   self.width = gameMessage.width
   self.height = gameMessage.height
end

CatoHUD:registerWidget('Cato_GameMessages', Cato_GameMessages)

----------------------------------------------------------------------------------------------------

Cato_Speed = {}

function Cato_Speed:drawWidget()
   if not povPlayer then return end

   local opts = {
      font = self.userData.fontFace,
      color = Color(255, 255, 255),
      size = self.userData.fontSize,
   }

   local ups = createTextElem(self.anchor, ceil(povPlayer.speed) .. 'ups', opts)
   ups.draw(self.x, self.y)

   self.width = ups.width
   self.height = ups.height
end

CatoHUD:registerWidget('Cato_Speed', Cato_Speed)

----------------------------------------------------------------------------------------------------

Cato_LowAmmo = {}

-- local attackButton = 'mouse1'
-- local attackUnbound = false
-- local attackCommand = '+attack; cl_camera_next_player; ui_RocketLagNullifier_attack 1'

function Cato_LowAmmo:drawWidget()
   if not povPlayer or povPlayer.infoHidden then return end

   local weaponIndexSelected = povPlayer.weaponIndexSelected
   if weaponDefinitions[weaponIndexSelected] == nil then return end

   local ammoLow = weaponDefinitions[weaponIndexSelected].lowAmmoWarning
   local ammo = povPlayer.weapons[weaponIndexSelected].ammo
   if ammo > ammoLow then return end

   local opts = {
      font = self.userData.fontFace,
   -- TODO: lerp color from white to yellow to red?
   --       visual indicator of halfway point is useful!
   -- TODO: optimize by precalculating midpoints between low ammo to no ammo
   -- just lerp from yellow to red for now
      color = lerpColor(Color(255, 0, 0), Color(255, 255, 0), (ammo - 1) / ammoLow),
      size = self.userData.fontSize,
   }

   if ammo <= 0 then
      opts.color = Color(95, 95, 95)
   end

   -- FIXME: Doesn't work. Possible fixes:
   --        (1) Temporarily unbind +attack until more ammo or weapon is switched
   --        (2) Use a custom command for +attack (requires "holding detection"?)
   --        (3) Just unbind +attack if no ammo for current weapon
   -- if self.userData.preventEmptyAttack and localPov and povPlayer.buttons.attack then
   --    consolePerformCommand('-attack')
   --    consolePrint('No ammo. Prevent shooting')
   -- end
   -- attackButton = bindReverseLookup('+attack', 'game')
   -- if localPov and self.userData.preventEmptyAttack then
   --    if ammo > 0 then
   --       consolePerformCommand('bind game ' .. attackButton .. ' ' .. attackCommand)
   --    elseif ammo == 1 then
   --       if povPlayer.buttons.attack then
   --          consolePerformCommand('-attack')
   --       end
   --    else
   --       consolePerformCommand('unbind game ' .. attackButton)
   --    end
   -- end

   -- local lowAmmoText = ammo <= 0 and 'LOW AMMO: ' .. ammo or 'NO AMMO: ' .. ammo
   -- local ammoWarning = createTextElem(self.anchor, lowAmmoText, opts)

   local ammoWarning = createTextElem(self.anchor, ammo, opts)
   ammoWarning.draw(self.x, self.y)

   self.width = ammoWarning.width
   self.height = ammoWarning.height
end

CatoHUD:registerWidget('Cato_LowAmmo', Cato_LowAmmo)

----------------------------------------------------------------------------------------------------

Cato_PacketLoss = {}

function Cato_PacketLoss:drawWidget()
   if not povPlayer or povPlayer.state == PLAYER_STATE_SPECTATOR then return end

   local opts = {
      font = self.userData.fontFace,
      color = Color(255, 0, 0),
      size = self.userData.fontSize,
   }

   if povPlayer.packetLoss == 0 then
      return
   elseif povPlayer.packetLoss <= 5 then
      opts.color = Color(255, 255, 255)
   elseif povPlayer.packetLoss < 10 then
      opts.color = Color(255, 255, 0)
   else
      opts.color = Color(255, 0, 0)
   end

   local packetloss = createTextElem(self.anchor, povPlayer.packetLoss .. ' PL', opts)
   packetloss.draw(self.x, self.y)

   self.width = packetloss.width
   self.height = packetloss.height
end

CatoHUD:registerWidget('Cato_PacketLoss', Cato_PacketLoss)

----------------------------------------------------------------------------------------------------

Cato_Ping = {}

function Cato_Ping:drawWidget()
   if not povPlayer or povPlayer.state == PLAYER_STATE_SPECTATOR then return end

   local opts = {
      font = self.userData.fontFace,
      color = Color(255, 255, 255),
      size = self.userData.fontSize,
   }

   if povPlayer.latency == 0 then
      return
   elseif povPlayer.latency <= 50 then
      opts.color = Color(0, 255, 0)
   elseif povPlayer.latency < 100 then
      opts.color = Color(255, 255, 0)
   else
      opts.color = Color(255, 0, 0)
   end

   local ping = createTextElem(self.anchor, povPlayer.latency .. 'ms', opts)
   ping.draw(self.x, self.y)

   self.width = ping.width
   self.height = ping.height
end

CatoHUD:registerWidget('Cato_Ping', Cato_Ping)

----------------------------------------------------------------------------------------------------

Cato_HealthNumber = {}

function Cato_HealthNumber:drawWidget()
   if not povPlayer or povPlayer.state == PLAYER_STATE_SPECTATOR then return end

   local opts = {
      font = self.userData.fontFace,
      color = Color(191, 191, 191),
      size = self.userData.fontSize,
      anchor = self.userData.textAnchor,
   }

   local playerHealth = 'N/A'
   if not povPlayer.infoHidden then
      playerHealth = povPlayer.health

      local damage = damageToKill(povPlayer.health, povPlayer.armor, povPlayer.armorProtection)
      if damage <= 80 then
         opts.color = Color(255, 0, 0)
      elseif damage <= 100 then
         opts.color = Color(255, 255, 0)
      else
         opts.color = Color(255, 255, 255)
      end
   end

   local health = createTextElem(self.anchor, playerHealth, opts)
   health.draw(self.x, self.y)

   self.width = health.width
   self.height = health.height
end

CatoHUD:registerWidget('Cato_HealthNumber', Cato_HealthNumber)

----------------------------------------------------------------------------------------------------

Cato_ArmorNumber = {}

function Cato_ArmorNumber:drawWidget()
   if not povPlayer or povPlayer.state == PLAYER_STATE_SPECTATOR then return end

   local opts = {
      font = self.userData.fontFace,
      color = Color(191, 191, 191),
      size = self.userData.fontSize,
      anchor = self.userData.textAnchor,
   }

   local playerArmor = 'N/A'
   if not povPlayer.infoHidden then
      playerArmor = povPlayer.armor

      opts.color = CatoHUD.userData['armorColor' .. povPlayer.armorProtection]
      opts.color = armorColorLerp(playerArmor, povPlayer.armorProtection, opts.color)

      -- local lerpSteps = floor(playerArmor / armorLimit[povPlayer.armorProtection + 1][0])

      -- local lerpSteps = -1
      -- for itemArmorProtection = 0, 2 do
      --    if playerArmor < armorLimit[povPlayer.armorProtection + 1][itemArmorProtection + 1] then
      --       lerpSteps = lerpSteps + 1
      --    end
      -- end

      -- local colorToLerp = lerpSteps < 0 and Color(255, 255, 255) or Color(0, 0, 0)
      -- opts.color = lerpColor(opts.color, colorToLerp, abs(lerpSteps) * 0.33)

      -- consoleColorPrint(opts.color)
      -- consoleColorPrint(colorToLerp)

      -- debug
      -- playerArmor = povPlayer.armor .. ' ' .. armorQuality(povPlayer) * povPlayer.armor

      -- local playerArmorLimit = playerArmor * armorQuality[povPlayer.armorProtection]
      -- playerArmorLimit = ceil(playerArmorLimit)
      -- if playerArmorLimit < armorQuality[0] * armorMax[0] then
      --    opts.color = lerpColor(opts.color, Color(0, 0, 0), 2 / 3)
      -- elseif playerArmorLimit < armorQuality[1] * armorMax[1] then
      --    opts.color = lerpColor(opts.color, Color(0, 0, 0), 1 / 3)
      -- elseif playerArmorLimit < armorQuality[2] * armorMax[2] then
      --    opts.color = lerpColor(opts.color, Color(0, 0, 0), 0)
      -- end

      -- FIXME: Better way?
      -- opts.color = CatoHUD.userData['armorColor' .. povPlayer.armorProtection]
      -- if povPlayer.armorProtection == 2 then
      --     -- RA <  66 -> can pickup GA
      --    if playerArmor < 66 then
      --       opts.color = lerpColor(opts.color, Color(0, 0, 0), 0.66)
      --     -- RA < 132 -> can pickup YA
      --    elseif playerArmor < 132 then
      --       opts.color = lerpColor(opts.color, Color(0, 0, 0), 0.33)
      --     -- RA < 200 -> can pickup RA
      --    elseif playerArmor < 200 then
      --       opts.color = lerpColor(opts.color, Color(0, 0, 0), 0)
      --    end
      -- elseif povPlayer.armorProtection == 1 then
      --     -- YA <  75 -> can pickup GA
      --    if playerArmor < 75 then
      --       opts.color = lerpColor(opts.color, Color(0, 0, 0), 0.66)
      --     -- YA < 150 -> can pickup YA
      --    elseif playerArmor < 150 then
      --       opts.color = lerpColor(opts.color, Color(0, 0, 0), 0.33)
      --    end
      -- elseif povPlayer.armorProtection == 0 then
      --     -- GA < 100 -> can pickup GA
      --    if playerArmor < 100 then
      --       opts.color = lerpColor(opts.color, Color(0, 0, 0), 0.66)
      --    end
      -- end
   end


   local armor = createTextElem(self.anchor, playerArmor, opts)
   armor.draw(self.x, self.y)

   self.width = armor.width
   self.height = armor.height
end

CatoHUD:registerWidget('Cato_ArmorNumber', Cato_ArmorNumber)

----------------------------------------------------------------------------------------------------

Cato_ArmorIcon = {}

function Cato_ArmorIcon:drawWidget()
   if not povPlayer or povPlayer.state == PLAYER_STATE_SPECTATOR then return end

   local opts = {
      color = CatoHUD.userData.noArmorColor,
      size = self.userData.iconSize,
   }

   if not povPlayer.infoHidden then
      opts.color = CatoHUD.userData['armorColor' .. povPlayer.armorProtection]
   end

   local armor = createSvgElem(self.anchor, 'internal/ui/icons/armor', opts)
   armor.draw(self.x, self.y)

   self.width = armor.width
   self.height = armor.height
end

CatoHUD:registerWidget('Cato_ArmorIcon', Cato_ArmorIcon)

----------------------------------------------------------------------------------------------------

Cato_Zoom = {canHide = false, canPosition = false, canPreview = false}

function Cato_Zoom:init()
   self.scoreboardFound = getProps('Scoreboard').visible ~= nil
end

function Cato_Zoom:drawWidget()
   local zoomFov = abs(self.userData.fov)
   local zoomSens = abs(self.userData.sensitivity)
   local zoomAnimTime = abs(self.userData.time)

   -- TODO: Animation
   if consoleGetVariable('ui_CatoHUD_zoom') ~= 0 then
      if showScores and not self.zooming then
            self.zooming = true
            self.zoomTime = 0
            consolePerformCommand('cl_show_gun 0')
            consolePerformCommand('m_speed ' .. zoomSens)
            if zoomAnimTime == 0 then
               consolePerformCommand('r_fov ' .. zoomFov)
            end
            if self.zoomPreScoreboard then
               consolePerformCommand('ui_hide_widget Scoreboard')
            end
      elseif (not showScores or isInMenu()) and self.zooming then
         consolePerformCommand('-showscores')
         consolePerformCommand('ui_CatoHUD_zoom 0')
         self.zooming = false
         consolePerformCommand('cl_show_gun ' .. self.zoomPreGun)
         consolePerformCommand('m_speed ' .. self.zoomPreSens)
         if zoomAnimTime == 0 then
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
      self.zoomPreScoreboard = self.scoreboardFound and getProps('Scoreboard').visible
   end
end

CatoHUD:registerWidget('Cato_Zoom', Cato_Zoom)

----------------------------------------------------------------------------------------------------
