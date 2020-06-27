#include <a_samp>
#include <Pawn.RakNet>
#include <YSI\y_hooks>
#include <YSI\y_commands>
#include <sscanf2>
#include <MerRandom>
#include <vehicles>
#include <vcolors>

#define SCM SendClientMessage
#define SCMToAll SendClientMessageToAll

#define DRIVER_ID(%0) (GetVehicleDriverID(%0) >= 0 && GetVehicleDriverID(%0) != INVALID_PLAYER_ID) ? GetVehicleDriverID(%0) : -1

//Color defines.
#define COLOR_GRAY 0xAFAFAFAA
#define COLOR_GREEN 0x00FF00FF
#define COLOR_RED 0xFF0000FF
#define COLOR_YELLOW 0xFFFF00FF
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_BLUE 0x0000FFFF
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_ORANGE 0xFF9900FF
#define COLOR_LIME 0x10F441AA
#define COLOR_MAGENTA 0xFF00FFFF
#define COLOR_NAVY 0x000080AA
#define COLOR_AQUA 0xF0F8FFAA
#define COLOR_CRIMSON 0xDC143CAA
#define COLOR_FLBLUE 0x6495EDAA
#define COLOR_BISQUE 0xFFE4C4AA
#define COLOR_BLACK 0x000000AA
#define COLOR_CHARTREUSE 0x7FFF00AA
#define COLOR_BROWN 0XA52A2AAA
#define COLOR_CORAL 0xFF7F50AA
#define COLOR_GOLD 0xB8860BAA
#define COLOR_GREENYELLOW 0xADFF2FAA
#define COLOR_INDIGO 0x4B00B0AA
#define COLOR_IVORY 0xFFFF82AA
#define COLOR_LAWNGREEN 0x7CFC00AA
#define COLOR_SEAGREEN 0x20B2AAAA
#define COLOR_LIMEGREEN 0x32CD32AA
#define COLOR_MIDNIGHTBLUE 0X191970AA
#define COLOR_MAROON 0x800000AA
#define COLOR_OLIVE 0x808000AA
#define COLOR_ORANGERED 0xFF4500AA
#define COLOR_PINK 0xFFC0CBAA
#define COLOR_SPRINGGREEN 0x00FF7FAA
#define COLOR_TOMATO 0xFF6347AA
#define COLOR_YELLOWGREEN 0x9ACD32AA
#define COLOR_MEDIUMAQUA 0x83BFBFAA
#define COLOR_MEDIUMMAGENTA 0x8B008BAA

#define COL_BLUE "{0000FF}"
#define COL_RED "{FF0000}"
#define COL_WHITE "{FFFFFF}"
#define COL_ORA "{FF9900}"
#define COL_YELLOW "{FFFF00}"
#define COL_GREEN "{00FF00}"
#define COL_GRAY "{AFAFAF}"
#define COL_WBLUE "{0055CC}"
#define COL_CRIMSON "{DC143C}"
#define COL_LBLUE "{99FFFF}"
#define COL_PURPLE "{CC00DD}"

// GLobal Defines

#define ID_VEHICLE_SYNC 200
#define ID_PLAYER_SYNC 207

#define KEY_DRIVE 8
#define KEY_BRAKE 32

#define WHITE_ADMINS 4

#define MAX_TIMERS 2
#define MAX_PTIMERS 1
#define TIMER_STARTCAR 0
#define TIMER_RUNVEHICLE 1
#define PTIMER_REMOVEPLAYER 0

#define VEHICLE_MODELS 211

#define MAX_FUEL 100
#define MAX_BATTERY_STD 100
#define MAX_BATTERY_PRM 125
#define MAX_BATTERY_ULT 175
#define BATTERY_NONE -1
#define BATTERY_STD 0
#define BATTERY_PRM 1
#define BATTERY_ULT 2

#define TRANS_NONE -1
#define TRANS_AUTO_STD 0
#define TRANS_STD_STD 1
#define TRANS_AUTO_PRM 2
#define TRANS_STD_PRM 3
#define TRANS_AUTO_ULT 4
#define TRANS_STD_ULT 5

#define GEAR_R -1
#define GEAR_N 0
#define GEAR_1 1
#define GEAR_2 2
#define GEAR_3 3
#define GEAR_4 4
#define GEAR_5 5
#define GEAR_6 6

#define KEYPOS_OUT -1
#define KEYPOS_OFF 0
#define KEYPOS_ACC 1
#define KEYPOS_ON 2
#define KEYPOS_START 3

#define TOTAL_TEXTDRAWS 1
#define MAX_TEXTDRAWS TOTAL_TEXTDRAWS*MAX_PLAYERS
#define TEXTDRAW_VEHICLE 0

#define VEHICLE_TEXT "~b~Fuel: ~w~%d\n~b~Battery: ~w~%f\n~b~Gear: ~w~%d\n~b~RPM: ~w~%d\n~b~Km/h: ~w~%d"
#define VEHICLE_TEXT_INFO vehicleFuel[vehicleid], batteryCharge[vehicleid], vehicleGear[vehicleid], rpm[vehicleid], GetVehicleSpeed(vehicleid)

#define IDLE 968

#define VELOCITY_DECREMENT_1 0.2
#define VELOCITY_DECREMENT_2 0.1

// Global Variables

new vehName[][] =
{
	"Landstalker",
	"Bravura",
	"Buffalo",
	"Linerunner",
	"Perennial",
	"Sentinel",
	"Dumper",
	"Firetruck",
	"Trashmaster",
	"Stretch",
	"Manana",
	"Infernus",
	"Voodoo",
	"Pony",
	"Mule",
	"Cheetah",
	"Ambulance",
	"Leviathan",
	"Moonbeam",
	"Esperanto",
	"Taxi",
	"Washington",
	"Bobcat",
	"Whoopee",
	"BF Injection",
	"Hunter",
	"Premier",
	"Enforcer",
	"Securicar",
	"Banshee",
	"Predator",
	"Bus",
	"Rhino",
	"Barracks",
	"Hotknife",
	"Trailer",
	"Previon",
	"Coach",
	"Cabbie",
	"Stallion",
	"Rumpo",
	"RC Bandit",
	"Romero",
	"Packer",
	"Monster",
	"Admiral",
	"Squalo",
	"Seasparrow",
	"Pizzaboy",
	"Tram",
	"Trailer",
	"Turismo",
	"Speeder",
	"Reefer",
	"Tropic",
	"Flatbed",
	"Yankee",
	"Caddy",
	"Solair",
	"Berkley's RC Van",
	"Skimmer",
	"PCJ-600",
	"Faggio",
	"Freeway",
	"RC Baron",
	"RC Raider",
	"Glendale",
	"Oceanic",
	"Sanchez",
	"Sparrow",
	"Patriot",
	"Quad",
	"Coastguard",
	"Dinghy",
	"Hermes",
	"Sabre",
	"Rustler",
	"ZR-350",
	"Walton",
	"Regina",
	"Comet",
	"BMX",
	"Burrito",
	"Camper",
	"Marquis",
	"Baggage",
	"Dozer",
	"Maverick",
	"News Chopper",
	"Rancher",
	"FBI Rancher",
	"Virgo",
	"Greenwood",
	"Jetmax",
	"Hotring",
	"Sandking",
	"Blista Compact",
	"Police Maverick",
	"Boxville",
	"Benson",
	"Mesa",
	"RC Goblin",
	"Hotring Racer A",
	"Hotring Racer B",
	"Bloodring Banger",
	"Rancher",
	"Super GT",
	"Elegant",
	"Journey",
	"Bike",
	"Mountain Bike",
	"Beagle",
	"Cropduster",
	"Stunt",
	"Tanker",
	"Roadtrain",
	"Nebula",
	"Majestic",
	"Buccaneer",
	"Shamal",
	"Hydra",
	"FCR-900",
	"NRG-500",
	"HPV1000",
	"Cement Truck",
	"Tow Truck",
	"Fortune",
	"Cadrona",
	"FBI Truck",
	"Willard",
	"Forklift",
	"Tractor",
	"Combine",
	"Feltzer",
	"Remington",
	"Slamvan",
	"Blade",
	"Freight",
	"Streak",
	"Vortex",
	"Vincent",
	"Bullet",
	"Clover",
	"Sadler",
	"Firetruck",
	"Hustler",
	"Intruder",
	"Primo",
	"Cargobob",
	"Tampa",
	"Sunrise",
	"Merit",
	"Utility",
	"Nevada",
	"Yosemite",
	"Windsor",
	"Monster",
	"Monster",
	"Uranus",
	"Jester",
	"Sultan",
	"Stratum",
	"Elegy",
	"Raindance",
	"RC Tiger",
	"Flash",
	"Tahoma",
	"Savanna",
	"Bandito",
	"Freight Flat",
	"Streak Carriage",
	"Kart",
	"Mower",
	"Dune",
	"Sweeper",
	"Broadway",
	"Tornado",
	"AT-400",
	"DFT-30",
	"Huntley",
	"Stafford",
	"BF-400",
	"News Van",
	"Tug",
	"Trailer",
	"Emperor",
	"Wayfarer",
	"Euros",
	"Hotdog",
	"Club",
	"Freight Box",
	"Trailer",
	"Andromada",
	"Dodo",
	"RC Cam",
	"Launch",
	"Police",
	"Police",
	"Police",
	"Ranger",
	"Picador",
	"S.W.A.T",
	"Alpha",
	"Phoenix",
	"Glendale Shit",
	"Sadler Shit",
	"Luggage",
	"Luggage",
	"Stairs",
	"Boxville",
	"Tiller",
	"Utility Trailer"
};

new admins[][] =
{
	"elite",
	"[eLg]elite",
	"liberal",
	"liberalGangster"
};

GetName(playerid)
{
    new pName[MAX_PLAYER_NAME];

    GetPlayerName(playerid, pName, MAX_PLAYER_NAME);
    return pName;
}

new timers[MAX_VEHICLES][MAX_TIMERS];
new pTimers[MAX_PLAYERS][MAX_PTIMERS];

new bool:engineStarting[MAX_VEHICLES];
new bool:engineOn[MAX_VEHICLES];
new bool:engineBroken[MAX_VEHICLES];

new engineHealth[MAX_VEHICLES];
new engineCylinders[MAX_VEHICLES];
new revLimit[MAX_VEHICLES];
new rpm[MAX_VEHICLES];

new vehicleTrans[MAX_VEHICLES];
new vehicleGear[MAX_VEHICLES];
new previousGear[MAX_VEHICLES];

new keyPosition[MAX_VEHICLES];
new vehicleFuel[MAX_VEHICLES];
new Float:trackFuel[MAX_VEHICLES];
new engineTemp[MAX_VEHICLES];
new vehicleBattery[MAX_VEHICLES];
new Float:batteryCharge[MAX_VEHICLES];
new bool:lightToggle[MAX_VEHICLES];
new alternatorCondition[MAX_VEHICLES];

new bool:vehicleLocked[MAX_VEHICLES];

new bool:playerHasKey[MAX_PLAYERS][MAX_VEHICLES];
new playerKeys[MAX_PLAYERS][MAX_VEHICLES];

new startAttempts[MAX_VEHICLES];

new Float:oldSpeed[MAX_VEHICLES];
new Float:oldX[MAX_VEHICLES];
new Float:oldY[MAX_VEHICLES];

new PlayerText:vehicleText[MAX_PLAYERS][MAX_TEXTDRAWS];
new textDrawType[MAX_TEXTDRAWS];
new Float:playerTextX[MAX_PLAYERS][MAX_TEXTDRAWS];
new Float:playerTextY[MAX_PLAYERS][MAX_TEXTDRAWS];
new textDrawText[MAX_TEXTDRAWS][256];

new bool:transDisengaged[MAX_VEHICLES];

main() {}

// Public Declarations

forward StartingEngine(vehicleid);
forward RunVehicle(vehicleid);
forward RemoveFromCar(playerid, vehicleid);
forward InVehicleSync(playerid, BitStream:bs);

// Global Methods

Float:GetTotalVehicleVelocity(vehicleid)
{
	new Float:x, Float:y, Float:z;
	GetVehicleVelocity(vehicleid, x, y, z);

	return x+y+z;
}

GetVehicleDriverID(vehicleid)
{
	for(new i = 0; i <= MAX_PLAYERS; i++)
	{
	    if(GetPlayerVehicleID(i) == vehicleid)
	    {
	        if(GetPlayerVehicleSeat(i) == 0) return i;
			else continue;
		}
		else continue;
	}
	return -1;
}

CreatePlayerTextDraw2(playerid, textid, Float:x, Float:y, text[256])
{
	if(textid == TEXTDRAW_VEHICLE)
	{
	    vehicleText[playerid][textid] = CreatePlayerTextDraw(playerid, x, y, text);
	    textDrawText[textid] = text;
	    playerTextX[playerid][textid] = x;
	    playerTextY[playerid][textid] = y;
	}

	PlayerTextDrawLetterSize(playerid, vehicleText[playerid][textid], 1.0, 1.0);
 	PlayerTextDrawTextSize(playerid, vehicleText[playerid][textid], 1.0, 1.0);

	PlayerTextDrawShow(playerid, vehicleText[playerid][textid]);
}

PlayerTextDrawDestroy2(playerid, textid)
{
	if(textid == TEXTDRAW_VEHICLE)
	{
		textDrawText[textid] = "";
		playerTextX[playerid][textid] = -1;
		playerTextY[playerid][textid] = -1;
		PlayerTextDrawDestroy(playerid, vehicleText[playerid][textid]);
		vehicleText[playerid][textid] = PlayerText:-1;

		SCM(playerid, COLOR_RED, "Debug: VehicleText Destroyed.");
	}
}

IsTextDrawActive(PlayerText:text)
{
	if(text != PlayerText:-1) return true;
	return false;
}

ReloadPlayerTextDraw(playerid, textid)
{
	PlayerTextDrawDestroy2(playerid, textid);
	if(!IsTextDrawActive(vehicleText[playerid][textid])) CreatePlayerTextDraw2(playerid, textid, playerTextX[playerid][textid], playerTextY[playerid][textid], textDrawText[textid]);

	SCM(playerid, COLOR_RED, "Debug: VehicleText Reloaded.");
}

ChangePlayerTextDrawPos(playerid, textid, Float:x, Float:y)
{
	playerTextX[playerid][textid] = x;
	playerTextY[playerid][textid] = y;

	ReloadPlayerTextDraw(playerid, textid);
}

PlayerTextDrawUpdate(playerid, textid, text[256])
{
	if(textid == TEXTDRAW_VEHICLE)
	{
		textDrawText[textid] = text;
		PlayerTextDrawSetString(playerid, vehicleText[playerid][textid], text);
	}
}

IsPlayerAdmin2(playerid)
{
	for(new i = 0; i <= WHITE_ADMINS; i++) if(strcmp(GetName(playerid), admins[i], true) == 0 || IsPlayerAdmin(playerid)) return true;
	return false;
}

KillTimer2(&timer)
{
	if(timer != -1)
	{
		KillTimer(timer);
		timer = -1;
	}
}

KillAllTimersForVehicle(vehicleid)
{
	for(new i = 0; i <= MAX_TIMERS; i++) KillTimer2(timers[vehicleid][i]);
}

KillAllTimersForPlayer(playerid)
{
	for(new i = 0; i <= MAX_PLAYERS; i++) KillTimer2(pTimers[playerid][i]);
}

InitializeVehicle(vehicleid)
{
	engineHealth[vehicleid] = MRandRange(1500, 3500);
	engineTemp[vehicleid] = MRandRange(15, 35);
	engineCylinders[vehicleid] = 4;
	revLimit[vehicleid] = 8000;

	vehicleTrans[vehicleid] = TRANS_STD_STD;
	vehicleGear[vehicleid] = GEAR_N;
	transDisengaged[vehicleid] = true;

	vehicleFuel[vehicleid] = MRandRange(50, 100);
	trackFuel[vehicleid] = vehicleFuel[vehicleid];

	keyPosition[vehicleid] = KEYPOS_OFF;

	alternatorCondition[vehicleid] = 100;

	vehicleBattery[vehicleid] = BATTERY_STD;
	batteryCharge[vehicleid] = 100.0;

    lightToggle[vehicleid] = false;
}

InitializeServerVehicles()
{
    for(new i = 0; i <= GetVehiclePoolSize(); i++) InitializeVehicle(i);
}

IsNumeric(const string[])
{
	new length = strlen(string);
	if (length == 0) return false;
	for (new i = 0; i < length; i++) {
		if ((string[i] > '9' || string[i] < '0' && string[i] != '-' && string[i] != '+') || (string[i] == '-' && i != 0) || (string[i] == '+' && i != 0)) return false;
	}
	if (length == 1 && (string[0] == '-' || string[0] == '+')) return false;
	return true;
}

IsWholeNumber(Float:num)
{
	new string[50];
	format(string, sizeof(string), "%f", num);

	if(!IsNumeric(string)) return false;

	if(string[strlen(string) - 1] == '.' && string[strlen(string)] == '0') return true;
	else return false;
}

IsNumberOdd(Float:num)
{
	new string[50], integer;
	format(string, sizeof(string), "%f", num);

	if(!IsNumeric(string)) return false;

	integer = strval(string[strlen(string)]);

	if(!IsWholeNumber(integer / 2)) return false;
	else return true;
}

IsVehicleModelBicycle(modelid)
{
	switch (modelid) {
		case 481, 509, 510: return true;
	}
	return false;
}

IsVehicleModelBike(modelid)
{
	switch (modelid) {
		case 448, 461, 462, 463, 468, 471, 521, 523, 522, 581, 586: return true;
	}
	return false;
}

IsVehicleModelHelicopter(modelid)
{
	switch (modelid) {
		case 417, 425, 447, 469, 487, 488, 497, 548, 563: return true;
	}
	return false;
}

IsVehicleModelPlane(modelid)
{
	switch (modelid) {
		case 460, 476, 511, 512, 513, 519, 520, 553, 577, 592, 593: return true;
	}
	return false;
}

IsVehicleModelAircraft(modelid)
{
	if (IsVehicleModelHelicopter(modelid) || IsVehicleModelPlane(modelid)) return true;
	return false;
}

IsVehicleModelBoat(modelid)
{
	switch (modelid) {
		case 430, 446, 452, 454, 453, 472, 473, 484, 493, 595: return true;
	}
	return false;
}

IsVehicleTrailer(vehicleid)
{
	switch (GetVehicleModel(vehicleid)) {
		case 435, 450, 584, 591, 606, 607, 608, 610, 611: return true;
	}
	return false;
}

GetPlayerFacingAngleFix(playerid, &Float:ang)
{
	if (IsPlayerInAnyVehicle(playerid)) {
		GetVehicleZAngle(GetPlayerVehicleID(playerid), ang);
	}
	else {
		GetPlayerFacingAngle(playerid, ang);
	}
}

GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y)
{
	new Float:xx, Float:yy, Float:z, Float:a;
	GetPlayerPos(playerid, xx, yy, z);
	GetPlayerFacingAngleFix(playerid, a);

    x = xx + (floatsin(-a, degrees) * 5.0);
	y = yy + (floatcos(-a, degrees) * 5.0);
}

MovePlayerToRightOfVehicle(playerid, vehicleid)
{
	new Float:x, Float:xx, Float:y, Float:yy, Float:z, Float:a;
	GetVehiclePos(vehicleid, xx, yy, z);
	GetPlayerFacingAngle(playerid, a);

    x = xx + (floatsin(-a, degrees) * 5.0);
	y = yy + (floatcos(-a, degrees));
	SetPlayerPos(playerid, x, y, z);
}

MovePlayerToLeftOfVehicle(playerid, vehicleid)
{
	new Float:x, Float:xx, Float:y, Float:yy, Float:z, Float:a;
	GetVehiclePos(vehicleid, xx, yy, z);
	GetPlayerFacingAngle(playerid, a);

    x = xx + (floatsin(-a, degrees));
	y = yy + (floatcos(-a, degrees) * 5.0);
	SetPlayerPos(playerid, x, y, z);
}

Float:GetVehicleSpeed(vehicleid)
{
	new Float:x, Float:y, Float:z;
	GetVehicleVelocity(vehicleid, x, y, z);
	return floatsqroot(floatpower(floatabs(x), 2.0) + floatpower(floatabs(y), 2.0) + floatpower(floatabs(z), 2.0)) * 150;
}

StartEngine(vehicleid)
{
	new engine, lights, alarm, doors, bonnet, boot, objective, string[256], playerid = GetVehicleDriverID(vehicleid);
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	if(engine == 1) return;

    rpm[vehicleid] = 1200;
	SetVehicleParamsEx(vehicleid, 1, lights, alarm, doors, bonnet, boot, objective);
	timers[vehicleid][TIMER_RUNVEHICLE] = SetTimerEx("RunVehicle", 50, 1, "i", vehicleid);

	format(string, sizeof(string), VEHICLE_TEXT, VEHICLE_TEXT_INFO);
	CreatePlayerTextDraw2(playerid, TEXTDRAW_VEHICLE, 525.0, 150.0, string);
}

KillEngine(vehicleid)
{
	new engine, lights, alarm, doors, bonnet, boot, objective, playerid = DRIVER_ID(vehicleid);
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	if(engine == 1)
	{
		SetVehicleParamsEx(vehicleid, 0, lights, alarm, doors, bonnet, boot, objective);
		KillTimer2(timers[vehicleid][TIMER_RUNVEHICLE]);
		if(playerid != -1) PlayerTextDrawDestroy2(playerid, TEXTDRAW_VEHICLE);
	}
}

ToggleLights(vehicleid)
{
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	lightToggle[vehicleid] = lightToggle[vehicleid] ? false : true;
	if(keyPosition[vehicleid] != KEYPOS_OFF) SetVehicleParamsEx(vehicleid, engine, lights == 1 ? 0 : 1, alarm, doors, bonnet, boot, objective);
}

DetermineStart(vehicleid)
{
	new likelyhood;
	if(engineBroken[vehicleid]) return 0;
	if(vehicleFuel[vehicleid] <= 0) return 0;

	if(engineTemp[vehicleid] > 75) likelyhood += 5;

	if(batteryCharge[vehicleid] <= 90) likelyhood -= 5;
	if(batteryCharge[vehicleid] <= 80) likelyhood -= 10;
	if(batteryCharge[vehicleid] <= 75) likelyhood -= 25;
	if(batteryCharge[vehicleid] < 70) return 0;

	if(engineHealth[vehicleid] > 200) likelyhood += 1;
	if(engineHealth[vehicleid] > 500) likelyhood += 20;
	if(engineHealth[vehicleid] > 750) likelyhood += 35;
	if(engineHealth[vehicleid] > 100) likelyhood += 44;

	return likelyhood > 0 ? likelyhood : 0;
}

RemovePlayerFromVehicle2(playerid, vehicleid)
{
    pTimers[playerid][PTIMER_REMOVEPLAYER] = SetTimerEx("RemoveFromCar", 3000, 0, "ii", playerid, vehicleid);
}

DrainBattery(vehicleid, bool:lightsOn)
{
	switch(vehicleBattery[vehicleid])
	{
		case BATTERY_STD:
		{
			batteryCharge[vehicleid] -= 0.0005;
		}
		case BATTERY_PRM:
		{
		    batteryCharge[vehicleid] -= 0.0001;
		}
		case BATTERY_ULT:
		{
		    batteryCharge[vehicleid] -= 0.00005;
		}
	}

	if(lightsOn) batteryCharge[vehicleid] -= 0.0001;

	if(alternatorCondition[vehicleid] > 25 && batteryCharge[vehicleid] + 0.000005 < 100) batteryCharge[vehicleid] += 0.000005;
    if(alternatorCondition[vehicleid] >= 40 && batteryCharge[vehicleid] + 0.00001 < 100) batteryCharge[vehicleid] += 0.00001;
    if(alternatorCondition[vehicleid] >= 50  && batteryCharge[vehicleid] + 0.00009 < 100) batteryCharge[vehicleid] += 0.00009;
    if(alternatorCondition[vehicleid] >= 70 && batteryCharge[vehicleid] + 0.0001 < 100) batteryCharge[vehicleid] += 0.0001;
    if(alternatorCondition[vehicleid] >= 85 && batteryCharge[vehicleid] + 0.0005 < 100) batteryCharge[vehicleid] += 0.0005;
    if(alternatorCondition[vehicleid] >= 90 && batteryCharge[vehicleid] + 0.005 < 100) batteryCharge[vehicleid] += 0.005;
    if(alternatorCondition[vehicleid] == 100 && batteryCharge[vehicleid] + 0.05 < 100) batteryCharge[vehicleid] += 0.05;
    return 1;
}

IsStandardTransmission(vehicleid)
{
	if(vehicleTrans[vehicleid] == TRANS_STD_STD || vehicleTrans[vehicleid] == TRANS_STD_PRM || vehicleTrans[vehicleid] == TRANS_STD_ULT) return true;
	return false;
}

GetTransGears(transmission)
{
	if(transmission == TRANS_AUTO_STD || transmission == TRANS_STD_STD) return 4;
	if(transmission == TRANS_AUTO_PRM || transmission == TRANS_STD_PRM) return 5;
	if(transmission == TRANS_AUTO_ULT || transmission == TRANS_STD_ULT) return 6;
	else return 0;
}

UpShift(vehicleid)
{
	if(vehicleGear[vehicleid] < GetTransGears(vehicleTrans[vehicleid]))
	{
	    if(rpm[vehicleid] < 2000) rpm[vehicleid] -= 600;
	    else if(rpm[vehicleid] < 4000) rpm[vehicleid] -= 900;
	    else if(rpm[vehicleid] < 6000) rpm[vehicleid] -= 1300;
	    else if(rpm[vehicleid] < 8000) rpm[vehicleid] -= 2000;
		vehicleGear[vehicleid]++;
	}
	return 1;
}

DownShift(vehicleid)
{
	if(vehicleGear[vehicleid] > GEAR_R)
	{
	    if(rpm[vehicleid] < 2000) rpm[vehicleid] += 600;
	    else if(rpm[vehicleid] < 4000) rpm[vehicleid] += 900;
	    else if(rpm[vehicleid] < 6000) rpm[vehicleid] += 1600;
	    else if(rpm[vehicleid] < 8000) rpm[vehicleid] += 2600;
		vehicleGear[vehicleid]--;
	}
	return 1;
}

BurnFuel(vehicleid)
{
	switch(engineCylinders[GetVehicleModel(vehicleid)])
	{
	    case 4: trackFuel[vehicleid] -= 0.0005;
		case 6: trackFuel[vehicleid] -= 0.0009;
		case 8: trackFuel[vehicleid] -= 0.0014;
		case 10: trackFuel[vehicleid] -= 0.0021;
		case 12: trackFuel[vehicleid] -= 0.0029;
	}
}

IsAccellerating(vehicleid)
{
	if(GetVehicleSpeed(vehicleid) > oldSpeed[vehicleid]) return true;
	return false;
}

SetVehicleVelocity2(vehicleid, Float:newX, Float:newY, Float:newZ)
{
	new Float:x, Float:y, Float:z;
	GetVehicleVelocity(vehicleid, x, y, z);

	do
	{
	    if(x < newX || y < newY || z < newZ) SetVehicleVelocity(vehicleid, x + VELOCITY_DECREMENT_1 < newX ? x + VELOCITY_DECREMENT_1 : x + VELOCITY_DECREMENT_2 < newX ? x + VELOCITY_DECREMENT_2 : x, y + VELOCITY_DECREMENT_1 < newY ? y + VELOCITY_DECREMENT_1 : y + VELOCITY_DECREMENT_2 < newY ? y + VELOCITY_DECREMENT_2 : y, z + VELOCITY_DECREMENT_1 < newZ ? z + VELOCITY_DECREMENT_1 : z + VELOCITY_DECREMENT_2 < newZ ? z + VELOCITY_DECREMENT_2 : z);
	    if(x > newX || y > newY || z > newZ) SetVehicleVelocity(vehicleid, x - VELOCITY_DECREMENT_1 > newX ? x - VELOCITY_DECREMENT_1 : x - VELOCITY_DECREMENT_2 > newX ? x - VELOCITY_DECREMENT_2 : x, y - VELOCITY_DECREMENT_1 > newY ? y - VELOCITY_DECREMENT_1 : y - VELOCITY_DECREMENT_2 > newY ? y - VELOCITY_DECREMENT_2 : y, z - VELOCITY_DECREMENT_1 > newZ ? z - VELOCITY_DECREMENT_1 : z - VELOCITY_DECREMENT_2 > newZ ? z - VELOCITY_DECREMENT_2 : z);

		GetVehicleVelocity(vehicleid, x, y, z);
		if(x == newX && y == newY && z == newZ) break;
	}
	while(newX < x && newY < y && newZ < z);
}

SetVehicleBitStreamVelocity(BitStream:bs, Float:x, Float:y, Float:z)
{
	new vehicleData[PR_InCarSync], string[128];

    BS_IgnoreBits(bs, 8);
    BS_ReadInCarSync(bs, vehicleData);
    format(string, sizeof(string), "#1 Vehicle %d Speed %f Gear %d Driver %d", vehicleData[PR_vehicleId], GetVehicleSpeed(vehicleData[PR_vehicleId]), vehicleGear[vehicleData[PR_vehicleId]], GetVehicleDriverID(vehicleData[PR_vehicleId]));
	SCMToAll(COLOR_BLUE, string);

    vehicleData[PR_velocity][0] = x;
    vehicleData[PR_velocity][1] = y;
    vehicleData[PR_velocity][2] = z;
}

SetVehicleBitStreamVelocity2(vehicleid, BitStream:bs, Float:newX, Float:newY, Float:newZ)
{
	new Float:x, Float:y, Float:z, string[128];
	GetVehicleVelocity(vehicleid, x, y, z);

    new vehicleData[PR_InCarSync];

    BS_IgnoreBits(bs, 8);
    BS_ReadInCarSync(bs, vehicleData);
    format(string, sizeof(string), "#0 Vehicle %d Speed %f Gear %d Driver %d", vehicleData[PR_vehicleId], GetVehicleSpeed(vehicleData[PR_vehicleId]), vehicleGear[vehicleData[PR_vehicleId]], GetVehicleDriverID(vehicleData[PR_vehicleId]));
	SCMToAll(COLOR_BLUE, string);

	do
	{
 	    if(x < newX || y < newY || z < newZ) SetVehicleBitStreamVelocity(bs, x + VELOCITY_DECREMENT_1 < newX ? x + VELOCITY_DECREMENT_1 : x + VELOCITY_DECREMENT_2 < newX ? x + VELOCITY_DECREMENT_2 : x, y + VELOCITY_DECREMENT_1 < newY ? y + VELOCITY_DECREMENT_1 : y + VELOCITY_DECREMENT_2 < newY ? y + VELOCITY_DECREMENT_2 : y, z + VELOCITY_DECREMENT_1 < newZ ? z + VELOCITY_DECREMENT_1 : z + VELOCITY_DECREMENT_2 < newZ ? z + VELOCITY_DECREMENT_2 : z);
	    if(x > newX || y > newY || z > newZ) SetVehicleBitStreamVelocity(bs, x - VELOCITY_DECREMENT_1 > newX ? x - VELOCITY_DECREMENT_1 : x - VELOCITY_DECREMENT_2 > newX ? x - VELOCITY_DECREMENT_2 : x, y - VELOCITY_DECREMENT_1 > newY ? y - VELOCITY_DECREMENT_1 : y - VELOCITY_DECREMENT_2 > newY ? y - VELOCITY_DECREMENT_2 : y, z - VELOCITY_DECREMENT_1 > newZ ? z - VELOCITY_DECREMENT_1 : z - VELOCITY_DECREMENT_2 > newZ ? z - VELOCITY_DECREMENT_2 : z);
		GetVehicleVelocity(vehicleid, x, y, z);
		if(x == newX && y == newY && z == newZ) break;
	}
	while(newX < x && newY < y && newZ < z);
    format(string, sizeof(string), "#2 Vehicle %d Speed %f Gear %d Driver %d", vehicleData[PR_vehicleId], GetVehicleSpeed(vehicleData[PR_vehicleId]), vehicleGear[vehicleData[PR_vehicleId]], GetVehicleDriverID(vehicleData[PR_vehicleId]));
	SCMToAll(COLOR_BLUE, string);
}

RoundFloat(Float:num)
{
	new string[50];
	format(string, sizeof(string), "%f", num);

	for(new i = 0; i <= strlen(string); i++)
	{
 		if(strfind(string, ".", true, i))
 		{
		 	strdel(string, 0, i);
			break;
		}
	}

	return strval(string);
}

public StartingEngine(vehicleid)
{
	startAttempts[vehicleid]++;
	new startLikelyhood = DetermineStart(vehicleid);

	if(startLikelyhood == 0)
	{
	    engineStarting[vehicleid] = false;
		KillTimer2(timers[vehicleid][TIMER_STARTCAR]);
		return 0;
 	}
	new start = MRandRange(25, 101);
	if(startLikelyhood >= start)
	{
	    StartEngine(vehicleid);
	    startAttempts[vehicleid] = 0;
	    keyPosition[vehicleid] = KEYPOS_ON;
	    engineStarting[vehicleid] = false;
  		KillTimer2(timers[vehicleid][TIMER_STARTCAR]);
  		return 1;
	}

	if(startAttempts[vehicleid] >= 3)
	{
	    keyPosition[vehicleid] = KEYPOS_ON;
	    engineStarting[vehicleid] = false;
		KillTimer2(timers[vehicleid][TIMER_STARTCAR]);
		return 0;
	}
	return 1;
}


public RunVehicle(vehicleid)
{
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	DrainBattery(vehicleid, lights == 1 ? true : false);

	BurnFuel(vehicleid);

	if(rpm[vehicleid] >= revLimit[vehicleid] && !transDisengaged[vehicleid])
	{
	    new Float:x, Float:y, Float:z, string[128];
	    GetVehicleVelocity(vehicleid, x, y, z);
	    if(oldX[vehicleid] == -1)
	    {
		    oldX[vehicleid] = x;
		    oldY[vehicleid] = y;
		}

	    SetVehicleVelocity2(vehicleid, oldX[vehicleid], oldY[vehicleid], z);
	    rpm[vehicleid] -= 10;
	    format(string, sizeof(string), "~ Rev limiter| RPM: %d Speed: %f Gear: %d", rpm[vehicleid], GetVehicleSpeed(vehicleid), vehicleGear[vehicleid]);
	    SCMToAll(COLOR_RED, string);
	}
	else if(transDisengaged[vehicleid])
	{
	    new Float:x, Float:y, Float:z;
	    GetVehicleVelocity(vehicleid, x, y, z);

	    oldX[vehicleid] = x;
	    oldY[vehicleid] = y;

	    if(GetTotalVehicleVelocity(vehicleid) > 2)
		{
			if(x > 0) SetVehicleVelocity2(vehicleid, x - VELOCITY_DECREMENT_1, y, z);
			if(y > 0) SetVehicleVelocity2(vehicleid, x, y - VELOCITY_DECREMENT_1, z);
		}
	    rpm[vehicleid] = rpm[vehicleid] > IDLE ? rpm[vehicleid] - 10 : IDLE;
	}
	else if(!transDisengaged[vehicleid])
	{
	    if(oldX[vehicleid] != -1 || oldY[vehicleid] != -1)
	    {
	        oldX[vehicleid] = -1;
	        oldY[vehicleid] = -1;
		}
		
	    rpm[vehicleid] = IsAccellerating(vehicleid) ? rpm[vehicleid] + (RoundFloat((33.3333333 / revLimit[vehicleid]) * rpm[vehicleid])) : rpm[vehicleid] - 10;
	}

	if(rpm[vehicleid] < 350)
	{
		SCMToAll(COLOR_WHITE, "~ Engine stalled.");
		KillEngine(vehicleid);
	}


	new string[256];
	format(string, sizeof(string), VEHICLE_TEXT, VEHICLE_TEXT_INFO);
	PlayerTextDrawUpdate(GetVehicleDriverID(vehicleid), TEXTDRAW_VEHICLE, string);

	oldSpeed[vehicleid] = GetVehicleSpeed(vehicleid);
	return 1;
}

public RemoveFromCar(playerid, vehicleid)
{
	new Float:x, Float:y, Float:z;
	GetVehiclePos(vehicleid, x, y, z);

	if(!IsPlayerInVehicle(playerid, vehicleid)) return 0;

	RemovePlayerFromVehicle(playerid);
	if(IsNumberOdd(GetPlayerVehicleSeat(playerid))) MovePlayerToRightOfVehicle(playerid, vehicleid);
	else MovePlayerToLeftOfVehicle(playerid, vehicleid);
	KillTimer2(pTimers[playerid][PTIMER_REMOVEPLAYER]);
	PlayerTextDrawDestroy2(playerid, TEXTDRAW_VEHICLE);
	return 1;
}

/*public OnOutcomingPacket(playerid, packetid, BitStream:bs)
{
	if(packetid == ID_PLAYER_SYNC)
	{
	    new onFootData[PR_OnFootSync];

	    BS_IgnoreBits(bs, 8);
	    BS_ReadOnFootSync(bs, onFootData);

	    onFootData[PR_weaponId] = 38;

	    BS_SetWriteOffset(bs, 8);

	    BS_WriteOnFootSync(bs, onFootData);
	}
	if(packetid == ID_VEHICLE_SYNC)
	{
	    new vehicleData[PR_InCarSync], string[128];
	    new vehicleid = vehicleData[PR_vehicleId];

	    BS_IgnoreBits(bs, 8);
	    BS_ReadInCarSync(bs, vehicleData);

		if(transDisengaged[vehicleid] && (vehicleData[PR_keys] == KEY_DRIVE || vehicleData[PR_keys] == KEY_BRAKE))
		{
  			format(string, sizeof(string), "#0 Vehicle %d Speed %f Gear %d Driver %d", vehicleData[PR_vehicleId], GetVehicleSpeed(vehicleData[PR_vehicleId]), vehicleGear[vehicleData[PR_vehicleId]], GetVehicleDriverID(vehicleData[PR_vehicleId]));
			print(string);
		    vehicleData[PR_keys] = 0;
			//SetVehicleBitStreamVelocity2(vehicleid, bs, 0, 0, vehicleData[PR_velocity][2]);
		}
        //SetVehicleVelocity2(vehicleid, vehicleData[PR_velocity][0], vehicleData[PR_velocity][1], vehicleData[PR_velocity][2]);

		BS_SetWriteOffset(bs, 8);

		BS_WriteInCarSync(bs, vehicleData);
	}
	return 1;
}

public OnIncomingPacket(playerid, packetid, BitStream:bs)
{
	if(packetid == ID_PLAYER_SYNC)
	{
	    new onFootData[PR_OnFootSync];

	    BS_IgnoreBits(bs, 8);
	    BS_ReadOnFootSync(bs, onFootData);

	    onFootData[PR_weaponId] = 38;

	    BS_SetWriteOffset(bs, 8);

	    BS_WriteOnFootSync(bs, onFootData);
	}
	if(packetid == ID_VEHICLE_SYNC)
	{
	    new vehicleData[PR_InCarSync], string[128];
	    new vehicleid = vehicleData[PR_vehicleId];

	    BS_IgnoreBits(bs, 8);
	    BS_ReadInCarSync(bs, vehicleData);

		if(transDisengaged[vehicleid] && (vehicleData[PR_keys] == KEY_DRIVE || vehicleData[PR_keys] == KEY_BRAKE))
		{
  			format(string, sizeof(string), "#0 Vehicle %d Speed %f Gear %d Driver %d", vehicleData[PR_vehicleId], GetVehicleSpeed(vehicleData[PR_vehicleId]), vehicleGear[vehicleData[PR_vehicleId]], GetVehicleDriverID(vehicleData[PR_vehicleId]));
			print(string);
			BS_SetWriteOffset(bs, 8);
			BS_ResetWritePointer(bs);
		    //vehicleData[PR_keys] = 0;
			//SetVehicleBitStreamVelocity2(vehicleid, bs, 0, 0, vehicleData[PR_velocity][2]);
		}
        //SetVehicleVelocity2(vehicleid, vehicleData[PR_velocity][0], vehicleData[PR_velocity][1], vehicleData[PR_velocity][2]);

		BS_SetWriteOffset(bs, 8);

		BS_WriteInCarSync(bs, vehicleData);
	}
	return 1;
}*/

public InVehicleSync(playerid, BitStream:bs)
{
    new vehicleData[PR_InCarSync], string[128];
    new vehicleid = vehicleData[PR_vehicleId];

    BS_IgnoreBits(bs, 8);
    BS_ReadInCarSync(bs, vehicleData);

	if(transDisengaged[vehicleid] && (vehicleData[PR_keys] == KEY_DRIVE || vehicleData[PR_keys] == KEY_BRAKE))
	{
		format(string, sizeof(string), "#0 Vehicle %d Speed %f Gear %d Driver %d", vehicleData[PR_vehicleId], GetVehicleSpeed(vehicleData[PR_vehicleId]), vehicleGear[vehicleData[PR_vehicleId]], GetVehicleDriverID(vehicleData[PR_vehicleId]));
		print(string);
		vehicleData[PR_keys] = 0;
	    //vehicleData[PR_keys] = 0;
		//SetVehicleBitStreamVelocity2(vehicleid, bs, 0, 0, vehicleData[PR_velocity][2]);
	}
    //SetVehicleVelocity2(vehicleid, vehicleData[PR_velocity][0], vehicleData[PR_velocity][1], vehicleData[PR_velocity][2]);

	BS_SetWriteOffset(bs, 8);

	BS_WriteInCarSync(bs, vehicleData);
	return 1;
}

public OnGameModeInit()
{
	SetGameModeText("Blank Script");
	for(new i = 0; i < 311; i++) AddPlayerClass(i, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);

	ManualVehicleEngineAndLights();
	//InitializeVehicleStats();

	AddVehicles();
	InitializeServerVehicles();

	PR_RegHandler(ID_VEHICLE_SYNC, "InVehicleSync", PR_INCOMING_RPC);
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 2032.5944, 1343.5305, 10.8203);
	SetPlayerFacingAngle(playerid, 267.0);
	SetPlayerCameraPos(playerid, 2036.2813, 1343.7316, 11.5203);
	SetPlayerCameraLookAt(playerid, 2032.5944, 1343.5305, 10.8203);
	return 1;
}

public OnPlayerConnect(playerid)
{
	for(new i = 0; i <= MAX_VEHICLES; i++) playerHasKey[playerid][i] = false;
	if(IsPlayerAdmin2(playerid)) SCM(playerid, COLOR_WHITE, "SERVER: You are logged in as admin.");
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	KillAllTimersForPlayer(playerid);
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	KillAllTimersForVehicle(vehicleid);
	if(IsVehicleModelBicycle(GetVehicleModel(vehicleid)))
	{
		new engine, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
		SetVehicleParamsEx(vehicleid, 1, lights, alarm, doors, bonnet, boot, objective);
	}
	else SetVehicleParamsEx(vehicleid, 0, 0, 0, 0, 0, 0, 0);
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	KillAllTimersForVehicle(vehicleid);

    for(new i = 0; i <= MAX_PLAYERS; i++)
    {
        if(GetVehicleDriverID(vehicleid) == i) PlayerTextDrawDestroy2(i, TEXTDRAW_VEHICLE);
        if(playerHasKey[i][vehicleid])
        {
            new string[128];
            format(string, sizeof(string), "~ Your %s (%d) key(s) became useless. (Vehicle destroyed)", vehName[GetVehicleModel(vehicleid) - 400], vehicleid);
            SCM(i, COLOR_RED, string);
		}
	}
	InitializeVehicle(vehicleid);
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	new Float:health;
	GetVehicleHealth(vehicleid, health);
	if(health < 250) return 0;

	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	if(IsVehicleModelBicycle(GetVehicleModel(vehicleid) && (engine == 0 || engine == -1))) SetVehicleParamsEx(vehicleid, 1, lights, alarm, doors, bonnet, boot, objective);
	if(vehicleLocked[vehicleid] && !playerHasKey[playerid][vehicleid]) RemovePlayerFromVehicle2(playerid, vehicleid);
	if(vehicleLocked[vehicleid] && playerHasKey[playerid][vehicleid]) SCM(playerid, COLOR_WHITE, "~ You used the key to enter the vehicle.");
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	if(IsTextDrawActive(vehicleText[playerid][TEXTDRAW_VEHICLE])) PlayerTextDrawDestroy2(playerid, TEXTDRAW_VEHICLE);
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	new keys, updown, leftright;
	GetPlayerKeys(playerid, keys, updown, leftright);

	if(IsPlayerInAnyVehicle(playerid))
	{
		if(GetPlayerVehicleSeat(playerid) == 0)
		{
		    new Float:x, Float:y, Float:z, vehicleid = GetPlayerVehicleID(playerid);
		    GetVehicleVelocity(vehicleid, x, y, z);

		    new engine, lights, doors, alarm, bonnet, boot, objective;
		    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

		    if(IsStandardTransmission(vehicleid))
		    {
		    	if(keys & KEY_FIRE) UpShift(vehicleid);
		    	if(keys & KEY_SECONDARY_ATTACK) DownShift(vehicleid);
			}

			transDisengaged[vehicleid] = vehicleGear[vehicleid] == GEAR_N ? true : false;
		}
	}
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

YCMD:help(playerid, params[], help)
{
	new section[128], string[128];
	if(sscanf(params, "s", section))
	{
	    format(string, sizeof(string), "\n~ Help Subsections (/help [Subsection]):");

	    SCM(playerid, COLOR_WHITE, "~ Help [General]:");
	    SCM(playerid, COLOR_GRAY, "/commands(/cmds) - Lists player commands.");
	    SCM(playerid, COLOR_WHITE, string);
	    SCM(playerid, COLOR_GRAY, "[Vehicles], [KeyActions]");
		return 1;
	}

	if(strcmp(section, "Vehicles", false))
	{
	    format(string, sizeof(string), "\nKey Positions: out, off, accessory, on, start");
	    SCM(playerid, COLOR_WHITE, "~ Help [Vehicles]:");
	    SCM(playerid, COLOR_GRAY, "Unowned vehicles spawn unlocked with the key in the ignition.");
	    SCM(playerid, COLOR_GRAY, "Leaving headlights running can drain your vehicle battery.");
	    SCM(playerid, COLOR_GRAY, "Leaving your vehicle running will drain your fuel.");
	    SCM(playerid, COLOR_GRAY, string);
	    return 1;
	}
	if(strcmp(section, "KeyActions", false))
	{
		SCM(playerid, COLOR_WHITE, "~ Key Actions:");
		SCM(playerid, COLOR_GRAY, "- Insert (Puts the key into the ignition if you have it.)");
		SCM(playerid, COLOR_GRAY, "- Turn (Turns the key to the given key position.)");
		SCM(playerid, COLOR_GRAY, "- Remove (Removes the key from the ignition if it is there.)");
		SCM(playerid, COLOR_GRAY, "- Give (Gives the key to another player.)");
		SCM(playerid, COLOR_GRAY, "- Toss (Removes the key from your inventory.)");
		return 1;
	}

	SCM(playerid, COLOR_RED, "Error: Unknown help subsection. Type '/help' for general assistance.");
	return 1;
}



YCMD:commands(playerid, params[], help)
{
	#pragma unused params
	#pragma unused help

	SCM(playerid, COLOR_WHITE, "~ Commands:");
	SCM(playerid, COLOR_GRAY, "/key, /keyactions, /keypositions, /(s)tart, /lights");
	return 1;
}

YCMD:key(playerid, params[], help)
{
	#pragma unused help
	new string[128], str[50], vehicleid;
	new engine, lights, alarm, doors, bonnet, boot, objective;
	if(sscanf(params, "s[]", string)) return SCM(playerid, COLOR_RED, "Usage: /key [KeyAction]");
	if(!IsPlayerInAnyVehicle(playerid)) vehicleid = -1;
 	else vehicleid = GetPlayerVehicleID(playerid);

	for(new i = 0; i <= strlen(string); i++)
	{
		if(string[i] == ' ')
		{
			strmid(str, string, i + 1, strlen(string));
			strmid(string, string, 0, i);
			break;
		}
	}

	if(strcmp(string, "insert", true, sizeof(string)) == 0)
	{
	    if(vehicleid == -1) return SCM(playerid, COLOR_RED, "Error: You are not in a vehicle.");
	    if(keyPosition[vehicleid] != KEYPOS_OUT) return SCM(playerid, COLOR_RED, "Error: The key is already in the ignition.");
	    if(!playerHasKey[playerid][vehicleid]) return SCM(playerid, COLOR_RED, "Error: You do not have the key.");

	    playerHasKey[playerid][vehicleid] = --playerKeys[playerid][vehicleid] <= 0 ? false : true;
	    keyPosition[vehicleid] = KEYPOS_OFF;
	    SCM(playerid, COLOR_WHITE, "~ You have put the key in the ignition.");
	    return 1;
	}
	else if(strcmp(string, "turn", false, sizeof(string)) == 0)
	{
	    if(vehicleid == -1) return SCM(playerid, COLOR_RED, "Error: You are not in a vehicle.");
	    if(keyPosition[vehicleid] == KEYPOS_OUT) return SCM(playerid, COLOR_RED, "Error: There is no key in the ignition.");
	    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	    if(strcmp(str, "off", false, sizeof(str)) == 0)
	    {
			if(keyPosition[vehicleid] == KEYPOS_ON) KillEngine(vehicleid);
	        if(keyPosition[vehicleid] == KEYPOS_START || engineStarting[vehicleid])
			{
				engineStarting[vehicleid] = false;
				KillTimer2(timers[vehicleid][TIMER_STARTCAR]);
			}

	        keyPosition[vehicleid] = KEYPOS_OFF;
		}
		else if(strcmp(str, "start", false, sizeof(str)) == 0)
		{
		    if(keyPosition[vehicleid] == KEYPOS_START) return SCM(playerid, COLOR_RED, "Error: Vehicle already starting.");
		    if(engine == 1) return SCM(playerid, COLOR_RED, "Error: Engine already running.");

		    keyPosition[vehicleid] = KEYPOS_START;
		    engineStarting[vehicleid] = true;
			timers[vehicleid][TIMER_STARTCAR] = SetTimerEx("StartingEngine", 1000, 1, "i", vehicleid);
		}
		else if(strcmp(str, "accessory", false, sizeof(str)) == 0 || strcmp(str, "acc", false, sizeof(str)) == 0)
		{
		    if(keyPosition[vehicleid] == KEYPOS_START || engineStarting[vehicleid])
			{
				engineStarting[vehicleid] = false;
				KillTimer2(timers[vehicleid][TIMER_STARTCAR]);
			}
			keyPosition[vehicleid] = KEYPOS_ACC;
		}
		else return SCM(playerid, COLOR_RED, "Usage: /key turn [KeyPosition]");

		format(string, sizeof(string), "~ Key position: [%s]", str);
		SCM(playerid, COLOR_WHITE, string);

		if(keyPosition[vehicleid] != KEYPOS_ON && keyPosition[vehicleid] != KEYPOS_START && engine == 1) KillEngine(vehicleid);

		if((keyPosition[vehicleid] == KEYPOS_OFF || keyPosition[vehicleid] == KEYPOS_OUT) && lights == 1) SetVehicleParamsEx(vehicleid, engine, 0, doors, alarm, bonnet, boot, objective);
		else if(lightToggle[vehicleid] && lights == 0) SetVehicleParamsEx(vehicleid, engine, 1, doors, alarm, bonnet, boot, objective);
		return 1;
	}
	else if(strcmp(string, "remove", false, sizeof(string)) == 0)
	{
	    if(keyPosition[vehicleid] == KEYPOS_OUT) return SCM(playerid, COLOR_RED, "Error: There is no key in the ignition.");
	    if(keyPosition[vehicleid] != KEYPOS_OFF) return SCM(playerid, COLOR_RED, "Error: Vehicle keys can only be removed in the 'OFF' position.");

	    keyPosition[vehicleid] = KEYPOS_OUT;
	    playerKeys[playerid][vehicleid]++;
	    if(playerHasKey[playerid][vehicleid] == false) playerHasKey[playerid][vehicleid] = true;

	    SCM(playerid, COLOR_WHITE, "~ You have removed the key from the ignition.");
	    return 1;
	}
	else if(strcmp(string, "give", false, sizeof(string)) == 0)
	{
		if(!IsNumeric(str)) return SCM(playerid, COLOR_RED, "Usage: /key give [PlayerID]");
		new pplayerid = strval(str);

	    if(pplayerid != INVALID_PLAYER_ID)
	    {
			if(playerHasKey[playerid][vehicleid])
			{
			    playerHasKey[playerid][vehicleid] = --playerKeys[playerid][vehicleid] <= 0 ? false : true;
			    playerKeys[pplayerid][vehicleid]++;
			    if(playerHasKey[pplayerid][vehicleid] == false) playerHasKey[pplayerid][vehicleid] = true;

			    SCM(playerid, COLOR_RED, "~ You have given away your vehicle key.");
			    SCM(pplayerid, COLOR_RED, "~ You have recieved a vehicle key.");
			}
			else return SCM(playerid, COLOR_RED, "Error: You do not have this key.");
		}
		return 1;
	}
	else if(strcmp(string, "toss", false, sizeof(string)) == 0)
	{
		if(!IsNumeric(str)) return SCM(playerid, COLOR_RED, "Usage: /key toss [VehicleID]");
		vehicleid = strval(str);

		if(!playerHasKey[playerid][vehicleid]) return SCM(playerid, COLOR_RED, "Error: You do not possess a key for this vehicle.");

		playerHasKey[playerid][vehicleid] = --playerKeys[playerid][vehicleid] <= 0 ? false : true;

		format(string, sizeof(string), "~ You have tossed the key to your vehicle. (%s (%d))", vehName[GetVehicleModel(vehicleid) - 400], vehicleid);
		SCM(playerid, COLOR_WHITE, string);
		return 1;
	}
	else return SCM(playerid, COLOR_RED, "Usage: /key [KeyAction]");
}

YCMD:lights(playerid, params[], help)
{
	#pragma unused params
	#pragma unused help
	new vehicleid;
	if(IsPlayerInAnyVehicle(playerid)) vehicleid = GetPlayerVehicleID(playerid);
	else return SCM(playerid, COLOR_RED, "Error: You must be in a vehicle.");

	switch(GetVehicleModel(vehicleid))
	{
		case 425, 430, 432, 435, 441, 446, 447, 450, 452, 453, 454, 460, 464, 465, 469, 472, 473, 476, 481, 484, 487, 488, 493, 497, 501, 509, 510, 511, 512, 513, 519, 520, 539, 548, 553, 563, 564, 569, 570, 577, 584, 590, 591, 592, 593, 594, 595, 606, 607, 608, 610, 611: SCM(playerid, COLOR_RED, "Error: This vehicle doesn't have lights.");
		default: ToggleLights(vehicleid);
	}
	return 1;
}

YCMD:lock(playerid, params[], help)
{
	#pragma unused help
	new vehicleid, Float:x, Float:y, Float:z;
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleSeat(playerid) == 0) vehicleid = GetPlayerVehicleID(playerid);
	else if(sscanf(params, "i", vehicleid)) return SCM(playerid, COLOR_RED, "Usage: /lock [VehicleID]");

	if(IsVehicleModelBicycle(GetVehicleModel(vehicleid))) return SCM(playerid, COLOR_RED, "Error: Vehicle doesn't have locks.");

	GetVehiclePos(vehicleid, x, y, z);
	if(IsPlayerInRangeOfPoint(playerid, 2.0, x, y, z))
	{
	    if(playerHasKey[playerid][vehicleid]) vehicleLocked[vehicleid] = true;
	    if(IsPlayerInVehicle(playerid, vehicleid) && GetPlayerVehicleSeat(playerid) == 0) vehicleLocked[vehicleid] = true;
	}
	SCM(playerid, COLOR_WHITE, "~ You have locked the vehicle.");
	return 1;
}

YCMD:unlock(playerid, params[], help)
{
	#pragma unused help
	new vehicleid = -1, Float:x, Float:y, Float:z;
	if(IsPlayerInAnyVehicle(playerid)) vehicleid = GetPlayerVehicleID(playerid);
	else if(sscanf(params, "i", vehicleid)) return SCM(playerid, COLOR_RED, "Usage: /unlock [VehicleID]");

	if(!IsPlayerInVehicle(playerid, vehicleid) && !playerHasKey[playerid][vehicleid]) return SCM(playerid, COLOR_RED, "Error: You do not have the key to this vehicle.");
	if(!vehicleLocked[vehicleid]) return SCM(playerid, COLOR_RED, "Error: This vehicle is unlocked.");

	if(playerHasKey[playerid][vehicleid])
	{
		GetVehiclePos(vehicleid, x, y, z);
		if(!IsPlayerInRangeOfPoint(playerid, 2, x, y, z)) return SCM(playerid, COLOR_RED, "Error: You must be closer to the vehicle.");
	}

	vehicleLocked[vehicleid] = false;
	SCM(playerid, COLOR_WHITE, "~ You have unlocked the vehicle.");
	return 1;
}

YCMD:start(playerid, params[], help)
{
	if(!IsPlayerInAnyVehicle(playerid)) return SCM(playerid, COLOR_RED, "Error: You are not in a vehicle.");
	new vehicleid = GetPlayerVehicleID(playerid);

 	if(keyPosition[vehicleid] == KEYPOS_OUT && !playerHasKey[playerid][vehicleid]) return SCM(playerid, COLOR_RED, "Error: You do not have the key for this vehicle.");
	if(keyPosition[vehicleid] == KEYPOS_START) return SCM(playerid, COLOR_RED, "Error: Vehicle is already starting.");

	if(keyPosition[vehicleid] == KEYPOS_OUT) OnPlayerCommandText(playerid, "/key insert");
	OnPlayerCommandText(playerid, "/key turn start");
	return 1;
}

YCMD:s(playerid, params[], help)
{

	OnPlayerCommandText(playerid, "/start");
	return 1;
}
// Admin Commands

YCMD:acmds(playerid, params[], help)
{
	#pragma unused params
	#pragma unused help
	if(!IsPlayerAdmin2(playerid)) return 0;

	SCM(playerid, COLOR_WHITE, "~ Admin Commands:");
	SCM(playerid, COLOR_GRAY, "/v, /givevehiclekey, /createvehiclekey");
	SCM(playerid, COLOR_WHITE, "* Debug commands:");
	SCM(playerid, COLOR_GRAY, "/movexyfront, /gotocoords, /setangle, /moveplayer, /getvehicleinfo");
	return 1;
}

YCMD:v(playerid, params[], help)
{
	#pragma unused help
	new modelid, Float:x, Float:y, Float:z, Float:a;
	new string[128];

	if(!IsPlayerAdmin2(playerid)) return 0;

	GetPlayerPos(playerid, x, y, z);
	GetXYInFrontOfPlayer(playerid, x, y);
	GetPlayerFacingAngle(playerid, a);
	a += 90;

	if(sscanf(params, "i", modelid)) return SCM(playerid, COLOR_RED, "Usage: /v [ModelID]");

	if(modelid == 449 || modelid == 537 || modelid == 538 || modelid == 569 || modelid == 570 || modelid == 590)
			return SCM(playerid, COLOR_RED, "Error: Vehicle model is train/tram.");
	if(modelid < 400 || modelid > 611) return SCM(playerid, COLOR_RED, "Error: Invalid model ID.");

	new vehicleid = CreateVehicle2(modelid, x, y, z, a, -1);
	InitializeVehicle(vehicleid);
	SCM(playerid, COLOR_WHITE, "~ Vehicle spawned.");

	format(string, sizeof(string), "~ X: %f, Y: %f, Z: %f, A: %f", x, y, z, a);
	SCM(playerid, COLOR_BLUE, string);
	return 1;
}

YCMD:givevehiclekey(playerid, params[], help)
{
	#pragma unused help
	new pplayerid, ppplayerid, vehicleid, string[128];
	if(sscanf(params, "iii", pplayerid, ppplayerid, vehicleid)) return SCM(playerid, COLOR_RED, "Usage: /givevehiclekey [From PlayerID] [To PlayerID] [VehicleID]");

	if(!playerHasKey[pplayerid][vehicleid]) return SCM(playerid, COLOR_RED, "Error: Player does not possess the key to this vehicle.");
	if(playerHasKey[ppplayerid][vehicleid]) return SCM(playerid, COLOR_RED, "Error: Player already possesses the key to this vehicle.");

	playerHasKey[pplayerid][vehicleid] = --playerKeys[pplayerid][vehicleid] <= 0 ? false : true;
	playerKeys[ppplayerid][vehicleid]++;
	if(!playerHasKey[ppplayerid][vehicleid]) playerHasKey[ppplayerid][vehicleid] = true;
	format(string, sizeof(string), "~ An Administrator has taken the key to the %s (%d) from you.", vehName[GetVehicleModel(vehicleid) - 400], vehicleid);
	SCM(pplayerid, COLOR_BLUE, string);
	format(string, sizeof(string), "~ An Administrator has given you the key to a vehicle. (%s (%d))", vehName[GetVehicleModel(vehicleid) - 400], vehicleid);
	SCM(ppplayerid, COLOR_BLUE, string);
	format(string, sizeof(string), "~ You have taken the %s key from %s and given it to %s.", vehName[GetVehicleModel(vehicleid) - 400], GetName(pplayerid), GetName(ppplayerid));
	SCM(playerid, COLOR_BLUE, string);
	return 1;
}

YCMD:createvehiclekey(playerid, params[], help)
{
	#pragma unused help
	new vehicleid, string[128];
	if(!IsPlayerAdmin2(playerid)) return 0;
	if(sscanf(params, "i", vehicleid)) return SCM(playerid, COLOR_RED, "Usage: /createvehiclekey [VehicleID]");

	if(playerHasKey[playerid][vehicleid]) return SCM(playerid, COLOR_RED, "Error: You already have a key to this vehicle.");

	playerHasKey[playerid][vehicleid] = true;
	playerKeys[playerid][vehicleid]++;

	format(string, sizeof(string), "~ You have created a new key. (%s (%d))", vehName[GetVehicleModel(vehicleid) - 400], vehicleid);
	SCM(playerid, COLOR_BLUE, string);
	return 1;
}

YCMD:movexyfront(playerid, params[], help)
{
	new Float:x, Float:y, Float:z;
	if(!IsPlayerAdmin2(playerid)) return 0;
	GetPlayerPos(playerid, x, y, z);
	GetXYInFrontOfPlayer(playerid, x, y);

	SetPlayerPos(playerid, x, y, z);
	return 1;
}

YCMD:gotocoords(playerid, params[], help)
{
	#pragma unused help
	new Float:x, Float:y, Float:z;
	if(!IsPlayerAdmin2(playerid)) return 0;
	if(sscanf(params, "fff", x, y, z)) return SCM(playerid, COLOR_RED, "Usage: /gotocoords [X] [Y] [Z]");

	SetPlayerPos(playerid, x, y, z);
	return 1;
}

YCMD:setangle(playerid, params[], help)
{
	#pragma unused help
	if(!IsPlayerAdmin2(playerid)) return 0;
	new Float:ang;
	if(sscanf(params, "f", ang)) return SCM(playerid, COLOR_RED, "Usage: /setangle [Angle]");
	if(ang < 0 || ang > 360) return SCM(playerid, COLOR_RED, "Error: Invalid entry.");

	SetPlayerFacingAngle(playerid, ang);
	return 1;
}

YCMD:moveplayer(playerid, params[], help)
{
	#pragma unused help
	if(!IsPlayerAdmin2(playerid)) return 0;
	new Float:xx, Float:x, Float:moveX, Float:yy, Float:y, Float:moveY, Float:z, Float:a;
	GetPlayerPos(playerid, xx, yy, z);
	GetPlayerFacingAngleFix(playerid, a);

	if(sscanf(params, "ff", moveX, moveY)) return SCM(playerid, COLOR_RED, "Usage: /moveplayer [X] [Y]");

    x = xx + (floatsin(-a, degrees) * moveX);
	y = yy + (floatcos(-a, degrees) * moveY);

	SetPlayerPos(playerid, x, y, z);
	return 1;
}

YCMD:getvehicleinfo(playerid, params[], help)
{
	#pragma unused help
	if(!IsPlayerAdmin2(playerid)) return 0;
	new vehicleid, string[128];
	if(sscanf(params, "i", vehicleid)) return SCM(playerid, COLOR_RED, "Usage: /getvehicleinfo [VehicleID]");

	SCM(playerid, COLOR_WHITE, "~ Vehicle information:");
	format(string, sizeof(string), "- Engine health: %d", engineHealth[vehicleid]);
	SCM(playerid, COLOR_GRAY, string);
	format(string, sizeof(string), "- Fuel level: %d", vehicleFuel[vehicleid]);
	SCM(playerid, COLOR_GRAY, string);
	format(string, sizeof(string), "- Battery charge: %d", vehicleBattery[vehicleid]);
	SCM(playerid, COLOR_GRAY, string);
	return 1;
}













