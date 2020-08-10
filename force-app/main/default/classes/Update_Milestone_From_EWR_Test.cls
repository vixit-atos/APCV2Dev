@isTest public class Update_Milestone_From_EWR_Test {
    
    @testSetup static void testSetup(){
        Case c = new Case();
        insert c;
        
        Opportunity oppObj = new Opportunity(Name='Test1', StageName='New', CloseDate=Date.Today());
        insert oppObj;
        
        Engineering_Work_Request__c ewr = new Engineering_Work_request__c();
        ewr.Job_No__c = '546372';
        ewr.JOB_CHGOVR_DATE__c=Date.Today()+1;
        ewr.TRGT_IMPL_DATE__c=Date.Today();
        ewr.JOB_ORIG_COVR_DATE__c=Date.Today();
        ewr.JOB_SCH_DSGN_DATE__c=Date.Today();
        ewr.PRELM_PKT_ISS_DATE__c=Date.Today()-1;
        ewr.JOB_ORIG_DSGN_DATE__c=Date.Today();
        ewr.FNL_PKT_RLSE_DATE__c=Date.Today();
        ewr.JOB_SCH_PKT_DATE__c=Date.Today();
        ewr.JOB_ORIG_PKT_DATE__c=Date.Today();
        ewr.JOB_ORIG_STA_DATE__c=Date.Today();
        ewr.JOB_RQST_DATE__c=Date.Today()+1;
        ewr.JOB_PSC_APPR_DATE__c=Date.Today();
        ewr.Opportunity__c= oppObj.Id;
        insert ewr;
        insert new Opportunity(Name='Test12', StageName='New', CloseDate=Date.Today());
        
        ewr = new Engineering_Work_request__c();
        ewr.Job_No__c = '337212';
        ewr.Opportunity__c= oppObj.Id;
        insert ewr;
        
        EWR_Work_Order__c ewrWO = new EWR_Work_Order__c();
        ewrWO.PREPROD_VEH_NO__c = '123454';
        insert ewrWO;
        
        Engineering_Work_Request_Detail__c detail = new Engineering_Work_request_detail__c();
        detail.Engineering_Work_Request__c = ewr.Id;
        detail.EWR_Work_Order__c = ewrWO.Id;
        detail.recordTypeId = Schema.SObjectType.Engineering_Work_Request_Detail__c.getRecordTypeInfosByName().get('Serial').getRecordTypeId();
        insert detail;
    }
    @isTest
    static void updateMilestonesTest(){
        test.startTest();
         
            List<Engineering_Work_Request__c> lst_Ewrs = [SELECT Opportunity__c,
                 JOB_CHGOVR_DATE__c,TRGT_IMPL_DATE__c,JOB_ORIG_COVR_DATE__c,
                 JOB_SCH_DSGN_DATE__c,PRELM_PKT_ISS_DATE__c,JOB_ORIG_DSGN_DATE__c,
                 FNL_PKT_RLSE_DATE__c,JOB_SCH_PKT_DATE__c,JOB_ORIG_PKT_DATE__c,
                 JOB_ORIG_STA_DATE__c,JOB_RQST_DATE__c,JOB_PSC_APPR_DATE__c
                 FROM Engineering_Work_Request__c where Job_No__c='337212'];
        Update_Milestone_From_EWR.updateMilestones(lst_Ewrs);
        test.stopTest();
    }
    }