public class ViewAllExtensionController 
{

     public String ActConId{get;set;} //Stores Account Id of the current Account
     public List<Private_Activity__c> PAList {get;set;} // List used to store all the private activities associated with the account
     public List<Task> activitytask {get;set;} // List used to store all the task information related to activityid from private Activity
     public List<Event> eventList {get;set;}// List used to store events.
     public List<Account> AccountList{get;set;} //Stores Account Name of the current Account
     public List<Contact> contactList{get;set;} // Stores the Contact of current Contact.
     public List<String> Activityid{get;set;}//Stores the activity ids.
     public String Name{get;set;}
     public Account actObj{get;set;}
     public Contact conObj{get;set;}
     public String first3chars{get;set;}
      
     
    public ViewAllExtensionController(ApexPages.StandardSetController controller)
    {
        activitytask= new List<Task>();
        eventList =new List<Event>();
        
        
        ActConId= ApexPages.currentPage().getParameters().get('id');
        first3chars=ActConId.substring(0,3);
        System.debug('-sk---'+first3chars);
        if(first3chars=='001')
        {
            actObj=[select id,Name FROM Account WHERE id=:ActConId  Limit 1 ALL ROWS ];
            Name=actObj.name;
            System.debug('-sk--actObj-'+actObj);
        }
        else if(first3chars=='003')
        {
            conObj=[select id,Name FROM Contact WHERE id=:ActConId  Limit 1 ALL ROWS];
            Name=conObj.name;
            System.debug('-sk--conObj-'+conObj);
        }
        if(first3chars=='001')
        {
               PAList = [select Name,Account__c,Contact_RL__c,Due_Date__c,Subject__c,Activity_ID__c FROM Private_Activity__c WHERE Account__c =:actObj.id  ALL ROWS ];
        }
        else if(first3chars=='003')
        {
               PAList = [select Name,Account__c,Contact_RL__c,Due_Date__c,Subject__c,Activity_ID__c FROM Private_Activity__c WHERE Contact_RL__c =:conObj.id  ALL ROWS ];
        }
        System.debug('-sk-PAList---'+PAList);
               
    }
    
    public List<Task> getPrivateActivitesTask()
    {
    
       if(PAList.isEmpty()==true)
           Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.INFO, 'There are no Private Activities associated with the Account/Contact')); //FATAL, WARNING, INFO, CONFIRM
       else
       { 
           Activityid= new List<String>();
           for(Private_Activity__c A: PAList)
           { 
               System.debug('-sk-priv activity-within for loop-'+A);
               if(A.Activity_ID__c!=null)
               {
                  String   first3charsT=A.Activity_ID__c.substring(0,3);
                  if(first3charsT=='00T')
                  {
                    Activityid.add(A.Activity_ID__c);
                          
                  }
               }
                                     
            }
            activitytask = [select Id,ActivityDate,Description,Priority,What.Name,Status,TaskSubtype,LastModifiedDate,Owner.Name,Subject FROM Task WHERE Id =:Activityid AND IsDeleted = false All ROWS ];
                           
            System.debug('-sk--task obj-'+activitytask);
       }
       return new List<Task>(activitytask);
    }

    public List<Event> getPrivateActivitesEvents()
    {
      
       if(PAList.isEmpty()==true)
           Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.INFO, 'There are no Private Activities associated with the Account/Contact')); //FATAL, WARNING, INFO, CONFIRM
       else
       {
             Activityid= new List<String>();
             for(Private_Activity__c A: PAList)
             {   
                 System.debug('-sk-priv activity-within for loop-'+A);
                 if(A.Activity_ID__c!=null)
                 {
                     String first3charsE=A.Activity_ID__c.substring(0,3);
                     if(first3charsE=='00U')
                     {
                         Activityid.add(A.Activity_ID__c);
                          
                     }
                 }
                           
                           
             }
             eventList=[select Id,ActivityDate,Type,DurationInMinutes,Location,Description,Subject FROM Event WHERE Id =:Activityid AND Isdeleted=false  All ROWS];
             System.debug('-sk--task obj-'+eventList);
                      
       }
       return new List<Event>(eventList);
     }
    
     public PageReference CancelClick()
     {
               
         PageReference pageRef= new PageReference('/'+ActConId);
               //pageRef.setredirect(true); 
           
         return pageRef;
     }



}