//Tools
AdminTrackVehicles = true;
AdminTrackTempVehicles = true;
AdminTrackHumanity = true;
AdminTrackDeleteObjects =true;
AdminTrackRefuel = true;
AdminTrackRepair = true;
AdminTrackSafezone = true;
AdminTrackSpectate = true;
AdminTrackLockVehicles = true;
AdminTrackUnLockVehicles = true;
AdminTrackZombiesheild = true;
AdminTrackDeleteDatabase = true;
AdminTrackBaseDelete = true;
AdminTrackFlipVehicle = true;
AdminTrackGetCode = true;
AdminTrackGiveKey = true;
AdminTrackHeal = true;
//Teleports
AdminTrackTeleport = true;
AdminTrackTpToPlayer  = true;
AdminTrackTpToMe  = true;
//Admin mode
AdminTrackAdminMode = true;
//Skins
AdminTrackSkins = true;
//Gear and item changes
AdminTrackDeleteGear = true;
AdminTrackBackpack = true;
AdminTrackItems = true;
//weapons
AdminTrackWeaponkits = true;
//crates
AdminTrackWeaponCrate = true;
AdminTrackItemCrate = true;
AdminTrackBuildingCrate = true;
AdminTrackBackpackCrate = true;
AdminTrackAllCrate = true;

if ((getPlayerUID player) in AdminList || (getPlayerUID player) in ModList) then {

	if (isnil "tracker") then {tracker = true;};

	if (tracker) then
	{
		[]spawn
		{
			private["_veh", "_idx"];
			_idx = -1;
			while {alive player} do
			{
				if (_idx == -1) then
				{
					[]execVM "admintools\KeyBindings\FunctionKeys.sqf";
					[]execVM "admintools\KeyBindings\NumberKeys.sqf";
					_idx = (vehicle player) addaction [("<t color=""#585858"">" + ("Admin Menu") +"</t>"),"admintools\AdminToolsMain.sqf","",0,false,true,"",""];
					_veh = vehicle player;
				};
				if (_veh != vehicle player) then
				{
					_veh removeAction _idx;
					_idx = -1;      
				};
				Sleep 2;
			};
		};
		tracker = false;
	};
	waituntil {!alive player ; sleep 2;};
	tracker = true;
};