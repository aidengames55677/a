-- "gamemodes\\mafiarp\\plugins\\adverts\\sh_plugin.lua"


local PLUGIN = PLUGIN

PLUGIN.name = "Adverts"
PLUGIN.author = "GlorifiedPig"
PLUGIN.desc = "System for in-game advertisement boards"

nut.util.include( "sv_plugin.lua" )
nut.util.include( "sv_sql.lua" )
nut.util.include( "cl_plugin.lua" )

PLUGIN.TimeBetweenAdverts = 21600 -- How much time (in seconds) between advert posting?

PLUGIN.AdvertTiers = { -- Time is in minutes.
    {
        Investment = 250,
        Time = 60
    },
    {
        Investment = 500,
        Time = 360
    },
    {
        Investment = 2500,
        Time = 1440
    },
    {
        Investment = 10000,
        Time = 10080
    },
}

local urlWhitelist = {
    ["i.imgur.com"] = true,
}

function PLUGIN:IsValidURL( url )
    if not isstring( url ) or string.len( url ) < 5 then return false end

    local subdomain, domain, tld = url:match( "^%a+://([^.]+)%.([^/]+)%.([^/]+)" )

    if not domain or not tld then return false end

    local fullDomain = subdomain and subdomain .. "." or ""
    fullDomain = fullDomain .. domain .. "." .. tld

    return tobool( urlWhitelist[string.lower( fullDomain )] )
end

function PLUGIN:GetFormattedTime( minutes )
    local d, h = math.floor( minutes / 1440 ), math.floor( ( minutes / 60 ) % 24 )

    if d > 0 and h > 0 then
        return d .. ( d == 1 and " Day, " or " Days, " ) .. h .. ( h == 1 and " Hour" or "Hours" )
    end

    if d > 0 and h <= 0 then
        return d .. ( d == 1 and " Day" or " Days" )
    end

    return h .. ( h == 1 and " Hour" or " Hours" )
end

Adverts = PLUGIN