public class PCSController {
    public Integer accountContactCount{get;set;}
    public Integer accountConcessionCount{get;set;}
    public Integer bareOpportunityCount{get;set;}
    public Integer fullOpportunityCount{get;set;}
    public String currentProgress{get;set;}//Displays current progress
    public ID latestJobID{get;set;}//Latest run job for displaying to user
    public AsyncApexJob jobInfo{get;set;}//Latest job object used for testing
    
    public void generate(){
        Map<String, Integer> methodCalls = new Map<String, Integer>();
        system.debug('@@@' + accountContactCount);
        methodCalls.put('AccountContact', accountContactCount);
        methodCalls.put('AccountConcession', accountConcessionCount);
        methodCalls.put('bareOpportunity', bareOpportunityCount);
        methodCalls.put('fullOpportunity', fullOpportunityCount);
        latestJobID = System.enqueueJob(new PCSDataGenerator(methodCalls));
        jobInformation();
    }
    public void jobInformation(){
        List<AsyncApexJob> Lst_apxjb = new List<AsyncApexJob>();
        if(latestJobID != null)
            Lst_apxjb = [SELECT Status,NumberOfErrors, TotalJobItems FROM AsyncApexJob WHERE Id=:latestJobID];
        if(Lst_apxjb.size() > 0)
            jobInfo = Lst_apxjb[0];
            
        if(jobInfo != null){
            if(jobInfo.Status == 'Completed'){
                currentProgress = 'Job Completed. Number of Errors: ' + jobInfo.NumberOfErrors + '. For items that errored, check the Logs in the Folder';
            }else{
                currentProgress = 'Job: ' + jobInfo.ID + ' has started. Status: ' + jobInfo.Status + ' Number of Errors: ' + jobInfo.NumberOfErrors;
            }
        }
    }
    public PageReference getProgress(){
        if(latestJobID!= null){
            jobInformation();
        }
        return null;
    }
}