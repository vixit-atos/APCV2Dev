/**
    * ─────────────────────────────────────────────────────────────────────────────────────────────────┐
    * One or two sentence summary of this class.
    *
    * This class is used as an controller for the vf page -My Task Home Component Vfpage- which is used 
    * to serve as an homecomponent
    * ──────────────────────────────────────────────────────────────────────────────────────────────────
    * @author         Satish Kumar  
    * @modifiedBy          
    * @version        3.0
    * @created        2-23-2017
    * @modified       03-30-2017
    * ──────────────────────────────────────────────────────────────────────────────────────────────────
    * @changes
    * modifiedBy      Satish      
    * 03-30-2017      Using the custom field on the User to store user specific picklist selection  
    *                 rather than cookie value (L40,L95-98,L143-154).
    *
    * modifiedBy      Satish     
    * 03-24-2017      Sort Order change according to due date(L88,L122-136). Fixed error caused due to
    *                 Account Id (L276-279,L202).Added Try catch blocks, apex messages(L345-347).
    *                 line between each @changes entry.
    * ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

public class MyTasksHomeComponentController 
{  
    public String UserId{get;set;}              // stores current user info.    
    public String selectedOption{get;set;}      // stores picklist value.
    public List<Task> MytaskList {get;set;}     // stores list of tasks.
    public Private_Activity__c pa {get;set;}    // stores Private Activity record.
    public String RelatedTo {get; set;}
    public String RelatedToId {get; set;}
    public String Name {get; set;}
    public String NameId {get; set;}
    public String AccountName {get; set;}
    public String AccountId {get; set;}
    public Boolean Message {get; set;}          // used to render message on vfpage .
    public Boolean RenderTable {get; set;}      // used to render page block table on vf page.
    public User LoginUser;                      // stores login user record .
    
    public Class Row                            // wrapper class to store the values of different fields and display them on vf page. 
    {
        public String OwnerId {get; set;}
        public String RelatedTo {get; set;}
        public String Name {get; set;}
        public String Status {get; set;}
        public String Subject {get; set;}
        public String AccountName {get; set;}
        public Date DueDate {get; set;}
        public String RelatedToId {get; set;}
        public String NameId {get; set;}
        public String SubjectId {get; set;}
        public String AccountId {get; set;}
        Row(String OwnerId, String RelatedToId,String RelatedTo,String NameId,String Name,Date DueDate,String Status,String SubjectId, String Subject,String AccountId, String AccountName) 
        {
            this.OwnerId = OwnerId;
            this.RelatedToId= RelatedToId;
            this.RelatedTo= RelatedTo;
            this.NameId =  NameId;
            this.Name =  Name;
            this.DueDate = DueDate;
            this.Status = Status;
            this.SubjectId = SubjectId;
            this.Subject = Subject;
            this.AccountId = AccountId;
            this.AccountName = AccountName;
            
            
        }      
        
    }
    
    public String viewmore;
    
    public MyTasksHomeComponentController()
    { 
        System.debug('HI');  
        viewmore = apexpages.currentpage().getparameters().get('viewmore');
        System.debug(viewmore);
        Message=false; 
        
        RenderTable=true;
        
        UserId= UserInfo.getUserId();
        LoginUser = [Select id,MyTasksHomeComponent_Cookie_Value__c from User where id=:UserId Limit 1];
        Date todayDT = date.today();
        MytaskList= [select Id,ActivityDate,Description,OwnerId,WhatId,What.Name,Contact__c,Contact__r.name,Owner.name,What.type,LastModifiedDate,AccountId,Priority,Status,Subject FROM Task WHERE (OwnerId =:UserId AND Status != 'Completed'  AND (ActivityDate <: todayDT OR  ActivityDate=:null) ) ORDER BY ActivityDate ASC NULLS FIRST ]; // default set to overdue
        if(MytaskList.isEmpty()==true)
        {
            Message=true;
            RenderTable=false;
        }
        
        if(LoginUser.MyTasksHomeComponent_Cookie_Value__c!=null)        // check whether there is a previous selection of picklist stored
        {
            selectedOption = LoginUser.MyTasksHomeComponent_Cookie_Value__c;
            Onchange(); 
        }   
        
    }
    
    public List<SelectOption> getValues() 
    {
        List<SelectOption> options = new List<SelectOption>();     // list used to store the picklist values and display on vf page.
        options.add(new SelectOption('Overdue','Overdue'));
        options.add(new SelectOption('Today','Today'));
        options.add(new SelectOption('Today + Overdue','Today + Overdue'));
        options.add(new SelectOption('Tomorrow','Tomorrow'));
        options.add(new SelectOption('Next 7 Days','Next 7 Days'));
        options.add(new SelectOption('Next 7 Days + Overdue','Next 7 Days + Overdue'));
        options.add(new SelectOption('This Month','This Month'));
        options.add(new SelectOption('All Open','All Open'));
        
        return options;
    }
    public void Onchange()                                  // called on onchange event of the picklist value on vf page and returns the respective list to display.
    {    
        Message=false;
        RenderTable=true;
        Date todayDT = date.today();
        if(selectedOption=='Overdue')
            MytaskList= [select Id,ActivityDate,Description,OwnerId,WhatId,What.Name,Contact__c,Contact__r.name,Owner.name,LastModifiedDate,What.type,AccountId,Priority,Status,Subject FROM Task WHERE OwnerId =:UserId AND (ActivityDate <: todayDT OR ActivityDate=:null) AND Status != 'Completed' ORDER BY ActivityDate ASC NULLS FIRST]; 
        if(selectedOption=='Today')
            MytaskList= [select Id,ActivityDate,Description,OwnerId,WhatId,What.Name,Contact__c,Contact__r.name,Owner.name,LastModifiedDate,What.type,AccountId,Priority,Status,Subject FROM Task WHERE OwnerId =:UserId AND ActivityDate =: todayDT AND Status != 'Completed' ORDER BY ActivityDate ASC NULLS FIRST];
        if(selectedOption=='Today + Overdue')
            MytaskList= [select Id,ActivityDate,Description,OwnerId,WhatId,What.Name,Contact__c,Contact__r.name,Owner.name,LastModifiedDate,What.type,AccountId,Priority,Status,Subject FROM Task WHERE OwnerId =:UserId AND (ActivityDate <=: todayDT OR ActivityDate=:null) AND Status != 'Completed' ORDER BY ActivityDate ASC NULLS FIRST];
        if(selectedOption=='Tomorrow')
            MytaskList= [select Id,ActivityDate,Description,OwnerId,WhatId,What.Name,Contact__c,Contact__r.name,Owner.name,LastModifiedDate,What.type,AccountId,Priority,Status,Subject FROM Task WHERE OwnerId =:UserId AND ActivityDate =: (todayDT+1) AND Status != 'Completed' ORDER BY ActivityDate ASC NULLS FIRST];
        if(selectedOption=='Next 7 Days')
            MytaskList= [select Id,ActivityDate,Description,OwnerId,WhatId,What.Name,Contact__c,Contact__r.name,Owner.name,LastModifiedDate,What.type,AccountId,Priority,Status,Subject FROM Task WHERE OwnerId =:UserId AND ActivityDate >=: (todayDT) AND ActivityDate <=: (todayDT+7) AND Status != 'Completed' ORDER BY ActivityDate ASC NULLS FIRST];
        if(selectedOption=='Next 7 Days + Overdue')
            MytaskList= [select Id,ActivityDate,Description,OwnerId,WhatId,What.Name,Contact__c,Contact__r.name,Owner.name,LastModifiedDate,What.type,AccountId,Priority,Status,Subject FROM Task WHERE OwnerId =:UserId AND (ActivityDate <=: (todayDT+7) OR ActivityDate=:null)  AND Status != 'Completed' ORDER BY ActivityDate ASC NULLS FIRST];
        if(selectedOption=='This Month')
            MytaskList= [select Id,ActivityDate,Description,OwnerId,WhatId,What.Name,Contact__c,Contact__r.name,Owner.name,LastModifiedDate,What.type,AccountId,Priority,Status,Subject FROM Task WHERE OwnerId =:UserId AND ActivityDate = THIS_MONTH AND Status != 'Completed' ORDER BY ActivityDate ASC NULLS FIRST];
        if(selectedOption=='All Open')
            MytaskList= [select Id,ActivityDate,Description,OwnerId,WhatId,What.Name,Contact__c,Contact__r.name,Owner.name,LastModifiedDate,What.type,AccountId,Priority,Status,Subject FROM Task WHERE OwnerId =:UserId AND Status != 'Completed' ORDER BY ActivityDate ASC NULLS FIRST];   
        if(MytaskList.isEmpty()==true)
        {
            Message=true;
            RenderTable=false;
        }
        
        // reset the selected value of the picklist in custom field on user.
        if(LoginUser.MyTasksHomeComponent_Cookie_Value__c==null)
        {
            LoginUser.MyTasksHomeComponent_Cookie_Value__c=selectedOption;
            Database.Update(LoginUser);
        }
        else
        {
            if(LoginUser!=null&&LoginUser.MyTasksHomeComponent_Cookie_Value__c!=selectedOption)
            {
                LoginUser.MyTasksHomeComponent_Cookie_Value__c=selectedOption;
                Database.Update(LoginUser);
            }
        }
        
        
        
    }
    
    public List<Row> getTaskList()                  // Used to return the records to be displayed on the vfpage with respective coloumn values.
    {   
        try
        {
            
            Map<Id,Row> RowMap = new Map<Id,row>();
            string soqlQuery;
            set<String> StdApiNames = new set<String>();
            set<String>custApiNames = new set<String>();
            Map<String, AllObjects__c> ObjectsMap = AllObjects__c.getAll();  // map which stores the records from custom setting.
            for(String s:ObjectsMap.keyset()){
                if(ObjectsMap.get(s).Standard_custom__c=='Standard') //Standard   Custom
                    StdApiNames.add(String.valueOf(s));
                if(ObjectsMap.get(s).Standard_custom__c=='Custom')
                    custApiNames.add(String.valueOf(s));
            }
            //StdApiNames.addall(String.valueOf(Label.StandrdApiNames).split(','));
            
            Set<String> whatIds = new Set<String>();
            Set<String> whoIds = new Set<String>();
            Map<String,List<Sobject>> sobj = new Map<String,list<Sobject>>();
            Map<String,String> OppAcc = new Map<String,String>();
            for(Task temp1 :MytaskList)
            {
                OppAcc.put(temp1.what.type,temp1.whatid);
                whatIds.add(temp1.whatid);
                whoids.add(temp1.Contact__c);
            }
            
            for(String str: StdApiNames)
                if(OppAcc.containsKey(str))
            {
                String idString = '(\'';                                            
                for (Id thisId : whatIds) 
                {
                    if(thisid!=null)
                        idString += thisId + '\',\'';
                }
                idString = idString.substring(0,idString.length()-2); //<--this is the bit I hate doing
                idString += ')';
                if (str=='Account')     
                    soqlQuery = 'SELECT Account.Name,Id FROM '+str+' WHERE id IN' + idString;
                else
                    soqlQuery = 'SELECT AccountId,Account.Name,Id FROM '+str+' WHERE id IN' + idString; 
                
                List<sObject> sobjList = Database.query(soqlQuery);
                sobj.put(str,sobjList);
            }
            for(String str: custApiNames)
                if(OppAcc.containsKey(str))
            {
                List<sObject> sobjList1 =new List<sObject>();
                if(str.equalsIgnoreCase('Private_Activity__c'))
                {
                    sobjList1 = [select id,Name,Account__c,Account__r.Name,Contact__c,Contact__r.Name,Due_Date__c,Subject__c,Activity_ID__c FROM Private_Activity__c WHERE id =:whatIds];
                    sobj.put(str,sobjList1);
                }
                else if(str.equalsIgnoreCase('Concession__c'))
                {   
                    sobjList1 = [select id,Name,Account__c,Account__r.Name FROM Concession__c WHERE id =:whatIds];
                    sobj.put(str,sobjList1);
                    
                }
                else
                    sobj.put(str,sobjList1);
            }  
            
            for(Task temp :MytaskList )
            {  
                RelatedToId = '';
                RelatedTo='';
                NameId='';
                Name ='';
                AccountId = '';
                AccountName = '';       
                if(sobj.Containskey(temp.What.type))
                {   
                    for(Sobject sob: sobj.get(temp.what.type))
                    {
                        
                        if(sob.id == temp.whatid)
                        {
                            RelatedToId = '';
                            RelatedTo='';
                            NameId='';
                            Name ='';
                            AccountId = '';
                            AccountName = '';
                            if(temp.what.Type =='Private_Activity__c')                      // check if related to private ativity 
                            {
                                RelatedToId = temp.WhatId ;
                                RelatedTo = temp.What.Name ;
                                if(sob.get('Account__c')!=null)                             // check if there is any account associated with the private activity.
                                {
                                    AccountId = String.valueOf(sob.get('Account__c'));
                                    AccountName = String.valueOf(sob.getSobject('Account__r').get('Name'));
                                }
                                if(sob.get('contact__c')!=null)                             // check if there is any contact associated with the private activity.
                                {
                                    NameId =  String.valueOf(sob.get('Contact__c'));
                                    Name =  String.valueOf(sob.getSobject('Contact__r').get('Name'));
                                }
                            }
                            if(temp.what.Type =='Concession__c')                      // check if related to private ativity 
                            {
                                RelatedToId = temp.WhatId ;
                                RelatedTo = temp.What.Name ;
                                if(sob.get('Account__c')!=null)                             // check if there is any account associated with the private activity.
                                {
                                    AccountId = String.valueOf(sob.get('Account__c'));
                                    AccountName = String.valueOf(sob.getSobject('Account__r').get('Name'));
                                }

                            }
                            
                            if(temp.Contact__r.Name!=null)                                         // check if there is an contact is related.
                            {
                                NameId = temp.Contact__c ;
                                Name = temp.Contact__r.Name ;
                            }
                            
                            
                            if(StdApiNames.Contains(temp.What.type))                        // check if the parent of the task is an standard object
                            {
                                RelatedToId = temp.WhatId ;
                                RelatedTo = temp.What.Name ;
                                if(temp.Contact__r.Name!=null)                                     // check if there is an contact is related.
                                {
                                    NameId = temp.Contact__c ;
                                    Name = temp.Contact__r.Name ;
                                }
                                if(temp.What.type == 'Account')                             // check if it is directly related to account.
                                {
                                    AccountId = String.valueOf(sob.get('id'));
                                    AccountName = String.valueOf(sob.get('Name'));
                                }
                                else if(sob.get('Accountid')!=null) 
                                {    
                                    AccountId = String.valueOf(sob.get('Accountid'));       // Query related parent account.
                                    AccountName = String.valueOf(sob.getSobject('Account').get('Name'));
                                }
                            }
                            System.debug(',,,,,,,'+temp.What.type+',,,,,,,');
                            if(custApiNames.Contains(temp.What.type)&&temp.what.Type !='Private_Activity__c')       // check if related to custom object other than private Activity.
                                if(RelatedTo=='' && RelatedToId==''){
                                    if(temp.WhatId!=null)
                                        RelatedToId = temp.WhatId ;
                                    if(temp.What.Name!=null)
                                        RelatedTo = temp.What.Name ; 
                                } 
                            
                            
                        }
                        if(custApiNames.Contains(temp.What.type)&&temp.what.Type !='Private_Activity__c')
                            if(RelatedTo=='' || RelatedToId==''){
                                if(temp.WhatId!=null)
                                    RelatedToId = temp.WhatId ;
                                if(temp.What.Name!=null)
                                    RelatedTo = temp.What.Name ; 
                            } 
                        RowMap.put(temp.id,new Row(temp.OwnerId,RelatedToId,RelatedTo,NameId,Name,temp.ActivityDate,temp.Status,temp.id,temp.Subject,AccountId,AccountName));  
                        
                    }
                    
                    
                    
                    
                }
                if(temp.Contact__c!=null && temp.Whatid == null)                                            // If related to only contact
                    //for(Sobject sob: sobj.get(temp.who.type))
                    
                {
                    RelatedToId = '';
                    RelatedTo='';
                    NameId='';
                    Name ='';
                    AccountId = '';
                    AccountName = '';
                    RelatedToId = temp.Contact__c ;
                    RelatedTo = temp.Contact__r.Name;
                    NameId = temp.Contact__c;
                    Name = temp.Contact__r.Name;
                    AccountId = '' ;
                    AccountName = '' ;
                    RowMap.put(temp.id,new Row(temp.OwnerId,RelatedToId,RelatedTo,NameId,Name,temp.ActivityDate,temp.Status,temp.id,temp.Subject,AccountId,AccountName));  
                    
                }
                if(RelatedTo=='' && RelatedToId==''){
                    if(temp.WhatId!=null)
                        RelatedToId = temp.WhatId ;
                    if(temp.What.Name!=null)
                        RelatedTo = temp.What.Name ; 
                }
                RowMap.put(temp.id,new Row(temp.OwnerId,RelatedToId,RelatedTo,NameId,Name,temp.ActivityDate,temp.Status,temp.id,temp.Subject,AccountId,AccountName)); 
                
                
                // RowMap.put(temp.id,new Row(temp.OwnerId,RelatedToId,RelatedTo,NameId,Name,temp.ActivityDate,temp.Status,temp.id,temp.Subject,AccountId,AccountName));  
            }  
            return RowMap.values();    
        }
        catch(Exception e)
        {
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Warning,'Error is '+e+' Please contact your administrator');
             ApexPages.addMessage(myMsg);
             return null;
        }
    }
    
    
    
}