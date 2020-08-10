@isTest
public class TWSSalesConApproverTriggerHandler_Test {
    static testMethod void craeteapprover() {
        // Implement test code
        Account a = new Account (Name = 'a1');
        insert a;
        Account a2 = new Account (Name = 'a2');
        insert a2;
        //create opportunity
        User u;
        User NAEuser =[select id,name from  User where  SalesUserRole__c='NAE' Limit 1];
        User NADuser =[select id,name from user where  SalesUserRole__c='NAD' Limit 1];
        
        User RGMuser =[select id,name from user where  SalesUserRole__c='RGM' Limit 1];
        User DMuser =[select id,name from user where  SalesUserRole__c='DM' Limit 1];
        
        Id domesticRecordTypeId = TWSConstants.getOpportunityRecordTypeMap().get('TWS_TC_Deal');
        Id domesticRecordTypeId2 = TWSConstants.getOpportunityRecordTypeMap().get('TWS_TC_Deal');
        Opportunity o = new Opportunity(Name = 'o1',DTR_Requested_to_Quote_Residual__c = true, VEH_MAKE__c = 'FTL', Account = a, StageName = 'Initial Notification', CloseDate = Date.Today(), RecordTypeId = domesticRecordTypeId,NAD_U__c=NADuser.id,NAEU__c=NAEuser.id,RGM_U__c=RGMuser.id,DistrictManager__c=DMuser.id);
        insert o;
        Opportunity o2 = new Opportunity(Name = 'o1sss',DTR_Requested_to_Quote_Residual__c = true, VEH_MAKE__c = 'FTL', Account = a2, StageName = 'Initial Notification', CloseDate = Date.Today(), RecordTypeId = domesticRecordTypeId2,NAD_U__c=NADuser.id,NAEU__c=NAEuser.id,RGM_U__c=RGMuser.id,DistrictManager__c=DMuser.id);
        insert o2;
        List<Opportunity> lstoppy=new List<Opportunity>();
        lstoppy.add(o);
        lstoppy.add(o2);
        update lstoppy;
        Sales_Contract__c  objsc= new Sales_Contract__c();
        objsc.Approval_Status__c='Ready for Approval';
        objsc.Opportunity__c=o2.id;
        insert objsc;
        Sales_Contract_Approver__c objSales_Contract_Approver =new Sales_Contract_Approver__c();
        objSales_Contract_Approver.Contract_Approver__c=NAEuser.id;
        objSales_Contract_Approver.Sales_Contract__c=objsc.id;
        insert objSales_Contract_Approver;
        objSales_Contract_Approver.Position__c=3;
        objSales_Contract_Approver.Contract_Approver__c=NADuser.id;
        List<OpportunityShare> lstoppyshare=[select id,OpportunityAccessLevel,RowCause  from  OpportunityShare where OpportunityId =: objsc.Opportunity__c and UserOrGroupId  =:NADuser.id];
        delete lstoppyshare;
        update objSales_Contract_Approver;
        delete objSales_Contract_Approver;
    }
}