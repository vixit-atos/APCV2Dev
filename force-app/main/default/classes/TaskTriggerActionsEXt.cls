public with sharing class TaskTriggerActionsEXt {
    
private static Map<ID,Opportunity> mapOppIDName = new Map<ID,Opportunity>();
private static String tempId;// Stores the What Id
private static Map<ID,ID> initOppTaskMap = new Map<ID,ID>();
private static list<Opportunity> oppUpadteList = new list<Opportunity>();
private static list<Opportunity> oppGetList = new list<Opportunity>();
   
    public static void updateoppstage(List<Task> tasks){   

    for(Task t : tasks)
    {   
        tempId = t.whatId;

        if(tempId != null && tempId.substring(0,3) == '006' &&  t.status == 'Completed' )
        {
            initOppTaskMap.put(t.Id,t.whatId);
        }
    }
system.debug('initOppTaskMap:::'+initOppTaskMap);
    if(initOppTaskMap.size() > 0){
      oppGetList= [select Id,Name,StageName ,AccountId,RecordTypeId  from Opportunity where Id IN : initOppTaskMap.values()];
        
    }
system.debug('oppGetList:::'+oppGetList);
    for(Opportunity oppUpadteDetails : oppGetList){

        if(oppUpadteDetails.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('International Sales Proposal').getRecordTypeId()){
            oppUpadteDetails.StageName ='Ready for Submission';
            oppUpadteList.add(oppUpadteDetails);
        }
    }
    system.debug('oppUpadteList:::'+oppUpadteList);
    if(oppUpadteList.size()>0){
    update  oppUpadteList;
    }

    }
}