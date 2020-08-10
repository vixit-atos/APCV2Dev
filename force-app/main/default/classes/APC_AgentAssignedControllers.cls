public class APC_AgentAssignedControllers{
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String caseId) {
        List < sObject > returnList = new List < sObject > ();
        if(caseId != '' ){
            case g= [select ownerId from case where id=:caseId];   
            List < GroupMember > lstOfRecords = [select UserOrGroupId from GroupMember where groupid =: g.ownerId ];
            set<id> userIds=new set<Id>();
            for(GroupMember gmember:lstOfRecords){
                userIds.add(gmember.UserOrGroupId);
            }     
            list<user> u=[select name from User where id =:userIds];            
            for (sObject obj: u) {
                returnList.add(obj);
            }
        }        
        return returnList;
    }
    @AuraEnabled 
    public static string saveAgent(String caseid, String AgentId){
        string status;
        if(caseId != '' && AgentId != '' ){
            try{
                case c=[select id ,Agent_Assigned__c from case where id=:caseid];            
                c.Agent_Assigned__c=AgentId;
                Update c; 
                status='success';
            }
            catch(exception ex){            
                status=ex.getMessage();
            } 
            
        }  
        return status;
    }
}