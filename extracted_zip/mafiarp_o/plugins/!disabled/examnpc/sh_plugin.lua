PLUGIN.name = "Exam NPC"
PLUGIN.author = "JayyKashtaCodes"
PLUGIN.description = "Adds an NPC that gives players an exam."

nut.util.include("entities/entities/sh_exam.lua")
if (CLIENT) then
    nut.util.include("derma/cl_exam.lua")
end
