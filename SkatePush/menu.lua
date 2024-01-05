local composer = require("composer")
local scene = composer.newScene()

local backGroup
local uiGroup

local gameBgMusic
audio.reserveChannels( 1 )
audio.setVolume( 0.08 , {channel = 1} )

local MainText 

function scene:create(event)
    local sceneGroup = self.view
    gameBgMusic =audio.loadSound( "bg_music.mp3"  )

    backGroup = display.newGroup()
    sceneGroup:insert(backGroup)


    uiGroup = display.newGroup()
    sceneGroup:insert(uiGroup)

    local function playAgain()
        composer.gotoScene( "game",{time = 800, effect = "crossFade"})

    end 

    MainScoreText = display.newText( uiGroup, "SKATE CONNECT",display.contentCenterX,display.contentCenterY - 200,"04B_30__.ttf", 32)
    MainScoreText:setFillColor(0,0,0)
    background =display.newImageRect( backGroup, "back_ground.png",display.contentWidth, display.contentHeight, 1, 1 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    local playAgainButton =display.newText( uiGroup, "PLAY",display.contentCenterX,display.contentCenterY,"04B_30__.ttf", 24)
    playAgainButton:setFillColor(0,0,0)
    playAgainButton:addEventListener("tap",playAgain)

    local tutText = display.newText( uiGroup, "HOLD MOUSE TO AIM AND RELEASE", display.contentCenterX, display.contentHeight - 60,"04B_30__.ttf", 16 )
    local tutSecText = display.newText( uiGroup, "DON'T LET THE BOARD CROSS THE BOUNDARY", display.contentCenterX, display.contentHeight - 40,"04B_30__.ttf", 10 )
    local tutThirdText = display.newText( uiGroup, "CONNECT THE PASSERBY'S WITH A BOARD", display.contentCenterX, display.contentHeight - 20,"04B_30__.ttf", 10 )

end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if(phase == "will") then

    elseif(phase == "did") then
       
        audio.play(gameBgMusic, {channel=1,loops=-1})

    end
end

function scene:destroy(event)
    local sceneGroup = self.view
    audio.dispose( gameBgMusic )
end

scene:addEventListener("create",scene)
scene:addEventListener( "show", scene )
return scene