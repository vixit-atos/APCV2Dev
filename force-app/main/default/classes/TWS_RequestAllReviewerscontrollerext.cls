/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* One or two sentence summary of this class.
*
* This classes is will give ability to TWS/TC- DOA would  be able to submit a task with the ability to 
* chose to send to one or all of the three reviewing groups
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Hareesh goud nellykonda   
* @modifiedBy          
* @version        1.0
* @created        06-05-2017
* @modified       MM-DD-YYYY
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* modifiedBy            
* MM-DD-YYYY      Explanation of the change.  Multiple lines can be used to explain the change, but
*                 each line should be indented till left aligned with the previous description text.
*
* modifiedBy           
* MM-DD-YYYY      Each change to this file should be documented by incrementing the version number,
*                 and adding a new entry to this @changes list. Note that there is a single blank
*                 line between each @changes entry.
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/


public class TWS_RequestAllReviewerscontrollerext {
    
    
    public List<Task> listtasks{get;set;}
    public Task objcontrolingtask{get;set;}
    public Task objcontrolingtask1{get;set;}
    public Task objcontrolingtask2{get;set;}
    public Task objDTRtask{get;set;}
    public Task objASPtask{get;set;}
    Public String strwhatid{get;set;}
    public Boolean blnContolling {get; set;}
    public Boolean blndisplayContolling {get; set;}
    public Boolean blnDTR {get; set;}
    public Boolean blndisplayDTR {get; set;}
    public Boolean blnASP {get; set;}
    public Boolean blndisplayASP {get; set;}
    set<id> ids = new set<id>();
    public list<Attachment> lstAttach = new list<Attachment>();
    //Picklist of tnteger values to hold file count
    public List<SelectOption> filesCountList {get; set;}
    //Selected count
    public String FileCount {get; set;}
    
    public List<Attachment> allFileList {get; set;}
    
    public TWS_RequestAllReviewerscontrollerext() {
        //Initialize  
        filesCountList = new List<SelectOption>() ;
        FileCount = '' ;
        allFileList = new List<Attachment>() ;
        
        //Adding values count list - 
        for(Integer i = 1 ; i < 6 ; i++)
            filesCountList.add(new SelectOption(''+i , ''+i)) ;
        
        blnContolling=false;
        blnDTR=false;
        blnASP=false;
        
        listtasks =new List<Task>();
        objcontrolingtask =new Task(); 
        objcontrolingtask1 =new Task(); 
        objcontrolingtask2 =new Task(); 
        objDTRtask =new Task(); 
        objASPtask =new Task(); 
        
        strwhatid= ApexPages.currentPage().getParameters().get('id');
        ID TWStaskRecType = Schema.SObjectType.Task.getRecordTypeInfosByName().get('TWS Task').getRecordTypeId();
        
        objcontrolingtask.subject=TWSTaskRequestAllReviews__c.getValues('ControlingTask').Subject__c;
        objcontrolingtask.Description=Label.Controlling_Description;
        objcontrolingtask.whatid=strwhatid; 
        objcontrolingtask.Status=TWSTaskRequestAllReviews__c.getValues('ControlingTask').Status__c;
        objcontrolingtask.Priority=TWSTaskRequestAllReviews__c.getValues('ControlingTask').Priority__c;
        objcontrolingtask.type=TWSTaskRequestAllReviews__c.getValues('ControlingTask').Type__c;
        objcontrolingtask.RecordTypeId=TWStaskRecType;
        
        
        
        // DTR Task
        objDTRtask.subject=TWSTaskRequestAllReviews__c.getValues('DTRTask').Subject__c;
        objDTRtask.Description=Label.DTR_Description;
        objDTRtask.whatid=strwhatid;
        objDTRtask.Status=TWSTaskRequestAllReviews__c.getValues('DTRTask').Status__c;
        objDTRtask.Priority=TWSTaskRequestAllReviews__c.getValues('DTRTask').Priority__c;
        objDTRtask.type=TWSTaskRequestAllReviews__c.getValues('DTRTask').Type__c;
        objDTRtask.RecordTypeId=TWStaskRecType;
        
        // ASP task
        objASPtask.subject=TWSTaskRequestAllReviews__c.getValues('AspTask').Subject__c;
        objASPtask.Description=Label.ASP_Description;
        objASPtask.whatid=strwhatid; 
        objASPtask.Status=TWSTaskRequestAllReviews__c.getValues('AspTask').Status__c;
        objASPtask.Priority=TWSTaskRequestAllReviews__c.getValues('AspTask').Priority__c;
        objASPtask.type=TWSTaskRequestAllReviews__c.getValues('AspTask').Type__c;
        objASPtask.RecordTypeId=TWStaskRecType;
        
        
    }
    public void updateBooleanvaalues() {
        if(blnDTR){
            blndisplayDTR = true;
        }
        else{
            blndisplayDTR = false;
        }
        if(blnContolling){
            blndisplayContolling = true;
        }
        else{
            blndisplayContolling = false;
        }
        
        if(blnASP){
            blndisplayASP = true;
        }
        else{
            blndisplayASP = false;
        }
        
        
    }
    public PageReference ChangeCount()
    {
        allFileList.clear() ;
        //Adding multiple attachments instance
        if(FileCount!=null)
            for(Integer i = 1 ; i <= Integer.valueOf(FileCount) ; i++)
            allFileList.add(new Attachment()) ;
        return null ;
    }
    public PageReference SaveNewTask() { 
        if(blndisplayContolling==true){
            
            String strcontrolligGroup=Label.TWS_Deal_Reviewers_Controlling;
            Group objcontrolligGroupid=[select id from group where Developername=:strcontrolligGroup];
            List<GroupMember> lstGroupMembers = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId =: objcontrolligGroupid.id];
            if(!lstGroupMembers.isEmpty() && blndisplayContolling==true){
                for(GroupMember gm :lstGroupMembers ){
                    Task  objcontrolingtask1 =new Task(); 
                    objcontrolingtask1.ownerid=gm.UserOrGroupId;
                    objcontrolingtask1.subject=objcontrolingtask.Subject;
                    objcontrolingtask1.whatid=strwhatid;
                    objcontrolingtask1.RecordTypeId=objcontrolingtask.RecordTypeId;
                    objcontrolingtask1.Description= objcontrolingtask.Description;
                    objcontrolingtask1.Status=objcontrolingtask.Status;
                    objcontrolingtask1.Priority=objcontrolingtask.Priority;
                    objcontrolingtask1.type=objcontrolingtask.type;
                    
                    objcontrolingtask1.ActivityDate =objcontrolingtask.ActivityDate;
                    listtasks.add(objcontrolingtask1);
                }
                system.debug('11111111##############'+listtasks);       
            }
        }
        if(blndisplayDTR==true){
            
            String strDTRGroup=Label.TWS_Deal_Reviewers_DTR;
            Group objDTRGroupid=[select id from group where Developername=:strDTRGroup];
            List<GroupMember> lstGroupMembers = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId =: objDTRGroupid.id];
            if(!lstGroupMembers.isEmpty() ){
                for(GroupMember gm :lstGroupMembers ){
                    Task  objDTRtask1 =new Task(); 
                    objDTRtask1.ownerid=gm.UserOrGroupId;
                    objDTRtask1.subject=objDTRtask.Subject;
                    objDTRtask1.whatid=strwhatid;
                    objDTRtask1.RecordTypeId=objDTRtask.RecordTypeId;
                    objDTRtask1.Description= objDTRtask.Description;
                    objDTRtask1.Status=objDTRtask.Status;
                    objDTRtask1.Priority=objDTRtask.Priority;
                    objDTRtask1.type=objDTRtask.type;
                    objDTRtask1.ActivityDate  =objDTRtask.ActivityDate;
                    
                    listtasks.add(objDTRtask1);
                    
                    
                }
                system.debug('11111111##############'+listtasks);
            }
        }
        
        /**   ASP Code ***/
        if(blndisplayASP==true){
            String strASPGroup=Label.TWS_Deal_Reviewers_ASP;
            Group objASPGroupid=[select id from group where Developername=:strASPGroup];
            List<GroupMember> lstGroupMembers = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId =: objASPGroupid.id];
            if(!lstGroupMembers.isEmpty() ){
                for(GroupMember gm : lstGroupMembers ){
                    Task  objASPtask1 =new Task(); 
                    objASPtask1.ownerid=gm.UserOrGroupId;
                    objASPtask1.subject=objASPtask.Subject;
                    objASPtask1.whatid=strwhatid;
                    objASPtask1.RecordTypeId=objASPtask.RecordTypeId; 
                    objASPtask1.Description= objASPtask.Description;
                    objASPtask1.Status=objASPtask.Status;
                    objASPtask1.Priority=objASPtask.Priority;
                    objASPtask1.type=objASPtask.type;
                    objASPtask1.ActivityDate  =objASPtask.ActivityDate;                    
                    listtasks.add(objASPtask1);
                    
                    
                }
                system.debug('11111111##############'+listtasks);                            
            }
        }
        /** ASP code end here **/
        
        IF(!listtasks.isEmpty()){
            
            try{
                
                UPSERT listtasks;
                
                
                /** Attachment code **/
                IF(!allFileList.isEmpty()){
                    for(Task t:listtasks){
                        for(Attachment a: allFileList){
                            IF(a.name!=null && a.Body!=null){ 
                                Attachment attchment=new Attachment();
                                attchment.OwnerId = t.OwnerId;  
                                attchment.ParentId = t.id;  
                                attchment.Body=a.Body;
                                attchment.name=a.name;
                                lstAttach.add(attchment);
                            }
                        }
                    }
                    
                    if(!lstAttach.isEmpty()){
                        insert lstAttach;  
                        system.debug('allFileList11111111111'+allFileList);
                        system.debug('lstAttach11111111111'+lstAttach.size());
                        lstAttach=null;
                    }
                }
                
                
                /** attchment code end here **/
                
                
                /** sending email **/
                
                
                Set<ID> taskids=new Set<ID>();
                for(task obj:listtasks){
                    taskids.add(obj.id);
                }
                List<Task> lsttasktosendemail=[select id,owner.email from task where id =:taskids];
                string[] toaddress = New String[] {};
                    Map<id,string> mapEmailAdress=new Map<id,string>();
                system.debug('listtasks1111'+listtasks);
                for(Task t:lsttasktosendemail){
                    system.debug('t.owner.email1111'+t.owner.email);
                    mapEmailAdress.put(t.id,t.owner.email);
                    system.debug('t.owner.email1111'+mapEmailAdress.values().size());

                    
                }
                // attach attchments to  email
               List<Messaging.EmailFileAttachment> lstFileAttachments = new List<Messaging.EmailFileAttachment>();
                
                for(attachment objattcment:allFileList){
                    Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                    if(objattcment.Name!=null && objattcment.body !=null ){
                        efa.setFileName(objattcment.Name);
                        efa.setBody(objattcment.body);
                        lstFileAttachments.add(efa);
                        
                    }
                }
                // end attch attchment email
                
                List<Messaging.SingleEmailMessage> lstEmailId=new List<Messaging.SingleEmailMessage>();
                Contact cont = [select id,name from contact where email ='test@gmtestail.com' limit 1];
                String Emailtemplatename=Label.Task_creation_Alert;
                EmailTemplate emailobj=[select id from EmailTemplate where DeveloperName =:Emailtemplatename ];
                if(!lsttasktosendemail  .isEmpty()){
                    for(Task tk : lsttasktosendemail){
                        system.debug('toaddress1111'+toaddress);
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        String emailids=mapEmailAdress.get(tk.id);
                        mail.setToAddresses(new String[] {emailids});
                        mail.setTemplateId(emailobj.id);
                        mail.setWhatId(tk.id);
                        mail.setTargetObjectId(cont.id);
                        mail.setTreatTargetObjectAsRecipient(false);
                        mail.setSaveAsActivity(false);                                            
                        mail.setFileAttachments(lstFileAttachments);     
                        lstEmailId.add(mail);                 
                        
                    }
                }
                if(lstEmailId.size()>0){
                    
                    system.debug('Print lstEmailId'+lstEmailId);
                    Messaging.sendEmail(lstEmailId);
                     //lstFileAttachments = null; // clears the viewstate
                    
                }
                
                // sending email end here
                
            }Catch(Exception e){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
                return new PageReference('/apex/TWS_RequestAllReviewerspage?id=' +strwhatid );
             }finally {
                  allFileList = null; // clears the viewstate
                 allFileList = new  List<Attachment> ();
                }
            
            
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Please select Group for review request'));
            return new PageReference('/apex/TWS_RequestAllReviewerspage?id=' +strwhatid );
            
        }
       // return new PageReference('/apex/TWS_RequestAllReviewerspage?id=' +strwhatid );
        
        return new PageReference('/' +strwhatid );
        
    } 
    public PageReference Cancel() { 
        return new PageReference('/' +strwhatid );
    }
    
    
    
    
}