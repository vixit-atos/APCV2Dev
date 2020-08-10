global class ProcessApprovalRequest 
{
    @InvocableMethod
    public static void invokeApproveProcessApprovalRequest(List<Id> lstConcId)
    {
        Approval.ProcessWorkitemRequest[] prWkItems = New Approval.ProcessWorkItemRequest[]{};
        ProcessInstance[] pi = [Select ID, Status, TargetObject.Name,
            (SELECT Id, ActorId, ProcessInstanceId FROM Workitems),
            (SELECT Id, StepStatus, Comments FROM Steps) From ProcessInstance
            Where TargetObjectID in :lstConcId AND Status = 'Pending'];
        
        for(ProcessInstance instance : pi)
        {
            String comment = 'Approved automatically';
            if ( String.valueOf(instance.TargetObjectID).substring(0,3) == 'a0D'){ //Concession Record
                comment = 'Approved automatically based on Concession status change.';
            }
            else if( String.valueOf(instance.TargetObjectID).substring(0,3) == 'a1U' ){ //Campaign Initiator
                comment = 'Approved automatically based on approval request has not been responded over 3 days.';
            }
                
            for(ProcessInstanceWorkItem workItem : instance.WorkItems)
            {
                Approval.ProcessWorkitemRequest prWkItem = new Approval.ProcessWorkitemRequest();
                prWkItem.setWorkItemID(workItem.id);
                prWkItem.setComments(comment);
                prWkItem.setAction('Approve');
                prWkItems.add(prWkItem);
                break;
            }
        }

        if(!prWkItems.isEmpty())
        {
            Approval.ProcessResult[] appResult = Approval.process(prWkItems);
        }
    }
}