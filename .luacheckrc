-- FIXME: Can I not get these warnings suppressed easier?
read_globals = {
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
   'STATE_CONNECTED',
   'STATE_CONNECTING',
   'STATE_DISCONNECTED',
   'WIDGET_PROPERTIES_COL_WIDTH',

   -- gamestrings.lua
   'mutatorDefinitions',

   -- LuaVariables.txt
   'deltaTime',
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
   'showScores',
   'teamColors',
   'weaponDefinitions',
   'widgets',
   'world',

   -- LuaFunctions.txt
   'consoleGetVariable',
   'consolePerformCommand',
   'consolePrint',
   'isInMenu',
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
   'nvgTextWidth',
   'playSound',
   'registerWidget',
   'saveUserData',
   'textRegion',
   'textRegionSetCursor',
   'widgetCreateConsoleVariable',
   'widgetSetConsoleVariable',
}

-- CatoHUD
self = false
allow_defined_top = true

ignore = {
   -- math
   'clamp',
   'rad2deg',
   -- debug
   'consoleColorPrint',
   'consoleTablePrint',
}
