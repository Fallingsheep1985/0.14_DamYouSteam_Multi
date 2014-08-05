
//####----####----####---- Base Building 1.3 Start ----####----####----####

/****************************************************** These Settings Can Be Edited ******************************************************/
/********************************** For more information on these settings, view 'Configuration ReadMe' ***********************************/
/***************************************************************** Admins *****************************************************************/
	BBSuperAdminAccess			= ["120958982","#####"]; //Replace with your high level admin playerUIDs for base building (High level admins have access to all functions of all BB items, even if they don't belong to them)
	BBLowerAdminAccess			= ["####","####"]; //Replace with your lower level admin playerUIDs for base building (Low level admins can only remove items that don't belong to them)

/************************************************************* Flag Settings **************************************************************/
	BBTypeOfFlag				= "FlagCarrierBIS_EP1"; //Type of flag Base Building 1.3 will use, you can select any of the flags from the BBAllFlagTypes array (default is FlagCarrierBIS_EP1)
	BBAllFlagTypes				= ["FlagCarrierBAF","FlagCarrierBIS_EP1","FlagCarrierBLUFOR_EP1","FlagCarrierCDF_EP1","FlagCarrierCDFEnsign_EP1","FlagCarrierCzechRepublic_EP1","FlagCarrierGermany_EP1","FlagCarrierINDFOR_EP1","FlagCarrierUSA_EP1"];//DO NOT REMOVE ITEMS FROM THIS ARRAY, you can ADD a flag type if you want a different flag, you will also need to add a picture for it to missionFolder\buildRecipeBook\images\buildable\! You will also need to add it to the safeObjects array below and to your database!
	BBMaxPlayerFlags			= 3; //This sets how many flags a player can be added to, default is 3
	BBFlagRadius				= 200; //This sets the build radius around a flag, default is 200

/********************************************************* Removal Chance Settings ********************************************************/
	BBtblProb					= 30; //Base chance level for loosing toolbox
	BBlowP						= 35; //Base lower chance level for failing to remove item
	BBmedP						= 70; //Base medium chance level for failing to remove item
	BBhighP						= 95; //Base high chance level for failing to remove item
	
/**************************************************** Zombie Shield Generator Settings ****************************************************/
	BBEnableZShield				= 1; //Enable toggleable zombie shield generator/ 1 = Enabled // 0 = Disabled (If disabled, players can still build shield generators, they just wont do anything)
	BBTypeOfZShield				= "CDF_WarfareBUAVterminal"; //Type of object used for Zombie Shield, included this only in case some maps have this object banned
	BBAllZShieldTypes			= ["CDF_WarfareBUAVterminal"]; //DO NOT REMOVE ITEMS FROM THIS ARRAY, you can ADD an object class if you want a different building to be used as a Zombie Shield Generator!
	BBMaxZShields				= 1; //Maximum number of zombie shield generators a player can be added to, default is 1
	BBZShieldRadius				= 100; //Radius for Base Build zombie shield generator, default is 50
	BBZShieldClean				= 0; //Delete Zombies when they enter active shield radius/ 1 = Enabled // 0 = Disabled (If disabled, zombies will be killed but not deleted, could lead to zombie loot farming)
	BBZShieldDis				= 1; //Limits the distance shield generators can be built from flags to (BBFlagRadius - BBZShieldRadius)/ 1 = Enabled // 0 = Disabled (If you reduce the flag radius, you may need to disable this)

/********************************************************* Miscellaneous Settings *********************************************************/
	BBAIGuards					= 0; //Sarge AI Base Guards/ 1 = Enabled // 0 = Disabled (Requires Sarge AI)
	BBUseTowerLights			= 1; //Enable toggleable tower lighting/ 1 = Enabled // 0 = Disabled (If you run AxeMan's tower lighting on your server, read the instructions on how to modify it)
	BBTowerLightsNGen			= true; //Require generator for base building tower lighting?
	BBCustomDebug				= "debugMonitor"; //Change debugMonitor to whatever variable your custom debug uses, this allows Base Building to hide the debug monitor where needed
	//BBCustomDebugS				= [] spawn fnc_debug; //Change to whatever your debug monitor uses to activate, this allows Base Building to restore the debug monitor if it closed it
	
	//If you add items to the build list, you also need to add them to the SafeObjects array. Remember you will also need to add them to your database for them to be saved.
	SafeObjects = ["MAP_picture_a",
"MAP_picture_a_02",
"MAP_picture_a_03",
"MAP_picture_a_04",
"MAP_picture_a_05",
"MAP_picture_b",
"MAP_picture_b_02",
"MAP_picture_c",
"MAP_picture_c_02",
"MAP_picture_d",
"MAP_picture_e",
"MAP_picture_f",
"MAP_picture_f_02",
"MAP_picture_g",
"MAP_wall_board",
"MAP_wall_board_02",
"MAP_wall_board_03",
"MAP_F_ch_mod_c",
"MAP_ch_mod_h",
"MAP_armchair",
"MAP_ch_mod_h",
"MAP_ch_office_B",
"MAP_chair",
"MAP_Church_chair",
"MAP_hospital_bench",
"MAP_kitchen_chair_a",
"MAP_lavicka_1",
"MAP_lavicka_2",
"MAP_lavicka_3",
"MAP_lavicka_4",
"MAP_lobby_chair",
"MAP_office_chair",
"MAP_F_postel_manz_kov",
"MAP_F_postel_panelak1",
"MAP_F_postel_panelak2",
"MAP_F_Vojenska_palanda",
"MAP_postel_manz_kov",
"MAP_postel_panelak1",
"MAP_vojenska_palanda",
"MAP_fridge",
"MAP_Kitchenstove_Elec",
"MAP_washing_machine",
"MAP_P_Basin_A",
"MAP_P_bath",
"MAP_F_bath",
"MAP_lekarnicka",
"MAP_P_sink",
"MAP_toilet_b",
"MAP_P_toilet_b_02",
"MAP_almara",
"MAP_case_a",
"MAP_case_bedroom_a",
"MAP_case_bedroom_b",
"MAP_case_cans_b",
"MAP_case_d",
"MAP_case_wall_unit_part_c",
"MAP_case_wall_unit_part_d",
"MAP_case_wooden_b",
"MAP_Dhangar_borwnskrin",
"MAP_Dhangar_brownskrin",
"MAP_Dhangar_knihovna",
"MAP_library_a",
"MAP_shelf",
"MAP_Skrin_bar",
"MAP_Skrin_opalena",
"MAP_Truhla_stara",
"MAP_briefcase",
"MAP_Dkamna_bila",
"MAP_Dkamna_uhli",
"MAP_F_Dkamna_uhli",
"MAP_icebox",
"MAP_mutt_vysilacka",
"MAP_notebook",
"MAP_pc",
"MAP_phonebox",
"MAP_radio",
"MAP_radio_b",
"MAP_satelitePhone",
"MAP_smallTV",
"MAP_tv_a",
"MAP_vending_machine",
"MAP_lantern",
"MAP_bucket",
"MAP_MetalBucket",
"MAP_FuelCan",
"MAP_SmallObj_money",
"MAP_conference_table_a",
"MAP_desk",
"MAP_Dhangar_psacistul",
"MAP_F_conference_table_a",
"MAP_kitchen_table_a",
"MAP_lobby_table",
"MAP_office_table_a",
"MAP_pultskasou",
"MAP_SmallTable",
"MAP_stul_hospoda",
"MAP_stul_kuch1",
"MAP_Table",
"MAP_table_drawer",
"MAP_kasna_new",
"MAP_Misc_Boogieman",
"MAP_ChickenCoop",
"MAP_Misc_Greenhouse",
"MAP_Misc_Hutch",
"MAP_Misc_Well",
"MAP_Misc_WellPump",
"MAP_PowerGenerator",
"MAP_psi_bouda",
"MAP_pumpa",
"MAP_stanek_3",
"MAP_stanek_3_d",
"MAP_stanek_3B",
"MAP_AirCond_big",
"MAP_AirCond_small",
"MAP_antenna_big_roof",
"MAP_antenna_small_roof",
"MAP_antenna_small_roof_1",
"MAP_drapes",
"MAP_drapes_long",
"MAP_GasMeterExt",
"MAP_Ladder",
"MAP_P_Ladder",
"MAP_LadderHalf",
"MAP_P_LadderLong",
"MAP_leseni2x",
"MAP_leseni4x",
"MAP_Misc_loudspeakers",
"MAP_parabola_big",
"MAP_P_Stavebni_kozy",
"MAP_Heli_H_civil",
"MAP_Heli_H_army",
"MAP_Heli_H_cross",
"MAP_Heli_H_rescue",
"MAP_Sr_border",
"MAP_drevo_hromada",
"MAP_garbage_misc",
"MAP_garbage_paleta",
"MAP_Ind_BoardsPack1",
"MAP_Ind_BoardsPack2",
"MAP_Ind_Timbers",
"MAP_Kontejner",
"MAP_Misc_GContainer_Big",
"MAP_Misc_HayStack",
"MAP_Misc_TyreHeap",
"MAP_Misc_WoodPile",
"MAP_pneu",
"MAP_popelnice",
"MAP_sekyraspalek",
"MAP_seno_balik",
"MAP_concrete_block",
"MAP_Concrete_Ramp",
"MAP_ramp_concrete",
"MAP_woodenRamp",
"MAP_brana",
"MAP_Houpacka",
"MAP_nastenkaX",
"MAP_Piskoviste",
"MAP_snowman",
"MAP_Barel1",
"MAP_Barel3",
"MAP_Barel4",
"MAP_Barel5",
"MAP_Barel6",
"MAP_Barel7",
"MAP_Barel8",
"MAP_Barels",
"MAP_Barels2",
"MAP_Barels3",
"MAP_barrel_empty",
"MAP_barrel_sand",
"MAP_barrel_water",
"MAP_P_bedna",
"MAP_box_c",
"MAP_P_cihly1",
"MAP_P_cihly2",
"MAP_P_cihly3",
"MAP_P_cihly4",
"MAP_metalcrate",
"MAP_metalcrate_02",
"Misc_concrete",
"MAP_Misc_G_Pipes",
"MAP_Misc_palletsfoiled",
"MAP_Misc_palletsfoiled_heap",
"MAP_obstacle_get_over",
"MAP_obstacle_prone",
"MAP_obstacle_run_duck",
"MAP_paletaA",
"MAP_paletyC",
"MAP_paletyD",
"MAP_Pallets_Column",
"MAP_P_pipe_big",
"MAP_P_pipe_small",
"MAP_P_ytong",
"Land_Fire_DZ", 
"TentStorage", 
"Wire_cat1", 
"Sandbag1_DZ", "Hedgehog_DZ", "StashSmall", "StashMedium", "BearTrap_DZ", 
"DomeTentStorage", "CamoNet_DZ", "Trap_Cans", "TrapTripwireFlare", "TrapBearTrapSmoke", 
"TrapTripwireGrenade", "TrapTripwireSmoke", "TrapBearTrapFlare", "Grave", "Concrete_Wall_EP1", 
"Infostand_2_EP1", "WarfareBDepot", "Base_WarfareBBarrier10xTall", "WarfareBCamp", "Base_WarfareBBarrier10x", 
"Land_fortified_nest_big", "Land_Fort_Watchtower", "Land_fort_rampart_EP1", "Land_HBarrier_large", "Land_fortified_nest_small", 
"Land_BagFenceRound", "Land_fort_bagfence_long", "Land_Misc_Cargo2E", "Misc_Cargo1Bo_military", "Ins_WarfareBContructionSite", 
"Land_pumpa", "Land_CncBlock", "Hhedgehog_concrete", "Misc_cargo_cont_small_EP1", "Land_prebehlavka", "Fence_corrugated_plate", 
"ZavoraAnim", "Land_tent_east", "Land_CamoNetB_EAST", "Land_CamoNetB_NATO", "Land_CamoNetVar_EAST", "Land_CamoNetVar_NATO", 
"Land_CamoNet_EAST", "Land_CamoNet_NATO", "Fence_Ind_long", "Fort_RazorWire", "Fence_Ind","Land_sara_hasic_zbroj",
"Land_Shed_wooden","Land_Barrack2","Land_vez","FlagCarrierBAF","FlagCarrierBIS_EP1","FlagCarrierBLUFOR_EP1",
"FlagCarrierCDF_EP1","FlagCarrierCDFEnsign_EP1","FlagCarrierCzechRepublic_EP1","FlagCarrierGermany_EP1","FlagCarrierINDFOR_EP1",
"FlagCarrierUSA_EP1","Land_Ind_Shed_01_main","Land_Fire_barrel","Land_WoodenRamp","Land_Ind_TankSmall2_EP1","PowerGenerator_EP1",
"Land_Ind_IlluminantTower","Land_A_Castle_Stairs_A","Land_A_Castle_Bergfrit","Land_A_Castle_Bastion","Land_A_Castle_Wall1_20",
"Land_A_Castle_Wall1_20_Turn","Land_A_Castle_Wall2_30","Land_A_Castle_Gate","Land_House_L_1_EP1","Land_ConcreteRamp","RampConcrete",
"HeliH","HeliHCivil","Land_ladder","Land_ladder_half","Land_Misc_Scaffolding","CDF_WarfareBUAVterminal","Land_Ind_Shed_01_end","Land_Ind_SawMillPen"];
/******************************************************** END OF EDITABLE SETTINGS ********************************************************/

//Daimyo Custom Variables
	//Strings
	globalSkin 			= "";
	//Arrays
	allbuildables_class = [];
	allbuildables 		= [];
	allbuild_notowns 	= [];
	allremovables 		= [];
	wallarray 			= [];
	structures			= [];
	CODEINPUT 			= [];
	keyCode 			= [];
	globalAuthorizedUID = [];
	//Booleans
	remProc 			= false;
	procBuild 			= false;
	hasBuildItem 		= false;
	keyValid 			= false;
	removeObject		= false;
	addUIDCode			= false;
	removeUIDCode		= false;
	buildReposition		= false;
	//Other
	currentBuildRecipe 	= 0;
	bbCDReload			= 0; //This is used to reload custom debug monitors where needed

//EXTENDED BASE BUILDING
        baseBuildingExtended=true;
        rotateDir = 0;
        objectHeight=0;
        objectDistance=0;
        objectParallelDistance=0;
        rotateIncrement=30;
		rotateIncrementSmall=10;
        objectIncrement=0.3;
		objectIncrementSmall=0.1;
        objectTopHeight=8;
        objectLowHeight=-10;
        maxObjectDistance=6;
        minObjectDistance=-1;
		
//Base Building Keybinds
	DZ_BB_E  = false; //Elevate
	DZ_BB_L  = false; //Lower
	DZ_BB_Es = false; //Elevate Small
	DZ_BB_Ls = false; //Lower Small
	DZ_BB_Rl = false; //Rotate Left
	DZ_BB_Rr = false; //Rotate Right
	DZ_BB_Rls= false; //Rotate Left Small
	DZ_BB_Rrs= false; //Rotate Right Small
	DZ_BB_A  = false; //Push Away
	DZ_BB_N  = false; //Pull Near
	DZ_BB_Le = false; //Move Left
	DZ_BB_Ri = false; //Move Right
//####----####----####---- Base Building 1.3 End ----####----####----####


