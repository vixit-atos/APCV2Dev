public class MilestonePathController {
    @AuraEnabled
    public static List<Milestone__c> fetchMilestones(Id OppId) {
        return [SELECT Name,Kickoff_Date__c,Deadline__c,Actual_Date__c
                FROM Milestone__c WHERE Opportunity__c = :OppId ORDER BY CreatedDate];
    }
    
    @AuraEnabled
    public static Result getDashboardData(Id OppId) {
        List<Engineering_Work_Request__c> EWRList = [SELECT Id,Design_Release_Complete__c,Final_Packet_Complete__c,TRGT_IMPL_DATE__c
                                                    FROM Engineering_Work_Request__c
                                                    WHERE Opportunity__c=:OppId LIMIT 1];
        Result r = new Result();
        if(EWRList.size()>0){
            r.DesignRelease = EWRList[0].Design_Release_Complete__c;
            r.FinalPacket = EWRList[0].Final_Packet_Complete__c;
            r.SOP = EWRList[0].TRGT_IMPL_DATE__c;
        }
        
        List<Milestone__c> milestoneList = [SELECT Name,Kickoff_Date__c,Deadline__c,Actual_Date__c
                							FROM Milestone__c 
                                            WHERE Opportunity__c = :OppId AND Name='Pact Approval' ORDER BY CreatedDate LIMIT 1];
        if(milestoneList.size()>0){
            r.CFRApproval = milestoneList[0].Actual_Date__c;
        }
        return r;
    }

    public class Result{
        @AuraEnabled
        public Date CFRApproval;
        @AuraEnabled
        public Boolean DesignRelease;
        @AuraEnabled
        public Boolean FinalPacket;
        @AuraEnabled
        public Date SOP;
    }
}