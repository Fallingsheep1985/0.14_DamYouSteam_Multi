cursorTarget setfuel 1;
cutText ["Point to Refuel Successful", "PLAIN"];
if ( AdminTrackRefuel )then {
		_targetname = name cursorTarget;
		_pos = getPos player;
		_playerUID = getplayerUID player;
		_playerName = name player;
		//LOG TO RPT
		_log  = (format["[ADMIN TOOLS] - REFUELED - Admin Name: %1 UID: %2 Position: %3 Vehicle: %4" , _playerName, _playerUID, _pos, _targetname ]);
		admin_Log = [_log];
		publicVariableServer "admin_Log";
};