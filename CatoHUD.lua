-- math
--
local abs = math.abs
-- local atan = math.atan
-- FIXME: atan2 is WRONG! Learn2trig or compare output to math.atan2
-- local atan2 = function(y, x) return math.atan(y, x) end -- math.atan2 is deprecated
-- local atan2 = math.atan2  -- math.atan2 is deprecated
-- local bitand = bit.band
-- local bitor = bit.bor
local ceil = math.ceil
-- local deg2rad = math.rad -- function(x) return x * pi / 180 end
local floor = math.floor
-- local huge = math.huge
local log = math.log
local max = math.max
local min = math.min
-- local pi = math.pi
-- local pow = function(x, y) return x ^ y end -- math.pow is deprecated
-- local rad2deg = math.deg -- function(x) return x * 180 / pi end
-- local random = math.random; math.randomseed()
-- local sin = math.sin
-- local sqrt = math.sqrt
-- local tan = math.tan
-- local csc = function(x) return 1 / sin(x) end
--

-- bit
--
local bitmsb = function(x) return floor(log(x, 2)) end
-- local bitnot = bit and bit.bnot or function(x)
--    local z, len = 0, bitmsb(x)
--    for i = 1, len do
--       local b = 2^(i - 1)
--       local bSetX = x % (b + b) >= b
--       if not bSetX then z = z + b end
--    end
--    return z
-- end
-- local bitand = bit and bit.band or function(x, y)
--    local z, len = 0, max(bitmsb(x), bitmsb(y))
--    for i = 1, len do
--       local b = 2^(i - 1)
--       local bSetX, bSetY = x % (b + b) >= b, y % (b + b) >= b
--       if bSetX and bSetY then z = z + b end
--    end
--    return z
-- end
-- local bitor = bit and bit.bor or function(x, y)
--    local z, len = 0, max(bitmsb(x), bitmsb(y))
--    for i = 1, len do
--       local b = 2^(i - 1)
--       local bSetX, bSetY = x % (b + b) >= b, y % (b + b) >= b
--       if bSetX or bSetY then z = z + b end
--    end
--    return z
-- end
-- local bitxor = bit and bit.bxor or function(x, y)
--    local z, len = 0, max(bitmsb(x), bitmsb(y))
--    for i = 1, len do
--       local b = 2^(i - 1)
--       local bSetX, bSetY = x % (b + b) >= b, y % (b + b) >= b
--       if (bSetX and not bSetY) or (not bSetX and bSetY) then z = z + b end
--    end
--    return z
-- end
-- local bitlshift = bit and bit.lshift or function(x, y) return x * 2^y end
-- local bitrshift = bit and bit.rshift or function(x, y) return floor(x / 2^y) end
local bitnot, bitlshift, bitrshift = bit.bnot, bit.lshift, bit.rshift
local bitand, bitor, bitxor = bit.band, bit.bor, bit.bxor
local function binrep(x, len)
   if x == nil then return '' end
   len = max(bitmsb(x), len or 0)
   local rep = ''
   for i = 1, len do
      rep = rep .. (bitand(x, bitlshift(1, i - 1)) ~= 0 and '1' or '0')
   end
   return rep
end
-- FIXME: Debug
-- do
--    local n = 12
--    local x, y = random(0, bitlshift(1, n) - 1), random(0, bitlshift(1, n) - 1)
--    local z
--    consolePrint(string.format('x = %s = %d', binrep(x, n), x))
--    consolePrint(string.format('y = %s = %d', binrep(y, n), y))
--    consolePrint('')
--    local msbX = bitlshift(1, bitmsb(x))
--    local msbY = bitlshift(1, bitmsb(y))
--    consolePrint(string.format('msb(x) = %s = %d', binrep(msbX, n), msbX))
--    consolePrint(string.format('msb(y) = %s = %d', binrep(msbY, n), msbY))
--    consolePrint('')
--    consolePrint(string.format('~x = %s = %d', binrep(bitnot(x), n), bitnot(x)))
--    consolePrint(string.format('~y = %s = %d', binrep(bitnot(y), n), bitnot(y)))
--    consolePrint('')
--    z = bitand(x, y)
--    consolePrint(string.format('x & y = %s = %d', binrep(z, n), z))
--    consolePrint('')
--    z = bitor(x, y)
--    consolePrint(string.format('x | y = %s = %d', binrep(z, n), z))
--    consolePrint('')
--    z = bitxor(x, y)
--    consolePrint(string.format('x ^ y = %s = %d', binrep(z, n), z))
--    consolePrint('')
-- end
--

-- string
--
-- local format = string.format
local gmatch = string.gmatch -- NOTE: For performance prefer whatever gets the index
-- local gsub = string.gsub
-- local len = string.len
-- local rep = string.rep
-- local sub = string.sub
-- local upper = string.upper
-- -- better names
-- local gsubstr = string.gsub
-- local len = string.len
-- local strrep = string.rep
local strf = string.format -- NOTE: For performance prefer concatenation (..) over string.format
local strlen = string.len
local tolower = string.lower
local toupper = string.upper
local substr = string.sub
--


-- table
--
local concat = table.concat
local insert = table.insert
--

-- NOTE: We store the variables and functions the game sets as local upvalues for performance.
--       Re-fetching them will be necessary whenever they are reassigned by the game.

-- LuaVariables.txt
--[[--
local deltaTime = deltaTime
local deltaTimeRaw = deltaTimeRaw
local epochTime = epochTime
local extendedColors = extendedColors
local gamemodes = gamemodes
local loading = loading
local log = log
local playerIndexCameraAttachedTo = playerIndexCameraAttachedTo
local playerIndexLocalPlayer = playerIndexLocalPlayer
local players = players
local renderModes = renderModes
local replayActive = replayActive
local replayName = replayName
local teamColors = teamColors
local timeLimit = timeLimit
local viewport = viewport
local weaponDefinitions = weaponDefinitions
local widgets = widgets
local world = world
--]]

-- LuaFunctions.txt
--
local consoleGetVariable = consoleGetVariable
local consolePerformCommand = consolePerformCommand
-- local consolePrint = consolePrint
local isInMenu = isInMenu
-- local loadUserData = loadUserData
local mouseRegion = mouseRegion
local nvgBeginPath = nvgBeginPath
local nvgFill = nvgFill
local nvgFillColor = nvgFillColor
local nvgFontBlur = nvgFontBlur
local nvgFontFace = nvgFontFace
local nvgFontSize = nvgFontSize
local nvgIntersectScissor = nvgIntersectScissor
local nvgLineTo = nvgLineTo
local nvgMoveTo = nvgMoveTo
local nvgRect = nvgRect
local nvgRestore = nvgRestore
local nvgSave = nvgSave
local nvgStroke = nvgStroke
local nvgStrokeColor = nvgStrokeColor
local nvgSvg = nvgSvg
local nvgText = nvgText
local nvgTextAlign = nvgTextAlign
-- local nvgTextBounds = nvgTextBounds
local nvgTextWidth = nvgTextWidth
local playSound = playSound
-- local registerWidget = registerWidget
local saveUserData = saveUserData
-- local textRegion = textRegion
-- local textRegionSetCursor = textRegionSetCursor
-- local widgetCreateConsoleVariable = widgetCreateConsoleVariable
local widgetGetConsoleVariable = widgetGetConsoleVariable
local widgetSetConsoleVariable = widgetSetConsoleVariable
--

-- reflexcore.lua
require 'base/internal/ui/reflexcore'
--
local STATE_DISCONNECTED = STATE_DISCONNECTED
local STATE_CONNECTING = STATE_CONNECTING
local STATE_CONNECTED = STATE_CONNECTED
local GAME_STATE_ACTIVE = GAME_STATE_ACTIVE
local GAME_STATE_GAMEOVER = GAME_STATE_GAMEOVER
local GAME_STATE_ROUNDACTIVE = GAME_STATE_ROUNDACTIVE
local GAME_STATE_ROUNDCOOLDOWN_DRAW = GAME_STATE_ROUNDCOOLDOWN_DRAW
local GAME_STATE_ROUNDCOOLDOWN_SOMEONEWON = GAME_STATE_ROUNDCOOLDOWN_SOMEONEWON
local GAME_STATE_ROUNDPREPARE = GAME_STATE_ROUNDPREPARE
local GAME_STATE_WARMUP = GAME_STATE_WARMUP
-- local LOG_TYPE_DEATHMESSAGE = LOG_TYPE_DEATHMESSAGE
local PLAYER_STATE_EDITOR = PLAYER_STATE_EDITOR
local PLAYER_STATE_INGAME = PLAYER_STATE_INGAME
local PLAYER_STATE_SPECTATOR = PLAYER_STATE_SPECTATOR
local PLAYER_STATE_QUEUED = PLAYER_STATE_QUEUED
-- local WIDGET_PROPERTIES_COL_WIDTH = WIDGET_PROPERTIES_COL_WIDTH
--

-- gamestrings.lua
require 'base/internal/ui/gamestrings'
--
local mutatorDefinitions = mutatorDefinitions
--

-- ConsoleVarPrint.lua (For debugging. See <github link> <workshop link>)
require 'ConsoleVarPrint'
--
local _ConsoleVarPrint = ConsoleVarPrint
--

-- Doing this so we can more easily spot CatoHUD output
local prefixCato = '  | '
local consolePrint = consolePrint
local _consolePrint = consolePrint
consolePrint = function(str) _consolePrint(str ~= nil and prefixCato .. str or '') end

-- FIXME: Currently requiring this for debug messages, because the ConsoleVarPrint code might change a bit in the near
--        future. But once it gets settled/before release just copy the function here. Doesn't hurt to still see if
--        ConsoleVarPrint global is present (maybe, it might be an older version).
-- FIXME: Why are we doing this again? We're not gonna be printing all the time on each frame right. RIGHT?
-- FIXME: We need the arg names for now
local consoleVarPrint = function(varName, var, prefix, showTypes, depth)
   if type(_ConsoleVarPrint) ~= 'function' then
      if type(ConsoleVarPrint) ~= 'function' then
         local varType = showTypes and strf(', -- (%s)', type(var)) or ''
         consolePrint(strf('%s%s = %s', prefix or '', varName, tostring(var), varType))
         return
      else
         _ConsoleVarPrint = ConsoleVarPrint
      end
   end
   _ConsoleVarPrint(varName, var, prefix or prefixCato, showTypes, depth)
end

------------------------------------------------------------------------------------------------------------------------
-- Math
------------------------------------------------------------------------------------------------------------------------

local function clamp(x, minVal, maxVal)
   return max(min(x, maxVal), minVal)
end

local function round(x, precision)
   if precision == nil or precision < 0 then precision = 0 end
   return (x >= 0 and floor(x * (10 ^ precision) + 0.5) or ceil(x * (10 ^ precision) - 0.5)) / (10 ^ precision)
end

-- FIXME: Tf u mean "normal"_round? This is only used in armorColorLerp right? Is it "turbopixelstudios"_round?
local function normal_round(n)
   if n - floor(n) < 0.5 then
      return floor(n)
   end
   return ceil(n)
end

local function lerp(x, y, k)
   return (1 - k) * x + k * y
end

-- local function armorMax(armorProtection)
--    return floor(200 * (armorProtection + 2) * 0.25)
-- end
-- local function armorQuality(armorProtection)
--    return floor(100 * (armorProtection + 1) / (armorProtection + 2)) * 0.01
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
-- consoleVarPrint('armorMax', armorMax)
-- consoleVarPrint('armorQuality', armorQuality)
-- consoleVarPrint('armorLimit', armorLimit)
-- consolePrint('---')
-- -- Precalculate these constants to save time
-- local armorMax = {}
-- local armorQuality = {}
-- for i = 1, 3 do
--    armorMax[i] = floor(200 * (i + 1) * 0.25)
--    armorQuality[i] = floor(100 * i / (i + 1)) * 0.01
-- end
-- local armorLimit = {}
-- for i = 1, 3 do
--    armorLimit[i] = {}
--    for j = 1, 3 do
--       armorLimit[i][j] = floor(armorMax[j] * armorQuality[j] / armorQuality[i])
--    end
-- end
-- consoleVarPrint('armorMax', armorMax)
-- consoleVarPrint('armorQuality', armorQuality)
-- consoleVarPrint('armorLimit', armorLimit)
-- consolePrint('---')
-- NOTE: "Why not simply? What if they change in a future update?"
--       The previous calculations are constant as well anyways, since nothing is tied to ruleset.
-- local armorMax = {100, 150, 200}
local armorQuality = {0.5, 0.66, 0.75}
local armorLimit = {
   {100, 198, 300},
   { 75, 150, 227},
   { 66, 132, 200},
}
-- consoleVarPrint('armorMax', armorMax)
-- consoleVarPrint('armorQuality', armorQuality)
-- consoleVarPrint('armorLimit', armorLimit)
-- consolePrint('---')

local function stackAfterDamage(health, armor, armorProtection, damage)
   local damageScale = armorQuality[armorProtection + 1]
   -- consolePrint(strf('%d, %d - %f, %f (%f dmg)', health, armor, floor(damage * (1 - damageScale)), ceil(damage * damageScale), damage))
   health, armor = health - floor(damage * (1 - damageScale)), armor - ceil(damage * damageScale)
   -- consolePrint(strf('%d %d', health, armor))
   -- consolePrint(strf('%d %d', health + min(0, armor), max(0, armor)))
   -- consolePrint()
   return health + min(0, armor), max(0, armor)
end

local function damageToKill(health, armor, armorProtection)
   -- NOTE: Fails on e.g. 80 damage to 27 hp, 61 ya
   return min(armor, health * (armorProtection + 1)) + health
end

-- FIXME: The condition is not sufficient for determining the player's index.
--        Example: Two players with same name and same team will see each other frag messages
local function getPlayerByName(players, name, team)
   local fallbackPlayer = nil
   for _, p in ipairs(players) do
      if p.name == name then
         if team == nil or p.team == team then return p end
         fallbackPlayer = fallbackPlayer or p
      end
   end

   return fallbackPlayer
end

------------------------------------------------------------------------------------------------------------------------
-- Time
------------------------------------------------------------------------------------------------------------------------

local MS_IN_S, S_IN_M, M_IN_H, H_IN_D, D_IN_Y, D_IN_LY = 1000, 60, 60, 24, 365, 366
local S_IN_H = M_IN_H * S_IN_M; local S_IN_D = H_IN_D * S_IN_H
local S_IN_Y = D_IN_Y * S_IN_D; local S_IN_LY = D_IN_LY * S_IN_D
local MS_IN_M, MS_IN_H, MS_IN_D = MS_IN_S * S_IN_M, MS_IN_S * S_IN_H, MS_IN_S * S_IN_D
local MS_IN_Y, MS_IN_LY = MS_IN_S * S_IN_Y, MS_IN_S * S_IN_LY

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

local DAYEXT = {'th', 'st', 'nd', 'rd'}
local MONTHS = {
   'January', 'February', 'March', 'April', 'May', 'June',
   'July', 'August', 'September', 'October', 'November', 'December'
}
local function formatDay(day)
   local lastDigit = day % 10
   return day .. DAYEXT[(lastDigit >= 4 or (day >= 11 and day <= 13)) and 1 or lastDigit + 1]
end
local function formatMonth(month) return MONTHS[month] end

local function isLeapYear(year) return (year % 4 == 0 and year % 100 ~= 0) or (year % 400 == 0) end

local function secondsInYear(year) return isLeapYear(year) and S_IN_LY or S_IN_Y end
local function daysInMonth(month, year) return month == 2 and (isLeapYear(year) and 29 or 28) or 30 + month % 2 end
local function secondsInMonth(month, year) return S_IN_D * daysInMonth(month, year) end

-- FIXME: Changing yearTo - 1 to yearTo is more optimal?
local function yearsModSince(yearFrom, yearTo, modulo)
   return floor((yearTo - 1) / modulo) - floor((yearFrom - 1) / modulo)
end

-- TODO: Optimization: Set lastEpochTime = epochTime on load, format it, then update formatted value on each draw by:
--                        deltaEpochTime = epochTime - lastEpochTime
--                        lastEpochTime = epochTime
--                        time.seconds = time.seconds + deltaEpochTime
--                        if time.seconds > 60.0  then time.minutes = time.minutes + 1.0 end -- ...and so on
--                     Alternatively:
--                        lastEpochTime = epochTime + deltaTimeRaw
--                        time.seconds = time.seconds + deltaTimeRaw
--                        if time.seconds > 60.0  then time.minutes = time.minutes + 1.0 end -- ...and so on
--                     This avoids re-formatting every frame. Check whichever works better.
local function formatEpochTime(epochTimestamp)
   local epochSeconds = epochTimestamp

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
   -- consolePrint(strf('%s (%s)', dateTime, epochTimestamp + offsetUTC))

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

-- FIXME: Rename to newColor?
local function Color(r, g, b, a, intensity) return {r = r, g = g, b = b, a = (a or 255) * (intensity or 1)} end

local function ColorHEX(hex, intensity)
   return {
      r = tonumber('0x' .. substr(hex, 1, 2)),
      g = tonumber('0x' .. substr(hex, 3, 4)),
      b = tonumber('0x' .. substr(hex, 5, 6)),
      a = (tonumber('0x' .. substr(hex, 7, 8)) or 255) * (intensity or 1)
   }
end

-- FIXME: Rename to newColor?
local function copyColor(color, intensity) return Color(color.r, color.g, color.b, color.a, intensity) end

-- FIXME: We should probably not make a new table every time?
--        Consider setColorLerp, newColorLerp?
local function lerpColor(color1, color2, k, intensity)
   return {
      r = lerp(color1.r, color2.r, k),
      g = lerp(color1.g, color2.g, k),
      b = lerp(color1.b, color2.b, k),
      a = lerp(color1.a, color2.a, k) * (intensity or 1)
   }
end

local function consoleColorPrint(color) consolePrint(strf('(%s, %s, %s, %s)', color.r, color.g, color.b, color.a)) end

local function armorColorLerp(armor, armorProtection, opts)
   -- pretty good
   -- local lerpAmount = 1
   -- for itemArmorProtection = 0, 2 do
   --    if armor < armorLimit[armorProtection + 1][itemArmorProtection + 1] then
   --       lerpAmount = lerpAmount - 1
   --    end
   -- end
   -- lerpAmount = lerpAmount * 0.33


   -- faster but slightly off (inaccurate for low GA/high RA)
   -- local lerpAmount = armor - (3 * armorLimit[armorProtection + 1][1] - armorLimit[armorProtection + 1][2]) * 0.5

   -- local armorLowRange = armorLimit[armorProtection + 1][1]
   -- local armorMidRange = armorLimit[armorProtection + 1][2] - armorLimit[armorProtection + 1][1]
   -- local lerpAmount = armor - armorLowRange - armorMidRange * 0.5
   -- lerpAmount = lerpAmount / armorMidRange
   -- lerpAmount = lerpAmount + 1 - armorProtection
   -- lerpAmount = normal_round(lerpAmount)
   -- lerpAmount = lerpAmount * 0.33
   local a = armorLimit[armorProtection + 1][1]
   local b = armorLimit[armorProtection + 1][2] - a
   local lerpAmount = normal_round(((armor - a - b * 0.5) / b) + 1 - armorProtection) * 0.33

   -- consolePrint(lerpAmount)

   local colorToLerp = lerpAmount < 0 and Color(0, 0, 0) or Color(255, 255, 255)
   opts.color = lerpColor(opts.color, colorToLerp, abs(lerpAmount))
   -- return lerpColor(opts.color, colorToLerp, abs(lerpAmount))
end

------------------------------------------------------------------------------------------------------------------------
-- Widget cache
------------------------------------------------------------------------------------------------------------------------

local indexCache, indexCacheSize, indexCacheUpdates = {}, 0, 0

-- Note: Calling this before initialize will fail
local function updateIndexCache(widgets, widgetName)
   -- We count every call since the widgets table gets looped each time
   indexCacheUpdates = indexCacheUpdates + 1

   if not indexCache[widgetName] then indexCacheSize = indexCacheSize + 1 end

   for widgetIndex, widget in ipairs(widgets) do
      if widget.name == widgetName then indexCache[widgetName] = widgetIndex; break end
   end

   return indexCache[widgetName]
end

-- Note: Calling this before initialize will fail.
--       If the widget is not present, a widget cache update is triggered,
--       which loops the entire widgets table (not smart to do every frame).
-- FIXME: Move to CatoHUD:getProps?
local function getProps(widgets, widgetName)
   local widgetIndex = indexCache[widgetName]
   if not widgetIndex or not widgets[widgetIndex] or widgets[widgetIndex].name ~= widgetName then
      widgetIndex = updateIndexCache(widgets, widgetName)
   end

   return widgets[widgetIndex] or {}
end

local function debugIndexCache(widgets)
   local debugLines = {}
   insert(debugLines, 'indexCacheSize: ' .. indexCacheSize)
   insert(debugLines, 'indexCacheUpdates: ' .. indexCacheUpdates)
   insert(debugLines, 'indexCache:')
   for widgetName, widgetIndex in pairs(indexCache) do
      local mismatch = widgets[widgetIndex].name ~= widgetName and '*' or ''
      insert(debugLines, '  ' .. widgetName .. ': ' .. widgetIndex .. mismatch)
   end
   insert(debugLines, 'widgets:')
   for widgetIndex, widget in ipairs(widgets) do
      if indexCache[widget.name] then insert(debugLines, '  ' .. widgetIndex .. ': ' .. widget.name) end
   end
   return debugLines
end

------------------------------------------------------------------------------------------------------------------------
-- UI/NVG
------------------------------------------------------------------------------------------------------------------------

-- TODO: Various relative offsets (such as between lines in 'FOLLOWING\nplayer') depend on the
--       font, so maybe a function that calculates the proper offset for all the default fonts?
--       Also, check these:
--       nvgTextLetterSpacing(spacing)
--       -- nvgTextBounds() returns table { minx, miny, maxx, maxy }
--       nvgTextBounds(text)
--       nvgTextBoxBounds(breakRowWidth, text)
--       nvgTextLineHeight(height)
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
      label = opts.label,
      font = opts.font,
      color = copyColor(opts.color, intensity),
      size = opts.size,
      anchor = opts.anchor and {x = opts.anchor.x, y = opts.anchor.y} or nil,
   }
end

local function getOffset(anchor, width, height)
   return {x = -(anchor.x + 1) * width * 0.5, y = -(anchor.y + 1) * height * 0.5}
end

--    ANCHOR_LEFT = -1,    ANCHOR_CENTER = 0,    ANCHOR_RIGHT = 1
-- NVG_ALIGN_LEFT =  0, NVG_ALIGN_CENTER = 1, NVG_ALIGN_RIGHT = 2
local function hAlignToAnchor(x) return x + 1 end

--    ANCHOR_TOP = -1,    ANCHOR_MIDDLE = 0,    ANCHOR_BOTTOM = 1
-- NVG_ALIGN_TOP =  1, NVG_ALIGN_MIDDLE = 2, NVG_ALIGN_BOTTOM = 3 (NVG_ALIGN_BASELINE = 0)
local function vAlignToAnchor(y) return y + 2 end

local function textCatoHUD(widget, text, opts)
   -- FIXME: Is this a good idea?
   -- opts.size = opts.size * viewportHeight / 1080
   -- Answer: NO. Scaling is fine but positioning gets fucked up. (Fixable by adjusting y?)
   -- FIXME: Is this a better idea?
   -- opts.size = opts.size * viewportHeight / resolutionHeight
   -- Answer: Better? Yes. Good? Sorta. Scaling and positioning are fine. (Fixable by adjusting y?)
   -- opts.size = opts.size * viewportScale

   local color, font, height = opts.color, opts.font, opts.size
   nvgFontBlur(0); nvgFontFace(font); nvgFontSize(height)
   local shadow, width = Color(0, 0, 0, color.a * 3), nvgTextWidth(text)

   local anchor, widgetAnchor = opts.anchor or {}, widget.anchor
   local anchorX, anchorY = anchor.x or widgetAnchor.x, anchor.y or widgetAnchor.y

   local draw = function(x, y)
      x, y = widget.x + x, widget.y + y

      nvgFontBlur(0); nvgFontFace(font); nvgFontSize(height)
      nvgTextAlign(hAlignToAnchor(anchorX), vAlignToAnchor(anchorY))

      nvgFillColor(shadow); nvgFontBlur(2); nvgText(x, y, text)
      nvgFillColor(color); nvgFontBlur(0); nvgText(x, y, text)

      widget.xMin, widget.xMax = min(widget.xMin, x), max(widget.xMax, x + width)
      widget.yMin, widget.yMax = min(widget.yMin, y), max(widget.yMax, y + height)
      widget.width, widget.height = widget.xMax - widget.xMin, widget.yMax - widget.yMin

      if consoleGetVariable('ui_CatoHUD_box_debug') ~= 0 then
         local pos = getOffset({x = anchorX, y = anchorY}, width, height)
         nvgFillColor(Color(127, 255, 127, 63)); nvgBeginPath(); nvgRect(x + pos.x, y + pos.y, width, height); nvgFill()
         -- TODO: Draw widget's name, anchor point, min-/max-x/y
      end
   end

   return {width = width, height = height, draw = draw}
end

local function svgCatoHUD(widget, svg, opts)
   -- FIXME: Is this a good idea?
   -- opts.size = opts.size * viewportHeight / 1080
   -- Answer: NO. Scaling is fine but positioning gets fucked up. (Fixable by adjusting y?)
   -- FIXME: Is this a better idea?
   -- local width = 2 * opts.size * viewportWidth / resolutionWidth
   -- local height = 2 * opts.size * viewportHeight / resolutionHeight
   -- Answer: Better? Yes. Good? Sorta. Scaling and positioning are fine. (Fixable by adjusting y?)
   -- local width = 2 * opts.size * viewportScale
   -- local height = 2 * opts.size * viewportScale

   local color, size, widgetAnchor = opts.color, opts.size, widget.anchor
   local height, width, shadow = size + size, size + size, Color(0, 0, 0, color.a)

   local draw = function(x, y)
      x, y = widget.x + x, widget.y + y

      local nvgX, nvgY = x - widgetAnchor.x * size, y - widgetAnchor.y * size
      nvgFillColor(shadow); nvgSvg(svg, nvgX, nvgY, size + 1.25)
      -- nvgSvg(svg, x - 1.5, y - 1.5, size); nvgSvg(svg, x + 1.5, y - 1.5, size)
      -- nvgSvg(svg, x + 1.5, y + 1.5, size); nvgSvg(svg, x - 1.5, y + 1.5, size)
      nvgFillColor(color); nvgSvg(svg, nvgX, nvgY, size)

      widget.xMin, widget.xMax = min(widget.xMin, x), max(widget.xMax, x + width)
      widget.yMin, widget.yMax = min(widget.yMin, y), max(widget.yMax, y + height)
      widget.width, widget.height = widget.xMax - widget.xMin, widget.yMax - widget.yMin

      if consoleGetVariable('ui_CatoHUD_box_debug') ~= 0 then
         local pos = getOffset(widgetAnchor, width, height)
         nvgFillColor(Color(255, 255, 127, 63)); nvgBeginPath(); nvgRect(x + pos.x, y + pos.y, width, height); nvgFill()
      end
   end

   return {width = width, height = height, draw = draw}
end

local function uiTextCato(pos, text, opts)
   -- FIXME: WTF BRO (It's options bro... Relax...)
   local widget = {
      anchor = {x = -1, y = -1}, x = 0, y = 0, xMin = 0, xMax = 0, width = 0, yMin = 0, yMax = 0, height = 0
   }
   local elem = textCatoHUD(widget, text, opts)
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
   nvgFillColor(opts.color); nvgBeginPath(); nvgRect(pos.x, pos.y, opts.size, 2); nvgFill()
   pos.y = pos.y + 10 -- padding

   if consoleGetVariable('ui_CatoHUD_box_debug') ~= 0 then
      nvgFillColor(Color(0, 255, 0, 63)); nvgBeginPath(); nvgRect(pos.x, pos.y - 18, opts.size, 18); nvgFill()
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
      -- local textUntilCursor = substr(t.text, 0, t.cursor)
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
      local textY = pos.y + opts.height / 2

      -- handle clicking inside region to change cursor location / drag select multiple characters
      -- (note: this can update the cursor inside t)
      if (t.leftDown or t.leftHeld) and t.mouseInside then
         local textLength = strlen(t.text)
         local prevDistance = nil
         local newCursor = textLength
         for l = 0, textLength do
            local distance = abs(textX + nvgTextWidth(substr(t.text, 0, l)) - t.mousex)

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
      local textUntilCursor = substr(t.text, 0, t.cursor)
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
            local textUntilCursorStart = substr(t.text, 0, t.cursorStart)
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
         playSound('internal/ui/sounds/buttonClick')
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
   local diffHalf = (inputOpts.height - textOpts.size) * 0.5
   pos.y = pos.y + max(0, diffHalf)
   local label = uiTextCato(pos, text, textOpts)

   local padding = label.width + 8
   pos.x, pos.y = pos.x + padding, pos.y - label.height - diffHalf
   value = inputFunc(pos, value, inputOpts)
   pos.x, pos.y = pos.x - padding, pos.y + max(label.height, inputOpts.height)
   return value
end

local function optionsOpts(intensity)
   return {
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
end

local function optPreview(pos, opts)
   optDelimiter(pos, opts.delimiter)
   local previewMode = optRowInput(
      optInput.checkBox,
      pos,
      'Preview',
      consoleGetVariable('ui_CatoHUD_preview') ~= 0,
      opts.medium,
      opts.checkBox
   )
   consolePerformCommand('ui_CatoHUD_preview ' .. (previewMode and 1 or 0))
end

local function optDebug(pos, opts, widgets, widget)
   optDelimiter(pos, opts.delimiter)
   uiTextCato(pos, 'Debug', opts.medium)

   local anchor = getProps(widgets, widget.name).anchor
   uiTextCato(pos, 'anchor: ' .. anchor.x .. ' ' .. anchor.y, opts.small)
   uiTextCato(pos, 'getOptionsHeight(): ' .. widget:getOptionsHeight(), opts.small)
   for _, debugLine in ipairs(debugIndexCache(widgets)) do
      uiTextCato(pos, debugLine, opts.small)
   end
end

local function updateWidgetPosition(widgets, widget, anchorWidgetName)
-- local function updateWidgetPosition(widgets, widget)
   if widget.anchor == nil or widget.offset == nil then
      local props = getProps(widgets, widget.name)
      widget.anchor, widget.offset = props.anchor, props.offset
   end

   -- local anchorWidgetName = widget.userData and widget.userData.anchorWidget
   if anchorWidgetName and widget.anchorWidget == nil then
      widget.anchorWidget = _G[anchorWidgetName]
   end

   -- consoleVarPrint(strf('%s.anchorWidget', widget.name), anchorWidgetName)

   -- local anchorWidget = widget.anchorWidget or {name = 'nil', x = 0, y = 0, offset = {x = 0, y = 0}}
   -- local anchorWidgetOffset = anchorWidget.offset or {x = 0, y = 0}
   local anchorWidget = widget.anchorWidget
   if anchorWidget ~= nil then
      local anchorWidgetOffset = anchorWidget and anchorWidget.offset
      if anchorWidgetOffset ~= nil then
         widget.x, widget.y = anchorWidget.x + anchorWidgetOffset.x, anchorWidget.y + anchorWidgetOffset.y
      else -- anchor widget exists but its offset is not initialized
         widget.anchorWidget = nil
      end
   end
end

-- (:.*?:)|\^[0-9a-zA-Z]
-- :arenafp: :reflexpicardia::skull:^w' .. player.name .. ' :rocket::boom:^7:beatoff:
-- local function nvgEmojiText(props, pos, text, opts)
--
-- end

------------------------------------------------------------------------------------------------------------------------
-- CatoHUD
------------------------------------------------------------------------------------------------------------------------

local defaultSettings, CatoWidgets, luaWidgets, CatoState = {}, {}, nil, 0

CatoHUD = {canHide = false, canPosition = false}
defaultSettings['CatoHUD'] = {
   userData = {
      configBackup = nil,
      useLocalTime = true,
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
      {'backup_config', 'int', 1},
      {'box_debug', 'int', 0, 0},
      {'debug', 'int', 0},
      {'preview', 'int', 0, 0},
      {'reset_widgets', 'string', '', ''},
      {'warmuptimer_reset', 'int', 0, 0},
      {'widget_cache', 'int', 0, 0},
   },
}

local TEAM_ALPHA, TEAM_ZETA = 1, 2

local povPlayer, mapTitle, ruleset, mutators
local gameModeShortName, gameModeHasTeams, timerActive, gameTimeElapsed, gameTimeLimit, timeLimit --, timeLimitRound

local fullscreen, borderless, resolutionHeight, resolutionWidth, viewportWidth, viewportHeight, viewportScale
local colorFriendHEX, colorEnemyHEX, colorFriend, colorEnemy

local warmupTimeElapsed = 0

-- local function fakePlayerInfo()
--    return {
--       connected = random(0, 1) == 1,
--       state = PLAYER_STATE_INGAME,
--       ready = random(0, 1) == 1,

--       health = random(-99, 200),
--       armor = random(0, 200),
--       armorProtection = random(0, 2),
--       isDead = random(0, 1) == 1,

--       buttons = {attack = random(0, 1) == 1, jump = random(0, 1) == 1},
--       speed = random(0, 999),

--       latency = random(0, 999),
--       packetLoss = random(0, 100),
--       mmr = random(0, 9999),
--       mmrBest = random(0, 9999),
--       mmrNew = random(0, 9999),

--       name = 'Fake Player',
--       score = random(0, 50),

--       infoHidden = random(0, 1) == 1,
--       team = random(0, 1),

--       weaponIndexSelected = random(1, 9),
--       weaponIndexweaponChangingTo = random(1, 9),
--       weapons = {
--          [1] = {ammo = random(0, 999)},
--          [2] = {ammo = random(0, 999)},
--          [3] = {ammo = random(0, 999)},
--          [4] = {ammo = random(0, 999)},
--          [5] = {ammo = random(0, 999)},
--          [6] = {ammo = random(0, 999)},
--          [7] = {ammo = random(0, 999)},
--          [8] = {ammo = random(0, 999)},
--          [9] = {ammo = random(0, 999)},
--       },
--    }
-- end

-- TODO: Format this so that:
--       binrep(CatoState) = CCCGGGGGGGAAAABBBB...,
--                           ^  ^      ^   ^
--                           |  |      |   |-> players[playerIndexCameraAttachedTo].state
--                           |  |      |-> players[playerIndexLocalPlayer].state
--                           |  |-> world.gameState
--                           |-> clientGameState
--       ... or have separate variables: CatoClientGameState, CatoWorldGameState, CatoLocalPlayerState, CatoPlayerState
--       (Also gamemodes[world.gameModeIndex].shortName and gamemodes[world.gameModeIndex].hasTeams?)
local state = {}
state.localplayer = bitlshift(1, 0)
state.playercam   = bitlshift(1, 1)
state.gameactive  = bitlshift(1, 2)
state.warmup      = bitlshift(1, 3)
state.gameover    = bitlshift(1, 4)
state.dead        = bitlshift(1, 5)
state.race        = bitlshift(1, 6)
state.replay      = bitlshift(1, 7)
state.freecam     = bitlshift(1, 8)
state.spectator   = bitlshift(1, 9)
state.editor      = bitlshift(1, 10)
state.menu        = bitlshift(1, 11)
state.mainmenu    = bitlshift(1, 12)
state.hudoff      = bitlshift(1, 13)
state.preview     = bitlshift(1, 30)
local maxState = 0
for _, _ in pairs(state) do maxState = maxState + 1 end
consolePrint(maxState)

local function hideFlags(widget)
   if widget.userData == nil or widget.userData.hideWhen == nil then return 0 end
   local flags = 0
   for stateName in gmatch(widget.userData.hideWhen or '', '%S+') do
      local hideFlag = state[tolower(stateName)]
      if hideFlag == nil then
         consolePrint(strf('Unknown flag "%s" in %s.hideWhen', stateName, widget.name))
      else
         flags = bitor(flags, hideFlag)
      end
   end
   return flags
end

local function registerCatoWidget(widgetName)
   local widget = _G[widgetName]; widget.name = widgetName; registerWidget(widgetName)

   widget.x, widget.xMin, widget.xMax, widget.width = 0, 0, 0, 0
   widget.y, widget.yMin, widget.yMax, widget.height = 0, 0, 0, 0

   widget.initialize = function(self, reset)
      if reset then consolePrint('Reset: ' .. widgetName) end
      self.userData = reset and {} or loadUserData()

      -- properties
      if reset or self.userData == nil then
         local default = (defaultSettings[self.name] or {}).properties or {}
         consolePerformCommand(strf('ui_show_widget %s', self.name))
         consolePerformCommand(strf('ui_set_widget_offset %s %s', self.name, default.offset or '0 0'))
         consolePerformCommand(strf('ui_set_widget_anchor %s %s', self.name, default.anchor or '0 0'))
         consolePerformCommand(strf('ui_set_widget_zIndex %s %s', self.name, default.zIndex or '0 0'))
         consolePerformCommand(strf('ui_set_widget_scale %s %s',  self.name, default.scale  or '0 0'))
         consolePerformCommand(strf('ui_%s_widget %s', default.visible ~= false and 'show' or 'hide', self.name))
      end

      -- cvars
      for _, cvar in ipairs((defaultSettings[self.name] or {}).cvars or {}) do
         if reset ~= true then
            widgetCreateConsoleVariable(cvar[1], cvar[2], cvar[3])
            if cvar[4] then widgetSetConsoleVariable(cvar[1], cvar[4]) end
         else
            -- widgetSetConsoleVariable(cvar[1], cvar[4] or cvar[3]) -- FIXME: It not work when called from CatoHUD:draw
            consolePerformCommand(strf('ui_%s_%s %s', self.name, cvar[1], cvar[4] or cvar[3]))
         end
      end

      -- userData
      local function setWidgetUserData(container, varName, defaultVal) -- FIXME: Unrecurse?
         if type(container[varName]) ~= type(defaultVal) then
            container[varName] = defaultVal
         elseif type(defaultVal) == 'table' then
            for var, val in pairs(defaultVal) do setWidgetUserData(container[varName], var, val) end
         end
      end
      setWidgetUserData(self, 'userData', (defaultSettings[self.name] or {}).userData or {})

      -- hide states
      self.hideFlags = hideFlags(self)

      -- init
      if self.init then self:init(self.userData) end
   end

   -- draw
   if widget.name ~= 'CatoHUD' then
      insert(CatoWidgets, widget)
      -- widget.hidden = true
      widget.draw = function(self)
         local userData = self.userData
         -- if userData == nil then return end

         updateWidgetPosition(luaWidgets, self, userData.anchorWidget)

         -- consoleVarPrint(
         --    strf('CatoState', self.name),
         --    binrep(CatoState, maxState)
         -- )
         -- consoleVarPrint(
         --    strf('%s.hideFlags', self.name),
         --    binrep(self.hideFlags, maxState)
         -- )
         -- consoleVarPrint(
         --    strf('CatoState & %s.hideFlags', self.name),
         --    binrep(bitand(CatoState, self.hideFlags), maxState)
         -- )
         -- consolePrint()

         if bitand(CatoState, state.preview) == 0 and bitand(CatoState, self.hideFlags) ~= 0 then return end
         self:drawWidget(userData)

         -- if bitand(CatoState, state.preview) == 0 and bitand(CatoState, self.hideFlags) ~= 0 then
         --    self.hidden = true
         --    return
         -- end

         -- if self.hidden then
         --    -- setDraw(self, false, function() self:drawWidget(userData) end)
         --    self.hidden = false
         --    -- self.draw = function() self:drawWidget(userData) end
         -- end

         -- if self.hidden then return end
         -- self.hidden = self:drawWidget(userData) == false
      end
   end

   -- finalize
   widget.finalize = function(self)
      if self.final then self:final(self.userData) end
      if self.userData then saveUserData(self.userData) end
   end

   -- getOptionsHeight
   widget.optionsHeight = 0; widget.getOptionsHeight = function(self) return self.optionsHeight end

   -- drawOptions
   widget.drawOptions = function(self, x, y, intensity)
      local userData, pos, opts = self.userData, {x = x, y = y}, optionsOpts(intensity)

      -- title/widget
      uiTextCato(pos, self.name, opts.widgetName)

      -- preview
      optPreview(pos, opts)

      -- anchor
      if self.name ~= 'CatoHUD' then
         -- consolePrint(self.name)
         -- consolePrint(userData.anchorWidget)
         -- TODO: Make text red if invalid anchorWidget is set
         optDelimiter(pos, opts.delimiter)
         userData.anchorWidget = optRowInput(
            optInput.editBox,
            pos,
            'Attach to',
            userData.anchorWidget,
            opts.medium,
            opts.editBox
         )
      end

      -- options
      if self.drawOpts then
         optDelimiter(pos, opts.delimiter)
         uiTextCato(pos, self.name .. ' Options', opts.medium)
         self:drawOpts(pos)
      end

      -- debug
      optDebug(pos, opts, luaWidgets, self)

      -- set & save widget data
      saveUserData(userData)
      self.hideFlags = hideFlags(self)
      self.optionsHeight = pos.y - y
   end
end

------------------------------------------------------------------------------------------------------------------------

function CatoHUD:init(userData)
   consolePrint('')
   consolePrint('CatoHUD loaded')

   -- FIXME: 1.2.0+backcompat
   local useLocalEpochTime = userData.useLocalTime and epochTimeLocal ~= nil

   local offsetUTC = useLocalEpochTime and (epochTimeLocal - epochTime) or userData.offsetUTC
   local time = formatEpochTime(useLocalEpochTime and epochTimeLocal or (epochTime + offsetUTC))
   local offsetHours = offsetUTC / S_IN_H
   offsetHours = offsetHours ~= 0 and (offsetHours > 0 and '+' .. offsetHours or offsetHours) or ''
   consolePrint(strf('%d-%02d-%02d %02d:%02d:%02d %s',
      time.year, time.month, time.day, time.hour, time.minute, time.second,
      '(UTC' .. offsetHours .. ')' .. (useLocalEpochTime and ' [Local]' or ' [User]')
   ))

   -- local finalEpochTime = tonumber(userData.finalEpochTime)
   -- if finalEpochTime then
   --    local fTime = formatEpochTime(finalEpochTime, offsetUTC)
   --    consolePrint('')
   --    consolePrint('Previous Reflex session ended on')
   --    consolePrint(strf('%d-%02d-%02d %02d:%02d:%02d (UTC%s)',
   --       fTime.year,
   --       fTime.month,
   --       fTime.day,
   --       fTime.hour,
   --       fTime.minute,
   --       fTime.second,
   --       offsetHours ~= 0 and (offsetHours > 0 and '+' .. offsetHours or offsetHours) or ''
   --    ))
   -- end

   if widgetGetConsoleVariable('backup_config') ~= 0 then
      consolePrint('')
      local configBackup = widgetGetConsoleVariable('backup_config') < 0 and '_%02d%02d%02d' or ''
      configBackup = strf('configs/%s-%d%02d%02d' .. configBackup,
         'game', time.year, time.month, time.day, time.hour, time.minute, time.second
         -- consoleGetVariable('name'), time.year, time.month, time.day, time.hour, time.minute, time.second
      )

      if userData.configBackup ~= configBackup then
         userData.configBackup = configBackup
         -- saveUserData(userData) -- FIXME: Need? (Probably not.)
         consolePrint('Creating backup config \'' .. configBackup .. '.cfg\'')
         consolePerformCommand('saveconfig ' .. configBackup)
         playSound('CatoHUD/toasty')
      else
         consolePrint('Backup config \'' .. configBackup .. '.cfg\' already exists')
      end
   end

   consolePrint('')
end

function CatoHUD:draw()
   -- consolePrint(self.name .. ':draw called')

   luaWidgets = widgets

   local clientGameState = clientGameState
   local replayActive, replayName, deltaTime = replayActive, replayName, deltaTime

   local playerIndexCameraAttachedTo = playerIndexCameraAttachedTo
   povPlayer = players[playerIndexCameraAttachedTo]
   -- localPlayer = players[playerIndexLocalPlayer]
   local playerIsLocal = playerIndexCameraAttachedTo == playerIndexLocalPlayer

   local world = world; local gameState, gameMode = world.gameState, gamemodes[world.gameModeIndex]
   mapTitle = world.mapTitle
   ruleset = world.ruleset
   mutators = world.mutators
   gameTimeElapsed = world.gameTime
   gameTimeLimit = world.gameTimeLimit
   timeLimit = world.timeLimit
   -- timeLimitRound = world.timeLimitRound
   timerActive = world.timerActive -- FIXME: Put in CatoState
   gameModeShortName = gameMode.shortName
   gameModeHasTeams = gameMode.hasTeams -- FIXME: Put in CatoState

   fullscreen = consoleGetVariable('r_fullscreen') ~= 0
   -- FIXME: 1.2.0+backcompat
   borderless = (consoleGetVariable('r_windowed_fullscreen') or 0) ~= 0
   if fullscreen or borderless then
      local r_resolution_fullscreen = consoleGetVariable('r_resolution_fullscreen')
      resolutionWidth, resolutionHeight = r_resolution_fullscreen[1], r_resolution_fullscreen[2]
   else
      local r_resolution_windowed = consoleGetVariable('r_resolution_windowed')
      resolutionWidth, resolutionHeight = r_resolution_windowed[1], r_resolution_windowed[2]
   end
   local viewport = viewport; viewportWidth, viewportHeight = viewport.width, viewport.height

   local newViewportScale = 1
   if 640 <= resolutionHeight and resolutionHeight <= 2160 then newViewportScale = viewportHeight / resolutionHeight end
   if viewportScale ~= newViewportScale then
      viewportScale = newViewportScale
      consolePrint(strf('viewportScale = %f / %d = %f (viewportHeight / resolutionHeight)',
         viewportHeight,
         resolutionHeight,
         viewportScale
      ))
   end

   -- FIXME: Track changes to cvars and change only when it changes. We only do this once for now.
   local newColorFriend, newColorEnemy = consoleGetVariable('cl_color_friend'), consoleGetVariable('cl_color_enemy')
   if colorFriendHEX ~= newColorFriend then colorFriendHEX = newColorFriend; colorFriend = ColorHEX(colorFriendHEX) end
   if colorEnemyHEX ~= newColorEnemy then colorEnemyHEX = newColorEnemy; colorEnemy = ColorHEX(colorEnemyHEX) end

   local resetWidgets = widgetGetConsoleVariable('reset_widgets')
   if resetWidgets ~= '' then
      widgetSetConsoleVariable('reset_widgets', '')
      -- consolePrint(strf('reset_widgets %s', resetWidgets))
      if tonumber(resetWidgets) == nil then
         for widgetName in gmatch(resetWidgets, '%S+') do
            -- consolePrint(strf('reset_widgets %s', widgetName))
            local widget = _G[widgetName]
            if tolower(substr(widgetName, 1, 4)) == 'cato'
               and type(widget) == 'table'
               and type(widget.initialize) == 'function' then
               widget:initialize(true)
            end
         end
         playSound('CatoHUD/toasty')
      elseif tonumber(resetWidgets) ~= 0 then
         local widgetNames = {'CatoHUD'}
         for _, widget in ipairs(CatoWidgets) do insert(widgetNames, widget.name) end
         widgetSetConsoleVariable('reset_widgets', concat(widgetNames, ' '))
      end
   end

   -- Parse events for: Cato_Chat Cato_GameEvents Cato_GameMessage Cato_FragMessage Cato_Toasty
   -- for i, event in ipairs(log) do
   --    consoleVarPrint('log[' .. i .. ']', event)
   -- end

   -- FIXME: Most genius of optimization ideas ever?
   --        Maybe nah bro cos u still gotta do the bitwise checks albeit there might be less table lookups overall?
   -- local connectedPlayers = 0
   -- local inGamePlayers = 0
   -- local teamAlphaPlayers = 0
   -- local teamZetaPlayers = 0
   -- for i, p in ipairs(players) do
   --    if p.connected then connectedPlayers = connectedPlayers + (i - 1) ^ 2 end
   --    if p.state == PLAYER_STATE_INGAME then inGamePlayers = inGamePlayers + (i - 1) ^ 2 end
   --    if p.team == TEAM_ALPHA then teamAlphaPlayers = teamAlphaPlayers + (i - 1) ^ 2 end
   --    if p.team == TEAM_ZETA then teamZetaPlayers = teamZetaPlayers + (i - 1) ^ 2 end
   -- end
   -- Now we can check if playerIndex & connectedPlayers then do smth.
   -- We could also make a mapping for playerName.playerTeam -> playerIndex to use over getPlayerByName.
   -- In fact we could just create getPlayerByName as a function here if that's faster than via a table mapping.

   -- Parse players for: Cato_BurstAccuracy, Cato_Chat, Cato_FakeBeam, Cato_RespawnDelay
   -- for i, p in ipairs(players) do
   --    consoleVarPrint('players[' .. i .. ']', p)
   -- end

   local clientGameStateDisconnected, clientGameStateConnecting, clientGameStateConnected
   if clientGameState == STATE_DISCONNECTED then
      clientGameStateDisconnected, clientGameStateConnecting, clientGameStateConnected = true, false, false
   elseif clientGameState == STATE_CONNECTING then
      clientGameStateDisconnected, clientGameStateConnecting, clientGameStateConnected = false, true, false
   elseif clientGameState == STATE_CONNECTED then
      clientGameStateDisconnected, clientGameStateConnecting, clientGameStateConnected = false, false, true
   end

   local gameStateWarmup, gameStateActive, gameStateRoundPrepare, gameStateRoundActive
   local gameStateRoundCooldownSomeoneWon, gameStateRoundCooldownDraw, gameStateGameOver
   if gameState == GAME_STATE_WARMUP then
      gameStateWarmup, gameStateActive, gameStateRoundPrepare, gameStateRoundActive = true, false ,false, false
      gameStateRoundCooldownSomeoneWon, gameStateRoundCooldownDraw, gameStateGameOver = false, false, false
   elseif gameState == GAME_STATE_ACTIVE then
      gameStateWarmup, gameStateActive, gameStateRoundPrepare, gameStateRoundActive = false, true ,false, false
      gameStateRoundCooldownSomeoneWon, gameStateRoundCooldownDraw, gameStateGameOver = false, false, false
   elseif gameState == GAME_STATE_ROUNDPREPARE then
      gameStateWarmup, gameStateActive, gameStateRoundPrepare, gameStateRoundActive = false, false ,true, false
      gameStateRoundCooldownSomeoneWon, gameStateRoundCooldownDraw, gameStateGameOver = false, false, false
   elseif gameState == GAME_STATE_ROUNDACTIVE then
      gameStateWarmup, gameStateActive, gameStateRoundPrepare, gameStateRoundActive = false, false ,false, true
      gameStateRoundCooldownSomeoneWon, gameStateRoundCooldownDraw, gameStateGameOver = false, false, false
   elseif gameState == GAME_STATE_ROUNDCOOLDOWN_SOMEONEWON then
      gameStateWarmup, gameStateActive, gameStateRoundPrepare, gameStateRoundActive = false, false ,false, false
      gameStateRoundCooldownSomeoneWon, gameStateRoundCooldownDraw, gameStateGameOver = true, false, false
   elseif gameState == GAME_STATE_ROUNDCOOLDOWN_DRAW then
      gameStateWarmup, gameStateActive, gameStateRoundPrepare, gameStateRoundActive = false, false ,false, false
      gameStateRoundCooldownSomeoneWon, gameStateRoundCooldownDraw, gameStateGameOver = false, true, false
   elseif gameState == GAME_STATE_GAMEOVER then
      gameStateWarmup, gameStateActive, gameStateRoundPrepare, gameStateRoundActive = false, false ,false, false
      gameStateRoundCooldownSomeoneWon, gameStateRoundCooldownDraw, gameStateGameOver = false, false, true
   end

   local playerState, playerIsDead
   local playerStateInGame, playerStateSpectator, playerStateEditor, playerStateQueued
   if povPlayer ~= nil then
      playerState, playerIsDead = povPlayer.state, povPlayer.isDead
      if playerState == PLAYER_STATE_INGAME then
         playerStateInGame, playerStateSpectator, playerStateEditor, playerStateQueued = true, false, false, false
      elseif playerState == PLAYER_STATE_SPECTATOR then
         playerStateInGame, playerStateSpectator, playerStateEditor, playerStateQueued = false, true, false, false
      elseif playerState == PLAYER_STATE_EDITOR then
         playerStateInGame, playerStateSpectator, playerStateEditor, playerStateQueued = false, false, true, false
      elseif playerState == PLAYER_STATE_QUEUED then
         playerStateInGame, playerStateSpectator, playerStateEditor, playerStateQueued = false, false, false, true
      end
   else
      playerState, playerIsDead = false, false
      playerStateInGame, playerStateSpectator, playerStateEditor, playerStateQueued = false, false, false, false
   end

   CatoState = 0
   if playerIsLocal then CatoState = bitor(CatoState, state.localplayer) end
   if povPlayer ~= nil then CatoState = bitor(CatoState, state.playercam) end
   if not gameStateWarmup and not gameStateGameOver then CatoState = bitor(CatoState, state.gameactive) end
   if gameStateWarmup then CatoState = bitor(CatoState, state.warmup) end
   if gameStateGameOver then CatoState = bitor(CatoState, state.gameover) end
   if playerIsDead then CatoState = bitor(CatoState, state.dead) end
   if gameModeShortName == 'race' or gameModeShortName == 'training' then CatoState = bitor(CatoState, state.race) end
   if replayActive and replayName ~= 'menu' then CatoState = bitor(CatoState, state.replay) end
   if playerIsLocal and not playerStateInGame then CatoState = bitor(CatoState, state.freecam) end
   if playerStateSpectator then CatoState = bitor(CatoState, state.spectator) end
   if playerStateEditor then CatoState = bitor(CatoState, state.editor) end
   if loading.loadScreenVisible or isInMenu() then CatoState = bitor(CatoState, state.menu) end
   if replayActive and replayName == 'menu' then CatoState = bitor(CatoState, state.mainmenu) end
   if consoleGetVariable('cl_show_hud') == 0 then CatoState = bitor(CatoState, state.hudoff) end
   if widgetGetConsoleVariable('preview') ~= 0 then CatoState = bitor(CatoState, state.preview) end

   -- for _, widget in ipairs(CatoWidgets) do
   --    local userData = widget.userData
   --    if userData == nil then goto drawNext end

   --    updateWidgetPosition(luaWidgets, widget)

   --    -- consoleVarPrint(strf('CatoState', widget.name), binrep(CatoState, maxState))
   --    -- consoleVarPrint(strf('%s.hideFlags', widget.name), binrep(widget.hideFlags, maxState))
   --    -- consoleVarPrint(strf('CatoState & %s.hideFlags', widget.name), binrep(bitand(CatoState, widget.hideFlags), maxState))
   --    -- consolePrint()
   --    if bitand(CatoState, state.preview) == 0 and bitand(CatoState, widget.hideFlags) ~= 0 then
   --       if not widget.hidden then
   --          -- setDraw(widget, true, function() end)
   --          widget.hidden = true
   --          -- widget.draw = function() end
   --       end
   --       goto drawNext
   --    end

   --    if widget.hidden then
   --       -- setDraw(widget, false, function() widget:drawWidget(userData) end)
   --       widget.hidden = false
   --       -- widget.draw = function() widget:drawWidget(userData) end
   --    end

   --    ::drawNext::
   -- end

   if widgetGetConsoleVariable('widget_cache') ~= 0 then
      widgetSetConsoleVariable('widget_cache', 0)
      for _, debugLine in ipairs(debugIndexCache(luaWidgets)) do consolePrint(debugLine) end
   end

   if widgetGetConsoleVariable('warmuptimer_reset') ~= 0 then
      widgetSetConsoleVariable('warmuptimer_reset', 0)
      warmupTimeElapsed = 0
   end

   if clientGameStateConnected and gameStateWarmup then
      warmupTimeElapsed = warmupTimeElapsed + deltaTime * MS_IN_S
   elseif warmupTimeElapsed ~= 0 then
      warmupTimeElapsed = 0
   end
end

-- function CatoHUD:final(userData)
--    userData.finalEpochTime = epochTime
-- end

registerCatoWidget('CatoHUD')

------------------------------------------------------------------------------------------------------------------------

Cato_HealthNumber = {}
defaultSettings['Cato_HealthNumber'] = {
   properties = {visible = true, offset = '-40 30', anchor = '0 1', zIndex = '0', scale = '1'},
   userData = {
      anchorWidget = '',
      hideWhen = 'mainMenu menu hudOff gameOver freecam editor',
      text = {
         unknown = {font = 'TitilliumWeb-Bold', color = Color(191, 191, 191), size = 160, anchor = {x = 1}},
         diesFromBolt = {font = 'TitilliumWeb-Bold', color = Color(255, 0, 0), size = 160, anchor = {x = 1}},
         diesFromMelee = {font = 'TitilliumWeb-Bold', color = Color(255, 127, 0), size = 160, anchor = {x = 1}},
         diesFromRocket = {font = 'TitilliumWeb-Bold', color = Color(255, 255, 0), size = 160, anchor = {x = 1}},
         safe = {font = 'TitilliumWeb-Bold', color = Color(255, 255, 255), size = 160, anchor = {x = 1}},
      },
   },
}

function Cato_HealthNumber:drawWidget(userData)
   if bitand(CatoState, state.playercam) == 0 then return end
   if bitand(CatoState, state.spectator) ~= 0 then return end -- FIXME: Technically not correct state check

   local health, armor, protection
   local opts
   if not povPlayer.infoHidden then
      health, armor, protection = povPlayer.health, povPlayer.armor, povPlayer.armorProtection

      -- TODO: Colors for single burst/plasma shot death, maybe some self-damage related?
      if stackAfterDamage(health, armor, protection, 80) <= 0 then
         opts = userData.text.diesFromBolt
      elseif stackAfterDamage(health, armor, protection, 90) <= 0 then
         opts = userData.text.diesFromMelee
      elseif stackAfterDamage(health, armor, protection, 100) <= 0 then
         opts = userData.text.diesFromRocket
      else
         opts = userData.text.safe
      end
      -- local h, a = stackAfterDamage(health, armor, protection, 80)
      -- local damage = damageToKill(health, armor, protection)
      -- if damage <= 80 then
      --    opts = userData.text.diesFromBolt
      -- elseif damage <= 90 then -- FIXME: Not always accurate?
      --    opts = userData.text.diesFromMelee
      -- elseif damage <= 100 then
      --    opts = userData.text.diesFromRocket
      -- else
      --    opts = userData.text.safe
      -- end
   else
      health = 'N/A'
      opts = userData.text.unknown
   end

   textCatoHUD(self, health, opts).draw(0, 0)
end

registerCatoWidget('Cato_HealthNumber')

------------------------------------------------------------------------------------------------------------------------

Cato_ArmorNumber = {}
defaultSettings['Cato_ArmorNumber'] = {
   properties = {visible = true, offset = '40 30', anchor = '0 1', zIndex = '0', scale = '1'},
   userData = {
      anchorWidget = '',
      hideWhen = 'mainMenu menu hudOff gameOver freecam editor',
      text = {
         [1] = {font = 'TitilliumWeb-Bold', color = Color(0, 255, 0), size = 160, anchor = {x = -1}},
         [2] = {font = 'TitilliumWeb-Bold', color = Color(255, 255, 0), size = 160, anchor = {x = -1}},
         [3] = {font = 'TitilliumWeb-Bold', color = Color(255, 0, 0), size = 160, anchor = {x = -1}},
         unknown = {font = 'TitilliumWeb-Bold', color = Color(191, 191, 191), size = 160, anchor = {x = -1}}
      },
   },
}

function Cato_ArmorNumber:drawWidget(userData)
   if bitand(CatoState, state.playercam) == 0 then return end
   if bitand(CatoState, state.spectator) ~= 0 then return end -- FIXME: Technically not correct state check

   local armor, protection
   local opts
   if not povPlayer.infoHidden then
      armor, protection = povPlayer.armor, povPlayer.armorProtection
      opts = copyOpts(userData.text[protection + 1]) -- FIXME: copyOpts
      armorColorLerp(armor, protection, opts)

      -- opts.color = CatoHUD.userData['armorColor'][povPlayer.armorProtection + 1]
      -- opts.color = armorColorLerp(armor, povPlayer.armorProtection, opts.color)

      -- local lerpSteps = floor(armor / armorLimit[povPlayer.armorProtection + 1][0])

      -- local lerpSteps = -1
      -- for itemArmorProtection = 0, 2 do
      --    if armor < armorLimit[povPlayer.armorProtection + 1][itemArmorProtection + 1] then
      --       lerpSteps = lerpSteps + 1
      --    end
      -- end

      -- local colorToLerp = lerpSteps < 0 and Color(255, 255, 255) or Color(0, 0, 0)
      -- opts.color = lerpColor(opts.color, colorToLerp, abs(lerpSteps) * 0.33)

      -- consoleColorPrint(opts.color)
      -- consoleColorPrint(colorToLerp)

      -- debug
      -- armor = povPlayer.armor .. ' ' .. armorQuality(povPlayer) * povPlayer.armor

      -- local armorLimit = armor * armorQuality[povPlayer.armorProtection]
      -- armorLimit = ceil(armorLimit)
      -- if armorLimit < armorQuality[0] * armorMax[0] then
      --    opts.color = lerpColor(opts.color, Color(0, 0, 0), 2 / 3)
      -- elseif armorLimit < armorQuality[1] * armorMax[1] then
      --    opts.color = lerpColor(opts.color, Color(0, 0, 0), 1 / 3)
      -- elseif armorLimit < armorQuality[2] * armorMax[2] then
      --    opts.color = lerpColor(opts.color, Color(0, 0, 0), 0)
      -- end

      -- FIXME: Better way?
      -- opts.color = CatoHUD.userData['armorColor' .. povPlayer.armorProtection]
      -- if povPlayer.armorProtection == 2 then
      --     -- RA <  66 -> can pickup GA
      --    if armor < 66 then
      --       opts.color = lerpColor(opts.color, Color(0, 0, 0), 0.66)
      --     -- RA < 132 -> can pickup YA
      --    elseif armor < 132 then
      --       opts.color = lerpColor(opts.color, Color(0, 0, 0), 0.33)
      --     -- RA < 200 -> can pickup RA
      --    elseif armor < 200 then
      --       opts.color = lerpColor(opts.color, Color(0, 0, 0), 0)
      --    end
      -- elseif povPlayer.armorProtection == 1 then
      --     -- YA <  75 -> can pickup GA
      --    if armor < 75 then
      --       opts.color = lerpColor(opts.color, Color(0, 0, 0), 0.66)
      --     -- YA < 150 -> can pickup YA
      --    elseif armor < 150 then
      --       opts.color = lerpColor(opts.color, Color(0, 0, 0), 0.33)
      --    end
      -- elseif povPlayer.armorProtection == 0 then
      --     -- GA < 100 -> can pickup GA
      --    if armor < 100 then
      --       opts.color = lerpColor(opts.color, Color(0, 0, 0), 0.66)
      --    end
      -- end
   else
      armor = 'N/A'
      opts = userData.text.unknown
   end

   textCatoHUD(self, armor, opts).draw(0, 0)
end

registerCatoWidget('Cato_ArmorNumber')

------------------------------------------------------------------------------------------------------------------------

Cato_ArmorIcon = {}
defaultSettings['Cato_ArmorIcon'] = {
   properties = {visible = true, offset = '0 -20', anchor = '0 1', zIndex = '0', scale = '1'},
   userData = {
      anchorWidget = '',
      hideWhen = 'mainMenu menu hudOff gameOver freecam editor',
      icon = {color = Color(191, 191, 191), size = 24},
   },
}

function Cato_ArmorIcon:drawWidget(userData)
   if bitand(CatoState, state.playercam) == 0 then return end
   if bitand(CatoState, state.spectator) ~= 0 then return end -- FIXME: Technically not correct state check

   local opts = copyOpts(userData.icon)

   if not povPlayer.infoHidden then
      opts.color = CatoHUD.userData['armorColor'][povPlayer.armorProtection + 1]
   end

   svgCatoHUD(self, 'internal/ui/icons/armor', opts).draw(0, 0)
end

registerCatoWidget('Cato_ArmorIcon')

------------------------------------------------------------------------------------------------------------------------

Cato_FPS = {}
defaultSettings['Cato_FPS'] = {
   properties = {visible = true, offset = '-3 -5', anchor = '1 -1', zIndex = '-999', scale = '1'},
   userData = {
      anchorWidget = '',
      hideWhen = 'hudOff',
      clampToMaxFPS = true,
      text = {font = 'TitilliumWeb-Bold', color = Color(255, 255, 255), size = 32},
   },
   cvars = {
      {'debug', 'int', 0, 0},
      {'frequency', 'float', 1.0},
      {'precision', 'int', 2},
      {'samples', 'int', 1000},
   },
}

local deltaSamples = {}
-- local function preAllocateDeltas(deltaSamples, sampleCount)
local function preAllocateDeltas(sampleCount)
   -- local deltaSamples = {}
   -- for deltaIndex = 1, sampleCount do
   --    deltaSamples[deltaIndex] = 0.0
   -- end
   -- return deltaSamples
   for deltaIndex = 1, sampleCount do
      insert(deltaSamples, deltaIndex, 0.0)
      -- deltaSamples[deltaIndex] = 0.0
   end
   -- return deltaSamples
end

local lastSampleCount = nil
local deltaIndex = 1
local sampleSum = 0.0
local measurementTimer = 0.0
local avgFPS = 0.0
local sampleAllocationDone = false
function Cato_FPS:drawWidget(userData)
   local opts = copyOpts(userData.text)

   local deltaTimeRaw = deltaTimeRaw

   local sampleCount, updateFrequency = widgetGetConsoleVariable('samples'), widgetGetConsoleVariable('frequency')
   if sampleCount ~= lastSampleCount then
      local fpsMax = consoleGetVariable('com_maxfps')
      if userData.clampToMaxFPS and fpsMax > 0 then sampleCount = min(fpsMax, sampleCount) end
      sampleCount = max(1, sampleCount)
      widgetSetConsoleVariable('samples', sampleCount)
      consolePrint(strf(
         '%s: Sample size %d -> %d. Discarding old samples.',
         self.name,
         lastSampleCount or 0,
         sampleCount
      ))
      -- deltaSamples = preAllocateDeltas(sampleCount)
      preAllocateDeltas(sampleCount)
      deltaIndex = 1
      sampleSum = 0.0
      measurementTimer = 0.0
      avgFPS = 0.0
      sampleAllocationDone = false
      opts.color = Color(191, 191, 191)
   end
   lastSampleCount = sampleCount

   -- deltaSamples is a rolling window buffer for deltaTimes
   -- sampleSum is the sum of last deltaSamples
   -- When the buffer is full the previous delta has to be subtracted from sampleSum before adding the new one

   -- NOTE: We pre-allocate deltaSamples, because otherwise we have to check deltaSamples[deltaIndex] for nil each frame
   --       Note however that pre-allocation means that #deltaSamples == sampleCount, so we MUST use deltaIndex as a way to
   --       count total sample when the buffer is not full.
   --       Using deltaIndex is probably more efficient (since it won't be used when sampleAllocationDone), but
   --       #deltaSamples would give a clearer intention and be more readable.
   -- sampleSum = sampleSum - (deltaSamples[deltaIndex] or 0.0)
   sampleSum = sampleSum - deltaSamples[deltaIndex]
   deltaSamples[deltaIndex] = deltaTimeRaw
   sampleSum = sampleSum + deltaTimeRaw
   deltaIndex = deltaIndex < sampleCount and deltaIndex + 1 or 1

   if widgetGetConsoleVariable('debug') ~= 0 then
      consolePrint(strf(
         '%s: deltaIndex = %d <= %d = sampleCount (%s)',
         self.name,
         deltaIndex,
         sampleCount,
         sampleAllocationDone
      ))
      consolePrint(strf(
         '%s: avgFPS = %f = %d / %f = %s / sampleSum',
         self.name,
         avgFPS,
         sampleAllocationDone and sampleCount or deltaIndex,
         sampleSum,
         sampleAllocationDone and 'sampleCount' or 'deltaIndex'
      ))
   end

   measurementTimer = measurementTimer + deltaTimeRaw
   if measurementTimer >= updateFrequency then
      if sampleAllocationDone then
         measurementTimer = 0.0
         avgFPS = sampleCount / sampleSum
      else
         avgFPS = deltaIndex / sampleSum
         if deltaIndex >= sampleCount then
            sampleAllocationDone = true
            opts.color = Color(255, 255, 255)
         end
      end
   end

   local precision = widgetGetConsoleVariable('precision')
   local fpsFormat = precision >= 0 and ('.' .. precision) or ''
   textCatoHUD(self, strf('%' .. fpsFormat .. 'ffps', round(avgFPS, precision)), userData.text).draw(0, 0)
end

registerCatoWidget('Cato_FPS')

------------------------------------------------------------------------------------------------------------------------

Cato_DisplayMode = {}
defaultSettings['Cato_DisplayMode'] = {
   properties = {visible = true, offset = '-100 0', anchor = '1 -1', zIndex = '-999', scale = '1'},
   userData = {
      anchorWidget = 'Cato_FPS',
      hideWhen = 'hudOff gameOver',
      text = {
         fullscreen = {font = 'TitilliumWeb-Bold', color = Color(255, 255, 255), size = 32},
         borderless = {font = 'TitilliumWeb-Bold', color = Color(255, 127, 127), size = 32},
         windowed = {font = 'TitilliumWeb-Bold', color = Color(255, 63, 63), size = 32},
      },
   },
}

-- local debugPrinted = false
function Cato_DisplayMode:drawWidget(userData)
   -- if world.gameState == GAME_STATE_ACTIVE and not debugPrinted then
   --    debugPrinted = true
   --    consoleVarPrint(CatoState, 'CatoState')
   --    consoleVarPrint(bitor(CatoState, state.localplayer, state.gameactive), 'bitor(CatoState, state.localplayer, state.gameactive)')
   --    consoleVarPrint(binrep(CatoState, maxState), 'CatoState')
   --    consoleVarPrint(binrep(bitor(CatoState, state.localplayer, state.gameactive), maxState), 'bitor(CatoState, state.localplayer, state.gameactive)')
   --    consoleVarPrint('fullscreen', fullscreen)
   -- end
   if CatoState == bitor(CatoState, state.localplayer, state.gameactive) and fullscreen then return end

   local refreshRate = consoleGetVariable('r_refreshrate')
   local monitorIndex = consoleGetVariable('r_monitor')
   -- FIXME: 1.2.0+backcompat
   if monitorIndex ~= nil and monitorIndex >= 0 then monitorIndex = ' #' .. monitorIndex else monitorIndex = '' end

   local mode, opts
   if fullscreen then
      mode = strf('Fullscreen%s %dx%d @ %.2fhz', monitorIndex, resolutionWidth, resolutionHeight, refreshRate)
      opts = userData.text.fullscreen
   elseif borderless then
      mode = strf('Borderless%s (Native)', monitorIndex)
      opts = userData.text.borderless
   else
      mode = strf('Windowed%s %dx%d @ %.2fhz', monitorIndex, resolutionWidth, resolutionHeight, refreshRate)
      opts = userData.text.windowed
   end

   textCatoHUD(self, mode, opts).draw(0, 0)
end

registerCatoWidget('Cato_DisplayMode')

------------------------------------------------------------------------------------------------------------------------

Cato_Time = {}
defaultSettings['Cato_Time'] = {
   properties = {visible = true, offset = '-3 18', anchor = '1 -1', zIndex = '-999', scale = '1'},
   userData = {
      anchorWidget = '',
      hideWhen = 'hudOff',
      text = {
         delimiter = {font = 'TitilliumWeb-Bold', color = Color(127, 127, 127), size = 32, anchor = {x = 0}},
         -- year = {font = 'TitilliumWeb-Bold', color = Color(255, 255, 255), size = 32, anchor = {x = -1}},
         -- month = {font = 'TitilliumWeb-Bold', color = Color(255, 255, 255), size = 32, anchor = {x = -1}},
         -- day = {font = 'TitilliumWeb-Bold', color = Color(255, 255, 255), size = 32, anchor = {x = -1}},
         hour = {font = 'TitilliumWeb-Bold', color = Color(255, 255, 255), size = 32, anchor = {x = 1}},
         minute = {font = 'TitilliumWeb-Bold', color = Color(255, 255, 255), size = 32, anchor = {x = -1}},
         -- second = {font = 'TitilliumWeb-Bold', color = Color(255, 255, 255), size = 32, anchor = {x = -1}},
      },
   },
}

function Cato_Time:drawWidget(userData)
   -- epochTime only
   -- if true then
   --    local time = formatEpochTime(epochTime, CatoHUD.userData.offsetUTC)
   --    local epochSeconds = epochTime + CatoHUD.userData.offsetUTC
   --    opts.second.anchor = self.anchor
   --    epochSeconds = textCatoHUD(self, epochSeconds, opts.second)
   --    epochSeconds.draw(0, 0)
   --    return
   -- end

   -- full datetime
   -- if true then
   --    local opts = {
   --       delimiter = copyOpts(userData.text.delimiter),
   --       year = copyOpts(userData.text.year),
   --       month = copyOpts(userData.text.month),
   --       day = copyOpts(userData.text.day),
   --       hour = copyOpts(userData.text.hour),
   --       minute = copyOpts(userData.text.minute),
   --       second = copyOpts(userData.text.second),
   --    }

   --    local time = formatEpochTime(epochTime, CatoHUD.userData.offsetUTC)

   --    local day = textCatoHUD(self, formatDay(time.day), opts.day)
   --    local delimiterDate1 = textCatoHUD(self, ' ', opts.delimiter)
   --    local month = textCatoHUD(self, formatMonth(time.month), opts.month)

   --    local delimiterDate2 = textCatoHUD(self, ' ', opts.delimiter)
   --    local year = textCatoHUD(self, time.year, opts.year)

   --    local delimiter = textCatoHUD(self, ' ', opts.delimiter)

   --    local hour = textCatoHUD(self, strf('%02d', time.hour), opts.hour)
   --    local delimiterTime1 = textCatoHUD(self, ':', opts.delimiter)
   --    local minute = textCatoHUD(self, strf('%02d', time.minute), opts.minute)

   --    local delimiterTime2 = textCatoHUD(self, ':', opts.delimiter)
   --    local second = textCatoHUD(self, strf('%02d', time.second), opts.second)

   --    local x = 0
   --    if self.anchor.x == -1 then
   --       x = x + 0
   --    elseif self.anchor.x == 0 then
   --       x = x - self.width * 0.5
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


   local epochSeconds
   -- FIXME: 1.2.0+backcompat
   if CatoHUD.userData.useLocalTime and epochTimeLocal ~= nil then epochSeconds = epochTimeLocal
   else epochSeconds = epochTime + CatoHUD.userData.offsetUTC end

   -- TODO: Figure out if time should be displayed during replay playback.
   --       It's a bit misleading since it displays current localtime, and replays don't seem to
   --       contain information regarding the actual IRL time they were played during.
   --       (Other than if the filename counts, but even then the question of timezone remains.)
   -- if inReplay then
   --    consolePrint('---')
   --    consoleTablePrint(replay)
   --    consolePrint(epochSeconds)
   --    consolePrint(replay.timecodeCurrent)
   -- end

   local hour = textCatoHUD(self, strf('%02d', floor(epochSeconds / S_IN_H) % H_IN_D), userData.text.hour)
   local delimiter = textCatoHUD(self, ':', userData.text.delimiter)
   local minute = textCatoHUD(self, strf('%02d', floor(epochSeconds / S_IN_M) % M_IN_H), userData.text.minute)

   -- FIXME: This alignment bs has to be figured out
   local x = 0
   local spacing = delimiter.width * 0.5
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

registerCatoWidget('Cato_Time')

------------------------------------------------------------------------------------------------------------------------

Cato_MMStats = {}
defaultSettings['Cato_MMStats'] = {
   properties = {visible = true, offset = '0 46', anchor = '1 -1', zIndex = '-999', scale = '1'},
   userData = {
      anchorWidget = 'Cato_MapName',
      hideWhen = 'hudOff',
      text = {
         status = {font = 'TitilliumWeb-Bold', color = Color(255, 255, 255), size = 32},
         rank = {font = 'TitilliumWeb-Bold', color = Color(255, 255, 255), size = 32},
         bestRank = {font = 'TitilliumWeb-Bold', color = Color(255, 255, 255), size = 24},
      },
      rankMMRs = {900, 1400, 1700, 2000, 2200, 2500},
      icon = {
         rank = {
            ['None'] = {
               label = 'None', svg = 'internal/ui/icons/searchIcon', color = Color(190, 190, 190), size = 12
            },
            ['Bronze'] = {
               label = 'Bronze', svg = 'internal/ui/icons/rank1Simple', color = Color(172, 107, 46), size = 12
            },
            ['Silver'] = {
               label = 'Silver', svg = 'internal/ui/icons/rank2Simple', color = Color(195, 202, 197), size = 12
            },
            ['Gold'] = {
               label = 'Gold', svg = 'internal/ui/icons/rank3Simple', color = Color(200, 172, 75), size = 12
            },
            ['Platinum'] = {
               label = 'Platinum', svg = 'internal/ui/icons/rank4Simple', color = Color(214, 214, 214), size = 12
            },
            ['Diamond'] = {
               label = 'Diamond', svg = 'internal/ui/icons/rank5Simple', color = Color(130, 154, 219), size = 12
            },
            ['Overlord'] = {
               label = 'Overlord', svg = 'internal/ui/icons/rank6Simple', color = Color(251, 205, 102), size = 12
            },
            ['Prime Overlord'] = {
               label = 'Prime Overlord', svg = 'internal/ui/icons/rank7Simple', color = Color(255, 222, 160), size = 12
            },
         },
         bestRank = {
            ['None'] = {
               label = 'None', svg = 'internal/ui/icons/searchIcon', color = Color(190, 190, 190), size = 10
            },
            ['Bronze'] = {
               label = 'Bronze', svg = 'internal/ui/icons/rank1Simple', color = Color(172, 107, 46), size = 10
            },
            ['Silver'] = {
               label = 'Silver', svg = 'internal/ui/icons/rank2Simple', color = Color(195, 202, 197), size = 10
            },
            ['Gold'] = {
               label = 'Gold', svg = 'internal/ui/icons/rank3Simple', color = Color(200, 172, 75), size = 10
            },
            ['Platinum'] = {
               label = 'Platinum', svg = 'internal/ui/icons/rank4Simple', color = Color(214, 214, 214), size = 10
            },
            ['Diamond'] = {
               label = 'Diamond', svg = 'internal/ui/icons/rank5Simple', color = Color(130, 154, 219), size = 10
            },
            ['Overlord'] = {
               label = 'Overlord', svg = 'internal/ui/icons/rank6Simple', color = Color(251, 205, 102), size = 10
            },
            ['Prime Overlord'] = {
               label = 'Prime Overlord', svg = 'internal/ui/icons/rank7Simple', color = Color(255, 222, 160), size = 10
            },
         },
      },
   },
}

local function getRankIcon(mmr, icon)
   if mmr <= 0 then return icon['None']
   elseif mmr < 900 then return icon['Bronze']
   elseif mmr < 1400 then return icon['Silver']
   elseif mmr < 1700 then return icon['Gold']
   elseif mmr < 2000 then return icon['Platinum']
   elseif mmr < 2200 then return icon['Diamond']
   elseif mmr < 2500 then return icon['Overlord']
   else return icon['Prime Overlord'] end
end

function Cato_MMStats:drawWidget(userData)
   -- if bitand(CatoState, state.localplayer) ~= 0 and bitand(CatoState, state.gameactive) ~= 0 then return end
   if CatoState == bitor(CatoState, state.localplayer, state.gameactive) then return end

   local matchmaking = matchmaking
   local matchmakingState = matchmaking.state
   -- consoleVarPrint('matchmaking', matchmaking)

   local mmState = ''
   if matchmakingState == MATCHMAKING_DISABLED then
      return
   elseif not connectedToSteam then
      mmState = 'No Steam connection'
   elseif matchmakingState == MATCHMAKING_PINGINGREGIONS then
      mmState = 'Pinging'
   elseif matchmakingState == MATCHMAKING_REQUESTINGLOBBYSERVER then
      mmState = 'Requesting lobby'
   elseif matchmakingState == MATCHMAKING_ENABLED_BUT_IDLE then
      mmState = 'Idle'
   elseif matchmakingState == MATCHMAKING_SEARCHINGFOROPPONENTS then
      local searchTime = formatTimeMs((matchmakingTimeSearching or 0) * 1000)
      mmState = strf('Searching %02d:%02d:%02d', searchTime.hours, searchTime.minutes, searchTime.seconds)
   elseif matchmakingState == MATCHMAKING_FOUNDOPPONENTS then
      local ready = matchmaking.clientSideReady
      mmState = strf('Match found (%s)', (ready and 'ready' or 'not ready'))
   elseif matchmakingState == MATCHMAKING_VOTINGMAP then
      mmState = 'Voting'
   elseif matchmakingState == MATCHMAKING_VOTEFINISHED then
      mmState = 'Vote finished'
   elseif matchmakingState == MATCHMAKING_FINDINGSERVER then
      mmState = 'Finding server'
   elseif matchmakingState == MATCHMAKING_LOSTCONNECTIONATTEMPTINGRECONNECT then
      mmState = 'Reconnecting'
   elseif matchmakingState == MATCHMAKING_BANNED then
      mmState = 'BANNED'
   end

   local mmPlaylistKey = world.matchmakingPlaylistKey
   if mmPlaylistKey == '' then mmPlaylistKey = '1v1' end

   local mmPlaylist = {}
   for _, playlist in ipairs(matchmaking.playlists or {}) do
      if playlist.key == mmPlaylistKey then
         mmPlaylist = playlist
         break
      end
   end
   -- consoleVarPrint(mmPlaylistKey, mmPlaylist)

   local mmLobby = world.isMatchmakingLobby

   local mmr = mmPlaylist.mmr or 0
   local mmrBest = mmPlaylist.mmrBest or 0
   local mmrDiff = ''
   if mmLobby and povPlayer then
      mmr = povPlayer.mmr
      mmrBest = povPlayer.mmrBest
      mmrDiff = povPlayer.mmrNew - mmr
      mmrDiff = mmrDiff ~= 0 and (mmrDiff > 0 and ' [+' .. mmrDiff .. ']' or ' [' .. mmrDiff .. ']') or ''
   end

   local mmStatus = textCatoHUD(self, mmState, userData.text.status)
   local x, y = 0, 0
   mmStatus.draw(x, y)

   local rankIcon, bestIcon = getRankIcon(mmr, userData.icon.rank), getRankIcon(mmrBest, userData.icon.bestRank)

   y = y + mmStatus.height - 8
   local spacing = rankIcon.size * 0.25
   local mmRankIcon = svgCatoHUD(self, rankIcon.svg, rankIcon)
   local mmRankText = textCatoHUD(self, strf('%s (%s%s)', rankIcon.label, mmr, mmrDiff), userData.text.rank)
   -- local lineWidth = 0
   local lineWidth = mmRankIcon.width + spacing + mmRankText.width
   if self.anchor.x == -1 then
      x = 0
   elseif self.anchor.x == 0 then
      x = -lineWidth * 0.5
   elseif self.anchor.x == 1 then
      x = -lineWidth
   end
   local iconHeight, textHeight = mmRankIcon.height, mmRankText.height
   local maxHeight = max(textHeight, iconHeight)
   x = x + mmRankIcon.width
   mmRankIcon.draw(x, y + (maxHeight - min(textHeight, iconHeight)) * 0.5)
   x = x + spacing + mmRankText.width
   mmRankText.draw(x, y)

   y = y + maxHeight - 4
   spacing = bestIcon.size * 0.25
   local mmBestIcon = svgCatoHUD(self, bestIcon.svg, bestIcon)
   local mmBestText = textCatoHUD(self, strf('%s (%s)', bestIcon.label, mmrBest), userData.text.bestRank)
   -- lineWidth = 0
   lineWidth = mmBestIcon.width + spacing + mmBestText.width
   if self.anchor.x == -1 then
      x = 0
   elseif self.anchor.x == 0 then
      x = -lineWidth * 0.5
   elseif self.anchor.x == 1 then
      x = -lineWidth
   end
   iconHeight, textHeight = mmBestIcon.height, mmBestText.height
   maxHeight = max(textHeight, iconHeight)
   x = x + mmBestIcon.width
   mmBestIcon.draw(x, y + (maxHeight - min(textHeight, iconHeight)) * 0.5)
   x = x + spacing + mmBestText.width
   mmBestText.draw(x, y)
end

registerCatoWidget('Cato_MMStats')

------------------------------------------------------------------------------------------------------------------------

Cato_Scores = {}
defaultSettings['Cato_Scores'] = {
   properties = {visible = true, offset = '0 23', anchor = '1 -1', zIndex = '0', scale = '1'},
   userData = {
      anchorWidget = 'Cato_Time',
      hideWhen = 'mainMenu menu hudOff editor',
      text = {
         delimiter = {font = 'TitilliumWeb-Bold', color = Color(127, 127, 127), size = 40, anchor = {x = 0}},
         team = {font = 'TitilliumWeb-Bold', color = Color(255, 255, 255), size = 40, anchor = {x = 1}},
         enemy = {font = 'TitilliumWeb-Bold', color = Color(0, 255, 0), size = 40, anchor = {x = -1}},
      },
   },
}

function Cato_Scores:drawWidget(userData)
   local opts = {
      team = copyOpts(userData.text.team),
      enemy = copyOpts(userData.text.enemy),
      delimiter = copyOpts(userData.text.delimiter),
   }
   opts.team.color, opts.enemy.color = colorFriend, colorEnemy

   local playerIndex = playerIndexCameraAttachedTo
   local scoreTeam, indexTeam, scoreEnemy, indexEnemy
   local relativeColors = consoleGetVariable('cl_colors_relative') == 1
   if gameModeHasTeams then
      if povPlayer and povPlayer.state == PLAYER_STATE_INGAME then
         indexTeam = povPlayer.team; indexEnemy = indexTeam % 2 + 1
         if not relativeColors then
            opts.team.color, opts.enemy.color = teamColors[indexTeam], teamColors[indexEnemy]
         end
      else
         indexTeam, indexEnemy = TEAM_ALPHA, TEAM_ZETA
         opts.team.color, opts.enemy.color = teamColors[indexTeam], teamColors[indexEnemy]
      end
      scoreTeam, scoreEnemy = world.teams[indexTeam].score, world.teams[indexEnemy].score
   elseif gameModeShortName == '1v1' or gameModeShortName == 'ffa' then
      local scoreWinner, scoreRunnerUp, indexWinner, indexRunnerUp
      for _, p in ipairs(players) do
         if p.state == PLAYER_STATE_INGAME and p.connected then
            if scoreWinner == nil or p.score > scoreWinner then
               scoreRunnerUp, indexRunnerUp, scoreWinner, indexWinner = scoreWinner, indexWinner, p.score, p.index
            elseif scoreRunnerUp == nil or p.score > scoreRunnerUp then
               scoreRunnerUp, indexRunnerUp = p.score, p.index
            end
         end
      end

      scoreTeam, indexTeam, scoreEnemy, indexEnemy = scoreWinner, indexWinner, scoreRunnerUp, indexRunnerUp
      if povPlayer and povPlayer.state == PLAYER_STATE_INGAME and povPlayer.connected then
         if indexWinner == playerIndex then
            scoreTeam, indexTeam, scoreEnemy, indexEnemy = scoreWinner, indexWinner, scoreRunnerUp, indexRunnerUp
         elseif indexRunnerUp == playerIndex then
            scoreTeam, indexTeam, scoreEnemy, indexEnemy = scoreRunnerUp, indexRunnerUp, scoreWinner, indexWinner
         else
            scoreTeam, indexTeam, scoreEnemy, indexEnemy = povPlayer.score, playerIndex, scoreWinner, indexWinner
         end
      end

      -- Use player colors in FFA/1v1
      if not relativeColors or not povPlayer or povPlayer.state ~= PLAYER_STATE_INGAME then
         if indexTeam ~= nil then opts.team.color = extendedColors[players[indexTeam].colorIndices[1] + 1] end
         if indexEnemy ~= nil then opts.enemy.color = extendedColors[players[indexEnemy].colorIndices[1] + 1] end
      end
   elseif gameModeShortName == 'race' then return-- TODO: Implement
   elseif gameModeShortName == 'training' then return-- TODO: Implement
   else return end

   scoreTeam = textCatoHUD(self, scoreTeam or 'N/A', opts.team)
   local delimiter = textCatoHUD(self, '    ', opts.delimiter)
   scoreEnemy = textCatoHUD(self, scoreEnemy or 'N/A', opts.enemy)

   -- FIXME: This alignment bs has to be figured out
   local x = 0
   local spacing = delimiter.width * 0.5
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

registerCatoWidget('Cato_Scores')

------------------------------------------------------------------------------------------------------------------------

Cato_RulesetName = {}
defaultSettings['Cato_RulesetName'] = {
   properties = {visible = true, offset = '0 27', anchor = '1 -1', zIndex = '0', scale = '1'},
   userData = {
      anchorWidget = 'Cato_Scores',
      hideWhen = 'mainMenu menu hudOff editor',
      text = {font = 'TitilliumWeb-Bold', color = Color(255, 255, 255), size = 32},
   },
}

function Cato_RulesetName:drawWidget(userData)
   if bitand(CatoState, state.localplayer) ~= 0 and bitand(CatoState, state.gameactive) ~= 0 then return end
   -- if bitand(the == CatoState, state.localplayer, state.gameactive) == CatoSt return end

   textCatoHUD(self, ruleset, userData.text).draw(0, 0)
end

registerCatoWidget('Cato_RulesetName')

------------------------------------------------------------------------------------------------------------------------

Cato_GameModeName = {}
defaultSettings['Cato_GameModeName'] = {
   properties = {visible = true, offset = '0 23', anchor = '1 -1', zIndex = '0', scale = '1'},
   userData = {
      anchorWidget = 'Cato_RulesetName',
      hideWhen = 'mainMenu menu hudOff editor',
      text = {font = 'TitilliumWeb-Bold', color = Color(255, 255, 255), size = 32},
   },
}

function Cato_GameModeName:drawWidget(userData)
   -- if bitand(CatoState, state.localplayer) ~= 0 and bitand(CatoState, state.gameactive) ~= 0 then return end
   if CatoState == bitor(CatoState, state.localplayer, state.gameactive) then return end

   textCatoHUD(self, strf('%s', gameModeShortName), userData.text).draw(0, 0)
end

registerCatoWidget('Cato_GameModeName')

------------------------------------------------------------------------------------------------------------------------

Cato_Timelimit = {}
defaultSettings['Cato_Timelimit'] = {
   properties = {visible = true, offset = '-75 0', anchor = '1 -1', zIndex = '0', scale = '1'},
   userData = {
      anchorWidget = 'Cato_GameModeName',
      hideWhen = 'mainMenu menu hudOff editor',
      text = {font = 'TitilliumWeb-Bold', color = Color(255, 255, 255), size = 32},
   },
}

function Cato_Timelimit:drawWidget(userData)
   -- bitand(CatoState, state.localplayer) == 0 => 00101 ^ 10000 = 10101
   -- bitand(CatoState, state.localplayer) ~= 0 => 10101 ^ 10000 = 00101
   -- if bitand(bitxor(CatoState, state.localplayer), bitor(state.warmup, state.replay)) == 0 then return end
   -- if bitand(CatoState, state.localplayer) ~= 0 and bitand(CatoState, state.gameactive) ~= 0 then return end
   if CatoState == bitor(CatoState, state.localplayer, state.gameactive) then return end

   local tl = formatTimeMs(timeLimit * 1000)
   textCatoHUD(self, strf('%d:%02d', tl.minutes, tl.seconds), userData.text).draw(0, 0)
end

registerCatoWidget('Cato_Timelimit')

------------------------------------------------------------------------------------------------------------------------

Cato_MapName = {}
defaultSettings['Cato_MapName'] = {
   properties = {visible = true, offset = '0 23', anchor = '1 -1', zIndex = '0', scale = '1'},
   userData = {
      anchorWidget = 'Cato_GameModeName',
      hideWhen = 'mainMenu menu hudOff editor',
      text = {font = 'TitilliumWeb-Bold', color = Color(255, 255, 255), size = 32},
   },
}

function Cato_MapName:drawWidget(userData)
   -- if bitand(CatoState, state.localplayer) ~= 0 and bitand(CatoState, state.gameactive) ~= 0 then return end
   if CatoState == bitor(CatoState, state.localplayer, state.gameactive) then return end

   textCatoHUD(self, mapTitle, userData.text).draw(0, 0)
end

registerCatoWidget('Cato_MapName')

------------------------------------------------------------------------------------------------------------------------

Cato_Mutators = {}
defaultSettings['Cato_Mutators'] = {
   properties = {visible = true, offset = '0 33', anchor = '1 -1', zIndex = '0', scale = '1'},
   userData = {
      anchorWidget = 'Cato_MapName',
      hideWhen = 'mainMenu menu hudOff editor',
      icon = {size = 12},
   },
}

function Cato_Mutators:drawWidget(userData)
   -- if bitand(CatoState, state.localplayer) ~= 0 and bitand(CatoState, state.gameactive) ~= 0 then return end
   if CatoState == bitor(CatoState, state.localplayer, state.gameactive) then return end

   local x = -userData.icon.size * 2
   local spacing = userData.icon.size * 0.5

   local gameMutators = {}
   -- TODO: Should this be ipairs and then use "gameMutators[i]" over "insert(gameMutators, mutator)"?
   for mutator in gmatch(mutators, '%S+') do
      mutator = mutatorDefinitions[toupper(mutator)]

      mutator = svgCatoHUD(self, mutator.icon, {color = mutator.col, size = userData.icon.size})
      x = x + mutator.width + spacing

      insert(gameMutators, mutator)
   end
   x = x - spacing -- spacing is only between the icons, adjust

   if self.anchor.x == -1 then
      x = 0
   elseif self.anchor.x == 0 then
      x = -x * 0.5
   elseif self.anchor.x == 1 then
      x = -x
   end

   for _, mutator in ipairs(gameMutators) do
      mutator.draw(x, 0)
      x = x + mutator.width + spacing
   end

   -- FIXME: What's this? P.S. Don't copyOpts
   -- local opts = copyOpts(userData.text)

   -- local gameMutators = textCatoHUD(self, mutators, opts)
   -- gameMutators.draw(0, 0)
end

registerCatoWidget('Cato_Mutators')

------------------------------------------------------------------------------------------------------------------------

Cato_LowAmmo = {}
defaultSettings['Cato_LowAmmo'] = {
   properties = {visible = true, offset = '0 160', anchor = '0 0', zIndex = '0', scale = '1'},
   userData = {
      anchorWidget = '',
      hideWhen = 'mainMenu menu dead hudOff warmup gameOver freecam editor',
      text = {
         click = {label = '*CLICK*', font = 'TitilliumWeb-Bold', color = Color(255, 255, 255), size = 72},
         empty = {label = 'NO AMMO', font = 'TitilliumWeb-Bold', color = Color(255, 0, 0), size = 64},
         halfLow = {label = nil, font = 'TitilliumWeb-Bold', color = Color(255, 0, 0), size = 72},
         low = {label = nil, font = 'TitilliumWeb-Bold', color = Color(255, 0, 0), size = 64},
         halfMid = {label = nil, font = 'TitilliumWeb-Bold', color = Color(255, 127, 0), size = 40},
         mid = {label = nil, font = 'TitilliumWeb-Bold', color = Color(255, 255, 0), size = 40},
         full = {label = 'FULL AMMO', font = 'TitilliumWeb-Bold', color = Color(255, 255, 255), size = 32},
      },
   },
}

local clickDelay = 0.0
function Cato_LowAmmo:drawWidget(userData)
   if clickDelay > 0.0 then clickDelay = clickDelay - deltaTime end

   if bitand(CatoState, state.preview) ~= 0 then
      local textPreview = textCatoHUD(self, '(Low Ammo)', userData.text.low)
      textPreview.draw(0, 0)
      return
   end

   if not povPlayer or povPlayer.infoHidden or povPlayer.isDead then
      clickDelay = 0.0
      return
   end

   local weaponIndex = povPlayer.weaponIndexweaponChangingTo -- povPlayer.weaponIndexSelected
   local weaponDefinition = weaponDefinitions[weaponIndex]
   if weaponIndex == 1 or weaponDefinition == nil then return end

   local lowAmmo, reloadTime = weaponDefinition.lowAmmoWarning, weaponDefinition.reloadTime
   local midAmmo = lowAmmo + ceil(1000 / reloadTime)
   local ammo, buttonAttack = povPlayer.weapons[weaponIndex].ammo, povPlayer.buttons.attack

   local opts
   if ammo <= 0 then
      if clickDelay > 0.0 then
         opts = userData.text.empty
      elseif buttonAttack then
         clickDelay = reloadTime
         opts = userData.text.click
      else
         opts = userData.text.empty
      end
   elseif ammo == 1 then
      if buttonAttack then
         clickDelay = reloadTime
      end
      opts = userData.text.halfLow
   elseif ammo <= lowAmmo * 0.5 then
      opts = userData.text.halfLow
   elseif ammo <= lowAmmo then
      opts = userData.text.low
   elseif ammo <= lowAmmo + (midAmmo - lowAmmo) * 0.5 then
      opts = userData.text.halfMid
   elseif ammo <= midAmmo then
      opts = userData.text.mid
   elseif ammo >= weaponDefinition.maxAmmo then
      opts = userData.text.full
   else
      return
   end

   textCatoHUD(self, opts.label or ammo, opts).draw(0, 0)
end

registerCatoWidget('Cato_LowAmmo')

------------------------------------------------------------------------------------------------------------------------

Cato_Ping = {}
defaultSettings['Cato_Ping'] = {
   properties = {visible = true, offset = '-3 4', anchor = '1 1', zIndex = '0', scale = '1'},
   userData = {
      anchorWidget = '',
      hideWhen = 'mainMenu hudOff editor',
      text = {font = 'TitilliumWeb-Bold', color = Color(255, 255, 255), size = 32},
   },
}

function Cato_Ping:drawWidget(userData)
   if bitand(CatoState, state.playercam) == 0 then return end
   if bitand(CatoState, state.spectator) ~= 0 then return end -- FIXME: Technically not correct state check

   local opts = copyOpts(userData.text)

   local latency = povPlayer.latency
   if latency == 0 then
      return
   elseif latency <= 50 then
      opts.color = Color(0, 255, 0)
   elseif latency < 100 then
      opts.color = Color(255, 255, 0)
   else
      opts.color = Color(255, 0, 0)
   end

   textCatoHUD(self, latency .. 'ms', opts).draw(0, 0)
end

registerCatoWidget('Cato_Ping')

------------------------------------------------------------------------------------------------------------------------

Cato_PacketLoss = {}
defaultSettings['Cato_PacketLoss'] = {
   properties = {visible = true, offset = '-3 -16', anchor = '1 1', zIndex = '0', scale = '1'},
   userData = {
      anchorWidget = '',
      hideWhen = 'mainMenu hudOff editor',
      text = {font = 'TitilliumWeb-Bold', color = Color(255, 0, 0), size = 32},
   },
}

function Cato_PacketLoss:drawWidget(userData)
   if bitand(CatoState, state.playercam) == 0 then return end
   if bitand(CatoState, state.spectator) ~= 0 then return end -- FIXME: Technically not correct state check

   local opts = copyOpts(userData.text)

   local packetLoss = povPlayer.packetLoss
   if packetLoss == 0 then
      return
   elseif packetLoss <= 5 then
      opts.color = Color(95, 255, 0)
   elseif packetLoss < 10 then
      opts.color = Color(191, 255, 0)
   else
      opts.color = Color(255, 0, 0)
   end

   textCatoHUD(self, packetLoss .. ' PL', opts).draw(0, 0)
end

registerCatoWidget('Cato_PacketLoss')

------------------------------------------------------------------------------------------------------------------------

Cato_GameTime = {}
defaultSettings['Cato_GameTime'] = {
   properties = {visible = true, offset = '0 -135', anchor = '0 1', zIndex = '0', scale = '1'},
   userData = {
      anchorWidget = '',
      hideWhen = 'mainMenu menu hudOff gameOver freecam editor',
      countDown = false,
      hideSeconds = false,
      text = {
         delimiter = {font = 'TitilliumWeb-Bold', color = Color(127, 127, 127), size = 120, anchor = {x = 0}},
         minutes = {font = 'TitilliumWeb-Bold', color = Color(255, 255, 255), size = 120, anchor = {x = 1}},
         seconds = {font = 'TitilliumWeb-Bold', color = Color(255, 255, 255), size = 120, anchor = {x = -1}},
      },
   },
}

function Cato_GameTime:drawWidget(userData)
   local hideSeconds = userData.hideSeconds

   local timeElapsed = 0
   -- if bitand(CatoState, state.warmup) ~= 0 then
   if world.gameState == GAME_STATE_WARMUP then
      timeElapsed = warmupTimeElapsed
   -- elseif bitand(CatoState, state.gameStateActive, state.gameStateRoundActive) ~= 0 then -- FIXME: Implement
   elseif world.gameState == GAME_STATE_ACTIVE or world.gameState == GAME_STATE_ROUNDACTIVE then
      timeElapsed = gameTimeElapsed
      hideSeconds = (hideSeconds and gameTimeLimit - gameTimeElapsed > 30000)
   end

   local timer = formatTimeMs(timeElapsed, gameTimeLimit, userData.countDown)

   local minutes = textCatoHUD(self, timer.minutes, userData.text.minutes)
   local delimiter = textCatoHUD(self, ':', userData.text.delimiter)
   local seconds = textCatoHUD(self, hideSeconds and 'xx' or strf('%02d', timer.seconds), userData.text.seconds)

   local x = 0
   local spacing = delimiter.width * 0.5
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

registerCatoWidget('Cato_GameTime')

------------------------------------------------------------------------------------------------------------------------

local delayCountDown = true
local delayRespawnMin = 1.0
local delayRespawnMax = 4.0

Cato_RespawnDelay = {}
defaultSettings['Cato_RespawnDelay'] = {
   properties = {visible = true, offset = '80 -90', anchor = '0 1', zIndex = '0', scale = '1'},
   userData = {
      anchorWidget = 'Cato_GameTime',
      hideWhen = 'mainMenu menu hudOff gameOver freecam editor',
      text = {font = 'TitilliumWeb-Bold', color = Color(255, 255, 255), size = 40},
   },
}

local deadTime = nil
function Cato_RespawnDelay:drawWidget(userData)
   -- FIXME: Switching POVs is going to give us trouble here
   if not povPlayer or povPlayer.state ~= PLAYER_STATE_INGAME then return end

   local isDead = povPlayer.isDead
   if deadTime ~= nil then
      if isDead then
         deadTime = deadTime + deltaTime
      else
         deadTime = nil
         return
      end
   else
      if isDead then
         deadTime = 0.0
      else
         return
      end
   end

   local opts = copyOpts(userData.text)
   local buttons = povPlayer.buttons
   local respawnButtons = buttons.attack or buttons.jump
   if deadTime < delayRespawnMin then
      opts.color = respawnButtons and Color(255, 255, 0) or Color(255, 0, 0)
   else
      -- NOTE: respawnButtons is false when dead?
      opts.color = respawnButtons and Color(255, 255, 255) or Color(0, 255, 0)
   end

   -- TODO: Keep remaining time visible for a short duration after respawn

   -- FIXME: Figure out the timer and don't clamp, noob
   -- local delay = strf('%f', delayCountDown and delayRespawnMax - deadTime or deadTime)
   local delay = strf('%.01f', clamp(delayCountDown and delayRespawnMax - deadTime or deadTime, 0.0, delayRespawnMax))
   textCatoHUD(self, delay, opts).draw(0, 0)
end

registerCatoWidget('Cato_RespawnDelay')

------------------------------------------------------------------------------------------------------------------------

Cato_FollowingPlayer = {}
defaultSettings['Cato_FollowingPlayer'] = {
   properties = {visible = true, offset = '0 0', anchor = '0 -1', zIndex = '0', scale = '1'},
   userData = {
      anchorWidget = '',
      hideWhen = 'mainMenu menu hudOff gameOver freecam editor',
      text = {font = 'TitilliumWeb-Bold', color = Color(255, 255, 255), size = 64, anchor = {x = 0}},
   },
}

function Cato_FollowingPlayer:drawWidget(userData)
   if not povPlayer then return end

   -- TODO: option for display on self
   if bitand(CatoState, state.localplayer) ~= 0 and bitand(CatoState, bitor(state.replay, state.preview)) == 0 then return end

   local label = textCatoHUD(self, 'FOLLOWING', userData.text)
   local name = textCatoHUD(self, povPlayer.name, userData.text)

   local x = 0
   if self.anchor.x == -1 then
      x = x + max(label.width, name.width) * 0.5
   elseif self.anchor.x == 0 then
      x = x + 0
   elseif self.anchor.x == 1 then
      x = x - (max(label.width, name.width) * 0.5)
   end

   local y = 0
   local offset = label.height / 3
   if self.anchor.y == -1 then
      y = y + 0
   elseif self.anchor.y == 0 then
      y = y - (label.height - offset) * 0.5
   elseif self.anchor.y == 1 then
      y = y - (name.height - offset)
   end

   label.draw(x, y)
   name.draw(x, y + label.height - offset)
end

registerCatoWidget('Cato_FollowingPlayer')

------------------------------------------------------------------------------------------------------------------------

Cato_ReadyStatus = {}
defaultSettings['Cato_ReadyStatus'] = {
   properties = {visible = true, offset = '0 145', anchor = '0 -1', zIndex = '0', scale = '1'},
   userData = {
      anchorWidget = '',
      hideWhen = 'mainMenu hudOff gameActive gameOver editor',
      text = {font = 'TitilliumWeb-Bold', color = Color(255, 255, 255), size = 32},
   },
}

function Cato_ReadyStatus:drawWidget(userData)
   if bitand(CatoState, bitor(state.warmup, state.preview)) == 0 then return end

   local playersReady, playersGame = 0, 0
   for _, p in ipairs(players) do
      if p.state == PLAYER_STATE_INGAME and p.connected then
         playersGame = playersGame + 1
         if p.ready then playersReady = playersReady + 1 end
      end
   end

   local opts = copyOpts(userData.text)
   if playersReady == 0 then
      opts.color = Color(255, 255, 255, 191)
   elseif povPlayer and not povPlayer.ready then
      opts.color = Color(255, 191, 191)
   end

   textCatoHUD(self, playersReady .. '/' .. playersGame .. ' ready', opts).draw(0, 0)
end

registerCatoWidget('Cato_ReadyStatus')

------------------------------------------------------------------------------------------------------------------------

Cato_GameMessage = {}
defaultSettings['Cato_GameMessage'] = {
   properties = {visible = true, offset = '0 -80', anchor = '0 0', zIndex = '0', scale = '1'},
   userData = {
      anchorWidget = '',
      hideWhen = 'mainMenu hudOff gameOver editor',
      text = {font = 'TitilliumWeb-Bold', color = Color(255, 255, 255), size = 40},
   },
}

local lastTickSeconds = -1
function Cato_GameMessage:drawWidget(userData)
   local gameMessage = nil
   if timerActive then
      -- elseif bitand(CatoState, state.gameStateWarmup, state.gameStateRoundPrepare) ~= 0 then -- FIXME: Implement
      if world.gameState == GAME_STATE_WARMUP or world.gameState == GAME_STATE_ROUNDPREPARE then
         local timer = formatTimeMs(gameTimeElapsed, gameTimeLimit, true)
         if lastTickSeconds ~= timer.seconds then
            lastTickSeconds = timer.seconds
            playSound('internal/ui/match/match_countdown_tick')
         end
         gameMessage = timer.seconds
      -- elseif bitand(CatoState, state.gameStateActive, state.gameStateRoundActive) ~= 0 then -- FIXME: Implement
      elseif world.gameState == GAME_STATE_ACTIVE or world.gameState == GAME_STATE_ROUNDACTIVE then
         if gameTimeElapsed < 2500 then
            local overTimeCount = world.overTimeCount
            if overTimeCount <= 0 then
               gameMessage = (gameModeShortName == 'race' or gameModeShortName == 'training') and 'GO' or 'FIGHT'
            else
               gameMessage = 'OVERTIME #' .. overTimeCount
            end
         end
      -- elseif bitand(CatoState, state.gameStateRoundCooldownSomeoneWon) ~= 0 then -- FIXME: Implement
      elseif world.gameState == GAME_STATE_ROUNDCOOLDOWN_SOMEONEWON then
         -- FIXME: This shit just straight up showing the wrong name
         if povPlayer ~= nil then
            local name = gameModeHasTeams and world.teams[povPlayer.team].name or povPlayer.name
            gameMessage = name .. ' WINS'
         else
            gameMessage = 'Round Over'
         end
      -- elseif bitand(CatoState, state.gameStateRoundCooldownDraw) ~= 0 then -- FIXME: Implement
      elseif world.gameState == GAME_STATE_ROUNDCOOLDOWN_DRAW then
         gameMessage = 'DRAW'
      end
   end

   if bitand(CatoState, state.preview) ~= 0 then
      if gameMessage == nil then
         gameMessage = '(Game Message)'
      end
   elseif gameMessage == nil or isInMenu() then
      return
   end

   textCatoHUD(self, gameMessage, userData.text).draw(0, 0)
end

registerCatoWidget('Cato_GameMessage')

------------------------------------------------------------------------------------------------------------------------

Cato_Speed = {}
defaultSettings['Cato_Speed'] = {
   properties = {visible = false, offset = '0 60', anchor = '0 0', zIndex = '0', scale = '1'},
   userData = {
      anchorWidget = '',
      hideWhen = 'mainMenu menu dead hudOff gameOver freecam editor',
      text = {font = 'TitilliumWeb-Bold', color = Color(255, 255, 255), size = 32},
   },
}

function Cato_Speed:drawWidget(userData)
   if not povPlayer then return end

   textCatoHUD(self, ceil(povPlayer.speed) .. 'ups', userData.text).draw(0, 0)
end

registerCatoWidget('Cato_Speed')

------------------------------------------------------------------------------------------------------------------------

Cato_Crosshair = {}
defaultSettings['Cato_Crosshair'] = {
   properties = {visible = true, offset = '0 0', anchor = '0 0', zIndex = '0', scale = '1'},
   userData = {
      anchorWidget = '',
      hideWhen = 'mainMenu menu dead hudOff gameOver freecam',
      crosshairWidth = 2,
      crosshairHeight = 2,
      crosshairStroke = 1,
      crosshairThickness = 2,
      crosshairGapWidth = 0,
      crosshairGapHeight = 0,
      crosshairDotWidth = 0,
      crosshairDotHeight = 0,
      crosshairDotStroke = 0,
      crosshairColor = Color(255, 255, 255, 255),
      crosshairStrokeColor = Color(0, 0, 0, 255),
      crosshairDotColor = Color(255, 255, 255, 255),
      crosshairDotStrokeColor = Color(0, 0, 0, 255),
   },
}

function Cato_Crosshair:drawWidget(userData)
   local x, y = 0, 0

   local pixelWidth, pixelHeight = viewportWidth / resolutionWidth, viewportHeight / resolutionHeight

   local width, height = userData.crosshairWidth, userData.crosshairHeight
   local stroke, thickness = userData.crosshairStroke, userData.crosshairThickness
   local gapWidth, gapHeight = userData.crosshairGapWidth, userData.crosshairGapHeight
   local dotWidth, dotHeight = userData.crosshairDotWidth, userData.crosshairDotHeight
   local dotStroke = userData.crosshairDotStroke

   -- TODO: Optimize: we probably don't need a copy every frame + the color can be fetched in the nvgFillColor call
   -- NOTE: In general one may consider fetching all relevant tables at the end of Widget:drawWidget
   local crosshairColor = copyColor(userData.crosshairColor)
   local crosshairStrokeColor = copyColor(userData.crosshairStrokeColor)
   local crosshairDotColor = copyColor(userData.crosshairDotColor)
   local crosshairDotStrokeColor = copyColor(userData.crosshairDotStrokeColor)

   -- fix for odd values of thickness
   if thickness % 2 ~= 0 then x, y = x - 0.5, y - 0.5 end

   -- draw dot
   if dotWidth > 0 or dotHeight > 0 then
      -- dot stroke
      if dotStroke > 0 then
         nvgBeginPath()
         nvgRect(
            x + pixelWidth * (-dotWidth * 0.5 - dotStroke),
            y + pixelHeight * (-dotHeight * 0.5 - dotStroke),
            pixelWidth * (dotWidth + dotStroke * 2),
            pixelHeight * (dotHeight + dotStroke * 2)
         )
         nvgFillColor(crosshairDotStrokeColor)
         nvgFill()
      end

      -- dot
      nvgBeginPath()
      nvgRect(
         x + pixelWidth * -dotWidth * 0.5,
         y + pixelHeight * -dotHeight * 0.5,
         pixelWidth * dotWidth,
         pixelHeight * dotHeight
      )
      nvgFillColor(crosshairDotColor)
      nvgFill()
   end

   -- draw cross
   if gapHeight > 0 or gapWidth > 0 then
      -- 4 rect cross
      -- stroke
      if stroke > 0 then
         nvgBeginPath()
         nvgRect(
            x + pixelWidth * (-thickness * 0.5 - stroke),
            y + pixelHeight * (-height * 0.5 - gapHeight * 0.5 - stroke),
            pixelWidth * (thickness + stroke * 2),
            pixelHeight * (height * 0.5 + stroke * 2)
         )
         nvgRect(
            x + pixelWidth * (-thickness * 0.5 - stroke),
            y + pixelHeight * (gapHeight * 0.5 - stroke),
            pixelWidth * (thickness + stroke * 2),
            pixelHeight * (height * 0.5 + stroke * 2)
         )
         nvgRect(
            x + pixelWidth * (-width * 0.5 - gapWidth * 0.5 - stroke),
            y + pixelHeight * (-thickness * 0.5 - stroke),
            pixelWidth * (width * 0.5 + stroke * 2),
            pixelHeight * (thickness + stroke * 2)
         )
         nvgRect(
            x + pixelWidth * (gapWidth * 0.5 - stroke),
            y + pixelHeight * (-thickness * 0.5 - stroke),
            pixelWidth * (width * 0.5 + stroke * 2),
            pixelHeight * (thickness + stroke * 2)
         )
         nvgFillColor(crosshairStrokeColor)
         nvgFill()
      end

      -- cross
      nvgBeginPath()
      nvgRect(
         x + pixelWidth * -thickness * 0.5,
         y + pixelHeight * (-height * 0.5 - gapHeight * 0.5),
         pixelWidth * thickness,
         pixelHeight * height * 0.5
      )
      nvgRect(
         x + pixelWidth * -thickness * 0.5,
         y + pixelHeight * gapHeight * 0.5,
         pixelWidth * thickness,
         pixelHeight * height * 0.5
      )
      nvgRect(
         x + pixelWidth * (-width * 0.5 - gapWidth * 0.5),
         y + pixelHeight * -thickness * 0.5,
         pixelWidth * width * 0.5,
         pixelHeight * thickness
      )
      nvgRect(
         x + pixelWidth * gapWidth * 0.5,
         y + pixelHeight * -thickness * 0.5,
         pixelWidth * width * 0.5,
         pixelHeight * thickness
      )
      nvgFillColor(crosshairColor)
      nvgFill()
   else
      -- 2 rect cross
      -- stroke
      if stroke > 0 then
         nvgBeginPath()
         nvgRect(
            x + pixelWidth * (-thickness * 0.5 - stroke),
            y + pixelHeight * (-height * 0.5 - stroke),
            pixelWidth * (thickness + stroke * 2),
            pixelHeight * (height + stroke * 2)
         )
         nvgRect(
            x + pixelWidth * (-width * 0.5 - stroke),
            y + pixelHeight * (-thickness * 0.5 - stroke),
            pixelWidth * (width + stroke * 2),
            pixelHeight * (thickness + stroke * 2)
         )
         nvgFillColor(crosshairStrokeColor)
         nvgFill()
      end

      -- cross
      nvgBeginPath()
      nvgRect(
         x + pixelWidth * -thickness * 0.5,
         y + pixelHeight * -height * 0.5,
         pixelWidth * thickness,
         pixelHeight * height
      )
      nvgRect(
         x + pixelWidth * -width * 0.5,
         y + pixelHeight * -thickness * 0.5,
         pixelWidth * width,
         pixelHeight * thickness
      )
      nvgFillColor(crosshairColor)
      nvgFill()
   end
end

registerCatoWidget('Cato_Crosshair')

------------------------------------------------------------------------------------------------------------------------

--[[
-- NOTE: this was kinda cool...

local state = {
   mainMenu   = 1,
   menu       = 2,
   dead       = 3,
   race       = 4,
   replay     = 5,
   hudOff     = 6,
   gameActive = 7,
   gameWarmup = 8,
   gameOver   = 9,
   freecam    = 10,
   editor     = 11,
}

local stateLabel = {}
for k, v in pairs(state) do
   stateLabel[v] = k
end

local stateVars = ''
for i = 1, #stateLabel do
   -- consolePrint(stateName)
   stateVars = strf('%s, %s', stateVars, stateLabel[i])
end
stateVars = substr(stateVars, 3)

local states = {}
for stateIndex, _ in ipairs(states) do states[stateIndex] = false end

local function hideStates(hideWhen)
   if hideWhen == nil then return nil end
   local hideWhenVals = gsub(hideWhen, '%s+', ' or ')
   -- local hideWhenVars = gsub(hideWhen, '%s+', ', ')
   -- local shouldHide = 'local ' .. hideWhenVars .. ' = unpack(...); return ' .. hideWhenVals
   local shouldHide = 'local ' .. stateVars .. ' = unpack(...); return ' .. hideWhenVals
   -- consolePrint(shouldHide)
   -- return function () return false end
   return assert(load(shouldHide))

   -- if hideWhen == nil then return nil end
   -- local hideList = {}
   -- for _, stateIndex in pairs(state) do hideList[stateIndex] = false end
   -- for stateStr in gmatch(hideWhen, '%S+') do
   --    local stateIndex = state[stateStr]
   --    if stateIndex ~= nil then
   --       hideList[stateIndex] = true
   --    end
   -- end
   -- return hideList
end

function CatoHUD:draw()

   -- ...

   local replayActive, menuReplay = replayActive, replayName == 'menu'
   inReplay = replayActive and not menuReplay
   local gameWarmup, gameOver = gameState == GAME_STATE_WARMUP, gameState == GAME_STATE_GAMEOVER
   states[state.hudOff] = consoleGetVariable('cl_show_hud') == 0
   states[state.mainMenu] = replayActive and menuReplay
   states[state.menu] = loading.loadScreenVisible or isInMenu()
   states[state.race] = gameModeShortName == 'race' or gameModeShortName == 'training'
   states[state.replay] = inReplay
   states[state.gameWarmup] = gameWarmup
   states[state.gameOver] = gameOver
   states[state.gameActive] = not gameWarmup and not gameOver
   if povPlayer then
      states[state.dead] = povPlayer.isDead
      states[state.freecam] = localPov and povPlayer.state ~= PLAYER_STATE_INGAME
      states[state.editor] = povPlayer.state == PLAYER_STATE_EDITOR
   else
      states[state.dead] = true
      states[state.freecam] = false
      states[state.editor] = false
      -- povPlayer = fakePlayerInfo()
   end

   -- ...

   for _, widget in ipairs(CatoWidgets) do
      local userData = widget.userData
      if userData == nil then goto drawNext end

      -- update anchor, offset, anchor widget, x, y

      -- consoleVarPrint(strf('%s.hideWhen', widget.name), userData.hideWhen)
      -- consoleVarPrint(strf('%s.shouldHide(...)', widget.name), widget.shouldHide(states))
      -- consolePrint()
      if not previewMode and widget.shouldHide(states) then
         if not widget.hidden then
            widget.hidden = true
            widget.draw = function() end
         end
         -- goto drawNext
      else
         if widget.hidden then
            widget.hidden = false
            widget.draw = function() widget:drawWidget(userData, previewMode) end
         end
      end

      ::drawNext::
   end

   -- ...

end
]]