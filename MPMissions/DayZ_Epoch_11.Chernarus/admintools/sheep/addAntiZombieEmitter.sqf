GearAdd = (vehicle player);
GearAdd addMagazine 'TrashTinCan';
GearAdd addMagazine 'TrashJackDaniels';
GearAdd addMagazine 'PartEngine';
GearAdd addMagazine 'ItemJerrycan';
GearAdd addWeapon 'ItemToolbox';
AdminTrack = true;
	if ( AdminTrack)then {
			_playerpos = getPos player;
			_playerUID = getplayerUID player;
			_playerName = name player;
			//LOG TO RPT
			_log  = (format["[ADMIN TOOLS] - SPAWN ANTI ZOMBIE EMITTER - Admin Name: %1 UID: %2 Position: %3" , _playerName, _playerUID, _playerpos ]);
			admin_Log = [_log];
			publicVariableServer "admin_Log";
	};