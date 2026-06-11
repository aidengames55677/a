-- "gamemodes\\mafiarp\\plugins\\cassette_player\\cl_plugin.lua"


local PLUGIN = PLUGIN

net.Receive("nutCassetteSync", function()
    local ent = net.ReadEntity()
    local type = net.ReadInt(32)
    local volume = net.ReadFloat()
    local channel = PLUGIN.RadioChannels[ent]

    local itemID = ent:getNetVar("cassetteID")
    if itemID == nil then return end

    if type == PLAY then
        if IsValid(channel) then
            if channel:GetState() == 2 then
                channel:Play()
            end
        elseif IsValid(channel) then
            if channel:GetState() == 0 && channel:GetTime() == channel:GetLength() then
                channel:SetTime(0)
                channel:Play()
            end
        elseif channel == nil then
            sound.PlayFile( "sound/"..nut.item.list[itemID].musicfile, "noplay 3d", function( station, errCode, errStr )
                if ( IsValid( station ) ) then
                    station:Play()
                    if ent:GetPos():DistToSqr(LocalPlayer():GetPos()) > PLUGIN.SoundStopDistance then
                        station:SetVolume(0)
                    else
                        station:SetVolume(0.5)
                    end
                    station:Set3DEnabled(true)
                    station:SetPos(ent:GetPos())
                    station:Set3DFadeDistance( PLUGIN.SoundFadeMin, PLUGIN.SoundFadeMax )
                    PLUGIN.RadioChannels[ent] = station

                    local timerID = "SyncAudioPosition"..ent:EntIndex()
                    timer.Create(timerID, PLUGIN.AudioPosUpdateFrequency, 0, function()
                        if (station != nil && ent != nil && station != NULL && ent != NULL) then
                            if ent:GetPos():DistToSqr(LocalPlayer():GetPos()) > PLUGIN.SoundStopDistance then
                                if IsValid(station) and station:GetVolume() != 0 then
                                    station:SetVolume(0)
                                end
                            else
                                if IsValid(station) and station:GetVolume() == 0 and ent.cassetteVolume ~= 0 then
                                    local volume = simfphys.IsCar(ent) and PLUGIN.DefaultCarVolume or PLUGIN.DefaultCPlayerVolume
                                    station:SetVolume(ent.cassetteVolume or volume)
                                end
                                station:SetPos(ent:GetPos())
                            end
                        else
                            timer.Remove(timerID)
                        end
                    end)
                end
            end )
        end
    elseif type == STOP then
        if IsValid(channel) then
            if channel:GetState() == 1 then
                channel:Pause()
            end
        end
    elseif type == LOAD then
        if IsValid(channel) then
            channel:Pause()
        end

        sound.PlayFile( "sound/"..nut.item.list[itemID].musicfile, "noplay 3d", function( station, errCode, errStr )
            if ( IsValid( station ) ) then
                station:Play()
                if ent:GetPos():DistToSqr(LocalPlayer():GetPos()) > PLUGIN.SoundStopDistance then
                    station:SetVolume(0)
                else
                    local volume = simfphys.IsCar(ent) and PLUGIN.DefaultCarVolume or PLUGIN.DefaultCPlayerVolume
                    station:SetVolume(ent.cassetteVolume or volume)
                end
                station:Set3DEnabled(true)
                station:SetPos(ent:GetPos())
                station:Set3DFadeDistance( PLUGIN.SoundFadeMin, PLUGIN.SoundFadeMax )
                PLUGIN.RadioChannels[ent] = station

                local timerID = "SyncPosition"..ent:EntIndex()
                timer.Create(timerID, PLUGIN.AudioPosUpdateFrequency, 0, function()
                    if (station != nil && ent != nil && station != NULL && ent != NULL) then
                        if ent:GetPos():DistToSqr(LocalPlayer():GetPos()) > PLUGIN.SoundStopDistance then
                            if IsValid(station) and station:GetVolume() ~= 0 then
                                station:SetVolume(0)
                            end
                        else
                            if IsValid(station) and station:GetVolume() == 0 and ent.cassetteVolume ~= 0 then
                                local volume = simfphys.IsCar(ent) and PLUGIN.DefaultCarVolume or PLUGIN.DefaultCPlayerVolume
                                station:SetVolume(ent.cassetteVolume or volume)
                            end
                            station:SetPos(ent:GetPos())
                        end
                    else
                        timer.Remove(timerID)
                    end
                end)
            end
        end )
    elseif type == VOLUME then
        if IsValid(channel) then
            if channel:GetState() == 1 then
                channel:SetVolume(volume)
            end
        end
    elseif type == EJECT then
        if IsValid(channel) then
            channel:Pause()
        end
    end
end)

function PLUGIN:EntityRemoved(ent)
    if PLUGIN.RadioChannels[ent] then
        if IsValid(PLUGIN.RadioChannels[ent]) then
            PLUGIN.RadioChannels[ent]:Stop()
        end
    end
end
