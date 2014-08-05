GearRemove = (vehicle player);
removeAllWeapons GearRemove;
removeAllItems GearRemove;
removebackpack GearRemove;

cutText ["Gear deleted!", "PLAIN"];
if ( AdminTrackDeleteGear ) then{
	_playerUID = getplayerUID player;
	_playerName = name player;
	diag_log format["[ADMIN TOOLS] - GEAR DELETED  - Admin Name: %1 UID: %2 " , _playerName, _playerUID ];
};