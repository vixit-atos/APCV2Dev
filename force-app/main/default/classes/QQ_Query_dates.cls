public with sharing class QQ_Query_dates {
    @AuraEnabled
    public static ASP_QQ_Switch__c get_FMV_Expiration_Date(){
       ASP_QQ_Switch__c obj=[select FMV_Date__c,Expiration_Date__c from ASP_QQ_Switch__c where Active__c= True ];
       
       return obj;
        
        
    }

}