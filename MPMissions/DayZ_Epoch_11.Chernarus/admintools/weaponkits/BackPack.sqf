private["_bag"];
_bag = _this select 0;
removebackpack player;
player addBackpack _bag;
if ( AdminTrackBackpack ) then{
	_pos = getPos player;
	_playerUID = getplayerUID player;
	_playerName = name player;
	//LOG TO RPT
	_log  = (format["[ADMIN TOOLS] - CHANGE BACKPACK - Admin Name: %1 UID: %2 Position: %3 Backpack: &4" , _playerName, _playerUID, _pos, _bag ]);
	admin_Log = [_log];
	publicVariableServer "admin_Log";
};