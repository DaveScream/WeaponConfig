class WeaponConfigObject extends Object
	PerObjectConfig
	config(WeaponConfig);

var const string ConfigFile;
var const string delim1, delim2;

struct Param
{
	var float	value;
	var float	BonusMax;
	var float	BonusLog;
};

var config string	WeaponClass;

var config Param	Damage[2];
var config Param	HeadMult[2];
var config Param	Cost;
var config Param	AmmoCost;		// in pickup
var config Param	Capacity[2];
var config Param	MagSize;
var config Param	Weight;
var config Param	FireRate[2];	// perk bonus takes from FireRate[0].BonusMax only
var config Param	ReloadRate;		// скорость перезарядки в KFWeapon
									// Bonus GetReloadSpeedModifier() - чем выше тем лучше 1.0 +...
var config Param	Spread[2]; // только WeaponFire SpreadBonus // 0 - 1 чем меньше тем лучше
var config float	RecoilX[2]; // KFFire KFShotGunFire int maxHorizontalRecoilAngle
var config float	RecoilY[2]; // KFFire KFShotGunFire int maxVerticalRecoilAngle

var config Param	AllowInShopAt; // указывает на каком уровне позволено покупать оружие (от 0 до 1)
var config array< class<KFVeterancyTypes> > AllowInShopFor; // каким перкам разрешено покупать оружие class'SRCommandos'

var config array< class<KFVeterancyTypes> > BonusFor; // на какие перки распространяется бонус class'SRCommandos'
var config class<DamageType> DamageType[2];
var config class<Ammunition> AmmoClass[2];
var config class<Pickup> PickupClass;
var int revision;

//--------------------------------------------------------------------------------------------------
simulated function float R(float f)
{
	local float f1;
	f1 = f * 10.f;
	f1 = int(f1);
	f1 = f1/10.f;
	return f1;
}
//--------------------------------------------------------------------------------------------------
simulated function string F2S(float f)
{
	return string(f);
}
//--------------------------------------------------------------------------------------------------
simulated function string I2S(int i)
{
	return string(i);
}
//--------------------------------------------------------------------------------------------------
simulated function float S2F(string s, optional out float f)
{
	f = float(s);
	return f;
}
//--------------------------------------------------------------------------------------------------
simulated function int S2I(string s, optional out int i)
{
	i = int(s);
	return i;
}
//--------------------------------------------------------------------------------------------------
simulated function ArrS2F(string s, out float F[2])
{
	local string delim;
	local array<string> iSplit;
	delim = "/";
	Split(s,delim,iSplit);
	F[0] = S2F(iSplit[0]);
	F[1] = S2F(iSplit[1]);
}
//--------------------------------------------------------------------------------------------------
simulated function S2Param(string s, out Param P)
{
	local array<string> iSplit;
	Split(s, delim1, iSplit);
	P.value = float(iSplit[0]);
	P.BonusMax = float(iSplit[1]);
	P.BonusLog = float(iSplit[2]);
}
//--------------------------------------------------------------------------------------------------
simulated function string Param2S(Param P)
{
	return P.value $ delim1 $ P.BonusMax $ delim1 $ P.BonusLog;
}
//--------------------------------------------------------------------------------------------------
simulated function string ArrF2S(float A[2])
{
	local string delim;
	delim = "/";
	return F2S(A[0])$delim$F2S(A[1]);
}
//--------------------------------------------------------------------------------------------------
simulated function ArrS2I(string s, out int I[2])
{
	local string delim;
	local array<string> iSplit;
	delim = "/";
	Split(s,delim,iSplit);
	I[0] = S2I(iSplit[0]);
	I[1] = S2I(iSplit[1]);
}
//--------------------------------------------------------------------------------------------------
simulated function string ArrI2S(int A[2])
{
	local string delim;
	delim = "/";
	return I2S(A[0])$delim$i2s(A[1]);
}
//--------------------------------------------------------------------------------------------------
simulated function Push(out string s, string input)
{
	local string delim;
	delim = "+";
	if (Len(s)==0)
		s=input;
	else
		s=s$delim$input;
}
//--------------------------------------------------------------------------------------------------
simulated function string Get(out string s)
{
	local string delim, l;
	local int n;
	delim = "+";
	n = InStr(s,delim);
	while (n==0)
	{
		s = Right(s, Len(s)-1);
		n = InStr(s,delim);
	}
	if (n==-1)
	{
		l=s;
		s="";
	}
	else
	{
		l = Left(s,n);
		s = Right(s, Len(s)-(n+1));
	}
	return l;
}
//--------------------------------------------------------------------------------------------------
simulated function Unserialize(string s)
{
	local int i,n;
	local string t;
	
	PickupClass=none;
	for (i=0;i<2;i++)
	{
		DamageType[i]=none;
		AmmoClass[i]=none;
	}
	AllowInShopFor.Remove(0,AllowInShopFor.Length);
	BonusFor.Remove(0,BonusFor.Length);
	
	WeaponClass = Get(s);
	S2Param(Get(s), Damage[0] );
	S2Param(Get(s), Damage[1] );
	S2Param(Get(s), HeadMult[0] );
	S2Param(Get(s), HeadMult[1] );
	S2Param(Get(s), Cost );
	S2Param(Get(s), AmmoCost );
	S2Param(Get(s), Capacity[0] );
	S2Param(Get(s), Capacity[1] );
	S2Param(Get(s), MagSize );
	S2Param(Get(s), Weight );
	S2Param(Get(s), FireRate[0] );
	S2Param(Get(s), FireRate[1] );
	S2Param(Get(s), ReloadRate );
	S2Param(Get(s), Spread[0] );
	S2Param(Get(s), Spread[1] );
	S2F( Get(s), RecoilX[0] );
	S2F( Get(s), RecoilX[1] );
	S2F( Get(s), RecoilY[0] );
	S2F( Get(s), RecoilY[1] );
	S2Param(Get(s), AllowInShopAt );

	S2I( Get(s), n ); // AllowInShopFor length
	for (i=0;i<n;i++)
	{
		t = Get(s);
		if (Caps(t)!="NONE")
			AllowInShopFor[i] = class<KFVeterancyTypes>(DynamicLoadObject(t, Class'Class'));
	}
	S2I( Get(s), n ); // BonusFor length	
	for (i=0;i<n;i++)
	{
		t = Get(s);
		if (Caps(t)!="NONE")
			BonusFor[i] = class<KFVeterancyTypes>(DynamicLoadObject(t, Class'Class'));
	}
	for (i=0;i<2;i++)
	{
		t = Get(s);
		if (Caps(t)!="NONE")
			DamageType[i]=class<DamageType>(DynamicLoadObject(t, Class'Class'));
	}
	for (i=0;i<2;i++)
	{
		t = Get(s);
		if (Caps(t)!="NONE")
			AmmoClass[i]=class<Ammunition>(DynamicLoadObject(t, Class'Class'));
	}
	t = Get(s);
		if (Caps(t)!="NONE")
			PickupClass = class<Pickup>(DynamicLoadObject(t, Class'Class'));
	
	S2I( Get(s), revision );
}
//--------------------------------------------------------------------------------------------------
simulated function string Serialize()
{
	local string s;
	local int i;

	Push(s, WeaponClass );
	Push(s, Param2S(Damage[0]) );
	Push(s, Param2S(Damage[1]) );
	Push(s, Param2S(HeadMult[0]) );
	Push(s, Param2S(HeadMult[1]) );
	Push(s, Param2S(Cost) );
	Push(s, Param2S(AmmoCost) );
	Push(s, Param2S(Capacity[0]) );
	Push(s, Param2S(Capacity[1]) );
	Push(s, Param2S(MagSize) );
	Push(s, Param2S(Weight) );
	Push(s, Param2S(FireRate[0]) );
	Push(s, Param2S(FireRate[1]) );
	Push(s, Param2S(ReloadRate) );
	Push(s, Param2S(Spread[0]) );
	Push(s, Param2S(Spread[1]) );
	Push(s, F2S(RecoilX[0]) );
	Push(s, F2S(RecoilX[1]) );
	Push(s, F2S(RecoilY[0]) );
	Push(s, F2S(RecoilY[1]) );
	Push(s, Param2S(AllowInShopAt) );
	
	Push(s, i2s(AllowInShopFor.Length) );
	for (i=0;i<AllowInShopFor.Length;i++)
		Push(s, string(AllowInShopFor[i]) );
		
	Push(s, i2s(BonusFor.Length) );
	for (i=0;i<BonusFor.Length;i++)
		Push(s, string(BonusFor[i]) );

	for (i=0;i<2;i++)
		Push(s, string(DamageType[i]));

	for (i=0;i<2;i++)
		Push(s, string(AmmoClass[i]));
	
	Push(s, string(PickupClass));
	
	Push(s, i2s(revision));
	
	return s;
}
//--------------------------------------------------------------------------------------------------
static function array<string> GetNames()
{
	return GetPerObjectNames(default.ConfigFile);
}
//--------------------------------------------------------------------------------------------------
defaultproperties
{
	delim1 = "/"
	delim2 = "+"
	ConfigFile = "WeaponConfig" // not used
}