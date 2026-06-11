-- "gamemodes\\mafiarp\\plugins\\pager\\libs\\sh_message.lua"


PagerMessage = {}
PagerMessage.__index = PagerMessage

TRASHED_STATUS = {
    NOT_TRASHED = 0,
    TRASHED = 1,
    DELETED = 2
}

local function initializeMessage( id, timestamp, content, subject, sender, recipient, read, trashedForSender, trashedForRecipient )
    local newMessage = setmetatable( {
        ID = id,
        Timestamp = timestamp,
        Content = content,
        Subject = subject or "[no subject]",
        Sender = sender,
        Recipient = recipient,
        Read = tobool( read ),
        TrashedForSender = trashedForSender or TRASHED_STATUS.NOT_TRASHED,
        TrashedForRecipient = trashedForRecipient or TRASHED_STATUS.NOT_TRASHED
    }, PagerMessage )

    return newMessage
end

function PagerMessage:GetFormattedTime()
    local seconds = os.time() - self.Timestamp

    if seconds <= 0 then
        return "just now"
    end

    local minutes, hours, days = math.floor( seconds / 60 ), math.floor( seconds / 3600 ), math.floor( seconds / 86400 )

    if days >= 1 then
        return tostring( days ) .. ( days == 1 and " day ago" or " days ago" )
    elseif hours >= 1 then
        return tostring( hours ) .. ( hours == 1 and " hour ago" or " hours ago" )
    elseif minutes >= 1 then
        return tostring( minutes ) .. ( minutes == 1 and " minute ago" or " minutes ago" )
    else
        return tostring( seconds ) .. ( seconds == 1 and " second ago" or " seconds ago" )
    end
end

function PagerMessage:GetSenderName( contacts )
    if CLIENT and self.Sender == LocalPlayer():getChar():getID() then
        return "You"
    end

    if contacts and contacts[self.Sender] then
        return tostring( contacts[self.Sender] ) .. " (" .. self.Sender .. ")"
    end

    return "Unknown (" .. self.Sender .. ")"
end

function PagerMessage:GetRecipientName( contacts )
    if CLIENT and self.Recipient == LocalPlayer():getChar():getID() then
        return "You"
    end

    if contacts and contacts[self.Recipient] then
        return tostring( contacts[self.Recipient] ) .. " (" .. self.Recipient .. ")"
    end

    return "Unknown (" .. self.Recipient .. ")"
end

PagerMessage = setmetatable( PagerMessage, { __call = function( self, ... ) return initializeMessage( ... ) end } )