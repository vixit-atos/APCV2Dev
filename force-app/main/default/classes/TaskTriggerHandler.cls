/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* One or two sentence summary of this class.
*
* This class is used as an controller for the vf page -My Task Home Component Vfpage- which is used 
* to serve as an homecomponent
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author           
* @modifiedBy          
* @version        3.0
* @created        
* @modified       04-10-2017
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* modifiedBy      Satish      
* 04-10-2017      Phone and email based on current user profile specific for STC users
*                 (L80,L172-192,L271-291).
*
* 
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/


public class TaskTriggerHandler extends TriggerHandler {
    
    private map<id, RecordType> rtMap;
    Set<String> qaSet;
    Set<String> ort;
    Set<String> setTaskGroup;
    
    public  TaskTriggerHandler() {
        ort = Task_Closure_Email_Template__c.getAll().keySet();
        setTaskGroup = Task_Group_Closure_Types_List__c.getAll().keySet();
        
        rtMap = new Map<id, RecordType>([SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Opportunity' and DeveloperName in :ort]);
    }
    
    /* Context overrides */
    
    
    protected override void beforeInsert() {
        
    }
    protected override void beforeUpdate() {
        processAfter(); 
    }
    protected override void afterInsert() {
        
        processAfter();
        UpdateAttachmentcount(); 
        UpdateopportunityStage();
        
    }
    protected override void afterUpdate() {
        
        if (TriggerHandler.runOnce()){
            processAfter();
            UpdateAttachmentcount();
            deleteothertasks();
            notifyoppyownertaskcomelete();
        }
    }
    protected override void afterDelete() {
        processdelete();
    }
    
    /**********************************/
    /*****PROCESS BEFORE START*********/
    /**********************************/
    private void processAfter() {
        
        Contact cont = null;                                                                    // Stores the value of Contact      
        List<Private_Activity__c> PGAList = new List<Private_Activity__c>();                    // Stores the List of  Private Activities For DML operations
        Map<String,Private_Activity__c> PGAUpdateMap = new Map<String,Private_Activity__c>();   // Stores the Private Activities for Update
        Set<String> PGAIds = new Set<String>();                                                 // Stores the IDs of Private Activities
        String UserProfilename = [select Name from profile where id = : userinfo.getProfileId() limit 1].name;
        Map<ID,String> mapAccountIDName = new Map<ID,String>();                                 // Stores the related Account Ids and Account Names
        Map<ID,String> mapContactIDName = new Map<ID,String>();                                 // Stores the related Contact Ids and Contact Names
        
        Map<ID,ID> initAcctTaskMap = new Map<ID,ID>();                                          // Stores the related Account Ids
        
        Map<ID,ID> ContTaskMap = new Map<ID,ID>();                                              // Stores the related Contact Ids
        List<Task> Incomingtasks = new List<Task>();
        List<Task> Tasklist = new List<Task>();
        set<String> taskIds = new set<String>();

        Private_Activity__c pa;                                                                 // Stores the Private Activity
        Map<id,Contact> ContMap = new Map <id,Contact>();                                       // Stores the related contacts
        
        String strPGAName;                                                                      // Stores the Private Activity Name
        String tempId;                                                                          // Stores the What Id
        
        Map<ID,Opportunity> mapOppIDName = new Map<ID,Opportunity>();
        Map<ID,ID> initOppTaskMap = new Map<ID,ID>();
        
        Map<ID,Concession__c> mapConcIDName = new Map<ID,Concession__c>();
        Map<ID,ID> initConcTaskMap = new Map<ID,ID>();
        
        
        for(Task t1 : (List<Task>)Trigger.new)
        {   
            taskIds.add(t1.id);
            System.debug('**********'+taskIds);
            
        }
        if(taskIds.size() > 0)
            Incomingtasks = new List<Task>([select Id, WhatId,what.name,What.type,TaskSubtype, Subject, ActivityDate,Phone__c,Email__c, Contact__c,Status, OwnerId,WhoId,AccountId   from Task Where Id=:taskIds ]);
        system.debug('!!!!!!!!!!!!!!!!!!!!!task list'+Tasklist);
        if(Trigger.isAfter)
        {
            Tasklist = Incomingtasks;
            system.debug('!!!!!!!!!!!!!!!!!Incomming tasks'+ Tasklist);
        }
        if(Trigger.isbefore)
        {
            Tasklist =  ((List<Task>)Trigger.new) ;
            system.debug('!!!!!!!!!!!!!!!!!trigger.new'+ Tasklist);
        }
        for(Task t : Tasklist)
        {   
            
            System.debug('AN Check whoId: ' + t.WhoId
                         + ' whoid: ' + t.WhoId
                         + ' what: ' + t.WhatId
                         + ' id: ' + t.id
                         + ' account: ' + t.accountid
                         + ' Contact: ' + t.Contact__c
                         + ' WhatName: ' + t.what.name
                         + ' sybtype: ' + t.TaskSubtype);
            tempId = t.whatId;
            if(t.Contact__c == null && t.WhoId !=null)         // This section is due to Send An Email activity process.. 
            {
                t.Contact__c=  t.whoid ;
            }
            System.debug('CheckAN '+tempId);
            if(t.Contact__c != null) // bulkification@satish
            {   
                ContTaskMap.put(t.Id,t.Contact__c);
                // t.whoid=t.Contact__c;
            }
            if(tempId != null && tempId.substring(0,3) == '001')
            {
                initAcctTaskMap.put(t.Id,t.whatId);
            }
            if(tempId != null && tempId.substring(0,3) == '006')
            {
                initOppTaskMap.put(t.Id,t.whatId);
            }
            if(tempId != null && tempId.substring(0,3) == 'a0D')
            {
                initConcTaskMap.put(t.Id,t.whatId);
            }
        }
        System.debug('CheckANinitAcctTaskList '+initAcctTaskMap);
        System.debug('CheckANinitContTaskList '+ContTaskMap);
        if(ContTaskMap.size() > 0) // bulkification@satish
        {
            String idString = '(\'';  
            for (String thisId : ContTaskMap.values()) 
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
        if(initAcctTaskMap.size() > 0)
            for(Account objPA : [select Id,Name from Account where Id IN : initAcctTaskMap.values()])
        {
            mapAccountIDName.put(objPA.Id,objPA.Name);
        }
        if(ContMap.size() > 0)                                                   // If any Account is associated with the Contact.
            for(Contact objPA : ContMap.values())
        {
            if (objPA.AccountId != null)
                mapAccountIDName.put(objPA.AccountId,objPA.Account.Name); 
        }
        if(ContTaskMap.size() > 0)
            for(Contact objPA : [select Id,Name from Contact where Id IN : ContTaskMap.values()])
        {   
            mapContactIDName.put(objPA.Id,objPA.Name);        
        }
        if(initOppTaskMap.size() > 0)
            for(Opportunity objPA : [select Id,Name,AccountId from Opportunity where Id IN : initOppTaskMap.values()])
        {   
            mapOppIDName.put(objPA.Id,objPA);        
        }
        if(initConcTaskMap.size() > 0)
            for(Concession__c objPA : [select Id,Name,Account__c from Concession__c where Id IN : initConcTaskMap.values()])
        {   
            mapConcIDName.put(objPA.Id,objPA);        
        }                
        
        System.debug('AN Check PArentNameMAp:');
        System.debug('********************'+initAcctTaskMap);
        System.debug('********************'+ContTaskMap);
        System.debug('********************'+mapAccountIDName);
        System.debug('********************'+mapContactIDName);
        
        /**********************************/
        /*****BEFORE INSERT START**********/
        /**********************************/
        /** Before Insert Process Start*/
        //if(Trigger.isInsert&&Trigger.isBefore){
        if(Trigger.isInsert&&Trigger.isAfter){
            
            
            for (Task t : Incomingtasks) {
                System.debug('TT Before who: ' + t.WhoId
                             + ' whoid: ' + t.WhoId
                             + ' what: ' + t.WhatId
                             + ' id: ' + t.id
                             + ' account: ' + t.accountid
                             + ' Contact: ' + t.Contact__c
                             + ' WhatName: ' + t.what.name
                             + ' sybtype: ' + t.TaskSubtype);
                
                tempId = t.whatId;
                
                if(tempId <> null && tempId.substring(0,3) == '001')
                    strPGAName = 'PGA-' + mapAccountIDName.get(t.WhatId);
                else if(tempId <> null && tempId.substring(0,3) == '006')
                {
                    Opportunity testopp= mapOppIDName.get(t.WhatId);
                    strPGAName = 'PGA-' + testopp.Name;
                }
                else if(tempId <> null && tempId.substring(0,3) == 'a0D')
                {
                    Concession__c testConc= mapConcIDName.get(t.WhatId);
                    strPGAName = 'PGA-' + testConc.Name;
                }                    
                else if((ContMap.Size() > 0) &&(t.contact__c!=null)  && (ContMap.get(t.Contact__c).AccountId)!= null)            // If any Account is associated with the Contact.
                    strPGAName = 'PGA-' + mapAccountIDName.get(ContMap.get(t.Contact__c).AccountId);
                else  
                    strPGAName = 'PGA-' + mapContactIDName.get(t.Contact__c);
                System.debug(strPGAName);
                
                if((tempId != null && tempId.substring(0,3) == '001') || (tempId == null && t.Contact__c != null) || (tempId != null && tempId.substring(0,3) == '006' ) || (tempId != null && tempId.substring(0,3) == 'a0D' )) {
                    pa = new Private_Activity__c();
                    pa.Name = strPGAName;
                    pa.Subject__c = t.Subject;
                    pa.Task__c = true;
                    pa.Status__c = t.Status;
                    
                    TimeZone tz = UserInfo.getTimeZone(); 
                    pa.Due_Date__c = t.ActivityDate != null ? DateTime.newInstance(t.ActivityDate, Time.newInstance(23, 59, 59, 999)) : null;
                    //pa.Due_Date__c = t.ActivityDate != null ? DateTime.Date(t.ActivityDate) : null;
                    pa.Owner__c = t.OwnerId;
                    pa.Activity_ID__c = t.Id;
                    if(tempId != null && tempId.substring(0,3) == '006'){
                        Opportunity testopp = mapOppIDName.get(t.WhatId);
                        pa.Account__c=testopp.Accountid;
                    }
                    else if(tempId != null && tempId.substring(0,3) == 'a0D'){
                        Concession__c testConc= mapConcIDName.get(t.WhatId);
                        pa.Account__c=testConc.Account__c;
                    }
                    else                       
                        pa.Account__c = ContMap.get(t.Contact__c) != null && tempId == null ? ContMap.get(t.Contact__c).AccountId : tempId;       
                    pa.Account_Open_Activity_RL__c = pa.Account__c;
                    if(t.Contact__c != null) // Avoids assigning null value during update.
                    {
                        pa.Contact__c = t.Contact__c;
                        pa.Contact_RL__c = pa.Contact__c;
                    }
                    PGAList.add(pa);
                }
                //////////////////////////////////
                
                
            }
            set<String> PgaIds1 = new set<String>();
            if(PGAList.size()>0){
                Database.SaveResult[] srList = Database.insert(PGAList);
                for (Database.SaveResult sr : srList)
                    PgaIds1.add(sr.getId());
            }
            list<Private_Activity__c> pgaList1 = [SELECT Id,Account__c,Contact__c,Activity_ID__c from Private_Activity__c where id=:PgaIds1]; 
            System.debug('**************'+pgaList1);
            for(Task t : Incomingtasks){
                for(Private_Activity__c p:pgaList1){
                    if(p.Activity_ID__c==t.id)
                    {
                        if(t.whatid!=null && t.whatid == p.Account__c)
                        {    
                            t.whatid = p.id;
                            system.debug('***************'+t.whatid);
                        }
                        if(t.whatid==null && t.Contact__c!=null && t.Contact__c == p.Contact__c)
                        {   
                            t.whatid = p.id;
                            system.debug('***************'+t.whatid);
                        }
                    }
                    
                }
                if ( t.Contact__c != null) {
                    cont = ContMap.get(t.Contact__c);
                    String STCName;
                    if(UserProfilename.contains('STC')){
                        STCName = UserProfilename.substringAfterLast('STC').normalizeSpace();
                        for(Schema.FieldSetMember f : SObjectType.Contact.FieldSets.STC_Contact_Info.getFields()) 
                            // contFields += f.getFieldPath() + ',';
                            if(f.getFieldPath().replaceAll('_',' ').normalizeSpace().contains(STCName)){
                                if(f.getFieldPath().containsignoreCase('phone'))
                                    t.Phone__c = String.valueOf(cont.get(f.getFieldPath())!=null?cont.get(f.getFieldPath()):'');//(cont.Phone!=null?cont.Phone:'');     /** Assigning Phone number values from contacts @satish**/
                                if(f.getFieldPath().containsignoreCase('email'))
                                    t.Email__c = String.valueOf(cont.get(f.getFieldPath())!=null?cont.get(f.getFieldPath()):'');
                                // t.Email__c = (cont.Email!=null?cont.Email:'');  /** Assigning Email Address values from contacts @satish**/
                                
                            }
                    } 
                    else
                    {
                        t.Phone__c = (cont.Phone!=null?cont.Phone:'');
                        t.Email__c = (cont.Email!=null?cont.Email:'');
                    }
                }                
                
            }
            update Incomingtasks;
        }
        /**********************************/
        /*****BEFORE INSERT END************/
        /**********************************/
        
        /**********************************/
        /*****BEFORE UPDATE START**********/
        /**********************************/
        
        /** before Update process Start**/
        if(Trigger.isUpdate&&Trigger.isAfter){
            system.debug('**************i am inside update task');
            
            Map<Id,Private_Activity__c> PGAMap=new Map<Id,Private_Activity__c>();
            Map<Id,Task> Updatetasks= new Map<Id,Task>();
            
            
            
            for(Task t : Incomingtasks)
            {   
                System.debug('**************'+t);
                System.debug('**************'+t.whatid);
                System.debug('**************'+t.Contact__c);
                System.debug('**************'+t.whoid);
                tempId = t.whatId;
                
                if(tempId != null){
                    if((tempId.substring(0,3) == 'a0J')|| (tempId.substring(0,3) == '006') || (tempId.substring(0,3) == 'a0D') )
                        PGAIds.add(t.Id);
                }
            }
            
            /**@@ PGA Information Map  @@**/
            if(PGAIds.size() > 0)
                PGAMap = new Map<Id,Private_Activity__c>([SELECT Id,Subject__c, Activity_ID__c, Task__c,Status__c,Due_Date__c, Owner__c,Account__c,Account_Open_Activity_RL__c,Contact__c,Contact_RL__c From Private_Activity__c WHERE Activity_ID__c=:PGAIds]);       
            for(Task t1: (List<task>)trigger.old){
                
                for(Task t : Incomingtasks)
                {   
                    if(t.id==t1.id){
                        tempId = t.whatId;
                        System.debug(strPGAName);
                        system.debug('****************####'+t.What.type);
                        //if(t.what.Type=='Private_Activity__c')
                        
                        if(PGAMap.values().size() != null && PGAMap.values().size()>0)
                            for(Private_Activity__c pa1:PGAMap.values()){
                                if(pa1.Activity_ID__c==t.id){
                                    
                                    pa1.Subject__c = t.Subject;
                                    pa1.Task__c = true;
                                    pa1.Status__c = t.Status;
                                    
                                    TimeZone tz = UserInfo.getTimeZone(); 
                                    pa1.Due_Date__c = t.ActivityDate != null ? DateTime.newInstance(t.ActivityDate, Time.newInstance(23, 59, 59, 999)) : null;
                                    pa1.Owner__c = t.OwnerId;
                                    if(tempId != null && tempId.substring(0,3) == '006'){
                                        Opportunity testopp = mapOppIDName.get(t.WhatId);
                                        pa1.Account__c=testopp.Accountid;
                                    }
                                    else if(tempId != null && tempId.substring(0,3) == 'a0D'){
                                        Concession__c testConc= mapConcIDName.get(t.WhatId);
                                        pa1.Account__c=testConc.Account__c;
                                    }
                                    else                            
                                        pa1.Account__c = ContMap.get(t.Contact__c) != null && pa1.Account__c == null ? ContMap.get(t.Contact__c).AccountId : pa1.Account__c;    
                                    if(pa1.Account__c != pa1.Account_Open_Activity_RL__c)
                                        pa1.Account_Open_Activity_RL__c = pa1.Account__c; 
                                    
                                    pa1.Contact__c = t.Contact__c;
                                    pa1.Contact_RL__c = pa1.Contact__c;
                                    
                                    PGAUpdateMap.put(t.whatId,pa1);
                                }
                            }
                        t.whoId = null;
                        
                        /////////////////////////////////////////////////
                        
                        if ( t.Contact__c != null) {
                            cont = ContMap.get(t.Contact__c);
                            String STCName;
                            if(UserProfilename.contains('STC')){
                                STCName = UserProfilename.substringAfterLast('STC').normalizeSpace();
                                for(Schema.FieldSetMember f : SObjectType.Contact.FieldSets.STC_Contact_Info.getFields()) 
                                    // contFields += f.getFieldPath() + ',';
                                    if(f.getFieldPath().replaceAll('_',' ').normalizeSpace().contains(STCName)){
                                        if(f.getFieldPath().containsignoreCase('phone'))
                                            t.Phone__c = String.valueOf(cont.get(f.getFieldPath())!=null?cont.get(f.getFieldPath()):'');//(cont.Phone!=null?cont.Phone:'');     /** Assigning Phone number values from contacts @satish**/
                                        if(f.getFieldPath().containsignoreCase('email'))
                                            t.Email__c = String.valueOf(cont.get(f.getFieldPath())!=null?cont.get(f.getFieldPath()):'');
                                        // t.Email__c = (cont.Email!=null?cont.Email:'');  /** Assigning Email Address values from contacts @satish**/
                                        
                                    }
                            } 
                            else
                            {
                                t.Phone__c = (cont.Phone!=null?cont.Phone:'');
                                t.Email__c = (cont.Email!=null?cont.Email:'');
                            }
                        }
                        else
                        {
                            t.Phone__c = ('');
                            t.Email__c = ('');
                        }                              
                    }
                    if((t1.Phone__c != t.Phone__c) || (t1.Email__c!=t.Email__c))
                        Updatetasks.put(t.id,t);
                    
                }
                
            }
            system.debug('----------------------');
            if(Updatetasks.values().size()>0)
                update Updatetasks.Values();
            if(PGAUpdateMap.values().size()>0)
                update PGAUpdateMap.values();
            
        }
        /**********************************/
        /*****BEFORE UPDATE END************/
        /**********************************/
        if(Trigger.isUpdate&&Trigger.isbefore)
        {
            system.debug('**************i am inside update task');
            List<Private_Activity__c> PGAListemail = new List<Private_Activity__c>();
            Map<Id,Private_Activity__c> PGAMapemail=new Map<Id,Private_Activity__c>();
            Map<Id,Id> PGAMap1=new Map<Id,ID>();
            Map<Id,Task> Updatetasks= new Map<Id,Task>();
            set<String> PgaIdsemail = new set<String>();
            
            for(Task t : (List<Task>)Trigger.new)
            {   
                System.debug('**************'+t);
                System.debug('**************'+t.whatid);
                System.debug('**************'+t.Contact__c);
                System.debug('**************'+t.whoid);
                tempId = t.whatId;
                
                if(tempId != null){
                    if((tempId.substring(0,3) == 'a0J')|| (tempId.substring(0,3) == '006') || (tempId.substring(0,3) == 'a0D')|| (tempId.substring(0,3) == '001')  )
                        PGAIdsemail.add(t.Id);
                }
                if(tempId == null){
                    
                    PGAIdsemail.add(t.Id);
                }
                
            }
            if(PGAIdsemail.size() > 0)
                PGAMapemail = new Map<Id,Private_Activity__c>([SELECT Id,Subject__c, Activity_ID__c, Task__c,Status__c,Due_Date__c, Owner__c,Account__c,Account_Open_Activity_RL__c,Contact__c,Contact_RL__c From Private_Activity__c WHERE Activity_ID__c=:PGAIdsemail]);
            
            for(Task t : (List<Task>)Trigger.new)
            {   
                
                if(PGAMapemail.values().size() != null && PGAMapemail.values().size()>0)
                    for(Private_Activity__c pa1:PGAMapemail.values()){
                        if(pa1.Activity_ID__c==t.id){
                            PGAMap1.put(t.id,pa1.id);   
                            
                        }   
                    }
                
                if(PGAMap1.get(t.id) == null&&t.End__c != null && (t.Whatid !=null || t.Whoid!=null || t.Contact__c != null ))
                {
                    system.debug('#########'+t);
                    
                    System.debug('TT Before who: ' + t.WhoId
                                 + ' whoid: ' + t.WhoId
                                 + ' what: ' + t.WhatId
                                 + ' id: ' + t.id
                                 + ' account: ' + t.accountid
                                 + ' Contact: ' + t.Contact__c
                                 + ' WhatName: ' + t.what.name
                                 + ' sybtype: ' + t.TaskSubtype);
                    
                    tempId = t.whatId;
                    
                    if(tempId <> null && tempId.substring(0,3) == '001')
                        strPGAName = 'PGA-' + mapAccountIDName.get(t.WhatId);
                    else if(tempId <> null && tempId.substring(0,3) == '006')
                    {
                        Opportunity testopp= mapOppIDName.get(t.WhatId);
                        strPGAName = 'PGA-' + testopp.Name;
                    }
                    else if(tempId <> null && tempId.substring(0,3) == 'a0D')
                    {
                        Concession__c testConc= mapConcIDName.get(t.WhatId);
                        strPGAName = 'PGA-' + testConc.Name;
                    }                    
                    else if((ContMap.Size() > 0) &&(t.contact__c!=null) && (ContMap.get(t.Contact__c).AccountId)!= null)            // If any Account is associated with the Contact.
                        strPGAName = 'PGA-' + mapAccountIDName.get(ContMap.get(t.Contact__c).AccountId);
                    else  
                        strPGAName = 'PGA-' + mapContactIDName.get(t.Contact__c);
                    System.debug(strPGAName);
                    
                    if((tempId != null && tempId.substring(0,3) == '001') || (tempId == null) || (tempId != null && tempId.substring(0,3) == '006' ) || (tempId != null && tempId.substring(0,3) == 'a0D' )) {
                        pa = new Private_Activity__c();
                        pa.Name = strPGAName;
                        pa.Subject__c = t.Subject;
                        pa.Task__c = true;
                        pa.Status__c = t.Status;
                        
                        TimeZone tz = UserInfo.getTimeZone(); 
                        pa.Due_Date__c = t.ActivityDate != null ? DateTime.newInstance(t.ActivityDate, Time.newInstance(23, 59, 59, 999)) : null;
                        pa.Owner__c = t.OwnerId;
                        pa.Activity_ID__c = t.Id;
                        if(tempId != null && tempId.substring(0,3) == '006'){
                            Opportunity testopp = mapOppIDName.get(t.WhatId);
                            pa.Account__c=testopp.Accountid;
                        }
                        else if(tempId != null && tempId.substring(0,3) == 'a0D'){
                            Concession__c testConc= mapConcIDName.get(t.WhatId);
                            pa.Account__c=testConc.Account__c;
                        }
                        else                       
                            pa.Account__c = ContMap.get(t.Contact__c) != null && tempId == null ? ContMap.get(t.Contact__c).AccountId : tempId;       
                        pa.Account_Open_Activity_RL__c = pa.Account__c;
                        if(t.Contact__c != null) // Avoids assigning null value during update.
                        {
                            pa.Contact__c = t.Contact__c;
                            pa.Contact_RL__c = pa.Contact__c;
                        }
                        PGAListemail.add(pa);
                    }
                    //////////////////////////////////
                    
                    if ( t.Contact__c != null) {
                        cont = ContMap.get(t.Contact__c);
                        String STCName;
                        if(UserProfilename.contains('STC')){
                            STCName = UserProfilename.substringAfterLast('STC').normalizeSpace();
                            for(Schema.FieldSetMember f : SObjectType.Contact.FieldSets.STC_Contact_Info.getFields()) 
                                // contFields += f.getFieldPath() + ',';
                                if(f.getFieldPath().replaceAll('_',' ').normalizeSpace().contains(STCName)){
                                    if(f.getFieldPath().containsignoreCase('phone'))
                                        t.Phone__c = String.valueOf(cont.get(f.getFieldPath())!=null?cont.get(f.getFieldPath()):'');//(cont.Phone!=null?cont.Phone:'');     /** Assigning Phone number values from contacts @satish**/
                                    if(f.getFieldPath().containsignoreCase('email'))
                                        t.Email__c = String.valueOf(cont.get(f.getFieldPath())!=null?cont.get(f.getFieldPath()):'');
                                    // t.Email__c = (cont.Email!=null?cont.Email:'');  /** Assigning Email Address values from contacts @satish**/
                                    
                                }
                        } 
                        else
                        {
                            t.Phone__c = (cont.Phone!=null?cont.Phone:'');
                            t.Email__c = (cont.Email!=null?cont.Email:'');
                        }
                    }           
                    
                }
                
                
                
            }
            set<String> PgaIdsemail1 = new set<String>();
            if(PGAListemail.size()>0){
                Database.SaveResult[] srList1 = Database.insert(PGAListemail);
                for (Database.SaveResult sr : srList1)
                    PgaIdsemail1.add(sr.getId());
            }
            list<Private_Activity__c> pgaListemail1 = [SELECT Id,Account__c,Contact__c,Activity_ID__c from Private_Activity__c where id=:PgaIdsemail1]; 
            System.debug('**************'+pgaListemail1);
            for(Task t : (List<Task>)Trigger.new){
                for(Private_Activity__c p:pgaListemail1){
                system.debug('----------------------');
                    if(p.Activity_ID__c==t.id)
                    {
                        if(t.whatid!=null && t.whatid == p.Account__c)
                        {    
                            t.whatid = p.id;
                            system.debug('***************'+t.whatid);
                        }
                        if(t.whatid==null && t.Contact__c!=null && t.Contact__c == p.Contact__c)
                        {   
                            t.whatid = p.id;
                            system.debug('***************'+t.whatid);
                        }
                    }
                    
                }
            }
            
            
            
            
            
        }
        
    } 
    /**********************************/
    /*****PROCESS BEFORE END***********/
    /**********************************/
    
    
    private void processdelete() {
        
        system.debug('**************i am inside delete task');
        
        Map<Id,Private_Activity__c> PGAMap=new Map<Id,Private_Activity__c>();
        String tempId;  
        set<String> PgaIds = new set<String>();
        
        
        for(Task t: (List<task>)trigger.old)
        {   
            tempId = t.whatId;
            
            if(tempId != null){
                if((tempId.substring(0,3) == 'a0J')|| (tempId.substring(0,3) == '006') || (tempId.substring(0,3) == 'a0D') )
                    PGAIds.add(t.Id);
            }
        }
        
        /**@@ PGA Information Map  @@**/
        if(PGAIds.size() > 0)
            PGAMap = new Map<Id,Private_Activity__c>([SELECT Id,Subject__c, Activity_ID__c, Task__c,Status__c,Due_Date__c, Owner__c,Account__c,Account_Open_Activity_RL__c,Contact__c,Contact_RL__c From Private_Activity__c WHERE Activity_ID__c=:PGAIds]);
        if(PGAMap.values().size() != null && PGAMap.values().size()>0)
            Delete PGAMap.values();
        
    }
    
    private void UpdateAttachmentcount() {
        
        List<Task> taskList = new List<Task>();
        Set<ID> taskIDSet = new Set<ID>();
        
        if (trigger.old != null)
        {
            for (Task t:(List<Task>) trigger.old)
            {
                taskIDSet.add(t.ID);
            }
        }
        
        if (trigger.new != null)
        {
            for (Task t:(List<Task>) trigger.new)
            {
                taskIDSet.add(t.ID);
            }
        }
        
        // Query for the attachment children of the tasks
        taskList = [SELECT id, (SELECT id FROM attachments) FROM Task WHERE ID in: taskIDSet];

            
            for (Task t:(List<Task>) taskList)
            {
                if(t.Attachments.size()>0){
                    t.Attachment__c=true;
                    
                }else{
                    t.Attachment__c=false;
                }
            }
            if(!taskList.isEmpty()){
                update taskList;
            }
        
        
    }
    /* when Task Staus Completed (Task closed) send Nofitication parent Record (opporunity) owner 
*/
    private void notifyoppyownertaskcomelete(){
        Set<String> strwhatIDs = new Set<String>();
        set<Id> setClosedTaskId = new set<Id>();
        Map<id,string> maprecortypes=new Map<id,string>();
        Map<id,string> mapEmailAdress=new Map<id,string>();
        Map<id,string> mapcurrentOwnerid=new Map<id,string>();
        Set<String> setEmailTemplateName =new Set<String>();
        Map<id,string> mapemailtemplateids=new Map<id,string>();
        
        
        string[] toaddress = New String[] {};
            for (Task t : (List<Task>)Trigger.new) {
                Task oldTask = (Task)trigger.oldMap.get(t.Id);
                Task newTask = (Task)trigger.newMap.get(t.Id);
                if(((oldTask.status != newTask.status) && t.status == 'Completed' )||test.isRunningTest())
                {
                    strwhatIDs.add(t.whatID);  
                    setClosedTaskId.add(t.id);
                }    
            }
        list<Task> lstTask = [select id,OwnerId,what.recordtype.developername,what.recordtype.name from Task where Id IN : setClosedTaskId and what.recordtype.developername in:ort];
        
        if(!lstTask.isEmpty()){
            for(Task tk : lstTask){
                maprecortypes.put(tk.id,tk.what.recordtype.developername);
                setEmailTemplateName.add(Task_Closure_Email_Template__c.getInstance(maprecortypes.get(tk.Id)).Email_Template__c);
                
            }
            
            List<EmailTemplate> lsttemplateIds =  [select id from EmailTemplate where developername in : setEmailTemplateName];
            if(!lsttemplateIds.isEmpty()){
                for(Task tk : lstTask){
                    
                    for(EmailTemplate objemailtemplate:lsttemplateIds){
                        mapemailtemplateids.put(tk.id, objemailtemplate.id);
                    }
                }
            }
        }
        
        list<Opportunity> lstopt = [select id,owner.email from Opportunity where id IN: strwhatIDs];
        /*list<Account> lstAct = [select id,owner.email from Account where id IN: strwhatIDs];
list<Order> lstOrder =[select id,owner.email from Order where id IN: strwhatIDs];
list<Sales_Contract__c> lstsalcon = [select id,Opportunity__r.ownerid,Opportunity__r.owner.email from Sales_Contract__c where id IN: strwhatIDs]; */
        if(!lstopt.isEmpty()){
            for(Opportunity Opt : lstopt){
                if(Opt.ownerid!=userinfo.getuserid()){
                    mapEmailAdress.put(Opt.id,Opt.owner.email);
                }
                mapcurrentOwnerid.put(Opt.id,Opt.ownerid);
            }
        }
        /*if(!lstAct.isEmpty()){
            for(Account act : lstAct){
            mapEmailAdress.put(act.id,act.owner.email);
            mapcurrentOwnerid.put(act.id,act.ownerid);
            }
            }
            if(!lstOrder.isEmpty()){
            for(Order ord : lstOrder){
            mapEmailAdress.put(ord.id,ord.owner.email);
            mapcurrentOwnerid.put(ord.id,ord.ownerid);
            }
            }
            if(!lstsalcon.isEmpty()){
            for(Sales_Contract__c sc : lstsalcon){
            mapEmailAdress.put(sc.id,sc.Opportunity__r.owner.email);
            mapcurrentOwnerid.put(sc.id,sc.Opportunity__r.ownerid);
            }
            } */
        if(!mapEmailAdress.values().isEmpty()){
            for(string str :mapEmailAdress.values()){
                toaddress = New String[] {str};
                    }
        }
        List<Messaging.SingleEmailMessage> lstEmailId=new List<Messaging.SingleEmailMessage>();
        Contact cont = [select id,name from contact where email ='test@gmtestail.com' limit 1];
        
        if(!lstTask.isEmpty()){
            for(Task tk : lstTask){
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(toaddress);
                mail.setTemplateId(mapemailtemplateids.get(tk.id));
                // mail.setWhatId(tk.whatid);
                mail.setWhatId(tk.id);
                // mail.setTargetObjectId(mapcurrentOwnerid.get(tk.whatId));
                mail.setTargetObjectId(cont.id);
                mail.setTreatTargetObjectAsRecipient(false);
                mail.setSaveAsActivity(false);
                lstEmailId.add(mail);                 
                
            }
        }
        if(lstEmailId.size()>0){
            try{                
                Messaging.sendEmail(lstEmailId);
            }Catch(Exception ee){
                system.debug('Print exception'+ee);
            }
        }
    }
    /* when one person from the group closes task - will delete the other group members tasks.
*/
    private void deleteothertasks(){
        system.debug('i am inside deleteothertasks');
        Set<String> strwhatIDs = new Set<String>();
        Set<String> settasktypes = new Set<String>();
        Set<String> setValidwhatIDs = new Set<String>();
        Map<ID,String> mapoppidtasktype = new Map<ID,String>();
        for (Task t : (List<Task>)Trigger.new) {
            if(t.WhatId!=null){
                if(  Opportunity.sObjectType == t.WhatId.getSObjectType() ){
                    Task oldTask = (Task)trigger.oldMap.get(t.Id);
                    Task newTask = (Task)trigger.newMap.get(t.Id);
                    if((oldTask.status != newTask.status) && (t.status == 'Completed' ||t.status == 'In Progress')){
                        //settasktypes.add(t.type);
                        strwhatIDs.add(t.whatID); 
                        mapoppidtasktype.put(t.whatID, t.type);
                    }    
                }
            }   
            
        }
        String strTasktypes;
        if(!strwhatIDs.isEmpty()){
            List<Opportunity> lstopportunity = [SELECT Id,Ownerid,RecordType.DeveloperName FROM Opportunity WHERE Id =: strwhatIDs and RecordType.DeveloperName =:ort ];
            // List<Opportunity> lstopportunity = [SELECT Id,Ownerid,RecordType.DeveloperName FROM Opportunity WHERE Id =: strwhatIDs ];
            if(!lstopportunity.isEmpty()){
                for(Opportunity Opty : lstopportunity){
                    setValidwhatIDs.add(Opty.id);  
                    strTasktypes=mapoppidtasktype.get(Opty.id);
                    if( setTaskGroup.contains(strTasktypes)){
                        settasktypes.add(strTasktypes);
                        system.debug('i am lstTask'+settasktypes);
                    }
                }
            }
            if(!setValidwhatIDs.isEmpty()){
                List<Task> lstTask = [select id,status from task where whatid IN:setValidwhatIDs   AND Type IN:settasktypes
                                      AND  status != 'Completed' AND status != 'In Progress'];
                system.debug('i am lstTask'+lstTask);
                if(!lstTask.isEmpty()){
                    system.debug('i am lstTask'+lstTask);
                    delete lstTask;
                }
            }
            
        }
    } 
    private void UpdateopportunityStage(){
        
        Set<String> strwhatIDs = new Set<String>();
        
        
        Map<ID,String> mapoppidtasktype = new Map<ID,String>();
        for (Task t : (List<Task>)Trigger.new) {
            if(t.WhatId!=null){
                if(  Opportunity.sObjectType == t.WhatId.getSObjectType() ){    
                    system.debug('---' + t.whatID);
                    system.debug('---' + t.type);              
                    strwhatIDs.add(t.whatID); 
                    mapoppidtasktype.put(t.whatID, t.type);
                    
                }
            }   
            
        }
        String strTasktypes;
        String strOppystage;
        Task_Group_Closure_Types_List__c tgctl;
        if(!strwhatIDs.isEmpty()){
            List<Opportunity> lstopportunity = [SELECT Id,Ownerid,RecordType.DeveloperName FROM Opportunity WHERE Id =: strwhatIDs  ];
            if(!lstopportunity.isEmpty()){
                for(Opportunity Opty : lstopportunity){
                    strTasktypes=mapoppidtasktype.get(Opty.id);
                    if (strTasktypes == null) continue; //this line added to avoid NullPointerException by Doren on 3/12/19
                    tgctl = Task_Group_Closure_Types_List__c.getInstance(strTasktypes);
                    if (tgctl == null) continue; //added another null check to prevent NullPointerException by Doren on 5/24/19
                    strOppystage=tgctl.StageUpdate__c;
                    if( setTaskGroup.contains(strTasktypes) && strOppystage!=null){
                        Opty.StageName=strOppystage;
                    }
                }
                update lstopportunity; //there is no reason to update list inside loop. This line moved outside of for loop by Doren on 3/12/19
            }
            
        }
    } 
}