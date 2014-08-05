waituntil {!isnil "bis_fnc_init"};

BIS_MPF_remoteExecutionServer = {
	if ((_this select 1) select 2 == "JIPrequest") then {
		[nil,(_this select 1) select 0,"loc",rJIPEXEC,[any,any,"per","execVM","ca\Modules\Functions\init.sqf"]] call RE;
	};
};
//plot pole fix
DeadPlayerPlotObjects = [];

BIS_Effects_Burn =				{};
server_playerCharacters =		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerCharacters.sqf";
server_playerLogin =			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerLogin.sqf";
server_playerSetup =			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerSetup.sqf";
server_onPlayerDisconnect = 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_onPlayerDisconnect.sqf";
server_updateObject =			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_updateObject.sqf";
server_playerDied =				compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerDied.sqf";
server_publishObj = 			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_publishObject.sqf";
server_deleteObj =				compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_deleteObj.sqf";
server_swapObject =				compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_swapObject.sqf"; 
server_publishVeh = 			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_publishVehicle.sqf";
server_publishVeh2 = 			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_publishVehicle2.sqf";
server_publishVeh3 = 			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_publishVehicle3.sqf";
server_tradeObj = 				compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_tradeObject.sqf";
server_traders = 				compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_traders.sqf";
server_playerSync =				compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerSync.sqf";
server_spawnCrashSite  =    	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_spawnCrashSite.sqf";
//Animated AN2 crashes
server_spawnAN2CrashSite = 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_spawnAN2CrashSite.sqf";
//AN2 carpackages
server_spawnAN2 = compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_spawnAN2.sqf"; 
server_carepackagedrop = compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_carepackagedrop.sqf";
//Air Raid
server_airRaid =            compile preprocessFileLineNumbers "z\addons\dayz_server\compile\server_airRaid.sqf";
//Infected Camps
spawnComposition = compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\object_mapper.sqf"; // Include BIS compositions
fn_bases = compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\fn_bases.sqf"; // Infected Camps

server_spawnEvents =			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_spawnEvent.sqf";
//server_weather =				compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_weather.sqf";
fnc_plyrHit   =					compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\fnc_plyrHit.sqf";
server_deaths = 				compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerDeaths.sqf";
server_maintainArea = 			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_maintainArea.sqf";
//plot pole fix
server_changePlotsOwner =		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_changePlotsOwner.sqf"; 

/* PVS/PVC - Skaronator */
server_sendToClient =			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_sendToClient.sqf";

//onPlayerConnected 			{[_uid,_name] call server_onPlayerConnect;};
onPlayerDisconnected 		{[_uid,_name] call server_onPlayerDisconnect;};

server_updateNearbyObjects = {
	private["_pos","_object","_isBuildable"];
	_pos = _this select 0;
	_object = _this select 1;
	_isBuildable = _this select 2;

	{
		[_x, "gear"] call server_updateObject;
	} count nearestObjects [_pos, dayz_updateObjects, 10];
	
	//####----####----####---- Base Building 1.3 Start ----####----####----####
	if (_isBuildable) then {
		[_object, "gear"] call server_updateObject;
		_isBuildable = false;
	};
	//####----####----####---- Base Building 1.3 End ----####----####----####
	
};

server_handleZedSpawn = {
	private["_zed"];
	_zed = _this select 0;
	_zed enableSimulation false;
};

zombie_findOwner = {
	private["_unit"];
	_unit = _this select 0;
	#ifdef DZE_SERVER_DEBUG
	diag_log ("CLEANUP: DELETE UNCONTROLLED ZOMBIE: " + (typeOf _unit) + " OF: " + str(_unit) );
	#endif
	deleteVehicle _unit;
};

vehicle_handleInteract = {
	private["_object"];
	_object = _this select 0;
	needUpdate_objects = needUpdate_objects - [_object];
	[_object, "all"] call server_updateObject;
};

array_reduceSizeReverse = {
	private["_array","_count","_num","_newarray","_startnum","_index"];
	_array = _this select 0;
	_newarray = [];
	_count = _this select 1;
	_num = count _array;
	if (_num > _count) then {
		_startnum = _num - 1;
		_index = _count - 1;
		for "_i" from 0 to _index do {
			_newarray set [(_index-_i),_array select (_startnum - _i)];
		};
		_array = _newarray;
	}; 
	_array
};

array_reduceSize = {
	private ["_array1","_array","_count","_num"];
	_array1 = _this select 0;
	_array = _array1 - ["Hatchet_Swing","Machete_Swing","Fishing_Swing","sledge_swing","crowbar_swing","CSGAS"];
	_count = _this select 1;
	_num = count _array;
	if (_num > _count) then {
		_array resize _count;
	};
	_array
};

object_handleServerKilled = {
	private["_unit","_objectID","_objectUID","_killer"];
	_unit = _this select 0;
	_killer = _this select 1;
	
	_objectID =	 _unit getVariable ["ObjectID","0"];
	_objectUID = _unit getVariable ["ObjectUID","0"];
		
	[_objectID,_objectUID,_killer] call server_deleteObj;
	
	_unit removeAllMPEventHandlers "MPKilled";
	_unit removeAllEventHandlers "Killed";
	_unit removeAllEventHandlers "HandleDamage";
	_unit removeAllEventHandlers "GetIn";
	_unit removeAllEventHandlers "GetOut";
};

check_publishobject = {
	private["_allowed","_object","_playername"];

	_object = _this select 0;
	_playername = _this select 1;
	_allowed = false;

	if ((typeOf _object) in dayz_allowedObjects || (typeOf _object) in allbuildables_class) then {
			//diag_log format ["DEBUG: Object: %1 published by %2 is Safe",_object, _playername];
			_allowed = true;
	};
    _allowed
};

//event Handlers
eh_localCleanup = {
	private ["_object"];
	_object = _this select 0;
	_object addEventHandler ["local", {
		if(_this select 1) then {
			private["_type","_unit"];
			_unit = _this select 0;
			_type = typeOf _unit;
			 _myGroupUnit = group _unit;
 			_unit removeAllMPEventHandlers "mpkilled";
 			_unit removeAllMPEventHandlers "mphit";
 			_unit removeAllMPEventHandlers "mprespawn";
 			_unit removeAllEventHandlers "FiredNear";
			_unit removeAllEventHandlers "HandleDamage";
			_unit removeAllEventHandlers "Killed";
			_unit removeAllEventHandlers "Fired";
			_unit removeAllEventHandlers "GetOut";
			_unit removeAllEventHandlers "GetIn";
			_unit removeAllEventHandlers "Local";
			clearVehicleInit _unit;
			deleteVehicle _unit;
			if ((count (units _myGroupUnit) == 0) && (_myGroupUnit != grpNull)) then {
				deleteGroup _myGroupUnit;
			};
			//_unit = nil;
			// diag_log ("CLEANUP: DELETED A " + str(_type) );
		};
	}];
};

server_hiveWrite = {
	private["_data"];
	_data = "HiveExt" callExtension _this;
};

server_hiveReadWrite = {
	private["_key","_resultArray","_data"];
	_key = _this;
	_data = "HiveExt" callExtension _key;
	_resultArray = call compile format ["%1",_data];
	_resultArray
};

server_hiveReadWriteLarge = {
	private["_key","_resultArray","_data"];
	_key = _this;
	_data = "HiveExt" callExtension _key;
	_resultArray = call compile _data;
	_resultArray
};

server_checkIfTowed = {
	private ["_vehicle","_player","_attached"];
	if (DZE_HeliLift) then {
		_vehicle = 	_this select 0;
		_player = 	_this select 2;
		_attached = _vehicle getVariable["attached",false];
		if (typeName _attached == "OBJECT") then {
			_player action ["eject", _vehicle];
			detach _vehicle;
			_vehicle setVariable["attached",false,true];
			_attached setVariable["hasAttached",false,true];
		};
	};
};

server_characterSync = {
	private ["_characterID","_playerPos","_playerGear","_playerBackp","_medical","_currentState","_currentModel","_key"];
	_characterID = 	_this select 0;	
	_playerPos =	_this select 1;
	_playerGear =	_this select 2;
	_playerBackp =	_this select 3;
	_medical = 		_this select 4;
	_currentState =	_this select 5;
	_currentModel = _this select 6;
	
	_key = format["CHILD:201:%1:%2:%3:%4:%5:%6:%7:%8:%9:%10:%11:%12:%13:%14:%15:%16:",_characterID,_playerPos,_playerGear,_playerBackp,_medical,false,false,0,0,0,0,_currentState,0,0,_currentModel,0];
	_key call server_hiveWrite;
};

if(isnil "dayz_MapArea") then {
	dayz_MapArea = 10000;
};
if(isnil "DynamicVehicleArea") then {
	DynamicVehicleArea = dayz_MapArea / 2;
};

// Get all buildings && roads only once TODO: set variables to nil after done if nessicary 
MarkerPosition = getMarkerPos "center";
RoadList = MarkerPosition nearRoads DynamicVehicleArea;

// Very taxing !!! but only on first startup
BuildingList = [];
{
	if (DZE_MissionLootTable) then {
		if (isClass (missionConfigFile >> "CfgBuildingLoot" >> (typeOf _x))) then
		{
				BuildingList set [count BuildingList,_x];
		};
	} else {
		if (isClass (configFile >> "CfgBuildingLoot" >> (typeOf _x))) then
		{
			BuildingList set [count BuildingList,_x];
		};
	};
	
	
} count (MarkerPosition nearObjects ["building",DynamicVehicleArea]);

spawn_vehicles = {
	private ["_random","_lastIndex","_weights","_index","_vehicle","_velimit","_qty","_isAir","_isShip","_position","_dir","_istoomany","_veh","_objPosition","_marker","_iClass","_itemTypes","_cntWeights","_itemType","_num","_allCfgLoots"];
	
	if (!isDedicated) exitWith { }; //Be sure the run this

	while {count AllowedVehiclesList > 0} do {
		// BIS_fnc_selectRandom replaced because the index may be needed to remove the element
		_index = floor random count AllowedVehiclesList;
		_random = AllowedVehiclesList select _index;

		_vehicle = _random select 0;
		_velimit = _random select 1;

		_qty = {_x == _vehicle} count serverVehicleCounter;

		// If under limit allow to proceed
		if (_qty <= _velimit) exitWith {};

		// vehicle limit reached, remove vehicle from list
		// since elements cannot be removed from an array, overwrite it with the last element && cut the last element of (as long as order is not important)
		_lastIndex = (count AllowedVehiclesList) - 1;
		if (_lastIndex != _index) then {
			AllowedVehiclesList set [_index, AllowedVehiclesList select _lastIndex];
		};
		AllowedVehiclesList resize _lastIndex;
	};

	if (count AllowedVehiclesList == 0) then {
		diag_log("DEBUG: unable to find suitable vehicle to spawn");
	} else {

		// add vehicle to counter for next pass
		serverVehicleCounter set [count serverVehicleCounter,_vehicle];
	
		// Find Vehicle Type to better control spawns
		_isAir = _vehicle isKindOf "Air";
		_isShip = _vehicle isKindOf "Ship";
	
		if(_isShip || _isAir) then {
			if(_isShip) then {
				// Spawn anywhere on coast on water
				waitUntil{!isNil "BIS_fnc_findSafePos"};
				_position = [MarkerPosition,0,DynamicVehicleArea,10,1,2000,1] call BIS_fnc_findSafePos;
				//diag_log("DEBUG: spawning boat near coast " + str(_position));
			} else {
				// Spawn air anywhere that is flat
				waitUntil{!isNil "BIS_fnc_findSafePos"};
				_position = [MarkerPosition,0,DynamicVehicleArea,10,0,2000,0] call BIS_fnc_findSafePos;
				//diag_log("DEBUG: spawning air anywhere flat " + str(_position));
			};
		
		
		} else {
			// Spawn around buildings && 50% near roads
			if((random 1) > 0.5) then {
			
				waitUntil{!isNil "BIS_fnc_selectRandom"};
				_position = RoadList call BIS_fnc_selectRandom;
			
				_position = _position modelToWorld [0,0,0];
			
				waitUntil{!isNil "BIS_fnc_findSafePos"};
				_position = [_position,0,10,10,0,2000,0] call BIS_fnc_findSafePos;
			
				//diag_log("DEBUG: spawning near road " + str(_position));
			
			} else {
			
				waitUntil{!isNil "BIS_fnc_selectRandom"};
				_position = BuildingList call BIS_fnc_selectRandom;
			
				_position = _position modelToWorld [0,0,0];
			
				waitUntil{!isNil "BIS_fnc_findSafePos"};
				_position = [_position,0,40,5,0,2000,0] call BIS_fnc_findSafePos;
			
				//diag_log("DEBUG: spawning around buildings " + str(_position));
		
			};
		};
		// only proceed if two params otherwise BIS_fnc_findSafePos failed && may spawn in air
		if ((count _position) == 2) then { 
	
			_dir = round(random 180);
		
			_istoomany = _position nearObjects ["AllVehicles",50];
			if((count _istoomany) > 0) exitWith { diag_log("DEBUG: Too many vehicles at " + str(_position)); };
		
			//place vehicle 
			_veh = createVehicle [_vehicle, _position, [], 0, "CAN_COLLIDE"];
			_veh setdir _dir;
			_veh setpos _position;		
			
			if(DZEdebug) then {
				_marker = createMarker [str(_position) , _position];
				_marker setMarkerShape "ICON";
				_marker setMarkerType "DOT";
				_marker setMarkerText _vehicle;
			};	
		
			// Get position with ground
			_objPosition = getPosATL _veh;
		
			clearWeaponCargoGlobal  _veh;
			clearMagazineCargoGlobal  _veh;
			// _veh setVehicleAmmo DZE_vehicleAmmo;

			// Add 0-3 loots to vehicle using random cfgloots 
			_num = floor(random 4);
			_allCfgLoots = ["trash","civilian","food","generic","medical","military","policeman","hunter","worker","clothes","militaryclothes","specialclothes","trash"];
			
			for "_x" from 1 to _num do {
				_iClass = _allCfgLoots call BIS_fnc_selectRandom;

				_itemTypes = [];
				if (DZE_MissionLootTable) then{
					{
						_itemTypes set[count _itemTypes, _x select 0]
					} count getArray(missionConfigFile >> "cfgLoot" >> _iClass);
				}
				else {
					{
						_itemTypes set[count _itemTypes, _x select 0]
					} count getArray(configFile >> "cfgLoot" >> _iClass);
				};

				_index = dayz_CLBase find _iClass;
				_weights = dayz_CLChances select _index;
				_cntWeights = count _weights;
				
				_index = floor(random _cntWeights);
				_index = _weights select _index;
				_itemType = _itemTypes select _index;
				_veh addMagazineCargoGlobal [_itemType,1];
				//diag_log("DEBUG: spawed loot inside vehicle " + str(_itemType));
			};

			[_veh,[_dir,_objPosition],_vehicle,true,"0"] call server_publishVeh;
		};
	};
};

spawn_ammosupply = {
	private ["_position","_veh","_istoomany","_marker","_spawnveh","_WreckList"];
	if (isDedicated) then {
		_WreckList = ["Supply_Crate_DZE"];
		waitUntil{!isNil "BIS_fnc_selectRandom"};
		_position = RoadList call BIS_fnc_selectRandom;
		_position = _position modelToWorld [0,0,0];
		waitUntil{!isNil "BIS_fnc_findSafePos"};
		_position = [_position,5,20,5,0,2000,0] call BIS_fnc_findSafePos;
		if ((count _position) == 2) then {

			_istoomany = _position nearObjects ["All",5];
			
			if((count _istoomany) > 0) exitWith { diag_log("DEBUG VEIN: Too many at " + str(_position)); };
			
			_spawnveh = _WreckList call BIS_fnc_selectRandom;

			if(DZEdebug) then {
				_marker = createMarker [str(_position) , _position];
				_marker setMarkerShape "ICON";
				_marker setMarkerType "DOT";
				_marker setMarkerText str(_spawnveh);
			};
			
			_veh = createVehicle [_spawnveh,_position, [], 0, "CAN_COLLIDE"];
			_veh enableSimulation false;
			_veh setDir round(random 360);
			_veh setpos _position;
			_veh setVariable ["ObjectID","1",true];
		};
	};
};

DZE_LocalRoadBlocks = [];

spawn_roadblocks = {
	private ["_position","_veh","_istoomany","_marker","_spawnveh","_WreckList"];
	_WreckList = ["SKODAWreck","HMMWVWreck","UralWreck","datsun01Wreck","hiluxWreck","datsun02Wreck","UAZWreck","Land_Misc_Garb_Heap_EP1","Fort_Barricade_EP1","Rubbish2"];
	
	waitUntil{!isNil "BIS_fnc_selectRandom"};
	if (isDedicated) then {
	
		_position = RoadList call BIS_fnc_selectRandom;
		
		_position = _position modelToWorld [0,0,0];
		
		waitUntil{!isNil "BIS_fnc_findSafePos"};
		_position = [_position,0,10,5,0,2000,0] call BIS_fnc_findSafePos;
		
		if ((count _position) == 2) then {
			// Get position with ground
			
			_istoomany = _position nearObjects ["All",5];
		
			if((count _istoomany) > 0) exitWith { diag_log("DEBUG: Too many at " + str(_position)); };
			
			waitUntil{!isNil "BIS_fnc_selectRandom"};
			_spawnveh = _WreckList call BIS_fnc_selectRandom;

			if(DZEdebug) then {
				_marker = createMarker [str(_position) , _position];
				_marker setMarkerShape "ICON";
				_marker setMarkerType "DOT";
				_marker setMarkerText str(_spawnveh);
			};

			_veh = createVehicle [_spawnveh,_position, [], 0, "CAN_COLLIDE"];
			_veh enableSimulation false;

			_veh setDir round(random 360); // Randomize placement a bit
			_veh setpos _position;

			_veh setVariable ["ObjectID","1",true];
		};
	
	};
	
};

spawn_mineveins = {
	private ["_position","_veh","_istoomany","_marker","_spawnveh","_positions"];

	if (isDedicated) then {
		
		_position = [getMarkerPos "center",0,(HeliCrashArea*0.75),10,0,2000,0] call BIS_fnc_findSafePos;

		if ((count _position) == 2) then {
			
			_positions = selectBestPlaces [_position, 500, "(1 + forest) * (1 + hills) * (1 - houses) * (1 - sea)", 10, 5];

			_position = (_positions call BIS_fnc_selectRandom) select 0;

			// Get position with ground
			_istoomany = _position nearObjects ["All",10];
		
			if((count _istoomany) > 0) exitWith { diag_log("DEBUG VEIN: Too many objects at " + str(_position)); };

			if(isOnRoad _position) exitWith { diag_log("DEBUG VEIN: on road " + str(_position)); };
			
			_spawnveh = ["Iron_Vein_DZE","Iron_Vein_DZE","Iron_Vein_DZE","Iron_Vein_DZE","Iron_Vein_DZE","Silver_Vein_DZE","Silver_Vein_DZE","Silver_Vein_DZE","Gold_Vein_DZE","Gold_Vein_DZE"] call BIS_fnc_selectRandom;

			if(DZEDebug) then {
				_marker = createMarker [str(_position) , _position];
				_marker setMarkerShape "ICON";
				_marker setMarkerType "DOT";
				_marker setMarkerText str(_spawnveh);
			};
			
			//diag_log("DEBUG: Spawning a crashed " + _spawnveh + " with " + _spawnloot + " at " + str(_position));
			_veh = createVehicle [_spawnveh,_position, [], 0, "CAN_COLLIDE"];
			_veh enableSimulation false;

			// Randomize placement a bit
			_veh setDir round(random 360);
			_veh setpos _position;

			_veh setVariable ["ObjectID","1",true];

		
		};
	};
};

if(isnil "DynamicVehicleDamageLow") then {
	DynamicVehicleDamageLow = 0;
};
if(isnil "DynamicVehicleDamageHigh") then {
	DynamicVehicleDamageHigh = 100;
};

if(isnil "DynamicVehicleFuelLow") then {
	DynamicVehicleFuelLow = 0;
};
if(isnil "DynamicVehicleFuelHigh") then {
	DynamicVehicleFuelHigh = 100;
};

if(isnil "DZE_DiagFpsSlow") then {
	DZE_DiagFpsSlow = false;
};
if(isnil "DZE_DiagFpsFast") then {
	DZE_DiagFpsFast = false;
};
if(isnil "DZE_DiagVerbose") then {
	DZE_DiagVerbose = false;
};

dze_diag_fps = {
	if(DZE_DiagVerbose) then {
		diag_log format["DEBUG FPS : %1 OBJECTS: %2 : PLAYERS: %3", diag_fps,(count (allMissionObjects "")),(playersNumber west)];
	} else {
		diag_log format["DEBUG FPS : %1", diag_fps];
	};
};

// Damage generator function
generate_new_damage = {
	private ["_damage"];
    _damage = ((random(DynamicVehicleDamageHigh-DynamicVehicleDamageLow))+DynamicVehicleDamageLow) / 100;
	_damage;
};

// Damage generator fuction
generate_exp_damage = {
	private ["_damage"];
    _damage = ((random(DynamicVehicleDamageHigh-DynamicVehicleDamageLow))+DynamicVehicleDamageLow) / 100;
	
	// limit this to 85% since vehicle would blow up otherwise.
	//if(_damage >= 0.85) then {
	//	_damage = 0.85;
	//};
	_damage;
};

server_getDiff =	{
	private["_variable","_object","_vNew","_vOld","_result"];
	_variable = _this select 0;
	_object = 	_this select 1;
	_vNew = 	_object getVariable[_variable,0];
	_vOld = 	_object getVariable[(_variable + "_CHK"),_vNew];
	_result = 	0;
	if (_vNew < _vOld) then {
		//JIP issues
		_vNew = _vNew + _vOld;
		_object getVariable[(_variable + "_CHK"),_vNew];
	} else {
		_result = _vNew - _vOld;
		_object setVariable[(_variable + "_CHK"),_vNew];
	};
	_result
};

server_getDiff2 =	{
	private["_variable","_object","_vNew","_vOld","_result"];
	_variable = _this select 0;
	_object = 	_this select 1;
	_vNew = 	_object getVariable[_variable,0];
	_vOld = 	_object getVariable[(_variable + "_CHK"),_vNew];
	_result = _vNew - _vOld;
	_object setVariable[(_variable + "_CHK"),_vNew];
	_result
};

dayz_objectUID = {
	private["_position","_dir","_key","_object"];
	_object = _this;
	_position = getPosATL _object;
	_dir = direction _object;
	_key = [_dir,_position] call dayz_objectUID2;
    _key
};

dayz_objectUID2 = {
	private["_position","_dir","_key"];
	_dir = _this select 0;
	_key = "";
	_position = _this select 1;
	{
		_x = _x * 10;
		if ( _x < 0 ) then { _x = _x * -10 };
		_key = _key + str(round(_x));
	} count _position;
	_key = _key + str(round(_dir));
	_key
};

dayz_objectUID3 = {
	private["_position","_dir","_key"];
	_dir = _this select 0;
	_key = "";
	_position = _this select 1;
	{
		_x = _x * 10;
		if ( _x < 0 ) then { _x = _x * -10 };
		_key = _key + str(round(_x));
	} count _position;
	_key = _key + str(round(_dir + time));
	_key
};

dayz_recordLogin = {
	private["_key"];
	_key = format["CHILD:103:%1:%2:%3:",_this select 0,_this select 1,_this select 2];
	_key call server_hiveWrite;
};

//DZGM
currentInvites = [];
publicVariable "currentInvites";

dayz_perform_purge = {
	if(!isNull(_this)) then {
		_group = group _this;
		_this removeAllMPEventHandlers "mpkilled";
		_this removeAllMPEventHandlers "mphit";
		_this removeAllMPEventHandlers "mprespawn";
		_this removeAllEventHandlers "FiredNear";
		_this removeAllEventHandlers "HandleDamage";
		_this removeAllEventHandlers "Killed";
		_this removeAllEventHandlers "Fired";
		_this removeAllEventHandlers "GetOut";
		_this removeAllEventHandlers "GetIn";
		_this removeAllEventHandlers "Local";
		clearVehicleInit _this;
		deleteVehicle _this;
		if ((count (units _group) == 0) && (_group != grpNull)) then {
			deleteGroup _group;
		};
	};
};

dayz_perform_purge_player = {

	private ["_countr","_backpack","_backpackType","_backpackWpn","_backpackMag","_objWpnTypes","_objWpnQty","_location","_dir","_holder","_weapons","_magazines"];
    diag_log ("Purging player: " + str(_this));	

	if(!isNull(_this)) then {

		_location = getPosATL _this;
		_dir = getDir _this;

		_holder = createVehicle ["GraveDZE", _location, [], 0, "CAN_COLLIDE"];
		_holder setDir _dir;
		_holder setPosATL _location;

		_holder enableSimulation false;

		_weapons = weapons _this;
		_magazines = magazines _this;

		// find backpack
		if(!(isNull unitBackpack _this)) then {
			_backpack = unitBackpack _this;
			_backpackType = typeOf _backpack;
			_backpackWpn = getWeaponCargo _backpack;
			_backpackMag = getMagazineCargo _backpack;

			_holder addBackpackCargoGlobal [_backpackType,1];

			// add items from backpack 
			_objWpnTypes = _backpackWpn select 0;
			_objWpnQty = _backpackWpn select 1;
			_countr = 0;
			{
				_holder addWeaponCargoGlobal [_x,(_objWpnQty select _countr)];
				_countr = _countr + 1;
			} count _objWpnTypes;

			// add backpack magazine items
			_objWpnTypes = _backpackMag select 0;
			_objWpnQty = _backpackMag select 1;
			_countr = 0;
			{
				_holder addMagazineCargoGlobal [_x,(_objWpnQty select _countr)];
				_countr = _countr + 1;
			} count _objWpnTypes;
		};
	};

	// add weapons
	{ 
		_holder addWeaponCargoGlobal [_x, 1];
	} count _weapons;

	// add mags
	{ 
		_holder addMagazineCargoGlobal [_x, 1];
	} count _magazines;
	_group = group _this;
	_this removeAllMPEventHandlers "mpkilled";
	_this removeAllMPEventHandlers "mphit";
	_this removeAllMPEventHandlers "mprespawn";
	_this removeAllEventHandlers "FiredNear";
	_this removeAllEventHandlers "HandleDamage";
	_this removeAllEventHandlers "Killed";
	_this removeAllEventHandlers "Fired";
	_this removeAllEventHandlers "GetOut";
	_this removeAllEventHandlers "GetIn";
	_this removeAllEventHandlers "Local";
	clearVehicleInit _this;
	deleteVehicle _this;
	if ((count (units _group) == 0) && (_group != grpNull)) then {
		deleteGroup _group;
	};
	//  _this = nil;
};


dayz_removePlayerOnDisconnect = {
	if(!isNull(_this)) then {
		_group = group _this;
		_this removeAllMPEventHandlers "mphit";
		deleteVehicle _this;
		deleteGroup (group _this);
	};
};

server_timeSync = {
	//Send request
	private ["_hour","_minute","_date","_key","_result","_outcome"];
    _key = "CHILD:307:";
	_result = _key call server_hiveReadWrite;
	_outcome = _result select 0;
	if(_outcome == "PASS") then {
		_date = _result select 1; 
		
		if(dayz_fullMoonNights) then {
			_hour = _date select 3;
			_minute = _date select 4;
			//Force full moon nights
			_date = [2013,8,3,_hour,_minute];
		};

		setDate _date;
		PVDZE_plr_SetDate = _date;
		publicVariable "PVDZE_plr_SetDate";
		diag_log ("TIME SYNC: Local Time set to " + str(_date));	
	};
};

// must spawn these 
server_spawncleanDead = {
	private ["_deathTime","_delQtyZ","_delQtyP","_qty","_allDead"];
	_allDead = allDead;
	_delQtyZ = 0;
	_delQtyP = 0;
	{
		if (local _x) then {
			if (_x isKindOf "zZombie_Base") then
			{
				_x call dayz_perform_purge;
				sleep 0.05;
				_delQtyZ = _delQtyZ + 1;
			} else {
				if (_x isKindOf "CAManBase") then {
					_deathTime = _x getVariable ["processedDeath", diag_tickTime];
					if (diag_tickTime - _deathTime > 1800) then {
						_x call dayz_perform_purge_player;
						sleep 0.025;
						_delQtyP = _delQtyP + 1;
					};
				};
			};
		};
		sleep 0.025;
	} count _allDead;
	if (_delQtyZ > 0 || _delQtyP > 0) then {
		_qty = count _allDead;
		diag_log (format["CLEANUP: Deleted %1 players && %2 zombies out of %3 dead",_delQtyP,_delQtyZ,_qty]);
	};
};
server_cleanupGroups = {
	if (DZE_DYN_AntiStuck3rd > 3) then { DZE_DYN_GroupCleanup = nil; DZE_DYN_AntiStuck3rd = 0; };
	if(!isNil "DZE_DYN_GroupCleanup") exitWith {  DZE_DYN_AntiStuck3rd = DZE_DYN_AntiStuck3rd + 1;};
	DZE_DYN_GroupCleanup = true;
	{
		if ((count (units _x) == 0) && (_x != grpNull)) then {
			deleteGroup _x;
		};
		sleep 0.001;
	} count allGroups;
	DZE_DYN_GroupCleanup = nil;
};

server_checkHackers = {
	if (DZE_DYN_AntiStuck2nd > 3) then { DZE_DYN_HackerCheck = nil; DZE_DYN_AntiStuck2nd = 0; };
	if(!isNil "DZE_DYN_HackerCheck") exitWith {  DZE_DYN_AntiStuck2nd = DZE_DYN_AntiStuck2nd + 1;};
	DZE_DYN_HackerCheck = true;
	{
	if (!((isNil "_x") || {(isNull _x)})) then {
		if(vehicle _x != _x && !(vehicle _x in PVDZE_serverObjectMonitor) && (isPlayer _x)  && !((typeOf vehicle _x) in DZE_safeVehicle) && (vehicle _x getVariable ["MalSar",0] !=1) && (vehicle _x getVariable ["Sarge",0] !=1) && (vehicle _x getVariable ["Mission",0] !=1)) then {
			diag_log ("CLEANUP: KILLING A HACKER " + (name _x) + " " + str(_x) + " IN " + (typeOf vehicle _x));
			(vehicle _x) setDamage 1;
			_x setDamage 1;
			sleep 0.25;
		};
	};
		sleep 0.001;
	} count allUnits;
	DZE_DYN_HackerCheck = nil;
};
server_spawnCleanFire = {
	private ["_delQtyFP","_qty","_delQtyNull","_missionFires"];
	_missionFires = allMissionObjects "Land_Fire_DZ";
	_delQtyFP = 0;
	{
		if (local _x) then {
			deleteVehicle _x;
			sleep 0.025;
			_delQtyFP = _delQtyFP + 1;
		};
		sleep 0.001;
	} count _missionFires;
	if (_delQtyFP > 0) then {
		_qty = count _missionFires;
		diag_log (format["CLEANUP: Deleted %1 fireplaces out of %2",_delQtyFP,_qty]);
	};
};
server_spawnCleanLoot = {
	private ["_created","_delQty","_nearby","_age","_keep","_qty","_missionObjs","_dateNow"];
	if (DZE_DYN_AntiStuck > 3) then { DZE_DYN_cleanLoot = nil; DZE_DYN_AntiStuck = 0; };
	if(!isNil "DZE_DYN_cleanLoot") exitWith {  DZE_DYN_AntiStuck = DZE_DYN_AntiStuck + 1;};
	DZE_DYN_cleanLoot = true;

	_missionObjs =  allMissionObjects "ReammoBox";
	_delQty = 0;
	_dateNow = (DateToNumber date);
	{
		if (!isNull _x) then {
			_keep = _x getVariable["permaLoot", false];
			if (!_keep) then {
				_created = _x getVariable["created", -0.1];
				if (_created == -0.1) then{
					_x setVariable["created", _dateNow, false];
					_created = _dateNow;
				}
				else {
					_age = (_dateNow - _created) * 525948;
					if (_age > 20) then{
						_nearby = { (isPlayer _x) && (alive _x) } count(_x nearEntities[["CAManBase", "AllVehicles"], 130]);
						if (_nearby == 0) then{
							deleteVehicle _x;
							sleep 0.025;
							_delQty = _delQty + 1;
						};
					};
				};
			};
		};
		sleep 0.001;
	} count _missionObjs;
	if (_delQty > 0) then {
		_qty = count _missionObjs;
		diag_log (format["CLEANUP: Deleted %1 Loot Piles out of %2",_delQty,_qty]);
	};
	DZE_DYN_cleanLoot = nil;
};

server_spawnCleanAnimals = {
	private ["_pos","_delQtyAnimal","_qty","_missonAnimals","_nearby"];
	_missonAnimals = entities "CAAnimalBase";
	_delQtyAnimal = 0;
	{
		if (local _x) then {
			_x call dayz_perform_purge;
			sleep 0.05;
			_delQtyAnimal = _delQtyAnimal + 1;
		} else {
			if (!alive _x) then {
				_pos = getPosATL _x;
				if (count _pos > 0) then {
					_nearby = {(isPlayer _x) && (alive _x)} count (_pos nearEntities [["CAManBase","AllVehicles"], 130]);
					if (_nearby==0) then {
						_x call dayz_perform_purge;
						sleep 0.05;
						_delQtyAnimal = _delQtyAnimal + 1;
					};
				};
			};
		};
		sleep 0.001;
	} count _missonAnimals;
	if (_delQtyAnimal > 0) then {
		_qty = count _missonAnimals;
		diag_log (format["CLEANUP: Deleted %1 Animals out of %2",_delQtyAnimal,_qty]);
	};
};

server_logUnlockLockEvent = {
	private["_player", "_obj", "_objectID", "_objectUID", "_statusText", "_status"];
	_player = _this select 0;
	_obj = _this select 1;
	_status = _this select 2;
	if (!isNull(_obj)) then {
		_objectID = _obj getVariable["ObjectID", "0"];
		_objectUID = _obj getVariable["ObjectUID", "0"];
		_statusText = "UNLOCKED";
		if (_status) then {
			[_obj, "gear"] call server_updateObject;
			_statusText = "LOCKED";
		};
		diag_log format["SAFE %5: ID:%1 UID:%2 BY %3(%4)", _objectID, _objectUID, (name _player), (getPlayerUID _player), _statusText];
	};
};

//####----####----####---- Base Building 1.3 Start ----####----####----####
build_baseBuilding_arrays = {

//####----####----####---- BUILD LIST ARRAY SERVER SIDE Start ----####----####----####
/*
Build list by Daimyo for SERVER side
Add and remove recipes, Objects(classnames), requirments to build, and town restrictions + extras
This method is used because we are referencing magazines from player inventory as buildables.
Main array (_buildlist) consist of 34 arrays within. These arrays contains parameters for player_build.sqf
From left to right, each array contains 3 elements, 1st: Recipe Array, 2nd: "Classname", 3rd: Requirements array. 
Check comments below for more info on parameters
*/
private["_isDestructable","_classname","_isSimulated","_disableSims","_objectSims","_objectSim","_requirements","_isStructure","_structure","_wallType","_removable","_buildlist","_build_townsrestrict"];
// Count is 34
// Info on Parameters (Copy and Paste to add more recipes and their requirments!):
//[TankTrap, SandBags, Wires, Logs, Scrap Metal, Grenades, scrapelectronics, crate, camonets, bricks, string, duct tape], "Classname", [_attachCoords, _startPos, _modDir, _toolBox, _eTool, _medWait, _longWait, _inBuilding, _roadAllowed, _inTown, _removable, _isStructure, _isSimulated, _isDestructable, _requireFlag];
									//[_attachCoords, _startPos, _modDir, _toolBox, _eTool, _medWait, _longWait, _inBuilding, _roadAllowed, _inTown, _removable, _isStructure, _isSimulated, _isDestructable, _requireFlag];
_buildlist = [
//t, s, w, L, m, g
[[3, 0, 1, 0, 2, 0], BBTypeOfFlag,  			[[0,6,1], 	[0,8,0], 	0, 	true, true, true, true, false, false, false, false, true, false, false, false]], //FlagCarrierUSA 	--1 
[[0, 1, 0, 0, 1, 1], "Grave", 						[[0,2.5,.1],[0,2,0], 	0, 	true, true, true, false, true, true, true, false, false, false, false, false]],//Booby Traps --2
[[2, 0, 0, 3, 1, 0], "Concrete_Wall_EP1", 			[[0,5,1.75],[0,2,0], 	0, 	true, false, true, false, true, true, false, false, false, false, false, true]],//Gate Concrete Wall --3
[[1, 0, 1, 0, 1, 0], "Infostand_2_EP1",				[[0,2.5,.6],[0,2,0], 	0, 	true, false, true, false, true, false, false, false, false, false, false, true]],//Gate Panel w/ KeyPad --4
[[3, 3, 2, 2, 0, 0], "WarfareBDepot",					[[0,18,2], 	[0,15,0], 	90, true, true, false, true, false, false, false, true, true, false, false, true]],//WarfareBDepot --5
[[4, 1, 2, 2, 0, 0], "Base_WarfareBBarrier10xTall", 	[[0,10,1], 	[0,10,0], 	0, 	true, true, false, true, false, false, false, true, false, false, false, true]],//Base_WarfareBBarrier10xTall --6 
[[2, 1, 2, 1, 0, 0], "WarfareBCamp",					[[0,12,1], 	[0,10,0], 	180, 	true, true, false, true, false, false, false, true, true, false, false, true]],//WarfareBCamp --7
[[2, 1, 1, 1, 0, 0], "Base_WarfareBBarrier10x", 		[[0,10,.6], [0,10,0], 	0, 	true, true, false, true, false, false, false, true, false, false, false, true]],//Base_WarfareBBarrier10x --8
[[2, 2, 0, 2, 0, 0], "Land_fortified_nest_big", 		[[0,12,1], 	[2,8,0], 	180,true, true, false, true, false, false, false, true, true, false, false, true]],//Land_fortified_nest_big --9
[[2, 1, 2, 2, 0, 0], "Land_Fort_Watchtower",			[[0,10,2.2],[0,8,0], 	90, true, true, false, true, false, false, false, true, true, false, false, true]],//Land_Fort_Watchtower --10
[[1, 3, 0, 2, 0, 0], "Land_fort_rampart_EP1", 		[[0,7,.2], 	[0,8,0], 	180, 	true, true, false, true, true, false, false, true, false, false, false, true]],//Land_fort_rampart_EP1 --11
[[2, 1, 1, 0, 0, 0], "Land_HBarrier_large", 			[[0,7,1], 	[0,4,0], 	0, 	true, true, true, false, true, false, false, true, false, false, false, true]],//Land_HBarrier_large --12
[[2, 1, 0, 1, 0, 0], "Land_fortified_nest_small",		[[0,7,1], 	[0,3,0], 	90, true, true, true, false, true, false, false, true, true, false, false, true]],//Land_fortified_nest_small --13
[[0, 1, 1, 0, 0, 0], "Land_BagFenceRound",			[[0,4,.5], 	[0,2,0], 	180,true, true, false, false, true, false, false, true, false, false, false, true]],//Land_BagFenceRound --14
[[0, 1, 0, 0, 0, 0], "Land_fort_bagfence_long", 		[[0,4,.3], 	[0,2,0], 	0, 	true, true, false, false, true, false, false, true, false, false, false, true]],//Land_fort_bagfence_long --15
[[6, 0, 0, 0, 2, 0], "Land_Misc_Cargo2E",				[[0,7,2.6], [0,5,0], 	90, true, false, false, true, true, false, false, true, false, false, false, true]],//Land_Misc_Cargo2E --16
[[5, 0, 0, 0, 1, 0], "Misc_Cargo1Bo_military",		[[0,7,1.3], [0,5,0], 	90, true, false, false, true, true, false, false, true, false, false, false, true]],//Misc_Cargo1Bo_military --17
[[3, 0, 0, 0, 1, 0], "Ins_WarfareBContructionSite",	[[0,7,1.3], [0,5,0], 	90, true, false, false, true, true, false, false, true, false, false, false, true]],//Ins_WarfareBContructionSite --18
[[1, 1, 0, 2, 1, 0], "Land_pumpa",					[[0,3,.4], 	[0,3,0], 	0, 	true, true, true, false, true, false, false, true, false, false, false, true]],//Land_pumpa --19
[[1, 0, 1, 0, 0, 0], "Land_CncBlock",					[[0,3,.4], 	[0,2,0], 	0, 	true, false, false, false, true, true, true, true, false, false, false, true]],//Land_CncBlock --20
[[2, 0, 0, 0, 1, 0], "Hhedgehog_concrete",			[[0,5,.6], 	[0,4,0], 	0, 	true, true, false, true, false, true, false, true, false, false, false, true]],//Hhedgehog_concrete --21
[[1, 0, 0, 0, 2, 0], "Misc_cargo_cont_small_EP1",		[[0,5,1.3], [0,4,0], 	90, true, false, false, false, true, false, false, true, false, false, false, true]],//Misc_cargo_cont_small_EP1 --22
[[1, 0, 0, 2, 0, 0], "Land_prebehlavka",				[[0,6,.7], 	[0,3,0], 	90, true, false, false, false, true, false, false, true, false, true, true, true]],//Land_prebehlavka(Ramp) --23
[[2, 0, 0, 0, 0, 0], "Fence_corrugated_plate",		[[0,4,.6], 	[0,3,0], 	0,	true, true, true, false, true, false, false, false, false, false, false, true]],//Fence_corrugated_plate --24
[[2, 0, 1, 0, 0, 0], "ZavoraAnim", 					[[0,5,4.0], [0,5,0], 	180, 	true, false, false, false, false, true, false, true, false, true, true, true]],//ZavoraAnim --25
[[0, 0, 3, 1, 1, 0], "Land_tent_east", 				[[0,8,1.7], [0,6,0], 	0, 	true, false, false, true, false, false, false, true, true, true, true, true]],//Land_tent_east --26
[[0, 0, 6, 0, 1, 0], "Land_CamoNetB_EAST",			[[0,10,2], 	[0,10,0], 	0, 	true, false, false, true, false, false, false, true, true, true, true, true]],//Land_CamoNetB_EAST --27
[[0, 0, 5, 0, 1, 0], "Land_CamoNetB_NATO", 			[[0,10,2], 	[0,10,0], 	0, 	true, false, false, true, false, false, false, true, true, true, true, true]],//Land_CamoNetB_NATO --28
[[0, 0, 4, 0, 1, 0], "Land_CamoNetVar_EAST",			[[0,10,1.2],[0,7,0], 	0, 	true, false, true, false, false, false, false, true, false, true, true, true]],//Land_CamoNetVar_EAST --29
[[0, 0, 3, 0, 1, 0], "Land_CamoNetVar_NATO", 			[[0,10,1.2],[0,7,0], 	0, 	true, false, true, false, false, false, false, true, false, true, true, true]],//Land_CamoNetVar_NATO --30
[[0, 0, 2, 0, 1, 0], "Land_CamoNet_EAST",				[[0,8,1.2], [0,7,0], 	0, 	true, false, true, false, false, false, false, true, false, true, true, true]],//Land_CamoNet_EAST --31
[[0, 0, 1, 0, 1, 0], "Land_CamoNet_NATO",				[[0,8,1.2], [0,7,0], 	0, 	true, false, true, false, false, false, false, true, false, true, true, true]],//Land_CamoNet_NATO --32
[[0, 0, 2, 2, 0, 0], "Fence_Ind_long",				[[0,5,.6], 	[-4,1.5,0], 0, 	true, false, true, false, true, false, false, true, false, true, true, true]], //Fence_Ind_long --33
[[0, 0, 1, 0, 0, 0], "Fort_RazorWire",				[[0,5,.8], 	[0,4,0], 	0, 	true, false, false, false, true, false, false, true, false, true, true, true]],//Fort_RazorWire --34
[[0, 0, 2, 0, 0, 0], "Fence_Ind",  					[[0,4,.7], 	[0,2,0], 	0, 	true, false, false, false, true, false, true, true, false, true, true, true]], //Fence_Ind --35
[[2, 1, 0, 0, 0, 0], "Land_sara_hasic_zbroj",  		[[0,10,2.4], [0,10,2.4], 	0, 	true, true, true, true, false, false, false, true, true, false, false, true]], //Land_sara_hasic_zbroj --36
[[1, 2, 1, 2, 0, 0], "Land_Shed_wooden",  			[[0,8,1], 	[0,10,0], 	0, 	true, true, true, true, true, false, false, true, true, false, false, true]], //Land_Shed_wooden --37
[[1, 1, 1, 2, 0, 0], "Land_Barrack2",  				[[0,10,1], 	[0,12,0], 	0, 	true, true, true, true, false, false, false, true, true, false, false, true]], //Land_Barrack2 --38
[[2, 0, 0, 0, 2, 0], "Land_vez",  					[[0,6,1], 	[0,8,0], 	0, 	true, true, true, true, true, false, false, true, true, false, false, true]], //Land_vez --39
[[3, 0, 0, 0, 2, 0], "Land_Ind_Shed_01_main",  		[[0,10,1], 	[0,10,0], 	0, 	true, false, false, true, true, false, false, false, false, false, false, true]], //Land_Ind_Shed_01_main --40
[[2, 1, 0, 0, 2, 0], "Land_Ind_Shed_01_end",  		[[0,10,1], 	[0,10,0], 	0, 	true, false, false, false, true, false, false, true, false, false, false, true]], //Land_Ind_Shed_01_main --40
[[4, 0, 0, 0, 2, 0], "Land_Ind_SawMillPen",  			[[0,10,1], 	[0,10,0], 	0, 	true, false, false, true, true, false, false, true, false, false, false, true]], //Land_Ind_Shed_01_main --40
[[1, 0, 0, 0, 1, 0], "Land_Fire_barrel",  			[[0,3,0.6], [0,4,0], 	0, 	true, false, false, false, true, false, false, true, false, true, true, true]], //Land_Fire_barrel --41 
[[0, 1, 0, 2, 0, 0], "Land_WoodenRamp",  				[[0,5,0.4], [0,4,0], 	0, 	true, false, false, false, true, false, false, true, false, false, false, true]], //Land_WoodenRamp --42 
[[2, 0, 2, 0, 2, 0], "Land_Ind_TankSmall2_EP1",  		[[0,6,1.3], [0,5,1.3], 	90, true, true, true, true, false, false, false, true, true, false, false, true]], //Land_Ind_TankSmall2_EP1 --43 
[[2, 0, 2, 2, 0, 0], "PowerGenerator_EP1",  			[[0,5,0.9], [0,5,0.9], 	90, true, true, true, true, false, false, false, true, true, false, false, true]], //PowerGenerator_EP1 --44 
[[1, 2, 0, 0, 3, 0], "Land_Ind_IlluminantTower",  	[[0,10,9.6], [0,10,9.6], 0, true, true, true, true, false, false, false, true, true, false, false, true]], //Land_Ind_IlluminantTower --45 
[[0, 0, 0, 4, 0, 0], "Land_A_Castle_Stairs_A",  		[[-5,10,3.5], [-5,10,3.5],90, true, true, true, true, false, false, false, true, true, false, false, true]], //Land_A_Castle_Stairs_A --46 
[[3, 2, 0, 0, 2, 0], "Land_A_Castle_Bergfrit",		[[0,20,15], [0,20,15], -90, true, true, true, true, false, false, false, true, true, false, false, true]], //Land_House_C_9_EP1         --48 
[[3, 3, 0, 0, 0, 0], "Land_A_Castle_Bastion",			[[0,16,10], [0,16,10], 180, true, true, true, true, false, false, false, true, true, false, false, true]], //Land_House_C_9_EP1         --48 
[[2, 2, 0, 0, 2, 0], "Land_A_Castle_Wall1_20",		[[0,16,10], [0,16,10], 180, true, true, true, true, false, false, false, true, true, false, false, true]], //Land_House_C_9_EP1         --48 
[[2, 2, 0, 0, 1, 0], "Land_A_Castle_Wall1_20_Turn",	[[0,16,10], [0,16,10], 180, true, true, true, true, false, false, false, true, true, false, false, true]], //Land_House_C_9_EP1         --48 
[[3, 2, 0, 0, 1, 0], "Land_A_Castle_Wall2_30",		[[0,16,10], [0,16,10], 180, true, true, true, true, false, false, false, true, true, false, false, true]], //Land_House_C_9_EP1         --48 
[[2, 0, 0, 2, 2, 0], "Land_A_Castle_Gate",  			[[0,17,6], [0,17,6], 	0, 	true, true, true, true, false, false, false, true, true, false, false, true]], //Land_A_Castle_Gate --47 
[[1, 1, 1, 1, 0, 0], "Land_House_L_1_EP1",  			[[0,20,2], [0,20,2], 	0, 	true, true, true, true, false, false, false, true, true, false, false, true]], //Land_House_L_1_EP1 --48 
[[5, 1, 0, 0, 2, 0], "Land_ConcreteRamp",  			[[0,12,0.5],[0,12,0], 	0, 	true, true, true, true, false, true, false, true, false, false, false, true]], //Land_ConcreteRamp --49 
[[3, 1, 0, 0, 1, 0], "RampConcrete",  				[[0,10,0.5],[0,10,0], 	0, 	true, true, true, false, false, true, false, true, false, false, false, true]], //RampConcrete --50
[[1, 1, 1, 0, 0, 0], "HeliH",  						[[0,8,0.5], [0,8,0], 	0, 	false, false, false, false, true, false, false, true, false, true, false, true]], //HeliH --51 
[[1, 2, 1, 0, 0, 0], "HeliHCivil",  					[[0,8,0.5], [0,8,0], 	0, 	false, false, false, false, true, false, false, true, false, true, false, true]], //HeliHCivil --52 
[[2, 0, 0, 0, 3, 0], "Land_ladder",  					[[0,5,0.8], [0,5,0], 	0, 	true, false, true, false, true, false, false, true, false, false, false, true]], //Land_ladder --54 
[[1, 0, 0, 0, 3, 0], "Land_ladder_half",  			[[0,5,1], 	[0,5,0], 	0, 	true, false, true, false, true, false, false, true, false, false, false, true]], //Land_ladder_half --55 
[[0, 0, 0, 3, 0, 0], "Land_Misc_Scaffolding",  		[[0,12,0.5],[0,12,0], 	0, 	true, true, true, false, true, false, false, true, false, false, false, true]], //Land_Misc_Scaffolding --56
[[1, 0, 0, 0, 0, 0], "Hedgehog_DZ",  					[[0,2,0.4],[0,2,0.4], 	0, 	true, true, true, false, true, false, false, true, false, false, false, true]], //Land_Misc_Scaffolding --57 *** Remember that the last element in array does not get comma ***
[[2, 0, 2, 1, 2, 0], BBTypeOfZShield,  				[[0,4.5,2],[0,4.5,2], 	0, 	true, true, true, false, true, false, false, true, false, false, false, true]] //Land_Misc_Scaffolding --57 *** Remember that the last element in array does not get comma ***
];
//t, s, w, L, m, g, e, cr, c, b, s, d														// _toolBox, _eTool, _medWait, _longWait, _inBuilding, _roadAllowed, _inTown, _removable, _isStructure, _isSimulated, _isDestructable, _requireFlag];

//Extendable object have the option to elevate/lower when positioning. They DO NOT follow ground contours and will always remain perfectly vertical.
allExtendables = ["Concrete_Wall_EP1","Infostand_2_EP1","Land_HBarrier_large","Land_fortified_nest_small","Land_BagFenceRound","Land_fort_bagfence_long",
					"Land_Misc_Cargo2E","Misc_Cargo1Bo_military","Ins_WarfareBContructionSite","Land_CncBlock","Misc_cargo_cont_small_EP1","Land_prebehlavka",
					"Fence_corrugated_plate","Land_CamoNet_EAST","Land_CamoNet_NATO","Fence_Ind_long","Fort_RazorWire","Fence_Ind","Land_Shed_wooden","Land_vez",
					"Land_Ind_Shed_01_main","Land_Ind_Shed_01_end","Land_Ind_SawMillPen","Land_Fire_barrel","Land_WoodenRamp","Land_ConcreteRamp","RampConcrete",
					"Land_ladder","Land_ladder_half","Land_Misc_Scaffolding","Land_Ind_TankSmall2_EP1","PowerGenerator_EP1","Land_Ind_IlluminantTower",
					"Land_A_Castle_Bergfrit","Land_A_Castle_Stairs_A","Land_A_Castle_Gate","Land_A_Castle_Bastion","Land_A_Castle_Wall1_20","Land_A_Castle_Wall1_20_Turn",
					"Land_A_Castle_Wall2_30","Land_sara_hasic_zbroj",BBTypeOfZShield];

// Build allremovables array for remove action
for "_i" from 0 to ((count _buildlist) - 1) do
{
	_removable = (_buildlist select _i) select _i - _i + 1;
	if (_removable != "Grave") then { // Booby traps have disarm bomb
	allremovables set [count allremovables, _removable];
	};
};
// Build classnames array for use later
for "_i" from 0 to ((count _buildlist) - 1) do
{
	_classname = (_buildlist select _i) select _i - _i + 1;
	allbuildables_class set [count allbuildables_class, _classname];
};


/*
*** Remember that the last element in ANY array does not get comma ***
Notice lines 47 and 62
*/

	antiBuildables = ["Hhedgehog_concrete"];
// Towns to restrict from building in. (Type exact name as shown on map, NOT Case-Sensitive but spaces important)
// ["Classname", range restriction];
// NOT REQUIRED SERVER SIDE, JUST ADDED IN IF YOU NEED TO USE IT
_build_townsrestrict = [
/*["Lyepestok", 1000],
["Sabina", 900],
["Branibor", 600],
["Bilfrad na moru", 400],
["Mitrovice", 350],
["Seven", 300],
["Blato", 300]*/
];
// Here we are filling the global arrays with this local list
allbuildables = _buildlist;
allbuild_notowns = _build_townsrestrict;

/*
This Area is for extra arrays that need to be built, some using above arrays
*/
};
//####----####----####---- BUILD LIST ARRAY SERVER SIDE End ----####----####----####
//####----####----####---- Base Building 1.3 End ----####----####----####



//Sector FNG inland
execVM "\z\addons\dayz_server\CustomBuildings\sectorfng\sectorfng_init.sqf";

//IXXO
execVM "\z\addons\dayz_server\CustomBuildings\balota.sqf";
execVM "\z\addons\dayz_server\CustomBuildings\kamenka.sqf";
execVM "\z\addons\dayz_server\CustomBuildings\Krasno.sqf";
execVM "\z\addons\dayz_server\CustomBuildings\northeast.sqf";
execVM "\z\addons\dayz_server\CustomBuildings\vybor.sqf";
execVM "\z\addons\dayz_server\CustomBuildings\basebor.sqf";
execVM "\z\addons\dayz_server\CustomBuildings\basedichina.sqf";
execVM "\z\addons\dayz_server\CustomBuildings\basenovy.sqf";
execVM "\z\addons\dayz_server\CustomBuildings\Zeleno.sqf";

//Caves
execVM "\z\addons\dayz_server\CustomBuildings\Prud_Cave.sqf";
execVM "\z\addons\dayz_server\CustomBuildings\North_Cave.sqf";
execVM "\z\addons\dayz_server\CustomBuildings\South_Cave.sqf";

//Kameka mine
execVM "\z\addons\dayz_server\CustomBuildings\mine_grotte.sqf";//removed ore and added to separate spawn
execVM "\z\addons\dayz_server\CustomBuildings\mine_grotte_ore.sqf";//ore
execVM "\z\addons\dayz_server\CustomBuildings\box_la_grotte.sqf";

//CDC Balota + Trader
execVM "\z\addons\dayz_server\CustomBuildings\Trader_CDC_Balota.sqf";

//Altar
execVM "\z\addons\dayz_server\CustomBuildings\altar.sqf";

//Golden River MIne
execVM "\z\addons\dayz_server\CustomBuildings\golden_river_mine.sqf";

//cherno heliport
execVM "\z\addons\dayz_server\CustomBuildings\heliport.sqf";

//beached aircraft carrier
execVM "\z\addons\dayz_server\CustomBuildings\aircraftcarrier.sqf";

//BANK
execVM "\z\addons\dayz_server\CustomBuildings\banks\nbank_novy_sobor.sqf";

//East coast cherno
execVM "\z\addons\dayz_server\CustomBuildings\Eastcoast.sqf";
execVM "\z\addons\dayz_server\CustomBuildings\Eastcoast2.sqf";

//Black Lake Castle
execVM "\z\addons\dayz_server\CustomBuildings\blacklakecastle.sqf";

execVM "\z\addons\dayz_server\CustomBuildings\kabinocheckpoint.sqf";
execVM "\z\addons\dayz_server\CustomBuildings\otmel.sqf";

//road from dam to sector FNG
execVM "\z\addons\dayz_server\CustomBuildings\roadpobeda.sqf";

//Black forest outpost
execVM "\z\addons\dayz_server\CustomBuildings\blackforestoutpost.sqf";

//Electro
execVM "\z\addons\dayz_server\CustomBuildings\electro.sqf";
execVM "\z\addons\dayz_server\CustomBuildings\electroZI.sqf";

//Cherno
execVM "\z\addons\dayz_server\CustomBuildings\Cherno.sqf";

//Enhanced Spawn Selection
donorListBase = [
	"10332294", //ebay example
	"0",
	"0"
];

donorListBases = [
	[2324.2893,15365.067,0], //ebay example
	[],
	[]
];
donorClassLvl1 = ["120958982","110704838","108784838"];
donorClassLvl2 = ["120958982","110704838","108784838"];
donorClassLvl3 = ["120958982","110704838","108784838"];
donorListClass = [
	"120958982", //sheep
	"110704838",
	"108784838"
];

donorListClasses = [
	["ebay's Loadout","GUE_Soldier_2_DZ",["100Rnd_762x51_M240","100Rnd_762x51_M240","30Rnd_9x19_UZI_SD","30Rnd_9x19_UZI_SD","30Rnd_9x19_UZI_SD","ItemAntibiotic","ItemBloodbag","ItemEpinephrine","ItemMorphine","Skin_GUE_Soldier_Sniper_DZ","ItemBandage"],["Mk_48_DZ","UZI_SD_EP1","Binocular_Vector","NVGoggles","ItemCompass","ItemHatchet","ItemKnife","Itemmatchbox","Itemetool","ItemSledge","ItemWatch","ItemGPS","ItemCrowbar"],"DZ_Backpack_EP1",["5Rnd_86x70_L115A1","5Rnd_86x70_L115A1","5Rnd_86x70_L115A1"],["BAF_LRR_scoped_W"],0,0],
	[],
	[]
];
DefaultMagazines = ["ItemBandage","ItemBandage","ItemBandage","ItemPainkiller","ItemWaterbottle","FoodPistachio","17Rnd_9x19_glock17","17Rnd_9x19_glock17","17Rnd_9x19_glock17"]; 
DefaultWeapons = ["ItemMap","ItemFlashlight","ItemToolbox","glock17_EP1"]; 
DefaultBackpack = "DZ_Assault_Pack_EP1";

presetClasses = [
	["Bandit","Bandit2_DZ",["10x_303","10x_303"],["LeeEnfield"],"",[],[],0,-2000],
	["Hero","Soldier_Sniper_PMC_DZ",["10x_303","10x_303"],["LeeEnfield"],"",[],[],0,5000],
	["Survivor","Survivor2_DZ",[],[],"",[],[],0,0],
	["British Soldier","Soldier1_DZ",["30Rnd_556x45_Stanag","30Rnd_556x45_Stanag"],["BAF_L85A2_RIS_Holo"],"",[],[],0,0],
	["Business Person","Functionary1_EP1_DZ",["8Rnd_B_Beneli_74Slug","8Rnd_B_Beneli_74Slug","8Rnd_B_Beneli_74Slug","ItemBriefcaseS20oz"],["Remington870_lamp"],"",[],[],0,0],
	["Civilian","Haris_Press_EP1_DZ",["15Rnd_W1866_Slug","15Rnd_W1866_Slug"],["Winchester1866"],"",[],[],0,0],
	["Czech Soldier","CZ_Special_Forces_GL_DES_EP1_DZ",["30Rnd_762x39_SA58","30Rnd_762x39_SA58"],["Sa58P_EP1"],"",[],[],0,0],
	["Police Officer","RU_Policeman_DZ",["8Rnd_B_Beneli_74Slug","8Rnd_B_Beneli_74Slug","8Rnd_B_Beneli_74Slug"],["M1014"],"",[],[],0,0],
	["Rocker","Rocker1_DZ",["30Rnd_9x19_MP5SD","30Rnd_9x19_MP5SD"],["MP5SD"],"",[],[],0,0],
	["Terrorist","TK_INS_Soldier_EP1_DZ",["30Rnd_545x39_AK","30Rnd_545x39_AK"],["AK_74"],"",[],[],0,0],
	["US Soldier","Graves_Light_DZ",["30Rnd_556x45_Stanag","30Rnd_556x45_Stanag"],["M4A1"],"",[],[],0,0],
	["Scout*","INS_Soldier_AR_DZ",["100Rnd_556x45_BetaCMag","100Rnd_556x45_BetaCMag","15Rnd_9x19_M9SD","15Rnd_9x19_M9SD","15Rnd_9x19_M9SD","ItemAntibiotic","ItemBloodbag","ItemEpinephrine","ItemMorphine"],["m16a4_acg","M9SD","Binocular_Vector"],"DZ_ALICE_Pack_EP1",[],[],1,0],
	["Specialist**","INS_Soldier_CO_DZ",["100Rnd_762x51_M240","100Rnd_762x51_M240","30Rnd_9x19_UZI_SD","30Rnd_9x19_UZI_SD","30Rnd_9x19_UZI_SD","ItemAntibiotic","ItemBloodbag","ItemEpinephrine","ItemMorphine"],["Mk_48_DZ","UZI_SD_EP1","Binocular_Vector"],"DZ_British_ACU",[],[],2,0],
	["Sniper***","GUE_Soldier_Sniper_DZ",["20Rnd_762x51_DMR","20Rnd_762x51_DMR","30Rnd_9x19_UZI_SD","30Rnd_9x19_UZI_SD","30Rnd_9x19_UZI_SD","ItemAntibiotic","ItemBloodbag","ItemEpinephrine","ItemMorphine"],["DMR","UZI_SD_EP1","Binocular_Vector"],"DZ_Backpack_EP1",[],[],3,0]
];

publicVariable "donorListBase";
publicVariable "donorListBases";
publicVariable "donorListClass";
publicVariable "donorListClasses";
publicVariable "DefaultMagazines";
publicVariable "DefaultWeapons";
publicVariable "DefaultBackpack";
publicVariable "donorClassLvl1";
publicVariable "donorClassLvl2";
publicVariable "donorClassLvl3";
publicVariable "presetClasses";