/*/
File: fn_clientInteractSlatArmor.sqf
Author:

	Quiksilver
	
Last Modified:

	14/04/2018 A3 1.82 by Quiksilver
	
Description:

	-
_____________________________________________________________/*/

params ['_actionTarget','_actionCaller','_actionID','_actionArguments'];
_actionArguments params ['_vehicle','_newPhase','_animationSources'];
if ((!(player getUnitTrait 'engineer')) && (!(['_crew_',(typeOf player),FALSE] call (missionNamespace getVariable 'QS_fnc_inString')))) exitWith {
	50 cutText ['Only engineers and crewmen can mount or remove slat armor','PLAIN DOWN',0.5];
};
if (isEngineOn _vehicle) exitWith {
	50 cutText ['Engine must be off','PLAIN DOWN',0.5];
};
if (!((damage _vehicle) isEqualTo 0)) exitWith {
	50 cutText ['Vehicle must be undamaged to modify slat armor','PLAIN DOWN',0.5];
};
private _exitCamo = FALSE;
_camonetArmor_anims = ['showcamonethull','showcamonetcannon','showcamonetcannon1','showcamonetturret','showcamonetplates1','showcamonetplates2'];
private _camonetArmor_vAnims = _vehicle getVariable ['QS_vehicle_camonetAnims',[]];
if (_camonetArmor_vAnims isEqualTo []) then {
	private _array = [];
	private _camonetAnimationSources = configFile >> 'CfgVehicles' >> (typeOf _vehicle) >> 'animationSources';
	private _animationSource = configNull;
	private _i = 0;
	for '_i' from 0 to ((count _camonetAnimationSources) - 1) step 1 do {
		_animationSource = _camonetAnimationSources select _i;
		if (((toLower (configName _animationSource)) in _camonetArmor_anims) || {(['showcamo',(configName _animationSource),FALSE] call (missionNamespace getVariable 'QS_fnc_inString'))}) then {
			0 = _array pushBack (toLower (configName _animationSource));
		};
	};
	{
		if (_x isEqualType '') then {
			if (!((toLower _x) in _array)) then {
				if (((toLower _x) in _camonetArmor_anims) || {(['showcamo',_x,FALSE] call (missionNamespace getVariable 'QS_fnc_inString'))}) then {
					_array pushBack (toLower _x);
				};
			};
		};
	} forEach (getArray (configFile >> 'CfgVehicles' >> (typeOf _vehicle) >> 'animationList'));
	_vehicle setVariable ['QS_vehicle_camonetAnims',_array,FALSE];
	_camonetArmor_vAnims = _array;
};
if (!(_camonetArmor_vAnims isEqualTo [])) then {
	if (!((_camonetArmor_vAnims findIf {((_vehicle animationSourcePhase _x) isEqualTo 1)}) isEqualTo -1)) then {
		_exitCamo = TRUE;
	};
};
if (_exitCamo) exitWith {
	50 cutText ['Remove camo net to mount slat armor','PLAIN DOWN',0.5];
};
_onCancelled = {
	params ['_v','_position'];
	private _c = FALSE;
	if (!alive player) then {_c = TRUE;};
	if ((_v distance2D _position) > 3) then {_c = TRUE;};
	if (!((vehicle player) isEqualTo _v)) then {_c = TRUE;};
	if (!(player isEqualTo player)) then {_c = TRUE;};
	if (!(isNull (attachedTo _v))) then {_c = TRUE;};
	if (!(isNull (isVehicleCargo _v))) then {_c = TRUE;};
	if (isEngineOn _v) then {_c = TRUE;};
	if (!alive _v) then {_c = TRUE;};
	if (_c) then {
		missionNamespace setVariable ['QS_repairing_vehicle',FALSE,FALSE];
	};
	_c;
};
_onCompleted = {
	params ['_actionTarget','_actionCaller','_actionID','_actionArguments'];
	_actionArguments params ['_vehicle','_newPhase','_animationSources'];
	private _exitCamo = FALSE;
	_camonetArmor_anims = ['showcamonethull','showcamonetcannon','showcamonetcannon1','showcamonetturret','showcamonetplates1','showcamonetplates2'];
	private _camonetArmor_vAnims = _vehicle getVariable ['QS_vehicle_camonetAnims',[]];
	if (_camonetArmor_vAnims isEqualTo []) then {
		private _array = [];
		private _camonetAnimationSources = configFile >> 'CfgVehicles' >> (typeOf _vehicle) >> 'animationSources';
		private _animationSource = configNull;
		private _i = 0;
		for '_i' from 0 to ((count _camonetAnimationSources) - 1) step 1 do {
			_animationSource = _camonetAnimationSources select _i;
			if (((toLower (configName _animationSource)) in _camonetArmor_anims) || {(['showcamo',(configName _animationSource),FALSE] call (missionNamespace getVariable 'QS_fnc_inString'))}) then {
				0 = _array pushBack (toLower (configName _animationSource));
			};
		};
		{
			if (_x isEqualType '') then {
				if (!((toLower _x) in _array)) then {
					if (((toLower _x) in _camonetArmor_anims) || {(['showcamo',_x,FALSE] call (missionNamespace getVariable 'QS_fnc_inString'))}) then {
						_array pushBack (toLower _x);
					};
				};
			};
		} forEach (getArray (configFile >> 'CfgVehicles' >> (typeOf _vehicle) >> 'animationList'));
		_vehicle setVariable ['QS_vehicle_camonetAnims',_array,FALSE];
		_camonetArmor_vAnims = _array;
	};
	if (!(_camonetArmor_vAnims isEqualTo [])) then {
		if (!((_camonetArmor_vAnims findIf {((_vehicle animationSourcePhase _x) isEqualTo 1)}) isEqualTo -1)) then {
			_exitCamo = TRUE;
		};
	};
	if (_exitCamo) exitWith {
		50 cutText ['Remove camo net to mount slat armor','PLAIN DOWN',0.5];
	};
	{
		_vehicle animateSource [_x,_newPhase,TRUE];
	} forEach _animationSources;
	playSound3D [
		'A3\Sounds_F\sfx\ui\vehicles\vehicle_repair.wss',
		_vehicle,
		FALSE,
		(getPosASL _vehicle),
		2,
		1,
		25
	];
	if (_newPhase isEqualTo 1) then {
		_mass = _vehicle getVariable ['QS_vehicle_massArmor',-1];
		if (_mass isEqualTo -1) then {
			_vehicle setVariable ['QS_vehicle_massArmor',[(getMass _vehicle),((getMass _vehicle) * 1.375)],TRUE];
		};
		if (local _vehicle) then {
			_vehicle setMass ((_vehicle getVariable 'QS_vehicle_massArmor') select 1);
		} else {
			['setMass',_vehicle,((_vehicle getVariable 'QS_vehicle_massArmor') select 1)] remoteExec ['QS_fnc_remoteExecCmd',_vehicle,FALSE];
		};
		if (vehicleCargoEnabled _vehicle) then {
			if (local _vehicle) then {
				_vehicle enableVehicleCargo FALSE;
			} else {
				['enableVehicleCargo',_vehicle,FALSE] remoteExec ['QS_fnc_remoteExecCmd',_vehicle,FALSE];
			};
		};
		50 cutText ['Slat armor mounted','PLAIN DOWN',0.333];
	} else {
		if (!((_vehicle getVariable ['QS_vehicle_massArmor',-1]) isEqualTo -1)) then {
			if (local _vehicle) then {
				_vehicle setMass ((_vehicle getVariable 'QS_vehicle_massArmor') select 0);
			} else {
				['setMass',_vehicle,((_vehicle getVariable 'QS_vehicle_massArmor') select 0)] remoteExec ['QS_fnc_remoteExecCmd',_vehicle,FALSE];
			};
			if (!(vehicleCargoEnabled _vehicle)) then {
				if (local _vehicle) then {
					_vehicle enableVehicleCargo TRUE;
				} else {
					['enableVehicleCargo',_vehicle,TRUE] remoteExec ['QS_fnc_remoteExecCmd',_vehicle,FALSE];
				};
			};
		};
		50 cutText ['Slat armor removed','PLAIN DOWN',0.333];
	};
	missionNamespace setVariable ['QS_repairing_vehicle',FALSE,FALSE];
};
missionNamespace setVariable ['QS_repairing_vehicle',TRUE,FALSE];
private _text = '';
if (_newPhase isEqualTo 1) then {
	_text = 'Mounting slat armor';
} else {
	_text = 'Removing slat armor';
};
private _duration = 5;
[
	_text,
	_duration,
	0,
	[[_vehicle],{FALSE}],
	[[_vehicle,(getPosATL _vehicle)],_onCancelled],
	[_this,_onCompleted],
	[[],{FALSE}]
] spawn (missionNamespace getVariable 'QS_fnc_clientProgressVisualization');