@isTest
public class NotificationRecipienttriggerHandler_Test {
     static testMethod void testmethod1() {
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
     Notification_Recipient__c objNotification_Recipient =new Notification_Recipient__c();
     objNotification_Recipient.Email_Sent__c=true;
     objNotification_Recipient.Notification_Recipient__c=NAEuser.id;
     objNotification_Recipient.TWS_Deal__c=o2.id;
     insert objNotification_Recipient;
     objNotification_Recipient.Notification_Recipient__c=DMuser.id;
     update objNotification_Recipient;
     delete objNotification_Recipient;
     }

}