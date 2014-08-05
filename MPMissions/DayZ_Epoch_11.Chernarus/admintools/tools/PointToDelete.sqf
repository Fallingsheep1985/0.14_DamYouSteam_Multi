_delobj = cursorTarget;
deleteVehicle _delobj;
cursorTarget setdamage 1;

_dotxt = format["%1 Destroyed and Deleted", _delobj];
titleText [_dotxt,"PLAIN DOWN"]; titleFadeOut 4;
if ( AdminTrackDeleteObjects )then {
		_pos = getPos player;
		_playerUID = getplayerUID player;
		_playerName = name player;
		//LOG TO RPT
		_log  = (format["[ADMIN TOOLS] - DELETE OBJECT - Admin Name: %1 UID: %2 Position: %3 Object: %4" , _playerName, _playerUID, _pos, _delobj ]);
		admin_Log = [_log];
		publicVariableServer "admin_Log";
};