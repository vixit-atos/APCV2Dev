/**
* @File Name          : APC_RestrictCaseAgent.apxc
* @Description        : Helper Class for APC_RestrictCaseAgent trigger
* @Author             : Dhruvil Shukla
* @Group              : 
* @Last Modified By   : 
* @Last Modified On   : 
* @Modification Log   : 
*==============================================================================
* Ver         Date                     Author                    Modification
*==============================================================================
* 1.0    1/30/2020,      Dhruvil Shukla           Initial Version
**/
public class APC_RestrictCaseAgent {
    
Public static void restrictcase(List<case> caseList){
         Set<Id> queueUserIds = new Set<Id>();
    Set<Id> queueIds = new Set<Id>();
    for(case cc:caseList){
        if((cc.OwnerId+'').left(3) == '00G') {
            queueIds.add(cc.OwnerId);
        }
    }
    
   
    for(GroupMember queueuser : [SELECT Id,UserOrGroupId  FROM GroupMember WHERE 
                                 GroupId =: queueIds]) 
    {
        queueUserIds.add(queueuser.UserOrGroupId);
    }
  
    for(case cc:caseList){
        if(!queueUserIds.contains(cc.Agent_Assigned__c)) {
            cc.addError('This Agent not Belongs to this Queue');
        }
    }
    
    } 
}