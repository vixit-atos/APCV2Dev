public class EWRController {
   
    @AuraEnabled
    public static Engineering_Work_Request__c fetchMilestoneEWR(Id crtId){
        List<Engineering_Work_Request__c> ewr = [Select Id, OwnerId, IsDeleted, Name, Job_No__c, Job_Desc__c, JOB_PSC_APPR_NAME__c, JOB_PSC_APPR_DATE__c, JOB_ORIG_STA_DATE__c, JOB_RQST_DATE__c, JOB_ORIG_DSGN_DATE__c, JOB_SCH_DSGN_DATE__c, PRELM_PKT_ISS_DATE__c, JOB_ORIG_PKT_DATE__c, JOB_SCH_PKT_DATE__c, FNL_PKT_RLSE_DATE__c, TOOL_IMPCT_INDC__c, MIP_CAT_ID__c, JOB_ORIG_COVR_DATE__c, TRGT_IMPL_DATE__c, JOB_CHGOVR_DATE__c, Status_Code_C_O__c, JOB_ORIG_DSGN_HRS__c, JOB_EST_DSGN_HRS__c, MIP_STS_CD__c, MIP_RESP_DEPT_CD__c, MIP_NO__c, MIP_STS_COMT__c, ENGR_MGR_APPR_NAME__c, JOB_ENGR__c, JOB_ENGR_MGR__c, JOB_DSGN_APPR_NAME__c, C_O_Complete__c, Days_Late_C_O__c, Design_Release_Complete__c, Days_Late_DR__c, Final_Packet_Complete__c, Days_Late_FP__c, Changeover_Comments__c, Job_Cond__c, Cab_Estimate__c, Opportunity__c, Chassis_Estimate__c, Mechatronics_Estimate__c, Eve_Estimate__c, Other_Estimates__c, Tooling_Expense__c, Other_Expenses__c FROM Engineering_Work_Request__c where Opportunity__c =: crtId];
        return ewr[0];
    }
    
    @AuraEnabled
    public static List<Engineering_Work_Request__c> fetchEWRInformation(Id recordId){
        List<Engineering_Work_Request__c> ewr = [Select Id, OwnerId, IsDeleted, Name, Job_No__c, Job_Desc__c, JOB_PSC_APPR_NAME__c, JOB_PSC_APPR_DATE__c, JOB_ORIG_STA_DATE__c, JOB_RQST_DATE__c, JOB_ORIG_DSGN_DATE__c, JOB_SCH_DSGN_DATE__c, PRELM_PKT_ISS_DATE__c, JOB_ORIG_PKT_DATE__c, JOB_SCH_PKT_DATE__c, FNL_PKT_RLSE_DATE__c, TOOL_IMPCT_INDC__c, MIP_CAT_ID__c, JOB_ORIG_COVR_DATE__c, TRGT_IMPL_DATE__c, JOB_CHGOVR_DATE__c, Status_Code_C_O__c, JOB_ORIG_DSGN_HRS__c, JOB_EST_DSGN_HRS__c, MIP_STS_CD__c, MIP_RESP_DEPT_CD__c, MIP_NO__c, MIP_STS_COMT__c, ENGR_MGR_APPR_NAME__c, JOB_ENGR__c, JOB_ENGR_MGR__c, JOB_DSGN_APPR_NAME__c, C_O_Complete__c, Days_Late_C_O__c, Design_Release_Complete__c, Days_Late_DR__c, Final_Packet_Complete__c, Days_Late_FP__c, Changeover_Comments__c, Job_Cond__c, Cab_Estimate__c, Opportunity__c, Chassis_Estimate__c, Mechatronics_Estimate__c, Eve_Estimate__c, Other_Estimates__c, Tooling_Expense__c, Other_Expenses__c FROM Engineering_Work_Request__c where Opportunity__c =: recordId];
        return ewr;
    }
    
    @AuraEnabled
    public static List<Engineering_Work_Request_Detail__c> fetchEWRDetails(List<Engineering_Work_Request__c> EWRs) {
        List<Id> idList = new List<Id>();
        for(Engineering_Work_Request__c ewr : EWRs){
            idList.add(ewr.id);
        }
        List<Engineering_Work_Request_Detail__c> ewrDetailList = [SELECT ID, Name, MODULE_NO__c, PROD_TYPE_CD__c, EWR_Work_Order__c, RecordTypeId, Engineering_Work_Request__c FROM Engineering_Work_Request_Detail__c WHERE Engineering_Work_Request__C in :idList];
        return ewrDetailList;
    }
    
    @AuraEnabled
    public static List<Engineering_Work_Request_Detail__c> fetchEWRDetail(ID recordId) {
        List<Engineering_Work_Request_Detail__c> ewrDetailList = [SELECT ID, Name, MODULE_NO__c, PROD_TYPE_CD__c, EWR_Work_Order__c, RecordTypeId, Engineering_Work_Request__c FROM Engineering_Work_Request_Detail__c WHERE Engineering_Work_Request__C =: recordId];
        return ewrDetailList;
    }
    
    @AuraEnabled
    public static List<EWR_Work_Order__c> fetchWorkOrders(List<Engineering_Work_Request_Detail__c> Details) {
        List<ID> idList = new List<ID>();
        for(Engineering_Work_Request_Detail__c s : Details){
            idList.add(s.EWR_Work_Order__c);
        }
        List<EWR_Work_Order__c> workOrderList = [SELECT ID, Name, EF_BUILD_DT__c, PREPROD_VEH_COMT__c, CUST_NAME_ABBR__c, LOC__c, PREPROD_VEH_INDC__c, PWO_NO__c, TST_RND_NO__c, PREPROD_VEH_NO__c FROM EWR_Work_Order__c WHERE ID in :idList];
        return workOrderList;
    }
    
    @AuraEnabled
    public static List<Engineering_Work_Request__c> getEWRs(ID recordId, String EWRs) {
        List<String> splitString = EWRs.split(',');
        List<String> EWRString = new List<String>();
        for(String s : splitString){
            s = s.deleteWhitespace();
            EWRString.add(s);
        }
        
        List<Engineering_Work_Request__c> EWRList = [SELECT ID, Job_No__c, Opportunity__c FROM Engineering_Work_Request__c WHERE Job_No__c in :EWRString];
        return EWRList;
    }
    
    @AuraEnabled
    public static List<String> checkEWRError(List<Engineering_Work_Request__c> foundEWRs, String EWRs) {
        Boolean foundFlag = false;
        List<String> splitString = EWRs.split(',');
        List<String> EWRString = new List<String>();
        for(String s : splitString){
            s = s.deleteWhitespace();
            EWRString.add(s);
        }
        List<String> ewrNotFound = new List<String>();
        
        if(foundEWRs.size() == 0){
            ewrNotFound = EWRString;
        }else{
            for(String e : EWRString){
                for(Engineering_Work_Request__c ewr: foundEWRs){
                    if(ewr.Job_No__c == e){
                        foundFlag=true;
                    }
                    if(foundFlag==false){
                        ewrNotFound.add(e);
                    }
                    foundFlag=false;
                }
            }
        }
        return ewrNotFound;
    }
    
    @AuraEnabled
    public static String attachEWRs(ID recordId, List<Engineering_Work_Request__c> foundEWRs) {
        List<Engineering_Work_Request__c> ewrList = new List<Engineering_Work_Request__c>();
        Boolean notFound = true;
        Boolean errorFlag = false;
        for(Engineering_Work_Request__c ewr : foundEWRs){
            if(ewr.Opportunity__c == null){
                system.debug('@@@Opp' + ewr.Opportunity__c);
                ewr.Opportunity__c = recordId;
                ewrList.add(ewr);
            }else{
                return ewr.Opportunity__c;
            }
        }
        system.debug('@@@'+ ewrList);
        Savepoint sp = Database.setSavepoint();
        if(ewrList.size() >0){
            Database.SaveResult[] srList = Database.update(ewrList, false);
            for(Database.SaveResult sr : srList){
                if(sr.isSuccess()==false){
                    errorFlag = true;
                }
            }
            if(errorFlag==true){
                Database.rollback(sp);
                return 'false';
            }else{
                return 'true';
            }
        }
        return 'false';
    }
    
}