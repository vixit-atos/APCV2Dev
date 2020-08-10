@isTest(SeeAllData=true)
public class TWS_ItemsToApproveMobileControllerTest {
    public static testMethod void testApproval_item_wrapper() { 
        approval_item_wrapper testWrapper = new approval_item_wrapper('01p2F000000L6iR','1','2','3','4','01p2F000000L6iR','6','7');
        System.assertEquals('01p2F000000L6iR', testWrapper.id);
        System.assertEquals('1', testWrapper.name);
        System.assertEquals('2', testWrapper.objtype);
        System.assertEquals('3', testWrapper.DateSubmited);
        System.assertEquals('4', testWrapper.tcmeetingcomments);
        System.assertEquals('01p2F000000L6iR', testWrapper.approvalid);
        System.assertEquals('6', testWrapper.ConcessionStatus);
        System.assertEquals('7', testWrapper.submittedBy); 
    }
    
    
    
    
    public static testMethod void testTWSItemsToApproveMobileControllerOpp() {
        TWS_ItemsToApproveMobileController controller = new TWS_ItemsToApproveMobileController(null);

        //Approval in Opportunity
        try{
            List<id> userID_1 = new List<id>();
            for (processinstanceworkitem item: [SELECT actorid from processinstanceworkitem where processinstance.TargetObject.type ='Opportunity']){
                userID_1.add(item.actorid);
            }
            User approver1 = [SELECT id from USER where id IN: userID_1 AND IsActive = TRUE limit 1];  
            System.debug('Approval1: ' + approver1.id);
            System.runAs(approver1){
                /*list<ProcessInstanceWorkItem> approvalList =  [select processinstance.targetobjectid,CreatedDate ,processinstance.targetobject.name,ProcessInstance.TargetObject.type,  processinstance.SubmittedById from processinstanceworkitem where actorid = :userinfo.getuserid()];
                list<ProcessInstanceWorkItem> approvalOppList = new list<ProcessInstanceWorkItem>();
                for ( ProcessInstanceWorkItem item : approvalList){
                  //  if (item.processinstance.TargetObject.type == 'Opportunity'){
                        approvalOppList.add(item);
                   // }
                }
                //List<approval_item_wrapper> TWS_ItemsToApproveMobileController.getItemToApprove().size();*/
                System.assertEquals([select id from processinstanceworkitem where actorid = :userinfo.getuserid()].size(), TWS_ItemsToApproveMobileController.getItemToApprove().size());
            }
        }
        catch(QueryException e) {
            System.debug(e.getMessage());
        }
        
        //Approval in Concession

        
        
    }
    
    public static testMethod void testTWSItemsToApproveMobileControllerCon() {
		TWS_ItemsToApproveMobileController controller = new TWS_ItemsToApproveMobileController(null);
        try{
            List<id> userID_2 = new List<id>();
            for (processinstanceworkitem item: [SELECT actorid from processinstanceworkitem where processinstance.TargetObject.type ='Concession__c']){
                userID_2.add(item.actorid);
            }
            User approver2 = [SELECT id from USER where id IN: userID_2 AND IsActive = TRUE limit 1];
            System.runAs(approver2){
                System.assertEquals([select id from processinstanceworkitem where actorid = :userinfo.getuserid()].size(), TWS_ItemsToApproveMobileController.getItemToApprove().size());
            }
        }
        catch(QueryException e) {
            System.debug( e.getMessage() );
        }
    }
    
    public static testMethod void testTWSItemsToApproveMobileControllerOthers() {
         TWS_ItemsToApproveMobileController controller = new TWS_ItemsToApproveMobileController(null);
        //Approval in other object
        try{
            List<id> userID_3 = new List<id>();
            for (processinstanceworkitem item: [SELECT actorid from processinstanceworkitem where processinstance.TargetObject.type !='Concession__c' AND processinstance.TargetObject.type !='Opportunity']){
                userID_3.add(item.actorid);
            }
            User approver3 = [SELECT id from USER where id IN: userID_3 AND IsActive = TRUE limit 1];
            System.runAs(approver3){
                    System.assertEquals([select id from processinstanceworkitem where actorid = :userinfo.getuserid()].size(), TWS_ItemsToApproveMobileController.getItemToApprove().size());
            }
        }
        catch(QueryException e) {
            System.debug( e.getMessage() );
        }
    }
}