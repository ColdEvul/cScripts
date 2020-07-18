#include "..\script_component.hpp";
/*
 * Author: CPL.Brostrom.A
 * This adds a adda ction as well as a ACE interaction reGear selection. The script reapplyes the players start loadout.
 *
 * Arguments:
 * 0: Object <OBJECT>
 *
 * Example:
 * [this] call cScripts_fnc_addAcquisition;
 */

params [["_object", objNull, [objNull]]];

[formatText["Options added to %1.", _object], "Acquisition"] call FUNC(logInfo);

private _condition = {true};

[_object, QEGVAR(action,Acquisition),"Acquisition","\a3\ui_f\data\gui\Rsc\RscDisplayArsenal\headgear_ca.paa", ["ACE_MainActions"]] call cScripts_fnc_addAceCategory;

private _statementMagazine = {
    private _weapon = primaryWeapon player; 
    private _baseCfg = (configFile >> "cfgWeapons"); 
    private _cfg = _baseCfg >> _weapon; 

    while {isClass (_cfg >> "LinkedItems") } do { 
        _parent = configName (inheritsFrom (_cfg)); 
        _cfg = _baseCfg >> _parent; 
    }; 
    private _baseWeapon = configName _cfg;

    private _magazine = "";
    private _displayName = "";
    private _icon = "";

    switch (_baseWeapon) do {
        case "rhs_weap_m4a1": {
            _magazine = "rhs_mag_30Rnd_556x45_M855A1_Stanag";
            _displayName = getText (configfile >> "CfgMagazines" >> _magazine >> "displayName");
            _icon = getText (configfile >> "CfgMagazines" >> _magazine >> "picture");

            player addMagazines [_magazine, 1];
            [[format ["One %1 added!", _displayName]],[_icon]] call CBA_fnc_notify;
        };
        default { 
            "You gain nothing!" call CBA_fnc_notify;
        };
    };
};

private _iconMagazine = "\a3\ui_f\data\gui\Rsc\RscDisplayArsenal\cargomag_ca.paa";
private _actionMagazine = [QEGVAR(action,requestMagazine), "Request extra magazine", _iconMagazine, _statementMagazine, {true}] call ace_interact_menu_fnc_createAction;
[_object, 0, ["ACE_MainActions", QEGVAR(action,Acquisition)], _actionMagazine] call ace_interact_menu_fnc_addActionToObject;
