-- "gamemodes\\mafiarp\\plugins\\nypdsergeant\\cl_plugin.lua"


local PLUGIN = PLUGIN

--[[ Config ]]--
PLUGIN.Questions = {}

--[[
    Question class/object structure:
    .ID = the ID in the table
    .Type = enum in which defines the question type
    .Description = describes the question
    .Options = the table of possible options
    .Answer = the index/table of indexes that are correct
    .Score = how many points received if this question is correct

    Create a helper function to match an answer input to a question object.
]]

function PLUGIN:RegisterQuestion( questionTbl )
    local id = table.insert( self.Questions, questionTbl )
    self.Questions[id].ID = id
    return id
end

function PLUGIN:GetAnswerPoints( questionId, answerInput )
    local question = self.Questions[questionId]

    if not question then
        return 0
    end

    if question.Type == SINGLE_CHOICE then
        if answerInput == question.Answer then
            return question.Points
        end
    elseif question.Type == MULTIPLE_CHOICE then
        local score = 0

        for _, v in pairs( answerInput ) do
            if question.Answer[v] then
                score = score + 1
            end
        end

        return score
    elseif question.Type == ORDERED_LIST then
        if answerInput == question.Answer then
            return question.Points
        end
    end

    return 0
end

nut.command.add( "testcheck", {
    onCheckAccess = function( client )
        return PLUGIN:IsNYPD( client:getChar() )
    end,
    onRun = function() end
} )

nut.command.add( "pdblacklist", {
    onCheckAccess = function( client )
        return client:IsAdmin()
    end,
    onRun = function() end
} )

nut.command.add( "pdunblacklist", {
    onCheckAccess = function( client )
        return client:IsAdmin()
    end,
    onRun = function() end
} )