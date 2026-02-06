-- math
--
local abs = math.abs
local atan = math.atan
-- FIXME: atan2 is WRONG! Learn2trig or compare output to math.atan2
-- local atan2 = function(y, x) return math.atan(y, x) end -- math.atan2 is deprecated
local atan2 = math.atan2  -- math.atan2 is deprecated
local ceil = math.ceil
local deg2rad = math.rad -- function(x) return x * pi / 180 end
local floor = math.floor
local huge = math.huge
local max = math.max
local min = math.min
local pi = math.pi
local pow = function(x, y) return x ^ y end -- math.pow is deprecated
local rad2deg = math.deg -- function(x) return x * 180 / pi end
local random = math.random
local sin = math.sin
local sqrt = math.sqrt
local tan = math.tan
local csc = function(x) return 1 / sin(x) end
--

-- local x = 343534
-- local y = 235
-- consolePrint(x & y)

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
local tbli = table.insert
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

local function round(x)
   return x >= 0 and floor(x + 0.5) or ceil(x - 0.5)
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
-- consoleVarPrint('armorMax', armorMax)
-- consoleVarPrint('armorQuality', armorQuality)
-- consoleVarPrint('armorLimit', armorLimit)
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
-- consoleVarPrint('armorMax', armorMax)
-- consoleVarPrint('armorQuality', armorQuality)
-- consoleVarPrint('armorLimit', armorLimit)
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
-- consoleVarPrint('armorMax', armorMax)
-- consoleVarPrint('armorQuality', armorQuality)
-- consoleVarPrint('armorLimit', armorLimit)
-- consolePrint('---')

local function damageToKill(health, armor, armorProtection)
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
local function Color(r, g, b, a, intensity)
   return {r = r, g = g, b = b, a = (a or 255) * (intensity or 1)}
end

local function ColorHEX(hex, intensity)
   return {
      r = tonumber('0x' .. substr(hex, 1, 2)),
      g = tonumber('0x' .. substr(hex, 3, 4)),
      b = tonumber('0x' .. substr(hex, 5, 6)),
      a = (tonumber('0x' .. substr(hex, 7, 8)) or 255) * (intensity or 1)
   }
end

-- FIXME: Rename to newColor?
local function copyColor(color, intensity)
   return Color(color.r, color.g, color.b, color.a, intensity)
end

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

local function consoleColorPrint(color)
   consolePrint(strf('(%s, %s, %s, %s)', color.r, color.g, color.b, color.a))
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
-- Widget cache
------------------------------------------------------------------------------------------------------------------------

local indexCache = {}
local indexCacheSize = 0
local indexCacheUpdates = 0

-- Note: Calling this before initialize will fail
local function updateIndexCache(widgets, widgetName)
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
   tbli(debugLines, 'indexCacheSize: ' .. indexCacheSize)
   tbli(debugLines, 'indexCacheUpdates: ' .. indexCacheUpdates)
   tbli(debugLines, 'indexCache:')
   for widgetName, widgetIndex in pairs(indexCache) do
      local mismatch = ''
      if widgets[widgetIndex].name ~= widgetName then
         mismatch = '*'
      end
      tbli(debugLines, '  ' .. widgetName .. ': ' .. widgetIndex .. mismatch)
   end
   tbli(debugLines, 'widgets:')
   for widgetIndex, widget in ipairs(widgets) do
      if indexCache[widget.name] then
         tbli(debugLines, '  ' .. widgetIndex .. ': ' .. widget.name)
      end
   end
   return debugLines
end

------------------------------------------------------------------------------------------------------------------------
-- UI/NVG
------------------------------------------------------------------------------------------------------------------------

local viewportScale = nil

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
      font = opts.font,
      color = copyColor(opts.color, intensity),
      size = opts.size,
      anchor = opts.anchor and {x = opts.anchor.x, y = opts.anchor.y} or nil,
   }
end

local function getOffset(anchor, width, height)
   return {
      x = -(anchor.x + 1) * width / 2,
      y = -(anchor.y + 1) * height / 2,
   }
end

local function hAlignToAnchor(x)
   --    ANCHOR_LEFT = -1,    ANCHOR_CENTER = 0,    ANCHOR_RIGHT = 1
   -- NVG_ALIGN_LEFT =  0, NVG_ALIGN_CENTER = 1, NVG_ALIGN_RIGHT = 2
   return x + 1
end

local function vAlignToAnchor(y)
   --    ANCHOR_TOP = -1,    ANCHOR_MIDDLE = 0,    ANCHOR_BOTTOM = 1
   -- NVG_ALIGN_TOP =  1, NVG_ALIGN_MIDDLE = 2, NVG_ALIGN_BOTTOM = 3 (NVG_ALIGN_BASELINE = 0)
   return y + 2
end

local function createTextElem(widget, text, opts)
   -- FIXME: Is this a good idea?
   -- opts.size = opts.size * viewportHeight / 1080
   -- Answer: NO. Scaling is fine but positioning gets fucked up. (Fixable by adjusting y?)
   -- FIXME: Is this a better idea?
   -- opts.size = opts.size * viewportHeight / resolutionHeight
   -- Answer: Better? Yes. Good? Sorta. Scaling and positioning are fine. (Fixable by adjusting y?)
   -- opts.size = opts.size * viewportScale

   local height = opts.size * viewportScale
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
      nvgTextAlign(hAlignToAnchor(anchorX), vAlignToAnchor(anchorY))

      nvgFillColor(Color(0, 0, 0, opts.color.a * 3))
      nvgFontBlur(2)
      nvgText(x, y, text)

      nvgFillColor(opts.color)
      nvgFontBlur(0)
      nvgText(x, y, text)

      widget.xMin = min(widget.xMin, x)
      widget.xMax = max(widget.xMax, x + width)
      widget.width = widget.xMax - widget.xMin

      widget.yMin = min(widget.yMin, y)
      widget.yMax = max(widget.yMax, y + height)
      widget.height = widget.yMax - widget.yMin

      if consoleGetVariable('ui_CatoHUD_box_debug') ~= 0 then
         -- local bounds = nvgTextBounds(text)
         -- -- consoleVarPrint('bounds', bounds)
         -- consolePrint('')
         -- nvgRect(bounds.minx, bounds.miny, bounds.maxx - bounds.minx, bounds.maxy - bounds.miny)
         local pos = getOffset({x = anchorX, y = anchorY}, width, height)
         nvgFillColor(Color(0, 255, 0, 63))
         nvgBeginPath()
         nvgRect(x + pos.x, y + pos.y, width, height)
         nvgFill()
         -- TODO: Draw widget's name, anchor point, min-/max-x/y
      end
   end

   return {width = width, height = height, draw = draw}
end

local function createSvgElem(widget, image, opts)
   -- FIXME: Is this a good idea?
   -- opts.size = opts.size * viewportHeight / 1080
   -- Answer: NO. Scaling is fine but positioning gets fucked up. (Fixable by adjusting y?)
   -- FIXME: Is this a better idea?
   -- local width = 2 * opts.size * viewportWidth / resolutionWidth
   -- local height = 2 * opts.size * viewportHeight / resolutionHeight
   -- Answer: Better? Yes. Good? Sorta. Scaling and positioning are fine. (Fixable by adjusting y?)

   local width = 2 * opts.size * viewportScale
   local height = 2 * opts.size * viewportScale

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

      widget.xMin = min(widget.xMin, x)
      widget.xMax = max(widget.xMax, x + width)
      widget.width = widget.xMax - widget.xMin

      widget.yMin = min(widget.yMin, y)
      widget.yMax = max(widget.yMax, y + height)
      widget.height = widget.yMax - widget.yMin

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

local function uiTextCato(pos, text, opts)
   -- FIXME: WTF BRO
   local widget = {
      anchor = {x = -1, y = -1}, x = 0, y = 0, xMin = 0, xMax = 0, width = 0, yMin = 0, yMax = 0, height = 0
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

      local t = nil
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
      local textY = pos.y + opts.height * 0.5

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
   local diffHalf = (inputOpts.height - textOpts.size) / 2
   pos.y = pos.y + max(0, diffHalf)
   local label = uiTextCato(pos, text, textOpts)

   local padding = label.width + 8
   pos.x = pos.x + padding
   pos.y = pos.y - label.height - diffHalf
   value = inputFunc(pos, value, inputOpts)
   pos.y = pos.y + max(label.height, inputOpts.height) -- padding
   pos.x = pos.x - padding
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

local function optPreview(pos, opts, previewMode)
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

local function optDebug(pos, opts, widgets, widget)
   optDelimiter(pos, opts.delimiter)
   uiTextCato(pos, 'Debug', opts.medium)

   local anchor = getProps(widgets, widget.name).anchor
   uiTextCato(pos, 'anchor: ' .. anchor.x .. ' ' .. anchor.y, opts.small)
   uiTextCato(pos, 'getOptionsHeight(): ' .. widget.getOptionsHeight(), opts.small)
   for _, debugLine in ipairs(debugIndexCache(widgets)) do
      uiTextCato(pos, debugLine, opts.small)
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

-- FIXME: Remove these eventually
local fontFace = 'TitilliumWeb-Bold'
local fontSizeTiny = 24
local fontSizeSmall = 32
local fontSizeMedium = 40
local fontSizeBig = 64
local fontSizeHuge = 72
local fontSizeTimer = 120
local fontSizeHealthAndArmor = 160

-- FIXME: Tests
-- local fontSizeMult = 1.0
-- fontSizeTiny = fontSizeTiny * fontSizeMult
-- fontSizeSmall = fontSizeSmall * fontSizeMult
-- fontSizeMedium = fontSizeMedium * fontSizeMult
-- fontSizeBig = fontSizeBig * fontSizeMult
-- fontSizeHuge = fontSizeHuge * fontSizeMult
-- fontSizeTimer = fontSizeTimer * fontSizeMult
-- fontSizeHealthAndArmor = fontSizeHealthAndArmor * fontSizeMult

local defaultUserData = {}
local defaultProperties = {}
local defaultCvars = {}

local CatoWidgets = {}

CatoHUD = {canHide = false, canPosition = false}

defaultUserData['CatoHUD'] = {
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
}
defaultCvars['CatoHUD'] = {
   {'backup_config', 'int', 1},
   {'box_debug', 'int', 0, 0},
   {'debug', 'int', 0},
   {'preview', 'int', 0, 0},
   {'reset_widgets', 'string', '', ''},
   {'warmuptimer_reset', 'int', 0, 0},
   {'widget_cache', 'int', 0, 0},
}

local previewMode = nil

local TEAM_ALPHA = 1
local TEAM_ZETA  = 2

local povPlayer = nil
-- local localPlayer = nil
local localPov = nil

local gameState = nil
local gameMode = nil
local hasTeams = nil
local map = nil
local mapTitle = nil
local ruleset = nil
local mutators = nil
local gameTimeElapsed = nil
local gameTimeLimit = nil

local timerActive = nil
local timeLimit = nil
-- local timeLimitRound = nil

local previousMap = nil
local warmupTimeElapsed = 0

local fullscreenOn = nil
local borderlessOn = nil
local resolutionHeight = nil
local resolutionWidth = nil
local viewportWidth = nil
local viewportHeight = nil

local colorFriendHEX = nil
local colorEnemyHEX = nil
local colorFriend = nil
local colorEnemy = nil

local function fakePlayerInfo()
   return {
      connected = random(0, 1) == 1,
      state = PLAYER_STATE_INGAME,
      ready = random(0, 1) == 1,

      health = random(-99, 200),
      armor = random(0, 200),
      armorProtection = random(0, 2),
      isDead = random(0, 1) == 1,

      buttons = {attack = random(0, 1) == 1, jump = random(0, 1) == 1},
      speed = random(0, 999),

      latency = random(0, 999),
      packetLoss = random(0, 100),
      mmr = random(0, 9999),
      mmrBest = random(0, 9999),
      mmrNew = random(0, 9999),

      name = 'Fake Player',
      score = random(0, 50),

      infoHidden = random(0, 1) == 1,
      team = random(0, 1),

      weaponIndexSelected = random(1, 9),
      weaponIndexweaponChangingTo = random(1, 9),
      weapons = {
         [1] = {ammo = random(0, 999)},
         [2] = {ammo = random(0, 999)},
         [3] = {ammo = random(0, 999)},
         [4] = {ammo = random(0, 999)},
         [5] = {ammo = random(0, 999)},
         [6] = {ammo = random(0, 999)},
         [7] = {ammo = random(0, 999)},
         [8] = {ammo = random(0, 999)},
         [9] = {ammo = random(0, 999)},
      },
   }
end

-- TODO: Sort by most to least commonly true condition
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

-- FIXME: Debug
local stateLabel = {}
for k, v in pairs(state) do
   stateLabel[v] = k
end

local states = {}
for stateIndex, _ in ipairs(states) do states[stateIndex] = false end

local function hideStates(hideStr)
   if hideStr == nil then return nil end

   local hideList = {}
   for _, stateIndex in pairs(state) do hideList[stateIndex] = false end
   for stateStr in gmatch(hideStr, '%S+') do
      if state[stateStr] ~= nil then
         hideList[state[stateStr]] = true
      end
   end
   return hideList
end

local function RegisterCato(widgetName, widget)
   widget.name = widgetName

   widget.x = 0
   widget.xMin = widget.x
   widget.xMax = widget.x

   widget.y = 0
   widget.yMin = widget.y
   widget.yMax = widget.y

   widget.width = 0
   widget.height = 0

   registerWidget(widgetName)

   widget.initialize = function(self, reset)
      self.userData = reset and {} or loadUserData()

      -- properties
      if reset or self.userData == nil then
         local default = defaultProperties[widget.name] or {}
         local offset  = default.offset  or '0 0'
         local anchor  = default.anchor  or '0 0'
         local zIndex  = default.zIndex  or '0'
         local scale   = default.scale   or '1'
         local visible = default.visible ~= false and 'show' or 'hide'
         consolePerformCommand(strf('ui_show_widget %s',          widget.name))
         consolePerformCommand(strf('ui_set_widget_offset %s %s', widget.name, offset))
         consolePerformCommand(strf('ui_set_widget_anchor %s %s', widget.name, anchor))
         consolePerformCommand(strf('ui_set_widget_zIndex %s %s', widget.name, zIndex))
         consolePerformCommand(strf('ui_set_widget_scale %s %s',  widget.name, scale))
         consolePerformCommand(strf('ui_%s_widget %s',            visible,     widget.name))
      end

      -- cvars
      for _, cvar in ipairs(defaultCvars[widget.name] or {}) do
         if reset ~= true then
            widgetCreateConsoleVariable(cvar[1], cvar[2], cvar[3])
            if cvar[4] then
               widgetSetConsoleVariable(cvar[1], cvar[4])
            end
         else
            widgetSetConsoleVariable(cvar[1], cvar[4] or cvar[3])
         end
      end

      -- userData
      -- FIXME: Unrecurse?
      local function setWidgetUserData(container, varName, defaultVal)
         if type(container[varName]) ~= type(defaultVal) then
            container[varName] = defaultVal
         elseif type(defaultVal) == 'table' then
            for var, val in pairs(defaultVal) do setWidgetUserData(container[varName], var, val) end
         end
      end
      setWidgetUserData(self, 'userData', defaultUserData[self.name])

      -- local widgets = widgets

      -- consoleVarPrint(strf('%s.userData', self.name), self.userData)
      -- consoleVarPrint(strf('%s.userData', self.name), type(self.userData))

      -- hide states
      self.hideWhen = hideStates(self.userData.hideWhen)
      -- consoleVarPrint(strf('%s.hideWhen', self.name), self.hideWhen)

      -- -- anchor
      -- self.anchor = self.anchor or getProps(widgets, self.name).anchor
      -- consoleVarPrint(strf('%s.anchor', self.name), self.anchor)

      -- -- offset
      -- self.offset = self.offset or getProps(widgets, self.name).offset
      -- consoleVarPrint(strf('%s.offset', self.name), self.offset)

      -- -- anchor widget
      -- local anchorWidgetName = self.userData.anchorWidget
      -- consoleVarPrint(strf('%s.userData.anchorWidget', self.name), anchorWidgetName)
      -- if anchorWidgetName ~= nil then
      --    -- FIXME: These are not indexed by name
      --    -- anchorWidget = CatoWidgets[anchorWidgetName]
      --    local anchorWidget = _G[anchorWidgetName]
      --    consolePrint(strf('%s.anchorWidget = %s', self.name, anchorWidget and anchorWidget.name or 'nil'))
      --    consoleVarPrint(strf('%s.anchorWidget.offset', self.name), anchorWidget and anchorWidget.offset)
      --    if anchorWidget ~= nil and anchorWidget.offset ~= nil then
      --       self.x = anchorWidget.x + anchorWidget.offset.x
      --       self.y = anchorWidget.y + anchorWidget.offset.y
      --       consolePrint(strf('%s.x = %s, %s.y = %s', self.name, self.x, self.name, self.y))
      --    end
      -- end

      -- init
      if self.init then self:init(self.userData) end
   end

   -- draw
   if widget.name ~= 'CatoHUD' then
      tbli(CatoWidgets, widget)
      widget.drawInitialized = false
      widget.draw = function() end
   end

   -- finalize
   widget.finalize = function(self)
      local userData = self.userData
      if userData then saveUserData(userData) end

      if self.final then
         self:final(userData)
      end
   end

   -- getOptionsHeight
   widget.optionsHeight = 0
   widget.getOptionsHeight = function(self)
      return self.optionsHeight
   end

   -- drawOptions
   widget.drawOptions = function(self, x, y, intensity)
      local userData = self.userData
      local pos = {x = x, y = y}
      local opts = optionsOpts(intensity)

      -- title/widget
      uiTextCato(pos, self.name, opts.widgetName)

      -- preview
      optPreview(pos, opts, previewMode)

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
      optDebug(pos, opts, widgets, self)

      -- set & save widget data
      saveUserData(userData)
      self.hideWhen = hideStates(userData.hideWhen) -- FIXME: We can do this dynamically with the selector
      self.optionsHeight = pos.y - y
   end
end

------------------------------------------------------------------------------------------------------------------------

function CatoHUD:init(userData)
   consolePrint('')
   consolePrint('CatoHUD loaded')

   local useLocalEpochTime = userData.useLocalTime and epochTimeLocal ~= nil

   local offsetUTC = useLocalEpochTime and (epochTimeLocal - epochTime) or userData.offsetUTC
   local time = formatEpochTime(useLocalEpochTime and epochTimeLocal or (epochTime + offsetUTC))
   local offsetHours = offsetUTC / S_IN_H
   offsetHours = offsetHours ~= 0 and (offsetHours > 0 and '+' .. offsetHours or offsetHours) or ''
   consolePrint(strf('%d-%02d-%02d %02d:%02d:%02d %s',
      time.year,
      time.month,
      time.day,
      time.hour,
      time.minute,
      time.second,
      useLocalEpochTime and '(Local)' or '(UTC' .. offsetHours .. ')'
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
         'game', -- consoleGetVariable('name'),
         time.year,
         time.month,
         time.day,
         time.hour,
         time.minute,
         time.second
      )

      if userData.configBackup ~= configBackup then
         userData.configBackup = configBackup
         -- saveUserData(userData) -- FIXME: Need?
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
   previewMode = widgetGetConsoleVariable('preview') ~= 0

   povPlayer = players[playerIndexCameraAttachedTo]
   -- localPlayer = players[playerIndexLocalPlayer]
   localPov = playerIndexCameraAttachedTo == playerIndexLocalPlayer

   local world = world
   gameState = world.gameState
   gameMode = gamemodes[world.gameModeIndex].shortName
   hasTeams = gamemodes[world.gameModeIndex].hasTeams
   map = world.mapName
   mapTitle = world.mapTitle
   ruleset = world.ruleset
   mutators = world.mutators
   gameTimeElapsed = world.gameTime
   gameTimeLimit = world.gameTimeLimit
   timeLimit = world.timeLimit
   -- timeLimitRound = world.timeLimitRound
   timerActive = world.timerActive

   fullscreenOn = consoleGetVariable('r_fullscreen') ~= 0
   borderlessOn = (consoleGetVariable('r_windowed_fullscreen') or 0) ~= 0
   if fullscreenOn or borderlessOn then
      local r_resolution_fullscreen = consoleGetVariable('r_resolution_fullscreen')
      resolutionWidth = r_resolution_fullscreen[1]
      resolutionHeight = r_resolution_fullscreen[2]
   else
      local r_resolution_windowed = consoleGetVariable('r_resolution_windowed')
      resolutionWidth = r_resolution_windowed[1]
      resolutionHeight = r_resolution_windowed[2]
   end
   viewportWidth = viewport.width
   viewportHeight = viewport.height

   viewportScale = 1
   -- if viewportScale == nil then
   --    viewportScale = (640 <= resolutionHeight and resolutionHeight <= 2160) and 1 or viewportHeight / resolutionHeight
   --    consolePrint(strf('s = v / r = %f / %d = %f',
   --       viewportHeight,
   --       resolutionHeight,
   --       viewportScale
   --    ))
   -- end

   -- FIXME: Track changes to cvars and change only when it changes. We only do this once for now.
   local newColorFriendHEX = consoleGetVariable('cl_color_friend')
   if newColorFriendHEX ~= colorFriendHEX then
      colorFriendHEX = newColorFriendHEX
      colorFriend = ColorHEX(colorFriendHEX)
   end

   local newColorEnemyHEX = consoleGetVariable('cl_color_enemy')
   if newColorEnemyHEX ~= colorEnemyHEX then
      colorEnemyHEX = newColorEnemyHEX
      colorEnemy = ColorHEX(colorEnemyHEX)
   end

   -- FIXME: Get all the requisite povPlayer/localPlayer fields here and pass on to widgets
   --[[
   -- world variables
   local gameModes = gamemodes
   local world = world

   local worldGameState = world.gameState
   local worldMapName = world.mapName
   local worldMapTitle = world.mapTitle
   local worldRuleset = world.ruleset

   local worldGameTimeElapsed = world.gameTime
   local worldGameTimeLimit = world.gameTimeLimit
   local worldTimeLimit = world.timeLimit
   local worldTimeLimitRound = world.timeLimitRound

   local worldGameModeIndex = world.gameModeIndex
   local worldGameMode = gameModes[worldGameModeIndex]
   local worldGameModeHasTeams = worldGameMode.hasTeams
   local worldGameModeShortName = worldGameMode.shortName

   -- player variables
   local players = players

   local playerIndex = playerIndexCameraAttachedTo
   local player = players[playerIndex]

   local playerIndex = player.index
   local playerName = player.name

   local playerConnected = player.connected
   local playerState = player.state
   local playerHidden = player.infoHidden
   local playerReady = player.ready

   local playerTeam = player.team
   local playerScore = player.score

   local playerLatency = player.latency
   local playerPacketloss = player.packetLoss

   local playerHealth = player.health
   local playerArmor = player.armor
   local playerArmorType = player.armorProtection
   local playerDamageLimit = damageToKill(playerHealth, playerArmor, playerArmorType)

   local playerIsDead = player.isDead
   local playerSpeed = player.speed

   local playerButtons = player.buttons
   local playerButtonsAttack = playerButtons.attack
   local playerButtonsJump = playerButtons.jump

   local playerWeapons = player.weapons

   local playerWeaponIndexA = player.weaponIndexSelected
   local playerWeaponIndexB = player.weaponIndexweaponChangingTo

   local playerWeaponA = playerWeapons[playerWeaponIndexB]
   local playerWeaponDefinitionA =  weaponDefinitions[playerWeaponIndexA]

   local playerWeaponB = playerWeapons[playerWeaponIndexB]
   local playerWeaponDefinitionB = weaponDefinitions[playerWeaponIndexB]

   local playerAmmo = playerWeaponB.ammo
   local playerReloadTime = playerWeaponDefinitionB.reloadTime
   local playerAmmoIsLow = playerWeaponDefinitionB.lowAmmoWarning
   local playerAmmoIsMid = playerAmmoIsLow + ceil(1000 / playerReloadTime)

   local localPlayerIndex = playerIndexLocalPlayer
   local playerIsLocal = playerIndex == localPlayerIndex
   local localPlayer = players[localPlayerIndex]
   ]]

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
               consolePrint('Reset: ' .. widgetName)
               widget:initialize(true)
            end
         end
         playSound('CatoHUD/toasty')
      elseif tonumber(resetWidgets) ~= 0 then
         local widgetsCatoStr = 'CatoHUD'
         for _, widget in ipairs(CatoWidgets) do widgetsCatoStr = strf('%s %s', widgetsCatoStr, widget.name) end
         widgetSetConsoleVariable('reset_widgets', widgetsCatoStr)
      end
   end

   local replayActive, menuReplay = replayActive, replayName == 'menu'
   local gameWarmup, gameOver = gameState == GAME_STATE_WARMUP, gameState == GAME_STATE_GAMEOVER
   states[state.hudOff] = consoleGetVariable('cl_show_hud') == 0
   states[state.mainMenu] = replayActive and menuReplay
   states[state.menu] = loading.loadScreenVisible or isInMenu()
   states[state.race] = gameMode == 'race' or gameMode == 'training'
   states[state.replay] = replayActive and not menuReplay
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

   for _, widget in ipairs(CatoWidgets) do
      local userData = widget.userData
      if userData == nil then goto drawNext end

      widget.anchor = widget.anchor or getProps(widgets, widget.name).anchor
      widget.offset = widget.offset or getProps(widgets, widget.name).offset

      local anchorWidget = userData.anchorWidget
      -- consoleVarPrint(strf('%s.userData', widget.name), userData)
      if anchorWidget ~= nil then
         -- anchorWidget = CatoWidgets[anchorWidget] -- FIXME: These are not indexed by name
         anchorWidget = _G[anchorWidget]
         if anchorWidget ~= nil and anchorWidget.offset ~= nil then
            -- consolePrint(strf('%s.anchorWidget is %s', widget.name, anchorWidget.name))
            widget.x = anchorWidget.x + anchorWidget.offset.x
            widget.y = anchorWidget.y + anchorWidget.offset.y
         end
      end

      if not previewMode then
         local hideWhen = widget.hideWhen
         -- FIXME: Debug
         if hideWhen == nil then
            consoleVarPrint('states', states)
            consoleVarPrint(widget.name .. '.hideWhen', hideWhen)
         end
         for stateIndex, stateActive in ipairs(states) do
            if stateActive and hideWhen[stateIndex] then
               if widget.drawInitialized then
                  widget.drawInitialized = false
                  widget.draw = function() end
               end
               goto drawNext
            end
         end
      end

      if not widget.drawInitialized then
         widget.drawInitialized = true
         widget.draw = function() widget:drawWidget(userData) end
      end

      ::drawNext::
   end

   if widgetGetConsoleVariable('widget_cache') ~= 0 then
      widgetSetConsoleVariable('widget_cache', 0)
      for _, debugLine in ipairs(debugIndexCache(widgets)) do
         consolePrint(debugLine)
      end
   end

   if map ~= previousMap then
      warmupTimeElapsed = 0
      previousMap = map
   elseif gameState == GAME_STATE_WARMUP then
      warmupTimeElapsed = warmupTimeElapsed + deltaTime * MS_IN_S
   elseif widgetGetConsoleVariable('warmuptimer_reset') ~= 0 then
      widgetSetConsoleVariable('warmuptimer_reset', 0)
      warmupTimeElapsed = 0
   else
      warmupTimeElapsed = 0
   end
end

-- function CatoHUD:final()
--    userData.finalEpochTime = epochTime
--    saveUserData(userData)
-- end

RegisterCato('CatoHUD', CatoHUD)

------------------------------------------------------------------------------------------------------------------------

Cato_HealthNumber = {}
defaultProperties['Cato_HealthNumber'] = {visible = true, offset = '-40 30', anchor = '0 1', zIndex = '0', scale = '1'}
defaultUserData['Cato_HealthNumber'] = {
   anchorWidget = '',
   -- show = 'dead',
   hideWhen = 'mainMenu menu hudOff gameOver freecam editor',
   text = {font = fontFace, color = Color(191, 191, 191), size = fontSizeHealthAndArmor, anchor = {x = 1}},
}

function Cato_HealthNumber:drawWidget(userData)
   if not povPlayer or povPlayer.state == PLAYER_STATE_SPECTATOR then return end

   local opts = copyOpts(userData.text)

   local playerHealth = 'N/A'
   if not povPlayer.infoHidden then
      playerHealth = povPlayer.health

      -- TODO: Colors for single burst/plasma shot death, maybe some self-damage related?
      local damage = damageToKill(playerHealth, povPlayer.armor, povPlayer.armorProtection)
      if damage <= 80 then
         opts.color = Color(255, 0, 0)
      elseif damage <= 90 then
         opts.color = Color(255, 127, 0)
      elseif damage <= 100 then
         opts.color = Color(255, 255, 0)
      else
         opts.color = Color(255, 255, 255)
      end
   end

   local health = createTextElem(self, playerHealth, opts)
   health.draw(0, 0)
end

RegisterCato('Cato_HealthNumber', Cato_HealthNumber)

------------------------------------------------------------------------------------------------------------------------

Cato_ArmorNumber = {}
defaultProperties['Cato_ArmorNumber'] = {visible = true, offset = '40 30', anchor = '0 1', zIndex = '0', scale = '1'}
defaultUserData['Cato_ArmorNumber'] = {
   anchorWidget = '',
   -- show = 'dead',
   hideWhen = 'mainMenu menu hudOff gameOver freecam editor',
   text = {font = fontFace, color = Color(191, 191, 191), size = fontSizeHealthAndArmor, anchor = {x = -1}},
}

function Cato_ArmorNumber:drawWidget(userData)
   if not povPlayer or povPlayer.state == PLAYER_STATE_SPECTATOR then return end

   local opts = copyOpts(userData.text)

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

RegisterCato('Cato_ArmorNumber', Cato_ArmorNumber)

------------------------------------------------------------------------------------------------------------------------

Cato_ArmorIcon = {}
defaultProperties['Cato_ArmorIcon'] = {visible = true, offset = '0 -20', anchor = '0 1', zIndex = '0', scale = '1'}
defaultUserData['Cato_ArmorIcon'] = {
   anchorWidget = '',
   -- show = 'dead',
   hideWhen = 'mainMenu menu hudOff gameOver freecam editor',
   icon = {color = Color(191, 191, 191), size = 24},
}

function Cato_ArmorIcon:drawWidget(userData)
   if not povPlayer or povPlayer.state == PLAYER_STATE_SPECTATOR then return end

   local opts = copyOpts(userData.icon)

   if not povPlayer.infoHidden then
      opts.color = CatoHUD.userData['armorColor'][povPlayer.armorProtection + 1]
   end

   local armor = createSvgElem(self, 'internal/ui/icons/armor', opts)
   armor.draw(0, 0)
end

RegisterCato('Cato_ArmorIcon', Cato_ArmorIcon)

------------------------------------------------------------------------------------------------------------------------

Cato_FPS = {}
defaultProperties['Cato_FPS'] = {visible = true, offset = '-3 -5', anchor = '1 -1', zIndex = '-999', scale = '1'}
defaultUserData['Cato_FPS'] = {
   anchorWidget = '',
   -- show = 'dead editor freecam gameOver mainMenu menu race',
   hideWhen = 'hudOff',
   text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall},
}
defaultCvars['Cato_FPS'] = {
   {'debug', 'int', 0, 0},
   {'frequency', 'float', 1.0},
   {'precision', 'int', 1},
   {'samples', 'int', 1000},
}

-- local function preAllocateDeltas(deltas, sampleCount)
local function preAllocateDeltas(sampleCount)
   local deltas = {}
   for deltaIndex = 1, sampleCount, 1 do
      deltas[deltaIndex] = 0.0
   end
   return deltas
end

local lastSampleCount = nil
local deltas = {}
local deltaIndex = 1
local sampleSum = 0.0
local measurementTimer = 0.0
local avgFPS = 0.0
local sampleAllocationDone = false
function Cato_FPS:drawWidget(userData)
   local opts = copyOpts(userData.text)

   local sampleCount = widgetGetConsoleVariable('samples')
   if sampleCount ~= lastSampleCount then
      consolePrint(strf(
         '%s: Sample size %d -> %d. Discarding old samples.',
         self.name,
         lastSampleCount or 0,
         sampleCount
      ))
      deltas = preAllocateDeltas(sampleCount)
      deltaIndex = 1
      sampleSum = 0.0
      measurementTimer = 0.0
      avgFPS = 0.0
      sampleAllocationDone = false
      opts.color = Color(191, 191, 191)
   end
   lastSampleCount = sampleCount

   local updateFrequency = widgetGetConsoleVariable('frequency')

   -- deltas is a rolling window buffer for deltaTimes
   -- sampleSum is the sum of last deltas
   -- When the buffer is full the previous delta has to be subtracted from sampleSum before adding the new one

   -- NOTE: We pre-allocate deltas, because otherwise we have to check deltas[deltaIndex] for nil each frame
   --       Note however that pre-allocation means that #deltas == sampleCount, so we MUST use deltaIndex as a way to
   --       count total sample when the buffer is not full.
   --       Using deltaIndex is probably more efficient (since it won't be used when sampleAllocationDone), but
   --       #deltas would give a clearer intention and be more readable.
   -- sampleSum = sampleSum - (deltas[deltaIndex] or 0.0)
   sampleSum = sampleSum - deltas[deltaIndex]
   deltas[deltaIndex] = deltaTimeRaw
   sampleSum = sampleSum + deltaTimeRaw
   deltaIndex = deltaIndex < sampleCount and deltaIndex + 1 or 1

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
   end

   local precision = widgetGetConsoleVariable('precision')
   local fpsFormat = precision < 0 and '' or ('.' .. precision)
   local fps = createTextElem(
      self,
      strf('%' .. fpsFormat .. 'ffps', avgFPS),
      userData.text
   )
   fps.draw(0, 0)
end

RegisterCato('Cato_FPS', Cato_FPS)

------------------------------------------------------------------------------------------------------------------------

Cato_DisplayMode = {}
defaultProperties['Cato_DisplayMode'] = {visible = true, offset = '-100 0', anchor = '1 -1', zIndex = '-999', scale = '1'}
defaultUserData['Cato_DisplayMode'] = {
   anchorWidget = 'Cato_FPS',
   -- show = 'dead freecam gameOver race mainMenu menu',
   hideWhen = 'hudOff gameActive',
   text = {
      fullscreen = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall},
      borderless = {font = fontFace, color = Color(255, 127, 127), size = fontSizeSmall},
      windowed = {font = fontFace, color = Color(255, 63, 63), size = fontSizeSmall},
   },
}

function Cato_DisplayMode:drawWidget(userData)
   if not inReplay and localPov and gameState ~= GAME_STATE_WARMUP then return end

   if not localPov and not ((replayActive and replayName == 'menu') or (loading.loadScreenVisible or isInMenu())) then
      return
   end

   local modeDisplay = nil
   local modeFormat = nil
   local opts = nil
   if fullscreenOn then
      modeDisplay = 'Fullscreen'
      modeFormat = '%s%s %dx%d @ %dhz'
      opts = userData.text.fullscreen
   elseif borderlessOn then
      modeDisplay = 'Borderless'
      modeFormat = '%s%s (Native)'
      opts = userData.text.borderless
   else
      modeDisplay = 'Windowed'
      modeFormat = '%s%s %dx%d @ %dhz'
      opts = userData.text.windowed
   end

   local monitorIndex = consoleGetVariable('r_monitor') or -1
   if monitorIndex < 0 then monitorIndex = ''
   else monitorIndex = ' #' .. monitorIndex end

   local refreshRate = consoleGetVariable('r_refreshrate')

   local mode = createTextElem(
      self,
      strf(modeFormat, modeDisplay, monitorIndex, resolutionWidth, resolutionHeight, refreshRate),
      opts
   )
   mode.draw(0, 0)
end

RegisterCato('Cato_DisplayMode', Cato_DisplayMode)

------------------------------------------------------------------------------------------------------------------------

Cato_Time = {}
defaultProperties['Cato_Time'] = {visible = true, offset = '-3 18', anchor = '1 -1', zIndex = '-999', scale = '1'}
defaultUserData['Cato_Time'] = {
   anchorWidget = '',
   -- show = 'dead editor freecam gameOver mainMenu menu race',
   hideWhen = 'hudOff',
   text = {
      delimiter = {font = fontFace, color = Color(127, 127, 127), size = fontSizeSmall, anchor = {x = 0}},
      -- year = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall, anchor = {x = -1}},
      -- month = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall, anchor = {x = -1}},
      -- day = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall, anchor = {x = -1}},
      hour = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall, anchor = {x = 1}},
      minute = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall, anchor = {x = -1}},
      -- second = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall, anchor = {x = -1}},
   },
}

function Cato_Time:drawWidget(userData)
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
   --       delimiter = copyOpts(userData.text.delimiter),
   --       year = copyOpts(userData.text.year),
   --       month = copyOpts(userData.text.month),
   --       day = copyOpts(userData.text.day),
   --       hour = copyOpts(userData.text.hour),
   --       minute = copyOpts(userData.text.minute),
   --       second = copyOpts(userData.text.second),
   --    }

   --    local time = formatEpochTime(epochTime, CatoHUD.userData.offsetUTC)

   --    local day = createTextElem(self, formatDay(time.day), opts.day)
   --    local delimiterDate1 = createTextElem(self, ' ', opts.delimiter)
   --    local month = createTextElem(self, formatMonth(time.month), opts.month)

   --    local delimiterDate2 = createTextElem(self, ' ', opts.delimiter)
   --    local year = createTextElem(self, time.year, opts.year)

   --    local delimiter = createTextElem(self, ' ', opts.delimiter)

   --    local hour = createTextElem(self, strf('%02d', time.hour), opts.hour)
   --    local delimiterTime1 = createTextElem(self, ':', opts.delimiter)
   --    local minute = createTextElem(self, strf('%02d', time.minute), opts.minute)

   --    local delimiterTime2 = createTextElem(self, ':', opts.delimiter)
   --    local second = createTextElem(self, strf('%02d', time.second), opts.second)

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


   local epochSeconds = nil
   if CatoHUD.userData.useLocalTime and epochTimeLocal ~= nil then epochSeconds = epochTimeLocal
   else epochSeconds = epochTime + CatoHUD.userData.offsetUTC end

   -- TODO: Figure out if time should be displayed during replay playback.
   --       It's a bit misleading since it displays current localtime, and replays don't seem to
   --       contain information regarding the actual IRL time they were played during.
   -- if inReplay then
   --    consolePrint('---')
   --    consoleTablePrint(replay)
   --    consolePrint(epochSeconds)
   --    consolePrint(replay.timecodeCurrent)
   -- end

   local hour = createTextElem(self, strf('%02d', floor(epochSeconds / S_IN_H) % H_IN_D), userData.text.hour)
   local delimiter = createTextElem(self, ':', userData.text.delimiter)
   local minute = createTextElem(self, strf('%02d', floor(epochSeconds / S_IN_M) % M_IN_H), userData.text.minute)

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

RegisterCato('Cato_Time', Cato_Time)

------------------------------------------------------------------------------------------------------------------------

Cato_MMStats = {}
defaultProperties['Cato_MMStats'] = {visible = true, offset = '0 23', anchor = '1 -1', zIndex = '-999', scale = '1'}
defaultUserData['Cato_MMStats'] = {
   anchorWidget = 'Cato_MapName',
   -- show = 'dead freecam gameOver mainMenu menu race',
   hideWhen = 'hudOff',
   text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall},
}

function Cato_MMStats:drawWidget(userData)
   if not inReplay and localPov and gameState ~= GAME_STATE_WARMUP then return end

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
      mmState = strf('Match found (%sready)', ready or 'not')
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
         goto mmPlaylistFound
      end
   end
   ::mmPlaylistFound::
   -- consoleVarPrint(mmPlaylistKey, mmPlaylist)

   local mmLobby = world.isMatchmakingLobby

   local mmr = mmPlaylist.mmr or 0
   local mmrBest = mmPlaylist.mmrBest or 0
   local mmrNew = 0
   local mmrDiff = ''
   if mmLobby and povPlayer then
      mmr = povPlayer.mmr
      mmrNew = povPlayer.mmrNew
      mmrBest = povPlayer.mmrBest
      mmrDiff = mmrNew - mmr
      mmrDiff = mmrDiff ~= 0 and (mmrDiff > 0 and ' [+' .. mmrDiff .. ']' or ' [' .. mmrDiff .. ']') or ''
   end

   local mmStats = createTextElem(self, strf(
      '%s [MMR: %s%s Best: %s]',
      mmState,
      mmr,
      mmrDiff,
      mmrBest
   ), userData.text)
   mmStats.draw(0, 0)
end

RegisterCato('Cato_MMStats', Cato_MMStats)

------------------------------------------------------------------------------------------------------------------------

Cato_Scores = {}
defaultProperties['Cato_Scores'] = {visible = true, offset = '0 23', anchor = '1 -1', zIndex = '0', scale = '1'}
defaultUserData['Cato_Scores'] = {
   anchorWidget = 'Cato_Time',
   -- show = 'dead freecam gameOver race',
   hideWhen = 'mainMenu menu hudOff editor',
   text = {
      delimiter = {font = fontFace, color = Color(127, 127, 127), size = fontSizeMedium, anchor = {x = 0}},
      team = {font = fontFace, color = Color(255, 255, 255), size = fontSizeMedium, anchor = {x = 1}},
      enemy = {font = fontFace, color = Color(0, 255, 0), size = fontSizeMedium, anchor = {x = -1}},
   },
}

function Cato_Scores:drawWidget(userData)
   local opts = {
      team = copyOpts(userData.text.team),
      enemy = copyOpts(userData.text.enemy),
      delimiter = copyOpts(userData.text.delimiter),
   }
   opts.team.color = colorFriend
   opts.enemy.color = colorEnemy

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

RegisterCato('Cato_Scores', Cato_Scores)

------------------------------------------------------------------------------------------------------------------------

Cato_RulesetName = {}
defaultProperties['Cato_RulesetName'] = {visible = true, offset = '0 27', anchor = '1 -1', zIndex = '0', scale = '1'}
defaultUserData['Cato_RulesetName'] = {
   anchorWidget = 'Cato_Scores',
   -- show = 'dead freecam gameOver race',
   hideWhen = 'mainMenu menu hudOff editor',
   text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall},
}

function Cato_RulesetName:drawWidget(userData)
   -- if not inReplay and localPov and gameState ~= GAME_STATE_WARMUP then return end

   local rulesetName = createTextElem(self, ruleset, userData.text)
   rulesetName.draw(0, 0)
end

RegisterCato('Cato_RulesetName', Cato_RulesetName)

------------------------------------------------------------------------------------------------------------------------

Cato_GameModeName = {}
defaultProperties['Cato_GameModeName'] = {visible = true, offset = '0 23', anchor = '1 -1', zIndex = '0', scale = '1'}
defaultUserData['Cato_GameModeName'] = {
   anchorWidget = 'Cato_RulesetName',
   -- show = 'dead freecam gameOver race',
   hideWhen = 'mainMenu menu hudOff editor gameActive',
   text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall},
}

function Cato_GameModeName:drawWidget(userData)
   if not inReplay and localPov and gameState ~= GAME_STATE_WARMUP then return end

   local gameModeName = createTextElem(self, strf('%s', gameMode), userData.text)
   -- local gameModeName = createTextElem(self, strf('training', gameMode), userData.text)
   gameModeName.draw(0, 0)
end

RegisterCato('Cato_GameModeName', Cato_GameModeName)

------------------------------------------------------------------------------------------------------------------------

Cato_Timelimit = {}
defaultProperties['Cato_Timelimit'] = {visible = true, offset = '-75 0', anchor = '1 -1', zIndex = '0', scale = '1'}
defaultUserData['Cato_Timelimit'] = {
   anchorWidget = 'Cato_GameModeName',
   -- show = 'dead freecam gameOver race',
   hideWhen = 'mainMenu menu hudOff editor gameActive',
   text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall},
}

function Cato_Timelimit:drawWidget(userData)
   if not inReplay and localPov and gameState ~= GAME_STATE_WARMUP then return end

   local tl = formatTimeMs(timeLimit * 1000)
   local gameModeName = createTextElem(self, strf('%d:%02d', tl.minutes, tl.seconds), userData.text)
   gameModeName.draw(0, 0)
end

RegisterCato('Cato_Timelimit', Cato_Timelimit)

------------------------------------------------------------------------------------------------------------------------

Cato_MapName = {}
defaultProperties['Cato_MapName'] = {visible = true, offset = '0 23', anchor = '1 -1', zIndex = '0', scale = '1'}
defaultUserData['Cato_MapName'] = {
   anchorWidget = 'Cato_GameModeName',
   -- show = 'dead freecam gameOver race',
   hideWhen = 'mainMenu menu hudOff editor gameActive',
   text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall},
}

function Cato_MapName:drawWidget(userData)
   if not inReplay and localPov and gameState ~= GAME_STATE_WARMUP then return end

   local mapName = createTextElem(self, mapTitle, userData.text)
   mapName.draw(0, 0)
end

RegisterCato('Cato_MapName', Cato_MapName)

------------------------------------------------------------------------------------------------------------------------

Cato_Mutators = {}
defaultProperties['Cato_Mutators'] = {visible = true, offset = '0 33', anchor = '1 -1', zIndex = '0', scale = '1'}
defaultUserData['Cato_Mutators'] = {
   anchorWidget = 'Cato_MapName',
   -- show = 'dead freecam gameOver race',
   hideWhen = 'mainMenu menu hudOff editor',
   icon = {size = 12},
}

function Cato_Mutators:drawWidget(userData)
   if not inReplay and localPov and gameState ~= GAME_STATE_WARMUP then return end

   local x = -userData.icon.size * 2
   local spacing = userData.icon.size / 2

   local gameMutators = {}
   -- TODO: Should this be ipairs and then use "gameMutators[i]" over "tbli(gameMutators, mutator)"?
   for mutator in gmatch(mutators, '%S+') do
      mutator = mutatorDefinitions[toupper(mutator)]

      mutator = createSvgElem(self, mutator.icon, {color = mutator.col, size = userData.icon.size})
      x = x + mutator.width + spacing

      tbli(gameMutators, mutator)
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

   -- local opts = copyOpts(userData.text)

   -- local gameMutators = createTextElem(self, mutators, opts)
   -- gameMutators.draw(0, 0)
end

RegisterCato('Cato_Mutators', Cato_Mutators)

------------------------------------------------------------------------------------------------------------------------

Cato_LowAmmo = {}
defaultProperties['Cato_LowAmmo'] = {visible = true, offset = '0 160', anchor = '0 0', zIndex = '0', scale = '1'}
defaultUserData['Cato_LowAmmo'] = {
   anchorWidget = '',
   -- show = 'race',
   hideWhen = 'mainMenu menu dead hudOff gameWarmup gameOver freecam editor',
   text = {
      click = {label = '*CLICK*', font = fontFace, color = Color(255, 255, 255), size = fontSizeHuge},
      empty = {label = 'NO AMMO', font = fontFace, color = Color(255, 0, 0), size = fontSizeBig},
      halfLow = {label = nil, font = fontFace, color = Color(255, 0, 0), size = fontSizeHuge},
      low = {label = nil, font = fontFace, color = Color(255, 0, 0), size = fontSizeBig},
      halfMed = {label = nil, font = fontFace, color = Color(255, 127, 0), size = fontSizeMedium},
      med = {label = nil, font = fontFace, color = Color(255, 255, 0), size = fontSizeMedium},
      full = {label = 'FULL AMMO', font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall},
   },
}

local clickDelay = 0.0
function Cato_LowAmmo:drawWidget(userData)
   if clickDelay > 0.0 then clickDelay = clickDelay - deltaTime end

   if previewMode then
      local textPreview = createTextElem(self, '(Low Ammo)', userData.text.low)
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

   local ammoLow = weaponDefinition.lowAmmoWarning
   local ammoMed = ammoLow + ceil(1000 / weaponDefinition.reloadTime)
   local ammoMax = weaponDefinition.maxAmmo
   local ammo = povPlayer.weapons[weaponIndex].ammo

   local buttonAttack = povPlayer.buttons.attack

   local opts = nil
   if ammo <= 0 then
      if clickDelay > 0.0 then
         opts = userData.text.click
      else
         if buttonAttack then
            clickDelay = 0.150
            opts = userData.text.click
         else
            opts = userData.text.empty
         end
      end
   elseif ammo <= ammoLow / 2 then
      opts = userData.text.halfLow
   elseif ammo <= ammoLow then
      opts = userData.text.low
   elseif ammo <= ammoLow + (ammoMed - ammoLow) / 2 then
      opts = userData.text.halfMed
   elseif ammo <= ammoMed then
      opts = userData.text.med
   elseif ammo >= ammoMax then
      opts = userData.text.full
   else
      return
   end

   local ammoWarning = createTextElem(self, opts.label or ammo, opts)
   ammoWarning.draw(0, 0)
end

RegisterCato('Cato_LowAmmo', Cato_LowAmmo)

------------------------------------------------------------------------------------------------------------------------

Cato_Ping = {}
defaultProperties['Cato_Ping'] = {visible = true, offset = '-3 4', anchor = '1 1', zIndex = '0', scale = '1'}
defaultUserData['Cato_Ping'] = {
   anchorWidget = '',
   -- show = 'dead freecam gameOver race',
   hideWhen = 'mainMenu hudOff editor',
   text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall},
}

function Cato_Ping:drawWidget(userData)
   if not povPlayer or povPlayer.state == PLAYER_STATE_SPECTATOR then return end

   local opts = copyOpts(userData.text)

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

RegisterCato('Cato_Ping', Cato_Ping)

------------------------------------------------------------------------------------------------------------------------

Cato_PacketLoss = {}
defaultProperties['Cato_PacketLoss'] = {visible = true, offset = '-3 -16', anchor = '1 1', zIndex = '0', scale = '1'}
defaultUserData['Cato_PacketLoss'] = {
   anchorWidget = '',
   -- show = 'dead freecam gameOver race',
   hideWhen = 'mainMenu hudOff editor',
   text = {font = fontFace, color = Color(255, 0, 0), size = fontSizeSmall},
}

function Cato_PacketLoss:drawWidget(userData)
   if not povPlayer or povPlayer.state == PLAYER_STATE_SPECTATOR then return end

   local opts = copyOpts(userData.text)

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

RegisterCato('Cato_PacketLoss', Cato_PacketLoss)

------------------------------------------------------------------------------------------------------------------------

Cato_GameTime = {}
defaultProperties['Cato_GameTime'] = {visible = true, offset = '0 -135', anchor = '0 1', zIndex = '0', scale = '1'}
defaultUserData['Cato_GameTime'] = {
   anchorWidget = '',
   -- show = 'dead',
   hideWhen = 'mainMenu menu hudOff gameOver freecam editor',
   countDown = false,
   hideSeconds = false,
   text = {
      delimiter = {font = fontFace, color = Color(127, 127, 127), size = fontSizeTimer, anchor = {x = 0}},
      minutes = {font = fontFace, color = Color(255, 255, 255), size = fontSizeTimer, anchor = {x = 1}},
      seconds = {font = fontFace, color = Color(255, 255, 255), size = fontSizeTimer, anchor = {x = -1}},
   },
}

function Cato_GameTime:drawWidget(userData)
   local hideSeconds = userData.hideSeconds

   local timeElapsed = 0
   if gameState == GAME_STATE_WARMUP then
      timeElapsed = warmupTimeElapsed
   elseif gameState == GAME_STATE_ACTIVE or gameState == GAME_STATE_ROUNDACTIVE then
      timeElapsed = gameTimeElapsed
      hideSeconds = (hideSeconds and gameTimeLimit - gameTimeElapsed > 30000)
   end

   local timer = formatTimeMs(timeElapsed, gameTimeLimit, userData.countDown)

   local minutes = createTextElem(self, timer.minutes, userData.text.minutes)
   local delimiter = createTextElem(self, ':', userData.text.delimiter)
   local seconds = hideSeconds and 'xx' or strf('%02d', timer.seconds)
   seconds = createTextElem(self, seconds, userData.text.seconds)

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

RegisterCato('Cato_GameTime', Cato_GameTime)

------------------------------------------------------------------------------------------------------------------------

local delayCountDown = true
local delayRespawnMin = 1.0
local delayRespawnMax = 4.0

Cato_RespawnDelay = {}
defaultProperties['Cato_RespawnDelay'] = {visible = true, offset = '80 -90', anchor = '0 1', zIndex = '0', scale = '1'}
defaultUserData['Cato_RespawnDelay'] = {
   anchorWidget = 'Cato_GameTime',
   -- show = 'dead race',
   hideWhen = 'mainMenu menu hudOff gameOver freecam editor',
   text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeMedium},
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
   delay = createTextElem(self, delay, opts)
   delay.draw(0, 0)
end

RegisterCato('Cato_RespawnDelay', Cato_RespawnDelay)

------------------------------------------------------------------------------------------------------------------------

Cato_FollowingPlayer = {}
defaultProperties['Cato_FollowingPlayer'] = {visible = true, offset = '0 0', anchor = '0 -1', zIndex = '0', scale = '1'}
defaultUserData['Cato_FollowingPlayer'] = {
   anchorWidget = '',
   -- show = 'dead race',
   hideWhen = 'mainMenu menu hudOff freecam editor',
   text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeBig, anchor = {x = 0}},
}

function Cato_FollowingPlayer:drawWidget(userData)
   if not povPlayer then return end

   -- TODO: option for display on self
   if not previewMode and not inReplay and localPov then return end

   local label = createTextElem(self, 'FOLLOWING', userData.text)
   local name = createTextElem(self, povPlayer.name, userData.text)

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

RegisterCato('Cato_FollowingPlayer', Cato_FollowingPlayer)

------------------------------------------------------------------------------------------------------------------------

Cato_ReadyStatus = {}
defaultProperties['Cato_ReadyStatus'] = {visible = true, offset = '0 145', anchor = '0 -1', zIndex = '0', scale = '1'}
defaultUserData['Cato_ReadyStatus'] = {
   anchorWidget = '',
   -- show = 'dead freecam race',
   hideWhen = 'mainMenu hudOff gameOver editor',
   text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall},
}

function Cato_ReadyStatus:drawWidget(userData)
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

   local opts = copyOpts(userData.text)
   if povPlayer and not povPlayer.ready then
      opts.color = Color(191, 191, 191)
   end

   local ready = createTextElem(self, playersReady .. '/' .. playersGame .. ' ready', opts)
   ready.draw(0, 0)
end

RegisterCato('Cato_ReadyStatus', Cato_ReadyStatus)

------------------------------------------------------------------------------------------------------------------------

Cato_GameMessage = {}
defaultProperties['Cato_GameMessage'] = {visible = true, offset = '0 -80', anchor = '0 0', zIndex = '0', scale = '1'}
defaultUserData['Cato_GameMessage'] = {
   anchorWidget = '',
   -- show = 'dead freecam menu race',
   hideWhen = 'mainMenu hudOff gameOver editor',
   text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeMedium},
}

local lastTickSeconds = -1
function Cato_GameMessage:drawWidget(userData)
   local gameMessage = nil
   if timerActive then
      if gameState == GAME_STATE_WARMUP or gameState == GAME_STATE_ROUNDPREPARE then
         local timer = formatTimeMs(gameTimeElapsed, gameTimeLimit, true)
         if lastTickSeconds ~= timer.seconds then
            lastTickSeconds = timer.seconds
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
         -- FIXME: This shit just straight up showing the wrong name
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

   gameMessage = createTextElem(self, gameMessage, userData.text)
   gameMessage.draw(0, 0)
end

RegisterCato('Cato_GameMessage', Cato_GameMessage)

------------------------------------------------------------------------------------------------------------------------

Cato_Speed = {}
defaultProperties['Cato_Speed'] = {visible = false, offset = '0 60', anchor = '0 0', zIndex = '0', scale = '1'}
defaultUserData['Cato_Speed'] = {
   anchorWidget = '',
   -- show = 'race',
   hideWhen = 'mainMenu menu dead hudOff gameOver freecam editor',
   text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall},
}

function Cato_Speed:drawWidget(userData)
   if not povPlayer then return end

   local ups = createTextElem(self, ceil(povPlayer.speed) .. 'ups', userData.text)
   ups.draw(0, 0)
end

RegisterCato('Cato_Speed', Cato_Speed)

------------------------------------------------------------------------------------------------------------------------

Cato_Crosshair = {}
defaultProperties['Cato_Crosshair'] = {visible = true, offset = '0 0', anchor = '0 0', zIndex = '0', scale = '1'}
defaultUserData['Cato_Crosshair'] = {
   anchorWidget = '',
   -- show = 'race',
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
}

function Cato_Crosshair:drawWidget(userData)
   local x = 0
   local y = 0

   local pixelWidth = viewportWidth / resolutionWidth
   local pixelHeight = viewportHeight / resolutionHeight

   local width = userData.crosshairWidth
   local height = userData.crosshairHeight
   local stroke = userData.crosshairStroke
   local thickness = userData.crosshairThickness

   local gapWidth = userData.crosshairGapWidth
   local gapHeight = userData.crosshairGapHeight

   local dotWidth = userData.crosshairDotWidth
   local dotHeight = userData.crosshairDotHeight
   local dotStroke = userData.crosshairDotStroke

   -- TODO: Optimize: we probably don't need a copy every frame + the color can be fetched in the nvgFillColor call
   -- NOTE: In general one may consider fetching all relevant tables at the end of Widget:drawWidget
   local crosshairColor = copyColor(userData.crosshairColor)
   local crosshairStrokeColor = copyColor(userData.crosshairStrokeColor)
   local crosshairDotColor = copyColor(userData.crosshairDotColor)
   local crosshairDotStrokeColor = copyColor(userData.crosshairDotStrokeColor)

   -- fix for odd values of thickness
   if thickness % 2 ~= 0 then
      x = x - 0.5
      y = y - 0.5
   end

   -- draw dot
   if dotWidth > 0 or dotHeight > 0 then
      -- dot stroke
      if dotStroke > 0 then
         nvgBeginPath()
         nvgRect(
            x + pixelWidth * (-dotWidth / 2 - dotStroke),
            y + pixelHeight * (-dotHeight / 2 - dotStroke),
            pixelWidth * (dotWidth + dotStroke * 2),
            pixelHeight * (dotHeight + dotStroke * 2)
         )
         nvgFillColor(crosshairDotStrokeColor)
         nvgFill()
      end

      -- dot
      nvgBeginPath()
      nvgRect(
         x + pixelWidth * -dotWidth / 2,
         y + pixelHeight * -dotHeight / 2,
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
            x + pixelWidth * (-thickness / 2 - stroke),
            y + pixelHeight * (-height / 2 - gapHeight / 2 - stroke),
            pixelWidth * (thickness + stroke * 2),
            pixelHeight * (height / 2 + stroke * 2)
         )
         nvgRect(
            x + pixelWidth * (-thickness / 2 - stroke),
            y + pixelHeight * (gapHeight / 2 - stroke),
            pixelWidth * (thickness + stroke * 2),
            pixelHeight * (height / 2 + stroke * 2)
         )
         nvgRect(
            x + pixelWidth * (-width / 2 - gapWidth / 2 - stroke),
            y + pixelHeight * (-thickness / 2 - stroke),
            pixelWidth * (width / 2 + stroke * 2),
            pixelHeight * (thickness + stroke * 2)
         )
         nvgRect(
            x + pixelWidth * (gapWidth / 2 - stroke),
            y + pixelHeight * (-thickness / 2 - stroke),
            pixelWidth * (width / 2 + stroke * 2),
            pixelHeight * (thickness + stroke * 2)
         )
         nvgFillColor(crosshairStrokeColor)
         nvgFill()
      end

      -- cross
      nvgBeginPath()
      nvgRect(
         x + pixelWidth * -thickness / 2,
         y + pixelHeight * (-height / 2 - gapHeight / 2),
         pixelWidth * thickness,
         pixelHeight * height / 2
      )
      nvgRect(
         x + pixelWidth * -thickness / 2,
         y + pixelHeight * gapHeight / 2,
         pixelWidth * thickness,
         pixelHeight * height / 2
      )
      nvgRect(
         x + pixelWidth * (-width / 2 - gapWidth / 2),
         y + pixelHeight * -thickness / 2,
         pixelWidth * width / 2,
         pixelHeight * thickness
      )
      nvgRect(
         x + pixelWidth * gapWidth / 2,
         y + pixelHeight * -thickness / 2,
         pixelWidth * width / 2,
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
            x + pixelWidth * (-thickness / 2 - stroke),
            y + pixelHeight * (-height / 2 - stroke),
            pixelWidth * (thickness + stroke * 2),
            pixelHeight * (height + stroke * 2)
         )
         nvgRect(
            x + pixelWidth * (-width / 2 - stroke),
            y + pixelHeight * (-thickness / 2 - stroke),
            pixelWidth * (width + stroke * 2),
            pixelHeight * (thickness + stroke * 2)
         )
         nvgFillColor(crosshairStrokeColor)
         nvgFill()
      end

      -- cross
      nvgBeginPath()
      nvgRect(
         x + pixelWidth * -thickness / 2,
         y + pixelHeight * -height / 2,
         pixelWidth * thickness,
         pixelHeight * height
      )
      nvgRect(
         x + pixelWidth * -width / 2,
         y + pixelHeight * -thickness / 2,
         pixelWidth * width,
         pixelHeight * thickness
      )
      nvgFillColor(crosshairColor)
      nvgFill()
   end
end

RegisterCato('Cato_Crosshair', Cato_Crosshair)

------------------------------------------------------------------------------------------------------------------------
