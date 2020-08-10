public class EventTriggerHandler extends TriggerHandler {
    Set<String> qaSet;
    
    public EventTriggerHandler() {
        qaSet = new Set<String> {'Account.createPrivateEvent', 'Contact.createContactPrivateEvent'};
            }
    
    protected override void beforeInsert() {
        
    }
    protected override void beforeUpdate() {
        
    }
    protected override void afterInsert() {
        processAfter();
    }
    protected override void afterUpdate() {
        if (TriggerHandler.runOnce()){
            processAfter();
        }   
    }
    protected override void afterDelete() {
        processdelete();
    }
    
    /**********************************/
    /*****PROCESS AFTER START*********/
    /**********************************/    
    
    private void processAfter() {
        
        Contact cont = null;                                                                    // Stores the value of Contact  
        List<Private_Activity__c> PGAList = new List<Private_Activity__c>();                    // Stores the List of  Private Activities For DML operations    
        Map<String,Private_Activity__c> PGAUpdateMap = new Map<String,Private_Activity__c>();   // Stores the Private Activities for Update
        Set<String> PGAIds = new Set<String>();                                                 // Stores the IDs of Private Activities
        String UserProfilename = [select Name from profile where id = : userinfo.getProfileId() limit 1].name;
        Map<ID,String> mapAccountIDName = new Map<ID,String>();                                 // Stores the related Account Ids and Account Names
        Map<ID,String> mapContactIDName = new Map<ID,String>();                                 // Stores the related Contact Ids and Contact Names
        
        Map<ID,ID> initAcctEventMap = new Map<ID,ID>();                                         // Stores the related Account Ids
        
        Map<ID,ID> ContEventMap = new Map<ID,ID>();                                             // Stores the related Contact Ids
        List<Event> Incomingevents = new List<Event>();
        set<String> eventIds = new set<String>();        

        Private_Activity__c pa;                                                                 // Stores the Private Activity
        Map<id,Contact> ContMap = new Map <id,Contact>();                                       // Stores the related contacts
        
        String strPGAName;                                                                      // Stores the Private Activity Name
        String tempId; 
        String tempOwnerId;                                                                         // Stores the What Id
        
        Map<ID,Opportunity> mapOppIDName = new Map<ID,Opportunity>();
        Map<ID,ID> initOppEventMap = new Map<ID,ID>();
        
        Map<ID,Concession__c> mapConcIDName = new Map<ID,Concession__c>();
        Map<ID,ID> initConcEventMap = new Map<ID,ID>();        
        
        
        for(Event e1 : (List<Event>)Trigger.new)
        {   
            eventIds.add(e1.id);
            System.debug('**********'+eventIds);
            
        }
        if(eventIds.size() > 0)
            Incomingevents = new List<Event>([select Id, WhatId,what.name,What.type,EventSubtype,IsPrivate,IsAllDayEvent, Subject, StartDateTime, ActivityDate,Phone__c,Email__c, Contact__c, OwnerId,WhoId,AccountId   from Event Where Id=:eventIds ]);
        for(Event e : Incomingevents)
        {   
            System.debug('AN Check whoId: ' + e.WhoId
                         + ' whoid: ' + e.WhoId
                         + ' what: ' + e.WhatId
                         + ' id: ' + e.id
                         + ' Contact: ' + e.Contact__c
                         + ' WhatName: ' + e.what.name
                         + ' sybtype: ' + e.EventSubtype);         
            tempId = e.whatId;
            System.debug('CheckAN '+tempId);
            if(e.Contact__c == null && e.WhoId !=null)         // This section is due to Send An Email activity process.. 
            {
                e.Contact__c=  e.whoid ;
            }            
            if(e.Contact__c != null) // bulkification@satish
            {   
                ContEventMap.put(e.Id,e.Contact__c);
                // e.whoid=e.Contact__c;
            }
            if(tempId != null && tempId.substring(0,3) == '001')
            {
                initAcctEventMap.put(e.Id,e.whatId);
            }
            if(tempId != null && tempId.substring(0,3) == '006')
            {
                initOppEventMap.put(e.Id,e.whatId);
            }
            if(tempId != null && tempId.substring(0,3) == 'a0D')
            {
                initConcEventMap.put(e.Id,e.whatId);
            }
        }           
        System.debug('CheckANinitAcctEventList '+initAcctEventMap);
        System.debug('CheckANinitContEventList '+ContEventMap);
        if(ContEventMap.size() > 0) // bulkification@satish
        {
            String idString = '(\'';  
            for (String thisId : ContEventMap.values()) 
            {
                if(thisid!=null)
                    idString += thisId + '\',\'';
            }
            idString = idString.substring(0,idString.length()-2); //<--this is the bit I hate doing
            idString += ')';
            
            
            String contFields = 'SELECT ';
            for(Schema.FieldSetMember f : SObjectType.Contact.FieldSets.STC_Contact_Info.getFields()) 
                contFields += f.getFieldPath() + ',';
            
            
            SObjectType.Contact.FieldSets.STC_Contact_Info.getFields();
            ContMap = new Map<id,Contact>((List<Contact>)Database.Query(contFields+'Id,AccountId,Account.Name,Name from Contact where Id IN'+ idString)); // querying respective fields from the field set in contact. 
            
        }   
        
        if(initAcctEventMap.size() > 0)
            for(Account objPA : [select Id,Name from Account where Id IN : initAcctEventMap.values()])
        {
            mapAccountIDName.put(objPA.Id,objPA.Name);
        }
        if(ContMap.size() > 0)                                                   // If any Account is associated with the Contact.
            for(Contact objPA : [select Id,Name,AccountId,Account.Name from Contact where Id IN : ContMap.keySet()])
        {
            if (objPA.AccountId != null)
                mapAccountIDName.put(objPA.AccountId,objPA.Account.Name); 
        }
        if(ContEventMap.size() > 0)
            for(Contact objPA : [select Id,Name from Contact where Id IN : ContEventMap.values()])
        {   
            mapContactIDName.put(objPA.Id,objPA.Name);        
        }
        if(initOppEventMap.size() > 0)
            for(Opportunity objPA : [select Id,Name,AccountId from Opportunity where Id IN : initOppEventMap.values()])
        {   
            mapOppIDName.put(objPA.Id,objPA);        
        }
        if(initConcEventMap.size() > 0)
            for(Concession__c objPA : [select Id,Name,Account__c from Concession__c where Id IN : initConcEventMap.values()])
        {   
            mapConcIDName.put(objPA.Id,objPA);        
        } 
        
        System.debug('AN Check PArentNameMAp:');
        System.debug('********************'+initAcctEventMap);
        System.debug('********************'+ContEventMap);
        System.debug('********************'+mapAccountIDName);
        System.debug('********************'+mapContactIDName);
        
        /**********************************/
        /*****AFTER INSERT START**********/
        /**********************************/        
        /** Before Insert Process Start*/
        //if(Trigger.isInsert&&Trigger.isBefore){
        if(Trigger.isInsert){    
            
            for (Event e : Incomingevents) {
                
                System.debug('AN Check whoId: ' + e.WhoId
                             + ' whoid: ' + e.WhoId
                             + ' what: ' + e.WhatId
                             + ' id: ' + e.id
                             + ' Contact: ' + e.Contact__c
                             + ' WhatName: ' + e.what.name
                             + ' sybtype: ' + e.EventSubtype);
                
                tempId = e.whatId;  
                tempOwnerId= e.OwnerId;
                if(tempId <> null && tempId.substring(0,3) == '001'  )
                    strPGAName = 'PGA-' + mapAccountIDName.get(e.WhatId);
                else if(tempId <> null && tempId.substring(0,3) == '006')
                {
                    Opportunity testopp= mapOppIDName.get(e.WhatId);
                    strPGAName = 'PGA-' + testopp.Name;
                }
                else if(tempId <> null && tempId.substring(0,3) == 'a0D')
                {
                    Concession__c testConc= mapConcIDName.get(e.WhatId);
                    strPGAName = 'PGA-' + testConc.Name;
                }                                       
                else if((ContMap.Size() > 0) &&(e.contact__c!=null) && (ContMap.get(e.Contact__c).AccountId)!= null)            // If any Account is associated with the Contact.
                    strPGAName = 'PGA-' + mapAccountIDName.get(ContMap.get(e.Contact__c).AccountId);
                else  
                    strPGAName = 'PGA-' + mapContactIDName.get(e.Contact__c);
                System.debug(strPGAName);
                
                if(((tempId != null && tempId.substring(0,3) == '001') || (tempId == null) || (tempId != null && tempId.substring(0,3) == '006' ) || (tempId != null && tempId.substring(0,3) == 'a0D' ))&& e.IsPrivate == false && tempOwnerId.substring(0,3) != '023' ) {
                    pa = new Private_Activity__c();
                    pa.Name = strPGAName;
                    pa.Subject__c = e.Subject;
                    
                    TimeZone tz = UserInfo.getTimeZone(); 
                    if(e.IsAllDayEvent==true)
                    pa.Due_Date__c = DateTime.newInstance(e.StartDateTime.dateGMT(),e.StartDateTime.timeGMT());
                    else
                    pa.Due_Date__c = DateTime.newInstanceGMT(e.StartDateTime.dateGMT(),e.StartDateTime.timeGMT());
                    pa.Owner__c = e.OwnerId;
                    pa.Activity_ID__c = e.Id;
                    if(tempId != null && tempId.substring(0,3) == '006'){
                        Opportunity testopp = mapOppIDName.get(e.WhatId);
                        pa.Account__c=testopp.Accountid;
                    }
                    else if(tempId != null && tempId.substring(0,3) == 'a0D'){
                        Concession__c testConc= mapConcIDName.get(e.WhatId);
                        pa.Account__c=testConc.Account__c;
                    }
                    else                       
                        pa.Account__c = ContMap.get(e.Contact__c) != null && tempId == null ? ContMap.get(e.Contact__c).AccountId : tempId;       
                    pa.Account_Open_Activity_RL__c = pa.Account__c;
                    if(e.Contact__c != null) // Avoids assigning null value during update.
                    {
                        pa.Contact__c = e.Contact__c;
                        pa.Contact_RL__c = pa.Contact__c;
                    }
                    PGAList.add(pa);
                }
                
            }
            
            set<String> PgaIds1 = new set<String>();
            if(PGAList.size()>0){
                Database.SaveResult[] srList = Database.insert(PGAList);
                for (Database.SaveResult sr : srList)
                    PgaIds1.add(sr.getId());
            }
            list<Private_Activity__c> pgaList1 = [SELECT Id,Account__c,Contact__c,Activity_ID__c from Private_Activity__c where id=:PgaIds1]; 
            System.debug('**************'+pgaList1);
            for(Event e : Incomingevents){
                for(Private_Activity__c p:pgaList1){
                    if(p.Activity_ID__c==e.id){
                        if(e.whatid!=null && e.whatid == p.Account__c)
                        {
                            e.whatid = p.id;
                            system.debug('***************'+e.whatid+ e);
                        }
                        if(e.whatid==null && e.Contact__c!=null && e.Contact__c == p.Contact__c)
                        {
                            e.whatid = p.id;
                            system.debug('***************'+e.whatid + e);
                        }
                    }
                }
                if ( e.Contact__c != null) {
                    cont = ContMap.get(e.Contact__c);
                    String STCName;
                    if(UserProfilename.contains('STC')){
                        STCName = UserProfilename.substringAfterLast('STC').normalizeSpace();
                        for(Schema.FieldSetMember f : SObjectType.Contact.FieldSets.STC_Contact_Info.getFields()) 
                            // contFields += f.getFieldPath() + ',';
                            if(f.getFieldPath().replaceAll('_',' ').normalizeSpace().contains(STCName)){
                                if(f.getFieldPath().containsignoreCase('phone'))
                                    e.Phone__c = String.valueOf(cont.get(f.getFieldPath())!=null?cont.get(f.getFieldPath()):'');//(cont.Phone!=null?cont.Phone:'');     /** Assigning Phone number values from contacts @satish**/
                                if(f.getFieldPath().containsignoreCase('email'))
                                    e.Email__c = String.valueOf(cont.get(f.getFieldPath())!=null?cont.get(f.getFieldPath()):'');
                                // e.Email__c = (cont.Email!=null?cont.Email:'');  /** Assigning Email Address values from contacts @satish**/
                                
                            }
                    } 
                    else
                    {
                        e.Phone__c = (cont.Phone!=null?cont.Phone:'');
                        e.Email__c = (cont.Email!=null?cont.Email:'');
                    }
                } 
            }
            update Incomingevents;
        }
        /**********************************/
        /*****AFTER INSERT END************/
        /**********************************/
        
        /**********************************/
        /*****AFTER UPDATE START**********/
        /**********************************/
        
        /** before Update process Start**/
        if(Trigger.isUpdate){
            system.debug('**************i am inside update EVENT');
            
            Map<Id,Private_Activity__c> PGAMap=new Map<Id,Private_Activity__c>();
            Map<Id,Event> Updateevents= new Map<Id,Event>();
            
            for(Event e : Incomingevents)
            {
                tempId = e.whatId;              
                System.debug('#################'+tempid + e);  
                if(tempId != null){
                    if((tempId.substring(0,3) == 'a0J')|| (tempId.substring(0,3) == '006') || (tempId.substring(0,3) == 'a0D'))
                        PGAIds.add(e.Id);
                }
            }
            
            /**@@ PGA Information Map  @@**/
            if(PGAIds.size() > 0)
                PGAMap = new Map<Id,Private_Activity__c>([SELECT Id,Subject__c, Activity_ID__c, Task__c,Status__c,Due_Date__c, Owner__c,Account__c,Account_Open_Activity_RL__c,Contact__c,Contact_RL__c From Private_Activity__c WHERE Activity_ID__c=:PGAIds]);       
            for(Event e1: (List<Event>)trigger.old){
                
                for(Event e : Incomingevents)
                {   
                    if(e.id==e1.id){
                        tempId = e.whatId;
                        
                        System.debug(strPGAName);
                        system.debug('****************####'+e.What.type);
                        //if(e.what.Type=='Private_Activity__c')
                        
                        if(PGAMap.values().size() != null && PGAMap.values().size()>0)
                            for(Private_Activity__c pa1:PGAMap.values()){
                                if(pa1.Activity_ID__c==e.id){
                                    
                                    pa1.Subject__c = e.Subject;
                                    
                                    TimeZone tz = UserInfo.getTimeZone();
                                   if(e.IsAllDayEvent==true)
                                    pa1.Due_Date__c = DateTime.newInstance(e.StartDateTime.dateGMT(),e.StartDateTime.timeGMT());
                                    else
                                    pa1.Due_Date__c = DateTime.newInstanceGMT(e.StartDateTime.dateGMT(),e.StartDateTime.timeGMT());
                                    pa1.Owner__c = e.OwnerId;
                                    if(tempId != null && tempId.substring(0,3) == '006'){
                                        Opportunity testopp = mapOppIDName.get(e.WhatId);
                                        pa1.Account__c=testopp.Accountid;
                                    }
                                    else if(tempId != null && tempId.substring(0,3) == 'a0D'){
                                        Concession__c testConc= mapConcIDName.get(e.WhatId);
                                        pa1.Account__c=testConc.Account__c;
                                    }
                                    else                            
                                        pa1.Account__c = ContMap.get(e.Contact__c) != null && pa1.Account__c == null ? ContMap.get(e.Contact__c).AccountId : pa1.Account__c;    
                                    if(pa1.Account__c != pa1.Account_Open_Activity_RL__c)
                                        pa1.Account_Open_Activity_RL__c = pa1.Account__c; 
                                    
                                    pa1.Contact__c = e.Contact__c;
                                    pa1.Contact_RL__c = pa1.Contact__c;
                                    
                                    PGAUpdateMap.put(e.whatId,pa1);
                                }
                            }
                        e.whoId = null;
                        
                        if ( e.Contact__c != null) {
                            cont = ContMap.get(e.Contact__c);
                            String STCName;
                            if(UserProfilename.contains('STC')){
                                STCName = UserProfilename.substringAfterLast('STC').normalizeSpace();
                                for(Schema.FieldSetMember f : SObjectType.Contact.FieldSets.STC_Contact_Info.getFields()) 
                                    // contFields += f.getFieldPath() + ',';
                                    if(f.getFieldPath().replaceAll('_',' ').normalizeSpace().contains(STCName)){
                                        if(f.getFieldPath().containsignoreCase('phone'))
                                            e.Phone__c = String.valueOf(cont.get(f.getFieldPath())!=null?cont.get(f.getFieldPath()):'');//(cont.Phone!=null?cont.Phone:'');     /** Assigning Phone number values from contacts @satish**/
                                        if(f.getFieldPath().containsignoreCase('email'))
                                            e.Email__c = String.valueOf(cont.get(f.getFieldPath())!=null?cont.get(f.getFieldPath()):'');
                                        // e.Email__c = (cont.Email!=null?cont.Email:'');  /** Assigning Email Address values from contacts @satish**/
                                        
                                    }
                            } 
                            else
                            {
                                e.Phone__c = (cont.Phone!=null?cont.Phone:'');
                                e.Email__c = (cont.Email!=null?cont.Email:'');
                            }
                        }
                        else
                        {
                            e.Phone__c = ('');
                            e.Email__c = ('');
                        }                      
                    }
                    if((e1.Phone__c != e.Phone__c) || (e1.Email__c!=e.Email__c))
                        Updateevents.put(e.id,e);                    
                }
                
            }
            if(Updateevents.values().size()>0)
                update Updateevents.Values(); 
            if(PGAUpdateMap.values().size()>0)
                update PGAUpdateMap.values();
            
        }
        /**********************************/
        /*****AFTER UPDATE END************/
        /**********************************/
        
    }    
    /**********************************/
    /*****PROCESS AFTER END***********/
    /**********************************/                 
    
    private void processdelete() {
        
        system.debug('**************i am inside delete task');
        
        Map<Id,Private_Activity__c> PGAMap=new Map<Id,Private_Activity__c>();
        String tempId;  
        set<String> PgaIds = new set<String>();
        
        
        for(Event e: (List<Event>)trigger.old)
        {   
            tempId = e.whatId;
            
            if(tempId != null){
                if((tempId.substring(0,3) == 'a0J')|| (tempId.substring(0,3) == '006') || (tempId.substring(0,3) == 'a0D') )
                    PGAIds.add(e.Id);
            }
        }
        
        /**@@ PGA Information Map  @@**/
        if(PGAIds.size() > 0)
            PGAMap = new Map<Id,Private_Activity__c>([SELECT Id,Subject__c, Activity_ID__c, Task__c,Status__c,Due_Date__c, Owner__c,Account__c,Account_Open_Activity_RL__c,Contact__c,Contact_RL__c From Private_Activity__c WHERE Activity_ID__c=:PGAIds]);
        if(PGAMap.values().size() != null && PGAMap.values().size()>0)
            Delete PGAMap.values();
        
    }
}