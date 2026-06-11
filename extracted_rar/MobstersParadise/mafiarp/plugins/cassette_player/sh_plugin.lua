-- "gamemodes\\mafiarp\\plugins\\cassette_player\\sh_plugin.lua"


PLUGIN.name = "Cassette Player"
PLUGIN.author = "Tarion"
PLUGIN.desc = "A cassette player with multi track cassettes."

nut.util.include("sv_plugin.lua")
nut.util.include("cl_plugin.lua")

// Types
PLAY = 1
STOP = 2
LOAD = 3
VOLUME = 4
EJECT = 5
PICKUP = 6

PLUGIN.RadioChannels = {}

// How often should the audiochannel be updated? This includes it stopping when the entity was removed (car, cassette player)
PLUGIN.AudioPosUpdateFrequency = 0.2

// Values that determine when the sound starts fading
PLUGIN.SoundFadeMin = 400
PLUGIN.SoundFadeMax = 1000000
PLUGIN.SoundStopDistance = 1000000

PLUGIN.MaxCarVolume = 2
PLUGIN.DefaultCarVolume = 1.5

PLUGIN.MaxCPlayerVolume = 1
PLUGIN.DefaultCPlayerVolume = 0.5
