_newCiv = cursorTarget;
_isDeatined = _newCiv getVariable ["Detain",0];
if ( _isDeatined ) then {
player action ["Gear", _newCiv];
}else{
cutText [format["You must detain a player before searching them!"], "PLAIN"];
    systemChat ('You must detain a player before searching them!');
};