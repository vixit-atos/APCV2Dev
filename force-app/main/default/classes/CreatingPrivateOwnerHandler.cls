global class CreatingPrivateOwnerHandler

{
global static void CreatingPrivateOwner(List<Account> PriOWnNewtLst){
        
        List<Private_Ownership__c> PriOwnInsertLst = new List<Private_Ownership__c>();
        Private_Ownership__c pri;
        
         map<String,String> UserRoleName = new map<string,String>();
        Map<String,String> OwnernameIds = new Map<String,String>();
        for(User u: [select id,UserRole.name,Name,UserRoleid from user where isactive = true and Userrole.name like 'STC%']){
            if(u.Userrole.name!=null)
                UserRoleName.put(u.id,u.Userrole.name);
            OwnernameIds.put(u.Userrole.name,U.id);
            
        }
            for(Account acc: PriOWnNewtLst){
           if(UserRoleName.get(acc.ownerid)!=null)
                    if(OwnernameIds.containskey(UserRoleName.get(acc.ownerid))){
                pri =new Private_Ownership__c(Account__c = acc.id,name = acc.name);
                PriOwnInsertLst.add(pri);
            }
        }
        if(PriOwnInsertLst!=null)
        Insert PriOwnInsertLst;
        
        
    }
    
   
    global static void UpdatinPrivateownerGroupName(List<Private_Ownership__c> PriOWnNewtLst){
        
        map<String,String> UserRoleName = new map<string,String>();
        Map<String,String> OwnernameIds = new Map<String,String>();
        for(User u: [select id,UserRole.name,Name,UserRoleid from user where isactive = true]){
            if(u.Userrole.name!=null)
                UserRoleName.put(u.id,u.Userrole.name);
            OwnernameIds.put(u.Name,U.id);
            System.debug(UserRoleName);
            
            
            
            for(Private_Ownership__c pown: PriOWnNewtLst){
                // System.debug(pown.ownerid);
                // System.debug(UserRoleName.get(pown.ownerid));
                if(UserRoleName.get(pown.ownerid)!=null){
                    if(UserRoleName.get(pown.ownerid).containsIgnoreCase('STC Charlotte'))
                        pown.Private_Owner_Group_name__c = 'STC Charlotte';
                    if(UserRoleName.get(pown.ownerid).containsIgnoreCase('STC Cleveland'))
                        pown.Private_Owner_Group_name__c = 'STC Cleveland';
                    if(UserRoleName.get(pown.ownerid).containsIgnoreCase('STC Kansas City'))
                        pown.Private_Owner_Group_name__c = 'STC Kansas City';
                    if(UserRoleName.get(pown.ownerid).containsIgnoreCase('STC Louisville'))
                        pown.Private_Owner_Group_name__c = 'STC Louisville';
                    if(UserRoleName.get(pown.ownerid).containsIgnoreCase('STC New England'))
                        pown.Private_Owner_Group_name__c = 'STC New England';
                    if(UserRoleName.get(pown.ownerid).containsIgnoreCase('STC Tampa'))
                        pown.Private_Owner_Group_name__c = 'STC Tampa';// STC Toronto
                    
                    if(UserRoleName.get(pown.ownerid).containsIgnoreCase('STC Toronto'))
                        pown.Private_Owner_Group_name__c = 'STC Toronto';  
                }      
                
                
            }
        }
    } 
    global static void CreatingSTC_OwnerRecords(List<Private_Ownership__c> PriOWnNewtLst){
        
        map<String,String> UserRoleName = new map<string,String>();
        map<String,STC_Ownership__c> MapUplist = new Map<String,STC_Ownership__c>();
        map<String,STC_Ownership__c> STCmap = new map<String,STC_Ownership__c>();
        Map<String,String> OwnernameIds = new Map<String,String>();
        for(User u: [select id,UserRole.name,Name,UserRoleid from user where isactive = true]){
            if(u.Userrole.name!=null)
                UserRoleName.put(u.id,u.Userrole.name);
            OwnernameIds.put(u.Name,U.id);
            
        }
        STC_Ownership__c sto = new STC_Ownership__c();
        String STCname,Accountid;
        for(Private_Ownership__c p: PriOWnNewtLst){
            if(MapUplist.keyset().size()>0){
                for( STC_Ownership__c st: MapUplist.values()){
                    if(p.Private_Owner_Group_name__c!=null && st.Account_STC_Name__c!=null) 
                        if(STCname == p.Private_Owner_Group_name__c && Accountid == p.Account__c){
                            
                        }
                    else{
                        // if(p.Private_Owner_Group_name__c = 'STC Charlete')
                        // )
                        sto= new STC_Ownership__c(Private_Ownership__c = p.id,Account_STC_Name__c = p.Private_Owner_Group_name__c,Account__C = p.Account__c);
                        MapUplist.put(p.id,sto);
                    }
                }
            }
            else
            {
                sto= new STC_Ownership__c(Private_Ownership__c = p.id,Account_STC_Name__c = p.Private_Owner_Group_name__c,Account__C = p.Account__c);
                MapUplist.put(p.id,sto);   
            }
            if(p.Private_Owner_Group_name__c!=null) 
                STCname = p.Private_Owner_Group_name__c;
            if(p.Account__c!=null)
                Accountid = p.Account__c;
        }
        system.debug(MapUplist.values());
        
        List<STC_Ownership__c> removDupli =new list<STC_Ownership__c >();
        List<STC_Ownership__c> Updateowners =new list<STC_Ownership__c >();
        String STCname1,Accountid1;
        
        List<String> ids = new list<String>();
        Database.SaveResult[] srList = Database.Insert(MapUplist.values(),true);
        for (Database.SaveResult sr : srList) {
            
            if (sr.isSuccess()) 
                ids.add(sr.getId());
        }   
        LIst<STC_Ownership__c> STclist = [select id,Private_Ownership__c ,Account__r.Private_Ownership_List1_Name__c,Account__r.Owner.name,Ownerships1__c,Ownerships__c,Account__C,Account_STC_Name__c from STC_Ownership__c where id = :ids order by Account__r.name];
        
        
        for(STC_Ownership__c s: STclist)
        {
            
            String StrResul;
            String strOnwerNames = s.Account__r.Owner.name;
            List<String> strnames =new List<String>();
            system.debug(s.Ownerships__c);
            if(s.Ownerships__c !=null){
            strnames = String.valueoF(s.Ownerships__c).Split(',');
            }else{ 
            if(s.Account__r.Owner.name!='CRM API Admin'){
            strnames = String.valueoF(s.Account__r.Owner.name).Split(',');
            }else{
                if(s.Account__r.Private_Ownership_List1_Name__c!=null)
                strnames = String.valueoF(s.Account__r.Private_Ownership_List1_Name__c).Split(',');
                }
              }  
            if(strnames.size()>0){
                for(String s1:strnames){
                    if(UserRoleName.get(OwnernameIds.get(s1))!=null)
                        if(s.Account_STC_Name__c!=null)
                        if(UserRoleName.get(OwnernameIds.get(s1)).containsIgnoreCase(s.Account_STC_Name__c)){
                            StrResul = s1;
                            if(s.Ownerships1__c!=null)
                                s.Ownerships1__c = s.Ownerships1__c+','+s1+',';
                            else
                                s.Ownerships1__c = s1;
                        }
                }
                Updateowners.add(s);
            }
        }
        
        update Updateowners;
        for(STC_Ownership__c s: STclist )
        {
            
            if(STCname1== s.Account_STC_Name__c && Accountid1 ==s.Account__C)
                removDupli.Add(s);
            STCname1 = s.Account_STC_Name__c;
            Accountid1 = s.Account__C;
        }
        delete removDupli;
        
    } 
    
    
}