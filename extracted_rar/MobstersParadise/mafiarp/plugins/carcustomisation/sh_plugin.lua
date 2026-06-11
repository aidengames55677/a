-- "gamemodes\\mafiarp\\plugins\\carcustomisation\\sh_plugin.lua"


//if !EventServer then return false end

PLUGIN.name = "Vehicle Customization"
PLUGIN.author = "Tarion"
PLUGIN.desc = "Adds a system to customize personal cars."

nut.util.include("sv_plugin.lua")


/*
Armour = 1
Bumpers = 2
Brakes = 3
Engine = 4
Grille = 5
Hood = 6
Horn = 7 
Lights = 8
Respray = 9 
Respray Finishes = 10
Rear Accessories = 11
Roof = 12
Roll Cage = 13
Suspension = 14
Skirts = 15
Spoilers = 16
Tracker = 17
Transmission = 19
Turbo Tuning = 19
Trims = 20
Wheels = 21 
	Tire Type = 1
	Tire Accessories = 2
	Tire Smoke Colour = 3
Windows = 22
*/

// Upgrade types
HEALTH = 1
BRAKES = 2
ENGINE = 3
TURBO = 4
SUSPENSION = 5
TRANSMISSION = 6
BODYGROUP = 7
WHEELS = 8
COLOR = 9
TIRESMOKE = 10
HORN = 11
EXPLOSIVE = 12
TRACKER = 13
BULLETPROOFTIRES = 14
SKIN = 15
ALARM = 16

PLUGIN.TypeToName = {
    [1] = "maxhealth",
    [2] = "brakes",
    [3] = "engine",
    [4] = "turbo",
    [5] = "suspension",
    [6] = "transmission",
    [7] = "bodygroups",
    [8] = "wheels",
    [9] = "paintJob",
    [10] = "tiresmoke",
    [11] = "horn",
    [12] = "explosive",
    [13] = "tracker",
    [14] = "bulletprooftires",
    [15] = "skin",
    [16] = "alarm"
}

PLUGIN.Defaults = {
    ["maxhealth"] = 0,
    ["brakes"] = 0,
    ["engine"] = 0,
    ["turbo"] = false,
    ["suspension"] = 0,
    ["transmission"] = 0,
    ["bodygroups"] = {},
    ["wheels"] = "models/props_vehicles/tire001c_car.mdl",
    ["paintJob"] = Color(255, 255, 255),
    ["tiresmoke"] = Color(255, 255, 255),
    ["horn"] = "simulated_vehicles/horn_0.wav",
    ["explosive"] = false,
    ["tracker"] = false,
    ["bulletprooftires"] = false,
    ["skin"] = 0,
    ["alarm"] = false
}

PLUGIN.Showcase = {
    pos = Vector(-6950, 1627, -27),
    ang = Angle(0, -180, 0),
    campos = Vector(-6944, 1386, 118),
    camang = Angle(26, 90, 0)
}

PLUGIN.ColorPrice = 500

PLUGIN.GlobalCustomizationOptions = {
    ["Armour"] = {
        order = 1,
        ["Armour Upgrade 20%"] = { -- Default
            order = 1,
            type = HEALTH,
            price = 1000,
            value = 1500
        },
        ["Armour Upgrade 40%"] = {
            order = 2,
            type = HEALTH,
            price = 10000,
            value = 2000
        },
        ["Armour Upgrade 60%"] = {
            order = 3,
            type = HEALTH,
            price = 25000,
            value = 2500
        },
        ["Armour Upgrade 80%"] = {
            order = 4,
            type = HEALTH,
            price = 50000,
            value = 3000
        },
        ["Armour Upgrade 100%"] = {
            order = 5,
            type = HEALTH,
            price = 100000,
            value = 3500
        }
    },
    ["Engine"] = {
        order = 3,
		["Turbo Tuning"] = {
			order = 1,
			type = TURBO,
			price = 200000
		}
    },
	
    ["Horn"] = {
        order = 7,
        ["Horn 1"] = { 
            order = 4,
            type = HORN,
            price = 500,
            value = "simulated_vehicles/horn_1.wav"
        },
        ["Horn 2"] = { 
            order = 5,
            type = HORN,
            price = 500,
            value = "simulated_vehicles/horn_2.wav"
        },
        ["Horn 3"] = { 
            order = 6,
            type = HORN,
           price = 500,
            value = "simulated_vehicles/horn_3.wav"
        },
        ["Horn 4"] = { 
            order = 7,
            type = HORN,
            price = 500,
            value = "simulated_vehicles/horn_4.wav"
        },
        ["Horn 5"] = { 
            order = 8,
            type = HORN,
            price = 500,
            value = "simulated_vehicles/horn_5.wav"
        },
        ["Horn 6"] = { 
            order = 9,
            type = HORN,
			price = 500,
            value = "simulated_vehicles/horn_7.wav"
        }
    },
	
	["Respray"] = {
		order = 9,
		type = COLOR,
		price = 500,
	},
	
    ["Suspension"] = {
        order = 14,
        ["Stock Suspension"] = { -- Default
            order = 1,
            type = SUSPENSION,
            value = 0.00,
            price = 1000
        },
        ["Lowered Suspension"] = {
            order = 2,
            type = SUSPENSION,
            value = -0.40,
            price = 1000
        },
        ["Street Suspension"] = {
            order = 3,
            type = SUSPENSION,
            value = -0.60,
            price = 25000
        },
        ["Sport Suspension"] = {
            order = 4,
            type = SUSPENSION,
            value = -0.80,
            price = 50000
        },
        ["Competition Suspension"] = {
            order = 5,
            type = SUSPENSION,
            value = -1.00,
            price = 100000
        }
    },

	["Tracker"] = {	
		order = 17,
		["Premium Tracking"] = {
			type = TRACKER,
			price = 50000
		}
	},

	["Security"] = {	
		order = 16,
		["Car Alarm"] = {
			type = ALARM,
			price = 50000
		}
	},
	
    ["Wheels"] = {
        order = 21,
       --[[ ["Tire Type"] = {
			type = WHEELS,
            order = 1,
            sub = true,
            ["Different Wheel 1"] = {
                order = 1,
                type = WHEELS,
                price = 50,
                value = "models/props_vehicles/tire001c_car.mdl"
            },
            ["Different Wheel 2"] = {
                order = 2,
                type = WHEELS,
                price = 50,
                value = "models/mechanics/wheels/rim_1.mdl"
            }
        },--]]
        ["Tire Smoke Colour"] = {
            order = 2,
            type = TIRESMOKE,
            price = 500
        },
        ["Bulletproof Tires"] = {
            order = 3,
            type = BULLETPROOFTIRES,
            price = 500000
        }
    }
}

PLUGIN.CustomizationOptions = {	
    ["sim_fphys_elcamino"] = {
        ["Rear Accessories"] = {
			order = 11,
            ["No Cover"] = { -- Default
				order = 1,
                type = BODYGROUP,
                id = 2,
                value = 0,
				price = 20,
            },
            
            ["Covered (Vehicle Colour)"] = {
				order = 2,
                type = BODYGROUP,
                id = 2,
                value = 1,
				price = 75,
            }
        },
		
        ["Respray Finishes"] = {
			order = 10,
            ["Stock Finish"] = { -- Default
				order = 1,
                type = SKIN,
                value = 0,
				price = 75
            },
            
            ["Black Striped Finish"] = {
				order = 2,
                type = SKIN,
                value = 1,
				price = 150
            }
        }

	},     
	
	["sim_fphys_citroensm"] = {
        ["Respray Finishes"] = {
			order = 10,
            ["Stock Finish"] = { -- Default
                type = SKIN,
                value = 0,
				price = 75
            },
            
            ["Yellow & Red Finish"] = {
                type = SKIN,
                value = 1,
				price = 250
            },
			
            ["Blue Race Finish"] = {
                type = SKIN,
                value = 2,
				price = 350
            },

            ["Blue & Orange Finish"] = {
                type = SKIN,
                value = 3,
				price = 350
            },
			
            ["Rainbow Finish"] = {
                type = SKIN,
                value = 4,
				price = 700
            }
        },
	},
	
	["sim_fphys_monaco"] = {
        ["Respray Finishes"] = {
		order = 10,
            ["Stock Finish"] = { -- Default
				order = 1,
                type = SKIN,
                value = 0,
				price = 75
            },
            
            ["Matte Finish"] = {
				order = 2,
                type = SKIN,
                value = 8,
				price = 750
            },
		}
	},	
	
	["sim_fphys_chev_belair"] = {
        ["Spoiler"] = {
			order = 16,
            ["No Spoiler"] = { -- Default
                order = 1,
                type = BODYGROUP,
                id = 2,
                value = 0,
                price = 50
            },
            
            ["Low Level Spoiler (Black)"] = {
				order = 2,
                type = BODYGROUP,
                id = 2,
                value = 1,
				price = 120,
            }
        },
		
		["Bumpers"] = {
			order = 2,
			["Front Bumper"] = {
				order = 1,
				sub = true,
				["Stock Front Bumper"] = {
					type = BODYGROUP,
					order = 1,
					id = 3,
					value = 0,
					price = 120,
				},
				["Steet Front Bumper"] = {
					order = 2,
					type = BODYGROUP,
					id = 3,
					value = 1,
					price = 300,
				},
				["Offroad Front Splitter (Black)"] = {
					order = 3,
					type = BODYGROUP,
					value = 2,
					id = 3,
					price = 500,
				}
			}, 
			
			["Rear Bumpers"] = {
				order = 2,
				sub = true,
				["Stock Rear Bumper"] = {
					order = 1,
					type = BODYGROUP,
					id = 4,
					value = 0,
					price = 120,
				},
				["Steet Rear Bumper"] = {
					order = 2,
					type = BODYGROUP,
					id = 4,
					value = 1,
					price = 300,
				},
				["Offroad Bumper"] = {
					order = 3,
					type = BODYGROUP,
					id = 4,
					value = 2,
					price = 500,
				}
			}
		},
		
        ["Hoods"] = {
			order = 7,
            ["Stock Hood"] = { -- Default
				order = 1,
                type = BODYGROUP,
                id = 5,
                value = 0,
				price = 30,
            },
            ["Scooped Hood"] = {
				order = 2,
                type = BODYGROUP,
                id = 5,
                value = 1,
				price = 325,
            },
            ["Vented Hood"] = {
				order = 3,
                type = BODYGROUP,
                id = 5,
                value = 2,
				price = 750,
            }
        },
		
        ["Skirts"] = {
			order = 15,
            ["No Skirt"] = { -- Default
                type = BODYGROUP,
                id = 6,
                value = 0,
				price = 30,
            },
            
            ["Custom Skirt"] = {
                type = BODYGROUP,
                id = 6,
                value = 1,
				price = 300,
            }
        }
	},
	
	["sim_fphys_ford_gran"] = {
        ["Windows"] = {
			order = 22,
            ["Stock Glass"] = { -- Default
				order = 1,
                type = BODYGROUP,
                id = 4,
                value = 0,
				price = 250,
            },
            
            ["Shaded Glass"] = {
				order = 2,
                type = BODYGROUP,
                id = 4,
                value = 1,
				price = 1000,
            },
			
            ["Bunker Glass"] = {
				order = 3,
                type = BODYGROUP,
                id = 4,
                value = 2,
				price = 2500,
            },
        },
        ["Respray Finishes"] = {
			order = 10,
            ["Stock Finish"] = { -- Default
                type = SKIN,
                value = 0,
				price = 75,
                order = 1
            },
            
            ["Matte Finish"] = {
                type = SKIN,
                order = 2,
                value = 1,
				price = 250
            },
			
            ["White & Red Race Finish"] = {
                type = SKIN,
                value = 2,
				price = 350
            },

            ["Yellow Race Finish"] = {
                type = SKIN,
                value = 3,
				price = 350
            },
			
            ["White Race Finish"] = {
                type = SKIN,
                value = 4,
				price = 350
            },
            
            ["White & Gold Race Finish"] = {
                type = SKIN,
                value = 5,
				price = 350
            }
        },
	},
	
	["sim_fphys_dod_chall70"] = {
        ["Hoods"] = {
			order = 7,
            ["Stock Hood"] = { -- Default
				order = 1,
                type = BODYGROUP,
                id = 1,
                value = 0,
				price = 30,
            },
            ["Scooped Hood"] = {
				order = 2,
                type = BODYGROUP,
                id = 1,
                value = 1,
				price = 325,
            },
            ["Vented Hood"] = {
				order = 3,
                type = BODYGROUP,
                id = 1,
                value = 2,
				price = 750,
            }
        },
        
        ["Respray Finishes"] = {
			order = 10,
            ["Stock Finish"] = { -- Default
                type = SKIN,
                value = 0,
				price = 75,
                order = 1
            },
            
            ["Matte Finish"] = {
                type = SKIN,
                order = 2,
                value = 1,
				price = 250
            },

            ["Striped Pattern Finish"] = {
                type = SKIN,
                value = 3,
				price = 750
            },
			
            ["Gritty Finish"] = {
                type = SKIN,
                value = 7,
				price = 750
            },
            
            ["Shiny Finish"] = {
                type = SKIN,
                value = 8,
				price = 750
            },
            
            ["Metal Finish"] = {
                type = SKIN,
                value = 9,
				price = 750
            },
            
            ["Camo Finish"] = {
                type = SKIN,
                value = 10,
				price = 750
            },
            
            ["Disruptive Overwhite Finish"] = {
                type = SKIN,
                value = 12,
				price = 750
            },
            
            ["Wooden Finish"] = {
                type = SKIN,
                value = 14,
				price = 750
            },
            
            ["Chrome Finish"] = {
                type = SKIN,
                value = 15,
				price = 750
            },
        },
	},
	
	["simfphys_mafia2_trautenberg_grande"] = {
        ["Hoods"] = {
			order = 7,
            ["Stock Hood"] = { -- Default
				order = 1,
                type = BODYGROUP,
                id = 6,
                value = 0,
				price = 30,
            },
            ["Turbo Hood"] = { -- Default
				order = 2,
                type = BODYGROUP,
                id = 0,
                value = 1,
				price = 550,
            },
		},
        ["Roofs"] = {
			order = 12,
            ["Stock Roof"] = { -- Default
				order = 1,
                type = SKIN,
                value = 0,
				price = 75
            },
            
            ["Black Roof"] = {
				order = 2,
                type = SKIN,
                value = 2,
				price = 250
            },
			
            ["Red Roof"] = {
				order = 3,
                type = SKIN,
                value = 3,
				price = 250
            },
			
            ["Dark Red Roof"] = {
				order = 4,
                type = SKIN,
                value = 4,
				price = 250
            },
            ["Lime Green Roof"] = {
				order = 5,
                type = SKIN,
                value = 5,
				price = 250
            },
			
            ["Dark Green Roof"] = {
				order = 6,
                type = SKIN,
                value = 6,
				price = 250
            },
			
            ["Blue Roof"] = {
				order = 7,
                type = SKIN,
                value = 7,
				price = 250
            },
			
            ["Dark Blue Roof"] = {
				order = 8,
                type = SKIN,
                value = 8,
				price = 250
            },
			
            ["Yellow Roof"] = {
				order = 9,
                type = SKIN,
                value = 9,
				price = 250
            },
			
            ["Cream Roof"] = {
				order = 10,
                type = SKIN,
                value = 10,
				price = 250
            },
		},
	},
	
	["sim_fphys_shelb_cobra"] = {
        ["Respray Finishes"] = {
			order = 10,
            ["Stock Finish"] = { -- Default
				order = 1,
                type = SKIN,
                value = 0,
				price = 75
            },
            
            ["White Striped Finish"] = {
				order = 2,
                type = SKIN,
                value = 1,
				price = 150
            }
        }
	},
	
	["sim_fphys_crsk_rolls-royce_silvercloud3"] = {
        ["Windows"] = {
            ["Stock Glass"] = { -- Default
                type = BODYGROUP,
                order = 1,
                id = 16,
                value = 0,
				price = 30,
            },
            
            ["Shaded Glass"] = {
                type = BODYGROUP,
                order = 2,
                id = 16,
                value = 1,
				price = 350,
            },
			
            ["Bunker Glass"] = {
                type = BODYGROUP,
                order = 3,
                id = 16,
                value = 2,
				price = 1000,
            }
        }
	},
	
	["sim_fphys_308gts"] = {
        ["Respray Finishes"] = {
			order = 10,
            ["Stock Trim"] = { -- Default
				order = 1,
                type = SKIN,
                value = 0,
				price = 75
            },
            
            ["Red Trim"] = {
				order = 2,
                type = SKIN,
                value = 1,
				price = 350
            },
			
            ["Brown Trim"] = {
				order = 3,
                type = SKIN,
                value = 2,
				price = 350
            },
            ["Blue Trim"] = {
				order = 4,
                type = SKIN,
                value = 3,
				price = 350
            },
            ["Black Trim"] = {
				order = 5,
                type = SKIN,
                value = 4,
				price = 350
            },
        }
	},
	
	["sim_fphys_308gtb"] = {
        ["Respray Finishes"] = {
			order = 10,
            ["Stock Trim"] = { -- Default
				order = 1,
                type = SKIN,
                value = 0,
				price = 75
            },
            
            ["Red Trim"] = {
				order = 2,
                type = SKIN,
                value = 1,
				price = 350
            },
			
            ["Brown Trim"] = {
				order = 3,
                type = SKIN,
                value = 2,
				price = 350
            },
            ["Blue Trim"] = {
				order = 4,
                type = SKIN,
                value = 3,
				price = 350
            },
            ["Black Trim"] = {
				order = 5,
                type = SKIN,
                value = 4,
				price = 350
            },
        }
	},
	
	["sim_fphys_bmw_m1"] = { 
        ["Spoiler"] = {
			order = 16,
            ["No Spoiler"] = { -- Default
                order = 1,
                type = BODYGROUP,
                id = 3,
                value = 0,
                price = 50
            },
            
            ["Spoiler (Black)"] = {
				order = 2,
                type = BODYGROUP,
                id = 3,
                value = 1,
				price = 120,
            }
        },
        
        ["Respray Finishes"] = {
			order = 10,
            ["Stock Finish"] = { -- Default
                type = SKIN,
                value = 0,
				price = 75,
                order = 1
            },
            
            ["Matte Finish"] = {
                type = SKIN,
                order = 2,
                value = 1,
				price = 250
            },

            ["Striped Pattern Finish"] = {
                type = SKIN,
                value = 3,
				price = 750
            },
			
            ["Gritty Finish"] = {
                type = SKIN,
                value = 7,
				price = 750
            },
            
            ["Shiny Finish"] = {
                type = SKIN,
                value = 8,
				price = 750
            },
            
            ["Metal Finish"] = {
                type = SKIN,
                value = 9,
				price = 750
            },
            
            ["Camo Finish"] = {
                type = SKIN,
                value = 10,
				price = 750
            },
            
            ["Disruptive Overwhite Finish"] = {
                type = SKIN,
                value = 12,
				price = 750
            },
            
            ["Wooden Finish"] = {
                type = SKIN,
                value = 14,
				price = 750
            },
            
            ["Chrome Finish"] = {
                type = SKIN,
                value = 15,
				price = 750
            },
        },
	},
	
	["sim_fphys_alfa_33_stradale"] = { 
        ["Spoiler"] = {
			order = 16,
            ["No Spoiler"] = { -- Default
                order = 1,
                type = BODYGROUP,
                id = 5,
                value = 0,
                price = 50
            },
            
            ["Low Level Spoiler (Black)"] = {
				order = 2,
                type = BODYGROUP,
                id = 5,
                value = 1,
				price = 120,
            }
        },
		
		["Bumpers"] = {
			order = 2,
			["Front Bumper"] = {
				order = 1,
				sub = true,
				["Stock Front Bumper"] = {
					type = BODYGROUP,
					order = 1,
					id = 4,
					value = 0,
					price = 120,
				},
				["Steet Front Bumper"] = {
					order = 2,
					type = BODYGROUP,
					id = 4,
					value = 1,
					price = 300,
				},
			},
		},
	},
	
	["sim_fphys_nis_2000gtr"] = {
		["Bumpers"] = {
			order = 2,
			["Front Bumper"] = {
				order = 1,
				sub = true,
				["Stock Front Bumper"] = {
					type = BODYGROUP,
					order = 1,
					id = 1,
					value = 0,
					price = 120,
				},
				["Racing Front Bumper"] = {
					order = 2,
					type = BODYGROUP,
					id = 1,
					value = 1,
					price = 300,
				},
			}, 
			
			["Rear Bumpers"] = {
				order = 2,
				sub = true,
				["Stock Rear Bumper"] = {
					order = 1,
					type = BODYGROUP,
					id = 6,
					value = 0,
					price = 120,
				},
				["Steet Rear Bumper"] = {
					order = 2,
					type = BODYGROUP,
					id = 6,
					value = 1,
					price = 300,
				},
			}
		},
	
        ["Roll Cage"] = {
			order = 13,
            ["No Roll Cage"] = { -- Default
                order = 1,
                type = BODYGROUP,
                id = 2,
                value = 0,
                price = 50
            },
            
            ["Roll Cage"] = {
				order = 2,
                type = BODYGROUP,
                id = 2,
                value = 1,
				price = 875,
            }
        },
		
        ["Spoiler"] = {
			order = 16,
            ["No Spoiler"] = { -- Default
                order = 1,
                type = BODYGROUP,
                id = 7,
                value = 0,
                price = 50
            },
            
            ["Low Level Spoiler (Black)"] = {
				order = 2,
                type = BODYGROUP,
                id = 7,
                value = 1,
				price = 120,
            }
        },
	},
	
    ["sim_fphys_lam_countach"] = {
        ["Spoiler"] = {
            order = 10,
            ["No Spoiler"] = { -- Default
                order = 1,
                type = BODYGROUP,
                id = 7,
                value = 0,
                price = 50
            },
            
            ["High Spoiler (Vehicle Colour)"] = {
                order = 2,
                type = BODYGROUP,
                id = 7,
                value = 1,
                price = 500
            },
            
            ["Low Spoiler (Black)"] = {
                order = 3,
                type = BODYGROUP,
                id = 7,
                value = 2,
                price = 500
            }
        }
	},
    
    ["simfphys_gta_sa_blade"] = { 
        offset = Vector(0,0,20),
        ["Respray Finishes"] = {
            order = 10,
            ["Stock Finish"] = { -- Default
                order = 1,
                type = SKIN,
                value = 0,
                price = 75
            },
            
            ["Flame Finish"] = {
                order = 2,
                type = SKIN,
                value = 1,
                price = 750
            },

            ["Striped Finish"] = {
                order = 2,
                type = SKIN,
                value = 2,
                price = 550
            },

            ["Hot Wheels Finish"] = {
                order = 4,
                type = SKIN,
                value = 3,
                price = 750
            },
        },

        ["Roofs"] = {
            order = 12,
            ["Stock Roof"] = { -- Default
                order = 1,
                type = BODYGROUP,
                id = 1,
                value = 0,
                price = 50
            },

            ["Closed Roof"] = { -- Default
                order = 2,
                type = BODYGROUP,
                id = 1,
                value = 1,
                price = 250
            },
        },

		["Bumpers"] = {
			order = 2,
			["Front Bumper"] = {
				order = 1,
				sub = true,
				["Stock Front Bumper"] = {
					type = BODYGROUP,
					order = 1,
					id = 2,
					value = 0,
					price = 120,
				},
				["Steet Front Bumper"] = {
					order = 2,
					type = BODYGROUP,
					id = 2,
					value = 1,
					price = 120
				},
				["Street Front Bumper 2"] = {
					order = 3,
					type = BODYGROUP,
					value = 2,
					id = 2,
					price = 120
				},

				["No Front Bumper"] = {
					order = 4,
					type = BODYGROUP,
					value = 3,
					id = 2,
					price = 120
				}
			}, 
			
			["Rear Bumpers"] = {
				order = 2,
				sub = true,
				["Stock Rear Bumper"] = {
					order = 1,
					type = BODYGROUP,
					id = 3,
					value = 0,
					price = 120,
				},
				["Steet Rear Bumper"] = {
					order = 2,
					type = BODYGROUP,
					id = 3,
					value = 1,
					price = 120,
				},
				["Offroad Bumper"] = {
					order = 3,
					type = BODYGROUP,
					id = 3,
					value = 2,
					price = 120,
				}
			}
		},

        ["Skirts"] = {
			order = 15,
            ["No Skirts"] = { -- Default
                type = BODYGROUP,
                id = 4,
                value = 0,
				price = 30,
            },
            
            ["Custom Skirts"] = {
                type = BODYGROUP,
                id = 4,
                value = 1,
				price = 100,
            }
        }
	},
    
    ["simfphys_gta_sa_broadway"] = { 
        offset = Vector(0,0,20),
        ["Respray Finishes"] = {
            order = 10,
            ["Stock Finish"] = { -- Default
                order = 1,
                type = SKIN,
                value = 0,
                price = 75
            },
            
            ["Flame Finish"] = {
                order = 2,
                type = SKIN,
                value = 1,
                price = 750
            },

            ["Hot Wheels Finish"] = {
                order = 4,
                type = SKIN,
                value = 2,
                price = 750
            },
        },

		["Bumpers"] = {
			order = 2,
			["Front Bumper"] = {
				order = 1,
				sub = true,
				["Stock Front Bumper"] = {
					type = BODYGROUP,
					order = 1,
					id = 1,
					value = 0,
					price = 120,
				},
				["Steet Front Bumper"] = {
					order = 2,
					type = BODYGROUP,
					id = 1,
					value = 1,
					price = 120
				},
				["Street Front Bumper 2"] = {
					order = 3,
					type = BODYGROUP,
					value = 2,
					id = 1,
					price = 120
				},

				["No Front Bumper"] = {
					order = 4,
					type = BODYGROUP,
					value = 3,
					id = 1,
					price = 120
				}
			}, 
			
			["Rear Bumpers"] = {
				order = 2,
				sub = true,
				["Stock Rear Bumper"] = {
					order = 1,
					type = BODYGROUP,
					id = 2,
					value = 0,
					price = 120,
				},
				["Steet Rear Bumper"] = {
					order = 2,
					type = BODYGROUP,
					id = 2,
					value = 1,
					price = 120,
				},
				["Offroad Bumper"] = {
					order = 3,
					type = BODYGROUP,
					id = 2,
					value = 2,
					price = 120,
				},
				["No Rear Bumper"] = {
					order = 4,
					type = BODYGROUP,
					id = 2,
					value = 3,
					price = 120,
				},
			}
		},

        ["Skirts"] = {
			order = 15,
            ["No Skirts"] = { -- Default
                type = BODYGROUP,
                id = 3,
                value = 0,
				price = 30,
            },
            
            ["Custom Skirts"] = {
                type = BODYGROUP,
                id = 3,
                value = 1,
				price = 100,
            }
        }
	},
	
	["simfphys_gta_sa_remingtn"] = { 
        offset = Vector(0,0,20),
        ["Respray Finishes"] = {
            order = 10,
            ["Stock Finish"] = { -- Default
                order = 1,
                type = SKIN,
                value = 0,
                price = 75
            },
            
            ["Aztec Finish"] = {
                order = 2,
                type = SKIN,
                value = 1,
                price = 750
            },

            ["Flame Finish"] = {
                order = 4,
                type = SKIN,
                value = 2,
                price = 750
            },
            ["Hot Flame Finish"] = {
                order = 4,
                type = SKIN,
                value = 3,
                price = 750
            },
        },

		["Bumpers"] = {
			order = 2,
			["Front Bumper"] = {
				order = 1,
				sub = true,
				["Stock Front Bumper"] = {
					type = BODYGROUP,
					order = 1,
					id = 1,
					value = 0,
					price = 120,
				},
				["Steet Front Bumper"] = {
					order = 2,
					type = BODYGROUP,
					id = 1,
					value = 1,
					price = 120
				},
				["Street Front Bumper 2"] = {
					order = 3,
					type = BODYGROUP,
					value = 2,
					id = 1,
					price = 120
				},

				["No Front Bumper"] = {
					order = 4,
					type = BODYGROUP,
					value = 3,
					id = 1,
					price = 120
				}
			}, 
			
			["Rear Bumpers"] = {
				order = 2,
				sub = true,
				["Stock Rear Bumper"] = {
					order = 1,
					type = BODYGROUP,
					id = 2,
					value = 0,
					price = 120,
				},
				["Steet Rear Bumper"] = {
					order = 2,
					type = BODYGROUP,
					id = 2,
					value = 1,
					price = 120,
				},
				["Offroad Bumper"] = {
					order = 3,
					type = BODYGROUP,
					id = 2,
					value = 2,
					price = 120,
				},
				["No Rear Bumper"] = {
					order = 4,
					type = BODYGROUP,
					id = 2,
					value = 3,
					price = 120,
				},
			}
		},

        ["Skirts"] = {
			order = 15,
            ["No Skirts"] = { -- Default
                type = BODYGROUP,
                id = 3,
                value = 0,
				price = 30,
            },
            
            ["Custom Skirts"] = {
                type = BODYGROUP,
                id = 3,
                value = 1,
				price = 100,
            },

            ["Custom Skirts #2"] = {
                type = BODYGROUP,
                id = 3,
                value = 2,
				price = 100,
            }
        }
	},
    
    ["simfphys_gta_sa_savanna"] = { 
        offset = Vector(0,0,30),
        ["Respray Finishes"] = {
            order = 10,
            ["Stock Finish"] = { -- Default
                order = 1,
                type = SKIN,
                value = 0,
                price = 75
            },
            
            ["Flame Finish"] = {
                order = 2,
                type = SKIN,
                value = 1,
                price = 750
            },

            ["Striped Finish"] = {
                order = 2,
                type = SKIN,
                value = 2,
                price = 550
            },

            ["Hot Wheels Finish"] = {
                order = 4,
                type = SKIN,
                value = 3,
                price = 750
            },
        },

        ["Roofs"] = {
            order = 12,
            ["Stock Roof"] = { -- Default
                order = 1,
                type = BODYGROUP,
                id = 1,
                value = 0,
                price = 50
            },

            ["Closed Roof"] = { -- Default
                order = 2,
                type = BODYGROUP,
                id = 1,
                value = 1,
                price = 250
            },

            ["Closed Roof #2"] = { -- Default
                order = 2,
                type = BODYGROUP,
                id = 1,
                value = 2,
                price = 250
            },
        },

		["Bumpers"] = {
			order = 2,
			["Front Bumper"] = {
				order = 1,
				sub = true,
				["Stock Front Bumper"] = {
					type = BODYGROUP,
					order = 1,
					id = 2,
					value = 0,
					price = 120,
				},
				["Steet Front Bumper"] = {
					order = 2,
					type = BODYGROUP,
					id = 2,
					value = 1,
					price = 120
				},
				["Street Front Bumper 2"] = {
					order = 3,
					type = BODYGROUP,
					value = 2,
					id = 2,
					price = 120
				},

				["No Front Bumper"] = {
					order = 4,
					type = BODYGROUP,
					value = 3,
					id = 2,
					price = 120
				}
			}, 
			
			["Rear Bumpers"] = {
				order = 2,
				sub = true,
				["Stock Rear Bumper"] = {
					order = 1,
					type = BODYGROUP,
					id = 3,
					value = 0,
					price = 120,
				},
				["Steet Rear Bumper"] = {
					order = 2,
					type = BODYGROUP,
					id = 3,
					value = 1,
					price = 120,
				},
				["Offroad Bumper"] = {
					order = 3,
					type = BODYGROUP,
					id = 3,
					value = 2,
					price = 120,
				}
			}
		},

        ["Skirts"] = {
			order = 15,
            ["No Skirts"] = { -- Default
                type = BODYGROUP,
                id = 4,
                value = 0,
				price = 30,
            },
            
            ["Custom Skirts"] = {
                type = BODYGROUP,
                id = 4,
                value = 1,
				price = 100,
            }
        }
        
	}, 
    
    ["simfphys_gta_sa_slamvan"] = { 
        offset = Vector(0,0,30),
        ["Respray Finishes"] = {
            order = 10,
            ["Stock Finish"] = { -- Default
                order = 1,
                type = SKIN,
                value = 0,
                price = 75
            },
            
            ["Rainbow Finish"] = {
                order = 2,
                type = SKIN,
                value = 1,
                price = 750
            },

            ["Flame Finish"] = {
                order = 2,
                type = SKIN,
                value = 2,
                price = 550
            },

            ["Hot Wheels Finish"] = {
                order = 4,
                type = SKIN,
                value = 3,
                price = 750
            },
        },
	},
    
    ["simfphys_gta_sa_tornado"] = { 
        offset = Vector(0,0,20),
        ["Respray Finishes"] = {
            order = 10,
            ["Stock Finish"] = { -- Default
                order = 1,
                type = SKIN,
                value = 0,
                price = 75
            },
            
            ["Flame Finish"] = {
                order = 2,
                type = SKIN,
                value = 1,
                price = 750
            },

            ["Striped Finish"] = {
                order = 2,
                type = SKIN,
                value = 2,
                price = 550
            },

            ["Hot Wheels Finish"] = {
                order = 4,
                type = SKIN,
                value = 3,
                price = 750
            },
        },

		["Bumpers"] = {
			order = 2,
			["Front Bumper"] = {
				order = 1,
				sub = true,
				["Stock Front Bumper"] = {
					type = BODYGROUP,
					order = 1,
					id = 1,
					value = 0,
					price = 120,
				},
				["Steet Front Bumper"] = {
					order = 2,
					type = BODYGROUP,
					id = 1,
					value = 1,
					price = 120
				},
				["Street Front Bumper 2"] = {
					order = 3,
					type = BODYGROUP,
					value = 2,
					id = 1,
					price = 120
				},

				["No Front Bumper"] = {
					order = 4,
					type = BODYGROUP,
					value = 3,
					id = 1,
					price = 120
				}
			}, 
			
			["Rear Bumpers"] = {
				order = 2,
				sub = true,
				["Stock Rear Bumper"] = {
					order = 1,
					type = BODYGROUP,
					id = 2,
					value = 0,
					price = 120,
				},
				["Steet Rear Bumper"] = {
					order = 2,
					type = BODYGROUP,
					id = 2,
					value = 1,
					price = 120,
				},
				["Offroad Bumper"] = {
					order = 3,
					type = BODYGROUP,
					id = 2,
					value = 2,
					price = 120,
				}
			}
		},

        ["Skirts"] = {
			order = 15,
            ["No Skirts"] = { -- Default
                type = BODYGROUP,
                id = 3,
                value = 0,
				price = 30,
            },
            
            ["Custom Skirts"] = {
                type = BODYGROUP,
                id = 3,
                value = 1,
				price = 100,
            }
        }
	},        
    
    ["sim_fphys_m635csi"] = {
        ["Roll Cage"] = {
			order = 13,
            ["No Roll Cage"] = { -- Default
                order = 1,
                type = BODYGROUP,
                id = 4,
                value = 0,
                price = 50
            },
            
            ["Modified Roll Cage"] = {
				order = 2,
                type = BODYGROUP,
                id = 4,
                value = 1,
				price = 875,
            }
        },
        ["Hoods"] = {
			order = 7,
            ["Stock Hood"] = { -- Default
				order = 1,
                type = BODYGROUP,
                id = 6,
                value = 0,
				price = 30,
            },
            ["Black Hood"] = {
				order = 2,
                type = BODYGROUP,
                id = 6,
                value = 1,
				price = 325,
            },
        },
    },      
    
    ["sim_fphys_camaro_irocz"] = {
        ["Roll Cage"] = {
			order = 13,
            ["No Roll Cage"] = { -- Default
                order = 1,
                type = BODYGROUP,
                id = 3,
                value = 0,
                price = 50
            },
            
            ["Roll Cage"] = {
				order = 2,
                type = BODYGROUP,
                id = 3,
                value = 1,
				price = 875,
            }
        },
		["Bumpers"] = {
			order = 2,
			["Front Bumper"] = {
				order = 1,
				sub = true,
				["Stock Front Bumper"] = {
					type = BODYGROUP,
					order = 1,
					id = 4,
					value = 0,
					price = 120,
				},
				["Racing Front Bumper"] = {
					order = 2,
					type = BODYGROUP,
					id = 4,
					value = 1,
					price = 300,
				},
			}, 
		},
        ["Hoods"] = {
			order = 7,
            ["Stock Hood"] = { -- Default
				order = 1,
                type = BODYGROUP,
                id = 8,
                value = 0,
				price = 30,
            },
            ["Scooped Hood"] = {
				order = 2,
                type = BODYGROUP,
                id = 8,
                value = 1,
				price = 325,
            },
            ["Vented Hood"] = {
				order = 3,
                type = BODYGROUP,
                id = 8,
                value = 2,
				price = 750,
            }
        },
        ["Spoiler"] = {
			order = 16,
            ["No Spoiler"] = { -- Default
                order = 1,
                type = BODYGROUP,
                id = 9,
                value = 0,
                price = 50
            },
            
            ["Low Level Spoiler"] = {
				order = 2,
                type = BODYGROUP,
                id = 9,
                value = 1,
				price = 120,
            }
        },
    },      
    
    ["sim_fphys_ford_bronco"] = {
        ["Windows"] = {
			order = 22,
            ["Stock Glass"] = { -- Default
				order = 1,
                type = BODYGROUP,
                id = 15,
                value = 0,
				price = 250,
            },
            
            ["Shaded Glass"] = {
				order = 2,
                type = BODYGROUP,
                id = 15,
                value = 1,
				price = 1000,
            },
			
            ["Bunker Glass"] = {
				order = 3,
                type = BODYGROUP,
                id = 15,
                value = 2,
				price = 2500,
            },
        },
    },       
    
    ["sim_fphys_ferrari_f40"] = {
    ["Wheels"] = {
        order = 21,
        ["Tire Type"] = {
            order = 1,
            sub = true,
            ["Stock Wheels"] = {
                order = 1,
                type = BODYGROUP,
                id = 1,
                price = 50,
                value = 0
            },
            ["Gold Wheels"] = {
                order = 2,
                type = BODYGROUP,
                id = 1,
                price = 50,
                value = 1
            }
        },
    }
    },     
    
    ["sim_fphys_rx7_fd"] = {
		["Bumpers"] = {
			order = 2,
			["Front Bumper"] = {
				order = 1,
				sub = true,
				["Stock Front Bumper"] = {
					type = BODYGROUP,
					order = 1,
					id = 2,
					value = 0,
					price = 120,
				},
				["Steet Front Bumper"] = {
					order = 2,
					type = BODYGROUP,
					id = 2,
					value = 1,
					price = 300,
				},
				["Racing Front Bumper"] = {
					order = 3,
					type = BODYGROUP,
					id = 2,
					value = 2,
					price = 450,
				},
				["Alternative Front Bumper"] = {
					order = 4,
					type = BODYGROUP,
					id = 2,
					value = 3,
					price = 600,
				},
				["Offroad Front Bumper (Black)"] = {
					order = 5,
					type = BODYGROUP,
					value = 4,
					id = 2,
					price = 800,
				}
			}, 
			
			["Rear Bumpers"] = {
				order = 2,
				sub = true,
				["Stock Rear Bumper"] = {
					order = 1,
					type = BODYGROUP,
					id = 3,
					value = 1,
					price = 120,
				},
				["Steet Rear Bumper"] = {
					order = 2,
					type = BODYGROUP,
					id = 3,
					value = 0,
					price = 200,
				},				
                ["Racing Rear Bumper"] = {
					order = 3,
					type = BODYGROUP,
					id = 3,
					value = 2,
					price = 300,
				},
				["Offroad Bumper"] = {
					order = 4,
					type = BODYGROUP,
					id = 3,
					value = 3,
					price = 500,
				}
			}
		},
        ["Hoods"] = {
			order = 7,
            ["Stock Hood"] = { -- Default
				order = 1,
                type = BODYGROUP,
                id = 4,
                value = 0,
				price = 30,
            },
            ["Indented Hood"] = {
				order = 2,
                type = BODYGROUP,
                id = 4,
                value = 1,
				price = 325,
            },            
            ["Racing Hood"] = {
				order = 3,
                type = BODYGROUP,
                id = 4,
                value = 2,
				price = 325,
            },
            ["Vented Hood"] = {
				order = 4,
                type = BODYGROUP,
                id = 4,
                value = 3,
				price = 750,
            }
        },

        ["Spoiler"] = {
            order = 10,
            ["No Spoiler"] = { -- Default
                order = 1,
                type = BODYGROUP,
                id = 5,
                value = 0,
                price = 50
            },
            
            ["Low Spoiler (Vehicle Colour)"] = {
                order = 2,
                type = BODYGROUP,
                id = 5,
                value = 1,
                price = 400
            },
            
            ["High Spoiler (Black)"] = {
                order = 3,
                type = BODYGROUP,
                id = 5,
                value = 2,
                price = 500
            }
        },
    },      
    
    ["sim_fphys_chev_impala_ss"] = {
        ["Roofs"] = {
            order = 12,
            ["Stock Roof"] = { -- Default
                order = 1,
                type = BODYGROUP,
                id = 2,
                value = 0,
                price = 50
            },

            ["Windowed Roof"] = { -- Default
                order = 2,
                type = BODYGROUP,
                id = 2,
                value = 1,
                price = 250
            },
            ["Closed Roof"] = { -- Default
                order = 3,
                type = BODYGROUP,
                id = 2,
                value = 2,
                price = 500
            },
        },
    },    
    
    ["sim_fphys_mer_w140"] = {
        ["Windows"] = {
			order = 22,
            ["Stock Glass"] = { -- Default
				order = 1,
                type = BODYGROUP,
                id = 3,
                value = 0,
				price = 250,
            },
            
            ["Shaded Glass"] = {
				order = 2,
                type = BODYGROUP,
                id = 3,
                value = 1,
				price = 1000,
            },
			
            ["Bunker Glass"] = {
				order = 3,
                type = BODYGROUP,
                id = 3,
                value = 2,
				price = 2500,
            },
        },
    },    
    
    ["sim_fphys_rolls_royce_silver_spirit_mk3"] = {
        ["Windows"] = {
			order = 22,
            ["Stock Glass"] = { -- Default
				order = 1,
                type = BODYGROUP,
                id = 15,
                value = 0,
				price = 250,
            },
            
            ["Shaded Glass"] = {
				order = 2,
                type = BODYGROUP,
                id = 15,
                value = 1,
				price = 1000,
            },
			
            ["Bunker Glass"] = {
				order = 3,
                type = BODYGROUP,
                id = 15,
                value = 2,
				price = 2500,
            },
        },
    },    
    
    ["sim_fphys_austin_healey3000"] = {
		["Bumpers"] = {
			order = 2,
			["Front Bumper"] = {
				order = 1,
				sub = true,
				["Stock Front Bumper"] = {
					type = BODYGROUP,
					order = 1,
					id = 1,
					value = 0,
					price = 120,
				},
				["Steet Front Bumper"] = {
					order = 2,
					type = BODYGROUP,
					id = 1,
					value = 1,
					price = 300,
				},
				["Offroad Front Splitter (Black)"] = {
					order = 3,
					type = BODYGROUP,
					value = 2,
					id = 1,
					price = 500,
				}
			}, 
			
			["Rear Bumpers"] = {
				order = 2,
				sub = true,
				["Stock Rear Bumper"] = {
					order = 1,
					type = BODYGROUP,
					id = 2,
					value = 0,
					price = 120,
				},
				["No Rear Bumper"] = {
					order = 2,
					type = BODYGROUP,
					id = 2,
					value = 1,
					price = 300,
				},
			}
		},
        ["Roll Cage"] = {
			order = 13,
            ["No Roll Cage"] = { -- Default
                order = 1,
                type = BODYGROUP,
                id = 4,
                value = 0,
                price = 50
            },
            
            ["Roll Cage"] = {
				order = 2,
                type = BODYGROUP,
                id = 4,
                value = 1,
				price = 875,
            }
        },

        ["Spoiler"] = {
			order = 16,
            ["No Spoiler"] = { -- Default
                order = 1,
                type = BODYGROUP,
                id = 7,
                value = 0,
                price = 50
            },
            
            ["Low Level Spoiler (Black)"] = {
				order = 2,
                type = BODYGROUP,
                id = 7,
                value = 1,
				price = 120,
            }
        },

        ["Respray Finishes"] = {
			order = 10,
            ["Stock Finish (White)"] = { -- Default
                order = 1,
                type = BODYGROUP,
                id = 5,
                value = 0,
                price = 50
            },
            
            ["Cream Finish"] = {
				order = 2,
                type = BODYGROUP,
                id = 5,
                value = 1,
				price = 100,
            },

            ["Black Finish"] = {
				order = 2,
                type = BODYGROUP,
                id = 5,
                value = 2,
				price = 100,
            },        
            
            ["Red Finish"] = {
				order = 2,
                type = BODYGROUP,
                id = 5,
                value = 3,
				price = 100,
            },         
            
            ["Vehicle Finish"] = {
				order = 2,
                type = BODYGROUP,
                id = 5,
                value = 4,
				price = 200,
            },
        },
    },

    ["sim_fphys_lambo_miura"] = {
        ["Respray Finishes"] = {
            order = 10,
                ["Stock Finish"] = { -- Default
                    order = 1,
                    type = SKIN,
                    value = 0,
                    price = 75
                },
                
                ["Matte Finish"] = {
                    order = 2,
                    type = SKIN,
                    value = 1,
                    price = 750
                },
            }
    },         
    
    ["sim_fphys_l4d_ambulance"] = {
        ["Respray Finishes"] = {
			order = 10,
            ["Stock Finish"] = { -- Default
				order = 1,
                type = SKIN,
                value = 0,
				price = 75
            },
            
            ["Ambulance Skin"] = {
				order = 2,
                type = SKIN,
                value = 1,
				price = 100
            }
        }
    },     
    
    ["sim_fphys_lancia_stradale"] = {
        ["Respray Finishes"] = {
			order = 10,
            ["Stock Finish"] = { -- Default
				order = 1,
                type = SKIN,
                value = 0,
				price = 75
            },
            
            ["Race Finish"] = {
				order = 2,
                type = SKIN,
                value = 1,
				price = 500
            }
        }
    },     
    
    ["sim_fphys_robert_wrangler_fnf"] = {
		["Bumpers"] = {
			order = 2,
			["Front Bumper"] = {
				order = 1,
				sub = true,
				["No Bumper"] = {
					type = BODYGROUP,
					order = 1,
					id = 5,
					value = 0,
					price = 120,
				},
				["Steet Front Bumper"] = {
					order = 2,
					type = BODYGROUP,
					id = 5,
					value = 1,
					price = 300,
				},
			}, 
        },

        ["Spoiler"] = {
			order = 16,
            ["No Spoiler"] = { -- Default
                order = 1,
                type = BODYGROUP,
                id = 6,
                value = 0,
                price = 50
            },
            
            ["Low Level Spoiler (Black)"] = {
				order = 2,
                type = BODYGROUP,
                id = 6,
                value = 1,
				price = 120,
            }
        },

        ["Rear Accessories"] = {
			order = 11,
            ["No Cover"] = { -- Default
				order = 1,
                type = BODYGROUP,
                id = 7,
                value = 0,
				price = 20,
            },
            
            ["Wheel"] = {
				order = 2,
                type = BODYGROUP,
                id = 7,
                value = 1,
				price = 75,
            }
        },

        ["Respray Finishes"] = {
			order = 10,
            ["Stock Finish"] = { -- Default
				order = 1,
                type = SKIN,
                value = 0,
				price = 75
            },
            
            ["Skin 3"] = {
				order = 2,
                type = SKIN,
                value = 3,
				price = 150
            },

            ["Skin 11"] = {
				order = 2,
                type = SKIN,
                value = 11,
				price = 150
            },

            ["Skin 13"] = {
				order = 2,
                type = SKIN,
                value = 13,
				price = 150
            },

            ["Skin 15"] = {
				order = 2,
                type = SKIN,
                value = 15,
				price = 150
            },
        }
    },    
    
    ["sim_fphys_ford_raptor"] = {
		["Bumpers"] = {
			order = 2,
			["Front Bumper"] = {
				order = 1,
				sub = true,
				["No Bumper"] = {
					type = BODYGROUP,
					order = 1,
					id = 4,
					value = 0,
					price = 120,
				},
				["Steet Front Bumper"] = {
					order = 2,
					type = BODYGROUP,
					id = 4,
					value = 1,
					price = 300,
				},
				["Offroad Bumper (Black)"] = {
					order = 3,
					type = BODYGROUP,
					value = 2,
					id = 4,
					price = 500,
				},
				["Bull Bar Bumper"] = {
					order = 4,
					type = BODYGROUP,
					value = 3,
					id = 4,
					price = 600,
				}
			}, 
        },

        ["Spoiler"] = {
			order = 16,
            ["No Spoiler (Back Open)"] = {
                order = 1,
                type = BODYGROUP,
                id = 6,
                value = 0,
                price = 50
            },
            
            ["No Spoiler (Back Closed)"] = {
				order = 2,
                type = BODYGROUP,
                id = 6,
                value = 1,
				price = 60,
            },

            ["Offroad Spoiler"] = {
				order = 2,
                type = BODYGROUP,
                id = 6,
                value = 2,
				price = 150,
            }
        },
    },

    ["sim_fphys_m3e46gtr"] = {
        ["Respray Finishes"] = {
			order = 10,
            ["Stock Finish"] = { -- Default
                order = 1,
                type = BODYGROUP,
                id = 3,
                value = 0,
                price = 50
            },
            
            ["Blue Finish"] = {
				order = 2,
                type = BODYGROUP,
                id = 3,
                value = 1,
				price = 60,
            }
        }
    },

	["sim_fphys_mercedes_benz_560sel"] = {
        ["Windows"] = {
			order = 22,
            ["Stock Glass"] = { -- Default
				order = 1,
                type = BODYGROUP,
                id = 7,
                value = 0,
				price = 250,
            },
            
            ["Shaded Glass"] = {
				order = 2,
                type = BODYGROUP,
                id = 7,
                value = 1,
				price = 1000,
            },
			
            ["Bunker Glass"] = {
				order = 3,
                type = BODYGROUP,
                id = 7,
                value = 2,
				price = 2500,
            },
        },
        ["Respray Finishes"] = {
			order = 10,
            ["Stock Finish"] = { -- Default
                type = SKIN,
                value = 0,
				price = 75,
                order = 1
            },
            
            ["Finish 1"] = {
                type = SKIN,
                order = 2,
                value = 1,
				price = 250
            },
			
            ["Finish 2"] = {
                type = SKIN,
                value = 2,
				price = 350
            },

            ["Finish 3"] = {
                type = SKIN,
                value = 3,
				price = 350
            },
			
            ["Finish 4"] = {
                type = SKIN,
                value = 4,
				price = 350
            }
        },
	},
}

function PLUGIN:PluginLoaded()
    timer.Simple(1, function()
        for k, v in pairs (nut.plugin.list.cardealer.Vehicles) do
            if !nut.plugin.list.carcustomisation.CustomizationOptions[v.Identifier] then
                nut.plugin.list.carcustomisation.CustomizationOptions[v.Identifier] = {}
            end
        end
    end)
end