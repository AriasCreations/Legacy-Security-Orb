default
{
    link_message(integer s,integer n,string m,key i){
        if(n == -90){
            list x = llParseString2List(m,["|"],[]);
            if(llList2String(x,0)=="action"){
                if(llList2String(x,1)=="eject"){
                    llEjectFromLand((key)llList2String(x,2));
                    //llTeleportAgentHome((key)llList2String(x,2));
                } else if(llList2String(x,1) == "ban"){
                    llAddToLandBanList((key)llList2String(x,2), llList2Float(x,3));
                    if(llList2String(x,3) != "0")
                        llInstantMessage((key)llList2String(x,2), "You are banned for: "+llList2String(x,3)+" hours.");
                    else llInstantMessage((key)llList2String(x,2), "You are banned for a indefinite period of time. If you know the land owner you may appeal the ban to them");
                }
            } else if(llList2String(x,0)=="message"){
                llInstantMessage(llList2Key(x,1), llDumpList2String(llList2List(x,2,-1),"|"));
            }
        }
    }
}

