public with sharing class ViewAllExtensionController_PrivateNote 
{


     public String ActConId{get;set;} //Stores Account Id of the current Account
     public List<Private_Note__c> PNList {get;set;} // List used to store all the private activities associated with the account
     public List<Private_Note__c> PNListNotes {get;set;}  // List used to store all the task information related to activityid from private Activity
     public List<Attachment> AttachmentList {get;set;}
     public List<Account> AccountList{get;set;} //Stores Account Name of the current Account
     public List<Contact> contactList{get;set;}
     public List<String> AttachmentID{get;set;}
     public String Name{get;set;}
     public Account actObj{get;set;}
     public Contact conObj{get;set;}
     public String first3chars{get;set;}
     
     
    public ViewAllExtensionController_PrivateNote(ApexPages.StandardSetController controller) 
    {

        PNListNotes= new List<Private_Note__c>();
        AttachmentList =new List<Attachment>();
        ActConId= ApexPages.currentPage().getParameters().get('id');
        first3chars=ActConId.substring(0,3);
        System.debug('-sk---'+first3chars);
        if(first3chars=='001')
        {
            actObj=[select id,Name FROM Account WHERE id=:ActConId Limit 1];
            Name=actObj.name;
            System.debug('-sk--actObj-'+actObj);
        }
        else if(first3chars=='003')
        {
            conObj=[select id,Name FROM Contact WHERE id=:ActConId Limit 1];
            Name=conObj.name;
            System.debug('-sk--conObj-'+conObj);
        }
        if(first3chars=='001')
        {
               PNList = [select Name,Account_RL__c,Contact_RL__c,Owner.Name,Body__c,AttachmentID__c FROM Private_Note__c WHERE Account_RL__c =:actObj.id  And IsDeleted=false All ROWS ];
        }
        else if(first3chars=='003')
        {
               PNList = [select Name,Account_RL__c,Contact_RL__c,Owner.name,AttachmentID__c,Body__c FROM Private_Note__c WHERE Contact_RL__c =:conObj.id And IsDeleted=false All ROWS ];
        }
        System.debug('-sk-PAList---'+PNList);
    }
    
    public List<Private_Note__c> getPrivateActivitesNote()
    {
       if(PNList.isEmpty()==true)
           Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.INFO, 'There are no Private Notes and Attachments associated with the Account/Contact')); //FATAL, WARNING, INFO, CONFIRM
       else{ 
                 AttachmentID= new List<String>();
                 for(Private_Note__c A: PNList)
                 { 
                       System.debug('-sk-priv activity-within for loop-'+A);
                       if(A.AttachmentID__c == null)
                       {
                         
                               PNListNotes.Add(A);
                               
                               System.debug('-sk--task obj-'+PNListNotes);
                       }
                 }
            }
       return new List<Private_Note__c>(PNListNotes);
    }

    public List<Attachment> getPrivateActivitesAttachments()
    {
      
       if(PNList.isEmpty()==true)
           Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.INFO, 'There are no Private Notes And Attachments associated with the Account/Contact')); //FATAL, WARNING, INFO, CONFIRM
       else{
                 AttachmentID = new List<String>();
                 for(Private_Note__c A: PNList)
                 {   
                       System.debug('-sk-priv activity-within for loop-'+A);
                       if(A.AttachmentID__c!=null)
                       {
                           String first3charsE=A.AttachmentID__c.substring(0,3);
                           if(first3charsE=='00P')
                           {
                              AttachmentID.add(A.AttachmentID__c);
                           }
                        }
                               
                               
                          
                  }
                 AttachmentList=[select id, Body,Owner.name,parent.name,parent.type,Name,Description from Attachment WHERE Id =:AttachmentID And IsDeleted=false  All ROWS ];
                 System.debug('-sk--task obj-'+AttachmentList);
            }
       return new List<Attachment>(AttachmentList);
    }
    
    public PageReference CancelClick()
    {
               
         PageReference pageRef= new PageReference('/'+ActConId);
               //pageRef.setredirect(true); 
               
         return pageRef;
     }



}