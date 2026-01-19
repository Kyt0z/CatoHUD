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
local sin = math.sin
local sqrt = math.sqrt
local tan = math.tan
local csc = function(x) return 1 / sin(x) end
--

-- string
--
-- local format = string.format
local gmatch = string.gmatch
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
local consolePrint = consolePrint
local isInMenu = isInMenu
local loadUserData = loadUserData
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
local nvgTextBounds = nvgTextBounds
local nvgTextWidth = nvgTextWidth
local playSound = playSound
-- FIXME: registerWidget doesn't make that much sense. We aren't calling it outside of the initial file load.
--        Then again that's why it won't hurt either.
local registerWidget = registerWidget
local saveUserData = saveUserData
local textRegion = textRegion
local textRegionSetCursor = textRegionSetCursor
-- FIXME: I sure hope these aren't re-assigned based on caller. Although they probably are and it makes sense.
local widgetCreateConsoleVariable = widgetCreateConsoleVariable
local widgetGetConsoleVariable = widgetGetConsoleVariable
local widgetSetConsoleVariable = widgetSetConsoleVariable
--

-- Doing this so we can more easily spot CatoHUD output
local prefixCato = '  | '
local _consolePrint = consolePrint
consolePrint = function(str) _consolePrint(str ~= '' and prefixCato .. str or '') end

-- FIXME: Lowkey we should still have these here for now, although reflexcore and gamestrings are basically always
--        loaded before any widgets.
--        Long term we should get rid of them and simply yoink any useful constants and functions.

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
local LOG_TYPE_DEATHMESSAGE = LOG_TYPE_DEATHMESSAGE
local PLAYER_STATE_EDITOR = PLAYER_STATE_EDITOR
local PLAYER_STATE_INGAME = PLAYER_STATE_INGAME
local PLAYER_STATE_SPECTATOR = PLAYER_STATE_SPECTATOR
local WIDGET_PROPERTIES_COL_WIDTH = WIDGET_PROPERTIES_COL_WIDTH
--

-- gamestrings.lua
require 'base/internal/ui/gamestrings'
--
local mutatorDefinitions = mutatorDefinitions
--

-- ConsoleVarPrint.lua
-- (For debugging. See <github link> <workshop link>)
require 'ConsoleVarPrint'
--
local ConsoleVarPrint = ConsoleVarPrint
--

-- FIXME: Currently requiring this for debug messages, because the ConsoleVarPrint code might change a bit in the near
--        future. But once it gets settled/before release just copy the function here. Doesn't hurt to still see if
--        ConsoleVarPrint global is present (maybe, it might be an older version).
-- FIXME: Why are we doing this again? We're not gonna be printing all the time on each frame right. RIGHT?
-- FIXME: We need the arg names for now
-- local function consoleVarPrint(...)
local function consoleVarPrint(varName, var, prefix, showTypes, depth)
   if type(ConsoleVarPrint) ~= 'function' then return end
   ConsoleVarPrint(varName, var, prefix or prefixCato, showTypes, depth)
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
local function getProps(widgetName)
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

-- (:.*?:)|\^[0-9a-zA-Z]
-- :arenafp: :reflexpicardia::skull:^w' .. player.name .. ' :rocket::boom:^7:beatoff:
-- local function nvgEmojiText(props, pos, text, opts)
--
-- end

------------------------------------------------------------------------------------------------------------------------
-- Settings
------------------------------------------------------------------------------------------------------------------------

local fontFace = 'TitilliumWeb-Bold'
local fontSizeTiny = 24
local fontSizeSmall = 32
local fontSizeMedium = 40
local fontSizeBig = 64
local fontSizeTimer = 120
local fontSizeHuge = 160
local cl_color_friend = ColorHEX(consoleGetVariable('cl_color_friend'))
local cl_color_enemy = ColorHEX(consoleGetVariable('cl_color_enemy'))

-- FIXME: Get rid of this
local function defaultShow(showStr)
   local showTable = {}
   for showVar in gmatch(showStr, '%w+') do
      showTable[showVar] = true
   end
   return showTable
end

-- TODO: This
-- local CW_SHOW_MAINMENU = 1 -- replayActive and replayName == 'menu' -> false
-- local CW_SHOW_MENU = 2 -- loading.loadScreenVisible or isInMenu() -> false
-- local CW_SHOW_DEAD = 4 -- not povPlayer or povPlayer.health <= 0 -> false
-- local CW_SHOW_RACE = 8 -- gameMode == 'race' or gameMode == 'training' -> false
-- local CW_SHOW_HUDOFF = 16 -- consoleGetVariable('cl_show_hud') == 0 -> false
-- local CW_SHOW_GAMEOVER = 32 -- gameState == GAME_STATE_GAMEOVER -> false
-- local CW_SHOW_FREECAM = 64 -- localPov and povPlayer and povPlayer.state ~= PLAYER_STATE_INGAME -> false
-- local CW_SHOW_EDITOR = 128 -- povPlayer and povPlayer.state == PLAYER_STATE_EDITOR -> false

-- local CW_HIDE_NOPLAYER = 1
-- local CW_HIDE_PLAYERHIDDEN = 4
-- local CW_HIDE_PLAYERDEAD = 4

-- local function defaultBits(mode, str)
--    mode = toupper(mode)
--    str = toupper(str)

--    if mode ~= 'SHOW' and mode ~= 'HIDE' then
--       consolePrint('ERROR: Invalid argument \'' .. mode .. '\' passed to defaultBits')
--       return
--    end

--    local flags = 0
--    for flagStr in gmatch(str, '%w+') do
--       flags = flags + (_G['CW_' .. mode .. '_' .. flagStr] or 0)
--    end
--    return flags
-- end

------------------------------------------------------------------------------------------------------------------------
-- CatoHUD
------------------------------------------------------------------------------------------------------------------------

local TEAM_ALPHA = 1
local TEAM_ZETA  = 2

local previewMode = nil

local povPlayer = nil
local localPlayer = nil




-- local playerIndex = nil
-- local playerName = nil

-- local playerConnected = nil
-- local playerState = nil
-- local playerHidden = nil
-- local playerReady = nil

-- local playerLatency = nil
-- local playerPacketloss = nil

-- local playerHealth = nil
-- local playerArmor = nil
-- local playerArmorType = nil
-- local playerDamageResilience = nil
-- local playerIsDead = nil

-- local playerSpeed = nil

-- local playerWeaponIndexSelected = nil
-- local playerWeaponIndexChangingTo = nil
-- local playerWeaponChangingTo = nil
-- local playerAmmo = nil
-- local playerSelectedWeaponDefinition = nil
-- local playerChangingToWeaponDefinition = nil
-- local playerLowAmmo = nil

-- local playerTeam = nil
-- local playerScore = nil

-- local playerButtonsAttack = nil
-- local playerButtonsJump = nil



local localPov = nil

local gameState = nil
local gameMode = nil
local hasTeams = nil
local map = nil
local mapTitle = nil
local ruleset = nil
local gameTimeElapsed = nil
local gameTimeLimit = nil

local timeLimit = nil
local timeLimitRound = nil

local inReplay = nil
local previousMap = nil
local warmupTimeElapsed = 0

local cl_show_hud = nil
local r_fullscreen = nil
local r_windowed_fullscreen = nil
local resolutionHeight = nil
local resolutionWidth = nil
local viewportWidth = nil
local viewportHeight = nil

local defaultUserData = {}
local defaultProperties = {}
local defaultCvars = {}

CatoHUD = {canHide = false, canPosition = false}
defaultUserData['CatoHUD'] = {
   configBackup = nil,
   offsetUTC = 2 * S_IN_H, -- TODO: Add DST behavior, e.g. date when observing starts/end
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
   {'display_mode', 'int', 0, 0},
   {'preview', 'int', 0, 0},
   {'reset_widgets', 'int', 0, 0},
   {'warmuptimer_reset', 'int', 0, 0},
   {'widget_cache', 'int', 0, 0},
}

local function setWidgetUserData(container, varName, defaultVal)
   if type(container[varName]) ~= type(defaultVal) then
      container[varName] = defaultVal
   elseif type(defaultVal) == 'table' then
      for var, val in pairs(defaultVal) do setWidgetUserData(container[varName], var, val) end
   end
end

local function setWidgetProperties(widget, reset)
   if not reset then return end

   local default = defaultProperties[widget.name] or {}
   consolePerformCommand('ui_show_widget ' .. widget.name)
   consolePerformCommand('ui_set_widget_offset ' .. widget.name .. ' ' .. (default.offset or '0 0'))
   consolePerformCommand('ui_set_widget_anchor ' .. widget.name .. ' ' .. (default.anchor or '0 0'))
   consolePerformCommand('ui_set_widget_zIndex ' .. widget.name .. ' ' .. (default.zIndex or '0'))
   consolePerformCommand('ui_set_widget_scale ' .. widget.name .. ' ' .. (default.scale or '1'))
   consolePerformCommand((default.visible ~= false and 'ui_show_widget' or 'ui_hide_widget') .. ' ' .. widget.name)
end

local function setWidgetConsoleVariables(widget, reset)
   for _, cvar in ipairs(defaultCvars[widget.name] or {}) do
      if not reset then
         widgetCreateConsoleVariable(cvar[1], cvar[2], cvar[3])
         if cvar[4] then
            widgetSetConsoleVariable(cvar[1], cvar[4])
         end
      else
         widgetSetConsoleVariable(cvar[1], cvar[4] or cvar[3])
      end
   end
end

local function setAnchorWidget(widget)
   local anchorWidgetName = widget.userData and widget.userData.anchorWidget
   if anchorWidgetName == nil then return end

   local anchorWidget = _G[anchorWidgetName]
   if anchorWidget == nil then return end

   local anchorOffset = getProps(anchorWidgetName).offset
   if anchorOffset == nil then return end

   -- widget.anchorWidget = anchorWidget
   widget.x = anchorWidget.x + anchorOffset.x
   widget.y = anchorWidget.y + anchorOffset.y
end

local widgetsCato = {}
-- FIXME: Stop spamming c:f() when self isn't needed
--        (Practically the only benefit from this is the 6 characters saved in any line that'd have "self, " in args.)
local function CatoRegisterWidget(widgetName, widget)
   -- FIXME: Consider either
   --           not calling registerWidget, or
   --           not assigning widget:initialize/draw/drawOptions
   --        until CatoHUD:initialize()
   widget.name = widgetName

   widget.x = 0
   widget.xMin = widget.x
   widget.xMax = widget.x

   widget.y = 0
   widget.yMin = widget.y
   widget.yMax = widget.y

   widget.width = 0
   widget.height = 0

   widget.anchor = {x = 0, y = 0}

   widget.optionsHeight = 0

   registerWidget(widgetName)
   -- widgetsCato[widgetName] = widget -- NOTE: The order of widgetsCato would not be guaranteed!
   tbli(widgetsCato, widget)

   widget.reset = function(self)
      self.userData = {}
      setWidgetUserData(self, 'userData', defaultUserData[self.name])
      setWidgetProperties(self, true)
      setWidgetConsoleVariables(self, true)
      -- saveUserData(self.userData)
      -- self.userData = loadUserData()
   end

   widget.initialize = function(self)
      self.userData = loadUserData()
      local resetProperties = self.userData == nil
      setWidgetUserData(self, 'userData', defaultUserData[self.name])
      setWidgetProperties(self, resetProperties)
      setWidgetConsoleVariables(self, false)
      saveUserData(self.userData)
      self.userData = loadUserData()

      if self.init then
         self:init()
      end
   end

   widget.finalize = function(self)
      -- consolePrint(self.name .. ':finalize() called')
      if self.userData then saveUserData(self.userData) end

      if widget.final then
         widget:final()
      end
   end

   widget.getOptionsHeight = function(self)
      return self.optionsHeight
   end

   -- FIXME: You MUST check what happens if GoaHud is present
   widget.drawOptions = function(self, x, y, intensity)
      local userData = self.userData

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

      uiTextCato(pos, self.name, opts.widgetName)

      -- Default options
      -- NOTE: Replacing these requires canHide, canPosition to be false
      --       Must use custom variables: canVisible, canAnchor, canOffset, canScale, canZIndex?

      -- Visible

      -- Anchor/Anchor self/Anchor self Alignment
      -- NOTE: If attached, disabled self's own anchor and copy it from parent

      -- Offset

      -- Scale

      -- Z-Index
      -- NOTE: If previewMode, disable Z-Index (show previous value?)

      -- self.canPreview is nil defaults to true
      if self.canPreview ~= false then
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

      if userData.anchorWidget then
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
         -- setAnchorWidget(self)
      end

      if self.drawOpts then
         optDelimiter(pos, opts.delimiter)
         uiTextCato(pos, self.name .. ' Options', opts.medium)
         self:drawOpts(pos)
      end

      optDelimiter(pos, opts.delimiter)
      uiTextCato(pos, 'Debug', opts.medium)

      local anchor = getProps(self.name).anchor
      uiTextCato(pos, 'anchor: ' .. anchor.x .. ' ' .. anchor.y, opts.small)
      uiTextCato(pos, 'getOptionsHeight(): ' .. self.optionsHeight, opts.small)
      for _, debugLine in ipairs(debugIndexCache(widgets)) do
         uiTextCato(pos, debugLine, opts.small)
      end

      self.optionsHeight = pos.y - y

      saveUserData(userData)
   end

   if widget.name == 'CatoHUD' then return end

   -- widget._draw = widget.draw -- TODO: See if renaming drawWidget to draw and doing this works (hides drawWidget)
   widget.draw = function(self)
      -- FIXME: We can move this outside of widget class and pass widget.userData in.
      --        Define widget.showCondition and widget.hideCondition
      --        Compute       showState     and        hideState     in CatoHUD.drawWidget
      --        Then showState & widget.showCondition -> show
      --             hideState & widget.hideCondition -> hide
      --        This way we do the heavy lifting in CatoHUD:drawWidget() and only do bitwise checks in widget:draw()
      local userData = self.userData
      local show = userData and userData.show
      if not previewMode and show
      and (not show.mainMenu and (replayActive and replayName == 'menu'))
       or (not show.menu and (loading.loadScreenVisible or isInMenu()))
       or (not show.dead and (not povPlayer or povPlayer.health <= 0))
       or (not show.race and (gameMode == 'race' or gameMode == 'training'))
       or (not show.hudOff and (cl_show_hud == 0))
       or (not show.gameOver and (gameState == GAME_STATE_GAMEOVER))
       or (not show.freecam and (localPov and povPlayer and povPlayer.state ~= PLAYER_STATE_INGAME))
       or (not show.editor and (povPlayer and povPlayer.state == PLAYER_STATE_EDITOR)) then
         return
      end

      -- disable preview when menu is closed?
      -- if not isInMenu() then
      --    previewMode = false
      -- end

      self:drawWidget()
   end
   -- widget._draw = nil -- TODO: See if renaming drawWidget to draw and doing this works (hides drawWidget)
end

------------------------------------------------------------------------------------------------------------------------

function CatoHUD:init()
   local offsetUTC = self.userData.offsetUTC
   local time = formatEpochTime(epochTime, offsetUTC)
   local offsetHours = offsetUTC / S_IN_H
   consolePrint(' ')
   consolePrint('CatoHUD loaded')
   consolePrint(strf('%d-%02d-%02d %02d:%02d:%02d (UTC%s)',
      time.year,
      time.month,
      time.day,
      time.hour,
      time.minute,
      time.second,
      offsetHours ~= 0 and (offsetHours > 0 and '+' .. offsetHours or offsetHours) or ''
   ))

   -- local finalEpochTime = tonumber(self.userData.finalEpochTime)
   -- if finalEpochTime then
   --    local fTime = formatEpochTime(finalEpochTime, offsetUTC)
   --    consolePrint(' ')
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
      consolePrint(' ')
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

      if self.userData.configBackup ~= configBackup then
         self.userData.configBackup = configBackup
         consolePrint('Creating backup config \'' .. configBackup .. '.cfg\'')
         consolePerformCommand('saveconfig ' .. configBackup)
         playSound('CatoHUD/toasty')
      else
         consolePrint('Backup config \'' .. configBackup .. '.cfg\' already exists')
      end
   end

   consolePrint(' ')
end

function CatoHUD:draw()
   previewMode = widgetGetConsoleVariable('preview') ~= 0

   -- playerWeaponIndexSelected = nil = player.weaponIndexSelected
   -- playerWeaponIndexChangingTo = nil = player.weaponIndexweaponChangingTo
   -- playerWeaponChangingTo = nil = player.weapons[playerWeaponIndexChangingTo]
   -- playerAmmo = nil = player.weapons[playerWeaponIndexChangingTo].ammo
   -- playerDamageResilience = nil = damageToKill(playerHealth, playerArmor, playerArmorType)
   -- playerSelectedWeaponDefinition = nil  = weaponDefinitions[playerWeaponIndexSelected]
   -- playerChangingToWeaponDefinition = nil = weaponDefinitions[playerWeaponIndexChangingTo]
   -- playerLowAmmo = nil = playerChangingToWeapon.lowAmmoWarning

   -- FIXME: Get all the requisite povPlayer/localPlayer fields here
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
   timeLimit = world.timeLimit
   timeLimitRound = world.timeLimitRound

   inReplay = replayActive and replayName ~= 'menu'

   cl_show_hud = consoleGetVariable('cl_show_hud')

   r_fullscreen = consoleGetVariable('r_fullscreen')
   r_windowed_fullscreen = consoleGetVariable('r_windowed_fullscreen')
   if r_fullscreen  ~= 0 or r_windowed_fullscreen ~= 0 then
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

   -- #1: widgetName -> widget -- NOTE: The order of widgetsCato would not be guaranteed!
   -- local widgetIndex = 0
   -- for widgetName, widget in pairs(widgetsCato) do
   --    widgetIndex = widgetIndex + 1
   -- #2: widgetIndex -> widget
   -- for widgetIndex = 1, #widgetsCato do
   --    local widget = widgetsCato[widgetIndex]
   --    local widgetName = widget.name
   -- #3: widgetIndex -> widget
   -- for widgetIndex, widget in ipairs(widgetsCato) do
   --    local widgetName = widget.name

   -- TODO: Resetting a specific widget should be doable as well
   local resetWidgets = widgetGetConsoleVariable('reset_widgets') ~= 0
   if resetWidgets then
      widgetSetConsoleVariable('reset_widgets', 0)
      -- FIXME: FUCK OFF REFLEX ARENA
      for _, w in ipairs(widgetsCato) do
         if true or w.name ~= 'CatoHUD' then
            -- consolePrint(w.name .. ':reset()')
            w:reset()
         end
      end
      self:reset()
      consolePrint('CatoHUD widgets have been reset')
      playSound('CatoHUD/toasty')
   end

   -- FIXME: Can we reset here?
   for _, w in ipairs(widgetsCato) do
      w.anchor = getProps(w.name).anchor
      setAnchorWidget(w)
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
   -- for i, player in ipairs(players) do
   --    if player.connected then connectedPlayers = connectedPlayers + (i - 1) ^ 2 end
   --    if player.state == PLAYER_STATE_INGAME then inGamePlayers = inGamePlayers + (i - 1) ^ 2 end
   --    if player.team == TEAM_ALPHA then teamAlphaPlayers = teamAlphaPlayers + (i - 1) ^ 2 end
   --    if player.team == TEAM_ZETA then teamZetaPlayers = teamZetaPlayers + (i - 1) ^ 2 end
   -- end
   -- Now we can check if playerIndex & connectedPlayers then do smth.
   -- We could also make a mapping for playerName.playerTeam -> playerIndex to use over getPlayerByName.
   -- In fact we could just create getPlayerByName as a function here if that's faster than via a table mapping.

   -- Parse players for: Cato_BurstAccuracy, Cato_Chat, Cato_FakeBeam, Cato_RespawnDelay
   -- for i, player in ipairs(players) do
   --    consoleVarPrint('players[' .. i .. ']', player)
   -- end
end

-- function CatoHUD:final()
--    self.userData.finalEpochTime = epochTime
--    saveUserData(self.userData)
-- end

CatoRegisterWidget('CatoHUD', CatoHUD)

------------------------------------------------------------------------------------------------------------------------

Cato_HealthNumber = {}
defaultProperties['Cato_HealthNumber'] = {visible = true, offset = '-40 30', anchor = '0 1', zIndex = '0', scale = '1'}
defaultUserData['Cato_HealthNumber'] = {
   anchorWidget = '',
   show = defaultShow('dead'),
   text = {font = fontFace, color = Color(191, 191, 191), size = fontSizeHuge, anchor = {x = 1}},
}

function Cato_HealthNumber:drawWidget()
   if not povPlayer or povPlayer.state == PLAYER_STATE_SPECTATOR then return end

   local opts = copyOpts(self.userData.text)

   local playerHealth = 'N/A'
   if not povPlayer.infoHidden then
      playerHealth = povPlayer.health

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

CatoRegisterWidget('Cato_HealthNumber', Cato_HealthNumber)

------------------------------------------------------------------------------------------------------------------------

Cato_ArmorNumber = {}
defaultProperties['Cato_ArmorNumber'] = {visible = true, offset = '40 30', anchor = '0 1', zIndex = '0', scale = '1'}
defaultUserData['Cato_ArmorNumber'] = {
   anchorWidget = '',
   show = defaultShow('dead'),
   text = {font = fontFace, color = Color(191, 191, 191), size = fontSizeHuge, anchor = {x = -1}},
}

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

CatoRegisterWidget('Cato_ArmorNumber', Cato_ArmorNumber)

------------------------------------------------------------------------------------------------------------------------

Cato_ArmorIcon = {}
defaultProperties['Cato_ArmorIcon'] = {visible = true, offset = '0 -20', anchor = '0 1', zIndex = '0', scale = '1'}
defaultUserData['Cato_ArmorIcon'] = {
   anchorWidget = '',
   show = defaultShow('dead'),
   icon = {color = Color(191, 191, 191), size = 24},
}

function Cato_ArmorIcon:drawWidget()
   if not povPlayer or povPlayer.state == PLAYER_STATE_SPECTATOR then return end

   local opts = copyOpts(self.userData.icon)

   if not povPlayer.infoHidden then
      opts.color = CatoHUD.userData['armorColor'][povPlayer.armorProtection + 1]
   end

   local armor = createSvgElem(self, 'internal/ui/icons/armor', opts)
   armor.draw(0, 0)
end

CatoRegisterWidget('Cato_ArmorIcon', Cato_ArmorIcon)

------------------------------------------------------------------------------------------------------------------------

Cato_FPS = {}
defaultProperties['Cato_FPS'] = {visible = true, offset = '-3 -5', anchor = '1 -1', zIndex = '-999', scale = '1'}
defaultUserData['Cato_FPS'] = {
   anchorWidget = '',
   show = defaultShow('dead editor freecam gameOver mainMenu menu race'),
   text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall},
}

function Cato_FPS:drawWidget()
   -- NOTE: Doesn't work when using an external FPS limiter
   -- local fps = min(round(1 / deltaTime), consoleGetVariable('com_maxfps'))

   -- NOTE: Gives "inffps" during end game scoreboard
   -- local fps = max(round(1 / deltaTime), 0)

   -- TODO: Figure out if this is actually a good solution.
   local fps = max(round(1 / (deltaTime ~= 0 and deltaTime or deltaTimeRaw)), 0)

   fps = createTextElem(self, fps .. 'fps', self.userData.text)
   fps.draw(0, 0)
end

CatoRegisterWidget('Cato_FPS', Cato_FPS)

------------------------------------------------------------------------------------------------------------------------

Cato_Time = {}
defaultProperties['Cato_Time'] = {visible = true, offset = '-3 18', anchor = '1 -1', zIndex = '-999', scale = '1'}
defaultUserData['Cato_Time'] = {
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
}

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


   local epochSeconds = epochTime + CatoHUD.userData.offsetUTC

   -- TODO: Figure out if time should be displayed during replay playback.
   --       It's a bit misleading since it displays current localtime, and replays don't seem to
   --       contain information regarding the actual IRL time they were played during.
   -- if inReplay then
   --    consolePrint('---')
   --    consoleTablePrint(replay)
   --    consolePrint(epochSeconds)
   --    consolePrint(replay.timecodeCurrent)
   -- end

   local hour = createTextElem(self, strf('%02d', floor(epochSeconds / S_IN_H) % H_IN_D), self.userData.text.hour)
   local delimiter = createTextElem(self, ':', self.userData.text.delimiter)
   local minute = createTextElem(self, strf('%02d', floor(epochSeconds / S_IN_M) % M_IN_H), self.userData.text.minute)

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

CatoRegisterWidget('Cato_Time', Cato_Time)

------------------------------------------------------------------------------------------------------------------------

Cato_Scores = {}
defaultProperties['Cato_Scores'] = {visible = true, offset = '0 23', anchor = '1 -1', zIndex = '0', scale = '1'}
defaultUserData['Cato_Scores'] = {
   anchorWidget = 'Cato_Time',
   show = defaultShow('dead freecam gameOver race'),
   text = {
      delimiter = {font = fontFace, color = Color(127, 127, 127), size = fontSizeSmall, anchor = {x = 0}},
      team = {font = fontFace, color = cl_color_friend, size = fontSizeSmall, anchor = {x = 1}},
      enemy = {font = fontFace, color = cl_color_enemy, size = fontSizeSmall, anchor = {x = -1}},
   },
}

function Cato_Scores:drawWidget()
   local opts = {
      team = copyOpts(self.userData.text.team),
      enemy = copyOpts(self.userData.text.enemy),
      delimiter = copyOpts(self.userData.text.delimiter),
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

CatoRegisterWidget('Cato_Scores', Cato_Scores)

------------------------------------------------------------------------------------------------------------------------

Cato_RulesetName = {}
defaultProperties['Cato_RulesetName'] = {visible = true, offset = '0 23', anchor = '1 -1', zIndex = '0', scale = '1'}
defaultUserData['Cato_RulesetName'] = {
   anchorWidget = 'Cato_Scores',
   show = defaultShow('dead freecam gameOver race'),
   text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall},
}

function Cato_RulesetName:drawWidget()
   -- if not inReplay and gameState ~= GAME_STATE_WARMUP then return end

   local rulesetName = createTextElem(self, ruleset, self.userData.text)
   rulesetName.draw(0, 0)
end

CatoRegisterWidget('Cato_RulesetName', Cato_RulesetName)

------------------------------------------------------------------------------------------------------------------------

Cato_GameModeName = {}
defaultProperties['Cato_GameModeName'] = {visible = true, offset = '0 23', anchor = '1 -1', zIndex = '0', scale = '1'}
defaultUserData['Cato_GameModeName'] = {
   anchorWidget = 'Cato_RulesetName',
   show = defaultShow('dead freecam gameOver race'),
   text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall},
}

function Cato_GameModeName:drawWidget()
   if not inReplay and gameState ~= GAME_STATE_WARMUP then return end

   local tl = formatTimeMs(timeLimit * 1000)
   local gameModeName = createTextElem(self, strf('%d:%02d %s', tl.minutes, tl.seconds, gameMode), self.userData.text)
   gameModeName.draw(0, 0)
end

CatoRegisterWidget('Cato_GameModeName', Cato_GameModeName)

------------------------------------------------------------------------------------------------------------------------

Cato_MapName = {}
defaultProperties['Cato_MapName'] = {visible = true, offset = '0 23', anchor = '1 -1', zIndex = '0', scale = '1'}
defaultUserData['Cato_MapName'] = {
   anchorWidget = 'Cato_GameModeName',
   show = defaultShow('dead freecam gameOver race'),
   text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall},
}

function Cato_MapName:drawWidget()
   if not inReplay and gameState ~= GAME_STATE_WARMUP then return end

   local mapName = createTextElem(self, mapTitle, self.userData.text)
   mapName.draw(0, 0)
end

CatoRegisterWidget('Cato_MapName', Cato_MapName)

------------------------------------------------------------------------------------------------------------------------

Cato_Mutators = {}
defaultProperties['Cato_Mutators'] = {visible = true, offset = '0 33', anchor = '1 -1', zIndex = '0', scale = '1'}
defaultUserData['Cato_Mutators'] = {
   anchorWidget = 'Cato_MapName',
   show = defaultShow('dead freecam gameOver race'),
   icon = {size = 8},
}

function Cato_Mutators:drawWidget()
   if not inReplay and gameState ~= GAME_STATE_WARMUP then return end

   local x = -self.userData.icon.size * 2
   local spacing = self.userData.icon.size / 2

   local gameMutators = {}
   -- TODO: Should this be ipairs and then use "gameMutators[i]" over "tbli(gameMutators, mutator)"?
   for mutator in gmatch(world.mutators, '%w+') do
      mutator = mutatorDefinitions[toupper(mutator)]

      mutator = createSvgElem(self, mutator.icon, {color = mutator.col, size = self.userData.icon.size})
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

   -- local opts = copyOpts(self.userData.text)

   -- local gameMutators = createTextElem(self, world.mutators, opts)
   -- gameMutators.draw(0, 0)
end

CatoRegisterWidget('Cato_Mutators', Cato_Mutators)

------------------------------------------------------------------------------------------------------------------------

Cato_DisplayMode = {}
defaultProperties['Cato_DisplayMode'] = {visible = true, offset = '0 20', anchor = '1 -1', zIndex = '-999', scale = '1'}
defaultUserData['Cato_DisplayMode'] = {
   anchorWidget = 'Cato_Mutators',
   show = defaultShow('dead freecam gameOver race mainMenu menu'),
   text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeTiny},
}

function Cato_DisplayMode:drawWidget()
   if not inReplay and gameState ~= GAME_STATE_WARMUP then return end

   if not localPov and not ((replayActive and replayName == 'menu') or (loading.loadScreenVisible or isInMenu())) then
      return
   end

   local modeDisplay = nil
   local monitorIndex = consoleGetVariable('r_monitor')
   local refreshRate = consoleGetVariable('r_refreshrate')
   if r_fullscreen ~= 0 then
      modeDisplay = 'Fullscreen'
   elseif r_windowed_fullscreen ~= 0 then
      modeDisplay = 'Borderless'
      refreshRate = 0 -- FIXME: fml
   else
      modeDisplay = 'Windowed'
   end

   local mode = strf('%s[%d] %dx%d @ %dhz', modeDisplay, monitorIndex, resolutionWidth, resolutionHeight, refreshRate)
   mode = createTextElem(self, mode, self.userData.text)
   mode.draw(0, 0)
end

CatoRegisterWidget('Cato_DisplayMode', Cato_DisplayMode)

------------------------------------------------------------------------------------------------------------------------

Cato_LowAmmo = {}
defaultProperties['Cato_LowAmmo'] = {visible = true, offset = '0 160', anchor = '0 0', zIndex = '0', scale = '1'}
defaultUserData['Cato_LowAmmo'] = {
   anchorWidget = '',
   show = defaultShow('race'),
   text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeMedium}, -- fontSizeSmall
}

-- local attackButton = 'mouse1'
-- local attackUnbound = false
-- local attackCommand = '+attack; cl_camera_next_player; ui_RocketLagNullifier_attack 1'

function Cato_LowAmmo:drawWidget()
   if previewMode then
      local ammoWarning = createTextElem(self, '(Low Ammo)', self.userData.text)
      ammoWarning.draw(0, 0)
      return
   end

   if not povPlayer or povPlayer.infoHidden or povPlayer.health <= 0 then return end

   -- local weaponIndexSelected = povPlayer.weaponIndexSelected
   local weaponIndexweaponChangingTo = povPlayer.weaponIndexweaponChangingTo
   if weaponIndexweaponChangingTo == 1 then return end

   local weaponDefinition = weaponDefinitions[weaponIndexweaponChangingTo]
   if weaponDefinition == nil then return end

   local ammoLow = weaponDefinition.lowAmmoWarning
   local ammoMed = ammoLow + ceil(1000 / weaponDefinition.reloadTime)
   local ammo = povPlayer.weapons[weaponIndexweaponChangingTo].ammo
   if ammo > ammoMed then return end

   local opts = copyOpts(self.userData.text)

   if ammo <= 0 then
      ammo = 'NO AMMO'
      if povPlayer.buttons.attack then
         opts.color = Color(255, 255, 255)
      else
         opts.color = Color(255, 0, 0)
      -- opts.color = Color(95, 95, 95)
      end
   -- TODO: optimize by precalculating midpoints between low ammo to no ammo
   elseif ammo <= ammoLow / 2 then
      -- opts.color = lerpColor(Color(255, 0, 0), Color(255, 255, 0), (ammo - 1) / ammoLow)
      opts.color = Color(255, 0, 0)
   elseif ammo <= ammoLow then
      opts.color = Color(255, 127, 0)
   elseif ammo <= ammoMed then
      opts.color = Color(255, 255, 0)
   end

   local ammoWarning = createTextElem(self, ammo, opts)
   ammoWarning.draw(0, 0)
end

CatoRegisterWidget('Cato_LowAmmo', Cato_LowAmmo)

------------------------------------------------------------------------------------------------------------------------

Cato_Ping = {}
defaultProperties['Cato_Ping'] = {visible = true, offset = '-3 4', anchor = '1 1', zIndex = '0', scale = '1'}
defaultUserData['Cato_Ping'] = {
   anchorWidget = '',
   show = defaultShow('dead freecam gameOver race'),
   text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall},
}

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

CatoRegisterWidget('Cato_Ping', Cato_Ping)

------------------------------------------------------------------------------------------------------------------------

Cato_PacketLoss = {}
defaultProperties['Cato_PacketLoss'] = {visible = true, offset = '-3 -16', anchor = '1 1', zIndex = '0', scale = '1'}
defaultUserData['Cato_PacketLoss'] = {
   anchorWidget = '',
   show = defaultShow('dead freecam gameOver race'),
   text = {font = fontFace, color = Color(255, 0, 0), size = fontSizeSmall},
}

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

CatoRegisterWidget('Cato_PacketLoss', Cato_PacketLoss)

------------------------------------------------------------------------------------------------------------------------

Cato_GameTime = {}
defaultProperties['Cato_GameTime'] = {visible = true, offset = '0 -135', anchor = '0 1', zIndex = '0', scale = '1'}
defaultUserData['Cato_GameTime'] = {
   anchorWidget = '',
   show = defaultShow('dead'),
   countDown = false,
   hideSeconds = false,
   text = {
      delimiter = {font = fontFace, color = Color(127, 127, 127), size = fontSizeTimer, anchor = {x = 0}},
      minutes = {font = fontFace, color = Color(255, 255, 255), size = fontSizeTimer, anchor = {x = 1}},
      seconds = {font = fontFace, color = Color(255, 255, 255), size = fontSizeTimer, anchor = {x = -1}},
   },
}

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
   local seconds = hideSeconds and 'xx' or strf('%02d', timer.seconds)
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

CatoRegisterWidget('Cato_GameTime', Cato_GameTime)

------------------------------------------------------------------------------------------------------------------------

local delayCountDown = true
local delayRespawnMin = 1.0
local delayRespawnMax = 4.0

Cato_RespawnDelay = {}
defaultProperties['Cato_RespawnDelay'] = {visible = true, offset = '80 -90', anchor = '0 1', zIndex = '0', scale = '1'}
defaultUserData['Cato_RespawnDelay'] = {
   anchorWidget = 'Cato_GameTime',
   show = defaultShow('dead race'),
   text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeMedium},
}

local deadTime = nil
function Cato_RespawnDelay:drawWidget()
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

   local opts = copyOpts(self.userData.text)
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

CatoRegisterWidget('Cato_RespawnDelay', Cato_RespawnDelay)

------------------------------------------------------------------------------------------------------------------------

Cato_FollowingPlayer = {}
defaultProperties['Cato_FollowingPlayer'] = {visible = true, offset = '0 0', anchor = '0 -1', zIndex = '0', scale = '1'}
defaultUserData['Cato_FollowingPlayer'] = {
   anchorWidget = '',
   show = defaultShow('dead race'),
   text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeBig, anchor = {x = 0}},
}

function Cato_FollowingPlayer:drawWidget()
   if not povPlayer then return end

   -- TODO: option for display on self
   if not previewMode and not inReplay and localPov then return end

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

CatoRegisterWidget('Cato_FollowingPlayer', Cato_FollowingPlayer)

------------------------------------------------------------------------------------------------------------------------

Cato_ReadyStatus = {}
defaultProperties['Cato_ReadyStatus'] = {visible = true, offset = '0 145', anchor = '0 -1', zIndex = '0', scale = '1'}
defaultUserData['Cato_ReadyStatus'] = {
   anchorWidget = '',
   show = defaultShow('dead freecam race'),
   text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall},
}

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

   local opts = copyOpts(self.userData.text)
   if povPlayer and not povPlayer.ready then
      opts.color = Color(191, 191, 191)
   end

   local ready = createTextElem(self, playersReady .. '/' .. playersGame .. ' ready', opts)
   ready.draw(0, 0)
end

CatoRegisterWidget('Cato_ReadyStatus', Cato_ReadyStatus)

------------------------------------------------------------------------------------------------------------------------

Cato_GameMessage = {}
defaultProperties['Cato_GameMessage'] = {visible = true, offset = '0 -80', anchor = '0 0', zIndex = '0', scale = '1'}
defaultUserData['Cato_GameMessage'] = {
   anchorWidget = '',
   show = defaultShow('dead freecam menu race'),
   text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeMedium},
}

local lastTickSeconds = -1
function Cato_GameMessage:drawWidget()
   local gameMessage = nil
   if world.timerActive then
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

   gameMessage = createTextElem(self, gameMessage, self.userData.text)
   gameMessage.draw(0, 0)
end

CatoRegisterWidget('Cato_GameMessage', Cato_GameMessage)

------------------------------------------------------------------------------------------------------------------------

Cato_Speed = {}
defaultProperties['Cato_Speed'] = {visible = false, offset = '0 60', anchor = '0 0', zIndex = '0', scale = '1'}
defaultUserData['Cato_Speed'] = {
   anchorWidget = '',
   show = defaultShow('race'),
   text = {font = fontFace, color = Color(255, 255, 255), size = fontSizeSmall},
}

function Cato_Speed:drawWidget()
   if not povPlayer then return end

   local ups = createTextElem(self, ceil(povPlayer.speed) .. 'ups', self.userData.text)
   ups.draw(0, 0)
end

CatoRegisterWidget('Cato_Speed', Cato_Speed)

------------------------------------------------------------------------------------------------------------------------

Cato_Crosshair = {}
defaultProperties['Cato_Crosshair'] = {visible = true, offset = '0 0', anchor = '0 0', zIndex = '0', scale = '1'}
defaultUserData['Cato_Crosshair'] = {
   anchorWidget = '',
   show = defaultShow('race'),
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

function Cato_Crosshair:drawWidget()
   local x = 0
   local y = 0

   local pixelWidth = viewportWidth / resolutionWidth
   local pixelHeight = viewportHeight / resolutionHeight

   local userData = self.userData

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
   -- NOTE: In general one may consider fetching all relevant tables at the end of Widget:drawWidget()
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

CatoRegisterWidget('Cato_Crosshair', Cato_Crosshair)

------------------------------------------------------------------------------------------------------------------------
