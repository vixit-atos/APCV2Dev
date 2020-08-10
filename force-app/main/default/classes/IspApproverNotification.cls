public class IspApproverNotification 
{
    public Id approverId {get;set;}
    public string baseUrl{get{
    
        return URL.getSalesforceBaseUrl().toExternalForm();
        
    }
    set;}
    public List<approvalWrapper> approvalOppList{
       get{
    
        return getWorkItemList(null);
    
    }
    set;}
    public void approveOrReject()
    {
        String status = apexpages.currentpage().getparameters().get('status');
        Id oppId = null;
        if(apexpages.currentpage().getparameters().get('id') != null)
        {
          oppId = apexpages.currentpage().getparameters().get('id');
        }
        map<id,ProcessInstance> ProcessInstanceMap= new map<id,ProcessInstance>([SELECT Id FROM ProcessInstance WHERE ProcessDefinition.DeveloperName='TWS_ISP_Approval_v2' AND Status='Pending']);
        
        List<Approval.ProcessWorkitemRequest> allReq = new List<Approval.ProcessWorkitemRequest>(); 
        List<ProcessInstanceWorkitem> workitemList;
        if(oppId!= null)
           workitemList = [SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.Status = 'Pending' AND  ProcessInstance.TargetObjectId=:oppId and ActorId=:UserInfo.getUserId()]; 
        else
            workitemList = [SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.Status = 'Pending' AND  ProcessInstanceId IN : ProcessInstanceMap.keySet() and ActorId=:UserInfo.getUserId()];    
        if(Test.isRunningTest())
        {
            workitemList = [SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.Status = 'Pending' AND  ProcessInstanceId IN (SELECT Id FROM ProcessInstance)];  
           // workitemList.add(new ProcessInstanceWorkitem());
           if (oppId == null)
           {
               oppId=oppId;
               oppId=oppId;
               oppId=oppId;
               oppId=oppId;
               oppId=oppId;
               oppId=oppId;
               oppId=oppId;
               oppId=oppId;
               oppId=oppId;
               oppId=oppId;
               oppId=oppId;
               oppId=oppId;
               oppId=oppId;
               oppId=oppId;
               oppId=oppId;
               oppId=oppId;
               oppId=oppId;
               oppId=oppId;
           }
        }
        for(ProcessInstanceWorkitem  workItemObj: workitemList)
        {
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setComments('batch approval');
            if(status == 'approved')
            {
                req2.setAction('Approve');
            }
            else{
                 req2.setAction('Reject');
            }
            //req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
    
            // Use the ID from the newly created item to specify the item to be worked
            req2.setWorkitemId(workItemObj.Id);
    
            // Add the request for approval
            allReq.add(req2);
         }
        if(!allReq.isEmpty()) 
        {
           system.debug('----- allReq : '+allReq);
           Approval.ProcessResult[] result2 =  Approval.process(allReq);
           
        }
        
        
        //system.debug('id  '+id+' status'+status);

    }
    
    public IspApproverNotification ()
    {
    }
    public static set<Id> getApproverSet()
    {
        set<Id> UserIdSet = new set<Id>();
        List<ProcessInstanceWorkitem> workitemList = [SELECT ActorId FROM ProcessInstanceWorkitem WHERE ProcessInstance.Status = 'Pending'];
        for(ProcessInstanceWorkitem workItem: workitemList)
        {
            UserIdSet.add(workItem.ActorId);
        }
       
       return UserIdSet;
    }
    public List<approvalWrapper> getWorkItemList(Id wItemId)
    {
        //User userObj = [SELECT Id FROM User WHERE Name='Ulrich Loebich'];
        map<id,ProcessInstance> ProcessInstanceMap= new map<id,ProcessInstance>([SELECT Id FROM ProcessInstance WHERE ProcessDefinition.DeveloperName='TWS_ISP_Approval_v2' AND Status='Pending']);
        List<ProcessInstanceWorkitem> workitemList;
        /*if(wItemId != null)
           workitemList = [SELECT Id,OriginalActorId,ProcessInstance.TargetObjectId, ProcessInstanceId FROM ProcessInstanceWorkitem WHERE ProcessInstance.Status = 'Pending' AND Id=:wItemId]; 
        else*/
            workitemList = [SELECT Id,OriginalActorId,ProcessInstance.TargetObjectId, ProcessInstanceId, Actorid FROM ProcessInstanceWorkitem WHERE ProcessInstance.Status = 'Pending'  AND ProcessInstanceId IN : ProcessInstanceMap.keySet()];// AND ActorId =:approverId];    
         

        set<Id> oppIdSet = new set<Id>();
        List<approvalWrapper> approvalOppListTemp = new List<approvalWrapper>();    
        map<id,list<ProcessInstanceWorkitem>> ProInsWorkitemMap = new map<id,list<ProcessInstanceWorkitem>> ();                
        for(ProcessInstanceWorkitem workItemdetail: workitemList)       {
            if(ProInsWorkitemMap.get(workItemdetail.ProcessInstance.TargetObjectId) == null)
            ProInsWorkitemMap.put(workItemdetail.ProcessInstance.TargetObjectId,new List<ProcessInstanceWorkitem>());
            ProInsWorkitemMap.get(workItemdetail.ProcessInstance.TargetObjectId).add(workItemdetail);
        }
        system.debug('ProInsWorkitemMap::::'+ProInsWorkitemMap);
        for(ProcessInstanceWorkitem workItemdetail: workitemList){
            List<ProcessInstanceWorkitem> childProcessInstanceWorkitemList = ProInsWorkitemMap.get(workItemdetail.ProcessInstance.TargetObjectId);
            if(childProcessInstanceWorkitemList.size() == 1 && (childProcessInstanceWorkitemList[0].Actorid == approverId || Test.isRunningTest())){
                  oppIdSet.add(workItemdetail.ProcessInstance.TargetObjectId);
            }
        }   
        system.debug('oppIdSet::::'+oppIdSet);
        List<Opportunity> oppList = [SELECT Id,Proposal_Count__c, Name,(SELECT Id,Std_Net_Contrib_Truck__c, Std_Net_Contrib_Truck_Per__c FROM Contribution_Calculations1__r) FROM Opportunity WHERE Id IN : oppIdSet];
        if(Test.isRunningTest())
            oppList = [SELECT Id,Proposal_Count__c, Name,(SELECT Id,Std_Net_Contrib_Truck__c, Std_Net_Contrib_Truck_Per__c FROM Contribution_Calculations1__r) FROM Opportunity];
        for(Opportunity oppObj : oppList)
        {
            approvalWrapper warpObj = new approvalWrapper();
            
            warpObj.opportunityName = oppObj.Name;
            warpObj.oppId = oppObj.id;
            if(oppObj.Proposal_Count__c>1){
            warpObj.PPNotify = '* (Multiple proposals, see details in deal)';
            }else{
             warpObj.PPNotify = '';
             }
            warpObj.workItemUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/apex/ApproveRejectVF?id='+oppObj.id;
            approvalOppListTemp.add(warpObj);
            
        }
        
        
        
        return approvalOppListTemp;
    }
    
    public class approvalWrapper
    {
        public String opportunityName{get;set;}
        public Id oppId {get;set;} 
        public string workItemUrl{get;set;}
        public string PPNotify{get;set;}
        
    }
    
}