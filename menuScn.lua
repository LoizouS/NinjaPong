local composer = require( "composer" )
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------
-- local forward references should go here

local title,multiplayerBtn,singleplayerBtn,settingsBtn,menuButtons,username,lastScore

local username,paddleColour



-- -------------------------------------------------------------------------------
  
-- "scene:create()"
function scene:create( event )
    local sceneGroup = self.view  
    local menuheight = 200
    --lastScore = 0
    composer.setVariable("username","User1")
    composer.setVariable("lastScore", "0")
    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.

    title = display.newText( {x=320, y = 50, text  = "MultiPong", fontSize = 80} )
    username = display.newText( {x=50, y = display.contentHeight-50, text  = composer.getVariable("username"), fontSize = 35} )

    singleplayerBtn = display.newText( {x=320,y=menuheight +0, text = "Single Player",fontSize = 45 } )
    multiplayerBtn =   display.newText( {x=320,y=menuheight+100, text = "MultiPlayer",fontSize = 45 } )
    settingsBtn =   display.newText( {x=320,y=menuheight+200, text = "Settings",fontSize = 45 } )
    lastScore = display.newText({x =320 , y=menuheight+300, text = composer.getVariable("lastScore"), fontSize = 45})
    sceneGroup:insert(lastScore)
    sceneGroup:insert(multiplayerBtn)
    sceneGroup:insert(singleplayerBtn)
    sceneGroup:insert(settingsBtn)
    sceneGroup:insert(title)
    sceneGroup:insert( username)
    composer.removeScene("splashScn")

    function multiplayerScnGoto( event )
        
        composer.gotoScene("multiplayerScn")
    
    end

    function mainSettingsGoto(event)
       -- if (event.phase=="ended") then
            composer.gotoScene("mainSettingsScn")
       -- end
    end

    function singleplayerGoto(event)
        
        composer.gotoScene("ninjaPongScn")
        
    end
                
    singleplayerBtn:addEventListener( "tap", singleplayerGoto )
    multiplayerBtn:addEventListener( "tap", multiplayerScnGoto )
    settingsBtn:addEventListener( "tap", mainSettingsGoto )


end


-- "scene:show()"
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).

    elseif ( phase == "did" ) then
        username.text=composer.getVariable("username")
        print(username.text.." in menu")
        lastScore.text = composer.getVariable("lastScore")
       
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
    end
end



-- "scene:destroy()"
function scene:destroy( event )
    local sceneGroup = self.view
 
    
    --title ,singleplayerBtn,multiplayerBtn = nil , nil ,nil
    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end

-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene