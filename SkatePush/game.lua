local composer = require( "composer" )
local scene = composer.newScene()


local physics = require("physics")
physics.start()
physics.setGravity(0,0)

math.randomseed(os.time())


-- Game Variables --
local addForceTimer
local isClickMouse = false
local canDeploy = true
local addForceV = 100

local angleRadians
local angleDegree
local scoreText
local score = 0 
local directionSB
local sk_main
local character_spawn_timer
local character_spawn_timer_max = 3000
local character_spawn_timer_min = 1000
local characterMS = 2

local backGroup
local mainGroup
local uiGroup

local characterTable = {}
local characterTableSecond = {}
local boardTable = {}

local player
local background 
local skate_sfx
-- Game Variables End --
-- Sprite Initialization -- 
audio.setVolume(0.2 )
local sheetSkate = {
    
        frames = {
            {
                x = 0,
                y = 0,
                width = 32,
                height = 32  
            },
            {
                x = 32,
                y = 0,
                width = 32,
                height = 32  
            }
        }
    
}
local sheetSkateInit = graphics.newImageSheet("Board_Prop.png",sheetSkate )
local sequence_Board_idle = {
    {
        name = "idle",
        start = 1,
        count = 2,
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    }
}
local sheetSkateMC = {
    frames = {
        {
            x = 0,
            y = 0,
            width = 32,
            height = 32  
        },
        {
            x = 32,
            y = 0,
            width = 32,
            height = 32  
        }
    }
}
local sheetSkateMCInit = graphics.newImageSheet( "Board_Prop_Main.png", sheetSkateMC )
local sequence_BoardMC_idle = {
    {
        name = "idle",
        start = 1,
        count = 2,
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    }
}
local sheetCharacter = {
    frames = {
        { x = 0, y = 0, width = 32, height = 32 },
        { x = 32, y = 0, width = 32, height = 32 },
        { x = 64, y = 0, width = 32, height = 32 },
        { x = 96, y = 0, width = 32, height = 32 },
        { x = 128, y = 0, width = 32, height = 32 },
        { x = 160, y = 0, width = 32, height = 32 }
    }
}
local sheetCharacterInit = graphics.newImageSheet("Idle_Char_Blonde.png", sheetCharacter)
local sequence_Character_idle = {
    {
        name = "idle",
        start = 1,
        count = 6,
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    }
}
local sheetCharacterSB = {
    frames = {
        { x = 0, y = 0, width = 32, height = 32 },
        { x = 32, y = 0, width = 32, height = 32 },
        { x = 64, y = 0, width = 32, height = 32 },
        { x = 96, y = 0, width = 32, height = 32 },
        { x = 128, y = 0, width = 32, height = 32 },
        { x = 160, y = 0, width = 32, height = 32 }
    }
}
local sheetCharacterSBInit = graphics.newImageSheet("Board_Char_Blonde.png", sheetCharacter)
local sequence_CharacterSB_idle = {
    {
        name = "idle",
        start = 1,
        count = 6,
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    }
}
-- Sprite Initialization End -- 
 -- Game Functions --
--[[local function addForce()
    print("Adding Force")
    addForceV = addForceV +  50
    if addForceV >= 300 then
        addForceV = 300
    end 

--end--]]
local function spawnCharacterSB(Oldcharacter)
    local character = nil
    for i = 1, #characterTableSecond do 
        if not characterTableSecond[i].isVisible then
            character = characterTableSecond[i]
            break
        end
    end 
    if character then 
        character.isVisible = true
        --character.isBodyActive = true
        character.x = Oldcharacter.x 
        character.y = Oldcharacter.y
        character.xScale = Oldcharacter.xScale
        print("Character x is " .. character.x .. " Character y is " .. character.y)
    end 
end 
local function onLocalCollision(self,event)
    if(event.phase == "began" and event.other.isVisible == true) then
        if((event.other.myName == "Character" and self.myName == "Board") and (event.other.isVisible == true and self.isVisible == true)) then
            print("Self myName: " .. self.myName .. " Event other myName: " .. event.other.myName) 
            self.isVisible = false
            event.other.isVisible = false
            score = score + 1 
            scoreText.text = "Score: " .. score
            --self.isBodyActive = false
            --event.other.isBodyActive = false
            canDeploy = true
            timer.performWithDelay(1, function()
                spawnCharacterSB(event.other)
            end)
        end
    end

end 

local function spawnCharacter()
    local character = nil
    for i = 1, #characterTable do 
        if not characterTable[i].isVisible then
            character = characterTable[i]
            break
        end
    end
    if character then
       character.isVisible = true
       character.isBodyActive = true
       local randNum 
       if math.random(2) == 1 then
          character.x = -10
          character.y = math.random(display.contentCenterY + 50, 630)
       else
           character.x = 490
           character.y = math.random(10, display.contentCenterY - 50)
       end

    end 
end 
local function spawnBoards()
    local board = nil
    for i = 1, #boardTable do
        if not boardTable[i].isVisible then 
            board = boardTable[i]
            break
        end
    end 
    if board  and angleRadians ~= nil then
        canDeploy = false
        board.isVisible = true
        board.isBodyActive = true
        board.rotation = sk_main.rotation + 90
        board.x = 240
        board.y = 320
        board.collision = onLocalCollision
        local speed = 300 -- Adjust the speed as needed
        local vx = math.cos(math.rad(angleDegree)) * speed
        local vy = math.sin(math.rad(angleDegree)) * speed

        board:setLinearVelocity(vx, vy)
        --local impulseMag = 0.1
        --local impulseX = math.cos(angleRadians)*impulseMag
        --local impulseY = math.sin(angleRadians)*impulseMag
        --board:applyLinearImpulse(impulseX,impulseY,board.x,board.y)
        print("x = " .. board.x .. " ".. "y = " .. board.y .. " index is " .. board.index .. " rotation in degrees " .. board.rotation .. " sk rotation is " .. sk_main.rotation .. " speed is " .. addForceV )
    end
end 

local function TrackBoards()
    for i = 1, #boardTable do
        local board = boardTable[i]
        if board.isVisible then
            --print("x = " .. board.x .. " ".. "y = " .. board.y)
            if (board.x >= 480 or board.x <= 0) or (board.y >= 640 or board.y <= 0) then
                board.isVisible = false
                board.isBodyActive = false
                audio.stop()
                --board.rotation = sk_main.rotation + 90
                canDeploy = true
                print("Out of Bounds!" .. " ".. board.index )
                composer.gotoScene( "menu",{time = 800, effect = "crossFade"})
                score = 0 
                print("Game Over!")
            end
            
        end
    end
end 
local function TrackCharSB()
    for i = 1, #characterTableSecond do 
        local charSb = characterTableSecond[i]
        if charSb.isVisible then 
            if (charSb.x >= 480 or charSb.x <= 0) or (charSb.y >= 640 or charSb.y <= 0) then
                charSb.isVisible = false
                charSb.isBodyActive = false
                audio.stop()
            end
        end
    end
end
--[[local function forceTimer()
    if(isClickMouse and canDeploy) then
        --print("Mouse Clicked")
        addForceTimer = timer.performWithDelay(500, addForce, 3)
    elseif(not isClickMouse and canDeploy ~= true) then
        addForceV = 50
    end
end--]]
local function updateRotation(event)
    local cursorX = event.x
    local cursorY = event.y
    local deltaX = cursorX - sk_main.x
    local deltaY = cursorY - sk_main.y
    if  event.phase == "moved" then
        isClickMouse = true
        --addForceTimer = timer.performWithDelay(500, addForce, 3)
        angleRadians = math.atan2(deltaY,deltaX)
        angleDegree = math.deg(angleRadians)

        sk_main.rotation = angleDegree
        --print(sk_main.rotation .. " Degree")
    end
    if event.phase == "ended"  and canDeploy then
        isClickMouse = false
        audio.play(skate_sfx)
        --timer.cancel( addForceTimer )
        spawnBoards()
    end
end

local function createBoards()
    local newBoard = display.newSprite( sheetSkateInit, sequence_Board_idle )
    physics.addBody( newBoard,"dynamic",{density = 0, friction = 0,isSensor = true})
    newBoard.myName = "Board"
    newBoard.isVisible = false
    newBoard.isBodyActive = false
    newBoard.x = display.contentCenterX
    newBoard.y = display.contentCenterY
    newBoard.index = #boardTable + 1
    newBoard.collision = onLocalCollision
    newBoard:addEventListener("collision")
    return newBoard
end
local function createChar()
    local newChar =display.newSprite( sheetCharacterInit, sequence_Character_idle )
    physics.addBody( newChar,"kinematic",{density = 0, friction = 0})
    newChar.myName = "Character"
    newChar.isVisible = false
    newChar.isBodyActive = false
    --newChar.width = 100
    --newChar.height = 100
    --newChar:scale(4,4)
    newChar:play()
    local randNum 
    if math.random(2) == 1 then
       newChar.direction = 1
       newChar.x = -10
       newChar.y = math.random(display.contentCenterY + 50, 630)
    else
        newChar.direction = 0
        newChar.x = 490
        newChar.y = math.random(10, display.contentCenterY - 50)
    end
    

    local function characterMovement()
        if newChar.direction == 1 then
            directionSB = 1
            newChar.xScale = -1
            newChar.x = newChar.x + characterMS
            --print( "Character going right" )
            if newChar.x >= 490 then
                newChar.direction = 0
            end
        elseif newChar.direction == 0 then
            --print( "Character going left" )
            directionSB = 0
            newChar.xScale = 1
            newChar.x = newChar.x - characterMS
            if newChar.x <= -10 then
                newChar.direction = 1
            end
        end
    end
    Runtime:addEventListener("enterFrame",characterMovement)
    
    return newChar
end 

local function createSBChar()
    local newCharSB =display.newSprite( sheetCharacterSBInit, sequence_CharacterSB_idle)
    physics.addBody( newCharSB,"kinematic",{density = 0, friction = 0})
    newCharSB.myName = "CharacterSB"
    newCharSB.isVisible = false
    newCharSB.isBodyActive = false

    local function characterMovementSB()
        if directionSB == 1 then
            newCharSB.x = newCharSB.x + characterMS + 1
            newCharSB.xScale = -1
        elseif directionSB == 0 then
            newCharSB.x = newCharSB.x - characterMS - 1
            newCharSB.xScale = 1
        end 

    end
    Runtime:addEventListener("enterFrame",characterMovementSB)
    return newCharSB
end


function scene:create( event )
 
    local sceneGroup = self.view
    physics.pause()
    
    backGroup = display.newGroup()
    sceneGroup:insert(backGroup)
    
    mainGroup = display.newGroup()
    sceneGroup:insert(mainGroup)
    
    uiGroup = display.newGroup()
    sceneGroup:insert(uiGroup)
    background =display.newImageRect( backGroup, "back_ground.png",display.contentWidth, display.contentHeight, 1, 1 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    sk_main =display.newSprite(sheetSkateMCInit,sequence_BoardMC_idle )
    physics.addBody( sk_main,"static",{density = 0, friction = 0} )
    sk_main.myName = "HolderSkate"
    sk_main.x = display.contentCenterX
    sk_main.y = display.contentCenterY
    sk_main:play()
    sk_main.isVisible = true
    score = 0
    scoreText = display.newText( uiGroup,"Score: " .. score,display.contentCenterX,display.contentCenterY - 200,"04B_30__.ttf", 30 )
    scoreText:setFillColor(1,1,1)
    skate_sfx =audio.loadSound(  "skate-sfx.mp3"  )
    --sk_main:scale(4,4)


    for i = 1, 10 do
        local board = createBoards()
        table.insert( boardTable,board )
    end

    for i = 1, 10 do
        local character = createChar()
        table.insert( characterTable, character )
    end 

    for i = 1, 10 do
        local character = createSBChar()
        table.insert( characterTableSecond, character )
    end 


end


function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
    

    if ( phase == "will" ) then
       sk_main.isVisible = true
        
       
 
    elseif ( phase == "did" ) then
        physics.start()
        Runtime:addEventListener("touch", updateRotation)
        Runtime:addEventListener("enterFrame", TrackBoards)
        Runtime:addEventListener("enterFrame",TrackCharSB)


        character_spawn_timer = timer.performWithDelay( math.random(character_spawn_timer_min,character_spawn_timer_max), spawnCharacter, -1 )
        --Runtime:addEventListener("enterFrame",forceTimer)

 
    end
end

 

function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        physics.pause()
        score = 0
        timer.cancel( character_spawn_timer )
        sk_main.isVisible = false
        for i = 1, #characterTable do 
            local char = characterTable[i]
            char.isVisible = false
        end
        for i = 1, #characterTableSecond do 
            local char = characterTableSecond[i]
            char.isVisible = false
        end
 
    elseif ( phase == "did" ) then
        Runtime:removeEventListener("touch", updateRotation)
        Runtime:removeEventListener("enterFrame",TrackBoards)
        Runtime:removeEventListener("enterFrame",TrackCharSB)
 
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