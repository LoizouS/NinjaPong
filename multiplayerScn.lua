local composer = require( "composer" )
local widget = require("widget")
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here
local title,numServers,servers,serverListTextOptions,serverListButtons,clearServerButtons
local servers= {}
-- -------------------------------------------------------------------------------


-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view
            function refreshServers(event)
            if (event.phase == "ended") then
                clearServerButtons()
                clients = {}
                numServers = 0
                client:scanServers()
                print( "refreshServers")
            end
        end

        function makeServer(event)
            if(event.phase == "ended") then
                client:stop( )
                client:stopScanning()
                print("makeserver is called")
                composer.gotoScene("startServer")
            end
        end
        function menuScnGoto(  event )
            if (event.phase=="ended") then

                composer.gotoScene("menuScn")
            end
        end
    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    sceneGroup:insert(widget.newButton( {label = "Make server", x = 320, y = 700, onEvent = makeServer, fontSize=20} ))
    sceneGroup:insert(widget.newButton(  {label = "Refresh servers", x = 320, y = 800, onEvent = refreshServers, fontSize=20} ))
    sceneGroup:insert(widget.newButton( {label = "Menu", x = 20, y = 900, onEvent = menuScnGoto, fontSize=20} ))
    title = display.newText( {x=320, y = 50, text  = "Multiplayer", fontSize = 80} )
    sceneGroup:insert( title)

    local serverListRect = display.newRect( sceneGroup,20, 120, 600, 400 )
    serverListRect.anchorX, serverListRect.anchorY = 0,0
    serverListRect.alpha = 0.2

    serverListButtons=display.newGroup()
    sceneGroup:insert(serverListButtons)
          
end


-- "scene:show()"
function scene:show( event )
    numServers=0

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
        client = require ("Client")
        client:start( )
        client:scanServers() 
    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
        client:stop( )
        client:stopScanning()
        clearServerButtons()
        Runtime:removeEventListener("autolanServerFound", autolanServerFound)
        Runtime:removeEventListener("autolanConnected", autolanConnected)
        Runtime:removeEventListener("autolanDisconnected", autolanDisconnected)
        Runtime:removeEventListener("autolanReceived", autolanReceived)
        Runtime:removeEventListener("autolanFileReceived", autolanFileReceived)
        Runtime:removeEventListener("autolanConnectionFailed", autolanConnectionFailed)
    elseif ( phase == "did" ) then

    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view
            --Runtime:removeEventListener("autolanServerFound", autolanServerFound)
        --[[Runtime:removeEventListener("autolanServerFound", autolanServerFound)
        Runtime:removeEventListener("autolanConnected", autolanConnected)
        Runtime:removeEventListener("autolanDisconnected", autolanDisconnected)
        Runtime:removeEventListener("autolanReceived", autolanReceived)
        Runtime:removeEventListener("autolanFileReceived", autolanFileReceived)
        Runtime:removeEventListener("autolanConnectionFailed", autolanConnectionFailed) ]]--


end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

----------------------------------------------------------------------------------------------------------
----------------------------Server Scanning Listerers-----------------------------------------------------
----------------------------------------------------------------------------------------------------------

local function addtoServerList()
            serverListTextOptions = {label = servers[#servers][2], fontSize = 30, x=320, y=150+numServers*35, textOnly = true, onEvent = function ()
                                     client:connect(servers[#servers][3])
                                    end}

            serverListButtons:insert(widget.newButton(serverListTextOptions))
end
local function autolanServerFound(event)
            print("broadcast", event.customBroadcast) --this is the user defined broadcast recieved from the server, it tells us about the server state.
            print("server name," ,event.serverName) --this is the name of the server device (from system.getInfo()). if you need more details just put whatever you need in the customBrodcast
            print("server IP:", event.serverIP) --this is the server IP, you must store this in an external table to connect to it later
            print("autolanServerFound")
            numServers = numServers +1
            servers[#servers+1] = {event.customBroadcast,event.serverName,event.serverIP}
            addtoServerList()
end
Runtime:addEventListener("autolanServerFound", autolanServerFound)

local function autolanConnected(event)
    print("broadcast", event.customBroadcast) --this is the user defined broadcast recieved from the server, it tells us about the server state.
    print("serverIP," ,event.serverIP) --this is the user defined broadcast recieved from the server, it tells us about the server state.
    print("connection established")
end
Runtime:addEventListener("autolanConnected", autolanConnected)



local function autolanDisconnected(event)
    print("disconnected b/c ", event.message) --this can be "closed", "timeout", or "user disonnect"
    print("serverIP ", event.serverIP) --this can be "closed", "timeout", or "user disonnect"
    print("autolanDisconnected") 
end
Runtime:addEventListener("autolanDisconnected", autolanDisconnected)

local function autolanReceived(event)
    print("message = ", event.message) --this is the message we recieved from the server
    print("autolanReceived")
end
Runtime:addEventListener("autolanReceived", autolanReceived)

local function autolanFileReceived(event)
    print("filename = ", event.filename) --this is the filename in the system.documents directory
    print("autolanFileReceived")
end
Runtime:addEventListener("autolanFileReceived", autolanFileReceived)

local function autolanConnectionFailed(event)
    print("serverIP = ", event.serverIP) --this indicates that the server went offline between discovery and connection. the serverIP is returned so you can remove it form your list
    print("autolanConnectionFailed")
end
Runtime:addEventListener("autolanConnectionFailed", autolanConnectionFailed)

function clearServerButtons()
    for i=1, serverListButtons.numChildren do
        serverListButtons[i]:removeSelf( )
        serverListButtons[i]=nil
    end
end

-- -------------------------------------------------------------------------------

return scene

