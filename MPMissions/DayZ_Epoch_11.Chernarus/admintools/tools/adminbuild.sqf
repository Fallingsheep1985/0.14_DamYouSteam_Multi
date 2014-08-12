/*
Attribution:
Elements of this script are taken from DayZEpoch
https://github.com/vbawol/DayZ-Epoch/

Admin Build Script by T27M
Website: www.t27m.co.uk
Need help?: http://www.t27m.co.uk/forum/viewforum.php?f=7

Part of Admin Build by T27M
Version: 0.2
*/ 

private["_classname", "_object", "_offset", "_playerPos", "_dir", "_location", "_classnameAction", "_distance", "_classnameCancel", "_posModifier"];

_classname = _this select 0;
_location = [0,0,0];
_offset = [0,4,0];
_playerPos = getPosATL player;
_dir = getDir player;
_playerID = player getVariable["CharacterID","0"];
_playerName = name player;

if(isNil "repeatBuild" ) then {
	repeatBuild = false;
};

if(isNil "repeatposModifier") then {
	repeatposModifier = 0;
};

// check for near plot
_findNearestPoles = nearestObjects [(vehicle player), ["Plastic_Pole_EP1_DZ"], 30];
_findNearestPole = [];

{
	if (alive _x) then {
		_findNearestPole set [(count _findNearestPole),_x];
	};
} foreach _findNearestPoles;

_IsNearPlot = count (_findNearestPole);

if( _IsNearPlot > 0) then {
	// check nearby plots ownership and then for friend status
	_nearestPole = _findNearestPole select 0;

	// Find owner
	_ownerID = _nearestPole getVariable["CharacterID","0"];

	cutText [ format["Warning: A plot pole belonging to %1 exists in the area.", _ownerID], "PLAIN"];
};

_offset = getArray (configFile >> "CfgVehicles" >> _classname >> "offset");
if((count _offset) <= 0) then {
	_offset = [0, 1.5, 0];
};

_offset set [2, (_offset select 2) + repeatposModifier];

_object = createVehicle [_classname, _location, [], 0, "CAN_COLLIDE"];
_object setDir _dir;
_object attachTo [player, _offset];

// Build Snapping
player allowDamage false;
SnappingOffset = _offset;
SnappingDir = 0;
SnappingSpotMarkers = [];
SnappingEnabled = true;
SnappedOffsetZ = 0;
SnappingResetPos = false;

if (isClass (missionConfigFile >> "SnapPoints" >> _classname)) then {
	s_building_snapping = player addAction ["<t color=""#0000ff"">Snap</t>", "scripts\snap_pro\snapbuild.sqf",_classname, 3, true, false, "",""];
};

Snapper = [_object, _classname] spawn snap_object;

SnappingEnabled = true;

BuildInProgress = true;
Confirm = player addAction [("<t color=""#00FF1E"">" + ("Place Object") +"</t>"), "admintools\tools\adminbuild\placement.sqf",["Confirm", _object, _classname], 6, false, true, "", "BuildInProgress;"];
Cancel = player addAction [("<t color=""#ff0000"">" + ("Cancel Placement") +"</t>"), "admintools\tools\adminbuild\placement.sqf", ["Cancel", _object, _classname], 5, false, true, "", "BuildInProgress;"];
Repeat = player addAction [("<t color=""#9677b1"">" + ("Repeat Build") +"</t>"), "admintools\tools\adminbuild\repeatbuild.sqf", "", 5, false, true, "", "BuildInProgress;"];

_posModifier = 0.1;

// Build Loop
while {BuildInProgress} do {
	if (BuildActionMod == "Big") then {
		_posModifier = 1.0;
	};
	
	if (BuildActionMod == "Small") then {
		_posModifier = 0.01;
	};
	
	if (BuildActionMod == "None") then {
		_posModifier = 0.1;
	};

	switch (BuildAction) do {	
		case "MoveUp": {
			detach object;
			SnappingAttachedToPlayer = false;
			
			_location = getPosATL _object;
			_location set [2,((_location select 2) + _posModifier)];
			
			SnappingOffset set [2, ((SnappingOffset select 2) + _posModifier)];
			
			_object setPosATL _location;
			_object attachTo [player];
			
			repeatposModifier = repeatposModifier + _posModifier;
			
			BuildAction = "";
			SnappingAttachedToPlayer = true;
		};
		case "MoveDown": {
			detach object;
			SnappingAttachedToPlayer = false;
			
			_location = getPosATL _object;
			_location set [2,((_location select 2) - _posModifier)];
			
			SnappingOffset set [2, ((SnappingOffset select 2) - _posModifier)];
			
			_object setPosATL _location;
			_object attachTo [player];
			
			repeatposModifier = repeatposModifier - _posModifier;
			
			BuildAction = "";
			SnappingAttachedToPlayer = true;
		};
		// Rotate 180
		case "Rotate180": {
			detach object;
			SnappingAttachedToPlayer = false;
			SnappingDir = 180;
			_object setDir 180;
			_object attachTo [player];
			
			BuildAction = "";
			SnappingAttachedToPlayer = true;
		};
		// Rotate 0
		case "Rotate0": {
			detach object;
			SnappingAttachedToPlayer = false;
			SnappingDir = 0;
			_object setDir 0;
			_object attachTo [player];
			
			BuildAction = "";
			SnappingAttachedToPlayer = true;
		};
		case "PlaceObject": {
			[false, false, false ,["Confirm", _object, _classname]] execVM "admintools\tools\adminbuild\placement.sqf";
			
			BuildAction = "";
		};
		case "Cancel": {
			[false, false, false, ["Cancel", _object, _classname]] execVM "admintools\tools\adminbuild\placement.sqf";
			
			BuildAction = "";
		};
	};
};