list admins = [];

list g_lLastLogs=[];


list g_lDSRequests;
key NULL=NULL_KEY;
UpdateDSRequest(key orig, key new, string meta){
    if(orig == NULL){
        g_lDSRequests += [new,meta];
    }else {
        integer index = HasDSRequest(orig);
        if(index==-1)return;
        else{
            g_lDSRequests = llListReplaceList(g_lDSRequests, [new,meta], index,index+1);
        }
    }
}

string GetDSMeta(key id){
    integer index=llListFindList(g_lDSRequests,[id]);
    if(index==-1){
        return "N/A";
    }else{
        return llList2String(g_lDSRequests,index+1);
    }
}

integer HasDSRequest(key ID){
    return llListFindList(g_lDSRequests, [ID]);
}

DeleteDSReq(key ID){
    if(HasDSRequest(ID)!=-1)
        g_lDSRequests = llDeleteSubList(g_lDSRequests, HasDSRequest(ID), HasDSRequest(ID)+1);
    else return;
}



default
{
    state_entry()
    {
        llListen(-4390, "", "", "");
        llSetText("ZNI Security Orb\n____\nAction Log\nFree Memory: "+(string)llGetFreeMemory(), <1,0,0>,1);

        admins=[];
        
        UpdateDSRequest(NULL, llGetNotecardLine("config",0), "nc_read:0");
    }
    
    dataserver(key r,string d){
        //llSay(0, "Has DS Request: "+(string)HasDSRequest(r));
        if(HasDSRequest(r)!=-1){
            if(d==EOF){
                DeleteDSReq(r);
                llSay(0, "Memory initialization completed");
                llMessageLinked(LINK_SET, 22, "ready", "");
            } else {
                string meta = GetDSMeta(r);
                //llSay(0, "meta value: "+meta);
                list lTmp = llParseString2List(meta,[":"],[]);
                if(llList2String(lTmp,0)=="nc_read"){
                    integer iLine = (integer)llList2String(lTmp,1);
                    iLine++;
                    
                    //llSay(0, "NC Line: "+d);
                    if(llGetSubString(d,0,0)=="#"){}else{
                        integer index = llListFindList(admins, [d]);
                        if(index!=-1){
                            admins = llDeleteSubList(admins, index-1,index+1);
                        }
                        UpdateDSRequest(NULL, llRequestUserKey(d), "user_key:"+d);
                    }
                
                    UpdateDSRequest(r, llGetNotecardLine("config", iLine), "nc_read:"+ (string)iLine);
                } else if(llList2String(lTmp,0) == "user_key"){
                    llSay(0, "User Added: secondlife:///app/agent/"+d+"/about");
                    admins += [(key)d,llList2String(lTmp,1)];
                    DeleteDSReq(r);
                }
            }
        }
    }
    
    on_rez(integer t){
        llResetScript();
    }
    
    changed(integer t){
        if(t&CHANGED_REGION_START){
            llListen(-4390, "", "", "");
        } else if(t&CHANGED_INVENTORY){
            
            admins=[];
            
            UpdateDSRequest(NULL, llGetNotecardLine("config",0), "nc_read:0");
        }
    }
    
    touch_start(integer t){
        if(llListFindList(admins, [(string)llDetectedKey(0)])!=-1){
            integer ix=0;
            integer end = llGetListLength(g_lLastLogs);
            for(ix=0;ix<end;ix++){
                llRegionSayTo(llDetectedKey(0),0, llList2String(g_lLastLogs, ix));
            }
            
            llInstantMessage(llDetectedKey(0), "Resetting logger");
            llResetScript();
        }
    }
    
    listen(integer c,string n,key i,string m){
        integer ix = 0;
        integer end = llGetListLength(admins);
        for(ix=0;ix<end;ix++){
            key kID = (key)llList2String(admins,ix);
            if(kID)
                llInstantMessage(kID, m);
        }
        g_lLastLogs += m;
        
        llSetText("ZNI Security Orb\n____\nAction Log\nFree Memory: "+(string)llGetFreeMemory(), <1,0,0>,1);
    }
}
