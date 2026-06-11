local PLUGIN = PLUGIN
PLUGIN.name = "Salaries"
PLUGIN.author = "JayyKashtaCodes"
PLUGIN.desc = "An NPC that gives you money when you deserve it."
PLUGIN.nextPayment = 0

if SERVER then
	local rankModels = { --the models and what payment people receive for having them
----------------------------------------------Militsiya----------------------------------------------------------------------------
	["models/strabe/sovietww2/militsiya/police/patrol/commissioner/police_commissioner_01.mdl"] = 125,
	
	["models/strabe/sovietww2/militsiya/police/patrol/commissioner/police_commissioner_02.mdl"] = 125,
	
	["models/strabe/sovietww2/militsiya/police/patrol/commissioner/police_commissioner_03.mdl"] = 125,
	
	["models/strabe/sovietww2/militsiya/police/patrol/commissioner/police_commissioner_04.mdl"] = 125,
	
	["models/strabe/sovietww2/militsiya/police/patrol/commissioner/police_commissioner_05.mdl"] = 125,
	
	["models/strabe/sovietww2/militsiya/police/patrol/commissioner/police_commissioner_06.mdl"] = 125,
	
	["models/strabe/sovietww2/militsiya/police/patrol/commissioner/police_commissioner_07.mdl"] = 125,
	
	["models/strabe/sovietww2/militsiya/police/patrol/officer/police_officer_patrol_01.mdl"] = 75,
	
	["models/strabe/sovietww2/militsiya/police/patrol/officer/police_officer_patrol_02.mdl"] = 75,
	
	["models/strabe/sovietww2/militsiya/police/patrol/officer/police_officer_patrol_03.mdl"] = 75,
	
	["models/strabe/sovietww2/militsiya/police/patrol/officer/police_officer_patrol_04.mdl"] = 75,
	
	["models/strabe/sovietww2/militsiya/police/patrol/officer/police_officer_patrol_05.mdl"] = 75,
	
	["models/strabe/sovietww2/militsiya/police/patrol/officer/police_officer_patrol_06.mdl"] = 75,
	
	["models/strabe/sovietww2/militsiya/police/patrol/officer/police_officer_patrol_07.mdl"] = 75,
	
	["models/strabe/sovietww2/militsiya/police/patrol/officer/police_officer_patrol_07.mdl"] = 75,
	
	["models/strabe/sovietww2/militsiya/police/patrol/patrolman/police_patrolman_01.mdl"] = 25,
	
	["models/strabe/sovietww2/militsiya/police/patrol/patrolman/police_patrolman_02.mdl"] = 25,
	
	["models/strabe/sovietww2/militsiya/police/patrol/patrolman/police_patrolman_03.mdl"] = 25,
	
	["models/strabe/sovietww2/militsiya/police/patrol/patrolman/police_patrolman_04.mdl"] = 25,
	
	["models/strabe/sovietww2/militsiya/police/patrol/patrolman/police_patrolman_05.mdl"] = 25,
	
	["models/strabe/sovietww2/militsiya/police/patrol/patrolman/police_patrolman_06.mdl"] = 25,
	
	["models/strabe/sovietww2/militsiya/police/patrol/patrolman/police_patrolman_07.mdl"] = 25,
	
	------------------------------------NKVD--------------------------------------------------------------------
	----------------Enlisted--------------------------
	
	["models/strabe/sovietww2/nkvd/uniform/service/enlisted/nkvd_enlisted_service_01.mdl"] = 50,
	
	["models/strabe/sovietww2/nkvd/uniform/service/enlisted/nkvd_enlisted_service_02.mdl"] = 50,
	
	["models/strabe/sovietww2/nkvd/uniform/service/enlisted/nkvd_enlisted_service_03.mdl"] = 50,
	
	["models/strabe/sovietww2/nkvd/uniform/service/enlisted/nkvd_enlisted_service_04.mdl"] = 50,
	
	["models/strabe/sovietww2/nkvd/uniform/service/enlisted/nkvd_enlisted_service_05.mdl"] = 50,
	
	["models/strabe/sovietww2/nkvd/uniform/service/enlisted/nkvd_enlisted_service_06.mdl"] = 50,
	
	["models/strabe/sovietww2/nkvd/uniform/service/enlisted/nkvd_enlisted_service_07.mdl"] = 50,

	["models/strabe/sovietww2/nkvd/uniform/parade/enlisted/nkvd_enlisted_parade_01.mdl"] = 50,
	
	["models/strabe/sovietww2/nkvd/uniform/parade/enlisted/nkvd_enlisted_parade_02.mdl"] = 50,
	
	["models/strabe/sovietww2/nkvd/uniform/parade/enlisted/nkvd_enlisted_parade_03.mdl"] = 50,
	
	["models/strabe/sovietww2/nkvd/uniform/parade/enlisted/nkvd_enlisted_parade_04.mdl"] = 50,
	
	["models/strabe/sovietww2/nkvd/uniform/parade/enlisted/nkvd_enlisted_parade_05.mdl"] = 50,
	
	["models/strabe/sovietww2/nkvd/uniform/parade/enlisted/nkvd_enlisted_parade_06.mdl"] = 50,
	
	["models/strabe/sovietww2/nkvd/uniform/parade/enlisted/nkvd_enlisted_parade_07.mdl"] = 50,

	----------------------------------------Officer-------------------------------------------------------------------------
	
	["models/strabe/sovietww2/nkvd/uniform/service/officer/nkvd_officer_service_01.mdl"] = 125,
	
	["models/strabe/sovietww2/nkvd/uniform/service/officer/nkvd_officer_service_02.mdl"] = 125,
	
	["models/strabe/sovietww2/nkvd/uniform/service/officer/nkvd_officer_service_03.mdl"] = 125,
	
	["models/strabe/sovietww2/nkvd/uniform/service/officer/nkvd_officer_service_04.mdl"] = 125,
	
	["models/strabe/sovietww2/nkvd/uniform/service/officer/nkvd_officer_service_05.mdl"] = 125,
	
	["models/strabe/sovietww2/nkvd/uniform/service/officer/nkvd_officer_service_06.mdl"] = 125,
	
	["models/strabe/sovietww2/nkvd/uniform/service/officer/nkvd_officer_service_07.mdl"] = 125,
	
	["models/strabe/sovietww2/nkvd/uniform/service/officer2/nkvd_officer_service2_01.mdl"] = 125,
	
	["models/strabe/sovietww2/nkvd/uniform/service/officer2/nkvd_officer_service2_02.mdl"] = 125,
	
	["models/strabe/sovietww2/nkvd/uniform/service/officer2/nkvd_officer_service2_03.mdl"] = 125,
	
	["models/strabe/sovietww2/nkvd/uniform/service/officer2/nkvd_officer_service2_04.mdl"] = 125,
	
	["models/strabe/sovietww2/nkvd/uniform/service/officer2/nkvd_officer_service2_05.mdl"] = 125,
	
	["models/strabe/sovietww2/nkvd/uniform/service/officer2/nkvd_officer_service2_06.mdl"] = 125,
	
	["models/strabe/sovietww2/nkvd/uniform/service/officer2/nkvd_officer_service2_07.mdl"] = 125,

	["models/strabe/sovietww2/nkvd/uniform/parade/officer/nkvd_officer_parade_01.mdl"] = 125,
	
	["models/strabe/sovietww2/nkvd/uniform/parade/officer/nkvd_officer_parade_02.mdl"] = 125,
	
	["models/strabe/sovietww2/nkvd/uniform/parade/officer/nkvd_officer_parade_03.mdl"] = 125,
	
	["models/strabe/sovietww2/nkvd/uniform/parade/officer/nkvd_officer_parade_04.mdl"] = 125,
	
	["models/strabe/sovietww2/nkvd/uniform/parade/officer/nkvd_officer_parade_05.mdl"] = 125,
	
	["models/strabe/sovietww2/nkvd/uniform/parade/officer/nkvd_officer_parade_06.mdl"] = 125,
	
	["models/strabe/sovietww2/nkvd/uniform/parade/officer/nkvd_officer_parade_07.mdl"] = 125,

	----------------------------------------General-----------------------------------------------------------------
	
	["models/strabe/sovietww2/nkvd/uniform/service/general/nkvd_general_service_01.mdl"] = 250,
	
	["models/strabe/sovietww2/nkvd/uniform/service/general/nkvd_general_service_02.mdl"] = 250,
	
	["models/strabe/sovietww2/nkvd/uniform/service/general/nkvd_general_service_03.mdl"] = 250,
	
	["models/strabe/sovietww2/nkvd/uniform/service/general/nkvd_general_service_04.mdl"] = 250,
	
	["models/strabe/sovietww2/nkvd/uniform/service/general/nkvd_general_service_05.mdl"] = 250,
	
	["models/strabe/sovietww2/nkvd/uniform/service/general/nkvd_general_service_06.mdl"] = 250,
	
	["models/strabe/sovietww2/nkvd/uniform/service/general/nkvd_general_service_07.mdl"] = 250,

	["models/strabe/sovietww2/nkvd/uniform/parade/general/nkvd_general_parade_01.mdl"] = 250,
	
	["models/strabe/sovietww2/nkvd/uniform/parade/general/nkvd_general_parade_02.mdl"] = 250,
	
	["models/strabe/sovietww2/nkvd/uniform/parade/general/nkvd_general_parade_03.mdl"] = 250,
	
	["models/strabe/sovietww2/nkvd/uniform/parade/general/nkvd_general_parade_04.mdl"] = 250,
	
	["models/strabe/sovietww2/nkvd/uniform/parade/general/nkvd_general_parade_05.mdl"] = 250,
	
	["models/strabe/sovietww2/nkvd/uniform/parade/general/nkvd_general_parade_06.mdl"] = 250,
	
	["models/strabe/sovietww2/nkvd/uniform/parade/general/nkvd_general_parade_07.mdl"] = 250,

	-----------------------------------------------------------------------------------------------------------
	---------------------------------------Military------------------------------------------------------------------------
	-----------------------------------------Enlisted----------------------------------------------------------
	["models/strabe/sovietww2/redarmy/uniform/parade/enlisted/ra_enlisted_parade_01.mdl"] = 25,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/enlisted/ra_enlisted_parade_02.mdl"] = 25,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/enlisted/ra_enlisted_parade_03.mdl"] = 25,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/enlisted/ra_enlisted_parade_04.mdl"] = 25,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/enlisted/ra_enlisted_parade_05.mdl"] = 25,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/enlisted/ra_enlisted_parade_06.mdl"] = 25,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/enlisted/ra_enlisted_parade_07.mdl"] = 25,

	["models/hts/comradebear/pm0v3/player/rkka/infantry/en/m43_s1_01.mdl"] = 25,

	["models/hts/comradebear/pm0v3/player/rkka/infantry/en/m43_s1_02.mdl"] = 25,

	["models/hts/comradebear/pm0v3/player/rkka/infantry/en/m43_s1_03.mdl"] = 25,

	["models/hts/comradebear/pm0v3/player/rkka/infantry/en/m43_s1_04.mdl"] = 25,

	["models/hts/comradebear/pm0v3/player/rkka/infantry/en/m43_s1_05.mdl"] = 25,

	["models/hts/comradebear/pm0v3/player/rkka/infantry/en/m43_s1_06.mdl"] = 25,

	["models/hts/comradebear/pm0v3/player/rkka/infantry/en/m43_s1_07.mdl"] = 25,

	--------------------------------------------------------------------------------
	["models/hts/comradebear/pm0v3/player/rkka/infantry/nco/m43_s1_01.mdl"] = 25,

	["models/hts/comradebear/pm0v3/player/rkka/infantry/nco/m43_s1_02.mdl"] = 25,

	["models/hts/comradebear/pm0v3/player/rkka/infantry/nco/m43_s1_03.mdl"] = 25,

	["models/hts/comradebear/pm0v3/player/rkka/infantry/nco/m43_s1_04.mdl"] = 25,

	["models/hts/comradebear/pm0v3/player/rkka/infantry/nco/m43_s1_05.mdl"] = 25,

	["models/hts/comradebear/pm0v3/player/rkka/infantry/nco/m43_s1_06.mdl"] = 25,

	["models/hts/comradebear/pm0v3/player/rkka/infantry/nco/m43_s1_07.mdl"] = 25,

	-----------------------------------------Officer----------------------------------------------------------

	["models/strabe/sovietww2/redarmy/uniform/parade/officer/ra_officer_parade_01.mdl"] = 75,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/officer/ra_officer_parade_02.mdl"] = 75,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/officer/ra_officer_parade_03.mdl"] = 75,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/officer/ra_officer_parade_04.mdl"] = 75,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/officer/ra_officer_parade_05.mdl"] = 75,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/officer/ra_officer_parade_06.mdl"] = 75,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/officer/ra_officer_parade_07.mdl"] = 75,

	["models/strabe/sovietww2/redarmy/uniform/service/officer/ra_officer_service_01.mdl"] = 75,
	
	["models/strabe/sovietww2/redarmy/uniform/service/officer/ra_officer_service_02.mdl"] = 75,
	
	["models/strabe/sovietww2/redarmy/uniform/service/officer/ra_officer_service_03.mdl"] = 75,
	
	["models/strabe/sovietww2/redarmy/uniform/service/officer/ra_officer_service_04.mdl"] = 75,
	
	["models/strabe/sovietww2/redarmy/uniform/service/officer/ra_officer_service_05.mdl"] = 75,
	
	["models/strabe/sovietww2/redarmy/uniform/service/officer/ra_officer_service_06.mdl"] = 75,
	
	["models/strabe/sovietww2/redarmy/uniform/service/officer/ra_officer_service_07.mdl"] = 75,

	["models/hts/comradebear/pm0v3/player/rkka/infantry/co/m43_s1_01.mdl"] = 75,

	["models/hts/comradebear/pm0v3/player/rkka/infantry/co/m43_s1_02.mdl"] = 75,

	["models/hts/comradebear/pm0v3/player/rkka/infantry/co/m43_s1_03.mdl"] = 75,

	["models/hts/comradebear/pm0v3/player/rkka/infantry/co/m43_s1_04.mdl"] = 75,

	["models/hts/comradebear/pm0v3/player/rkka/infantry/co/m43_s1_05.mdl"] = 75,

	["models/hts/comradebear/pm0v3/player/rkka/infantry/co/m43_s1_06.mdl"] = 75,

	["models/hts/comradebear/pm0v3/player/rkka/infantry/co/m43_s1_07.mdl"] = 75,
	
	----------------------------------------------Specialist Officer--------------------------------------------------------------------------
	
	["models/strabe/sovietww2/redarmy/uniform/service/specialistofficer/ra_specialist_officer_service_01.mdl"] = 75,
	
	["models/strabe/sovietww2/redarmy/uniform/service/specialistofficer/ra_specialist_officer_service_02.mdl"] = 75,
	
	["models/strabe/sovietww2/redarmy/uniform/service/specialistofficer/ra_specialist_officer_service_03.mdl"] = 75,
	
	["models/strabe/sovietww2/redarmy/uniform/service/specialistofficer/ra_specialist_officer_service_04.mdl"] = 75,
	
	["models/strabe/sovietww2/redarmy/uniform/service/specialistofficer/ra_specialist_officer_service_05.mdl"] = 75,
	
	["models/strabe/sovietww2/redarmy/uniform/service/specialistofficer/ra_specialist_officer_service_06.mdl"] = 75,
	
	["models/strabe/sovietww2/redarmy/uniform/service/specialistofficer/ra_specialist_officer_service_07.mdl"] = 75,

	["models/strabe/sovietww2/redarmy/uniform/parade/specialistofficer/ra_specialist_officer_parade_01.mdl"] = 75,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/specialistofficer/ra_specialist_officer_parade_02.mdl"] = 75,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/specialistofficer/ra_specialist_officer_parade_03.mdl"] = 75,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/specialistofficer/ra_specialist_officer_parade_04.mdl"] = 75,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/specialistofficer/ra_specialist_officer_parade_05.mdl"] = 75,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/specialistofficer/ra_specialist_officer_parade_06.mdl"] = 75,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/specialistofficer/ra_specialist_officer_parade_07.mdl"] = 75,
	-----------------------------------------General----------------------------------------------------------
	
	["models/strabe/sovietww2/redarmy/uniform/parade/general/ra_general_parade_01.mdl"] = 125,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/general/ra_general_parade_02.mdl"] = 125,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/general/ra_general_parade_03.mdl"] = 125,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/general/ra_general_parade_04.mdl"] = 125,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/general/ra_general_parade_05.mdl"] = 125,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/general/ra_general_parade_06.mdl"] = 125,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/general/ra_general_parade_07.mdl"] = 125,

	["models/strabe/sovietww2/redarmy/uniform/service/general/ra_general_service_01.mdl"] = 125,
	
	["models/strabe/sovietww2/redarmy/uniform/service/general/ra_general_service_02.mdl"] = 125,
	
	["models/strabe/sovietww2/redarmy/uniform/service/general/ra_general_service_03.mdl"] = 125,
	
	["models/strabe/sovietww2/redarmy/uniform/service/general/ra_general_service_04.mdl"] = 125,
	
	["models/strabe/sovietww2/redarmy/uniform/service/general/ra_general_service_05.mdl"] = 125,
	
	["models/strabe/sovietww2/redarmy/uniform/service/general/ra_general_service_06.mdl"] = 125,
	
	["models/strabe/sovietww2/redarmy/uniform/service/general/ra_general_service_07.mdl"] = 125,
	

	-----------------------------------------Marshal----------------------------------------------------------
	
	["models/strabe/sovietww2/redarmy/uniform/parade/marshal/ra_marshal_parade_01.mdl"] = 250,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/marshal/ra_marshal_parade_02.mdl"] = 250,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/marshal/ra_marshal_parade_03.mdl"] = 250,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/marshal/ra_marshal_parade_04.mdl"] = 250,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/marshal/ra_marshal_parade_05.mdl"] = 250,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/marshal/ra_marshal_parade_06.mdl"] = 250,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/marshal/ra_marshal_parade_07.mdl"] = 250,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/marshalssr/ra_marshalssr_parade_01.mdl"] = 500,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/marshalssr/ra_marshalssr_parade_02.mdl"] = 500,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/marshalssr/ra_marshalssr_parade_03.mdl"] = 500,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/marshalssr/ra_marshalssr_parade_04.mdl"] = 500,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/marshalssr/ra_marshalssr_parade_05.mdl"] = 500,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/marshalssr/ra_marshalssr_parade_06.mdl"] = 500,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/marshalssr/ra_marshalssr_parade_07.mdl"] = 500,
	
	["models/strabe/sovietww2/redarmy/uniform/parade/marshalssr/ra_marshalssr_parade_07.mdl"] = 500,

	["models/strabe/sovietww2/redarmy/uniform/service/marshal/ra_marshal_service_01.mdl"] = 250,
	
	["models/strabe/sovietww2/redarmy/uniform/service/marshal/ra_marshal_service_02.mdl"] = 250,
	
	["models/strabe/sovietww2/redarmy/uniform/service/marshal/ra_marshal_service_03.mdl"] = 250,
	
	["models/strabe/sovietww2/redarmy/uniform/service/marshal/ra_marshal_service_04.mdl"] = 250,
	
	["models/strabe/sovietww2/redarmy/uniform/service/marshal/ra_marshal_service_05.mdl"] = 250,
	
	["models/strabe/sovietww2/redarmy/uniform/service/marshal/ra_marshal_service_06.mdl"] = 250,
	
	["models/strabe/sovietww2/redarmy/uniform/service/marshal/ra_marshal_service_07.mdl"] = 250,

------------------------------------------------------------------------------------------------------------------
----------------------------------------------Militsiya------------------------------------------------------------------------	
	["models/strabe/sovietww2/militsiya/police/patrol/commissioner/police_commissioner_01.mdl"] = 125,
	
	["models/strabe/sovietww2/militsiya/police/patrol/commissioner/police_commissioner_02.mdl"] = 125,
	
	["models/strabe/sovietww2/militsiya/police/patrol/commissioner/police_commissioner_03.mdl"] = 125,
	
	["models/strabe/sovietww2/militsiya/police/patrol/commissioner/police_commissioner_04.mdl"] = 125,
	
	["models/strabe/sovietww2/militsiya/police/patrol/commissioner/police_commissioner_05.mdl"] = 125,
	
	["models/strabe/sovietww2/militsiya/police/patrol/commissioner/police_commissioner_06.mdl"] = 125,
	
	["models/strabe/sovietww2/militsiya/police/patrol/commissioner/police_commissioner_07.mdl"] = 125,
	
	["models/strabe/sovietww2/militsiya/police/patrol/officer/police_officer_patrol_01.mdl"] = 75,
	
	["models/strabe/sovietww2/militsiya/police/patrol/officer/police_officer_patrol_02.mdl"] = 75,
	
	["models/strabe/sovietww2/militsiya/police/patrol/officer/police_officer_patrol_03.mdl"] = 75,
	
	["models/strabe/sovietww2/militsiya/police/patrol/officer/police_officer_patrol_04.mdl"] = 75,
	
	["models/strabe/sovietww2/militsiya/police/patrol/officer/police_officer_patrol_05.mdl"] = 75,
	
	["models/strabe/sovietww2/militsiya/police/patrol/officer/police_officer_patrol_06.mdl"] = 75,
	
	["models/strabe/sovietww2/militsiya/police/patrol/officer/police_officer_patrol_07.mdl"] = 75,
	
	["models/strabe/sovietww2/militsiya/police/patrol/patrolman/police_patrolman_01.mdl"] = 25,
	
	["models/strabe/sovietww2/militsiya/police/patrol/patrolman/police_patrolman_02.mdl"] = 25,
	
	["models/strabe/sovietww2/militsiya/police/patrol/patrolman/police_patrolman_03.mdl"] = 25,
	
	["models/strabe/sovietww2/militsiya/police/patrol/patrolman/police_patrolman_04.mdl"] = 25,
	
	["models/strabe/sovietww2/militsiya/police/patrol/patrolman/police_patrolman_05.mdl"] = 25,
	
	["models/strabe/sovietww2/militsiya/police/patrol/patrolman/police_patrolman_06.mdl"] = 25,
	
	["models/strabe/sovietww2/militsiya/police/patrol/patrolman/police_patrolman_07.mdl"] = 25,
	
	---------------------------------------------------------------------------------------------------------------------------------------------
	
	
	
	["models/soviet/sovietmodels/m32telogreika_stalin_karl.mdl"] = 100,
	
	["models/soviet/sovietmodels/m32telogreika_m43.mdl"] = 100,
	
	["models/soviet/sovietmodels/m35tunic_1.mdl"] = 100,
	
	["models/soviet/sovietmodels/m43_karl.mdl"] = 100,
	
	["models/soviet/sovietmodels/m43amoeba_karl.mdl"] = 100,
	
	["models/soviet/sovietmodels/M43navy_greatcoat_Karl.mdl"] = 100,
	
	["models/soviet/sovietmodels/m43officer_inf_karl.mdl"] = 100,
	
	["models/soviet/sovietmodels/m43officer_karl.mdl"] = 100,
	
	["models/soviet/sovietmodels/M43officer_wincoat_Karl.mdl"] = 100,
	
	["models/soviet/sovietmodels/M43sn42_Karl.mdl"] = 100,
	----------------------Partisan----------------------------------------
	
	["models/soviet/sovietmodels/Partisan_Karl.mdl"] = 100,
	
	["models/soviet/sovietmodels/Partisan2_Karl.mdl"] = 100,
	
	["models/soviet/sovietmodels/Partisan3_Karl.mdl"] = 100,
	
	["models/soviet/sovietmodels/Partisan4_Karl.mdl"] = 100,
	----------Government--------------------------------------------------
	----------Upper Government-------------
	
	["models/soviet/sovietmodels/updated/male_01_closed_coat_tie_updated.mdl"] = 500,
	
	["models/soviet/sovietmodels/updated/male_02_closed_coat_tie_updated.mdl"] = 500,
	
	["models/soviet/sovietmodels/updated/male_03_closed_coat_tie_updated.mdl"] = 500,
	
	["models/soviet/sovietmodels/updated/male_04_closed_coat_tie_updated.mdl"] = 500,
	
	["models/soviet/sovietmodels/updated/male_05_closed_coat_tie_updated.mdl"] = 500,
	
	["models/soviet/sovietmodels/updated/male_06_closed_coat_tie_updated.mdl"] = 500,
	
	["models/soviet/sovietmodels/updated/male_07_closed_coat_tie_updated.mdl"] = 500,
	
	["models/soviet/sovietmodels/updated/male_08_closed_coat_tie_updated.mdl"] = 500,
	
	["models/soviet/sovietmodels/updated/male_09_closed_coat_tie_updated.mdl"] = 500,
	
	["models/soviet/soviet_command/Soviet_Formal_Dress_Officer.mdl"] = 100,
	
	["models/soviet/soviet_command/Soviet_Formal_Dress_Officer2.mdl"] = 100,
	
	["models/soviet/soviet_command/Soviet_Formal_Dress_Officer_highcommand.mdl"] = 100,
-------------------------------Stalin---------------------------------------------------------------------------------------------------------------------------------------------	
	["models/soviet/soviet_command/Stalin.mdl"] = 1000,
	
	["models/soviet/soviet_command/wincoat_stalin.mdl"] = 1000,
	-------------------------Civilian------------------------------------------------------------------------------------------------------------------------------------------
	
	["models/sentry/suanro/male_09_open_waistcoatpm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_08_open_waistcoatpm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_07_open_waistcoatpm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_06_open_waistcoatpm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_05_open_waistcoatpm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_03_open_waistcoatpm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_02_open_waistcoatpm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_01_open_waistcoatpm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_09_closed_tiepm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_08_closed_tiepm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_07_closed_tiepm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_06_closed_tiepm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_05_closed_tiepm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_04_closed_tiepm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_03_closed_tiepm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_02_closed_tiepm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_01_closed_tiepm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_09_shirt_tiepm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_08_shirt_tiepm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_07_shirt_tiepm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_06_shirt_tiepm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_05_shirt_tiepm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_04_shirt_tiepm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_03_shirt_tiepm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_02_shirt_tiepm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_01_shirt_tiepm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_09_shirtpm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_08_shirtpm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_07_shirtpm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_08_shirtpm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_06_shirtpm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_05_shirtpm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_04_shirtpm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_03_shirtpm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_02_shirtpm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_01_shirtpm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_09_open_tiepm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_08_open_tiepm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_07_open_tiepm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_06_open_tiepm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_05_open_tiepm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_04_open_tiepm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_03_open_tiepm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_02_open_tiepm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_01_open_tiepm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_09_openpm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_08_openpm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_07_openpm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_06_openpm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_05_openpm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_04_openpm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_03_openpm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_02_openpm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_01_openpm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_09_closed_coat_tiepm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_08_closed_coat_tiepm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_07_closed_coat_tiepm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_06_closed_coat_tiepm.mdl"] = 10,
	
	
	
	["models/sentry/suanro/male_05_closed_coat_tiepm.mdl"] = 10,
	
	["models/sentry/suanro/male_04_closed_coat_tiepm.mdl"] = 10,
	
	["models/sentry/suanro/male_03_closed_coat_tiepm.mdl"] = 10,
	
	["models/sentry/suanro/male_02_closed_coat_tiepm.mdl"] = 10,
		
	["models/sentry/suanro/male_01_closed_coat_tiepm.mdl"] = 10,
	
	["models/sentry/sentryoldmob/oldgoons/sentrybusi1male8pm.mdl"] = 10,
	
	["models/sentry/sentryoldmob/oldgoons/sentrybusi1male7pm.mdl"] = 10,
	
	["models/sentry/sentryoldmob/oldgoons/sentrybusi1male6pm.mdl"] = 10,
	
	["models/sentry/sentryoldmob/oldgoons/sentrybusi1male4pm.mdl"] = 10,
	
	["models/sentry/sentryoldmob/oldgoons/sentrybusi1male2pm.mdl"] = 10,
	
	["models/sentry/sentryoldmob/oldgoons/sentryarmbmale8pm.mdl"] = 10,
	
	["models/sentry/sentryoldmob/oldgoons/sentryarmbmale6pm.mdl"] = 10,
	
	["models/sentry/sentryoldmob/oldgoons/sentryarmbmale2pm.mdl"] = 10,
	
	
	
	["models/sentry/sentryoldmob/mafia/sentrymobmale9pm.mdl"] = 10,
	
	["models/sentry/sentryoldmob/mafia/sentrymobmale8pm.mdl"] = 10,
	
	["models/sentry/sentryoldmob/mafia/sentrymobmale7pm.mdl"] = 10,
	
	["models/sentry/sentryoldmob/mafia/sentrymobmale6pm.mdl"] = 10,
	
	["models/sentry/sentryoldmob/mafia/sentrymobmale4pm.mdl"] = 10,
	
	["models/sentry/sentryoldmob/mafia/sentrymobmale2pm.mdl"] = 10,
	
	
	
	["models/sentry/sentryoldmob/irish/sentryirishmale9pm.mdl"] = 10,
	
	["models/sentry/sentryoldmob/irish/sentryirishmale8pm.mdl"] = 10,
	
	["models/sentry/sentryoldmob/irish/sentryirishmale7pm.mdl"] = 10,
	
	["models/sentry/sentryoldmob/irish/sentryirishmale6pm.mdl"] = 10,
	
	["models/sentry/sentryoldmob/irish/sentryirishmale4pm.mdl"] = 10,
	
	["models/sentry/sentryoldmob/irish/sentryirishmale2pm.mdl"] = 10,
	
	["models/sentry/sentryoldmob/oldgoons/sentrybusi1male8pm.mdl"] = 10,
	
	["models/sentry/sentryoldmob/chinese/oldchinesegoonpm.mdl"] = 10,
	
	["models/sentry/sentryoldmob/oldgoons/sentrybusi1male9pm.mdl"] = 10,
	
	["models/ibz/rkka/general_officers/m35_1941_01_general.mdl"] = 10,
	
	["models/ibz/rkka/general_officers/m35_1941_02_general."] = 10,
	
	["models/ibz/rkka/general_officers/m35_1941_05_general.mdl"] = 10,
	
	["models/ibz/rkka/general_officers/m35_1941_06_general.mdl"] = 10,
	
	["models/ibz/rkka/general_officers/m35_1941_01_general_dress.mdl"] = 10,
	
	["models/ibz/rkka/general_officers/m35_1941_02_general_dress.mdl"] = 10,
	
	["models/ibz/rkka/general_officers/m35_1941_05_general_dress.mdl"] = 10,
	
	["models/ibz/rkka/general_officers/m35_1941_06_general_dress.mdl"] = 10,
	
	["models/player/pa/compiled 0.34/panavyofficer_male01.mdl"] = 10,

}
classList = {
	----------------------
	["gen_sec"] = 3500,
	---------------------
	["rkka_nco"] = 25,
	["rkka_co"] = 50,
	["rkka_gen"] = 75,
	["rkka_marsh"] = 150,
	---------------------
	["nkvd_nco"] = 25,
	["nkvd_co"] = 50,
	["nkvd_gen"] = 75,
	["nkvd_comm"] = 150,
	---------------------
	["milit_nco"] = 25,
	["milit_co"] = 50,
	["milit_gen"] = 75,
	["milit_comm"] = 100,
	----------------------
}

function PLUGIN:Think()
	if CurTime() > self.nextPayment then
		for _, v in pairs(player.GetAll()) do
			if IsValid(v) and v:getChar() then
				local char = v:getChar()
				local modelValue = rankModels[v:GetModel()]
				
				local amount = (modelValue or 0)
				
				char:setData("earnings", char:getData("earnings", 0) + amount)
				if modelValue then
					v:notify("You have been paid " .. amount .. " Rubles. Go to the bank to retrieve it.")
				end
			--------------------------------------------------------------------------------------------------------------------
				if (char:getClass()) then
					local playerClass = char:getClass()
					local className = nut.class.list[playerClass].uniqueID
					local classValue = classList[className]
					
					local amount = (classValue or 0)
					
					char:setData("earnings", char:getData("earnings", 0) + amount)
					if classValue then
						v:notify("You have been paid an Bonus " .. amount .. " Rubles. Go to the bank to retrieve it.")
					end
				end
			end
		end
		
		self.nextPayment = CurTime() + nut.config.get("PaymentInterval")
	end
end

function PLUGIN:SaveData()
	local data = {}
		for k, v in ipairs(ents.FindByClass("nut_salary")) do
			data[#data + 1] = {
				name = v:getNetVar("name"),
				desc = v:getNetVar("desc"),
				pos = v:GetPos(),
				angles = v:GetAngles(),
				model = v:GetModel(),
				material = v:GetMaterial()
			}
		end
	self:setData(data)
end

function PLUGIN:LoadData()
	for k, v in ipairs(ents.FindByClass("nut_salary")) do
		v:Remove()
	end	
	for k, v in ipairs(self:getData() or {}) do
		local entity = ents.Create("nut_salary")
		entity:SetPos(v.pos)
		entity:SetAngles(v.angles)
		entity:Spawn()
		entity:SetModel(v.model)
		entity:SetMaterial(v.material)
	end
end
end