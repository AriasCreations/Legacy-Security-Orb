integer DEBUG_LEVEL = 100;    // set to > 0 if you want to show debug messages of 
string DEBUG_MODE="Private";   // level <= DEBUG_LEVEL (see the DEBUGN() function)
                            // set to 0 for no debug at all
                            // here 5 and upper will show function calls
list g_lWhitelist;
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
integer GLC;
integer GenerateChannel()
{
    //debugf(TRUE, "GenerateChannel", []);
    GLC = llRound(llFrand(5748367));
    //debug("Channel Generated Successfully: "+(string)GLC);
    //debugf(FALSE, "GenerateChannel", []);
    return GLC;
}


list auth;
integer lstn;
integer iAgeKick;
integer debugMode;
integer ListMode = AGENT_LIST_PARCEL;
integer iAgeKick_Age;
list ageReq;
integer line;
key AdminReq;
list Admins;
integer iScriptKick;
float fScriptCPU;
integer iMaxScript;
integer iGroupImmunity;
integer iScriptMem;
integer iComplexityKick;
integer MaxComplexityCost;
integer g_iTagImmune;
string g_sTag="X";
integer g_iAreaKick;
integer g_iArea;
integer g_iBan=FALSE;
float g_fBanTime;
integer g_iListOnly;
integer g_iNotifyActions;
integer GetAuth(key id){
    if(llGetOwner()==id) return TRUE;
    if(llGetInventoryCreator(llGetScriptName()))return TRUE;
    if(llListFindList(Admins,[llToLower(llKey2Name(id))])!=-1)return TRUE;
    return FALSE;
}
string Settings(){
    string Scan;
    if(ListMode==AGENT_LIST_PARCEL)Scan="List: Parcel";
    else if(ListMode==AGENT_LIST_REGION)Scan="List: Region";
    llSay(0, "Scan Mode: "+Scan);
    llSay( 0,"AgeKick: "+tf(iAgeKick)+"\nAge: "+(string)iAgeKick_Age+"\nDebug: "+tf(debugMode));
    llSay(0, "ScriptKick: "+tf(iScriptKick)+"\nCPU: "+(string)fScriptCPU+"\nMax Running Scripts: "+(string)iMaxScript+"\nMEMORY: "+(string)iScriptMem);
    llSay(0, "Timer Event: "+(string)iTimerEvent);
    llSay(0, "Complexity: "+(string)tf(iComplexityKick)+"\nKick AT Complexity: "+ (string)MaxComplexityCost);
    llSay(0, "Tag Immune: "+tf(g_iTagImmune)+"\nTag: "+g_sTag);
    llSay(0, "Group Immune: "+tf(iGroupImmunity));
    llSay(0, "Area Kick: "+tf(g_iAreaKick)+"\nArea: "+(string)g_iArea);
    llSay(0, "Ban: "+tf(g_iBan)+"\nBan Time (in hours): "+(string)g_fBanTime);
    llSay(0, "Notify Admins of actions: "+tf(g_iNotifyActions));
    llSay(0, "Whitelist ONLY: "+tf(g_iListOnly));
    llSay(0, "Return Kicked users' objects: "+tf(g_iAutoReturn));
    return "";
}
integer g_iAutoReturn;
integer iTimerEvent=30;
LoadSettings(){
    string m = llGetObjectDesc();
    list x = llParseStringKeepNulls(m,[","],[]);
    integer opts= llList2Integer(x,0);
    if(opts&1){
        iAgeKick=TRUE;
        iAgeKick_Age=llList2Integer(x,1);
    }
    if(opts&2){
        ListMode=AGENT_LIST_PARCEL;
    }
    if(opts&4){
        ListMode=AGENT_LIST_REGION;
    }
    if(opts&8){
        debugMode=TRUE;
    }
    
    
    if(opts&32){
        iScriptKick=TRUE;
        fScriptCPU=llList2Float(x,2);
        iMaxScript=llList2Integer(x,3);
        iScriptMem=llList2Integer(x,4);
    }
    
    if(opts&64){
        iGroupImmunity=TRUE;
    }
    
    if(opts&128){
        iTimerEvent=llList2Integer(x,5);
        llSetTimerEvent(iTimerEvent);
    }
    
    if(opts&256){
        iComplexityKick = TRUE;
        MaxComplexityCost = (integer)llList2String(x,6);
    }
    
    if(opts&512){
        g_iTagImmune = TRUE;
        g_sTag = llList2String(x,7);
    }
    
    if(opts&1024){
        g_iAreaKick=TRUE;
        g_iArea = (integer)llList2String(x,8);
    }
    
    if(opts&2048){
        g_iBan = TRUE;
        g_fBanTime = (float)llList2String(x,9);
    }
    
    if(opts & 4096)g_iListOnly = TRUE;
    if(opts & 8192)g_iNotifyActions=TRUE;
    
    if(opts & 16384){
        llRequestPermissions(llGetOwner(), PERMISSION_RETURN_OBJECTS);
        g_iAutoReturn=TRUE;
    }
}
d(string m){
    if(debugMode){
        llSay(0, "Script: "+(string)llGetScriptName()+" ["+(string)llGetFreeMemory()+"] - "+m);
    }
}
list UserTicks=[];
integer Tick(key id){
    
    if(llListFindList(UserTicks,[id])==-1)UserTicks+=[id,6];
    list Entry  =  llList2List(UserTicks,llListFindList(UserTicks,[id]), llListFindList(UserTicks,[id])+1);
    integer TICK = llList2Integer(Entry,1);
    if(TICK<=0){
        d("Tick is up.");
        UserTicks=llDeleteSubList(UserTicks, llListFindList(UserTicks,[id]),llListFindList(UserTicks,[id])+1);
        return TRUE;
    }
    else{
        d("Ticking");
        TICK--;
        Entry=llListReplaceList(Entry,[TICK],1,1);
        UserTicks=llListReplaceList(UserTicks, Entry, llListFindList(UserTicks,[id]), llListFindList(UserTicks,[id])+1);
        return FALSE;
    }
}

string tf(integer t){
    if(t)return "True";
    else return "False";
}
list agent_list;
integer date2days(string data)
{
    integer result;
    list parse_date = llParseString2List(data, ["-"], []);
    integer year = llList2Integer(parse_date, 0);
 
    result = (year - 2000) * 365; // Bias Number to year 2000 (SL Avatars Born After Date)
    list days = [ 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334 ];
 
    result += llList2Integer(days, (llList2Integer(parse_date, 1) - 1));
 
    //Fixed the leap year calculation below  ~Casper Warden, 28/10/2015.
    //if (year/4 == llRound(year/4)) result += 1;
    result += llFloor((year-2000) / 4);
 
    result += llList2Integer(parse_date, 2);
 
    return result;
}
key g_kWhitelistReader;
integer g_iWhitelistLine;

string getKickStr(){
    if(g_iBan)return "ban";
    else return "eject";
}

string getKickExtra(){
    if(g_iBan)return "|"+(string)g_fBanTime+"|"+(string)g_iAutoReturn;
    else return "|0|"+(string)g_iAutoReturn;
}


default
{
    state_entry(){
        //llSetText("**Reading Settings**",<1,0,0>,1);
        LoadSettings();
        
        llSleep(2);
        
        
        DEBUG_LEVEL=0;
        line=0;
        AdminReq=llGetNotecardLine("Admins",line);
    }
    on_rez(integer t){
        llResetScript();
    }
    touch_start(integer t){
        llResetTime();
    }
    
    timer(){
        // Age kick is ZERO Tick
        d("Tick!");
        list AGENTS = llGetAgentList(ListMode,[]);
        integer i=0;
        integer end=llGetListLength(AGENTS);
        integer Ticked=FALSE;
        for(i=0;i<end;i++){
            // Begin to detect  now
            integer detick=FALSE;
            if(iGroupImmunity && llSameGroup(llList2Key(AGENTS,i))) jump out;
            if(g_iTagImmune && llList2String(llGetObjectDetails(llList2Key(AGENTS,i), [OBJECT_GROUP_TAG]),0) == g_sTag) jump out;
            if(llListFindList(g_lWhitelist, [llToLower(llKey2Name(llList2Key(AGENTS,i)))])!=-1)jump out;

            if(llListFindList(Admins, [llToLower(llKey2Name(llList2Key(AGENTS,i)))])!=-1)jump out; // admins are immune


            // check if on list only mode
            if(g_iListOnly && llListFindList(g_lWhitelist, [llToLower(llKey2Name(llList2Key(AGENTS,i)))]) == -1) {
                Ticked=TRUE;
                if(Tick(llList2Key(AGENTS,i))){
                    llMessageLinked(LINK_SET,-90,"message|"+llList2String(AGENTS,i)+"|You are being ejected because: This security orb is whitelist only", "");
                    llMessageLinked(LINK_SET,-90,"action|"+getKickStr()+"|"+llList2String(AGENTS,i)+getKickExtra(),"");
                }else{
                    llMessageLinked(LINK_SET,-90,"message|"+llList2String(AGENTS,i)+"|To avoid eject, teleport or leave the parcel now", "");
                }
            } else detick=TRUE;
            if(iAgeKick){
                ageReq+=[llRequestAgentData(llList2Key(AGENTS,i),DATA_BORN), llList2Key(AGENTS,i)];
                d("Requested agent age");
            }
            
            if(g_iAreaKick){
                float distance = llVecDist((vector)llList2String(llGetObjectDetails(llList2Key(AGENTS,i),[OBJECT_POS]),0), llGetPos());
                
                if(distance <= g_iArea){
                    Ticked=TRUE;
                    d(llKey2Name(llList2Key(AGENTS,i))+" is within zone");
                    // Check Tick
                    if(Tick(llList2Key(AGENTS,i))){
                        llMessageLinked(LINK_SET,-90,"message|"+llList2String(AGENTS,i)+"|You are being ejected because you entered a restricted area", "");
                        llMessageLinked(LINK_SET, -90, "action|"+getKickStr()+"|"+llList2String(AGENTS,i)+getKickExtra(),"");
                    }else{
                        llMessageLinked(LINK_SET,-90, "message|"+llList2String(AGENTS,i)+"|To avoid being ejected, leave the area! You are in a restricted area", "");
                    }
                }else detick=TRUE;
            }
            
            if(iComplexityKick){
                list x = llGetObjectDetails(llList2Key(AGENTS,i), [OBJECT_RENDER_WEIGHT]);
                if(MaxComplexityCost<=llList2Integer(x,0)){
                    Ticked=TRUE;
                    if(Tick(llList2Key(AGENTS,i))){
                        llMessageLinked(LINK_SET,-90, "message|"+llList2String(AGENTS,i)+"|You are being sent home because your complexity is too high!\n Your complexity is: "+llList2String(x,0)+"\nAnd the Allowed maximum complexity is: "+(string)MaxComplexityCost, "");
                        llMessageLinked(LINK_SET,-90, "action|"+getKickStr()+"|"+llList2String(AGENTS,i)+getKickExtra(),"");
                    }else{
                        llMessageLinked(LINK_SET,-90,"message|"+llList2String(AGENTS,i)+"|To avoid being ejected for complexity you need to lower your render cost. This could include removing detailed attachments.", "");
                    }
                } else {
                    detick=TRUE;
                }
            }
                        
            if(iScriptKick){
                list x = llGetObjectDetails(llList2Key(AGENTS,i), [OBJECT_SCRIPT_TIME,OBJECT_SCRIPT_MEMORY,OBJECT_RUNNING_SCRIPT_COUNT]);
                //  check user script information
                // then perform ticks if they have in violation
                
                integer TickUser;
                if(fScriptCPU<=llList2Float(x,0)) TickUser=TRUE;
                if(iScriptMem<=llList2Integer(x,1)) TickUser=TRUE;
                if(iMaxScript<=llList2Integer(x,2))TickUser=TRUE;
                
                if(TickUser){
                    Ticked=TRUE;
                    if(Tick(llList2Key(AGENTS,i))){
                        // Send a message and kick
                        llMessageLinked(LINK_SET,-90,"message|"+llList2String(AGENTS,i)+"|You are being sent home because your script usage is too high! \nYour current CPU time is: "+llList2String(x,0)+". \nYou current script memory is: "+llList2String(x,1)+"\nYour current running script count is: "+llList2String(x,2),"");
                        llMessageLinked(LINK_SET,-90, "message|"+llList2String(AGENTS,i)+"|Here's the allowed script information.\nScript CPU time: "+(string)fScriptCPU+"\nScript Memory: "+(string)iScriptMem+"\nMax Scripts: "+(string)iMaxScript,"");
                    
                        llMessageLinked(LINK_SET, -90, "action|"+getKickStr()+"|"+llList2String(AGENTS,i)+getKickExtra(),"");
                    }else{
                        llMessageLinked(LINK_SET, -90, "message|"+llList2String(AGENTS,i)+"|You need to lower your script count, memory, or CPI to be within sim compliance.","");
                        llMessageLinked(LINK_SET,-90, "message|"+llList2String(AGENTS,i)+"|Here's the allowed script information.\nScript CPU time: "+(string)fScriptCPU+"\nScript Memory: "+(string)iScriptMem+"\nMax Scripts: "+(string)iMaxScript,"");
                        llMessageLinked(LINK_SET,-90,"message|"+llList2String(AGENTS,i)+"|If you do not lower it from the following then you will be removed from the sim! \nYour current CPU time is: "+llList2String(x,0)+". \nYou current script memory is: "+llList2String(x,1)+"\nYour current running script count is: "+llList2String(x,2),"");
                    }
                } else {
                    detick=TRUE;
                }
            }
            if(detick && !Ticked){
                
                if(llListFindList(UserTicks,[llList2Key(AGENTS,i)])!=-1){
                    // remove user tick
                    UserTicks=llDeleteSubList(UserTicks,llListFindList(UserTicks,[llList2Key(AGENTS,i)]), llListFindList(UserTicks,[llList2Key(AGENTS,i)])+1);
                    llMessageLinked(LINK_SET, -90, "message|"+llList2String(AGENTS,i)+"|Kick timer deactivated","");
                }
            }
            
            if(Ticked){
                if(g_iAutoReturn){
                    llReturnObjectsByOwner(llList2Key(AGENTS,i), OBJECT_RETURN_PARCEL);
                }
            }
            @out;
        }
        if(llGetFreeMemory()<=2000){
            llResetScript();
        }
        
    }
    changed(integer t){
        llResetScript();
    }
    dataserver(key r,string d){
        if(llListFindList(ageReq,[r])!=-1){
 
            integer today = date2days(llGetDate());
            integer age = date2days(d);
            key agent = llList2Key(ageReq, llListFindList(ageReq,[r])+1);
            string name = llKey2Name(agent);
            d("Age is "+(string)(today-age)+" for "+name);
            if(name!=""){
                if((today-age)<iAgeKick_Age){
                    llMessageLinked(LINK_SET, -90, "message|"+(string)agent+"|We are teleporting you home now because your avatar does not meet the required minimum age of "+(string)iAgeKick_Age, "");
                    llMessageLinked(LINK_SET,-90, "action|"+getKickStr()+"|"+(string)agent+getKickExtra(), "");
                    d("Perform action on user: EJECT for age");
                }
            }
            
            ageReq=llDeleteSubList(ageReq,llListFindList(ageReq, [r]), llListFindList(ageReq,[r])+1);
                    
        } else if(r==AdminReq){
            // Read the admins notecard
            if(d!=EOF){
                line++;
                
                Admins+=llToLower(d);
                AdminReq=llGetNotecardLine("Admins",line);
            
            }
            else{
                g_iWhitelistLine=0;
                g_lWhitelist=[];
                g_kWhitelistReader = llGetNotecardLine("WHITELIST", g_iWhitelistLine);
                if(llListFindList(Admins, [llToLower(llKey2Name(llGetOwner()))])==-1)
                    Admins+=llToLower(llKey2Name(llGetOwner()));
                llSetText("ZNI Creations\n>SECURITY ORB<\n====\n** Operational\n"+(string)llGetListLength(Admins)+" admins\n"+(string)llGetListLength(g_lWhitelist)+" whitelisted",<0,1,0>,1);
            }
        } else if(r == g_kWhitelistReader){
            if(d!=EOF){
                g_iWhitelistLine++;
                g_lWhitelist+=llToLower(d);
                g_kWhitelistReader = llGetNotecardLine("WHITELIST", g_iWhitelistLine);
            } else {
                // done
                //llSetText("ZNI Security Orb\n_______\n"+(string)llGetListLength(Admins)+" admins\n"+(string)llGetListLength(g_lWhitelist)+" whitelisted",<0,1,0>,1);
            }
        }
    }
    touch_end(integer t){
        if(llGetTime()>=2.5 && GetAuth(llDetectedKey(0))){
            GenerateChannel();
            lstn=llListen(GLC,"","", "");
            //llSay(0, "Listening on: "+(string)GLC);
            llSay(89,(string)GLC);//debug port
            llRezObject("1.1.2-MenuHandler", llGetPos()+<0,0,1>, ZERO_VECTOR, ZERO_ROTATION,GLC);
            llSleep(4);
            llSay(GLC, (string)llDetectedKey(0));
        } else {
                
            if(GetAuth(llDetectedKey(0))){
                llSleep(1);
                llSay(0, Settings());
                
                llGiveInventory(llDetectedKey(0), "WHITELIST");
                llGiveInventory(llDetectedKey(0), "Admins");
                
            }
        }
    }
    listen(integer c,string n,key i,string m){
        //llSay(0, m);
        list x = llParseString2List(m,["|"],[]);
        if(llList2String(x,0)=="downloadSettingsCSV"){
            llSleep(2);
            //llSay(0, "Menu configuration is being uploaded");
            llSay(c, llGetObjectDesc());
            
        } else if(llList2String(x,0)=="uploadsettings"){
            llSetObjectDesc(llList2String(x,1));
            // Upload means that the config is finished!
            llListenRemove(lstn);
            llResetScript();
        }
    }
    
    link_message(integer s,integer n,string m,key i){
        if(n == -90 && g_iNotifyActions){
            list lPar = llParseString2List(m,["|"],[]);
            if(llList2String(lPar,0) == "action"){
                llSay(-4390, "Action ("+llToUpper(llList2String(lPar,1))+"): secondlife:///app/agent/"+llList2String(lPar,2)+"/about - "+llGetDate());
            }
        }
    }
}
