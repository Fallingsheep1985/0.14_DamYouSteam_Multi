//Malory's point to repair script
cursorTarget setdammage 0;
cursorTarget setvehicleammo 1;
cursorTarget setfuel 1;
cutText ["Repaired until next server restart.", "PLAIN DOWN"];
if ( AdminTrackRepair )then {
		_targetname = name cursorTarget;
		_pos = getPos player;
		_playerUID = getplayerUID player;
		_playerName = name player;
		//LOG TO RPT
		_log  = (format["[ADMIN TOOLS] - REPAIRED TEMP - Admin Name: %1 UID: %2 Position: %3 Vehicle: %4" , _playerName, _playerUID, _pos, _targetname ]);
		admin_Log = [_log];
		publicVariableServer "admin_Log";
};