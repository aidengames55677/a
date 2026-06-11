-- "gamemodes\\mafiarp\\plugins\\nypdsergeant\\cl_config.lua"


local PLUGIN = PLUGIN

PLUGIN.ScoreNeeded = 70 -- What percentage is needed for people to pass the test?

PLUGIN.QUESTION_TYPE = {
    SINGLE_CHOICE = 1, -- One single answer across a single choice.
    MULTIPLE_CHOICE = 2, -- Numerous answers across numerous choices.
    ORDERED_LIST = 3 -- Must be ordered in a certain way. Choices can be re-arranged into the correct answer. Always goes from first to last.
}

PLUGIN:RegisterQuestion {
    Type = PLUGIN.QUESTION_TYPE.SINGLE_CHOICE,
    Description = "Which gear is not allowed for a cadet?",
    Options = {
        [1] = "Taser",
        [2] = "Baton",
        [3] = "Handgun"
    },
    Answer = 3,
    Score = 1
}

PLUGIN:RegisterQuestion {
    Type = PLUGIN.QUESTION_TYPE.SINGLE_CHOICE,
    Description = "Can you carry a shotgun at the rank of Officer?",
    Options = {
        [1] = "Yes",
        [2] = "No"
    },
    Answer = 1,
    Score = 1
}

PLUGIN:RegisterQuestion {
    Type = PLUGIN.QUESTION_TYPE.ORDERED_LIST,
    Description = "What order do the NYPD Bells follow? (Most Severe at the TOP to Least Severe at the bottom)",
    Options = {
        [1] = "Black",
        [2] = "Green",
        [3] = "Red",
        [4] = "Orange",
        [5] = "Yellow"
    },
    Answer = {
        1, 3, 4, 5, 2
    },
    Score = 5
}

PLUGIN:RegisterQuestion {
    Type = PLUGIN.QUESTION_TYPE.ORDERED_LIST,
    Description = "Fill in the correct order of the Tactical Communication Process. (Step 1 at the TOP to the last step at the bottom)",
    Options = {
        [1] = "Explanation",
        [2] = "Options/Instructions",
        [3] = "Arrest/Detainment",
        [4] = "Introduction",
        [5] = "Assesment",
        [6] = "Final Warning"
    },
    Answer = {
        4, 1, 5, 2, 6, 3
    },
    Score = 6
}

PLUGIN:RegisterQuestion {
    Type = PLUGIN.QUESTION_TYPE.SINGLE_CHOICE,
    Description = "Is charging a person more than once for the same thing allowed?",
    Options = {
        [1] = "Yes",
        [2] = "No"
    },
    Answer = 2,
    Score = 1
}

PLUGIN:RegisterQuestion {
    Type = PLUGIN.QUESTION_TYPE.SINGLE_CHOICE,
    Description = "Do all Bureaus have uniform guidelines that you must follow?",
    Options = {
        [1] = "Yes",
        [2] = "No"
    },
    Answer = 1,
    Score = 1
}

PLUGIN:RegisterQuestion {
    Type = PLUGIN.QUESTION_TYPE.MULTIPLE_CHOICE,
    Description = "Before and during an arrest, an officer should: (Multiple Answers)",
    Options = {
        [1] = "Read the suspect their Miranda Rights",
        [2] = "Have Probable Cause",
        [3] = "Check if an arrest warrant for the accused exists",
        [4] = "Use the proper tactical communications (tac-coms) process",
        [5] = "Disrespect the accused",
        [6] = "Use the most minimal level of force required to make the arrest"
    },
    Answer = {
        1, 2, 3, 4, 6
    },
    Score = 5
}

PLUGIN:RegisterQuestion {
    Type = PLUGIN.QUESTION_TYPE.SINGLE_CHOICE,
    Description = "Should the NYPD should be a toxic environment where you bully and harass other officers when they do something wrong?",
    Options = {
        [1] = "Yes",
        [2] = "No"
    },
    Answer = 2,
    Score = 1
}

PLUGIN:RegisterQuestion {
    Type = PLUGIN.QUESTION_TYPE.MULTIPLE_CHOICE,
    Description = "After an arrest is made, rights have been read, and you are at holding cells, what should officers do? (Multiple Answers)",
    Options = {
        [1] = "If the accused wants a case, transfer them to the prison whilst attempting to organise defence, prosecution and judge.",
        [2] = "Yell at and intimidate the accused as a tactic to illicit a confession.",
        [3] = "If the accused has drugs/contraband/illegal weapons, the officer does /me takes photo of the suspect's inventory, so that the officer can confiscate the items.",
        [4] = "Request a lawyer if the accused ask for one.",
        [5] = "Attempt to Question and get more evidence that may be used against the accused",
        [6] = "Attempt to sign a plea deal with the accused for less charges and half a sentence (Getting it approved by a DA or Supervisor)",
        [7] = "Drop all charges because its too hard."
    },
    Answer = {
        1, 4, 3, 5, 6
    },
    Score = 5
}

PLUGIN:RegisterQuestion {
    Type = PLUGIN.QUESTION_TYPE.MULTIPLE_CHOICE,
    Description = "What do you do when you search someone and need to use their inventory as evidence, such as when you find contraband? (Multiple Answers)",
    Options = {
        [1] = "Confiscate it all then type '/me takes photo' (and screenshot) your own inventory for the evidence channel",
        [2] = "Just take their stuff without proper '/me takes a photo.'",
        [3] = "Type '/me takes photo' (and screenshot) their inventory for the evidence channel.",
        [4] = "Get the suspect to drop everything and type '/me takes photo' (and screenshot) of the evidence on the ground for the evidence channel",
        [5] = "Put on gloves by typing '/me puts on gloves' before searching the suspect"
    },
    Answer = {
        3, 5
    },
    Score = 2
}

PLUGIN:RegisterQuestion {
    Type = PLUGIN.QUESTION_TYPE.SINGLE_CHOICE,
    Description = "A cadet starts using his pager and messages the high command. What should the cadet do instead?",
    Options = {
        [1] = "Nothing, still continue to message the High Command.",
        [2] = "Speak to the next chain of command. For example, an officer."
    },
    Answer = 2,
    Score = 1
}

PLUGIN:RegisterQuestion {
    Type = PLUGIN.QUESTION_TYPE.MULTIPLE_CHOICE,
    Description = "An Officer (A) sees another officer (B) committing infractions against civilians or PD. What are the options (A) officer can utilize? (Multiple Answers)",
    Options = {
        [1] = "Make an IA report with proper evidence/witness",
        [2] = "If the (B) officer poses a threat to others or himself, the (A) officer must use tactical options depending on the situation.",
        [3] = "Go and publicly punish the (B) officer in the middle of the PD.",
        [4] = "Inform an available Supervisor on shift.",
        [5] = "Confront the officer directly in an attempt to stop the infractions."
    },
    Answer = {
        1, 2, 4
    },
    Score = 3
}

PLUGIN:RegisterQuestion {
    Type = PLUGIN.QUESTION_TYPE.SINGLE_CHOICE,
    Description = "Should all Plea Deals be submitted to the Government Website using a Plea-Deal File made by the Officer?",
    Options = {
        [1] = "Yes",
        [2] = "No"
    },
    Answer = 1,
    Score = 1
}

PLUGIN:RegisterQuestion {
    Type = PLUGIN.QUESTION_TYPE.SINGLE_CHOICE,
    Description = "Must officers obey all federal, state and city laws?",
    Options = {
        [1] = "Yes",
        [2] = "No"
    },
    Answer = 1,
    Score = 1
}

PLUGIN:RegisterQuestion {
    Type = PLUGIN.QUESTION_TYPE.SINGLE_CHOICE,
    Description = "True or False: All IA (Internal Affairs) decisions are respected, but they can be appealed. ",
    Options = {
        [1] = "True",
        [2] = "False"
    },
    Answer = 1,
    Score = 1
}