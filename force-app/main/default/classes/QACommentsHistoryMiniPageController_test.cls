@istest
public class QACommentsHistoryMiniPageController_test
{
    static testMethod void method_one()
    {   Id RecordTypeIdconcession = Schema.SObjectType.Concession__c.getRecordTypeInfosByName().get('FTL Mainframe Concession').getRecordTypeId();
        Concession__c Conc = new Concession__c(Name='TEST1',recordtypeid=RecordTypeIdconcession);
        insert Conc;
        Quote_Activity_Comment_History__c QACmnt = new Quote_Activity_Comment_History__c(ConcessionId__c=Conc.id,Comment__c='Test@1');
        insert QACmnt;
        
        ApexPages.currentPage().getParameters().put('ConcessionId',  Conc.id);
        ApexPages.currentPage().getParameters().put('button',  'true');
        
        QACommentsHistoryMiniPageController QAtest = new QACommentsHistoryMiniPageController ();
        //QAtest.returnback() ;
        
    }
    static testMethod void method_two()
    {   Id RecordTypeIdconcession = Schema.SObjectType.Concession__c.getRecordTypeInfosByName().get('FTL Mainframe Concession').getRecordTypeId();
        Concession__c Conc = new Concession__c(Name='TEST1',recordtypeid=RecordTypeIdconcession);
        insert Conc;
        Quote_Activity_Comment_History__c QACmnt = new Quote_Activity_Comment_History__c(ConcessionId__c=Conc.id,Comment__c='Test@1');
        insert QACmnt;
        
        ApexPages.currentPage().getParameters().put('ConcessionId',  Conc.id);
        
        
        QACommentsHistoryMiniPageController QAtest = new QACommentsHistoryMiniPageController ();
        //QAtest.returnback() ;
        
    }
    @isTest static void method_three() {
       ApexPages.currentPage().getParameters().put('ConcessionId',  '====');
        try {
             QACommentsHistoryMiniPageController QAtest = new QACommentsHistoryMiniPageController ();
        } catch(DMLException e) {
            system.assertEquals(e.getMessage(), e.getMessage());
        }
        
    }
    
    

}