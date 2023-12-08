local index = 1
config = {
    controls = {
        quit = 194, -- [[BACKSPACE]]
        goUp = 85, -- [[Q]]
        goDown = 48, -- [[Z]]
        turnLeft = 34, -- [[A]]
        turnRight = 35, -- [[D]]
        goForward = 32,  -- [[W]]
        goBackward = 33, -- [[S]]
        changeSpeed = 21, -- [[L-Shift]]
        save = 191, -- [[ENTER]]
    },

    speeds = {
        { label = "Very Slow", speed = 0},
        { label = "Slow", speed = 0.05},
        { label = "Normal", speed = 1},
        { label = "Fast", speed = 2},
        { label = "Very Fast", speed = 3},
        { label = "Extremely Fast", speed = 5},
        { label = "Extremely Fast v2.0", speed = 10},
        { label = "Max Speed", speed = 15}
    },

    offsets = {
        y = 0.5, 
        z = 0.2,
        h = 3,
    },

    bgR = 0,
    bgG = 0,
    bgB = 0,
    bgA = 80,
}

RegisterCommand('coords', function()
	TriggerEvent("coordsSaver:saveCoord")
end)

AddEventHandler("coordsSaver:saveCoord", function()
    currentSpeed = config.speeds[index].speed
    buttons = zmrdeDamTiPestisetupScaleform("instructional_buttons")
    
	while true do 
		Wait(0)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local heading = GetEntityHeading(ped)
        local dir = headingToVector(heading-90)
		drawTxt("x= "..tenth(coords.x,2).." y= "..tenth(coords.y,2).." z= "..tenth(coords.z,2).." dirX= "..tenth(dir.x,2).." dirY= "..tenth(dir.y,2))
		DrawMarker(	
				26, coords,
				dir.x, dir.y, 0,
				0, 0, 0,
				0.5, 0.5, 0.5,
				255, 255, 255, 255,
				false, false, nil, false
				)

        DrawScaleformMovieFullscreen(buttons)
            
        local yoff = 0.0
        local zoff = 0.0

        if IsControlJustPressed(1, config.controls.changeSpeed) then
            if index ~= 8 then
                index = index+1
                currentSpeed = config.speeds[index].speed
            else
                currentSpeed = config.speeds[1].speed
                index = 1
            end
            zmrdeDamTiPestisetupScaleform("instructional_buttons")
        end
            
            disableControls()

        if IsDisabledControlPressed(0, config.controls.goForward) then
            yoff = config.offsets.y
        end
        
        if IsDisabledControlPressed(0, config.controls.goBackward) then
            yoff = -config.offsets.y
        end
        
        if IsDisabledControlPressed(0, config.controls.turnLeft) then
            SetEntityHeading(ped, GetEntityHeading(ped)+config.offsets.h)
        end
        
        if IsDisabledControlPressed(0, config.controls.turnRight) then
            SetEntityHeading(ped, GetEntityHeading(ped)-config.offsets.h)
        end
        
        if IsDisabledControlPressed(0, config.controls.goUp) then
            zoff = config.offsets.z
        end
        
        if IsDisabledControlPressed(0, config.controls.goDown) then
            zoff = -config.offsets.z
        end

        if IsDisabledControlPressed(0, config.controls.quit) then 
            SetEntityVisible(ped, true)  
            SetEntityCollision(ped, true, true)
            return
        end		

        if IsDisabledControlPressed(0, config.controls.save) then 
            	SendNUIMessage({
            		coords = ""..tenth(coords.x,2)..","..tenth(coords.y,2)..","..tenth(coords.z,2)..","..tenth(dir.x,2)..","..tenth(dir.y,2)
            	})
                SetEntityVisible(ped, true)  
                SetEntityCollision(ped, true, true)
            	return
        end

        local newPos = GetOffsetFromEntityInWorldCoords(ped, 0.0, yoff * (currentSpeed + 0.01), zoff * (currentSpeed + 0.01))
        local heading = GetEntityHeading(ped)
        SetEntityVelocity(ped, 0.0, 0.0, 0.0)
        SetEntityRotation(ped, 0.0, 0.0, 0.0, 0, false)
        SetEntityHeading(ped, heading)
        SetEntityCoordsNoOffset(ped, newPos.x, newPos.y, newPos.z, noclipActive, noclipActive, noclipActive)
        SetEntityVisible(ped, false, 0)
        SetEntityCollision(ped, false, false)
	end	
end)

function zmrdeDamTiPestisetupScaleform(scaleform)

    local scaleform = RequestScaleformMovie(scaleform)

    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(1)
    end

    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(6)
    button(GetControlInstructionalButton(2, config.controls.quit, true))
    buttonMessage("Disable CoordSaver")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(5)
    button(GetControlInstructionalButton(2, config.controls.save, true))
    buttonMessage("SAVE")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(4)
    button(GetControlInstructionalButton(2, config.controls.goUp, true))
    buttonMessage("Go Up")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(3)
    button(GetControlInstructionalButton(2, config.controls.goDown, true))
    buttonMessage("Go Down")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    button(GetControlInstructionalButton(1, config.controls.turnRight, true))
    button(GetControlInstructionalButton(1, config.controls.turnLeft, true))
    buttonMessage("Turn Left/Right")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    button(GetControlInstructionalButton(1, config.controls.goBackward, true))
    button(GetControlInstructionalButton(1, config.controls.goForward, true))
    buttonMessage("Go Forwards/Backwards")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    button(GetControlInstructionalButton(2, config.controls.changeSpeed, true))
    buttonMessage("Change Speed ("..config.speeds[index].label..")")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(config.bgR)
    PushScaleformMovieFunctionParameterInt(config.bgG)
    PushScaleformMovieFunctionParameterInt(config.bgB)
    PushScaleformMovieFunctionParameterInt(config.bgA)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

function headingToVector(heading)
    local radians = heading * (math.pi / 180)
    local x = math.cos(radians)
    local y = math.sin(radians)
    local z = 0.0  
    return vector3(x, y, z)
end

function drawTxt(text)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0.5, 0.5)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.3,0.8)
end

function tenth(num, numDecimalPlaces) 
    local mult = 5^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end
function buttonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function button(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end

function disableControls()
    DisableControlAction(0, 30, true)
    DisableControlAction(0, 31, true)
    DisableControlAction(0, 32, true)
    DisableControlAction(0, 33, true)
    DisableControlAction(0, 34, true)
    DisableControlAction(0, 35, true)
    DisableControlAction(0, 266, true)
    DisableControlAction(0, 267, true)
    DisableControlAction(0, 268, true)
    DisableControlAction(0, 269, true)
    DisableControlAction(0, 44, true)
    DisableControlAction(0, 20, true)
    DisableControlAction(0, 74, true)
end