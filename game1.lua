
local composer = require( "composer" )

local scene = composer.newScene()

local function gotoGameOver()
	local options = { effect = "fade", time = 800}
    composer.gotoScene( "gameOver", options)
end

local function gotoGame2()
	local options = { effect = "fade", time = 800}
    composer.gotoScene( "game2", options)
end

-- Iniciando a fisica -- 
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )
--physics.setDrawMode( "hybrid" )

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

--som efeito (comendo)
local lacerttiEating

--som fundo musical
local backgroundSound


local fimJogo = false
-- Configurando imagem de folha--
local sheetOptions1 =
{
    frames =
    {
        {   -- Enemy Hawk purple Open 1 --
         x = 0,
        y = 0,
        width = 100,
        height = 113
        },
        {   -- Enemy Hawk purple Close 2 --
        x = 0,
        y = 113,
        width = 100,
        height = 113
        },
        {   -- Enemy Hawk blue Open 3 --
        x = 0,
        y = 226,
        width = 100,
        height = 113
        },
        {   -- Enemy Hawk purple Close 4 --
        x = 0,
        y = 339,
        width = 100,
        height = 113
        },
        {   -- food flies blue 5 -- excluido
        x = 0,
        y = 452,
        width = 20,
        height = 25
        },
        {   -- food flies orange 6 -- excluido
        x = 0,
        y = 477,
        width = 20,
        height = 25
        },
        {   -- food fruit red 7 --
        x = 0,
        y = 502,
        width = 20,
        height = 20
        },
        {   -- food fruit yellow 8 --
        x = 0,
        y = 522,
        width = 20,
        height = 20
        },
        {   -- food fruit purple 9 --
        x = 0,
        y = 542,
        width = 20,
        height = 20
        },
        {   -- lacertti left 10 --
        x = 0,
        y = 562,
        width = 50,
        height = 120
        },
        {   -- lacertti right 11 --
        x = 0,
        y = 682,
        width = 50,
        height = 120
        },
    },
}
-- Configurando imagem de folha flies --
local sheetOptions2 =
{
    frames =
    {
        {   -- Enemy Flies purple Open 1 --
         x = 0,
        y = 0,
        width = 40,
        height = 25
        },
        {   -- Enemy Flies purple Close 2 --
        x = 0,
        y = 25,
        width = 40,
        height = 25
        },
        {   -- Enemy Flies red Open 1 --
         x = 0,
        y = 50,
        width = 40,
        height = 25
        },
        {   -- Enemy Flies red Close 2 --
        x = 0,
        y = 75,
        width = 40,
        height = 25
        },
    }
}

-- Configurando imagem de folha SNAKE --
local sheetOptions3 =
{
    frames =
    {
        {   -- Snake Enemy --
            x = 0,
            y = 0,
            width = 50,
            height = 123
        },
        {   -- Snake Enemy --
            x = 0,
            y = 123,
            width = 50,
            height = 123
        },
    }
}
-- Sequência de animação do SNAKE --
local sequencesSnake = {
    {
        name = "crawl",
        start = 1,
        count = 2,
        time = 500,
        loopCount = 0,
        loopDirection = "forward"
    }
}

-- Sequência de animação Lacertti --
local sequencesLacertti = {
    {
        name = "walk",
        start = 10,
        count = 2,
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    }
}
-- Sequência de animação flies purple --
local sequencesFliesPurple = {
    {
        name = "fly",
        start = 1,
        count = 2,
        time = 500,
        loopCount = 0,
        loopDirection = "forward"
    }
}
-- Sequência de animação flies red --
local sequencesFliesRed = {
    {
        name = "fly",
        start = 3,
        count = 2,
        time = 500,
        loopCount = 0,
        loopDirection = "forward"
    }
}
--Carregando folha de imagem e fazendo ref. a tabela sheetOptions --
local objectSheet1 = graphics.newImageSheet( "ElementsSheet.png", sheetOptions1 )
local objectSheet2 = graphics.newImageSheet( "SheetFlies.png", sheetOptions2 )
local objectSheet3 = graphics.newImageSheet("Snake.png", sheetOptions3)

-- Inicializando as variaveis--
local tipoFruta = 7
local tipoSnake = 1
local lives = 3
local score = 0
local MaxScore = score
local died = false

-- criando tabelas
--local enemyTable = {}
local fliesTable = {}
local snakeTable = {}

local lacertti
local gameLoopTimer
local livesText
local scoreText


-- variavel de velocidade do background -- 
local scrollSpeed = 2

local function updateText()
    livesText.text = "Lives: " .. lives
    scoreText.text = "Score: " .. score
end


---------------------------------------------------------------------------------------
local sky = display.newImageRect( backGroup, "sky.png", 360, 570 )
sky.x = display.contentCenterX
sky.y = display.contentCenterY

-------------------Carregar loop down teste --------------------- 
local down = display.newImageRect( backGroup, "down.png", 360, 570 )
down.x = display.contentCenterX
down.y = display.contentCenterY

local down2 = display.newImageRect( backGroup, "down.png", 360, 570 )
down2.x = display.contentCenterX
down2.y = display.contentCenterY - display.actualContentHeight

local down3 = display.newImageRect( backGroup, "down.png", 360, 570 )
down3.x = display.contentCenterX
down3.y = display.contentCenterY - display.actualContentHeight

local down4 = display.newImageRect( backGroup, "down.png", 360, 570 )
down4.x = display.contentCenterX
down4.y = display.contentCenterY - display.actualContentHeight
--------------------------------------------------------------------------------------
local function move( event )

    ----if( movimento == true ) then
        down.y = down.y + scrollSpeed
        down2.y = down2.y + scrollSpeed
        down3.y = down3.y + scrollSpeed
        down4.y = down4.y + scrollSpeed
        if ( down.y - display.contentHeight / 2 > display.contentHeight + 100 ) then 
            down:translate( 0, -down.contentHeight * 2 )
        end
        if ( down2.y - display.contentHeight / 2 > display.contentHeight + 100 ) then
            down2:translate( 0, -down2.contentHeight * 2 )
        end
        if ( down3.y - display.contentHeight / 2 > display.contentHeight + 100 ) then
            down3:translate( 0, -down2.contentHeight * 2 )
        end
        if ( down4.y - display.contentHeight / 2 > display.contentHeight + 100 ) then
            down4:translate( 0, -down4.contentHeight * 2 )
        end
    ----end
end
local function updateFrame()
    move()
end

local function updateFrame2()
    transition.to(rock, { y = display.contentHeight, time = 20000 })
end

----------------------------- Criando as Frutas -----------------------------------
local function createSnake()
    if(fimJogo == false) then
        local snake = display.newSprite(mainGroup, objectSheet3, sequencesSnake)
        if(tipoSnake ~= 9) then
            tipoSnake = tipoSnake + 1
        else
            tipoSnake = 1
        end
        snake.myName = "sting"
        snake.x = math.random(80, display.contentWidth - 85)
        snake.y = -50
        snake.isVisible = true;
        snake:setSequence("crawl")
        snake:play()
        physics.addBody( snake, "dynamic", { radius=5, isSensor = true } )
        transition.to(snake, { y = 570, time = 8000, onComplete = function() display.remove( snake ) end } )
    end   
   
end
------------------------------Criação de moscas roxas----------------------------------------------
 
local function creatingFliesPurple()
	--display.newImageRect ou display.newSprite
	--local newEnemy = display.newImageRect( mainGroup, objectSheet, 1, 100, 113 )
	local newFly = display.newSprite(mainGroup, objectSheet2, sequencesFliesPurple, { isSensor = true } )
	table.insert( fliesTable, newFly )
	physics.addBody( newFly, "dynamic", { radius=20, isSensor = true } ) -- bounce=0.8 } )
	--Propriedade de Inimigo--
	newFly.myName = "flies"

     ----------------------------Posição de Criação de mosca------------------------------
   local whereFrom = math.random( 3 )

   if ( whereFrom == 1 ) then
	   --from left 
	   newFly.x = -20
	   newFly.y = math.random(100)
	   newFly:setLinearVelocity(math.random(40,120), math.random(20,60))
	   transition.to(newFly, {x=display.contentWidth + 60, time = 3000, onComplete = function() display.remove(newFly) end } )
   elseif (whereFrom == 2 ) then
	   --From the top
	   newFly.x = math.random( display.contentWidth)
	   newFly.y = -20
	   newFly:setLinearVelocity(math.random(-40,40), math.random(40,120))
   elseif (whereFrom == 3) then
	   --From right
	   newFly.x = display.contentWidth + 60
	   newFly.y = math.random(100)
	   newFly:setLinearVelocity(math.random(-120,-40), math.random(20,60))
   end
   newFly.isVisible = true;
   newFly:setSequence("fly")
   newFly:play()
end
------------------------- Criação de moscas vermelhas -----------------------------------
local function creatingFliesRed()
	--display.newImageRect ou display.newSprite
	--local newEnemy = display.newImageRect( mainGroup, objectSheet, 1, 100, 113 )
	local newFly = display.newSprite(mainGroup, objectSheet2, sequencesFliesRed, { isSensor = true } )
	table.insert( fliesTable, newFly )
	physics.addBody( newFly, "dynamic", { radius=20, isSensor = true } ) -- bounce=0.8 } )
	--Propriedade de Inimigo--
	newFly.myName = "flies"

   ----------------------------Posição de Criação de mosca------------------------------
   local whereFrom = math.random( 3 )

   if ( whereFrom == 1 ) then
	   --from left 
	   newFly.x = -60
	   newFly.y = math.random(100)
	   newFly:setLinearVelocity(math.random(40,120), math.random(20,60))
	   transition.to(newFly, {x=display.contentWidth + 60, time = 3000, onComplete = function() display.remove(newFly) end } )
   elseif (whereFrom == 2 ) then
	   --From the top
	   newFly.x = math.random( display.contentWidth)
	   newFly.y = -60
	   newFly:setLinearVelocity(math.random(-40,40), math.random(40,120))
   elseif (whereFrom == 3) then
	   --From right
	   newFly.x = display.contentWidth + 60
	   newFly.y = math.random(100)
	   newFly:setLinearVelocity(math.random(-120,-40), math.random(20,60))
   end
   newFly.isVisible = true;
   newFly:setSequence("fly")
   newFly:play()
end

----------------------------- Criando as Frutas -----------------------------------
local function createFruit()
    local fruta = display.newImageRect(mainGroup, objectSheet1, tipoFruta, 20, 20)
    if(tipoFruta ~= 9) then
        tipoFruta = tipoFruta + 1
    else
        tipoFruta = 7
    end
    fruta.myName = "fruit"
    fruta.x = math.random(80, display.contentWidth - 85)
    fruta.y = -50
    physics.addBody( fruta, "dynamic", { radius=5, isSensor = true } )
    transition.to(fruta, { y = 570, time = 8000, onComplete = function() display.remove( fruta ) end } )
end

-------------------- MOVENDO O LAGARTO -------------------------------

motionx = 0 -- variavel usada para mover o lagarto ao longo do eixo x
speed = 8 -- velocidade do lagarto

local function movePlayer(event)
    if(lacertti.x ~= nil)then
        local posicao = lacertti.x + motionx
        if (posicao > 80 and posicao < display.contentWidth-85) then
            lacertti.x = posicao
        end
    end
end

 
 ------Toque Ouvinte, posicao a cada fase do evento------
function playerVelocity(event)
    if (event.phase == "began") then
    if event.x  >= display.contentCenterX then
    motionx = speed
    lacertti.xScale = 0
    elseif event.x <= display.contentCenterX then
    motionx = -speed
    lacertti.xScale = 0
end
elseif (event.phase == "ended") then
motionx = 0
end
end

local function gameStart()
    if(fimJogo == false)then
    --inimigoAzulLoopTimer = timer.performWithDelay(2000, creatingEnemyBlue, math.random(3))
    --inimigoRoxoLoopTimer = timer.performWithDelay(2000, creatingEnemyPurple, math.random(3))
        moscaRoxaLoopTimer = timer.performWithDelay(4000, creatingFliesPurple, math.random(3))
        moscaVermelhaLoopTimer = timer.performWithDelay(3000, creatingFliesRed, math.random(3))
        frutasLoopTimer = timer.performWithDelay(3000, createFruit, math.random(4))
        snakeEnemyLoop = timer.performWithDelay(3000, createSnake, math.random(4))
    end
end

---------------remove Inimigo -----------------
--local function removeInimigo(inimigo)
local function removeInimigo()

    for i = #snakeTable, 1, -1 do
        if ( snakeTable[i] == inimigo ) then
            table.remove( snakeTable, i)
            break
        end
    end
end

local function limpaTabelaInimigo()

    for i = #snakeTable, 1, -1 do
        local inimigo = snakeTable[i]
        if ( snakeTable[i] == inimigo ) then
            table.remove( snakeTable, i)
            break
        end
    end
    for i = #fliesTable, 1, -1 do
        local inimigo = fliesTable[i]
        if ( fliesTable[i] == inimigo ) then
            table.remove( fliesTable, i)
            break
        end
    end
end

local function gameLoop()

    removeInimigo()
end	

-----função restaurar (lacertti)------
local function restoreLacertti()
 
    lacertti.isBodyActive = false
    lacertti.x = display.contentCenterX
    lacertti.y = display.contentHeight - 10
 
    -- desvanecer o lacertti
    transition.to( lacertti, { alpha=1, time=4000,
        onComplete = function()
            lacertti.isBodyActive = true
            died = false
        end
    } )
    
    --[[if ( lives == 0 ) then
        display.remove( lacertti )
    end ]]--   
end

local function ToNextScene ()
    timer.performWithDelay(1000, gotoGame2, 1)
end

  ----função colisão e pontuação----
local function onCollision( self,event )
   local MaxPoints = 200
    if ( event.phase == "began" ) then
        --objtos de colisão--
        local obj1 = event.target -- lacertti
        local obj2 = event.other -- fruit ou flies
       
        if( obj2.myName == "fruit") then
            display.remove(obj2)
            score = score + 50
            scoreText.text = "Score: " .. score
            audio.play( lacerttiEating )
            --lacerttiEating = audio.loadSound( "audio/Eat.wav" )
            if (score == 500) then
                lives = lives + 1
                livesText.text = "Lives: " .. lives
            elseif (score == 1000) then
                lives = lives + 1
                livesText.text = "Lives: " .. lives
            elseif (score == 1500) then
                lives = lives + 1
                livesText.text = "Lives: " .. lives
            elseif (score == 2000) then
                lives = lives + 1
                livesText.text = "Lives: " .. lives
            end
        elseif( obj2.myName == "flies") then
            display.remove(obj2)
            score = score + 100
            scoreText.text = "Score: " .. score
            audio.play( lacerttiEating )
            -- lacerttiEating = audio.loadSound( "audio/Eat.wav" )
        elseif( obj2.myName == "sting") then
            --removeInimigo(obj2)
            lives = lives - 1
            livesText.text = "Lives: " .. lives
            if( lives ~= 0) then
                display.remove(obj2)
                obj1.alpha = 0
                timer.performWithDelay(1000, restoreLacertti)
            elseif(lives == 0) then
                Runtime:removeEventListener("enterFrame", movePlayer)
                display.remove(obj1)
                --composer.setVariable( "finalScore", score )
                --composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
                timer.performWithDelay(1000, gotoGameOver, 1)
            end
        end
        if (score >= MaxPoints)then
            fimJogo = true
            ToNextScene()
        end
    end--elseif(MaxScore == MaxPoints) then
        --print("score")
        --timer.performWithDelay(1000, gotoGame2, 1)
end







local gameLoopTimer = function() timer.performWithDelay( 500, gameLoop, 0 ) end
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------




-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	physics.pause()  -- Temporarily pause the physics engine

	 -- Set up display groups
	 --backGroup = display.newGroup()  -- Display group for the background image
	 sceneGroup:insert( backGroup )  -- Insert into the scene's view group
  
	 --mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
	 sceneGroup:insert( mainGroup )  -- Insert into the scene's view group
  
	 --uiGroup = display.newGroup()    -- Display group for UI objects like the score
	 sceneGroup:insert( uiGroup )    -- Insert into the scene's view group



------------------------------Carregando Personagem------------------------------
--lacertti = display.newImageRect(mainGroup, objectSheet, 10 , 50 , 120)
    lacertti = display.newSprite(mainGroup,objectSheet1, sequencesLacertti, { isSensor = true } )
    lacertti.x = display.contentCenterX 
    lacertti.y = display.contentHeight - 10
    lacertti.xScale = 0.6
    lacertti.yScale = 0.6
    lacertti.isVisible = true
    --Criando sequência--
    lacertti:setSequence("walk")
    lacertti:play()

    -----Adicionando fisica ao lacertti---
    physics.addBody( lacertti, { radius=20, isSensor=true } )
	lacertti.myName = "lacertti"
    
    lacertti.collision = onCollision
    lacertti:addEventListener("collision")

	-------Mostrando Vidas e Pontos-------
    livesText = display.newText( uiGroup, "Lives: " .. lives, 200, 80, native.systemFont, 18 )
    livesText:setFillColor(0.180, 0.65, 0.35  )

    scoreText = display.newText( uiGroup, "Score: " .. score, display.contentCenterX-80 , 80, native.systemFont, 18 )
    scoreText:setFillColor(0.180, 0.65, 0.35  )
	
    sky:addEventListener("touch", playerVelocity)
    
    -- Variavel de som
    lacerttiEating = audio.loadSound( "Eat.wav" )
    backgroundSound = audio.loadSound( "Firefly.wav")
    audio.play(backgroundSound, { loops = -1, fadein = 2000, channel = 1 } )
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		physics.start()
        Runtime:addEventListener("enterFrame", updateFrame )
        updateFrame2()
        gameLoopTimer = timer.performWithDelay(5000, gameStart,0)
        timer.performWithDelay(10000, gameLoopTimer, 1)
        Runtime:addEventListener("enterFrame", movePlayer)
        
         -- Start the music!
        audio.play( musicTrack, { channel=1, loops=-1 } )
        
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        physics.pause()
        timer.cancel(gameLoopTimer)
        --[[timer.cancel(moscaRoxaLoopTimer)
        timer.cancel(moscaVermelhaLoopTimer)
        timer.cancel(frutasLoopTimer)
        timer.cancel(snakeEnemyLoop)
        
        --timer.cancel(inimigoAzulLoopTimer)
        --timer.cancel(inimigoRoxoLoopTimer)
        --timer.cancel()]]
        limpaTabelaInimigo()

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
        --Runtime:removeEventListener("enterFrame", movePlayer)
        Runtime:addEventListener("enterFrame", movePlayer)
        Runtime:removeEventListener("enterFrame", updateFrame)
        -- Stop the music!
        --display.remove (mainGroup)
        --mainGroup = nil
        --display.remove(backGroup)
        --backGroup = nil
        audio.stop( 1 )
        composer.removeScene("game1")
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

     -- Dispose audio!
    --audio.dispose( lacerttiEating )
    audio.dispose( backgroundSound)
    

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
