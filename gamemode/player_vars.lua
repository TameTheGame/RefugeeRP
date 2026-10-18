
--Player vars, networked and serverside
--These are all created on the player on initial spawn

--SERVERSIDE VARIABLES
TS.PlayerVars = { }

TS.PlayerVars["passedout"] = 0;

TS.PlayerVars["newnick"] = "";
TS.PlayerVars["name"] = "";
TS.PlayerVars["jointime"] = 0;

TS.PlayerVars["AdminFlags"] = "";
TS.PlayerVars["UserFlags"] = "";

TS.PlayerVars["LetterBits"] = "";

TS.PlayerVars["ignorenextname"] = false;

TS.PlayerVars["OverrideAnim"] = false;
TS.PlayerVars["CrntActID"] = 0;

TS.PlayerVars["LastLogLook"] = 0;

TS.PlayerVars["WeapAnim"] = "";
TS.PlayerVars["LegHealthMul"] = 1;
TS.PlayerVars["ChangeAnim"] = true;
TS.PlayerVars["InAir"] = false;

TS.PlayerVars["FailCount"] = 0;

TS.PlayerVars["LastJump"] = 0;

TS.PlayerVars["saveversion"] = 0;
TS.PlayerVars["saveeof"] = 0;

TS.PlayerVars["citizenmodel"] = "";
TS.PlayerVars["model"] = "";
TS.PlayerVars["newbie"] = 0;
TS.PlayerVars["jobnotify"] = 0;
TS.PlayerVars["status"] = { }
TS.PlayerVars["Owned"] = { }
TS.PlayerVars["Inventory"] = { }

TS.PlayerVars["LastDoorKick"] = 0;

TS.PlayerVars["lastregen"] = 0;

TS.PlayerVars["lastbleeddmg"] = 0;
TS.PlayerVars["bleedwound"] = 0;
TS.PlayerVars["lastbleed"] = 0;

TS.PlayerVars["HeadBleed"] = 0;
TS.PlayerVars["hp.Body"] = 100;
TS.PlayerVars["hp.Arms"] = 100;
TS.PlayerVars["hp.Legs"] = 100;

TS.PlayerVars["LastSneakStatCheck"] = 0;
TS.PlayerVars["LastSprintStatCheck"] = 0;

TS.PlayerVars["letter.Ent"] = 0;
TS.PlayerVars["letter.Item"] = "";

TS.PlayerVars["lastkoregen"] = 0;

TS.PlayerVars["slay"] = 0;

TS.PlayerVars["lastdeductrate"] = 0;

TS.PlayerVars["cangetloan"] = 0;

TS.PlayerVars["prop.lastspawn"] = 0;
TS.PlayerVars["prop.propcount"] = 0;
TS.PlayerVars["prop.delay"] = 0;

TS.PlayerVars["lastooc"] = 0;

TS.PlayerVars["stat.StrengthModifier"] = 0;
TS.PlayerVars["stat.EnduranceModifier"] = 0; 
TS.PlayerVars["stat.SprintModifier"] = 0;
TS.PlayerVars["stat.SpeedModifier"] = 0;

TS.PlayerVars["stat.AimModifier"] = 0; 
TS.PlayerVars["stat.MedicModifier"] = 0; 
TS.PlayerVars["stat.SneakModifier"] = 0;

TS.PlayerVars["MaxStamina"] = 100;

TS.PlayerVars["LastStaminaDegrade"] = 0;

TS.PlayerVars["CustomModel"] = "";

TS.PlayerVars["beingpatdown"] = 0;

TS.PlayerVars["StunHit"] = 0;

TS.PlayerVars["pattingdown"] = 0;
TS.PlayerVars["firsttimelogin"] = 0;
TS.PlayerVars["ragdolled"] = 0;
TS.PlayerVars["ragdoll"] = 0;
TS.PlayerVars["isko"] = 0;
TS.PlayerVars["charactercreate"] = 0;
TS.PlayerVars["healingtarget"] = 0;
TS.PlayerVars["healingself"] = 0;
TS.PlayerVars["healtype"] = 0;
TS.PlayerVars["tieduptarget"] = 0;
TS.PlayerVars["ownsbusiness"] = 0;
TS.PlayerVars["cid"] = 0;
TS.PlayerVars["radiofreq"] = 0;
TS.PlayerVars["borrowamount"] = 0;
TS.PlayerVars["oweamount"] = 0;
TS.PlayerVars["inventory.CrntSize"] = 0;
TS.PlayerVars["inventory.MaxSize"] = 4;
TS.PlayerVars["info.Race"] = "";
TS.PlayerVars["info.Age"] = "";
TS.PlayerVars["info.Bio"] = "";
TS.PlayerVars["combineflags"] = "";
TS.PlayerVars["miscflags"] = "";
TS.PlayerVars["businessflags"] = "";
TS.PlayerVars["job"] = "Unemployed";

--GLOBAL INTEGERS
TS.PlayerNWInts = { }
TS.PlayerPrivateNWInts = {

	"MaxHealth",
	"MaxArmor",
	"armor",
	"sprint",
	"charactercreate",
	"isbleeding",
	"ownsbusiness",
	"hired"
}

TS.PlayerNWInts["MaxHealth"] = 100;
TS.PlayerNWInts["MaxArmor"] = 0;
TS.PlayerNWInts["armor"] = 0;
TS.PlayerNWInts["sprint"] = 100;

TS.PlayerNWInts["healing"] = 0;
TS.PlayerNWInts["beinghealed"] = 0;

TS.PlayerNWInts["tiedup"] = 0;
TS.PlayerNWInts["tyingup"] = 0;
TS.PlayerNWInts["beingtiedup"] = 0;
TS.PlayerNWInts["untying"] = 0;

TS.PlayerNWInts["businessid"] = 0;

TS.PlayerNWInts["isbleeding"] = 0;

--GLOBAL FLOATS (DECIMALS)
TS.PlayerNWFloats = { }
TS.PlayerPrivateNWFloats = {

	"cid",
	"money",
	"radiofreq",
	"borrowamount",
	"oweamount",
	"komul",
	"conscious",
	"stat.Strength",
	"stat.Endurance",
	"stat.Sprint",
	"stat.Speed",
	"stat.Aim",
	"stat.Sneak",
	"inventory.CrntSize",
	"inventory.MaxSize"
}

TS.PlayerNWFloats["money"] = 115;

TS.PlayerNWFloats["conscious"] = 100;
TS.PlayerNWFloats["komul"] = 1;

TS.PlayerNWFloats["stat.Strength"] = 35; --Todo
TS.PlayerNWFloats["stat.Endurance"] = 35; 
TS.PlayerNWFloats["stat.Sprint"] = 33;
TS.PlayerNWFloats["stat.Speed"] = 8;

TS.PlayerNWFloats["stat.Aim"] = 20; 
TS.PlayerNWFloats["stat.Medic"] = 5; --Todo
TS.PlayerNWFloats["stat.Sneak"] = 1;

--GLOBAL STRINGS
TS.PlayerNWStrings = { }
TS.PlayerPrivateNWStrings = {

	"job",
	"info.Race",
	"info.Age",
	"info.Bio",
	"combineflags",
	"miscflags",
	"businessflags"
}

TS.PlayerNWStrings["title"] = "Survivor";


TS.PlayerNWStrings["IngameAvatar"] = "";

TS.PlayerNWStrings["admintitle"] = "";

