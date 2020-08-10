public class AttachmentTriggerHandler extends TriggerHandler {

public AttachmentTriggerHandler(){
} 
    protected override void afterInsert() {
         checkAttachmentonTask () ;
}
    protected override void afterupdate() {
         checkAttachmentonTask () ;
}
     protected override void afterdelete() {
         checkAttachmentonTask () ;
}
@TestVisible private void checkAttachmentonTask () {
// Contains the IDs of all the parent tasks
    Set<Id> parentTaskIdSet = new Set<id>();

    if (trigger.new != null)
    {
        for (Attachment a:(List<Attachment>)  trigger.new)
        {
            parentTaskIdSet.add(a.parentId);
        }
    }
    
    if (trigger.old != null)
    {
        for (Attachment a:(List<Attachment>) trigger.old)
        {
            parentTaskIdSet.add(a.parentId);
        }
    }    
    
    // List of tasks that needs to be updated
    List<Task> parentTaskList = [SELECT id, (SELECT id FROM Attachments) FROM Task WHERE id in: parentTaskIdSet];
    
    for (Task t: parentTaskList)
    {
        if(t.Attachments.size()>0){
            t.Attachment__c=true;
            
        } else{
            t.Attachment__c=false;
        }
    }
    
    update parentTaskList;
}
}