public class OpportunityTriggerHandler extends TriggerHandler {
    
    
    private static final String STAGE_PA = 'Pending Approval';
    private static final Integer MAX_APPROVERS = 20;
    @testvisible private map<id, RecordType> rtMap;
    private map<id, RecordType> MapCRMOppyRecordtypidName;

    
    public OpportunityTriggerHandler() {
        
        Set<String> ort = RT_Approval_Process_Map__c.getAll().keySet();
       Set<String> SetTWSOppyRecordtypName =new Set<String> ();
       /*   TWSAdminaccess__c field is to determine TWS admin have access to only TWS opportunity records and he can’t delete or edit CRM opportunity records. */
      List<TWS_Record_Type_Map__c> lstCRMOppyRecordtypName = [select id,name from TWS_Record_Type_Map__c where TWSAdminaccess__c=True];
        for(TWS_Record_Type_Map__c objTWSRT : lstCRMOppyRecordtypName){
            SetTWSOppyRecordtypName.add(objTWSRT.name);
        }
        rtMap = new Map<id, RecordType>([SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Opportunity' and DeveloperName in :ort]);
        MapCRMOppyRecordtypidName = new Map<id, RecordType>([SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Opportunity' and DeveloperName  NOT in :SetTWSOppyRecordtypName]);
    }
    
    /* context overrides */
    
    protected override void afterInsert() {
        UpdateRGMNAD();
        for (Opportunity o : (List<Opportunity>) Trigger.new) {
            if (o.Related_TC_Deal__c == null && rtMap.containsKey(o.recordTypeId)) {
                prepopulateApprovers(o);
            }
        }
    }
    
    protected override void beforeUpdate() {
    preventdeletingrecords();
        
        processOpportunities();
        UpdateRGMNADNotificationRecipient();           
    
    }
    protected override void afterupdate() {
    if(CheckRecursive.runonce()){
         Lockrecordafterpublish() ;
        prepopulateApproversDTRRequested();
    }
    }
    protected override void afterdelete() {
         preventdeletingrecords();
    }
    @TestVisible private void prepopulateApprovers(Opportunity o) {
        
        //brand
        
        List<String> brands = new List<String>();
        
        //tws approvers
        List<TWS_Approver__c> oppApproverList = new List<TWS_Approver__c>();
        
        //sales contract approvers
        //  List<Sales_Contract_Approver__c> scApproverList = new List<Sales_Contract_Approver__c>();
        
        brands.add(o.Make__c);
        brands.add('ALL');
        
        
        //which process are we targeting?
        
        String rtName = rtMap.get(o.RecordTypeId).DeveloperName;
        String procName = RT_Approval_Process_Map__c.getInstance(rtName).Picklist_Value__c;
        for (Approver_Configuration__c a : [SELECT Approver__c FROM Approver_Configuration__c WHERE Make__c IN :brands and Process__c = :procName and (OppyOwner__c =null OR (OppyOwner__c=:userinfo.getuserid() and OppyOwner__c !=null))]) {            
            oppApproverList.add(new TWS_Approver__c(TWS_Deal__c = o.id, TWS_Approver__c = a.Approver__c, Actual_Approver__c = a.Approver__c));
        }
        if(o.DTR_Requested_to_Quote_Residual__c == true || o.DTR_Requested_to_Quote_Trades__c == true ){
            for (Approver_Configuration__c a : [SELECT Approver__c FROM Approver_Configuration__c WHERE Make__c='DTR'  and Process__c = :procName ]) {
                oppApproverList.add(new TWS_Approver__c(TWS_Deal__c = o.id, TWS_Approver__c = a.Approver__c, Actual_Approver__c = a.Approver__c));
            }
        }
        
        /* procName = RT_Approval_Process_Map__c.getInstance(rtName).Process_2_Picklist_Value__c;

if (procName != null) 
{
for (Approver_Configuration__c a : [SELECT Approver__c FROM Approver_Configuration__c WHERE Make__c IN :brands and Process__c = :procName ]) 
{
//TO clean Anto       scApproverList.add(new Sales_Contract_Approver__c(TWS_Deal__c = o.id, Contract_Approver__c = a.Approver__c));
}
} */
        //  insert scApproverList;
        insert oppApproverList;
        
    }
    // HN added code start for 80128 
    
 @TestVisible   private void prepopulateApproversDTRRequested() {
 
  /** Prepopulate the Approvers from TC to SP  **/ 
  list<Approver_Configuration__c> lstac = [SELECT Approver__c,Process__c FROM Approver_Configuration__c WHERE Make__c='DTR' ];
     Map<id, RecordType> OpprtMap = new Map<id, RecordType>([SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Opportunity']);
        set<Id> setOpptyId = new set<Id>();
        for (Opportunity objoppynew : (List<Opportunity>) Trigger.new) {
            for(Opportunity objoppyold : (List<Opportunity>) Trigger.old) {
                if (objoppyold.Related_TC_Deal__c == null && rtMap.containsKey(objoppyold.recordTypeId)) {
                    Opportunity oldOpp = (Opportunity)trigger.oldMap.get(objoppynew.Id) ;
                    Opportunity NewOpp = (Opportunity)trigger.NewMap.get(objoppynew.Id) ; 
                    if((oldOpp.DTR_Requested_to_Quote_Residual__c != NewOpp.DTR_Requested_to_Quote_Residual__c) || (oldOpp.DTR_Requested_to_Quote_Trades__c != NewOpp.DTR_Requested_to_Quote_Trades__c)) {
                        setOpptyId.add(objoppynew.id);
                    }
                }
            }
        }
        map<id,string> mapoptyidToRecordType = new map<id,string>();
        list<Opportunity> lstOpptys = [select id,recordtype.developername from Opportunity where ID IN:setOpptyId];
        for(Opportunity opty : lstOpptys){
            mapoptyidToRecordType.put(opty.id,opty.recordtype.developername);    
        }
        set<id> delApproverOppids = new set<id>();
        List<TWS_Approver__c> NewoppApproverList = new List<TWS_Approver__c>();
        for (Opportunity objoppynew : (List<Opportunity>) Trigger.new) 
        {
            for(Opportunity objoppyold : (List<Opportunity>) Trigger.old) 
            {
                Opportunity Oppold = (Opportunity)Trigger.oldMap.get(objoppynew.id); 
                System.debug('recordtype'+objoppynew.RecordTypeId);
                System.debug('recordtype1'+Oppold.RecordTypeId);
                if(OpprtMap.get(objoppynew.RecordTypeId)!= OpprtMap.get(Oppold.RecordTypeId))//.DeveloperName
                {
                    delApproverOppids.add(objoppynew.id);
                    List<String> brands = new List<String>();
                    brands.add(objoppynew.Make__c);
                    brands.add('ALL');

                    String rtName = OpprtMap.get(objoppynew.RecordTypeId).DeveloperName;
                    String procName = RT_Approval_Process_Map__c.getInstance(rtName).Picklist_Value__c;
                    System.debug('procName '+procName );
                    System.debug('rtName'+rtName);
                    for (Approver_Configuration__c a : [SELECT Approver__c FROM Approver_Configuration__c WHERE Make__c IN :brands and Process__c = :procName and (OppyOwner__c =null OR (OppyOwner__c=:userinfo.getuserid() and OppyOwner__c !=null))]) 
                    {
                        NewoppApproverList.add(new TWS_Approver__c(TWS_Deal__c = objoppynew.id, TWS_Approver__c = a.Approver__c, Actual_Approver__c = a.Approver__c));
                    }
                    if(((objoppynew.DTR_Requested_to_Quote_Residual__c) ||  (objoppynew.DTR_Requested_to_Quote_Trades__c )) && ((objoppyold.DTR_Requested_to_Quote_Residual__c) || (objoppyold.DTR_Requested_to_Quote_Trades__c )) )
                    {
                        for(Approver_Configuration__c aca : lstac)
                        {
                            if(aca.Process__c ==RT_Approval_Process_Map__c.getInstance(mapoptyidToRecordType.get(objoppynew.id)).Picklist_Value__c)
                                NewoppApproverList.add(new TWS_Approver__c(TWS_Deal__c = objoppynew.id, TWS_Approver__c = aca.Approver__c, Actual_Approver__c = aca.Approver__c));
                        }
                    }
                }
            }
        } 
    
     List<TWS_Approver__c> oppApproverDelList = [select id,TWS_Deal__c from TWS_Approver__c where TWS_Deal__c = : delApproverOppids];
        Delete oppApproverDelList;
        insert NewoppApproverList;
        
        
        List<TWS_Approver__c> oppApproverList = new List<TWS_Approver__c>();
        map<id,list<TWS_Approver__c>> mapOpptyIdToOpptyApprId = new map<id,list<TWS_Approver__c>>();
        map<id,TWS_Approver__c> mapAprIdToOpptyApprId = new map<id,TWS_Approver__c>();
    //     map<id,string> mapoptyidToRecordType = new map<id,string>();
    //     list<Opportunity> lstOpptys = [select id,recordtype.developername from Opportunity where ID IN:setOpptyId];
        for(Opportunity opty : lstOpptys){
            mapoptyidToRecordType.put(opty.id,opty.recordtype.developername);    
        }
        if(!setOpptyId.isEmpty()){
            oppApproverList = [select id,TWS_Deal__c,TWS_Approver__c from TWS_Approver__c where TWS_Deal__c IN : setOpptyId];
            for(TWS_Approver__c tw : oppApproverList){
                mapAprIdToOpptyApprId.put(tw.TWS_Approver__c,tw);
                
                if(mapOpptyIdToOpptyApprId.containsKey(tw.TWS_Deal__c)){
                    mapOpptyIdToOpptyApprId.get(tw.TWS_Deal__c).add(tw);
                } else {
                    list<TWS_Approver__c> ltsa = new list<TWS_Approver__c>();
                    ltsa.add(tw);
                    mapOpptyIdToOpptyApprId.put(tw.TWS_Deal__c,ltsa);
                }
            }
        }
        list<TWS_Approver__c> lstTatoDelete = new list<TWS_Approver__c>();
        list<TWS_Approver__c> lstTatoInsert = new list<TWS_Approver__c>();
        
        //list<Approver_Configuration__c> lstac = [SELECT Approver__c,Process__c FROM Approver_Configuration__c WHERE Make__c='DTR' ];
        for (Opportunity objoppynew : (List<Opportunity>) Trigger.new) {
            for(Opportunity objoppyold : (List<Opportunity>) Trigger.old) {  
                if (objoppyold.Related_TC_Deal__c == null && rtMap.containsKey(objoppyold.recordTypeId)) {
                    Opportunity oldOpp = (Opportunity)trigger.oldMap.get(objoppynew.Id) ;
                    Opportunity NewOpp = (Opportunity)trigger.NewMap.get(objoppynew.Id) ; 
                    if((oldOpp.DTR_Requested_to_Quote_Residual__c != NewOpp.DTR_Requested_to_Quote_Residual__c) || (oldOpp.DTR_Requested_to_Quote_Trades__c != NewOpp.DTR_Requested_to_Quote_Trades__c)) {
                        if((objoppynew.DTR_Requested_to_Quote_Residual__c == false ) && (objoppynew.DTR_Requested_to_Quote_Trades__c == false)){
                            for(TWS_Approver__c TW : mapOpptyIdToOpptyApprId.get(objoppynew.id)) {
                                for(Approver_Configuration__c aca : lstac){
                                    
                                    if((TW.TWS_Approver__c == aca.Approver__c)&& aca.Process__c ==RT_Approval_Process_Map__c.getInstance(mapoptyidToRecordType.get(objoppynew.id)).Picklist_Value__c){
                                        lstTatoDelete.add(TW);
                                    }
                                }
                            }
                        } 
                    }
                    if((objoppyold.DTR_Requested_to_Quote_Residual__c == false ) && (objoppyold.DTR_Requested_to_Quote_Trades__c == false)) {
                        if((oldOpp.DTR_Requested_to_Quote_Residual__c != NewOpp.DTR_Requested_to_Quote_Residual__c) || (oldOpp.DTR_Requested_to_Quote_Trades__c != NewOpp.DTR_Requested_to_Quote_Trades__c)) {
                            for(Approver_Configuration__c aca : lstac){
                                if(aca.Process__c ==RT_Approval_Process_Map__c.getInstance(mapoptyidToRecordType.get(objoppynew.id)).Picklist_Value__c)
                                    lstTatoInsert.add(new TWS_Approver__c(TWS_Deal__c = objoppynew.id, TWS_Approver__c = aca.Approver__c, Actual_Approver__c = aca.Approver__c));
                            }
                        }
                    }
                }
            }
        }
        if(!lstTatoDelete.isEmpty()){
            delete lstTatoDelete;
        }
        if(!lstTatoInsert.isempty()){
            insert lstTatoInsert;
        }
        
    }
    
    
    
    // HN added code End for 80128 
    
    /* private methods */
    private void populateApprovers(Opportunity o, List<SObject> sc_approvers, String fieldName) {
        
        Integer size = sc_approvers.size();
        system.debug('sc_approvers +++++++++'+sc_approvers);
        if (size > 0) {
            
            for (Integer i = 0; i < MAX_APPROVERS; i++) {
                //TWS_Approver__c
                o.put('Approver_' + (i + 1) + '__c', sc_approvers[math.mod(i, size)].get(fieldName));
            }
        }
    }
    
    
    private void processOpportunities() {
        
        List<Opportunity> opps_to_update = new List<Opportunity>();
        Map<Id, Opportunity> oldOpps = (Map<Id, Opportunity>) Trigger.oldMap;
        for (Opportunity o : (List<Opportunity>) Trigger.new) {
            
            if (o.StageName == STAGE_PA || o.TC_Decision__c == 'Approved') {
                opps_to_update.add(o);
                
            }
        }
        
        
        List<SObject> approvers;
        
        
        for (Opportunity o : opps_to_update) {
            
            if (o.StageName == STAGE_PA) 
            {
                approvers = [select (select TWS_Approver__c from TWS_Approvers__r) from opportunity where id = :o.id].TWS_Approvers__r;
                //contract_approvers = [select (select TWS_Approver__c from TWS_Approvers__r) from opportunity where id=:o.id].TWS_Approvers__r;
                populateApprovers(o, approvers, 'TWS_Approver__c');
                
            }/* else if (o.TC_Decision__c == 'Approved') {

approvers = [select (select Contract_Approver__c from Sales_Contract_Approvers__r) from opportunity where id = :o.id].Sales_Contract_Approvers__r;
populateApprovers(o, approvers,'Contract_Approver__c');
}*/
        }
    }
    
    @TestVisible private void UpdateRGMNAD() {       
        
        List<Notification_Recipient__c> lstNotificationRecipients = new List<Notification_Recipient__c>(); 
        List<OpportunityShare> lstOpportunityShare = new List<OpportunityShare>();      
        List<Opportunity> lstOpportunitynew= Trigger.new;   
        List<Opportunity> lstOpportunity =[select id,name,NAEU__c,NAD_U__c,RGM_U__c,DistrictManager__c from opportunity WHERE id IN :lstOpportunitynew AND (
            NAD_U__c !=null OR NAEU__c !=null OR DistrictManager__c!= null OR RGM_U__c!=null ) ];
        
        for(Opportunity  objOpportunity : lstOpportunity){      
            
            if(objOpportunity.NAD_U__c!=null ){     
                Notification_Recipient__c objNotificationRecipient = new Notification_Recipient__c();               
                objNotificationRecipient.TWS_Deal__c= objOpportunity.id;        
                objNotificationRecipient.Notification_Recipient__c=objOpportunity.NAD_U__c;     
                lstNotificationRecipients.add(objNotificationRecipient); 
               /* OpportunityShare objOppyshare =new OpportunityShare();
                objOppyshare.OpportunityId=objOpportunity.id;
                objOppyshare.UserOrGroupId=objOpportunity.NAD_U__c;
                objOppyshare.OpportunityAccessLevel = 'Read';
                objOppyshare.RowCause = Schema.OpportunityShare.RowCause.Manual;
                lstOpportunityShare.add(objOppyshare); */
                
                
            }       
            if( objOpportunity.NAEU__c!=null){      
                Notification_Recipient__c objNotificationRecipient = new Notification_Recipient__c();               
                objNotificationRecipient.TWS_Deal__c= objOpportunity.id;        
                objNotificationRecipient.Notification_Recipient__c=objOpportunity.NAEU__c;      
                lstNotificationRecipients.add(objNotificationRecipient);
               /* OpportunityShare objOppyshare =new OpportunityShare();
                objOppyshare.OpportunityId=objOpportunity.id;
                objOppyshare.UserOrGroupId=objOpportunity.NAEU__c;
                objOppyshare.OpportunityAccessLevel = 'Read';
                
                objOppyshare.RowCause = Schema.OpportunityShare.RowCause.Manual;
                
                lstOpportunityShare.add(objOppyshare); */
                
                
            }       
            if( objOpportunity.DistrictManager__c!=null){
                Notification_Recipient__c objNotificationRecipient = new Notification_Recipient__c();           
                objNotificationRecipient.TWS_Deal__c= objOpportunity.id;        
                objNotificationRecipient.Notification_Recipient__c=objOpportunity.DistrictManager__c;       
                lstNotificationRecipients.add(objNotificationRecipient);   
                /*OpportunityShare objOppyshare =new OpportunityShare();
                objOppyshare.OpportunityId=objOpportunity.id;
                objOppyshare.UserOrGroupId=objOpportunity.DistrictManager__c;
                objOppyshare.OpportunityAccessLevel = 'Read';
                
                objOppyshare.RowCause = Schema.OpportunityShare.RowCause.Manual;
                
                lstOpportunityShare.add(objOppyshare); */
            }       
            if( objOpportunity.RGM_U__c!=null){     
                Notification_Recipient__c objNotificationRecipient = new Notification_Recipient__c();       
                objNotificationRecipient.TWS_Deal__c= objOpportunity.id;        
                objNotificationRecipient.Notification_Recipient__c=objOpportunity.RGM_U__c;     
                lstNotificationRecipients.add(objNotificationRecipient);   
               /* OpportunityShare objOppyshare =new OpportunityShare();
                objOppyshare.OpportunityId=objOpportunity.id;
                objOppyshare.UserOrGroupId=objOpportunity.RGM_U__c;
                
                objOppyshare.OpportunityAccessLevel = 'Read';
                objOppyshare.RowCause = Schema.OpportunityShare.RowCause.Manual;
                lstOpportunityShare.add(objOppyshare); */
                
            }       
            
            
        }       
        if(!lstNotificationRecipients.isEmpty()){       
            insert lstNotificationRecipients;  
           /* insert lstOpportunityShare; */
            
        }       
    }       
    @TestVisible private void UpdateRGMNADNotificationRecipient() {
        set<Id> setOpptyId = new set<Id>();
        List<Opportunity> LstNewOpportunitys=(List<Opportunity>) trigger.new;
        for(Opportunity OPty : LstNewOpportunitys){
            Opportunity oldOpp = (Opportunity)trigger.oldMap.get(OPty.Id) ;
            Opportunity NewOpp = (Opportunity)trigger.NewMap.get(OPty.Id) ;            
            if((oldOpp.NAD_U__c != NewOpp.NAD_U__c) || (oldOpp.NAEU__c != NewOpp.NAEU__c) || (oldOpp.DistrictManager__c != NewOpp.DistrictManager__c) || (oldOpp.RGM_U__c != NewOpp.RGM_U__c)) {
                setOpptyId.add(Opty.id);
                
            }
        }
        List<Notification_Recipient__c> lstNotificationRecipients = [select id,TWS_Deal__c,Notification_Recipient__c from Notification_Recipient__c where TWS_Deal__c IN : setOpptyId];
        map<id,List<Notification_Recipient__c>> mapNRtoLstNR = new map<id,List<Notification_Recipient__c>>();
        
        List<Notification_Recipient__c> lstNotificationRecipientsToUpdate = new List<Notification_Recipient__c>();
        List<OpportunityShare> listsharesToupdate = new List<OpportunityShare>();
        List<Notification_Recipient__c> lstNRtoupdate = new List<Notification_Recipient__c>();
        
        Set<Id> idstodel = new Set<ID>();
        
        
        for(id oid : setOpptyId){
            Opportunity oldOpp = (Opportunity)trigger.oldMap.get(oid) ;
            Opportunity NewOpp = (Opportunity)trigger.NewMap.get(oid) ;
            // List<OpportunityShare> sharesToDelete = [SELECT Id  FROM OpportunityShare WHERE Opportunityid IN :setOpptyId AND RowCause = 'Manual' and UserOrGroupId IN:idstodel ];
            if(oldOpp.NAD_U__c != NewOpp.NAD_U__c) {
                Notification_Recipient__c NRs = new Notification_Recipient__c();
                NRs.TWS_Deal__c=oid;
                NRs.Notification_Recipient__c = NewOpp.NAD_U__c;
                if(NewOpp.NAD_U__c!=null){
                    lstNotificationRecipientsToUpdate.add(NRs);
                }
                
                if(oldOpp.NAD_U__c !=null){
                    idstodel.add(oldOpp.NAD_U__c);
                }
                
                
               /* if(NewOpp.NAD_U__c!=null){
                    
                    OpportunityShare objOppyshare =new OpportunityShare();
                    objOppyshare.OpportunityId=oid;
                    objOppyshare.UserOrGroupId=NewOpp.NAD_U__c;
                    
                    objOppyshare.OpportunityAccessLevel = 'Read';
                    objOppyshare.RowCause = Schema.OpportunityShare.RowCause.Manual;
                    listsharesToupdate.add(objOppyshare);
                } */
            }
            
            if(oldOpp.NAEU__c != NewOpp.NAEU__c) {
                Notification_Recipient__c NRs = new Notification_Recipient__c();
                NRs.TWS_Deal__c=oid;
                NRs.Notification_Recipient__c = NewOpp.NAEU__c;
                if(NewOpp.NAEU__c!=null){
                    
                    lstNotificationRecipientsToUpdate.add(NRs);
                }
                
                if(oldOpp.NAEU__c !=null){
                    idstodel.add(oldOpp.NAEU__c);
                }              
                
                
                
               /* if(NewOpp.NAEU__c!=null){
                    
                    OpportunityShare objOppyshare =new OpportunityShare();
                    objOppyshare.OpportunityId=oid;
                    objOppyshare.UserOrGroupId=NewOpp.NAEU__c;
                    
                    objOppyshare.OpportunityAccessLevel = 'Read';
                    objOppyshare.RowCause = Schema.OpportunityShare.RowCause.Manual;
                    listsharesToupdate.add(objOppyshare);
                } */
            }
            
            if(oldOpp.DistrictManager__c != NewOpp.DistrictManager__c) {
                
                Notification_Recipient__c NRs = new Notification_Recipient__c();
                NRs.TWS_Deal__c=oid;
                
                NRs.Notification_Recipient__c = NewOpp.DistrictManager__c;
                if(NewOpp.DistrictManager__c!=null){
                    
                    lstNotificationRecipientsToUpdate.add(NRs);
                }
                
                if(oldOpp.DistrictManager__c !=null){
                    idstodel.add(oldOpp.DistrictManager__c);
                } 
                
                
                
             /*   if(NewOpp.DistrictManager__c!=null){
                    
                    OpportunityShare objOppyshare =new OpportunityShare();
                    objOppyshare.OpportunityId=oid;
                    objOppyshare.UserOrGroupId=NewOpp.DistrictManager__c;
                    
                    objOppyshare.OpportunityAccessLevel = 'Read';
                    objOppyshare.RowCause = Schema.OpportunityShare.RowCause.Manual;
                    listsharesToupdate.add(objOppyshare);
                } */
            }
            
            if(oldOpp.RGM_U__c != NewOpp.RGM_U__c) {
                Notification_Recipient__c NRs = new Notification_Recipient__c();
                NRs.TWS_Deal__c=oid;
                NRs.Notification_Recipient__c = NewOpp.RGM_U__c;
                if(NewOpp.RGM_U__c!=null){
                    
                    lstNotificationRecipientsToUpdate.add(NRs);
                }
                
                if(oldOpp.RGM_U__c !=null){
                    idstodel.add(oldOpp.RGM_U__c);
                } 
                
               /* if(NewOpp.RGM_U__c!=null){
                    OpportunityShare objOppyshare =new OpportunityShare();
                    objOppyshare.OpportunityId=oid;
                    objOppyshare.UserOrGroupId=NewOpp.RGM_U__c;
                    
                    objOppyshare.OpportunityAccessLevel = 'Read';
                    objOppyshare.RowCause = Schema.OpportunityShare.RowCause.Manual;
                    listsharesToupdate.add(objOppyshare);
                }  */
                
            }
            /*List<OpportunityShare> sharesToDelete = [SELECT Id  FROM OpportunityShare WHERE RowCause = 'Manual' and UserOrGroupId IN:idstodel ];
            
            if(!sharesToDelete.isEmpty()){
                
                delete sharesToDelete;
            } */
            List<Notification_Recipient__c> lstNotificationRecipientToDelete = [SELECT Id  FROM Notification_Recipient__c WHERE  Notification_Recipient__c  IN:idstodel ];
            if(!lstNotificationRecipientToDelete.isEmpty()){
                delete lstNotificationRecipientToDelete;    
            }
        }
        if(!lstNotificationRecipientsToUpdate.isEmpty()){
            upsert lstNotificationRecipientsToUpdate;
           // upsert listsharesToupdate;
            
        }
    }
     private void Lockrecordafterpublish() {
        for (Opportunity objoppynew : (List<Opportunity>) Trigger.new) {
            for(Opportunity objoppyold : (List<Opportunity>) Trigger.old) {
                    Opportunity oldOpp = (Opportunity)trigger.oldMap.get(objoppynew.Id) ;
                    Opportunity NewOpp = (Opportunity)trigger.NewMap.get(objoppynew.Id) ; 
                    if((oldOpp.StageName != NewOpp.StageName && NewOpp.StageName=='Published') ) {
                       Approval.lock(trigger.new,false);
                    }
                        
            }
        }
    }
     private void preventdeletingrecords() {
         if ( trigger.isDelete ) {

            for(Opportunity objoppyold : (List<Opportunity>) Trigger.old) {
                           
                if(MapCRMOppyRecordtypidName.containsKey(objoppyold.recordTypeId) && UserInfo.getUserName() ==Label.KenUserid){
                      
                      objoppyold.adderror('insufficient privileges');
                }
                
            }
        }
   
      if ( trigger.isUpdate ){
            for(Opportunity objoppy : (List<Opportunity>) Trigger.new) {
                 if(MapCRMOppyRecordtypidName.containsKey(objoppy.recordTypeId) && UserInfo.getUserName() ==Label.KenUserid){
                      
                      objoppy.adderror('insufficient privileges');
                }

          
      }
      }
}
}