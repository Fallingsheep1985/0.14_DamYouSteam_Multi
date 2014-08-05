_newCiv = cursorTarget;
_dist = player distance _newCiv;
_isMan = _newCiv isKindOf "Man";
_isAlive = alive _newCiv;


detach _newCiv;    // Just incase
//part required to detain
_magazinesPlayer = magazines player;
_hasScrap = "PartGeneric" in _magazinesPlayer;
if (_hasScrap) then{
if (canbuild) then{
if(_dist < 10 && _isMan && _isAlive ) then {
    // removing required...
    player removeMagazine"PartGeneric";
    sleep 1;
    player playActionNow "Medic";
    // Hint
    cutText [format["Your hostage is tied up for the next 10 minutes!"], "PLAIN"];
    systemChat ('Your hostage is tied up for the next 10 minutes!');
    // Public Var
    _newCiv setVariable ["Detain",1,true];
    PVDZ_ply_Arrst = _newCiv;
    publicVariable "PVDZ_ply_Arrst";
    if ((getPlayerUID _newCiv) in AdminList) then {
        //Admins can escape with bandage/vault
    } else {
        // Creates temp can and attaches to player
        _dir = getdir vehicle player;
        _pos = getPos vehicle player;
        _pos = [(_pos select 0)+1.5*sin(_dir),(_pos select 1)+1.5*cos(_dir),0];
        _item = createVehicle ["Can_Small", _pos, [], 0.0, "CAN_COLLIDE"];
        _item setPosATL _pos;
        _item setDir _dir;
        _newCiv attachto [_item,[0, 0, 0]];
    };
    //animation sitting arrested
    [objNull, _newCiv, rswitchmove ,"CivilSitting"] call RE;
if (_newCiv getVariable "Detain" == 1) then {
        sleep 600;
        detach _newCiv;
        _objects = nearestObjects [player, ["Can_Small"], 50];
        _objects = _objects select 0;
        deleteVehicle _objects;
        [objNull, _newCiv, rswitchmove,""] call RE;
        _newCiv setVariable ["Detain",0,true];
        PVDZ_ply_Arrst = _newCiv;
        publicVariable "PVDZ_ply_Arrst";
};
};
}else{
	if(!canbuild)then{
		cutText [format["You cant detain a player in a safezone!"], "PLAIN"];
		systemChat ('You cant detain a player in a safezone!');
	}else{
		cutText [format["You cant detain a trader!"], "PLAIN"];
		systemChat ('You cant detain a trader!');
	};
};
}else{
cutText [format["You must have scrap metal to detain a player!"], "PLAIN"];
    systemChat ('You must have scrap metal to detain a player!');
};