-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

-- Iniciando a fisica -- 
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )
physics.setDrawMode( "hybrid" )
-- Gerador de numeros random para inimigos--
math.randomseed( os.time() )




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
-- Sequência de animação do hawk Purple --
local sequencesHawkPurple = {
    {
        name = "fly",
        start = 1,
        count = 2,
        time = 500,
        loopCount = 0,
        loopDirection = "forward"
    }
}
-- Sequência de animação do hawk Blue --
local sequencesHawkBlue = {
    {
        name = "fly",
        start = 3,
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
--local voar = display.newSprite(objectSheet, sequences, { isSensor = true } )


-- Inicializando as variaveis--
local tipoFruta = 7
local lives = 3
local score = 0
local died = false

-- criando tabelas
local enemyTable = {}
local fliesTable = {}

local lacertti
local gameLoopTimer
local livesText
local scoreText

-- variavel de velocidade do background -- 
local scrollSpeed = 1

-- Configurando grupos de exibicao--
local backGroup = display.newGroup()  -- Grupo de imagens background
local mainGroup = display.newGroup()  -- Grupo de imagens (inimigos, frutas, moscas)
local uiGroup = display.newGroup()    -- Grupo de Textos de pontuacao 

-- Carregando plano BackCeu --
local sky = display.newImageRect( backGroup, "skyDegra.png", 360, 570 )
sky.x = display.contentCenterX
sky.y = display.contentCenterY

-- transition.moveBy(background1, {y=900, time=50000})

-- Carregando plano BackRochedo --
local rock = display.newImageRect( backGroup, "RockGreen.png", 360, 1000 )
rock.x = display.contentCenterX
rock.y = display.contentCenterY

--transition.moveBy(RockGreen, {y=0000, time=3000})
transition.moveBy( rockTransition, { x=0, y=570, time=9000 } )


--Carregar loop arvore -- 
local stalk = display.newImageRect( backGroup, "stalk.png", 360, 570 )
stalk.x = display.contentCenterX
stalk.y = display.contentCenterY

local stalk2 = display.newImageRect( backGroup, "stalk.png", 360, 570 )
stalk2.x = display.contentCenterX
stalk2.y = display.contentCenterY - display.actualContentHeight

local stalk3 = display.newImageRect( backGroup, "stalk.png", 360, 570 )
stalk3.x = display.contentCenterX
stalk3.y = display.contentCenterY - display.actualContentHeight

local stalk4 = display.newImageRect( backGroup, "stalk.png", 360, 570 )
stalk4.x = display.contentCenterX
stalk4.y = display.contentCenterY - display.actualContentHeight


--transition.moveBy(background3, {y=3000, time=25000})



--carregando Personagem--
--lacertti = display.newImageRect(mainGroup, objectSheet, 10 , 50 , 120)
lacertti = display.newSprite(objectSheet1, sequencesLacertti, { isSensor = true } )
lacertti.x = display.contentCenterX 
lacertti.y = display.contentHeight - 10
lacertti.xScale = 0.6
lacertti.yScale = 0.6
lacertti.isVisible = true
--Criando sequência--
lacertti:setSequence("walk")
lacertti:play()

--Adicionando fisica ao lacertti--
physics.addBody( lacertti, { radius=20, isSensor=true } )
lacertti.myName = "lacertti"

--Mostrando Vidas e Pontos
livesText = display.newText( uiGroup, "Lives: " .. lives, 200, 80, native.systemFont, 18 )
--scoreText = display.newText( uiGroup, "Score: " .. score, 400, 80, native.systemFont, 36 )
livesText:setFillColor(0.180, 0.65, 0.35  )

scoreText = display.newText( uiGroup, "Score: " .. score, display.contentCenterX-80 , 80, native.systemFont, 18 )
scoreText:setFillColor(0.180, 0.65, 0.35  )
-- Hide the status bar
--display.setStatusBar( display.HiddenStatusBar )

----Funçao de atualizacao das variaveis pontos ------
local function updateText()
    livesText.text = "Lives: " .. lives
    scoreText.text = "Score: " .. score
    --scoreText:setFillColor(0.180, 0.65, 0.35  )
	--scoreText.text = "Score: " .. score
end

------------------------------------ Função de criação do inimigos ---------------------------
local function creatingEnemyPurple()
    --local newEnemy = display.newImageRect( mainGroup, objectSheet, 1, 100, 113 )
    local newEnemy = display.newSprite(objectSheet1, sequencesHawkPurple, { isSensor = true } )
    table.insert( enemyTable, newEnemy )
    physics.addBody( newEnemy, "dynamic", { radius=40, isSensor = true } ) -- bounce=0.8 } )
    --Propriedade de inimigo--
    newEnemy.myName = "enemy"

    --COLOCAÇAO--
    local whereFrom = math.random( 3 )

    if ( whereFrom == 1 ) then
        --from left 
       newEnemy.x = -60
        newEnemy.y = math.random(500)
        newEnemy:setLinearVelocity(math.random(40,120), math.random(20,60))
    elseif (whereFrom == 2 ) then
        --From the top
        newEnemy.x = math.random( display.contentWidth)
        newEnemy.y = -60
        newEnemy:setLinearVelocity(math.random(-40,40), math.random(40,120))
        -- from the right
    elseif (whereFrom == 3) then
        newEnemy.x = display.contentWidth + 60
        newEnemy.y = math.random(500)
        newEnemy:setLinearVelocity(math.random(-120,-40), math.random(20,60))
    end
    newEnemy.isVisible = true;
    newEnemy:setSequence("fly")
    newEnemy:play()
end
------------------------------Criação de Inimigo azul----------------------------------------------
local function creatingEnemyBlue()
    
    --local newEnemy = display.newImageRect( mainGroup, objectSheet, 1, 100, 113 )
    local newEnemy = display.newSprite(objectSheet1, sequencesHawkBlue, { isSensor = true } )
    table.insert( enemyTable, newEnemy )
    physics.addBody( newEnemy, "dynamic", { radius=40, isSensor = true } ) -- bounce=0.8 } )
    --Propriedade de Inimigo--
    newEnemy.myName = "enemy"

    --COLOCAÇAO--
    local whereFrom = math.random( 3 )

    if ( whereFrom == 1 ) then
        --from left 
        newEnemy.x = -60
        newEnemy.y = math.random(display.contentCenterY)
        newEnemy:setLinearVelocity(math.random(40,120), math.random(20,60))
        --transition.to(newEnemy, {x=display.contentWidth + 60, time = 3000, onComplete = function() display.remove(newEnemy) end } )
    elseif (whereFrom == 2 ) then
        --From the top
        newEnemy.x = math.random( display.contentWidth)
        newEnemy.y = -60
        newEnemy:setLinearVelocity(math.random(-40,40), math.random(40,120))
    elseif (whereFrom == 3) then
        --From right
        newEnemy.x = display.contentWidth + 60
        newEnemy.y = math.random(display.contentCenterY)
        newEnemy:setLinearVelocity(math.random(-120,-40), math.random(20,60))
    end
    newEnemy.isVisible = true;
    newEnemy:setSequence("fly")
    newEnemy:play()
end

local function generateEnemy()

    local tipo = math.random(1,2)
    if(tipo == 1 ) then
        creatingEnemyPurple()
    else
        creatingEnemyBlue()
    end
end
------------------------------Criação de moscas----------------------------------------------
 
local function creatingFliesPurple()
     --display.newImageRect ou display.newSprite
     --local newEnemy = display.newImageRect( mainGroup, objectSheet, 1, 100, 113 )
     local newFly = display.newSprite(objectSheet2, sequencesFliesPurple, { isSensor = true } )
     table.insert( fliesTable, newFly )
     physics.addBody( newFly, "dynamic", { radius=20, isSensor = true } ) -- bounce=0.8 } )
     --Propriedade de Inimigo--
     newFly.myName = "flies"

    --COLOCAÇAO--
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
     local newFly = display.newSprite(objectSheet2, sequencesFliesRed, { isSensor = true } )
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

-------------------------------Gerando moscas ------------------------- 
local function generateFlies()

    local tipo = math.random(1,2)
    if(tipo == 1 ) then
        creatingFliesPurple()
    else
        creatingFliesRed()
    end
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
    local posicao = lacertti.x + motionx
    if (posicao > 80 and posicao < display.contentWidth-85) then
        lacertti.x = posicao
    end
end
Runtime:addEventListener("enterFrame", movePlayer)
 
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

------------- Translate do BackGround ----------------------------------------------------

local function move( event )

    --if( movimento == true ) then
        stalk.y = stalk.y + scrollSpeed
        stalk2.y = stalk2.y + scrollSpeed
        stalk3.y = stalk3.y + scrollSpeed
        stalk4.y = stalk4.y + scrollSpeed
        if ( stalk.y - display.contentHeight / 2 > display.contentHeight + 100 ) then 
            stalk:translate( 0, -stalk.contentHeight * 2 )
        end
        if ( stalk2.y - display.contentHeight / 2 > display.contentHeight + 100 ) then
            stalk2:translate( 0, -stalk2.contentHeight * 2 )
        end
        if ( stalk3.y - display.contentHeight / 2 > display.contentHeight + 100 ) then
            stalk3:translate( 0, -stalk2.contentHeight * 2 )
        end
        if ( stalk4.y - display.contentHeight / 2 > display.contentHeight + 100 ) then
            stalk4:translate( 0, -stalk4.contentHeight * 2 )
        end
    --end
end
    

local function updateFrame()
    move()
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
    lives = lives - 1
    livesText.text = "Lives: " .. lives
    if ( lives == 0 ) then
        display.remove( lacertti )
    end    
end

----------------------------------------------------------------------

local function removeInimigo(inimigo)

    display.remove(inimigo)
    for i = #enemyTable, 1, -1 do
        if ( enemyTable[i] == inimigo ) then
            table.remove( enemyTable, i)
            break
        end
    end
end

----------------------------------------------------------------------


    ----função colisão e pontuação----
local function onCollision( self,event )
 
    if ( event.phase == "began" ) then
        --objtos de colisão--
        local obj1 = event.target -- lacertti
        local obj2 = event.other -- fruit ou flies
       
        if( obj2.myName == "fruit") then
            display.remove(obj2)
            score = score + 50
            scoreText.text = "Score: " .. score
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
        elseif( obj2.myName == "enemy") then
            removeInimigo(obj2)
            obj1.alpha = 0
            timer.performWithDelay(1000, restoreLacertti)
        end   
    end
end
----
---------------------------------
lacertti.collision = onCollision
lacertti:addEventListener("collision")

-- Adicionando açoes a variavel sky(toque=tap, velocidade do personagem)
sky:addEventListener("touch", playerVelocity)
timer.performWithDelay(3000, generateEnemy, 0 )
timer.performWithDelay(2000, generateFlies, 0 )
timer.performWithDelay(5000, createFruit, 0 )
Runtime:addEventListener("enterFrame", updateFrame )
--Runtime:addEventListener( "collision", onCollision )