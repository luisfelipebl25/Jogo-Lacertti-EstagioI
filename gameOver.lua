
local composer = require( "composer" )

local scene = composer.newScene()

--som fundo gameover
--local SoundGameOver


-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoMenu()
	local options = { effect = "fade", time = 800}
    composer.gotoScene( "menu", options)
end
 
local function gotoHighScores()
    composer.gotoScene( "highscores" )
end

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()



local StartDisplay = display.newImageRect( backGroup, "GameOver.png", 360, 570 )
StartDisplay.x = display.contentCenterX
StartDisplay.y = display.contentCenterY

StartDisplay:addEventListener("tap", gotoMenu)
--[[local playButton = display.newText( uiGroup, "Play", display.contentCenterX, display.contentCenterY+100, native.systemFont, 44 )
playButton:setFillColor( 0.82, 0.86, 1 )

local highScoresButton = display.newText( uiGroup, "High Scores", display.contentCenterX, display.contentCenterY+150, native.systemFont, 44 )
highScoresButton:setFillColor( 0.75, 0.78, 1 )
]]--

local mensagemFim = display.newText( uiGroup, "Jogar Novamente", display.contentCenterX, display.contentCenterY - 200, native.systemFont, 20 )
mensagemFim:setFillColor( 0.82, 0.86, 1 )




-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	sceneGroup:insert(backGroup)
	sceneGroup:insert(mainGroup)
	sceneGroup:insert(uiGroup)
	--playButton:addEventListener( "tap", gotoGame )
    --highScoresButton:addEventListener( "tap", gotoHighScores )
    

	--texto Inicial logo do jogo
	--local title = display.newImageRect( sceneGroup, "title.png", 500, 80 )
    --title.x = display.contentCenterX
   --title.y = 200

  
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
