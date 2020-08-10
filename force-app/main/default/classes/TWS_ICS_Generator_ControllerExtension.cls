public with sharing class TWS_ICS_Generator_ControllerExtension {
    
    
    public User[] invitees {get;private set;}
    public DateTime startTime {get;private set;}
    public DateTime endTime {get;private set;}
    public ApexPages.StandardController TCM_sc = null;
    private final sObject mysObject;
    private TCMeeting__c tcm;
    
    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public TWS_ICS_Generator_ControllerExtension(ApexPages.StandardController stdController) {
        this.mysObject = (sObject)stdController.getRecord();
        
        tcm = [select TC_Meeting_Date__c from TCMeeting__c where id = :mysObject.id];
        
        TCM_sc = stdController;
        
        List<Deal_Meeting_Association__c>  dml = [select (Select TWS_TC_Deal__c from Deal_Meeting_Associations__r) from TCMeeting__c where id = :mysObject.id].Deal_Meeting_Associations__r;
        
        
        
        set<id> ids = new set<id>();
        
        for (Deal_Meeting_Association__c dma : dml) {
            System.debug(LoggingLevel.DEBUG, 'Adding' + dma.TWS_TC_Deal__c);
            
            ids.add(dma.TWS_TC_Deal__c);
        }
        
        
        //   List<TWS_Approver__c> ol = [select (select TWS_Approver__c from TWS_Approvers__r) from Opportunity where id in :ids].TWS_Approvers__r;
        
        List<TWS_Approver__c> ol = [ select TWS_Approver__c from TWS_Approver__c where TWS_Deal__c in: ids];
        List<Opportunity> lstopportunities = [ select NAD_U__c,NAEU__c,DistrictManager__c,RGM_U__c	 from Opportunity  where id in: ids];
        
        String strDOAgroupname=Label.DOA_team_members;
        Group objDOAgroupid=[select id from group where Developername=:strDOAgroupname];
        List<GroupMember> lstGroupMembers = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId =: objDOAgroupid.id];
        
        List<String> strList = new List<String>();
        ids.clear();
        if(!lstGroupMembers.isEmpty()){
            for(GroupMember objGroupMember : lstGroupMembers){
                ids.add(objGroupMember.UserOrGroupId);
            }   
        }
        for (TWS_Approver__c ta : ol) ids.add(ta.TWS_Approver__c);
        if(!lstopportunities.isEmpty()){
            for (Opportunity objopportunity : lstopportunities) {
                ids.add(objopportunity.NAD_U__c);
                ids.add(objopportunity.NAEU__c);
                ids.add(objopportunity.DistrictManager__c);
                ids.add(objopportunity.RGM_U__c);
            }
        }
        system.debug('1111111111111'+ids);
        this.invitees =  [select name, email from user where id in :ids];
        system.debug('22222222222222'+this.invitees);
     
        
        startTime = Datetime.newInstance( tcm.TC_Meeting_Date__c, Time.newInstance(11,30, 0, 0));
        endTime = Datetime.newInstance( startTime.date(), Time.newInstance(13,0, 0, 0));
        
        
    }
    public PageReference doCancel()
    {
        return TCM_sc.cancel();
    }
    
}