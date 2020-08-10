public with sharing class ViewAllButtonOnContactController {
    
    
    public String ActConId{get;set;} //Stores Id of the current Contact
    public String first3chars{get;set;}  //Stores the prefix of the id.
    public LIst<task> PrivateActivitesTask{get;set;} // List used to store related tasks
    public list<event> PrivateActivitesEvents {get;set;} // list used to store related events
    public Contact conObj{get;set;} // Used to Query related contact
    public String Name{get;set;} //  Used to store contact name
    
    public ViewAllButtonOnContactController()
    {
        ActConId= ApexPages.currentPage().getParameters().get('id');   // Fetch the id passed as an parameter
        if(ActConId != null)
            first3chars=ActConId.substring(0,3);	// identifying prefix of the id
        if(first3chars=='003')
        {
            conObj=[select id,Name FROM Contact WHERE id=:ActConId  Limit 1 ALL ROWS];     // querying related contact for contact name
            Name=conObj.name;
            // query all the tasks related to the current contact 
            PrivateActivitesTask = [select Id,ActivityDate,Description,Priority,What.Name,Status,TaskSubtype,LastModifiedDate,Owner.Name,Subject FROM Task WHERE Contact__c =:ActConId AND IsDeleted = false All ROWS ];
            // query all the events related to the current contact 
            PrivateActivitesEvents = [select Id,ActivityDate,Type,DurationInMinutes,Location,Description,Subject FROM Event WHERE Contact__c =:ActConId AND Isdeleted=false  All ROWS];
        }
        if(PrivateActivitesTask.isEmpty()==true && PrivateActivitesEvents.isEmpty()==true )  // custom message if there are no tasks and events associated.
            Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.INFO, 'There are no Activities associated with the Contact')); //FATAL, WARNING, INFO, CONFIRM
        
    }
    
    public PageReference CancelClick()    
    {
        PageReference pageRef= new PageReference('/'+ActConId);
        return pageRef;
    }
    
    
    
}