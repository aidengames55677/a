-- "gamemodes\\mafiarp\\plugins\\customitems\\items\\cookfood\\sh_fortuneegg.lua"

ITEM.name = "Egg of Fortune"
ITEM.model = "models/diverge/goldenegg/goldenegg.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.hungerAmount = 750
ITEM.foodDesc = "A fortune cookie contained in a golden egg. Crack it open to reveal a message of wisdom, and a savory treat."
ITEM.mustCooked = false
ITEM.price = 10
ITEM.facExclusive = { [FACTION_PIEDRA] = true, [FACTION_LEON] = true, }

ITEM.functions.Fortune = {
	name = "Reveal Fortune",
    icon = "icon16/page_white_text.png",
	onRun = function( item )
        local ply = item.player
        local fortunes = {
            "You will find great misfortune in the near future at the hands of greasy pizza enjoyers.",
            "Your future is grim. You will witness a tragic event in the year 2001 September 11", 
            "Help! I'm being held prisoner in a Chinese bakery.", 
            "People don't care how much you know until they know how much you care.", 
            "You find fortune in allowing the commission to lose the Le Grande.", 
            "Tomorrow your day will breathe because time is good for you, but then later when you breathe you'll be sad, so time will die.", 
            "Time: 19:06. Day: 14 of September. Year: 2054. Cause of death: Asphyxiation.", 
            "Scoreboardd!! Scoreboard!!!! Oh, what happened to your friend?? Hey, I know that guy, I killed him, he cried like a bitch!", 
            "You find great misfortune in allowing infamy to run a faction.", 
            "You find great fortune in buying a golden egg instead of shitty Italian food.", 
            "Wash your hands.", 
            "Imagine being in the commission lol.", 
            "Imagine spending 125 mil on a name change.", 
            "Griller erp go fund me.", 
            "Eclipse lost the Gambinos home.", 
            "It is rumoured that C.oco still walks the floor of Le Grande to this day.", 
            "Coco loves Isabella Medici.", 
            "You get a bitter taste in your mouth and begin to think how the Scott’s are pussies for becoming a district of the commission.", 
            "Scratch that, we don’t recognize the commission.", 
            "We don’t recognize your territory.", 
            "I’m going to tax you 10 million for blah blah blah.", 
            "Infamy was pushed out the commission.", 
            "Mass RDM = Tris babble.", 
            "Imagine pking an associate and losing a retired street boss.", 
            "If only Mikvik didn’t metagame…", 
            "This golden egg’s secret? This fortune is 100 percent truth! You get no bitches, you got no drip, and NO WOK.", 
            "Detachment ø was an inside job.", 
            "Motel ERP.", 
            "Sean Costigan Motel room.", 
            "A message from my future self: Magic Johnson, Aids!?", 
            "Gunny gives back shots to the Bonnano don.", 
            "Imagine sniping someone for a don's order.", 
            "Tables, why are you missing all your shots lately, nigga????", 
            "Monaclu is biased for the 14k.", 
            "Missile sucks cock at pvp.", 
            "Where’s deity?", 
            "How do you allow Microwave to kill Deity while he’s standing still?", 
            "If you are reading this, the chance that Boom may give you money is low, but not impossible.", 
            "The Gmod edater is seen in your future.", 
            "Your mom and dad hate you because you play mafia rp.", 
            "RIP Mark Diaz.", 
            "You will fuck your mom.", 
            "There is a black man waiting to give you his loving chocolate.", 
            "Curtis will be visiting you soon.", 
            "A stinky WOP will have intercourse with your favorite pet.", 
            "An Italian man is waiting to stroke his gabagool to you.", 
            "You will come across a mob of angry niggas.", 
            "I’m wopin here.", 
            "You are alone, child. There is only darkness for you, and only death for your people.", 
            "Meth over crack.", 
            "Silver tongue.", 
            "La Stanza.", 
            "Lucky 108.", 
            "Lucky arms.", 
            "Lucky lady.", 
            "Sergio for mayor.", 
            "Darkfire was so fucking loyal.", 
            "Menace to the streets, small dick energy.", 
            "You will need to sacrifice the one you call your leader for real change to ensue.", 
            "The Shateigashira will lose all of the money at the tables.", 
            "Your leader will walk out just like your dad did.", 
            "Tony the geek.", 
            "Tony Tony.", 
            "Crazy Joe can’t shoot straight.", 
            "Johnny got shot two times.", 
            "A Crazy Joe will get information from Out Of the City.", 
            "Philly will make a new suit for his funeral.", 
            "Don's orders.", 
            "Your wife is cheating on you right now at home with Jamar.", 
            "Your mother smells of wet dog.", 
            "Your sister looks like my foot.", 
            "You look like you need a diet cock.", 
            "American pig dog oink oink this niggah a fed.", 
            "I do have a small cock but I still fucked ya motha.", 
            "Italians are pussies.", 
            "Why does this taste like cat?", 
            "Slam door in face maybe u will look better aftahwards.", 
            "I beat u like mah son, u no docta.", 
            "Zer0 will barely meet quota.", 
            "Pendretti crime family rules south side.", 
            "String will return.", 
            "At the Silver Tongue your nice suit will be ruined by a big nose loud mouth from Calabria.", 
            "U look funny maybe I like Dick too much.", 
            "Look to your left, they will mug you.", 
            "THERE IS COPPER IN YOUR VEINS!!!", 
            "Bing chilling because u a cold MF.", 
            "Pull off your skin.", 
            "You are now black, go eat a banana monkey.", 
            "I'm gonna touch ya motha in ways she hasn't been touched in years.", 
            "Fuck you tard ass.", 
            "Your sister got them pink breasts.", 
            "Be racist to the next person you meet or you'll have bad juju for 5 years.", 
            "James will suck the fun out of you.", 
            "Yuki will make an ugly ass suit.", 
            "Grandpa Solomons killed a retard probationary cop and got life in jail.", 
            "Nothing but PD events this week.", 
            "ESU will raid your grandma's house today.", 
            "Rayve will accuse someone of bias …. again.", 
            "Microwave perma mod.", 
            "Italians smell weird, don't you think?",
            "Man, I bet you want some cock right now.",
            "Beat up the next whiteshirt for being a retard.",
            "I'm going to rape you, you better hide.",
            "Oops, your car is gone, better go get it.",
            "A whiteshirt dresses better than you.",
            "Take that dildo out of your ass and maybe we'll be friends. J.k. Fuck you.",
            "You can't drive. I'm Asian and I can drive better than you.",
            "Your uncle touched you, didn't he?",
            "Hehe, Balls.",
            "Do you think we could even be friends? I mean, I like the Peking duck, Bing Chilling.",
            "America numbah 1, niggah.",
            "I was crazy once.",
            "Your balls sweat, maybe that's why you smell.",
            "Boo, did I scare you? OH FUCK, YOU'RE SCARY AS SHIT, MAH NIGGA, GODDAM.",
            "Congrats, you win one free Peking duck. Come down and say 'I am a stinky niggah' to win.",
            "Beat the nearest woman or you're gay.",
            "Give Grandpa Norton $50 and say 'I like men' in front of Grandpa Norton.",
            "Boop a cop on the nose and say 'you're special' with a rifle.",
            "You will [insert generic fortune here].",
            "Purchase the 'get fortunes' DLC for $3.",
            "The cops are waiting for you.",
            "Your brother will have intercourse with your aunt.",
            "I don't know how to cook, I just put a fork in the microwave and now my Microwave is on fire.",
            "Didn't you threaten to kill infamy irl?",
            "She's wopping on my chang till I gook.",
            "Ayo.",
            "14k Triad.",
            "Colombo crime family.",
            "Kosher Nostra.",
            "I don't blame the Jews for dying.",
            "Die for daddy.",
            "If you keep exposing me ong I'll coup.",
            "Hymie is really just a lady boy.",
            "Darkfire is toxic.",
            "I am Mayor Davis and I approve this message.",
            "The odds are in your favor at the lucky 108 casino today.",
            "RIP Kurt the biggest steppa.",
            "Detachment ø recruiting again. Message genericrapper for more info.",
            "Aquila is a pussy Italian.",
            "Do you like Aldi's? Aldi's nuts in your mouth got ya, nigga.",
            "Kiss yo homies good night.",
            "Scream Bing Chilling or you're a monkey.",
            "Lucy's been with like 10 guys in the city, she's for the streets.",
            "Man, I could eat some tacos right now.",
            "I miss the Mexicans. You aren't Italians, you are Mexicans.",
            "You will be raped by 10 autistic whiteshirts.",
            "Shame what happened to the golden duck.",
            "The Silver Tongue has the Cumbros.",
            "Aquila likes cock.",
            "1 get out of jail free card (will not work with Blacks).",
            "There is great wisdom to be found if you gaze down the barrel of a loaded gun.",
            "Jump off worldcorp.",
            "Martin Riggs sucks horse cock and leaked a boomstick out of the PD ATM.",
        }
        local fortune = table.Random(fortunes)

        local inv = ply:getChar():getInv()
        if inv:findFreePosition( "fortunenote" ) then
            inv:add( "fortunenote", 1 )
            :next( function( res )
                res:setData( "msg", fortune )
                ply:EmitSound( "item_crackers_01_open.wav" )
            end )
        else
            ply:notify( "You have no room in your inventory to store your fortune." )
            return false
        end

        ply:notify( "You crack open the egg and reveal a cookie inside, along with a small slip of paper." )
        item:setData( "fortune", true )
        return false
    end,
    onCanRun = function( item )
        return not item:getData( "fortune" ) and item.uniqueID == "fortuneegg" -- No idea why it's applying to all items
    end
}