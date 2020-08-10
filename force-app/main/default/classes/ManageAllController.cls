/**
* ---------------------------------------------------------------------------------------------------
* @author         Christopher McDonald   
* @modifiedBy          
* @version        1.0
* @created        02-14-2018
* @modified       
* ---------------------------------------------------------------------------------------------------
* @changes
* modifiedBy            
* MM-DD-YYYY      Creation of a Manage All screen. Used for Concession Approvals for WST Sales profiles.
*
* ---------------------------------------------------------------------------------------------------
*/
public with sharing class ManageAllController{
    public List<Concession__c> lstConcessionstoapprove {get; set;} //Holds Concessions for Approval
    public string inputtedComment {get; set;}   //Comment from Page
    Set<ID> setTargetObjectIDs = new Set<ID>();
    public list<item_wrapper> items_to_approve { get; set; } //Entire Items to Approve for the user
    public Concession__c searchUserThroughConcession {get; set;} //Concession to lookup Users on and stores on OwnerID
    public List<item_wrapper> selectedApprovals {get; private set;} //List of all the approvals selected by the user.
    public List<Item_Wrapper> items_to_approve_pageList { get; set;} //List to display to the user of the Items to Approve
    public integer totalRecs {get; set;} //Items to Approve maximum size
    public integer OffsetSize {get; set;} //Current location for the page 
    public integer LimitSize {get; set;} //Limit for the pages
    
    public class item_wrapper {
        public item_wrapper(id id,string name,String DateSubmitted, id approvalid,String vehicleModel, String CustomerName, String ConcessionStatus, Decimal Contribution ) {
            this.id = id;
            this.selected = false;
            this.name = name;
            this.DateSubmitted = DateSubmitted;
            this.approvalid = approvalid ;
            this.vehicleModel = vehicleModel;
            this.CustomerName = CustomerName;
            this.ConcessionStatus = ConcessionStatus;
            this.Contribution = Contribution;
        }
        public boolean selected { get; set;}
        public id id { get; set; }
        public string name { get; set; }
        public String DateSubmitted { get; set; }
        public id approvalid { get; set; }
        public String vehicleModel {get; set;}
        public String CustomerName {get; set;}
        public String ConcessionStatus { get; set; }
        public Decimal Contribution {get;set;}
    }
    
    public ManageAllController() {
        totalRecs = 0;
        OffsetSize = 0;
        LimitSize = 25;
        
        items_to_approve_pageList = new list<item_wrapper>();
        items_to_approve = new list<item_wrapper>();
        searchUserThroughConcession = new Concession__c();
        
        
        list<ProcessInstanceWorkItem> lstPIWI;
        lstPIWI = [select processinstance.targetobjectid, CreatedDate, processinstance.targetobject.name, ProcessInstance.TargetObject.type from processinstanceworkitem where actorid = :userinfo.getuserid() Order by CreatedDate Desc];
        map<id,ProcessInstanceWorkItem> ConcessionPIWIMap = getConcessionProcessInstanceWorkItemMap(lstPIWI);
        Map<id,Concession__c> mapConcessionIdtoConcessionstatus = getConcessionMapForItemWrappers();
        createItemWrappers(lstPIWI, ConcessionPIWIMap, mapConcessionIdtoConcessionstatus);
    }    
    
    public Map<Id, ProcessinstanceWorkItem> getConcessionProcessInstanceWorkItemMap(List<ProcessInstanceWorkItem> lstPIWI){
        map<id,ProcessInstanceWorkItem> ConcessionPIWIMap = new map<id,ProcessInstanceWorkItem>();
        if(!lstPIWI.isEmpty()){
            for(ProcessInstanceWorkItem item: lstPIWI) {
                setTargetObjectIDs.add(item.processinstance.targetobjectid);
                if(!ConcessionPIWIMap.containsKey(item.processinstance.targetobjectid)){
                    ConcessionPIWIMap.put(item.processinstance.targetobjectid,item); 
                }
            }
        }
        return ConcessionPIWIMap;
    }
    
    public Map<ID,Concession__c> getConcessionMapForItemWrappers(){
        Map<ID,Concession__c> mapConcessionIdtoConcessionstatus = new Map<ID,Concession__c>();
        if(setTargetObjectIDs.size()>0){
            lstConcessionstoapprove =[select id,name, VEH_MDL_NO__c, CUST_NAME_50__c, CONC_STATUS_CD__c, APPR_NET_CNTRB__C from Concession__c where id in : setTargetObjectIDs LIMIT 1000];
            if(!lstConcessionstoapprove.isEmpty()){
                for(Concession__c  objConcession : lstConcessionstoapprove ){
                    mapConcessionIdtoConcessionstatus.put(objConcession.id,objConcession);
                }
            }
        }
        return mapConcessionIdtoConcessionstatus;
    }
    
    public void createItemWrappers(List<ProcessInstanceWorkItem> lstPIWI, Map<Id,ProcessInstanceWorkItem> ConcessionPIWIMap, Map<Id,Concession__c> mapConcessionIdtoConcessionstatus){
        if(!lstPIWI.isEmpty()){
            for(ProcessInstanceWorkItem item: ConcessionPIWIMap.values()) {
                String dateTimeValue = item.CreatedDate.format('MM/dd/yyyy hh:mm a');
                
                if(item.processinstance.TargetObject.type == 'Concession__c'){
                    items_to_approve.add(new item_wrapper(item.processinstance.targetobjectid,item.processinstance.targetobject.name,dateTimeValue,item.id,mapConcessionIdtoConcessionstatus.get(item.processinstance.targetobjectid).VEH_MDL_NO__c, mapConcessionIdtoConcessionstatus.get(item.processinstance.targetobjectid).CUST_NAME_50__c, mapConcessionIdtoConcessionstatus.get(item.processinstance.targetobjectid).CONC_STATUS_CD__c, mapConcessionIdtoConcessionstatus.get(item.processinstance.targetobjectid).APPR_NET_CNTRB__C));   
                }
            }
            totalRecs = items_to_approve.size();
            FirstPage();
        }
    }
    
    public PageReference itemsApproveRedirect(String location){
        String finalLocation = '/apex/' + location;
        PageReference pref = new PageReference(finalLocation);
        pref.setRedirect(false);
        string myParam;
        selectedApprovals = new List<item_wrapper>();
        for(item_wrapper iw : items_to_approve){
            if(iw.selected == true){
                selectedApprovals.add(iw);
            }
        }
        if(selectedApprovals.size() == 0){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, 'Please select records'));
            return null;
        }
        return pref;
    }
    
    public PageReference goToMassReassign(){
        String location = 'MassApprovalReassign';
        PageReference pref = itemsApproveRedirect(location);
        return pref;
    }
    
    public PageReference goToMassApproveReject(){
        String location = 'MassApprovalApproveReject';
        PageReference pref = itemsApproveRedirect(location);
        return pref;
    }

    public Id getWorkItemId(Id targetObjectId){
        Id piwiID = null;
        for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: targetObjectId AND p.ProcessInstance.Status = 'Pending']){
            piwiID  =  workItem.Id;
        }
        return piwiID;
    }
    
    public List<ID> getWorkItemIds(){
        List<ID> workItems = new List<ID>();
        for(item_wrapper item : items_to_approve){
            if(item.selected == true){
                workItems.add(getWorkItemID(item.id));
            }
        }
        return workItems;
    }
    
    public void processApprovals(List<ID> workItems, String action){
        for(ID workID : workItems){
                Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                req.setComments(inputtedComment); 
                req.setAction(action);
                req.setWorkItemID(workID);
                Approval.ProcessResult result =  Approval.process(req);
        }
    }
    
    public String massApprove(){
        List<ID> workItemList = getWorkItemIds();
        if(workItemList != null || workItemList.size() > 0){
            processApprovals(workItemList, 'Approve');
        }
        return 'https://'+ System.URL.getSalesforceBaseUrl().getHost()+'/home/home.jsp';
    }
    
    public String massReject(){
        List<ID> workItemList = getWorkItemIds();
        boolean redirect = false;
        if(workItemList != null || workItemList.size() > 0){
            redirect = true;
            processApprovals(workItemList, 'Reject');
        }
        return 'https://'+ System.URL.getSalesforceBaseUrl().getHost()+'/home/home.jsp';
    }
    
    public String massReassign(){
        List<ID> workItemList = getWorkItemIds();
        if(workItemList != null || workItemList.size() > 0){
            if(searchUserThroughConcession.ownerID != null){
                processReassigns(workItemList);
            }
        }
        return 'https://'+ System.URL.getSalesforceBaseUrl().getHost()+'/home/home.jsp';
    }

    public void processReassigns(List<ID> workItems){
        List<ID> approverIDS = new List<ID>();
        approverIDs.add(searchUserThroughConcession.ownerID);
        List<ID> approvalIds = new List<ID>();
        List<ProcessInstanceWorkItem> piwiList = new List<ProcessInstanceWorkItem>();
        
        for(item_wrapper item : items_to_approve_pageList){
            if(item.selected == true){
                approvalIds.add(item.approvalId);
            }
        }
        
        For(ProcessinstanceWorkItem piwi : [Select ID, ActorID From ProcessInstanceWorkItem where ID =: approvalIds]){
            ProcessInstanceWorkItem updatedPiwi = new ProcessInstanceWorkItem();
            updatedPiwi.Id = piwi.id;
            updatedPiwi.actorId = searchUserThroughConcession.ownerId;
            piwiList.add(updatedpiwi);
        }
        update piwiList;
    }
    
    //Pagination
    public List<Item_Wrapper> getNewList(Integer startingLocation, Integer endingLocation){
        List<Item_Wrapper> newList = new List<Item_Wrapper>();
        Integer limiter = LimitSize;
        
        if(OffsetSize+LimitSize > totalRecs){
                limiter = totalRecs;
        }
        
        if(endingLocation == totalrecs){
            for(integer i = 0; i < limiter; i++){
                if(OffsetSize+i < totalrecs){
                    newlist.add(items_to_approve[OffsetSize+i]);
                }
            }
        }else{
            for(Integer i = startingLocation; i < limiter; i++){
                if(items_to_approve[i] != null){
                    newList.add(items_to_approve[i]);   
                }
            }
        }
        return newList;
    }
    
    public void FirstPage(){
        offsetSize = 0;     
        items_to_approve_pageList.clear();
        items_to_approve_pageList.addall(getNewList(offsetSize, limitSize));
    }
    
    public void previous(){
        OffsetSize = OffsetSize - LimitSize;
        items_to_approve_pageList.clear();
        items_to_approve_pageList.addall(getNewList(offsetSize, totalRecs));
    }
    
    public void next(){
        OffsetSize = OffsetSize + LimitSize;
        items_to_approve_pageList.clear();
        items_to_approve_pageList.addall(getNewList(offsetSize, totalRecs));
    }
    
    public void LastPage(){
        OffsetSize = totalrecs - math.mod(totalRecs,LimitSize);
        items_to_approve_pageList.clear();
        items_to_approve_pageList.addall(getNewList(OffsetSize, totalrecs));
    }
    
    public boolean getprev(){
        if(OffsetSize == 0) return true;
        else return false;
    }
    
    public boolean getnxt(){
        if((OffsetSize + LimitSize) > totalRecs || (OffsetSize + LimitSize) == totalRecs) return true;
        else return false;
    }
    
    //Redirects
    public  static String ApproveRejectnavigation() { 
        String url='';  
        string myParam = apexpages.currentpage().getparameters().get('myParam'); 
        String urlTest = Apexpages.currentPage().getUrl();
        if(urlTest.contains('Employee')){
        url='https://'+ System.URL.getSalesforceBaseUrl().getHost() +   
            '/Employee/p/process/ProcessInstanceWorkitemWizardStageManager?id=' + myParam ;
            }else{
            url='https://'+ System.URL.getSalesforceBaseUrl().getHost() +   
            '/p/process/ProcessInstanceWorkitemWizardStageManager?id=' + myParam ;
            }
        system.debug('------' + myParam);    
        return url;  
        
    }
    public  static String REASSIGNnavigation() { 
        String url='';  
        string myParam = apexpages.currentpage().getparameters().get('myParam'); 
        String urlTest = Apexpages.currentPage().getUrl();
        if(urlTest.contains('Employee')){
        url='https://'+ System.URL.getSalesforceBaseUrl().getHost()+'/Employee/'+ myParam +'/e?et=REASSIGN'; 
        }else{
        url='https://'+ System.URL.getSalesforceBaseUrl().getHost()+'/'+ myParam +'/e?et=REASSIGN'; 
        }     
        return url;  
        
    }
    public String goBack(){
        return 'https://'+ System.URL.getSalesforceBaseUrl().getHost()+'/apex/ManageAllApprovals';   
    }
    public Boolean checkSelected(){
        Boolean check = false;
        
        for(item_wrapper iw : items_to_approve_pageList){
            if (iw.selected == true){
                check = true;
            }
        }
        
        return check;
    }
}