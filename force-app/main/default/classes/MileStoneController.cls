public class MileStoneController {
    @AuraEnabled
    public static Result getData(Id OppId) {
        Result r = new Result();        
        list<Opportunity>oppList=[select id,CFR_Approval_Date__c from Opportunity where id=:OppId];
        if(oppList.size()>0){
        	r.CFRApproval=oppList[0].CFR_Approval_Date__c;    
        }
        list<Milestone__c>designReleaseList=[select id,Completed__c from Milestone__c where Opportunity__c=:OppId AND Name='Design Release' ORDER BY CreatedDate Limit 1];
        if(designReleaseList.size()>0){
            r.DesignRelease=designReleaseList[0].Completed__c;
        }
        list<Milestone__c>finalPacketList=[select id,Completed__c from Milestone__c where Opportunity__c=:OppId AND Name='Final Packet' ORDER BY CreatedDate Limit 1];
        if(finalPacketList.size()>0){
            r.FinalPacket=finalPacketList[0].Completed__c;
        }
        list<Milestone__c>sopList=[select id,Deadline__c from Milestone__c where Opportunity__c=:OppId AND Name='Changeover' ORDER BY CreatedDate Limit 1];
        if(sopList.size()>0){
            r.SOP=sopList[0].Deadline__c;
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