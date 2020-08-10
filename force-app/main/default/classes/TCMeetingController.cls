public without sharing   class TCMeetingController{
    ApexPages.standardController stdController= null;
    public final TCMeeting__c mysObject {get;private set;}
        public final opportunity Objectopportunity {get; set;}
    ID Oppyid;

    public final String subject {get;private set;}
    public List<opportunity> lstopportunityapprove {get; set;}
    Set<ID> oppyids=new Set<ID>();
public String testing1 ='';
public String testing2 ='';
public String testing3 ='';
public String testing4 ='';
public String testing5 ='';
public String testing6 ='';
public String testing7 ='';
public String testing8 ='';
    public class item_wrapper {
        public item_wrapper(id id,string name,String DealApprovalStatus,string tcmeetingcomments, id approvalid, string recordtype, Boolean approvalwaiting, Opportunity opty, string PersonalApStatus) {
            this.id = id;
            this.name = name;
            this.DealApprovalStatus = DealApprovalStatus;
            this.tcmeetingcomments=tcmeetingcomments;
            this.approvalid =approvalid ;
            this.recordtype = recordtype;
            this.approvalwaiting = approvalwaiting;
            this.opty = opty;
            this.PersonalApStatus = PersonalApStatus;
        }
        public id id { get; set; }
        public string name { get; set; }
        public String DealApprovalStatus { get; set; }
        public string tcmeetingcomments{ get; set; }
        public id approvalid { get; set; }
        public string recordtype{get;set;}
        public Boolean approvalwaiting{get;set;}
        public Opportunity opty{get;set;}
        public string PersonalApStatus{get;set;}
     }
    public list<item_wrapper> items_to_approve { get; set; }
    public TCMeetingController(ApexPages.StandardController controller) {
        Oppyid= ApexPages.currentPage().getParameters().get('id');
        stdController=controller;
        if(Oppyid!=null){
            Objectopportunity=[select id,Owner.name,name,Deal_Comments__c,PLEASE_READ__c,stagename,TC_Meeting_Notes__c,TWSdealLinktoWS__c from Opportunity where id =:Oppyid];
        }
        try{
            mysObject = [Select ID,Name,TC_Meeting_Date__c,(select id,name,TWS_TC_Deal__c,TWS_Worksheet__c,TWS_TC_Deal__r.TC_Meeting_Notes__c,TWS_TC_Deal__r.StageName,TWS_TC_Deal__r.TC_Decision__c,TWS_TC_Deal__r.TWSdealLinktoWS__c 
                                                            from Deal_Meeting_Associations__r) from TCMeeting__c where (TC_Meeting_Date__c >= TODAY) order by TC_Meeting_Date__c limit 1]; 
        }
        catch(exception e){
            system.debug(e.getMessage()+'Debug123#');
        }
        if(mysObject !=null){
            subject = mysObject.TC_Meeting_Date__c.format();
        }
        Set<ID> setOppyids=new Set<ID>();
                if(mysObject !=null){

        List<Deal_Meeting_Association__c> lstdma=[select id,TWS_TC_Deal__c from Deal_Meeting_Association__c where TC_Meeting__c=:mysObject.id ];
        
        for(Deal_Meeting_Association__c objdma:lstdma){
            setOppyids.add(objdma.TWS_TC_Deal__c );
        }
        }
       
        items_to_approve = new list<item_wrapper>();
        map<id,ProcessInstanceWorkItem> mpaPIWIdToPIW = new map<id,ProcessInstanceWorkItem>();
        list<ProcessInstanceWorkItem> lstPIWI = [select Actorid,processinstance.status,processinstance.targetobjectid,CreatedDate ,processinstance.targetobject.name,ProcessInstance.TargetObject.type from processinstanceworkitem where processinstance.targetobjectid in : setOppyids AND Actorid =: userinfo.getuserId() ];
        map<id,Boolean> mapcurrentUserASApprover = new map<id,Boolean>();
        if(!lstPIWI.isEmpty()){
            for(ProcessInstanceWorkItem item: lstPIWI) {
            if(item.actorid == userinfo.getUserId()){
                mapcurrentUserASApprover.put(item.processinstance.targetobjectid, true);   
            } 
                oppyids.add(item.processinstance.targetobjectid);
                if(!mpaPIWIdToPIW.containsKey(item.processinstance.targetobjectid)){
                    mpaPIWIdToPIW.put(item.processinstance.targetobjectid,item); 
                }
            }
        }
        map<id,Opportunity> mapoptyIdtoMeetingnotes = new map<id,Opportunity>();
        map<id,string> mapObjeIdstepStatus = new map<id,string>();
        map<id,string> mapObjeIdPersonStatus = new map<id,string>();
        if(setOppyids.size()>0){        
        list<ProcessInstance> lstprI =[SELECT Id,targetObjectId, (SELECT Id, StepStatus,Actorid, Comments FROM StepsAndWorkitems order by createddate ) FROM ProcessInstance where targetObjectId in :setOppyids order by createddate desc];
        list<ProcessInstance> lstprIs = new list<ProcessInstance>();
        map<id,Boolean> mapUniquePI = new map<id,Boolean>();
        if(!lstprI.isEmpty()){
            for(ProcessInstance PI : lstprI){
                if(!mapUniquePI.containsKey(PI.targetObjectId)) {
                    mapUniquePI.put(PI.targetObjectId,true);  
                    lstprIs.add(PI);  
                }
            }
        }
            if(!lstprIs.isEmpty()){
                for(ProcessInstance PI : lstprIs){
                system.debug('PI.TargetObjectIdI2222222'+PI.TargetObjectId);
                               if(PI.StepsAndWorkitems !=null){
                               for(ProcessInstanceHistory SW : PI.StepsAndWorkitems){
                                   
                                   if(SW.ActorId == userInfo.getUserId() && SW.StepStatus !='Started' ){
                                       system.debug(SW.StepStatus + 'its me' + SW.id +'And Me'+PI.TargetObjectId);
                                      if(!mapObjeIdPersonStatus.containsKey(PI.targetObjectId)){ 
                                        if(SW.StepStatus != 'NoResponse' && SW.StepStatus != 'Removed'){
                                            mapObjeIdPersonStatus.put(PI.targetObjectId, SW.StepStatus);
                                        } else {
                                            mapObjeIdPersonStatus.put(PI.targetObjectId, '');
                                        }
                                        
                                        
                                      }
                                     
                                   }
                               }

                if(PI.StepsAndWorkitems[0].stepstatus !=null  ){
                    mapObjeIdstepStatus.put(PI.TargetObjectId,PI.StepsAndWorkitems[0].stepstatus);
                   }
                   }
                }
            } 
           
            items_to_approve.clear();
            lstopportunityapprove=[select id,Owner.name,name,recordtype.name,type,Deal_Comments__c,PLEASE_READ__c,stagename,TC_Meeting_Notes__c,TWSdealLinktoWS__c,TC_Decision__c  from Opportunity where id in : setOppyids];
            if(!lstopportunityapprove.isEmpty()){
                for(opportunity objoppy:lstopportunityapprove){
                
                string PersonalStatus;
                id PIId;
                Boolean cuurentuserasApprover= false;
                if(mapcurrentUserASApprover.containsKey(objoppy.id)){
                   cuurentuserasApprover = true; 
                }
               
                if(mapObjeIdPersonStatus.containsKey(objoppy.id)){
                    PersonalStatus = mapObjeIdPersonStatus.get(objoppy.id);
                }
                if(mpaPIWIdToPIW.containsKey(objoppy.id)){
                    PIId = mpaPIWIdToPIW.get(objoppy.id).id;
                   
                }
                item_wrapper iw = new item_wrapper(objoppy.id,objoppy.name,objoppy.TC_Decision__c ,objoppy.TC_Meeting_Notes__c,PIId,objoppy.recordtype.name,cuurentuserasApprover,objoppy,PersonalStatus );
                items_to_approve.add(iw); 
                }
                
            }
        }
    }   
     
    public PageReference ApproveNavigate()
    {
        return new PageReference('/apex/TWS_ApprovalHistorypage?id='+ getOpportunityID());
        
    }
    
    public PageReference RejectNavigate(){
        return  new PageReference('/apex/TWS_ApprovalHistorypage?id='+ getOpportunityID());
    }
    
    public PageReference doCancel() {
        return new PageReference('/apex/TWC_ThisWeekTCMeeting');
    }
    
    public PageReference Cancel() {
        if (UserInfo.getUiTheme() == 'Theme4t'){
        	return new PageReference('/_ui/core/chatter/ui/ChatterPage');
        }
        else{
        	return new PageReference('/home/home.jsp');
        }
    }
    
    public ID getOpportunityID() {
        return ApexPages.currentPage().getParameters().get('myParam');
    }
    public PageReference Approve() { 
        processApproval(true);
        return new PageReference('/apex/TWC_ThisWeekTCMeeting');
    }
    public PageReference  processApprove(){
        
        return new PageReference('/' + getOpportunityID());
        
        
    }
    public PageReference Reject() {
        processApproval(false);
        return new PageReference('/apex/TWC_ThisWeekTCMeeting');
    }
    public void processApproval(Boolean isApproved) {
        // First, get the IDs for the WorkItems 
        List<Id> newWorkItemIds = new List<Id>();
        for (List<ProcessInstance> pis : [Select (Select Id,Actorid  From Workitems where Actorid =: userinfo.getuserId()) From ProcessInstance p WHERE p.TargetObjectId = :Oppyid AND p.Status = 'Pending'   ]) {
            for (ProcessInstance pi : pis) {
                for (List<ProcessInstanceWorkitem> wis : pi.Workitems) {
                    for (ProcessInstanceWorkitem wi : wis ) {
                        newWorkItemIds.add(wi.id);
                    }
                }           
            }
        }
        
        // Instantiate the new ProcessWorkitemRequest object and populate it
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
        if (isApproved) {
            req2.setComments(Objectopportunity.Deal_Comments__c);
            req2.setAction('Approve');
        } else {
            req2.setComments(Objectopportunity.Deal_Comments__c);
            req2.setAction('Reject');
        }
      
        // Use the ID from the newly created item to specify the item to be worked
        req2.setWorkitemId(newWorkItemIds.get(0));
        
        // Submit the request for approval
        Approval.ProcessResult result2 =  Approval.process(req2);
        
    }
}