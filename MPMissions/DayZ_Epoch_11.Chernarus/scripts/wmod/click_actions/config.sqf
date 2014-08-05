//  DZE_CLICK_ACTIONS
//      This is where you register your right-click actions
//  FORMAT -- (no comma after last array entry)
//      [_classname,_text,_execute,_condition],
//  PARAMETERS
//  _classname  : the name of the class to click on 
//                  (example = "ItemBloodbag")
//  _text       : the text for the option that is displayed when right clicking on the item 
//                  (example = "Self Transfuse")
//  _execute    : compiled code to execute when the option is selected 
//                  (example = "execVM 'my\scripts\self_transfuse.sqf';")
//  _condition  : compiled code evaluated to determine whether or not the option is displayed
//                  (example = {true})
//  EXAMPLE -- see below for some simple examples
DZE_CLICK_ACTIONS = [
	["ItemMachete","Clear Grass","[] execVM 'scripts\crafting\clearbrush.sqf';","true"],
	["ItemKnife","Make Arrows","[] execVM 'scripts\crafting\makearrow.sqf';","true"],
	["ItemKnife","Make Bandage","[] execVM 'scripts\crafting\makebandage.sqf';","true"],
	["ItemToolbox","Make Knife","[] execVM 'scripts\crafting\makeknife.sqf';","true"],
	["ItemToolbox","Make Bow","[] execVM 'scripts\crafting\makebow.sqf';","true"],
	["ItemToolbox","Make Hatchet","[] execVM 'scripts\crafting\makehatchet.sqf';","true"],
	["ItemZombieParts","Smear Zombie Guts on yourself","[] execVM 'scripts\walkamongstthedead\smear_guts.sqf';","true"],
	["ItemWaterbottle","Wash off zombie gutss","[] execVM 'scripts\walkamongstthedead\usebottle.sqf';","true"],
	["ItemBriefcase100oz","Call Carepackage (On Self)","[] execVM 'scripts\Carepackage\carepackage.sqf';","true"],
	["ItemBriefcase100oz","Call Carepackage (On Map)","[] execVM 'scripts\Carepackage2\clickpackage.sqf';","true"],
	["ItemKiloHemp","Smoke Weed","[] execVM 'scripts\HarvestHemp\smokeweed.sqf';","true"],
	["ItemKnife","Harvest Weed","[] execVM 'scripts\HarvestHemp\hemp.sqf.sqf';","true"],
	["ItemRadio","Group Management","[] execVM 'scripts\dzgm\loadGroupManagement.sqf';","true"],
	["ItemEmerald","Picture Frame","createDialog 'WGT_INTERIOR1';","true"],
	["ItemEmerald","Chair","createDialog 'WGT_INTERIOR2';","true"],
	["ItemEmerald","Bed","createDialog 'WGT_INTERIOR3';","true"],
	["ItemEmerald","Bathroom","createDialog 'WGT_INTERIOR4';","true"],
	["ItemEmerald","Shelf","createDialog 'WGT_INTERIOR5';","true"],
	["ItemEmerald","Misc","createDialog 'WGT_INTERIOR6';","true"],
	["ItemEmerald","Table","createDialog 'WGT_INTERIOR7';","true"],
	["ItemEmerald","Exterior","createDialog 'WGT_INTERIOR8';","true"],
	["glock17_EP1","Suicide","[] execVM 'scripts\suicide\suicide_init.sqf';","true"],
	["M9","Suicide","[] execVM 'scripts\suicide\suicide_init.sqf';","true"],
	["M9SD","Suicide","[] execVM 'scripts\suicide\suicide_init.sqf';","true"],
	["Makarov","Suicide","[] execVM 'scripts\suicide\suicide_init.sqf';","true"],
	["MakarovSD","Suicide","[] execVM 'scripts\suicide\suicide_init.sqf';","true"],
	["revolver_EP1","Suicide","[] execVM 'scripts\suicide\suicide_init.sqf';","true"],
	["UZI_EP1","Suicide","[] execVM 'scripts\suicide\suicide_init.sqf';","true"],
	["SA61_EP1","Suicide","[] execVM 'scripts\suicide\suicide_init.sqf';","true"],
	["Colt1911_EP1","Suicide","[] execVM 'scripts\suicide\suicide_init.sqf';","true"],
	["ItemToolbox","Deploy Bike","[] execVM 'scripts\spawnbike\deploy_init.sqf';","true"],
	["Binocular","Set Fog - 250","[] execVM 'scripts\BinocularFog\250.sqf';","true"],
	["Binocular","Set Fog - 500","[] execVM 'scripts\BinocularFog\500.sqf';","true"],
	["Binocular","Set Fog - 750","[] execVM 'scripts\BinocularFog\750.sqf';","true"],
	["Binocular","Set Fog - 1000","[] execVM 'scripts\BinocularFog\1000.sqf';","true"],
	["Binocular","Set Fog - 1250","[] execVM 'scripts\BinocularFog\1250.sqf';","true"],
	["Binocular","Set Fog - 1500","[] execVM 'scripts\BinocularFog\1500.sqf';","true"],
	["Binocular","Set Fog - 1750","[] execVM 'scripts\BinocularFog\1750.sqf';","true"],
	["Binocular","Set Fog - 2000","[] execVM 'scripts\BinocularFog\2000.sqf';","true"]
];                                               