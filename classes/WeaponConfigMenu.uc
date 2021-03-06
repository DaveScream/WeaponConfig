class WeaponConfigMenu extends LargeWindow
	dependson(WeaponConfigObject);

var struct GUIParam
{
	var  GUILabel	caption;
	var  GUIEditBox value;
	var  GUIEditBox bonus;
	var  GUIEditBox log;
	var  GUIEditBox stat0;
	var  GUIEditBox stat1;
	var  GUIEditBox stat2;
} Damage0, Damage1, HeadMult0, HeadMult1, FireRate0, FireRate1,
	Capacity0, Capacity1, MagSize, Cost, Weight, ReloadRate, Spread0, Spread1, 
	RecoilX0, RecoilX1, RecoilY0, RecoilY1, InShopLvl;

var GUILabel titValue, titBonus, titLog, titStats, titLvl0, titLvl1, titLvl2;

var GUIEditBox	PerkBox;
var GUIListBox	PerkList;
var GUIButton	PerkBtn;
var GUILabel	PerkLabel;

enum valueType
{
	HEADMULT0,
	HEADMULT1,
	USUAL,
	USUAL_INVERSE,
	NO_STATS,
	FIRERATE0,
	FIRERATE1,
};
enum varType
{
	FLOAT,
	INTEGER,
};
enum EBoxEdit
{
	NO_EDIT,
	CAN_EDIT,
};

var GUIButton bSaveExit, bCancel;
var localized string WinCaption;

var WeaponConfigObject WI;
var StringReplicationInfo RDataGUI;

var float gapU, gapD, gapL, gapR, gapBetweenX, gapBetweenY, gapLabel;
var float ParamLabelWidth, ParamHeight, ParamEditBoxWidth;
var color LabelTextColor;
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
function SetupGUIValues()
{
	local int row;
	local float width;
	t_WindowTitle.SetCaption(WI.WeaponClass);
	
	LabelTextColor.R=255;
	LabelTextColor.G=255;
	LabelTextColor.B=255;
	LabelTextColor.A=255;

	gapL = 30;
	gapU = 30;
	gapLabel = 8.f;
	gapBetweenX = 25.f;
	gapBetweenY = 1.f;
	ParamLabelWidth = 85.0;
	ParamHeight = 30.0;
	ParamEditBoxWidth = 75.f;
	
	titValue = InitLabel(0, 1, "Value");
	titValue.WinTop	+= ParamHeight / 2 ;
	
	titBonus = InitLabel(0, 2, "Bonus");
	titBonus.WinTop += ParamHeight / 2;
	
	titLog	= InitLabel(0, 3, "Log");
	titLog.WinTop += ParamHeight / 2;
	
	titStats = InitLabel(0, 5, "Stats");
	titLvl0 = InitLabel(1, 4, "lvl 0");
	titLvl1 = InitLabel(1, 5, "lvl 1/2");
	titLvl2 = InitLabel(1, 6, "lvl 1");
	
	row=2;
	InitParameter(Damage0,	"Damage0", WI.Damage[0], row++, USUAL, FLOAT);
	InitParameter(Damage1,	"Damage1", WI.Damage[1], row++, USUAL, FLOAT);
	InitParameter(HeadMult0,"HeadMult0", WI.HeadMult[0], row++, HEADMULT0, FLOAT);
	InitParameter(HeadMult1,"HeadMult1", WI.HeadMult[1], row++, HEADMULT1, FLOAT);
	InitParameter(FireRate0,"FireRate0", WI.FireRate[0], row++, FIRERATE0, FLOAT);
	InitParameter(FireRate1,"FireRate1", WI.FireRate[1], row++, FIRERATE1, FLOAT);
	InitParameter(Capacity0,"Capacity0", WI.Capacity[0], row++, USUAL, INTEGER);
	InitParameter(Capacity1,"Capacity1", WI.Capacity[1], row++, USUAL, INTEGER);
	InitParameter(MagSize,	"MagSize", WI.MagSize, row++, USUAL, INTEGER);
	InitParameter(Cost,		"Cost", WI.Cost, row++, USUAL_INVERSE, INTEGER);
	InitParameter(Weight,	"Weight", WI.Weight, row++, USUAL_INVERSE, INTEGER);
	InitParameter(ReloadRate,"ReloadRate", WI.ReloadRate, row++, USUAL, FLOAT);
	InitParameter(Spread0,	"Spread0", WI.Spread[0], row++, USUAL_INVERSE, FLOAT);
	InitParameter(Spread1,	"Spread1", WI.Spread[1], row++, NO_STATS, FLOAT);
	PerkLabel = InitLabel(row-1,5,"Perks");
	InitPerkList(row,4);
	
	RecoilX0.caption	= InitLabel(row,0,"RecoilX0");
	RecoilX0.value		= InitEditBox(row,1,WI.RecoilX[0], INTEGER, CAN_EDIT);
	RecoilY0.caption	= InitLabel(row,2,"RecoilY0");
	RecoilY0.value	= InitEditBox(row,3,WI.RecoilY[0], INTEGER, CAN_EDIT);
	row++;
	RecoilX1.caption	= InitLabel(row,0,"RecoilX1");
	RecoilX1.value		= InitEditBox(row,1,WI.RecoilX[1], INTEGER, CAN_EDIT);
	RecoilY1.caption	= InitLabel(row,2,"RecoilY1");
	RecoilY1.value		= InitEditBox(row,3,WI.RecoilY[1], INTEGER, CAN_EDIT);
	row++;
	InitPerkBtn(row, 6);
	InitPerkBox(row, 4);
	InitParameter(InShopLvl, "InShopLvl", WI.AllowInShopAt, row++, NO_STATS, FLOAT);
	

	width = ParamLabelWidth + gapLabel + 5*gapBetweenX + 6*ParamEditBoxWidth;
	bSaveExit = GUIButton(AddComponent("XInterface.GUIButton"));
	bSaveExit.bBoundToParent=true;
	bSaveExit.bNeverScale = True;
	bSaveExit.bTabStop=false;
	bSaveExit.Caption = "Ok";
	//bSaveExit.FontScale = FNS_Small;
	bSaveExit.WinLeft	= gapL;
	bSaveExit.WinTop	= gapU + row * ParamHeight + row * gapBetweenY + (gapBetweenY*2);
	bSaveExit.WinWidth	= width/2 - gapBetweenX/4;
	bSaveExit.WinHeight = ParamHeight*3 + gapBetweenY*2;
	bSaveExit.OnClick = InternalOnClick;

	bCancel = GUIButton(AddComponent("XInterface.GUIButton"));
	bCancel.bBoundToParent=true;
	bCancel.bNeverScale = True;
	bCancel.bTabStop=false;
	bCancel.Caption = "Cancel";
	//bCancel.FontScale = FNS_Small;
	bCancel.WinLeft	= gapL + width/2 + gapBetweenX/4;
	bCancel.WinTop	= gapU + row * ParamHeight + row * gapBetweenY + (gapBetweenY*2);
	bCancel.WinWidth = width/2 - gapBetweenX/4;
	bCancel.WinHeight = ParamHeight*3 + gapBetweenY*2;
	bCancel.OnClick = InternalOnClick;	

	row+=3;
	
	WinWidth = width + gapL*2;
	WinHeight = gapU + row * ParamHeight + row * gapBetweenY + (gapBetweenY*2) + gapU/2;
	return;
}
//--------------------------------------------------------------------------------------------------
function GUILabel PreInitLabel(string Caption)
{
	local GUILabel L;
	L = GUILabel(AddComponent("XInterface.GUILabel"));
	L.bBoundToParent=true;
	L.bNeverScale = True;
	L.TextColor = LabelTextColor;
	L.Caption = Caption;
	
	L.FontScale = FNS_Small;
	L.Style = Controller.GetStyle("EditBox", FontScale);
	//L.StyleName = "TextLabel";
	
	L.VertAlign=TXTA_Center;
	L.bAcceptsInput=false;
	L.bCaptureMouse=false;
	L.bNeverFocus=true;
	L.bTabStop=false;
		
	return L;
}
//--------------------------------------------------------------------------------------------------
function InitPerkBtn(int row, int col)
{
	local GUIButton L;
	L = GUIButton(AddComponent("XInterface.GUIButton"));
	L.bBoundToParent=true;
	L.bNeverScale = True;
	L.bTabStop=false;
	
	L.FontScale = FNS_Small;
	
	L.WinLeft	= gapL + ParamLabelWidth + gapLabel + (col-1) * gapBetweenX + (col-1)*ParamEditBoxWidth;
	L.WinTop	= gapU + row * ParamHeight + row * gapBetweenY;
	L.WinWidth	= ParamEditBoxWidth;
	L.WinHeight = ParamHeight;
	//L.OnChange	= OnChangePerkBox;
	L.DisableMe();
	PerkBtn = L;
	return;
}
//--------------------------------------------------------------------------------------------------
function bool OnPerkBtnDel(GUIComponent Sender)
{
	
	PerkList.List.Remove(PerkList.List.Index);
/*	for (i=0;i<PerkList.List.SelectedElements.Length; i++)
	{
		PerkBox.TextStr = PerkList.List.SelectedElements[i].Item;
		PerkList.List.RemoveElement(PerkList.List.SelectedElements[i]);
	}*/
	return true;
}
//--------------------------------------------------------------------------------------------------
function bool OnPerkBtnAdd(GUIComponent Sender)
{
	PerkList.List.Add(PerkBox.TextStr);
	OnPerkBoxChange(Sender);
	return true;
}
//--------------------------------------------------------------------------------------------------
function InitPerkList(int row, int col)
{
	local GUIListBox L;
	local int i;
	L = GUIListBox(AddComponent("XInterface.GUIListBox"));
	L.bBoundToParent=true;
	L.bNeverScale = True;
	L.bTabStop=false;
	L.bVisibleWhenEmpty = true;
	L.List.bVisibleWhenEmpty = true;
	

	L.List.FontScale = FNS_Small;
	L.Style = Controller.GetStyle("SmallListBox", FontScale);
	
	
	L.WinLeft	= gapL + ParamLabelWidth + gapLabel + (col-1) * gapBetweenX + (col-1)*ParamEditBoxWidth;
	L.WinTop	= gapU + row * ParamHeight + row * gapBetweenY;
	L.WinWidth	= ParamEditBoxWidth*3 + gapBetweenX*2;
	L.WinHeight = ParamHeight*2 + gapBetweenY*1;
	L.List.TextAlign	= TXTA_Left;
	L.List.OnChange		= OnPerkListChange;
	L.List.OnActivate	= OnPerkListActivate;

	for (i=0;i<WI.BonusFor.Length;i++)
		L.List.Add(string(WI.BonusFor[i].Name));
	
	PerkList = L;
	return;
}
//--------------------------------------------------------------------------------------------------
function OnPerkListActivate()
{
	if (PerkList.List.ItemCount > 0)
	{
		PerkBtn.Caption = "Del";
		PerkBtn.OnClick = OnPerkBtnDel;
	}
}
//--------------------------------------------------------------------------------------------------
function OnPerkListChange(GUIComponent Sender)
{
	if (PerkList==none || PerkList.List == none || PerkBtn == none)
		return;

	if (PerkList.List.Index != -1)
		PerkBtn.EnableMe();
	else
		PerkBtn.DisableMe();
	return;
}
//--------------------------------------------------------------------------------------------------
function InitPerkBox(int row, int col)
{
	local GUIEditBox L;
	L = GUIEditBox(AddComponent("XInterface.GUIEditBox"));
	L.FontScale = FNS_Small;
	L.bBoundToParent=true;
	L.bNeverScale = True;
	L.bTabStop=false;
	
	L.WinLeft	= gapL + ParamLabelWidth + gapLabel + (col-1) * gapBetweenX + (col-1)*ParamEditBoxWidth;
	L.WinTop	= gapU + row * ParamHeight + row * gapBetweenY;
	L.WinWidth	= ParamEditBoxWidth*2 + gapBetweenX;
	L.WinHeight = ParamHeight;
	L.OnActivate = OnPerkBoxActivate;
	L.OnChange	= OnPerkBoxChange;
	L.TextStr = string(KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo).ClientVeteranSkill.Name);
	OnPerkBoxChange(L);
	PerkBox = L;
	return;
}
//--------------------------------------------------------------------------------------------------
function OnPerkBoxActivate()
{
	PerkBtn.OnClick = OnPerkBtnAdd;
	OnPerkBoxChange(PerkBox);

}
//--------------------------------------------------------------------------------------------------
function OnPerkBoxChange(GUIComponent Sender)
{
	local class<KFVeterancyTypes> vet;
	local int n;
	local string pkg;
	
	if (PerkBtn==none)
		return;
	
	pkg = string(KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo).ClientVeteranSkill);
	n = InStr(pkg,".");
	pkg = Left(pkg,n);
	vet = class<KFVeterancyTypes>(DynamicLoadObject(pkg$"."$PerkBox.TextStr, Class'Class'));
	if (vet!=none && PerkList.List.FindIndex(string(vet.name))== -1 )
	{
		PerkBtn.Caption = "Add";
		PerkBtn.EnableMe();
	}
	else
	{
		PerkBtn.Caption = "Add";
		PerkBtn.DisableMe();
	}
	return;
}
//--------------------------------------------------------------------------------------------------
function GUILabel InitLabel(int row, int col, string Caption)
{
	local GUILabel L;
	L = PreInitLabel(Caption);
	if (col==0)
	{
		L.WinWidth	= ParamLabelWidth;
		L.WinLeft	= gapL;
	}
	if (col>0)
	{
		L.TextAlign = TXTA_Center;
		L.WinLeft	= gapL + ParamLabelWidth + gapLabel + (col-1) * ParamEditBoxWidth + (col-1) * gapBetweenX;
		L.WinWidth	= ParamEditBoxWidth;
	}
	L.WinTop	= gapU + row * ParamHeight + row * gapBetweenY ;
	
	L.WinHeight = ParamHeight;
	return L;
}
//--------------------------------------------------------------------------------------------------
function OnChange(GUIComponent Sender)
{
	local int row;
	local bool bOnlyCalcStats;
	bOnlyCalcStats = true;

	ReadInfo();
	
	InitParameter(Damage0, "Damage0", WI.Damage[0], row++, USUAL, FLOAT,bOnlyCalcStats);
	InitParameter(Damage1, "Damage1", WI.Damage[1], row++, USUAL, FLOAT,bOnlyCalcStats);
	InitParameter(HeadMult0, "HeadMult0", WI.HeadMult[0], row++, HEADMULT0, FLOAT,bOnlyCalcStats);
	InitParameter(HeadMult1, "HeadMult1", WI.HeadMult[1], row++, HEADMULT1, FLOAT,bOnlyCalcStats);
	InitParameter(FireRate0, "FireRate0", WI.FireRate[0], row++, FIRERATE0, FLOAT,bOnlyCalcStats);
	InitParameter(FireRate1, "FireRate1", WI.FireRate[1], row++, FIRERATE1, FLOAT,bOnlyCalcStats);
	InitParameter(Capacity0, "Capacity0", WI.Capacity[0], row++, USUAL, INTEGER,bOnlyCalcStats);
	InitParameter(Capacity1, "Capacity1", WI.Capacity[1], row++, USUAL, INTEGER,bOnlyCalcStats);
	InitParameter(MagSize, "MagSize", WI.MagSize, row++, USUAL, INTEGER,bOnlyCalcStats);
	InitParameter(Cost, "Cost", WI.Cost, row++, USUAL_INVERSE, INTEGER,bOnlyCalcStats);
	InitParameter(Weight, "Weight", WI.Weight, row++, USUAL_INVERSE, INTEGER,bOnlyCalcStats);
	InitParameter(Spread0, "Spread0", WI.Spread[0], row++, USUAL_INVERSE, FLOAT,bOnlyCalcStats);
	InitParameter(Spread1, "Spread1", WI.Spread[1], row++, NO_STATS, FLOAT,bOnlyCalcStats);
	InitParameter(ReloadRate, "ReloadRate", WI.ReloadRate, row++, USUAL, FLOAT,bOnlyCalcStats);
	InitParameter(InShopLvl, "InShopLvl", WI.AllowInShopAt, row++, NO_STATS, FLOAT,bOnlyCalcStats);
}
//--------------------------------------------------------------------------------------------------
function GUIEditBox InitEditBox(int row, int col, float val, optional varType varType, optional EBoxEdit Edit)
{
	local GUIEditBox L;
	L = GUIEditBox(AddComponent("XInterface.GUIEditBox"));
	L.bBoundToParent=true;
	L.bNeverScale = True;
	L.bTabStop=false;
	
	L.FontScale = FNS_Small;
	
	L.WinLeft	= gapL + ParamLabelWidth + gapLabel + (col-1) * gapBetweenX + (col-1)*ParamEditBoxWidth;
	L.WinTop	= gapU + row * ParamHeight + row * gapBetweenY;
	L.WinWidth	= ParamEditBoxWidth;
	L.WinHeight = ParamHeight;
	if (varType == INTEGER)
	{
		L.TextStr	= string(int(val));
		L.bIntOnly = true;
	}
	else
		L.TextStr	= string(val);
	if (Edit == NO_EDIT)
	{
		L.bAcceptsInput=false;
		L.bCaptureMouse=false;
		L.bNeverFocus=true;
		L.bTabStop=false;
		L.bReadOnly=true;
	}
	else
		L.OnChange = OnChange;
		
	return L;
}
//--------------------------------------------------------------------------------------------------
/*function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);
}*/
//--------------------------------------------------------------------------------------------------
//InitParameter(Damage0, "Damage0", WI.Damage[0]);
function InitParameter(out GUIParam GP, string Cap, WeaponConfigObject.Param P, int row, valueType vType, varType varType, optional bool bOnlyCalcStats)
{
	local int i;
	local float f,f2;
	local float fl[3];
	if (bOnlyCalcStats==false)
	{
		GP.caption	= InitLabel(row,0,Cap);
		GP.value	= InitEditBox(row,1,P.value, varType, CAN_EDIT);
		GP.bonus	= InitEditBox(row,2,P.BonusMax,,CAN_EDIT);
		GP.log		= InitEditBox(row,3,P.BonusLog,,CAN_EDIT);
	}
	if (vType == NO_STATS)
		return;
	else if (vType==USUAL_INVERSE)
	{
		for (i=0;i<3;i++)
		{
			fl[i] = class'WeaponConfig'.static.GetCoeff(P, i*0.5f, true);
			fl[i] *= P.value;
		}
	}
	else if (vType==USUAL)
	{
		for (i=0;i<3;i++)
		{
			fl[i] = class'WeaponConfig'.static.GetCoeff(P, i*0.5f);
			fl[i] *= P.value;
		}
	}
	else if (vType==HEADMULT0)
	{
		for (i = 0; i<3; i++)
		{
			f = class'WeaponConfig'.static.GetCoeff(WI.Damage[0], i*0.5f);
			f *= WI.Damage[0].value;
			f2 = class'WeaponConfig'.static.GetCoeff(WI.HeadMult[0], i*0.5f);
			f2 *= WI.HeadMult[0].value;
			f *= f2;
			fl[i] = f;
		}
	}
	else if (vType==HEADMULT1)
	{
		for (i = 0; i<3; i++)
		{
			f = class'WeaponConfig'.static.GetCoeff(WI.Damage[1], i*0.5f);
			f *= WI.Damage[1].value;
			f2 = class'WeaponConfig'.static.GetCoeff(WI.HeadMult[1], i*0.5f);
			f2 *= WI.HeadMult[1].value;
			f *= f2;
			fl[i] = f;
		}
	}
	else if (vType==FIRERATE0)
	{
		for (i = 0; i<3; i++)
		{
			f = class'WeaponConfig'.static.GetCoeff(WI.FireRate[0], i*0.5f);
			f = WI.FireRate[0].value / f;
			fl[i] = f;
		}
	}
	else if (vType==FIRERATE1)
	{
		for (i = 0; i<3; i++)
		{
			f = class'WeaponConfig'.static.GetCoeff(WI.FireRate[1], i*0.5f);
			f = WI.FireRate[1].value / f;
			fl[i] = f;
		}		
	}
	for (i=0;i<3;i++)
	{
		if (bOnlyCalcStats)
		{
			if (i==0) GP.stat0.SetText(string(fl[i]));
			if (i==1) GP.stat1.SetText(string(fl[i]));
			if (i==2) GP.stat2.SetText(string(fl[i]));
		}
		else
		{
			if (i==0) GP.stat0	= InitEditBox(row,4+i, fl[i],,NO_EDIT);
			if (i==1) GP.stat1	= InitEditBox(row,4+i, fl[i],,NO_EDIT);
			if (i==2) GP.stat2	= InitEditBox(row,4+i, fl[i],,NO_EDIT);
		}
	}
	//static function float GetCoeff(WeaponConfigObject.Param P, float lvlmult, optional bool bInverseCoeff)
}
//--------------------------------------------------------------------------------------------------
event HandleParameters(string Param1, string Param2)
{
	local int bBadCRC;
	local string S;
	
	if (WI==none)
		WI = new(None, "temp") class'WeaponConfigObject';
		
	foreach PlayerOwner().DynamicActors(class'StringReplicationInfo', RDataGUI)
	{
		if (RDataGUI.OwnerPC == PlayerOwner() && RDataGUI.bMenuStr)
		{
			S = RDataGUI.GetString(bBadCRC);
			if (bBadCRC==0)
			{
				WI.Unserialize(S);
				break;
			}
			else
			{
				PlayerOwner().ClientMessage("Bad RDataGUI CRC so exit menu");
				PlayerOwner().ClientCloseMenu(True,False); //CloseAll(false,true);
				return;
			}
		}
	}
	//WI.Unserialize(Param1$Param2);
	SetupGUIValues();
}
//--------------------------------------------------------------------------------------------------
function OnOpen()
{
	Super.OnOpen();
}
//--------------------------------------------------------------------------------------------------
/*function WriteParameter(GUIParam GP, out WeaponConfigObject.Param P)
{
	P.value		= float(GP.value.TextStr);
	P.BonusMax	= float(GP.bonus.TextStr);
	P.BonusLog	= float(GP.log.TextStr);
}
//--------------------------------------------------------------------------------------------------
function WriteInfo()
{
	WriteParameter(Damage0, WI.Damage[0]);
	WriteParameter(Damage1, WI.Damage[1]);
	WriteParameter(HeadMult0, WI.HeadMult[0]);
	WriteParameter(HeadMult1, WI.HeadMult[1]);
	WriteParameter(FireRate0, WI.FireRate[0]);
	WriteParameter(FireRate1, WI.FireRate[1]);
	WriteParameter(Capacity0, WI.Capacity[0]);
	WriteParameter(Capacity1, WI.Capacity[1]);
	WriteParameter(MagSize, WI.MagSize);
	WriteParameter(Cost, WI.Cost);
	WriteParameter(Weight, WI.Weight);
	WriteParameter(Recoil0, WI.Recoil[0]);
	WriteParameter(Recoil1, WI.Recoil[1]);
	WriteParameter(InShopLvl, WI.AllowInShopAt);
}*/
//--------------------------------------------------------------------------------------------------
function ReadParameter(GUIParam GP, out WeaponConfigObject.Param P)
{
	P.value		= float(GP.value.TextStr);
	P.BonusMax	= float(GP.bonus.TextStr);
	P.BonusLog	= float(GP.log.TextStr);
}
//--------------------------------------------------------------------------------------------------
function ReadInfo()
{
	local int i;
	local string vet, pkg;
	local class<KFVeterancyTypes> v;
	
	ReadParameter(Damage0, WI.Damage[0]);
	ReadParameter(Damage1, WI.Damage[1]);
	ReadParameter(HeadMult0, WI.HeadMult[0]);
	ReadParameter(HeadMult1, WI.HeadMult[1]);
	ReadParameter(FireRate0, WI.FireRate[0]);
	ReadParameter(FireRate1, WI.FireRate[1]);
	ReadParameter(Capacity0, WI.Capacity[0]);
	ReadParameter(Capacity1, WI.Capacity[1]);
	ReadParameter(MagSize, WI.MagSize);
	ReadParameter(Cost, WI.Cost);
	ReadParameter(Weight, WI.Weight);
	ReadParameter(Spread0, WI.Spread[0]);
	ReadParameter(Spread1, WI.Spread[1]);
	ReadParameter(ReloadRate, WI.ReloadRate);
	ReadParameter(InShopLvl, WI.AllowInShopAt);
	WI.RecoilX[0] = int(RecoilX0.value.TextStr);
	WI.RecoilY[0] = int(RecoilY0.value.TextStr);
	WI.RecoilX[1] = int(RecoilX1.value.TextStr);
	WI.RecoilY[1] = int(RecoilY1.value.TextStr);
	WI.BonusFor.Remove(0,WI.BonusFor.Length);
	pkg = string(KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo).ClientVeteranSkill);
	pkg = Left(pkg,InStr(pkg,"."));
	for (i=0; i<PerkList.List.ItemCount;i++)
	{
		vet = PerkList.List.Elements[i].Item;
		//PerkList.List.GetAtIndex(i,vet);
		v = class<KFVeterancyTypes>(DynamicLoadObject(pkg$"."$vet, Class'Class'));
		if (v!=none)
			WI.BonusFor[WI.BonusFor.Length] = v;
	}
}
//--------------------------------------------------------------------------------------------------
function SaveData()
{
	local array<string> S;
	local string tStr;
	local int i,mLen, fLen;
	mLen = 200;
	ReadInfo();
	// Отправляем новые настройки через консоль mutate (а мутатор должен их поймать)
	tStr = WI.Serialize();
	fLen = Len(tStr);
	while (Len(tStr)>0)
	{
		if (Len(tStr)>mLen)
		{
			S[S.Length] = Left(tStr,mLen);
			tStr = Right(tStr, Len(tStr)-mLen);
		}
		else
		{
			S[S.Length] = tStr;
			tStr="";
			break;
		}
	}
	RDataGUI.revision++;
	for (i=0;i<S.Length;i++)
		RDataGUI.SetStringClient(S[i], i, S.Length, fLen);
}
//--------------------------------------------------------------------------------------------------
/*function OnClose(optional Bool bCancelled)
{
	Super.OnClose(bCancelled);
}*/
//--------------------------------------------------------------------------------------------------
function bool InternalOnClick(GUIComponent Sender)
{
	local PlayerController PC;
	PC = PlayerOwner();
	
	switch (GUIButton(Sender))
	{
		case bSaveExit:
			SaveData();
			PC.ClientCloseMenu(True,False); //CloseAll(false,true);
			break;
		case bCancel:
			PC.ClientCloseMenu(True,False); //CloseAll(false,true);
			break;
	}
    return false;
}
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
defaultproperties
{
	/*
	Begin Object Class=GUIButton Name=obSaveExit
      Caption="Ok"
      OnClick=InternalOnClick
      TabOrder=2
      bBoundToParent=true
      bScaleToParent=false
		WinWidth=0.298585
		WinHeight=0.100143
		WinLeft=0.036077
		WinTop=0.872991
	End Object
	bSaveExit=obSaveExit

	Begin Object Class=GUIButton Name=obCancel
      Caption="Cancel"
      OnClick=InternalOnClick
      TabOrder=1
      bBoundToParent=true
      bScaleToParent=false
		WinWidth=0.298585
		WinHeight=0.100143
		WinLeft=0.505391
		WinTop=0.872991
	End Object
	bCancel=obCancel
	*/
	WinCaption="Weapon config"
	bResizeWidthAllowed=false
    bResizeHeightAllowed=false
    bMoveAllowed=True
    DefaultLeft=0.110313
    DefaultTop=0.057916
    DefaultWidth=0.779688
    DefaultHeight=0.847083
    bRequire640x480=False
    WinTop=0.057916
    WinLeft=0.110313
    WinWidth=724 //500
	WinHeight=645 //250
	bAllowedAsLast=True // If this is true, closing this page will not bring up the main menu if last on the stack.	
    bPersistent=False // If set in defprops, page is kept in memory across open/close/reopen
	bRestorable=False // When the GUIController receives a call to CloseAll(), should it reopen this page the next time main is opened?
}