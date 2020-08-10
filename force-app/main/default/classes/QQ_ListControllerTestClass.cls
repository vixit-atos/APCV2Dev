@isTest
private class QQ_ListControllerTestClass {
    @isTest static void TestQQ_ListControllerTest() {  
        List < ASP_QQ__c> Quotetstdata = new List <ASP_QQ__c>();
        
        Test.startTest();
        for (Integer k=0;k<5;k++) {
            Quotetstdata .add(new ASP_QQ__c(Stage__c='Pending',Status__c='Pending for Validation' , Domain__c='Extended Warranty', Source__c='Internal'));
        }             
        insert Quotetstdata ;
    	
        List <QQ_ListController.wrapperQQ> Quotelist =  QQ_ListController.getQuoteRecords('Pending' , 'Pending for Validation', 'Extended Warranty' , 'Internal');
                  
        Test.stopTest();
        
        System.assertEquals(Quotelist.size() , Quotetstdata.size());
        
    }
    
    @isTest static void TestQQ_ListControllerArchieve() {  
        List < ASP_QQ__c> Quotetstdata = new List <ASP_QQ__c>();
        
        Test.startTest();
        for (Integer k=0;k<5;k++) {
            Quotetstdata .add(new ASP_QQ__c(Stage__c='Draft',Status__c='Draft' , Domain__c='Extended Warranty', Source__c='External'));
        }             
        insert Quotetstdata ;
        List<Id> QQIdlist = new List<Id>(new Map<Id, ASP_QQ__c >(Quotetstdata).keySet());
    	
        QQ_ListController.archiveRecords(QQIdlist);
        List <ASP_QQ__c> archievedQQlist = [Select Id from ASP_QQ__C where Archived__c = true];
        Test.stopTest();
        
        System.assertEquals(archievedQQlist.size() , Quotetstdata.size());
        
    }

}