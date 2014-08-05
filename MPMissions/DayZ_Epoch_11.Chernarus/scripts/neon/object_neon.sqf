private ["_neonColor","_theCar","_Vehicle","_HASneon"];
_theCar = _this select 3; 
_Vehicle = _theCar select 0; 
_HASneon = _Vehicle getVariable["Neon", false]; 

if( !_HASneon ) then { 
	_Vehicle setVariable["Neon", true, true]; 
	_neonColor = _Vehicle getVariable "NeonColour";
	if (isNil {_neonColor}) then { _neonColor = [1, 2, 3, 4] call BIS_fnc_selectRandom; };
	if( _neonColor > 4 ) then { _neonColor = 1; }; 
	_Vehicle setVariable["NeonColour", _neonColor, true]; 
	_Vehicle setVariable["ShouldHaveLight", true, true];
	neon_toggle = 1; 
	[_Vehicle, _neonColor] spawn spawnObjLight; 
	
	SAND_spawnLight = [_Vehicle, _neonColor]; 
	publicVariable "SAND_spawnLight"; 
	
	while{ (alive _Vehicle) and (neon_toggle != 0) and (_Vehicle getVariable["Neon", false]) and (_Vehicle getVariable["ShouldHaveLight", true]) } do { sleep 0.2; }; 
	if( neon_toggle != 0 ) then { neon_toggle = 0; 	_Vehicle setVariable["ShouldHaveLight", false, true]; }; 
	
} else { 
	_Vehicle setVariable["Neon", false, true]; 
	if( neon_toggle != 0 ) then { neon_toggle = 0; 	_Vehicle setVariable["ShouldHaveLight", false, true];  }; 
};