list order_buttons(list buttons)
{
    return llList2List(buttons, -3, -1) + llList2List(buttons, -6, -4) +
        llList2List(buttons, -9, -7) + llList2List(buttons, -12, -10);
}
 
integer menuindex;
list LastList;
list Ensure(list A)
{
    LastList=A;
    list NList=A;
    integer i = 0;
    integer b = llGetListLength(NList);
    for(i=0;i<b;i++)
    {
        NList =llListReplaceList(NList, [llGetSubString(llList2String(NList,i),0,22)], i,i);
    }
    return NList;
}
integer IsMenu(string a)
{
    integer i =0;
    integer end = llGetListLength(LastList);
    for(i=0;i<end;i++)
    {
        if(llGetSubString(llList2String(LastList,i),0,22)==a)
        {
            return TRUE;
        }
    }
    return FALSE;
}

integer ParseMenu(string a)
{
    integer i=0;
    integer end=llGetListLength(LastList);
    for(i=0;i<end;i++)
    {
        if(llGetSubString(llList2String(LastList,i),0,22)==a)
        {
            return i;
        }
    }
    return FALSE;
}
Dialog(key avatar, string message, list buttons, integer channel, integer CurMenu)
{
    if (12 < llGetListLength(buttons))
    {
        list lbut = buttons;
        list Nbuttons = [];
        if(CurMenu == -1)
        {
            CurMenu = 0;
            menuindex = 0;
        }
 
        if((Nbuttons = (llList2List(buttons, (CurMenu * 10), ((CurMenu * 10) + 9)) + ["<--", "-->"])) == ["<--", "-->"]){
            Nbuttons = Ensure(Nbuttons);
            menuindex=0;
            Dialog(avatar, message, lbut, channel, menuindex);
        }else{
            Nbuttons = Ensure(Nbuttons);
            llDialog(avatar, message,  order_buttons(Nbuttons), channel);
        }
    }
    else{
        buttons = Ensure(buttons);
        llDialog(avatar, message,  order_buttons(buttons), channel);
    }
}
integer GLC;
integer GenerateChannel()
{
    //debugf(TRUE, "GenerateChannel", []);
    GLC = llRound(llFrand(5748367));
    //debug("Channel Generated Successfully: "+(string)GLC);
    //debugf(FALSE, "GenerateChannel", []);
    return GLC;
}
integer DEBUG_LEVEL = 100;    // set to > 0 if you want to show debug messages of 
string DEBUG_MODE="Private";   // level <= DEBUG_LEVEL (see the DEBUGN() function)
                            // set to 0 for no debug at all
                            // here 5 and upper will show function calls

integer nIndent = 0;    // indentation for debugging purposes
debug (string msg) {
    // Won't do anything if DEBUG_LEVEL == 0
    if (DEBUG_LEVEL) debugn (1, msg);
}



debugn (integer level, string msg) {
    // Choose a level <= DEBUG_LEVEL to display the message
    // The levels used in this template are totally arbitrary, but
    // the lower the more important the debug message
    // Debug messages are indented according to nIndent, which changes
    // when calling DEBUGF()
    if (DEBUG_LEVEL && level <= DEBUG_LEVEL) {
        string indent = "";
        integer i;
        for (i=0; i<nIndent; ++i) {
            indent = indent + "|       ";
        }
    if(DEBUG_MODE=="Private"){
            llOwnerSay ( llGetScriptName() + "   " + indent + msg 
            + "   <lvl " + (string)level + ", " + (string)llGetFreeMemory() + " b>");
        } else {
                llSay(0, llGetScriptName() + "   " + indent  + msg + "   <lvl " + (string)level + ", "+ (string)llGetFreeMemory()+" b>");
        }
    }
}

debugf (integer entering, string functionName, list params) {
    // Call this when entering or exiting a function
    // If entering == 1, indents and displays "enter"
    // Else if entering == 0, unindents and displays "leave"
    // Else it doesn't change indentation
    if (DEBUG_LEVEL) {
        string hdr = "";
        if (entering == 1) {
            hdr = "ENTER ";
        }
        else if (entering == 0) {
            hdr = "LEAVE ";
            if (nIndent > 0) --nIndent;
        }
        debugn (5, hdr + functionName + " (" + llList2CSV (params) + ")");
        if (entering == 1) ++nIndent;
    }
}
string lbl(string btn, integer flag)
{
    if (flag) return ("[*]"+btn);
    else return ("[ ]"+btn);
}
string tf(integer t)
{
    if(t) return " true ";
    else return " false ";
}


key User;
integer GLCX;
integer iAgeKick=FALSE;
integer iKickAge; // The age to kick
string mode;
integer DebugMode;
integer ListMode;
integer iScriptKick;
float fScriptCPU;
integer iMaxScript;
integer iScriptMem;
integer iTimerEvent=30;
integer iGroupImmunity;
integer region;
integer iComplexityKick;
integer MaxComplexityCost;
integer parcel;
integer lstn;
LoadSettings(string m){
    // currently none to load
    list x = llParseStringKeepNulls(m,[","],[]);
    integer opts=llList2Integer(x,0);
    if(opts&1){
        iAgeKick=TRUE;
        iKickAge=llList2Integer(x,1);
    } 
    
    if(opts&2){
        parcel=1;
        region=0;
    }
    if(opts&4){
        parcel=0;
        region=1;
    }
    
    if(opts&8) DebugMode=1;
    
    
    
    if(opts&32){
        iScriptKick=TRUE;
        fScriptCPU=llList2Float(x,2);
        iMaxScript=llList2Integer(x,3);
        iScriptMem = llList2Integer(x,4);
    }
    
    if(opts&64) iGroupImmunity=TRUE;
    
    if(opts&128) iTimerEvent=llList2Integer(x,5);
    
    if(opts&256){
        iComplexityKick=TRUE;
        MaxComplexityCost=llList2Integer(x,6);
    }
    
    if(opts&512){
        g_iTagImmune = TRUE;
        g_sTag = llList2String(x,7);
    }
    
    if(opts&1024){
        // Kick by area size
        g_iAreaKick = TRUE;
        g_iArea = (integer)llList2String(x,8);
    }
    
    
    if(opts&2048){
        // ban
        g_iBan = TRUE;
        g_fBanTime = (float)llList2String(x,9);
    }
    
    if(opts&4096){
        g_iWhiteListOnly=TRUE;
    }
    
    if(opts&8192){
        g_iNotifyActions=TRUE;
    }
    
    if(opts&16384){
        g_iAutoReturn = TRUE;
    }
}
integer g_iTagImmune;
integer g_iAutoReturn;
string g_sTag="X";
integer g_iAreaKick;
integer g_iArea;
integer g_iBan;
float g_fBanTime;

integer g_iWhiteListOnly;
integer g_iNotifyActions;

Menu(key uid, string path){
    string MenuText="ZNI Productions\nSecurity Orb\n===========\n* Choose your options!";
    list Buttons;
    if(path == "main"){
        // build main menu using settings!
        MenuText+="\n=> Main Menu <=";
        Buttons = [lbl("Age", iAgeKick), "Finish", lbl("Region",region), lbl("Parcel",parcel), lbl("Debug",DebugMode), lbl("ScriptKick", iScriptKick), lbl("Group Immune", iGroupImmunity), "Set Timer", lbl("Complexity", iComplexityKick), lbl("TagImmune", g_iTagImmune), lbl("Area", g_iAreaKick), "NEXT"];

//lbl("Ban", g_iBan)];
        mode="dialog";
    } else if(path == "main2"){
        MenuText += "\n=> Page 2 <=";
        Buttons = [lbl("Ban", g_iBan), "BACK", lbl("List Only", g_iWhiteListOnly), lbl("NotifyActions", g_iNotifyActions), lbl("AutoReturn", g_iAutoReturn)];
        
        mode = "dialog2";
    }
    
    GenerateChannel();
    llListenRemove(lstn);
    lstn=llListen(GLC,"",uid,"");
    Dialog(uid,MenuText,Buttons,GLC,menuindex);
}

string Settings(){
    list ret =[0,0,0,0,0,0,"X",0,0];
    integer opts;
    if (iAgeKick){
        opts+=1;
        ret=llListReplaceList(ret,[iKickAge],1,1);
    }
    if(parcel){
        if(region)region=FALSE;
        opts+=2;
    }
    
    if(region){
        if(parcel)parcel=FALSE;
        opts+=4;
    }
    if(DebugMode) opts+=8;
    
    if(iScriptKick){
        opts+=32;
        ret=llListReplaceList(ret, [fScriptCPU,iMaxScript,iScriptMem], 2,4);
    }
    if(iGroupImmunity)opts+=64;
    
    if(iTimerEvent!=30){
        opts+=128;
        ret=llListReplaceList(ret,[iTimerEvent],5,5);
    }
    
    if(iComplexityKick){
        opts+=256;
        ret=llListReplaceList(ret,[MaxComplexityCost],6,6);
    }
    
    if(g_iTagImmune){
        opts+=512;
        ret = llListReplaceList(ret, [g_sTag], 7,7);
    }
    
    if(g_iAreaKick){
        opts+=1024;
        ret = llListReplaceList(ret,[g_iArea],8,8);
    }
    
    if(g_iBan){
        opts += 2048;
        ret = llListReplaceList(ret, [g_fBanTime],9,9);
    }
    
    if(g_iWhiteListOnly){
        opts+=4096;
    }
    
    if(g_iNotifyActions)
    {
        opts += 8192;
    }
    
    if(g_iAutoReturn){
        opts += 16384;
    }
    
    
    ret=llListReplaceList(ret,[opts],0,0);
    
    //llSay(0,"Replaced List Entry 0 with "+(string)opts);
    
    return llDumpList2String(ret,",");
}
default
{
    on_rez(integer t){
        GLCX=t;
        llListen(t, "", "", "");
        
    }
    state_entry(){
        llSetText("", ZERO_VECTOR,1);
    }
    listen(integer c,string n,key i,string m){
        // This should be a uuid!!
        User=(key)m;
        llSetText("Menu is being configured by "+llKey2Name((key)m),<1,0,0>,1);
        state getSettings;
    }
}
state getSettings{
    state_entry(){
        //llSay(0, (string)GLCX);
        llListen(GLCX,"","","");
        llSay(GLCX, "downloadSettingsCSV");
    }
    listen(integer c,string n,key i,string m){
        LoadSettings(m);
        state MenuHandler;
        
    }
}
state MenuHandler{
    state_entry(){
        Menu(User,"main");
    }
    listen(integer c,string n,key i,string m){
        string mm = llList2String(LastList,ParseMenu(m));
        
        if(mode=="dialog") jump mainmenuChoices;
        else if(mode == "age") jump ageGet;
        else if(mode=="scriptcpu") jump getScriptCPU;
        else if(mode=="maxscript") jump getScriptMax;
        else if(mode=="getscriptmem") jump getScriptMem;
        else if(mode=="getTimer") jump getTimer;
        else if(mode == "getComplexity") jump getComplex;
        else if(mode == "getTag") jump getTag;
        else if(mode == "getArea") jump getArea;
        else if(mode == "getBanTime") jump getBan;
        else if(mode == "dialog2")jump page2Choices;
        
        
        @mainmenuChoices;
        if(mm == "Finish"){
            llSay(GLCX, "uploadsettings|"+Settings());
            llDie();
        } else if(mm == lbl("Age",iAgeKick)){
            iAgeKick=1-iAgeKick;
            if(iAgeKick){
                mode="age";
                llTextBox(User, "Please enter the minimum age allowed on parcel",GLC);
                jump ov;
            }
        } else if(mm == lbl("Parcel",parcel)){
            if(parcel){
                parcel=FALSE;
                region=TRUE;
            } else {
                parcel=TRUE;
                region=FALSE;
            }
        } else if(mm == lbl("Region",region)){
            if(region){
                region=FALSE;
                parcel=TRUE;
            } else{
                region=TRUE;
                parcel=FALSE;
            }
        } else if(mm == lbl("Debug",DebugMode)){
            DebugMode=1-DebugMode;
        } else if(mm == lbl("Group Immune", iGroupImmunity)){
            iGroupImmunity=1-iGroupImmunity;
        } else if(mm == lbl("ScriptKick",iScriptKick)){
            iScriptKick=1-iScriptKick;
            if(iScriptKick){
                mode="scriptcpu";
                llTextBox(User,"Enter the max script cpu usage allowable", GLC);
                jump ov;
            }
        } else if(mm=="Set Timer"){
            mode="getTimer";
            llTextBox(User,"Enter the new number of seconds between each sim scan", GLC);
            jump ov;
        } else if(mm == lbl("Complexity", iComplexityKick)){
            iComplexityKick=1-iComplexityKick;
            if(iComplexityKick){
                mode="getComplexity";
                llTextBox(User,"Enter the maximum complexity allowed within the radius.", GLC);
                jump ov;
            }
        } else if(mm == lbl("TagImmune", g_iTagImmune)){
            g_iTagImmune=1-g_iTagImmune;
            if(g_iTagImmune){
                mode="getTag";
                llTextBox(User,"Enter the tag - case sensitive - that you want to be immune to kicks", GLC);
                jump ov;
            } else {
                g_sTag="X";
            }
        } else if(mm == lbl("Area", g_iAreaKick)){
            g_iAreaKick=1-g_iAreaKick;
            if(g_iAreaKick){
                mode="getArea";
                llTextBox(User, "Enter the area  -  this is a spherical zone measured in meters away from this object", GLC);
                jump ov;
            } else {
                g_iArea=0;
            }
        } else if(mm == "NEXT"){
            jump page2;
        }
        jump mainmenu;
        
        @mainmenu;
        Menu(User,"main");
        jump ov;
        
        @page2Choices;
        if(mm == lbl("Ban", g_iBan)){
            g_iBan=1-g_iBan;
            if(g_iBan){
                mode="getBanTime";
                llTextBox(User, "Enter the length of time in hours for the ban.\n\n=> Note: For permanent or indefinite bans, enter 0\n=> For 1 and a half hours: 1.5", GLC);
                jump ov;
            } else g_iBan=0;
        } else if(mm == "BACK"){
            jump mainmenu;
        } else if(mm == lbl("List Only", g_iWhiteListOnly))g_iWhiteListOnly=1-g_iWhiteListOnly;
        else if(mm == lbl("NotifyActions", g_iNotifyActions))g_iNotifyActions=1-g_iNotifyActions;
        else if(mm == lbl("AutoReturn", g_iAutoReturn))g_iAutoReturn=1-g_iAutoReturn;
        
        jump page2;
        
        @page2;
        Menu(User, "main2");
        jump ov;
        
        @ageGet;
        iKickAge = (integer)m;
        llInstantMessage(User, "Confirmed! We will kick anyone below "+(string)iKickAge + " days old");
        jump mainmenu;
        
        @getScriptCPU;
        fScriptCPU=(float)m;
        mode="maxscript";
        llTextBox(User,"Enter the max number of scripts allowed to be running",GLC);
        jump ov;
        
        @getScriptMax;
        iMaxScript = (integer)m;
        mode="getscriptmem";
        llTextBox(User,"Enter the max amount of Script Memory allowed. In kilobytes",GLC);
        jump ov;
        
        @getScriptMem;
        iScriptMem=((integer)m*1024);
        jump mainmenu;
        
        @getTimer;
        iTimerEvent=(integer)m;
        jump mainmenu;
        
        @getComplex;
        MaxComplexityCost=(integer)m;
        jump mainmenu;
        
        @getTag;
        g_sTag = m;
        jump mainmenu;
        
        @getArea;
        g_iArea=(integer)m;
        jump mainmenu;
        
        
        @getBan;
        g_fBanTime = (integer)m;
        jump page2;
        
        @o;
        llListenRemove(lstn);
        @ov;
        
    }
        
}