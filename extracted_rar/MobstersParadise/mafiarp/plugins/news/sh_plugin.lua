PLUGIN.name = "News"
PLUGIN.author = "AngryBaldMan"
PLUGIN.desc = "Allows players to report the news."

nut.util.include("cl_news.lua", "client")
nut.util.include("sv_news.lua", "server")

