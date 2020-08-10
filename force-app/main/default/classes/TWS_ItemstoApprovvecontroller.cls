/**
* -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* One or two sentence summary of this class.
*
* class is used to Custom Approval process 
* -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* @author         Hareesh goud nellykonda   
* @modifiedBy          
* @version        1.0
* @created        01-09-2017
* @modified       MM-DD-YYYY
* -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* @changes
* modifiedBy      Christopher Mcdonald      
* 02-28-2018      Modified ManageAll to redirect WST to WST_ItemsToApprove page. Added Concession Fields VehicleModel, Customername, ContributionMargin
*
* -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* @changes
* modifiedBy      Gilbert Tang      
* 04-20-2018      Modified  ApproveRejectnavigation and REASSIGNnavigation to redirect to Partner side's approval, rejection and reassign
*
* @changes 
* modifiedBy      Rahul Aggarwal
* 06-25-2018      Passed extra parameter OptyId & Modified Navigation url to custom Approval page.Function updated : ApproveRejectnavigation
*
* @changes 
* modifiedBy      Anto Nirmal
* 09-24-2018      Prod fix to revert the changes back
*
* -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
public class TWS_ItemstoApprovvecontroller {
    public static boolean runningInTestMode = false;
    
    ApexPages.standardController stdController= null;
    public TWS_ItemstoApprovvecontroller(ApexPages.StandardController controller) {
        stdController=controller;
    }
    public opportunity Objectopportunity {get; set;}
    public List<opportunity> lstopportunityapprove {get; set;}
    public List<Concession__c> lstConcessionstoapprove {get; set;}
    
    Set<ID> setTargetObjectIDs=new Set<ID>();
               
    public class item_wrapper {
        public item_wrapper(id id,string name,string objtype,String DateSubmited,string tcmeetingcomments, id approvalid,String vehicleModel, String CustomerName, String ConcessionStatus, Decimal Contribution) {
            this.id = id;
            this.selected = false;
            this.name = name;
            this.objtype = objtype;
            this.DateSubmited = DateSubmited;
            this.tcmeetingcomments = tcmeetingcomments;
            this.approvalid = approvalid ;
            this.vehicleModel = vehicleModel;
            this.CustomerName = CustomerName;
            this.ConcessionStatus = ConcessionStatus;
            this.Contribution = Contribution;
        }
        public boolean selected { get; set;}
        public id id { get; set; }
        public string name { get; set; }
        public string objtype { get; set; }
        public String DateSubmited { get; set; }
        public string tcmeetingcomments{ get; set; }
        public id approvalid { get; set; }
        public String vehicleModel {get; set;}
        public String CustomerName {get; set;}
        public String ConcessionStatus { get; set; }
        public Decimal Contribution {get; set;}
    }
    
    public list<item_wrapper> items_to_approve { get; set; }
    
    public TWS_ItemstoApprovvecontroller() {
        items_to_approve = new list<item_wrapper>();
        
        map<id,ProcessInstanceWorkItem> mpaPIWIdToPIW = new map<id,ProcessInstanceWorkItem>();
        list<ProcessInstanceWorkItem> lstPIWI;
        if (runningInTestMode){
            RecordType Rd = [select id,name from recordtype where sobjecttype='Opportunity' AND name = 'TWS-Direct TC'];
            
            Opportunity opp = new Opportunity();
            opp.Name = 'Test Opp';
            opp.Amount = 100;
            opp.CloseDate = Date.today();
            opp.Probability = 90;
            opp.StageName = 'Added to TCM';
            opp.RecordtypeId=Rd.id;
            // insert the new opp
            insert opp;
            system.debug('opp12345'+opp.id);
            ProcessInstance testInstance = new ProcessInstance();
            testInstance.targetObjectId = opp.id;
            ProcessInstanceWorkitem testP = new ProcessInstanceWorkitem(ActorId = UserInfo.getUserId(), 
                                                                        ProcessInstance = testInstance);
            system.debug('testP12345'+testP.id);
            lstPIWI = new List<ProcessInstanceWorkitem>();
            lstPIWI.add(testP);
        }else{
            
            lstPIWI = [select processinstance.targetobjectid,CreatedDate ,processinstance.targetobject.name,ProcessInstance.TargetObject.type from processinstanceworkitem where actorid = :userinfo.getuserid() Order by CreatedDate Desc];
        }
        if(!lstPIWI.isEmpty()){
            for(ProcessInstanceWorkItem item: lstPIWI) {
                setTargetObjectIDs.add(item.processinstance.targetobjectid);
                if(!mpaPIWIdToPIW.containsKey(item.processinstance.targetobjectid)){
                    mpaPIWIdToPIW.put(item.processinstance.targetobjectid,item); 
                }
            }
        }
        
        map<id,Opportunity> mapoptyIdtoMeetingnotes = new map<id,Opportunity>();
        map<id,Concession__c> mapConcessionIdtoConcessionstatus = new map<id,Concession__c>();
        
        if(setTargetObjectIDs.size()>0){
            lstopportunityapprove=[select id,Owner.name,name,Deal_Comments__c,stagename,TC_Meeting_Notes__c,CONC_STATUS_CD__c  from Opportunity where id in : setTargetObjectIDs];
            if(!lstopportunityapprove.isEmpty()){
                for(opportunity objoppy:lstopportunityapprove){
                    mapoptyIdtoMeetingnotes.put(objoppy.id,objoppy);
                }
            }
        }
        if(setTargetObjectIDs.size()>0){
            lstConcessionstoapprove =[select id,name, VEH_MDL_NO__c, CUST_NAME_50__c, CONC_STATUS_CD__c, APPR_NET_CNTRB__C from Concession__c where id in : setTargetObjectIDs];
            if(!lstConcessionstoapprove.isEmpty()){
                for(Concession__c  objConcession : lstConcessionstoapprove ){
                    mapConcessionIdtoConcessionstatus .put(objConcession.id,objConcession );
                }
            }
        }
        if(!lstPIWI.isEmpty()){
            
            for(ProcessInstanceWorkItem item: mpaPIWIdToPIW.values()) {
                
                String dateTimeValue = item.CreatedDate.format('MM/dd/yyyy hh:mm a');
                
                system.debug(dateTimeValue +'Debug2 dateTimeValue ');
                
                if(item.processinstance.TargetObject.type == 'Opportunity'){
                    system.debug(item.processinstance.targetobjectid +'Debug2 dateTimeValue ');
                    
                    items_to_approve.add(new item_wrapper(item.processinstance.targetobjectid,item.processinstance.targetobject.name,item.processinstance.TargetObject.type,dateTimeValue ,mapoptyIdtoMeetingnotes.get(item.processinstance.targetobjectid).TC_Meeting_Notes__c,item.id,'','','', 0)); 
                }else if(item.processinstance.TargetObject.type == 'Concession__c'){
                    system.debug(item.processinstance.targetobjectid +'Debug2 dateTimeValue ');
                    
                    
                    String sObjName = item.processinstance.targetobjectid.getSObjectType().getDescribe().getLabel();   
                    system.debug(sObjName +'sObjNameValue ');
                    
                    items_to_approve.add(new item_wrapper(item.processinstance.targetobjectid,item.processinstance.targetobject.name,sObjName ,dateTimeValue ,'',item.id,mapConcessionIdtoConcessionstatus.get(item.processinstance.targetobjectid).VEH_MDL_NO__c, mapConcessionIdtoConcessionstatus.get(item.processinstance.targetobjectid).CUST_NAME_50__c, mapConcessionIdtoConcessionstatus.get(item.processinstance.targetobjectid).CONC_STATUS_CD__c, mapConcessionIdtoConcessionstatus.get(item.processinstance.targetobjectid).APPR_NET_CNTRB__C));   
                }else{
                    String sObjName = item.processinstance.targetobjectid.getSObjectType().getDescribe().getLabel();   
                    system.debug(sObjName +'sObjNameValue ');
                    items_to_approve.add(new item_wrapper(item.processinstance.targetobjectid,item.processinstance.targetobject.name,sObjName ,dateTimeValue ,'',item.id,'','','',0 )); 
                    
                }
            }
        }
    }  
    
    public  static String ApproveRejectnavigation() 
    { 
        String url='';  
        string itemid = apexpages.currentpage().getparameters().get('myParam'); 
        string optyid=''; 
        optyid = apexpages.currentpage().getparameters().get('Parmoptyid');                   
        String urlTest = Apexpages.currentPage().getUrl();
        //url='https://'+ System.URL.getSalesforceBaseUrl().getHost() +   
        //    '/apex/TWS_OptyItemApproval?id=' + optyid + '&workitemid=' + itemid;
        url='https://'+ System.URL.getSalesforceBaseUrl().getHost() + 
            '/p/process/ProcessInstanceWorkitemWizardStageManager?id=' + itemid ;
        
        if(optyid == null)
        {
            url='https://'+ System.URL.getSalesforceBaseUrl().getHost() + Site.getPathPrefix()  + 
                '/p/process/ProcessInstanceWorkitemWizardStageManager?id=' + itemid ;
        }
        else if(optyid.left(3) == '006')
        {
            url='https://'+ System.URL.getSalesforceBaseUrl().getHost() + Site.getPathPrefix()  + 
                '/apex/TWS_OptyItemApproval?id=' + optyid + '&workitemid=' + itemid;
        }
        else
        {
            url='https://'+ System.URL.getSalesforceBaseUrl().getHost() + Site.getPathPrefix()  + 
                '/p/process/ProcessInstanceWorkitemWizardStageManager?id=' + itemid ;
        }
        system.debug('------' + itemid);    
        return url;          
    }
    
    public  static String REASSIGNnavigation() 
    { 
        String url='';
        string myParam = apexpages.currentpage().getparameters().get('myParam');
        String urlTest = Apexpages.currentPage().getUrl();
        url='https://'+ System.URL.getSalesforceBaseUrl().getHost() + Site.getPathPrefix() + '/'+ myParam +'/e?et=REASSIGN';
        return url;
    }
    
    public  static String Manageall() 
    {
        String url='';
        string myParam = apexpages.currentpage().getparameters().get('myParam');
        List<profile> userProfile = [Select Name from Profile Where ID =: userInfo.getProfileID() LIMIT 1];
        if(userProfile[0].Name == 'DTNA - WST Sales' || userProfile[0].Name == 'DTNA - WST DOA' || userProfile[0].Name == 'DTNA - FTL Sales' || userProfile[0].Name == 'DTNA - FTL DOA' || userProfile[0].Name == 'System Administrator')
        {
            url='https://'+ System.URL.getSalesforceBaseUrl().getHost()+'/apex/ManageAllApprovals';  
        }
        else
        {
            url='https://'+ System.URL.getSalesforceBaseUrl().getHost()+'/04i';  
        } 
        return url;  
        
    }
    
    
}