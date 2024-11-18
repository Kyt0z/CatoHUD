------------------------------------------------------------------------------------------------------------------------
-- luacheck
------------------------------------------------------------------------------------------------------------------------

-- FIXME: Can I not get these warnings suppressed easier?

-- reflexcore.lua
-- luacheck: globals GAME_STATE_ACTIVE GAME_STATE_GAMEOVER GAME_STATE_ROUNDACTIVE GAME_STATE_ROUNDCOOLDOWN_DRAW
-- luacheck: globals GAME_STATE_ROUNDCOOLDOWN_SOMEONEWON GAME_STATE_ROUNDPREPARE GAME_STATE_WARMUP LOG_TYPE_DEATHMESSAGE
-- luacheck: globals PLAYER_STATE_EDITOR PLAYER_STATE_INGAME PLAYER_STATE_SPECTATOR STATE_CONNECTED STATE_CONNECTING
-- luacheck: globals STATE_DISCONNECTED WIDGET_PROPERTIES_COL_WIDTH

-- gamestrings.lua
-- luacheck: globals mutatorDefinitions

-- LuaVariables.txt
-- luacheck: globals deltaTime epochTime extendedColors gamemodes loading log playerIndexCameraAttachedTo
-- luacheck: globals playerIndexLocalPlayer players replayActive replayName showScores teamColors weaponDefinitions
-- luacheck: globals widgets world

-- LuaFunctions.txt
-- luacheck: globals consoleGetVariable consolePerformCommand consolePrint isInMenu mouseRegion nvgBeginPath nvgFill
-- luacheck: globals nvgFillColor nvgFontBlur nvgFontFace nvgFontSize nvgIntersectScissor nvgLineTo nvgMoveTo nvgRect
-- luacheck: globals nvgRestore nvgSave nvgStroke nvgStrokeColor nvgSvg nvgText nvgTextAlign nvgTextWidth playSound
-- luacheck: globals registerWidget saveUserData textRegion textRegionSetCursor widgetCreateConsoleVariable
-- luacheck: globals widgetSetConsoleVariable

-- CatoHUD
-- luacheck: no self
-- luacheck: allow defined top
-- _luacheck: allow defined
-- _luacheck: no redefined
-- _luacheck: unused, ignore (for now)
-- luacheck: ignore rad2deg clamp (math)
-- luacheck: ignore consoleTablePrint consoleColorPrint (debug functions)

------------------------------------------------------------------------------------------------------------------------
-- Math/Lua
------------------------------------------------------------------------------------------------------------------------

local floor = math.floor
local ceil = math.ceil
local abs = math.abs
local min = math.min
local max = math.max
local sin = math.sin
local csc = function(x) return 1 / sin(x) end
local tan = math.tan
local atan = math.atan
local atan2 = math.atan2
local pi = math.pi
local sqrt = math.sqrt
local deg2rad = function(x) return x * pi / 180 end
local rad2deg = function(x) return x * 180 / pi end
local format = string.format
local rep = string.rep
local sub = string.sub

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

-- local function armorMax(armorProtection)
--    return floor(200 * (armorProtection + 2) / 4)
-- end
-- local function armorQuality(armorProtection)
--    return floor(100 * (armorProtection + 1) / (armorProtection + 2)) / 100
-- end
-- local function armorLimit(pArmorProt, iArmorProt)
--    return floor(armorMax(iArmorProt) * armorQuality(iArmorProt) / armorQuality(pArmorProt))
-- end
-- -- Precalculate these constants to save time
-- local armorMax = {armorMax(0), armorMax(1), armorMax(2)} -- {100, 150, 200}
-- local armorQuality = {armorQuality(0), armorQuality(1), armorQuality(2)} -- {0.50, 0.66, 0.75}
-- local armorLimit = {
--    {armorLimit(0, 0), armorLimit(0, 1), armorLimit(0, 2)}, -- 100, 198, 300
--    {armorLimit(1, 0), armorLimit(1, 1), armorLimit(1, 2)}, --  75, 150, 227
--    {armorLimit(2, 0), armorLimit(2, 1), armorLimit(2, 2)}, --  66, 132, 200
-- }
-- consolePrint('---')
-- consoleTablePrint(armorMax)
-- consoleTablePrint(armorQuality)
-- consoleTablePrint(armorLimit)
-- consolePrint('---')
-- -- Precalculate these constants to save time
-- local armorMax = {}
-- local armorQuality = {}
-- for i = 1, 3 do
--    armorMax[i] = floor(200 * (i + 1) / 4)
--    armorQuality[i] = floor(100 * i / (i + 1)) / 100
-- end
-- local armorLimit = {}
-- for i = 1, 3 do
--    armorLimit[i] = {}
--    for j = 1, 3 do
--       armorLimit[i][j] = floor(armorMax[j] * armorQuality[j] / armorQuality[i])
--    end
-- end
-- consoleTablePrint(armorMax)
-- consoleTablePrint(armorQuality)
-- consoleTablePrint(armorLimit)
-- consolePrint('---')
-- NOTE: "Why not simply? What if they change in a future update?"
--       The previous calculations are constant as well anyways, since nothing is tied to ruleset.
local armorMax = {100, 150, 200}
local armorQuality = {0.5, 0.66, 0.75}
local armorLimit = {
   {100, 198, 300},
   { 75, 150, 227},
   { 66, 132, 200},
}
-- consoleTablePrint(armorMax)
-- consoleTablePrint(armorQuality)
-- consoleTablePrint(armorLimit)
-- consolePrint('---')

local function damageToKill(health, armor, armorProtection)
   return min(armor, health * (armorProtection + 1)) + health
end

------------------------------------------------------------------------------------------------------------------------
-- Time
------------------------------------------------------------------------------------------------------------------------

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

local function formatEpochTime(epochTimestamp, offsetUTC)
   local epochSeconds = epochTimestamp + offsetUTC

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

   -- -- TODO: Optimization (even further)
   -- -- Overshoot yearTo such that epochSeconds < 0, and then add the year's seconds back to it?
   -- -- Test case: year is k*365 or k*366 >= yearFrom, k >= 1
   -- local yearFrom = 1970
   -- local year = yearFrom
   -- while epochSeconds >= secondsInYear(year) do
   --    year = year + floor(epochSeconds / S_IN_Y)
   --    local yearsMod4Since = yearsModSince(yearFrom, year, 4)
   --    local yearsMod100Since = yearsModSince(yearFrom, year, 100)
   --    local yearsMod400Since = yearsModSince(yearFrom, year, 400)
   --    local leapYears = yearsMod4Since - yearsMod100Since + yearsMod400Since
   --    local nonLeapYears = year - leapYears
   --    epochSeconds = epochSeconds - (leapYears * S_IN_LY + nonLeapYears * S_IN_Y)
   --    yearFrom = year
   -- end

   -- local month = 1
   -- local monthSeconds = secondsInMonth(month, year)
   -- while epochSeconds >= monthSeconds do
   --    epochSeconds = epochSeconds - monthSeconds
   --    month = month + 1
   --    monthSeconds = secondsInMonth(month, year)
   -- end

   local day = floor(epochSeconds / S_IN_D)
   epochSeconds = epochSeconds - day * S_IN_D
   day = max(1, day)

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

------------------------------------------------------------------------------------------------------------------------
-- Colors
------------------------------------------------------------------------------------------------------------------------

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

------------------------------------------------------------------------------------------------------------------------
-- Default settings
------------------------------------------------------------------------------------------------------------------------

local fontFace = 'TitilliumWeb-Bold'
local fontSizeSmall = 32
local fontSizeMedium = 40
local fontSizeBig = 64
local fontSizeTimer = 120
local fontSizeHuge = 160
local m_speed = consoleGetVariable('m_speed')
local r_fov = consoleGetVariable('r_fov')
local zoomFov = 40
local zoomSensMult = 1.0915740009242504 -- FIXME: 1 for release
local zoomSens = m_speed * zoomSensRatio(r_fov, zoomFov, 1440, 1080) * zoomSensMult
local cl_color_friend = ColorHEX(consoleGetVariable('cl_color_friend'))
local cl_color_enemy = ColorHEX(consoleGetVariable('cl_color_enemy'))

local function defaultShow(showStr)
   local showTable = {}
   for showVar in showStr:gmatch('%w+') do
      showTable[showVar] = true
   end
   return showTable
end

local defaultSettings = {
   ['CatoHUD'] = {
      userData = {
         offsetUTC = 2 * S_IN_H,
         armorColor = {Color(0, 255, 0), Color(255, 255, 0), Color(255, 0, 0)},
         megaColor = Color(60, 80, 255),
         carnageColor = Color(255, 0, 188),
         resistColor = Color(124, 32, 255),
         weaponColor = {
            Color(255, 255, 255), Color(0, 255, 255), Color(255, 150, 0),
            Color(99, 221, 74), Color(255, 0, 255), Color(250, 0, 0),
            Color(0, 128, 255), Color(255, 255, 0), Color(128, 0, 0),
         },
      },
      cvars = {
         {'box_debug', 'int', 0, 0},
         {'debug', 'int', 0},
         {'preview', 'int', 0, 0},
         {'reset_widgets', 'int', 0, 0},
         {'warmuptimer_reset', 'int', 0, 0},
         {'widget_cache', 'int', 0, 0},
         {'zoom', 'int', 0, 0},
      },
   },
   ['Cato_HealthNumber'] = {
      visible = true, props = {offset = '-40 30', anchor = '0 1', zIndex = '0', scale = '1'},
      userData = {
         anchorWidget = '',
         show = defaultShow('dead'),
         text = {font = fontFace, color = Color(191, 191, 191), size = fontSizeHuge, anchor = {x = 1}},
      },
   },
   ['Cato_ArmorNumber'] = {
      visible = true, props = {offset = '40 30', anchor = '0 1', zIndex = '0', scale = '1'},
      userData = {
         anchorWidget = '',
         show = defaultShow('dead'),
         text = {font = fontFace, color = Color(191, 191, 191), size = fontSizeHuge, anchor = {x = -1}},
      },
   },
   ['Cato_ArmorIcon'] = {
      visible = true, props = {offset = '0 -20', anchor = '0 1', zIndex = '0', scale = '1'},
      userData = {
         anchorWidget = '',
         show = defaultShow('dead'),
         icon = {color = Color(191, 191, 191), size = 24},
      },
   },
   ['Cato_FPS'] = {
      visible = true, props = {offset = '-3 -5', anchor = '1 -1', zIndex = '-999', scale = '1'},
      userData = {
         anchorWidget = '',
         show = defaultShow('dead editor freecam gameOver mainMenu menu race'),
         text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall},
      },
   },
   ['Cato_Time'] = {
      visible = true, props = {offset = '-3 18', anchor = '1 -1', zIndex = '-999', scale = '1'},
      userData = {
         anchorWidget = '',
         show = defaultShow('dead editor freecam gameOver mainMenu menu race'),
         text = {
            delimiter = {font = fontFace, color = Color(127, 127, 127), size = fontSizeSmall, anchor = {x = 0}},
            -- year = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall, anchor = {x = -1}},
            -- month = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall, anchor = {x = -1}},
            -- day = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall, anchor = {x = -1}},
            hour = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall, anchor = {x = 1}},
            minute = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall, anchor = {x = -1}},
            -- second = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall, anchor = {x = -1}},
         },
      },
   },
   ['Cato_Scores'] = {
      visible = true, props = {offset = '0 23', anchor = '1 -1', zIndex = '0', scale = '1'},
      userData = {
         anchorWidget = 'Cato_Time',
         show = defaultShow('dead freecam gameOver race'),
         text = {
            delimiter = {font = fontFace, color = Color(127, 127, 127), size = fontSizeSmall, anchor = {x = 0}},
            team = {font = fontFace, color = cl_color_friend, size = fontSizeSmall, anchor = {x = 1}},
            enemy = {font = fontFace, color = cl_color_enemy, size = fontSizeSmall, anchor = {x = -1}},
         },
      },
   },
   ['Cato_GameModeName'] = {
      visible = true, props = {offset = '0 23', anchor = '1 -1', zIndex = '0', scale = '1'},
      userData = {
         anchorWidget = 'Cato_Scores',
         show = defaultShow('dead freecam gameOver race'),
         text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall},
      },
   },
   ['Cato_RulesetName'] = {
      visible = true, props = {offset = '0 23', anchor = '1 -1', zIndex = '0', scale = '1'},
      userData = {
         anchorWidget = 'Cato_GameModeName',
         show = defaultShow('dead freecam gameOver race'),
         text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall},
      },
   },
   ['Cato_MapName'] = {
      visible = true, props = {offset = '0 23', anchor = '1 -1', zIndex = '0', scale = '1'},
      userData = {
         anchorWidget = 'Cato_RulesetName',
         show = defaultShow('dead freecam gameOver race'),
         text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall},
      },
   },
   ['Cato_Mutators'] = {
      visible = true, props = {offset = '0 33', anchor = '1 -1', zIndex = '0', scale = '1'},
      userData = {
         anchorWidget = 'Cato_MapName',
         show = defaultShow('dead freecam gameOver race'),
         icon = {size = 8},
      },
   },
   ['Cato_LowAmmo'] = {
      visible = true, props = {offset = '0 160', anchor = '0 0', zIndex = '0', scale = '1'},
      userData = {
         anchorWidget = '',
         show = defaultShow(', race'),
         preventEmptyAttack = true,
         text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall},
      },
   },
   ['Cato_Ping'] = {
      visible = true, props = {offset = '-3 4', anchor = '1 1', zIndex = '0', scale = '1'},
      userData = {
         anchorWidget = '',
         show = defaultShow('dead freecam gameOver race'),
         text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall},
      },
   },
   ['Cato_PacketLoss'] = {
      visible = true, props = {offset = '-3 -16', anchor = '1 1', zIndex = '0', scale = '1'},
      userData = {
         anchorWidget = '',
         show = defaultShow('dead freecam gameOver race'),
         text = {font = fontFace, color = Color(255, 0, 0), size = fontSizeSmall},
      },
   },
   ['Cato_GameTime'] = {
      visible = true, props = {offset = '0 -135', anchor = '0 1', zIndex = '0', scale = '1'},
      userData = {
         anchorWidget = '',
         show = defaultShow('dead'),
         countDown = false,
         hideSeconds = false,
         text = {
            delimiter = {font = fontFace, color = Color(127, 127, 127), size = fontSizeTimer, anchor = {x = 0}},
            minutes = {font = fontFace, color = Color(255, 255, 255), size = fontSizeTimer, anchor = {x = 1}},
            seconds = {font = fontFace, color = Color(255, 255, 255), size = fontSizeTimer, anchor = {x = -1}},
         },
      },
   },
   ['Cato_FollowingPlayer'] = {
      visible = true, props = {offset = '0 0', anchor = '0 -1', zIndex = '0', scale = '1'},
      userData = {
         anchorWidget = '',
         show = defaultShow('dead race'),
         text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeBig, anchor = {x = 0}},
      },
   },
   ['Cato_ReadyStatus'] = {
      visible = true, props = {offset = '0 145', anchor = '0 -1', zIndex = '0', scale = '1'},
      userData = {
         anchorWidget = '',
         show = defaultShow('dead freecam race'),
         text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall},
      },
   },
   ['Cato_FragMessage'] = {
      visible = false, props = {offset = '0 -250', anchor = '0 0', zIndex = '0', scale = '1'},
      userData = {
         anchorWidget = '',
         show = defaultShow('dead race'),
         text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeMedium},
      },
   },
   ['Cato_GameMessage'] = {
      visible = true, props = {offset = '0 -80', anchor = '0 0', zIndex = '0', scale = '1'},
      userData = {
         anchorWidget = '',
         show = defaultShow('dead freecam menu race'),
         text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeMedium},
      },
   },
   ['Cato_Speed'] = {
      visible = false, props = {offset = '0 60', anchor = '0 0', zIndex = '0', scale = '1'},
      userData = {
         anchorWidget = '',
         show = defaultShow('race'),
         text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall},
      },
   },
   ['Cato_Zoom'] = {
      userData = {fov = zoomFov, sensitivity = zoomSens, time = 0},
   },
}

local function resetProperties(widgetName)
   consolePerformCommand((defaultSettings[widgetName].visible and 'ui_show_widget ' or 'ui_hide_widget ') .. widgetName)

   for prop, val in pairs(defaultSettings[widgetName].props or {}) do
      consolePerformCommand('ui_set_widget_' .. prop .. ' ' .. widgetName .. ' ' .. val)
   end
end

local function widgetSetUserData(widgetName, widget, reset)
   if reset or not widget.userData then widget.userData = {} end

   for var, val in pairs(defaultSettings[widgetName].userData or {}) do
      if not widget.userData[var] or type(widget.userData[var]) ~= type(val) then
         widget.userData[var] = val
      end
   end

   saveUserData(widget.userData)
end

local function widgetSetCvars(widgetName, widget, reset)
   for _, cvar in ipairs(defaultSettings[widgetName].cvars or {}) do
      if not reset then
         widget:createConsoleVariable(cvar[1], cvar[2], cvar[3])
         if cvar[4] then
            widget:setConsoleVariable(cvar[1], cvar[4])
         end
      else
         consolePerformCommand('ui_' .. widgetName .. '_' .. cvar[1] .. ' ' .. (cvar[4] or cvar[3]))
      end
   end
end

------------------------------------------------------------------------------------------------------------------------
-- Widget cache
------------------------------------------------------------------------------------------------------------------------

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

------------------------------------------------------------------------------------------------------------------------
-- UI/NVG
------------------------------------------------------------------------------------------------------------------------

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

local function copyOpts(opts, intensity)
   return {
      font = opts.font,
      color = copyColor(opts.color, intensity),
      size = opts.size,
      anchor = opts.anchor and {x = opts.anchor.x, y = opts.anchor.y} or nil,
   }
end

local function setAnchorWidget(widget)
   widget.anchorWidget = _G[widget.userData.anchorWidget] or {x = 0, y = 0}
   widget.anchorOffset = getProps(widget.userData.anchorWidget).offset or {x = 0, y = 0}
   widget.x = widget.anchorWidget.x + widget.anchorOffset.x
   widget.y = widget.anchorWidget.y + widget.anchorOffset.y
end

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

local function createTextElem(widget, text, opts)
   -- FIXME: Is this a good idea?
   -- opts.size = opts.size * viewport.height / 1080
   -- Answer: NO. Scaling is fine but positioning gets fucked up. (Fixable by adjusting y?)

   local height = opts.size
   nvgFontBlur(0)
   nvgFontFace(opts.font)
   nvgFontSize(height)
   local width = nvgTextWidth(text)

   local draw = function(x, y)
      x = widget.x + x
      y = widget.y + y

      local anchorX = widget.anchor.x
      local anchorY = widget.anchor.y
      if opts.anchor then
         if opts.anchor.x then anchorX = opts.anchor.x end
         if opts.anchor.y then anchorY = opts.anchor.y end
      end
      nvgTextAlign(nvgHorizontalAlign(anchorX), nvgVerticalAlign(anchorY))

      nvgFillColor(Color(0, 0, 0, opts.color.a * 3))
      nvgFontBlur(2)
      nvgText(x, y, text)

      nvgFillColor(opts.color)
      nvgFontBlur(0)
      nvgText(x, y, text)

      widget.x_min = min(widget.x_min, x)
      widget.x_max = max(widget.x_max, x + width)
      widget.width = widget.x_max - widget.x_min

      widget.y_min = min(widget.y_min, y)
      widget.y_max = max(widget.y_max, y + height)
      widget.height = widget.y_max - widget.y_min

      if consoleGetVariable('ui_CatoHUD_box_debug') ~= 0 then
         -- local bounds = nvgTextBounds(text)
         -- -- consoleTablePrint(bounds)
         -- consolePrint('')
         -- nvgRect(bounds.minx, bounds.miny, bounds.maxx - bounds.minx, bounds.maxy - bounds.miny)
         local pos = getOffset({x = anchorX, y = anchorY}, width, height)
         nvgFillColor(Color(0, 255, 0, 63))
         nvgBeginPath()
         nvgRect(x + pos.x, y + pos.y, width, height)
         nvgFill()
      end
   end

   return {width = width, height = height, draw = draw}
end

local function createSvgElem(widget, image, opts)
   -- FIXME: Is this a good idea?
   -- opts.size = opts.size * viewport.height / 1080
   -- Answer: NO. Scaling is fine but positioning gets fucked up. (Fixable by adjusting y?)

   local width = 2 * opts.size
   local height = 2 * opts.size

   local draw = function(x, y)
      x = widget.x + x
      y = widget.y + y

      local nvgX = x - widget.anchor.x * opts.size
      local nvgY = y - widget.anchor.y * opts.size

      nvgFillColor(Color(0, 0, 0, opts.color.a))
      nvgSvg(image, nvgX, nvgY, opts.size + 1.25)
      -- nvgSvg(image, x - 1.5, y - 1.5, opts.size)
      -- nvgSvg(image, x + 1.5, y - 1.5, opts.size)
      -- nvgSvg(image, x + 1.5, y + 1.5, opts.size)
      -- nvgSvg(image, x - 1.5, y + 1.5, opts.size)

      nvgFillColor(opts.color)
      nvgSvg(image, nvgX, nvgY, opts.size)

      widget.x_min = min(widget.x_min, x)
      widget.x_max = max(widget.x_max, x + width)
      widget.width = widget.x_max - widget.x_min

      widget.y_min = min(widget.y_min, y)
      widget.y_max = max(widget.y_max, y + height)
      widget.height = widget.y_max - widget.y_min

      if consoleGetVariable('ui_CatoHUD_box_debug') ~= 0 then
         local pos = getOffset(widget.anchor, width, height)
         nvgFillColor(Color(0, 255, 0, 63))
         nvgBeginPath()
         nvgRect(x + pos.x, y + pos.y, width, height)
         nvgFill()
      end
   end

   return {width = width, height = height, draw = draw}
end

local function nvgTextUI(pos, text, opts)
   local widget = {
      anchor = {x = -1, y = -1}, x = 0, y = 0, x_min = 0, x_max = 0, width = 0, y_min = 0, y_max = 0, height = 0
   }
   local elem = createTextElem(widget, text, opts)
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
   nvgRect(pos.x, pos.y, opts.size, 2)
   nvgFill()
   pos.y = pos.y + 10 -- padding

   if consoleGetVariable('ui_CatoHUD_box_debug') ~= 0 then
      nvgFillColor(Color(0, 255, 0, 63))
      nvgBeginPath()
      nvgRect(pos.x, pos.y - 18, opts.size, 18)
      nvgFill()
   end
end

-- FIXME: Copied from reflexcore and modified. DIY..
editBox_flash = 0 -- hmm hidden globals
editBox_offsetX = 0
editBox_offsetX_id = 0
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
   editBox = function(pos, value, opts)
      local enabled = opts.enabled == nil and true or opts.enabled
      local giveFocus = (opts.giveFocus ~= nil) and opts.giveFocus or false

      local t
      if enabled then
         t = textRegion(pos.x, pos.y, opts.width, opts.height, value, opts.id or 0, giveFocus)
      else
         t = {text = value, focus = false, apply = false, hoverAmount = 0}
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
      -- local textUntilCursor = sub(t.text, 0, t.cursor)
      -- local textWidthAtCursor = nvgTextWidth(textUntilCursor)

      -- text positioning (this may be a frame behind at this point, but it used for input, one what
      -- is on the screen, so that's fine)
      local offsetX = 0
      if t.focus then -- only use editBox_offsetX if we have focus
         if editBox_offsetX_id == t.id then
            offsetX = editBox_offsetX
         else
            editBox_offsetX_id = t.id
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
      local textUntilCursor = sub(t.text, 0, t.cursor)
      local textWidthAtCursor = nvgTextWidth(textUntilCursor)

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
         editBox_offsetX = offsetX
         editBox_offsetX_id = t.id
      else
         -- no-longer holding it, reset
         if editBox_offsetX_id == t.id then
            editBox_offsetX_id = 0
         end
      end

      -- update these, offset may have changed!
      textX = pos.x + padX + offsetX

      -- scissor text & cursor etc
      nvgIntersectScissor(pos.x + padX / 2, pos.y, opts.width - padX, opts.height)

      -- cursor
      if t.focus then
         local cursorFlashPeriod = 0.25

         editBox_flash = editBox_flash + deltaTime

         -- if cursor moves, restart flash
         if t.cursorChanged then
            editBox_flash = 0
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
         if editBox_flash < cursorFlashPeriod then
            nvgBeginPath()
            nvgMoveTo(textX + textWidthAtCursor, textY - opts.height * 0.35)
            nvgLineTo(textX + textWidthAtCursor, textY + opts.height * 0.35)
            nvgStrokeColor(textColor)
            nvgStroke()
         else
            if editBox_flash > cursorFlashPeriod * 2 then
               editBox_flash = 0
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

------------------------------------------------------------------------------------------------------------------------
-- Game
------------------------------------------------------------------------------------------------------------------------

-- FIXME: The condition is not sufficient for determining the player's index.
--        Example: Two players with same name and same team will see each other frag messages
local function getPlayerByName(name, team)
   local fallbackPlayer
   for _, p in ipairs(players) do
      if p.name == name then
         if team == nil or p.team == team then
            return p
         end

         if fallbackPlayer == nil then
            fallbackPlayer = p
         end
      end
   end

   return fallbackPlayer
end

------------------------------------------------------------------------------------------------------------------------
-- CatoHUD
------------------------------------------------------------------------------------------------------------------------

local TEAM_ALPHA = 1
local TEAM_ZETA  = 2

local debugMode = nil
local previewMode = nil

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

   widget.x = 0
   widget.y = 0
   widget.x_min = widget.x
   widget.x_max = widget.x
   widget.width = 0
   widget.y_min = widget.y
   widget.y_max = widget.y
   widget.height = 0

   function widget:setConsoleVariable(varName, varValue)
      widgetSetConsoleVariable(varName, varValue)
   end

   function widget:createConsoleVariable(varName, varType, valueDefault)
      widgetCreateConsoleVariable(varName, varType, valueDefault)
   end

   function widget:initialize()
      resetProperties(widgetName)

      -- consoleTablePrint(widgetName .. '.userData', widget.userData)
      widgetSetUserData(widgetName, widget)
      -- consoleTablePrint(widgetName .. '.userData', widget.userData)

      widgetSetCvars(widgetName, widget)

      -- setAnchorWidget(widget)

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
         small = {size = 24, font = 'roboto-regular', color = Color(191, 191, 191, 255 * intensity)},
         medium = {size = 28, font = 'roboto-regular', color = Color(255, 255, 255, 255 * intensity)},
         widgetName = {size = 30, font = 'roboto-bold', color = Color(255, 255, 255, 255 * intensity)},
         warning = {size = 28, font = 'roboto-regular', color = Color(255, 0, 0, 255 * intensity)},
         delimiter = {size = WIDGET_PROPERTIES_COL_WIDTH + 20, color = Color(0, 0, 0, 63 * intensity)},
         checkBox = {
            width = 35, height = 35,
            bg = {base = Color(26, 26, 26, 255 * intensity), hover = Color(39, 39, 39, 255 * intensity)},
            fg = {
               base = Color(222, 222, 222, 255 * intensity), hover = Color(255, 255, 255, 255 * intensity),
               pressed = Color(200, 200, 200, 255 * intensity), disabled = Color(100, 100, 100, 255 * intensity),
            },
         },
         editBox = {
            width = 300, height = 35,
            bg = {base = Color(26, 26, 26, 255 * intensity), hover = Color(39, 39, 39, 255 * intensity)},
            fg = {
               base = Color(222, 222, 222, 255 * intensity), hover = Color(255, 255, 255, 255 * intensity),
               pressed = Color(200, 200, 200, 255 * intensity), disabled = Color(100, 100, 100, 255 * intensity),
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
      -- NOTE: If previewMode, disable Z-Index (show previous value?)

      -- widget.canPreview is nil defaults to true
      if widget.canPreview ~= false then
         optDelimiter(pos, opts.delimiter)
         previewMode = optRowInput(
            optInput.checkBox,
            pos,
            'Preview',
            previewMode,
            opts.medium,
            opts.checkBox
         )
         consolePerformCommand('ui_CatoHUD_preview ' .. (previewMode and 1 or 0))
      end

      -- widget.canAttach is nil defaults to true
      if widget.canAttach ~= false and widget.userData.anchorWidget then
         -- consolePrint(widgetName)
         -- consolePrint(widget.userData.anchorWidget)
         -- TODO: Make text red if invalid anchorWidget is set
         optDelimiter(pos, opts.delimiter)
         widget.userData.anchorWidget = optRowInput(
            optInput.editBox,
            pos,
            'Attach to',
            widget.userData.anchorWidget,
            opts.medium,
            opts.editBox
         )
         -- setAnchorWidget(widget)
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
      if previewMode or not widget.userData.show then
         -- FIXME: preview should temporarily change zindex to -999?
         return true
      end

      -- FIXME: Combine statements. Should be more efficient?
      if not widget.userData.show.mainMenu then
         if replayActive and replayName == 'menu' then
            return false
         end
      end

      if not widget.userData.show.menu then
         if loading.loadScreenVisible or isInMenu() then
            return false
         end
      end

      if not widget.userData.show.dead then
         if not povPlayer or povPlayer.health <= 0 then
            return false
         end
      end

      if not widget.userData.show.race then
         if gameMode == 'race' or gameMode == 'training' then
            return false
         end
      end

      if not widget.userData.show.hudOff then
         if consoleGetVariable('cl_show_hud') == 0 then
            return false
         end
      end

      if not widget.userData.show.gameOver then
         if gameState == GAME_STATE_GAMEOVER then
            return false
         end
      end

      if not widget.userData.show.freecam then
         if localPov and povPlayer and povPlayer.state ~= PLAYER_STATE_INGAME then
            return false
         end
      end

      if not widget.userData.show.editor then
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
      --    previewMode = false
      -- end

      widget.anchor = getProps(widgetName).anchor
      setAnchorWidget(widget)

      widget:drawWidget()
   end
end

------------------------------------------------------------------------------------------------------------------------

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
   previewMode = consoleGetVariable('ui_CatoHUD_preview') ~= 0

   povPlayer = players[playerIndexCameraAttachedTo]
   localPlayer = players[playerIndexLocalPlayer]
   localPov = playerIndexCameraAttachedTo == playerIndexLocalPlayer

   gameState = world.gameState
   gameMode = gamemodes[world.gameModeIndex].shortName
   hasTeams = gamemodes[world.gameModeIndex].hasTeams
   map = world.mapName
   mapTitle = world.mapTitle
   ruleset = world.ruleset
   gameTimeElapsed = world.gameTime
   gameTimeLimit = world.gameTimeLimit

   inReplay = replayActive and replayName ~= 'menu'

   if checkResetConsoleVariable('ui_CatoHUD_reset_widgets', 0) ~= 0 then
      for widgetName, _ in pairs(defaultSettings) do
         resetProperties(widgetName)
         widgetSetUserData(widgetName, _G[widgetName], true)
         widgetSetCvars(widgetName, _G[widgetName], true)
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
   --    Cato_GameMessage
   --    Cato_FragMessage
   --    Cato_Toasty
   -- FIXME: Is there a better way? Cato_FragMessage.fragEvents needs to be cleared after 2.5s
   Cato_FragMessage.fragEvents = {}
   for _, event in ipairs(log) do
      -- consoleTablePrint(event)
      if event.type == LOG_TYPE_DEATHMESSAGE then
         if not event.deathSuicide then
            -- Cato_FragMessage
            if event.age * 1000 < 2500 then
               -- FIXME: Again. getPlayerByName is not a sufficient condition.
               local killer = getPlayerByName(event.deathKiller, event.deathTeamIndexKiller)
               Cato_FragMessage.fragEvents[killer.index] = event
            end
         end
      end
   end

   -- Parse players for:
   --    Cato_BurstAccuracy
   --    Cato_Chat
   --    Cato_FakeBeam
   -- for _, p in ipairs(players) do
   --    consoleTablePrint(p)
   -- end
end

CatoHUD:registerWidget('CatoHUD', CatoHUD)

------------------------------------------------------------------------------------------------------------------------

Cato_HealthNumber = {}

function Cato_HealthNumber:drawWidget()
   if not povPlayer or povPlayer.state == PLAYER_STATE_SPECTATOR then return end

   local opts = copyOpts(self.userData.text)

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

   local health = createTextElem(self, playerHealth, opts)
   health.draw(0, 0)
end

CatoHUD:registerWidget('Cato_HealthNumber', Cato_HealthNumber)

------------------------------------------------------------------------------------------------------------------------

Cato_ArmorNumber = {}

function Cato_ArmorNumber:drawWidget()
   if not povPlayer or povPlayer.state == PLAYER_STATE_SPECTATOR then return end

   local opts = copyOpts(self.userData.text)

   local playerArmor = 'N/A'
   if not povPlayer.infoHidden then
      playerArmor = povPlayer.armor

      opts.color = CatoHUD.userData['armorColor'][povPlayer.armorProtection + 1]
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

   local armor = createTextElem(self, playerArmor, opts)
   armor.draw(0, 0)
end

CatoHUD:registerWidget('Cato_ArmorNumber', Cato_ArmorNumber)

------------------------------------------------------------------------------------------------------------------------

Cato_ArmorIcon = {}

function Cato_ArmorIcon:drawWidget()
   if not povPlayer or povPlayer.state == PLAYER_STATE_SPECTATOR then return end

   local opts = copyOpts(self.userData.icon)

   if not povPlayer.infoHidden then
      opts.color = CatoHUD.userData['armorColor'][povPlayer.armorProtection + 1]
   end

   local armor = createSvgElem(self, 'internal/ui/icons/armor', opts)
   armor.draw(0, 0)
end

CatoHUD:registerWidget('Cato_ArmorIcon', Cato_ArmorIcon)

------------------------------------------------------------------------------------------------------------------------

Cato_FPS = {}

function Cato_FPS:drawWidget()
   local fps = min(round(1 / deltaTime), consoleGetVariable('com_maxfps'))
   fps = createTextElem(self, fps .. 'fps', self.userData.text)
   fps.draw(0, 0)
end

CatoHUD:registerWidget('Cato_FPS', Cato_FPS)

------------------------------------------------------------------------------------------------------------------------

Cato_Time = {}

function Cato_Time:drawWidget()
   -- epochTime only
   -- if true then
   --    local time = formatEpochTime(epochTime, CatoHUD.userData.offsetUTC)
   --    local epochSeconds = epochTime + CatoHUD.userData.offsetUTC
   --    opts.second.anchor = self.anchor
   --    epochSeconds = createTextElem(self, epochSeconds, opts.second)
   --    epochSeconds.draw(0, 0)
   --    return
   -- end

   -- full datetime
   -- if true then
   --    local opts = {
   --       delimiter = copyOpts(self.userData.text.delimiter),
   --       year = copyOpts(self.userData.text.year),
   --       month = copyOpts(self.userData.text.month),
   --       day = copyOpts(self.userData.text.day),
   --       hour = copyOpts(self.userData.text.hour),
   --       minute = copyOpts(self.userData.text.minute),
   --       second = copyOpts(self.userData.text.second),
   --    }

   --    local time = formatEpochTime(epochTime, CatoHUD.userData.offsetUTC)

   --    local day = createTextElem(self, formatDay(time.day), opts.day)
   --    local delimiterDate1 = createTextElem(self, ' ', opts.delimiter)
   --    local month = createTextElem(self, formatMonth(time.month), opts.month)

   --    local delimiterDate2 = createTextElem(self, ' ', opts.delimiter)
   --    local year = createTextElem(self, time.year, opts.year)

   --    local delimiter = createTextElem(self, ' ', opts.delimiter)

   --    local hour = createTextElem(self, format('%02d', time.hour), opts.hour)
   --    local delimiterTime1 = createTextElem(self, ':', opts.delimiter)
   --    local minute = createTextElem(self, format('%02d', time.minute), opts.minute)

   --    local delimiterTime2 = createTextElem(self, ':', opts.delimiter)
   --    local second = createTextElem(self, format('%02d', time.second), opts.second)

   --    local x = 0
   --    if self.anchor.x == -1 then
   --       x = x + 0
   --    elseif self.anchor.x == 0 then
   --       x = x - self.width / 2
   --    elseif self.anchor.x == 1 then
   --       x = x - self.width
   --    end

   --    day.draw(x, 0)
   --    x = x + day.width
   --    delimiterDate1.draw(x, 0)
   --    x = x + delimiterDate1.width
   --    month.draw(x, 0)
   --    x = x + month.width

   --    delimiterDate2.draw(x, 0)
   --    x = x + delimiterDate2.width
   --    year.draw(x, 0)
   --    x = x + year.width

   --    delimiter.draw(x, 0)
   --    x = x + delimiter.width

   --    hour.draw(x, 0)
   --    x = x + hour.width
   --    delimiterTime1.draw(x, 0)
   --    x = x + delimiterTime1.width
   --    minute.draw(x, 0)
   --    x = x + minute.width

   --    delimiterTime2.draw(x, 0)
   --    x = x + delimiterTime2.width
   --    second.draw(x, 0)
   -- end


   local epochSeconds = epochTime + CatoHUD.userData.offsetUTC

   -- TODO: Figure out if time should be displayed during replay playback.
   --       It's a bit misleading since it displays current local time, and replays don't seem to
   --       contain information regarding the actual IRL time they were played during.
   -- if inReplay then
   --    consolePrint('---')
   --    consoleTablePrint(replay)
   --    consolePrint(epochSeconds)
   --    consolePrint(replay.timecodeCurrent)
   -- end

   local hour = createTextElem(self, format('%02d', floor(epochSeconds / S_IN_H) % H_IN_D), self.userData.text.hour)
   local delimiter = createTextElem(self, ':', self.userData.text.delimiter)
   local minute = createTextElem(self, format('%02d', floor(epochSeconds / S_IN_M) % M_IN_H), self.userData.text.minute)

   -- TODO: This alignment bs has to be figured out
   local x = 0
   local spacing = delimiter.width / 2
   if self.anchor.x == -1 then
      x = x + hour.width + spacing
   elseif self.anchor.x == 0 then
      x = x + 0
   elseif self.anchor.x == 1 then
      x = x - (minute.width + spacing)
   end

   hour.draw(x - spacing, 0)
   delimiter.draw(x, 0)
   minute.draw(x + spacing, 0)
end

CatoHUD:registerWidget('Cato_Time', Cato_Time)

------------------------------------------------------------------------------------------------------------------------

Cato_Scores = {}

function Cato_Scores:drawWidget()
   local opts = {
      team = copyOpts(self.userData.text.team),
      enemy = copyOpts(self.userData.text.enemy),
      delimiter = copyOpts(self.userData.text.delimiter),
   }

   local scoreTeam
   local indexTeam
   local scoreEnemy
   local indexEnemy
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
               -- this fixes edge case where runner-up score appears first in the players table
               scoreRunnerUp = scoreWinner
               indexRunnerUp = indexWinner
               --
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
         if indexWinner == playerIndexCameraAttachedTo then
            scoreTeam = scoreWinner
            indexTeam = indexWinner
            scoreEnemy = scoreRunnerUp
            indexEnemy = indexRunnerUp
         elseif indexRunnerUp == playerIndexCameraAttachedTo then
            scoreTeam = scoreRunnerUp
            indexTeam = indexRunnerUp
            scoreEnemy = scoreWinner
            indexEnemy = indexWinner
         else
            scoreTeam = povPlayer.score
            indexTeam = playerIndexCameraAttachedTo
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
      -- TODO: Implement
      return
   elseif gameMode == 'training' then
      -- TODO: Implement
      return
   else
      return
   end

   scoreTeam = createTextElem(self, scoreTeam or 'N/A', opts.team)
   local delimiter = createTextElem(self, '    ', opts.delimiter)
   scoreEnemy = createTextElem(self, scoreEnemy or 'N/A', opts.enemy)

   -- TODO: This alignment bs has to be figured out
   local x = 0
   local spacing = delimiter.width / 2
   if self.anchor.x == -1 then
      x = x + scoreTeam.width + spacing
   elseif self.anchor.x == 0 then
      x = x + 0
   elseif self.anchor.x == 1 then
      x = x - (scoreEnemy.width + spacing)
   end

   scoreTeam.draw(x - spacing, 0)
   delimiter.draw(x, 0)
   scoreEnemy.draw(x + spacing, 0)
end

CatoHUD:registerWidget('Cato_Scores', Cato_Scores)

------------------------------------------------------------------------------------------------------------------------

Cato_GameModeName = {}

function Cato_GameModeName:drawWidget()
   if not inReplay and gameState ~= GAME_STATE_WARMUP then return end

   local gameModeName = createTextElem(self, gameMode, self.userData.text)
   gameModeName.draw(0, 0)
end

CatoHUD:registerWidget('Cato_GameModeName', Cato_GameModeName)

------------------------------------------------------------------------------------------------------------------------

Cato_RulesetName = {}

function Cato_RulesetName:drawWidget()
   if not inReplay and gameState ~= GAME_STATE_WARMUP then return end

   local rulesetName = createTextElem(self, ruleset, self.userData.text)
   rulesetName.draw(0, 0)
end

CatoHUD:registerWidget('Cato_RulesetName', Cato_RulesetName)

------------------------------------------------------------------------------------------------------------------------

Cato_MapName = {}

function Cato_MapName:drawWidget()
   if not inReplay and gameState ~= GAME_STATE_WARMUP then return end

   local mapName = createTextElem(self, mapTitle, self.userData.text)
   mapName.draw(0, 0)
end

CatoHUD:registerWidget('Cato_MapName', Cato_MapName)

------------------------------------------------------------------------------------------------------------------------

Cato_Mutators = {}

function Cato_Mutators:drawWidget()
   if not inReplay and gameState ~= GAME_STATE_WARMUP then return end

   local x = -self.userData.icon.size * 2
   local spacing = self.userData.icon.size / 2

   local gameMutators = {}
   -- TODO: Should this be ipairs and then use "gameMutators[i]" over "table.insert"?
   for mutator in world.mutators:gmatch('%w+') do
      mutator = mutatorDefinitions[string.upper(mutator)]

      mutator = createSvgElem(self, mutator.icon, {color = mutator.col, size = self.userData.icon.size})
      x = x + mutator.width + spacing

      table.insert(gameMutators, mutator)
   end
   x = x - spacing -- spacing is only between the icons, adjust

   if self.anchor.x == -1 then
      x = 0
   elseif self.anchor.x == 0 then
      x = -x / 2
   elseif self.anchor.x == 1 then
      x = -x
   end

   for _, mutator in ipairs(gameMutators) do
      mutator.draw(x, 0)
      x = x + mutator.width + spacing
   end

   -- local opts = copyOpts(self.userData.text)

   -- local gameMutators = createTextElem(self, world.mutators, opts)
   -- gameMutators.draw(0, 0)
end

CatoHUD:registerWidget('Cato_Mutators', Cato_Mutators)

------------------------------------------------------------------------------------------------------------------------

Cato_LowAmmo = {}

-- local attackButton = 'mouse1'
-- local attackUnbound = false
-- local attackCommand = '+attack; cl_camera_next_player; ui_RocketLagNullifier_attack 1'

function Cato_LowAmmo:drawWidget()
   if previewMode then
      local ammoWarning = createTextElem(self, '(Low Ammo)', self.userData.text)
      ammoWarning.draw(0, 0)
      return
   end

   if not povPlayer or povPlayer.infoHidden then return end

   local weaponIndexSelected = povPlayer.weaponIndexSelected
   if weaponDefinitions[weaponIndexSelected] == nil then return end

   local ammoLow = weaponDefinitions[weaponIndexSelected].lowAmmoWarning
   local ammo = povPlayer.weapons[weaponIndexSelected].ammo
   if ammo > ammoLow then return end

   local opts = copyOpts(self.userData.text)

   if ammo <= 0 then
      opts.color = Color(95, 95, 95)
   else
      -- TODO: lerp color from white to yellow to red?
      --       visual indicator of halfway point is useful!
      -- TODO: optimize by precalculating midpoints between low ammo to no ammo
      -- just lerp from yellow to red for now
      opts.color = lerpColor(Color(255, 0, 0), Color(255, 255, 0), (ammo - 1) / ammoLow)
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
   -- local ammoWarning = createTextElem(self, lowAmmoText, opts)

   local ammoWarning = createTextElem(self, ammo, opts)
   ammoWarning.draw(0, 0)
end

CatoHUD:registerWidget('Cato_LowAmmo', Cato_LowAmmo)

------------------------------------------------------------------------------------------------------------------------

Cato_Ping = {}

function Cato_Ping:drawWidget()
   if not povPlayer or povPlayer.state == PLAYER_STATE_SPECTATOR then return end

   local opts = copyOpts(self.userData.text)

   if povPlayer.latency == 0 then
      return
   elseif povPlayer.latency <= 50 then
      opts.color = Color(0, 255, 0)
   elseif povPlayer.latency < 100 then
      opts.color = Color(255, 255, 0)
   else
      opts.color = Color(255, 0, 0)
   end

   local ping = createTextElem(self, povPlayer.latency .. 'ms', opts)
   ping.draw(0, 0)
end

CatoHUD:registerWidget('Cato_Ping', Cato_Ping)

------------------------------------------------------------------------------------------------------------------------

Cato_PacketLoss = {}

function Cato_PacketLoss:drawWidget()
   if not povPlayer or povPlayer.state == PLAYER_STATE_SPECTATOR then return end

   local opts = copyOpts(self.userData.text)

   if povPlayer.packetLoss == 0 then
      return
   elseif povPlayer.packetLoss <= 5 then
      opts.color = Color(255, 255, 255)
   elseif povPlayer.packetLoss < 10 then
      opts.color = Color(255, 255, 0)
   else
      opts.color = Color(255, 0, 0)
   end

   local packetloss = createTextElem(self, povPlayer.packetLoss .. ' PL', opts)
   packetloss.draw(0, 0)
end

CatoHUD:registerWidget('Cato_PacketLoss', Cato_PacketLoss)

------------------------------------------------------------------------------------------------------------------------

Cato_GameTime = {}

function Cato_GameTime:drawWidget()
   local hideSeconds = self.userData.hideSeconds

   local timeElapsed = 0
   if gameState == GAME_STATE_WARMUP then
      timeElapsed = warmupTimeElapsed
   elseif gameState == GAME_STATE_ACTIVE or gameState == GAME_STATE_ROUNDACTIVE then
      timeElapsed = gameTimeElapsed
      hideSeconds = (hideSeconds and gameTimeLimit - gameTimeElapsed > 30000)
   end

   local timer = formatTimeMs(timeElapsed, gameTimeLimit, self.userData.countDown)

   local minutes = createTextElem(self, timer.minutes, self.userData.text.minutes)
   local delimiter = createTextElem(self, ':', self.userData.text.delimiter)
   local seconds = hideSeconds and 'xx' or format('%02d', timer.seconds)
   seconds = createTextElem(self, seconds, self.userData.text.seconds)

   local x = 0
   local spacing = delimiter.width / 2
   if self.anchor.x == -1 then
      x = x + minutes.width + spacing
   elseif self.anchor.x == 0 then
      x = x + 0
   elseif self.anchor.x == 1 then
      x = x - (seconds.width + spacing)
   end

   minutes.draw(x - spacing, 0)
   delimiter.draw(x, 0)
   seconds.draw(x + spacing, 0)
end

CatoHUD:registerWidget('Cato_GameTime', Cato_GameTime)

------------------------------------------------------------------------------------------------------------------------

Cato_FollowingPlayer = {}

function Cato_FollowingPlayer:drawWidget()
   if not povPlayer then return end

   -- TODO: option for display on self
   if not previewMode and localPov then return end

   local label = createTextElem(self, 'FOLLOWING', self.userData.text)
   local name = createTextElem(self, povPlayer.name, self.userData.text)

   local x = 0
   if self.anchor.x == -1 then
      x = x + max(label.width, name.width) / 2
   elseif self.anchor.x == 0 then
      x = x + 0
   elseif self.anchor.x == 1 then
      x = x - (max(label.width, name.width) / 2)
   end

   local y = 0
   local offset = label.height / 3
   if self.anchor.y == -1 then
      y = y + 0
   elseif self.anchor.y == 0 then
      y = y - (label.height - offset) / 2
   elseif self.anchor.y == 1 then
      y = y - (name.height - offset)
   end

   label.draw(x, y)
   name.draw(x, y + label.height - offset)
end

CatoHUD:registerWidget('Cato_FollowingPlayer', Cato_FollowingPlayer)

------------------------------------------------------------------------------------------------------------------------

Cato_ReadyStatus = {}

function Cato_ReadyStatus:drawWidget()
   if gameState ~= GAME_STATE_WARMUP and not previewMode then return end

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

   local ready = createTextElem(self, playersReady .. '/' .. playersGame .. ' ready', self.userData.text)
   ready.draw(0, 0)
end

CatoHUD:registerWidget('Cato_ReadyStatus', Cato_ReadyStatus)

------------------------------------------------------------------------------------------------------------------------

Cato_FragMessage = {fragEvents = {}}

-- FIXME: Implement properly:
--        (1) log should only be used to get the event and duration calculation should be handled by
--            the widget code
--        (2) Figure out whether it's possible to decisively conclude who actually (was) fragged
function Cato_FragMessage:drawWidget()
   local fragMessage
   if self.fragEvents[playerIndexCameraAttachedTo] then
      fragMessage = 'You fragged ' .. self.fragEvents[playerIndexCameraAttachedTo].deathKilled
   elseif previewMode then
      fragMessage = '(Frag Message)'
   else
      return
   end

   -- TODO: Country flag
   fragMessage = createTextElem(self, fragMessage, self.userData.text)
   fragMessage.draw(0, 0)
end

CatoHUD:registerWidget('Cato_FragMessage', Cato_FragMessage)

------------------------------------------------------------------------------------------------------------------------

Cato_GameMessage = {}

function Cato_GameMessage:init()
   self.lastTickSeconds = -1
end

function Cato_GameMessage:drawWidget()
   local gameMessage = nil
   if world.timerActive then
      if gameState == GAME_STATE_WARMUP or gameState == GAME_STATE_ROUNDPREPARE then
         local timer = formatTimeMs(gameTimeElapsed, gameTimeLimit, true)
         if self.lastTickSeconds ~= timer.seconds then
            self.lastTickSeconds = timer.seconds
            playSound('internal/ui/match/match_countdown_tick')
         end
         gameMessage = timer.seconds
      elseif gameState == GAME_STATE_ACTIVE or gameState == GAME_STATE_ROUNDACTIVE then
         if gameTimeElapsed < 2500 then
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

   if previewMode then
      if gameMessage == nil then
         gameMessage = '(Game Message)'
      end
   elseif gameMessage == nil or isInMenu() then
      return
   end

   gameMessage = createTextElem(self, gameMessage, self.userData.text)
   gameMessage.draw(0, 0)
end

CatoHUD:registerWidget('Cato_GameMessage', Cato_GameMessage)

------------------------------------------------------------------------------------------------------------------------

Cato_Speed = {}

function Cato_Speed:drawWidget()
   if not povPlayer then return end

   local ups = createTextElem(self, ceil(povPlayer.speed) .. 'ups', self.userData.text)
   ups.draw(0, 0)
end

CatoHUD:registerWidget('Cato_Speed', Cato_Speed)

------------------------------------------------------------------------------------------------------------------------

Cato_Zoom = {canHide = false, canPosition = false, canPreview = false}

function Cato_Zoom:init()
   self.scoreboardFound = getProps('Scoreboard').visible ~= nil
end

function Cato_Zoom:drawWidget()
   -- TODO: Animation
   if consoleGetVariable('ui_CatoHUD_zoom') ~= 0 then
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
         consolePerformCommand('ui_CatoHUD_zoom 0')
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
      self.zoomPreScoreboard = self.scoreboardFound and getProps('Scoreboard').visible
   end
end

CatoHUD:registerWidget('Cato_Zoom', Cato_Zoom)

------------------------------------------------------------------------------------------------------------------------
