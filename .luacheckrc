-- FIXME: Can I not get these warnings suppressed easier?
read_globals = {
   -- ConsoleVarPrint.lua
   'ConsoleVarPrint',

   -- reflexcore.lua
   'GAME_STATE_ACTIVE',
   'GAME_STATE_GAMEOVER',
   'GAME_STATE_ROUNDACTIVE',
   'GAME_STATE_ROUNDCOOLDOWN_DRAW',
   'GAME_STATE_ROUNDCOOLDOWN_SOMEONEWON',
   'GAME_STATE_ROUNDPREPARE',
   'GAME_STATE_WARMUP',
   'LOG_TYPE_DEATHMESSAGE',
   'PLAYER_STATE_EDITOR',
   'PLAYER_STATE_INGAME',
   'PLAYER_STATE_SPECTATOR',
   'WIDGET_PROPERTIES_COL_WIDTH',

   -- gamestrings.lua
   'mutatorDefinitions',

   -- LuaVariables.txt
   'deltaTime',
   'deltaTimeRaw',
   'epochTime',
   'extendedColors',
   'gamemodes',
   'loading',
   'log',
   'playerIndexCameraAttachedTo',
   'playerIndexLocalPlayer',
   'players',
   'replayActive',
   'replayName',
   'teamColors',
   'timeLimit',
   'viewport',
   'weaponDefinitions',
   'widgets',
   'world',

   -- LuaFunctions.txt
   'consoleGetVariable',
   'consolePerformCommand',
   'consolePrint',
   'isInMenu',
   'loadUserData',
   'mouseRegion',
   'nvgBeginPath',
   'nvgFill',
   'nvgFillColor',
   'nvgFontBlur',
   'nvgFontFace',
   'nvgFontSize',
   'nvgIntersectScissor',
   'nvgLineTo',
   'nvgMoveTo',
   'nvgRect',
   'nvgRestore',
   'nvgSave',
   'nvgStroke',
   'nvgStrokeColor',
   'nvgSvg',
   'nvgText',
   'nvgTextAlign',
   'nvgTextBounds',
   'nvgTextWidth',
   'playSound',
   'registerWidget',
   'saveUserData',
   'textRegion',
   'textRegionSetCursor',
   'widgetCreateConsoleVariable',
   'widgetGetConsoleVariable',
   'widgetSetConsoleVariable',
}

-- CatoHUD
self = false
allow_defined_top = true

ignore = {
   -- math
   -- 'clamp',
   -- 'rad2deg',
   -- debug
   -- 'consoleColorPrint',
   -- 'consoleTablePrint',
}
