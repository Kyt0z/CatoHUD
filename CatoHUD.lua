local debugMode = true
if debugMode then
   consolePrint('CatoHUD loaded')
end

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

local function clamp(x, minVal, maxVal)
   return max(min(x, maxVal), minVal)
end

local function round(x)
   return x >= 0 and floor(x + 0.5) or ceil(x - 0.5)
end

local function lerp(x, y, k)
   return (1 - k) * x + k * y
end

local function Color(r, g, b, a, intensity)
   return {r = r, g = g, b = b, a = (a or 255) * (intensity or 1)}
end

local function ColorHEX(hex, intensity)
   return {
      r = tonumber('0x' .. string.sub(hex, 1, 2)),
      g = tonumber('0x' .. string.sub(hex, 3, 4)),
      b = tonumber('0x' .. string.sub(hex, 5, 6)),
      a = (tonumber('0x' .. string.sub(hex, 7, 8)) or 255) * (intensity or 1)
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

local function consoleColorPrint(color)
   consolePrint(string.format('(%s, %s, %s, %s)', color.r, color.g, color.b, color.a))
end

local function consoleTablePrint(key, val, depth)
   if not depth then depth = 0 end

   if type(key) == 'table' then
      for k, v in pairs(key) do
         consoleTablePrint(k, v, depth + 1)
      end
      return
   end

   local typeval = type(val)
   local indent = string.rep(' ', depth)
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

----------------------------------------------------------------------------------------------------

local defaultFontFace = 'TitilliumWeb-Bold'
local defaultFontSizeSmall = 32
local defaultFontSizeMedium = 40
local defaultFontSizeBig = 64
local defaultFontSizeTimer = 120
local defaultFontSizeHuge = 160
local sens = consoleGetVariable('m_speed')
local fov = consoleGetVariable('r_fov')
local defaultZoomFov = 40
local defaultZoomSens = sens * zoomSensRatio(fov, defaultZoomFov, 1440, 1080) * 1.0915740009242504
-- local defaultZoomSens = sens * zoomSensRatio(fov, defaultZoomFov, 1440, 1080)
-- local defaultZoomSens = 5.76 * zoomSensRatio(105, defaultZoomFov, 1440, 1080)
-- local defaultZoomSens = 5.759587 * zoomSensRatio(105, defaultZoomFov, 1440, 1080)
-- local defaultZoomSens = 5.75 * zoomSensRatio(105, defaultZoomFov, 1440, 1080)
-- local defaultZoomSens = 3.839724 * zoomSensRatio(105, defaultZoomFov, 1440, 1080)

local defaultSettings = {
   ['CatoHUD'] = {
      userData = {
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
         {'reset_widgets', 'int', 0, 0},
         {'warmuptimer_reset', 'int', 0, 0},
         {'widget_cache', 'int', 0, 0},
         {'zoom', 'int', 0, 0},
      },
   },
   ['Cato_Zoom'] = {
      userData = {
         fov = defaultZoomFov,
         sensitivity = defaultZoomSens,
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
         fontFace = defaultFontFace,
         fontSize = defaultFontSizeHuge,
         textAnchor = {x = 1},
         show = {dead = true, race = false, menu = false, hudOff = false, gameOver = false},
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
         fontFace = defaultFontFace,
         fontSize = defaultFontSizeHuge,
         textAnchor = {x = -1},
         show = {dead = true, race = false, menu = false, hudOff = false, gameOver = false},
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
         iconSize = 24,
         show = {dead = true, race = false, menu = false, hudOff = false, gameOver = false},
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
         fontFace = defaultFontFace,
         fontSize = defaultFontSizeSmall,
         show = {dead = true, race = true, menu = true, hudOff = false, gameOver = true},
      },
   },
   ['Cato_Scores'] = {
      visible = true,
      props = {
         offset = '-3 18',
         anchor = '1 -1',
         zIndex = '0',
         scale = '1',
      },
      userData = {
         fontFace = defaultFontFace,
         fontSize = defaultFontSizeSmall,
         show = {dead = true, race = true, menu = false, hudOff = false, gameOver = true},
      },
   },
   ['Cato_GameInfo'] = {
      visible = true,
      props = {
         offset = '-3 41',
         anchor = '1 -1',
         zIndex = '0',
         scale = '1',
      },
      userData = {
         fontFace = defaultFontFace,
         fontSize = defaultFontSizeSmall,
         show = {dead = true, race = true, menu = false, hudOff = false, gameOver = false},
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
         fontFace = defaultFontFace,
         fontSize = defaultFontSizeSmall,
         show = {dead = true, race = true, menu = false, hudOff = false, gameOver = false},
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
         fontFace = defaultFontFace,
         fontSize = defaultFontSizeMedium,
         show = {dead = true, race = true, menu = true, hudOff = false, gameOver = false},
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
         fontFace = defaultFontFace,
         fontSize = defaultFontSizeSmall,
         show = {dead = false, race = true, menu = false, hudOff = false, gameOver = false},
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
         fontFace = defaultFontFace,
         fontSize = defaultFontSizeSmall,
         show = {dead = true, race = true, menu = false, hudOff = false, gameOver = true},
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
         fontFace = defaultFontFace,
         fontSize = defaultFontSizeSmall,
         show = {dead = true, race = true, menu = false, hudOff = false, gameOver = true},
      },
   },
   ['Cato_Timer'] = {
      visible = true,
      props = {
         offset = '0 -135',
         anchor = '0 1',
         zIndex = '0',
         scale = '1',
      },
      userData = {
         countDown = false,
         hideSeconds = false,
         fontFace = defaultFontFace,
         fontSize = defaultFontSizeTimer,
         show = {dead = true, race = false, menu = false, hudOff = false, gameOver = false},
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
         fontFace = defaultFontFace,
         fontSize = defaultFontSizeBig,
         textAnchor = {x = 0},
         show = {dead = true, race = true, menu = false, hudOff = false, gameOver = false},
      },
   },
}

----------------------------------------------------------------------------------------------------

STATE_DISCONNECTED = 0
STATE_CONNECTING = 1
STATE_CONNECTED = 2

GAME_STATE_WARMUP = 0
GAME_STATE_ACTIVE = 1
GAME_STATE_ROUNDPREPARE = 2
GAME_STATE_ROUNDACTIVE = 3
GAME_STATE_ROUNDCOOLDOWN_SOMEONEWON = 4
GAME_STATE_ROUNDCOOLDOWN_DRAW = 5
GAME_STATE_GAMEOVER = 6

PLAYER_STATE_INGAME = 1
PLAYER_STATE_SPECTATOR = 2
PLAYER_STATE_EDITOR = 3
PLAYER_STATE_QUEUED = 4

TEAM_ALPHA = 1
TEAM_ZETA = 2

-- TODO: Various relative offsets (such as between lines in 'FOLLOWING\nplayer') depend on the
--       font, so maybe a function that calculates the proper offset for all the default fonts?
-- fonts = {
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

local povPlayer = nil
local localPlayer = nil

local gameState = nil
local gameMode = nil
local hasTeams = nil
local mapName = nil
local mapTitle = nil
local rulesetName = nil
local gameTimeElapsed = nil
local gameTimeLimit = nil

local inReplay = nil
local previousMapName = nil
local warmupTimeElapsed = 0

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

local function checkResetConsoleVariable(cvar, resetValue)
   local oldValue = consoleGetVariable(cvar)
   if oldValue ~= resetValue then
      consolePerformCommand(cvar .. ' ' .. resetValue)
   end
   return oldValue
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

--

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

local function damageToKill(health, armor, armorProtection)
   return min(armor, health * (armorProtection + 1)) + health
end

local function formatTimer(elapsed, limit, countDown)
   if countDown then
      local remaining = 1000 + limit - elapsed
      return {
         minutes = max(floor(remaining / 60000), 0),
         seconds = (floor(remaining / 1000) % 60 + 60) % 60,
      }
   end
   return {
      minutes = floor(elapsed / 60000),
      seconds = floor((elapsed / 1000) % 60),
   }
end

----------------------------------------------------------------------------------------------------

CatoHUD = {
   canHide = false,
   canPosition = false,
}

----------------------------------------------------------------------------------------------------

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

local function uiDelimiter(pos, opts)
   pos.y = pos.y + 8 -- padding
   nvgFillColor(opts.color)
   nvgBeginPath()
   nvgRect(pos.x, pos.y, 580, 2) -- WIDGET_PROPERTIES_COL_WIDTH = 560
   nvgFill()
   pos.y = pos.y + 10 -- padding

   if consoleGetVariable('ui_CatoHUD_box_debug') ~= 0 then
      nvgFillColor(Color(0, 255, 0, 63))
      nvgBeginPath()
      nvgRect(pos.x, pos.y - 18, 580, 18)
      nvgFill()
   end
end

local function createTextElem(anchor, text, opts)
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

local function uiCheckBox(pos, value, opts)
   local enabled = opts.enabled == nil and true or opts.enabled

   local mouse = {hoverAmount = 0, leftUp = false}
   if enabled then
      mouse = mouseRegion(pos.x, pos.y, opts.size, opts.size, opts.id or 0)
   end

   local bgColor = lerpColor(opts.bg.base, opts.bg.hover, mouse.hoverAmount or 0, opts.intensity)
   local fgColor = lerpColor(opts.fg.base, opts.fg.hover, mouse.hoverAmount or 0, opts.intensity)
   if pressed then
      fgColor = copyColor(opts.fg.disabled, intensity)
   elseif enabled then
      fgColor = copyColor(opts.fg.pressed, intensity)
   end

   -- bg
   nvgBeginPath()
   nvgRect(pos.x, pos.y, opts.size, opts.size)
   nvgFillColor(bgColor)
   nvgFill()

   -- svg
   if value then
      local checkOffset = round(opts.size / 2)
      local checkSize = round(opts.size / 3.5)
      nvgFillColor(fgColor)
      nvgSvg('internal/ui/icons/checkBoxTick', pos.x + checkOffset, pos.y + checkOffset, checkSize)
   end

   if mouse.leftUp then
      playSound('internal/ui/sounds/buttonClick')
      value = not value
   end

   return value
end

local function uiRowCheckbox(pos, text, value, textOpts, checkboxOpts)
   -- WIDGET_PROPERTIES_COL_INDENT = 250
   local diff = checkboxOpts.size - textOpts.size
   pos.y = pos.y + max(0, diff / 2)
   local label = nvgTextUI(pos, text, textOpts)

   local padding = label.width + 8
   pos.x = pos.x + padding
   pos.y = pos.y - label.height - diff / 2
   value = uiCheckBox(pos, value, checkboxOpts)
   pos.y = pos.y + max(label.height, checkboxOpts.size) -- padding
   pos.x = pos.x - padding
   return value
end

-- (:.*?:)|\^[0-9a-zA-Z]
-- :arenafp: :reflexpicardia::skull:^w' .. povPlayer.name .. ' :rocket::boom:^7:beatoff:
-- local function nvgEmojiText(props, pos, text, opts)
--
-- end

----------------------------------------------------------------------------------------------------

function CatoHUD:registerWidget(widgetName, widget)
   registerWidget(widgetName)

   if widget.canPreview == nil then
      widget.canPreview = true
   end

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
            -- preview = debugMode,
            size = 22,
            font = 'roboto-regular',
            color = Color(191, 191, 191, 255 * intensity),
         },
         medium = {
            -- preview = debugMode,
            size = 28,
            font = 'roboto-regular',
            color = Color(255, 255, 255, 255 * intensity),
         },
         warning = {
            -- preview = debugMode,
            size = 28,
            font = 'roboto-regular',
            color = Color(255, 0, 0, 255 * intensity),
         },
         delimiter = {
            -- preview = debugMode,
            color = Color(0, 0, 0, 63 * intensity),
         },
         checkbox = {
            size = 35,
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

      if widget.canPreview then
         widget.preview = uiRowCheckbox(pos, 'Preview', widget.preview, opts.medium, opts.checkbox)
      end
      uiDelimiter(pos, opts.delimiter)

      if widget.drawOpts then
         nvgTextUI(pos, widgetName .. ' Options', opts.medium)
         widget:drawOpts(pos)
         if debugMode then
            uiDelimiter(pos, opts.delimiter)
         end
      end

      if debugMode then
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

   function widget:shouldShow(player)
      if widgetName == 'CatoHUD' then return true end
      if widgetName == 'Cato_Zoom' then return true end -- FIXME: Better solution

      -- FIXME: This is pretty weird. Maybe tie preview check boxes to CatoHUD.preview?
      --        (And vice versa?)
      -- FIXME: preview should temporarily change zindex to -999?
      if CatoHUD.preview or widget.preview then
         return true
      end

      -- FIXME: Combine statements. Should be more efficient?
      local widgetShow
      if widget.userData and widget.userData.show then
         widgetShow = widget.userData.show
      else
         widgetShow = {}
      end

      if not widgetShow.menu then
         if loading.loadScreenVisible or isInMenu() then
            return false
         end
      end

      if not widgetShow.dead then
         if not player or player.health <= 0 then
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

      return true
   end

   function widget:draw()
      if not widget:shouldShow(povPlayer) then
         return
      end

      if not isInMenu() then
         widget.preview = false
      -- elseif CatoHUD.preview then -- FIXME: This almost works
      --    widget.preview = true
      end

      widget.anchor = getProps(widgetName).anchor
      widget:drawWidget(povPlayer, localPlayer)
   end
end

----------------------------------------------------------------------------------------------------

function CatoHUD:drawWidget()
   povPlayer = players[playerIndexCameraAttachedTo]
   localPlayer = players[playerIndexLocalPlayer]

   gameState = world.gameState
   gameMode = gamemodes[world.gameModeIndex].shortName
   hasTeams = gamemodes[world.gameModeIndex].hasTeams
   mapName = world.mapName
   mapTitle = world.mapTitle
   rulesetName = world.ruleset
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

   if checkResetConsoleVariable('ui_CatoHUD_warmuptimer_reset', 0) ~= 0 then
      warmupTimeElapsed = 0
   elseif gameState == GAME_STATE_WARMUP then
      warmupTimeElapsed = warmupTimeElapsed + deltaTime * 1000
   end

   if mapName ~= previousMapName then
      warmupTimeElapsed = 0
      previousMapName = mapName
   end
end

CatoHUD:registerWidget('CatoHUD', CatoHUD)

----------------------------------------------------------------------------------------------------

Cato_Timer = {}

function Cato_Timer:drawWidget(player)
   if not player or player.state == PLAYER_STATE_SPECTATOR then return end

   local hideSeconds = self.userData.hideSeconds

   local timeElapsed = 0
   if gameState == GAME_STATE_WARMUP then
      timeElapsed = warmupTimeElapsed
   elseif gameState == GAME_STATE_ACTIVE or gameState == GAME_STATE_ROUNDACTIVE then
      timeElapsed = gameTime
      hideSeconds = (hideSeconds and gameTimeLimit - gameTime > 30000)
   end

   local timer = formatTimer(timeElapsed, gameTimeLimit, self.userData.countDown)

   local opts = {
      minutes = {
         font = self.userData.fontFace,
         color = Color(255, 255, 255),
         size = self.userData.fontSize,
         anchor = {x = 1},
      },
      delimiter = {
         font = self.userData.fontFace,
         color = Color(127, 127, 127),
         size = self.userData.fontSize,
         anchor = {x = 0},
      },
      seconds = {
         font = self.userData.fontFace,
         color = Color(255, 255, 255),
         size = self.userData.fontSize,
         anchor = {x = -1},
      },
   }

   local minutes = createTextElem(self.anchor, timer.minutes, opts.minutes)
   local delimiter = createTextElem(self.anchor, ':', opts.delimiter)
   local seconds = createTextElem(self.anchor, string.format('%02d', timer.seconds), opts.seconds)

   local x = 0
   local spacing = delimiter.width / 2
   if self.anchor.x == -1 then
      x = minutes.width + spacing
   elseif self.anchor.x == 0 then
      x = 0
   elseif self.anchor.x == 1 then
      x = -(seconds.width + spacing)
   end

   minutes.draw(x - spacing, 0)
   delimiter.draw(x, 0)
   seconds.draw(x + spacing, 0)
end

CatoHUD:registerWidget('Cato_Timer', Cato_Timer)

----------------------------------------------------------------------------------------------------

Cato_FollowingPlayer = {}

function Cato_FollowingPlayer:drawWidget(player)
   if not player then return end

   -- TODO: option for display on self
   local preview = CatoHUD.preview or self.preview
   if not preview and player == localPlayer then return end

   local opts = {
      font = self.userData.fontFace,
      color = Color(255, 255, 255),
      size = self.userData.fontSize,
      anchor = self.userData.textAnchor,
   }

   local label = createTextElem(self.anchor, 'FOLLOWING', opts)
   local name = createTextElem(self.anchor, player.name, opts)

   local x = 0
   if self.anchor.x == -1 then
      x = max(label.width, name.width) / 2
   elseif self.anchor.x == 0 then
      x = 0
   elseif self.anchor.x == 1 then
      x = -(max(label.width, name.width) / 2)
   end

   local y = 0
   local offset = opts.size / 3
   if self.anchor.y == -1 then
      y = 0
   elseif self.anchor.y == 0 then
      y = -(label.height - offset) / 2
   elseif self.anchor.y == 1 then
      y = -(name.height - offset)
   end

   label.draw(x, y)
   name.draw(x, y + label.height - offset)
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
   fps.draw(0, 0)
end

CatoHUD:registerWidget('Cato_FPS', Cato_FPS)

----------------------------------------------------------------------------------------------------

Cato_Scores = {}

function Cato_Scores:drawWidget(player)
   local opts = {
      team = {
         font = self.userData.fontFace,
         color = ColorHEX(consoleGetVariable('cl_color_friend')),
         size = self.userData.fontSize,
         anchor = {x = 1},
      },
      delimiter = {
         font = self.userData.fontFace,
         color = Color(127, 127, 127),
         size = self.userData.fontSize,
         anchor = {x = 0},
      },
      enemy = {
         font = self.userData.fontFace,
         color = ColorHEX(consoleGetVariable('cl_color_enemy')),
         size = self.userData.fontSize,
         anchor = {x = -1},
      },
   }

   local scoreTeam = nil
   local indexTeam = nil
   local scoreEnemy = nil
   local indexEnemy = nil
   local relativeColors = consoleGetVariable('cl_colors_relative') == 1
   if hasTeams then
      if player and player.state == PLAYER_STATE_INGAME then
         indexTeam = player.team
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
      if player and player.state == PLAYER_STATE_INGAME and player.connected then
         if indexWinner == player.index then
            scoreTeam = scoreWinner
            indexTeam = indexWinner
            scoreEnemy = scoreRunnerUp
            indexEnemy = indexRunnerUp
         elseif indexRunnerUp == player.index then
            scoreTeam = scoreRunnerUp
            indexTeam = indexRunnerUp
            scoreEnemy = scoreWinner
            indexEnemy = indexWinner
         else
            scoreTeam = player.score
            indexTeam = player.index
            scoreEnemy = scoreWinner
            indexEnemy = indexWinner
         end
      end

      -- Use player colors in FFA/1v1
      if not relativeColors or not player or player.state ~= PLAYER_STATE_INGAME then
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
   local x = 0
   local spacing = delimiter.width / 2
   if self.anchor.x == -1 then
      x = scoreTeam.width + spacing
   elseif self.anchor.x == 0 then
      x = 0
   elseif self.anchor.x == 1 then
      x = -(scoreEnemy.width + spacing)
   end

   scoreTeam.draw(x - spacing, 0)
   delimiter.draw(x, 0)
   scoreEnemy.draw(x + spacing, 0)
end

CatoHUD:registerWidget('Cato_Scores', Cato_Scores)

----------------------------------------------------------------------------------------------------

Cato_GameInfo = {}

function Cato_GameInfo:drawWidget(player)
   if not inReplay and gameState ~= GAME_STATE_WARMUP then return end

   local opts = {
      font = self.userData.fontFace,
      color = Color(255, 255, 255),
      size = self.userData.fontSize,
   }

   local gameInfo = string.format('%s (%s) @ %s', string.upper(gameMode), rulesetName, mapTitle)
   gameInfo = createTextElem(self.anchor, gameInfo, opts)
   gameInfo.draw(0, 0)
end

CatoHUD:registerWidget('Cato_GameInfo', Cato_GameInfo)

----------------------------------------------------------------------------------------------------

Cato_ReadyStatus = {}

function Cato_ReadyStatus:drawWidget(player)
   local preview = CatoHUD.preview or self.preview
   if gameState ~= GAME_STATE_WARMUP and not preview then return end

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
   ready.draw(0, 0)
end

CatoHUD:registerWidget('Cato_ReadyStatus', Cato_ReadyStatus)

----------------------------------------------------------------------------------------------------

Cato_GameMessages = {}

function Cato_GameMessages:init()
   self.lastTickSeconds = -1
end

function Cato_GameMessages:drawWidget(player)
   local opts = {
      font = self.userData.fontFace,
      color = Color(255, 255, 255),
      size = self.userData.fontSize,
   }

   local gameMessage = nil
   if world.timerActive then
      if gameState == GAME_STATE_WARMUP or gameState == GAME_STATE_ROUNDPREPARE then
         local timer = formatTimer(gameTime, gameTimeLimit, true)
         if self.lastTickSeconds ~= timer.seconds then
            self.lastTickSeconds = timer.seconds
            playSound('internal/ui/match/match_countdown_tick')
         end
         gameMessage = timer.seconds
      elseif gameState == GAME_STATE_ACTIVE or gameState == GAME_STATE_ROUNDACTIVE then
         if gameTime < 2000 then
            local overTimeCount = world.overTimeCount
            if overTimeCount <= 0 then
               gameMessage = (gameMode == 'race' or gameMode == 'training') and 'GO' or 'FIGHT'
            else
               gameMessage = 'OVERTIME #' .. overTimeCount
            end
         end
      elseif gameState == GAME_STATE_ROUNDCOOLDOWN_SOMEONEWON then
         if player ~= nil then
            local name = hasTeams and world.teams[player.team].name or player.name
            gameMessage = name .. ' WINS'
         else
            gameMessage = 'Round Over'
         end
      elseif gameState == GAME_STATE_ROUNDCOOLDOWN_DRAW then
         gameMessage = 'DRAW'
      end
   end

   local preview = CatoHUD.preview or self.preview
   if preview then
      if gameMessage == nil then
         gameMessage = '(Game Message)'
      end
   elseif gameMessage == nil or isInMenu() then
      return
   end

   gameMessage = createTextElem(self.anchor, gameMessage, opts)
   gameMessage.draw(0, 0)
end

CatoHUD:registerWidget('Cato_GameMessages', Cato_GameMessages)

----------------------------------------------------------------------------------------------------

Cato_LowAmmo = {}

-- local attackButton = 'mouse1'
-- local attackUnbound = false
-- local attackCommand = '+attack; cl_camera_next_player; ui_RocketLagNullifier_attack 1'

function Cato_LowAmmo:drawWidget(player, localPlayer)
   if not player or player.infoHidden then return end

   local weaponIndexSelected = player.weaponIndexSelected
   if weaponDefinitions[weaponIndexSelected] == nil then return end

   local ammoLow = weaponDefinitions[weaponIndexSelected].lowAmmoWarning
   local ammo = player.weapons[weaponIndexSelected].ammo
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
   -- if self.userData.preventEmptyAttack and player == localPlayer and player.buttons.attack then
   --    consolePerformCommand('-attack')
   --    consolePrint('No ammo. Prevent shooting')
   -- end
   -- attackButton = bindReverseLookup('+attack', 'game')
   -- if player == localPlayer and self.userData.preventEmptyAttack then
   --    if ammo > 0 then
   --       consolePerformCommand('bind game ' .. attackButton .. ' ' .. attackCommand)
   --    elseif ammo == 1 then
   --       if player.buttons.attack then
   --          consolePerformCommand('-attack')
   --       end
   --    else
   --       consolePerformCommand('unbind game ' .. attackButton)
   --    end
   -- end

   -- local lowAmmoText = ammo <= 0 and 'LOW AMMO: ' .. ammo or 'NO AMMO: ' .. ammo
   -- local ammoWarning = createTextElem(self.anchor, lowAmmoText, opts)

   local ammoWarning = createTextElem(self.anchor, ammo, opts)
   ammoWarning.draw(0, 0)
end

CatoHUD:registerWidget('Cato_LowAmmo', Cato_LowAmmo)

----------------------------------------------------------------------------------------------------

Cato_PacketLoss = {}

function Cato_PacketLoss:drawWidget(player)
   if not player or player.state == PLAYER_STATE_SPECTATOR then return end

   local opts = {
      font = self.userData.fontFace,
      color = Color(255, 0, 0),
      size = self.userData.fontSize,
   }

   if player.packetLoss == 0 then
      return
   elseif player.packetLoss <= 5 then
      opts.color = Color(255, 255, 255)
   elseif player.packetLoss < 10 then
      opts.color = Color(255, 255, 0)
   else
      opts.color = Color(255, 0, 0)
   end

   local packetloss = createTextElem(self.anchor, player.packetLoss .. ' PL', opts)
   packetloss.draw(0, 0)
end

CatoHUD:registerWidget('Cato_PacketLoss', Cato_PacketLoss)

----------------------------------------------------------------------------------------------------

Cato_Ping = {}

function Cato_Ping:drawWidget(player)
   if not player or player.state == PLAYER_STATE_SPECTATOR then return end

   local opts = {
      font = self.userData.fontFace,
      color = Color(255, 255, 255),
      size = self.userData.fontSize,
   }

   if player.latency == 0 then
      return
   elseif player.latency <= 50 then
      opts.color = Color(0, 255, 0)
   elseif player.latency < 100 then
      opts.color = Color(255, 255, 0)
   else
      opts.color = Color(255, 0, 0)
   end

   local ping = createTextElem(self.anchor, player.latency .. 'ms', opts)
   ping.draw(0, 0)
end

CatoHUD:registerWidget('Cato_Ping', Cato_Ping)

----------------------------------------------------------------------------------------------------

Cato_HealthNumber = {}

function Cato_HealthNumber:drawWidget(player)
   if not player or player.state == PLAYER_STATE_SPECTATOR then return end

   local opts = {
      font = self.userData.fontFace,
      color = Color(191, 191, 191),
      size = self.userData.fontSize,
      anchor = self.userData.textAnchor,
   }

   local playerHealth = 'N/A'
   if not player.infoHidden then
      playerHealth = player.health

      local damage = damageToKill(player.health, player.armor, player.armorProtection)
      if damage <= 80 then
         opts.color = Color(255, 0, 0)
      elseif damage <= 100 then
         opts.color = Color(255, 255, 0)
      else
         opts.color = Color(255, 255, 255)
      end
   end

   local health = createTextElem(self.anchor, playerHealth, opts)
   health.draw(0, 0)

end

CatoHUD:registerWidget('Cato_HealthNumber', Cato_HealthNumber)

----------------------------------------------------------------------------------------------------

Cato_ArmorNumber = {}

function Cato_ArmorNumber:drawWidget(player)
   if not player or player.state == PLAYER_STATE_SPECTATOR then return end

   local opts = {
      font = self.userData.fontFace,
      color = Color(191, 191, 191),
      size = self.userData.fontSize,
      anchor = self.userData.textAnchor,
   }

   local playerArmor = 'N/A'
   if not player.infoHidden then
      playerArmor = player.armor

      opts.color = CatoHUD.userData['armorColor' .. player.armorProtection]
      opts.color = armorColorLerp(playerArmor, player.armorProtection, opts.color)

      -- local lerpSteps = floor(playerArmor / armorLimit[player.armorProtection + 1][0])

      -- local lerpSteps = -1
      -- for itemArmorProtection = 0, 2 do
      --    if playerArmor < armorLimit[player.armorProtection + 1][itemArmorProtection + 1] then
      --       lerpSteps = lerpSteps + 1
      --    end
      -- end

      -- local colorToLerp = lerpSteps < 0 and Color(255, 255, 255) or Color(0, 0, 0)
      -- opts.color = lerpColor(opts.color, colorToLerp, abs(lerpSteps) * 0.33)

      -- consoleColorPrint(opts.color)
      -- consoleColorPrint(colorToLerp)

      -- debug
      -- playerArmor = player.armor .. ' ' .. armorQuality(player) * player.armor

      -- local playerArmorLimit = playerArmor * armorQuality[player.armorProtection]
      -- playerArmorLimit = ceil(playerArmorLimit)
      -- if playerArmorLimit < armorQuality[0] * armorMax[0] then
      --    opts.color = lerpColor(opts.color, Color(0, 0, 0), 2 / 3)
      -- elseif playerArmorLimit < armorQuality[1] * armorMax[1] then
      --    opts.color = lerpColor(opts.color, Color(0, 0, 0), 1 / 3)
      -- elseif playerArmorLimit < armorQuality[2] * armorMax[2] then
      --    opts.color = lerpColor(opts.color, Color(0, 0, 0), 0)
      -- end

      -- FIXME: Better way?
      -- opts.color = CatoHUD.userData['armorColor' .. player.armorProtection]
      -- if player.armorProtection == 2 then
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
      -- elseif player.armorProtection == 1 then
      --     -- YA <  75 -> can pickup GA
      --    if playerArmor < 75 then
      --       opts.color = lerpColor(opts.color, Color(0, 0, 0), 0.66)
      --     -- YA < 150 -> can pickup YA
      --    elseif playerArmor < 150 then
      --       opts.color = lerpColor(opts.color, Color(0, 0, 0), 0.33)
      --    end
      -- elseif player.armorProtection == 0 then
      --     -- GA < 100 -> can pickup GA
      --    if playerArmor < 100 then
      --       opts.color = lerpColor(opts.color, Color(0, 0, 0), 0.66)
      --    end
      -- end
   end


   local armor = createTextElem(self.anchor, playerArmor, opts)
   armor.draw(0, 0)
end

CatoHUD:registerWidget('Cato_ArmorNumber', Cato_ArmorNumber)

----------------------------------------------------------------------------------------------------

Cato_ArmorIcon = {}

function Cato_ArmorIcon:drawWidget(player)
   if not player or player.state == PLAYER_STATE_SPECTATOR then return end

   local opts = {
      color = CatoHUD.userData.noArmorColor,
      size = self.userData.iconSize,
   }

   if not player.infoHidden then
      opts.color = CatoHUD.userData['armorColor' .. player.armorProtection]
   end

   local armor = createSvgElem(self.anchor, 'internal/ui/icons/armor', opts)
   armor.draw(0, 0)
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