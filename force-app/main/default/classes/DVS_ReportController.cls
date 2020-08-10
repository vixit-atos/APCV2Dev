public with sharing class DVS_ReportController {
    public List<Id> reportIdList {get;set;}
    
    public DVS_ReportController() {
        reportIdList = new List<Id>();
        for (Report report : [SELECT Id from Report WHERE FolderName = 'DVS Report']){
            reportIdList.add(report.Id);
        }
    }
}