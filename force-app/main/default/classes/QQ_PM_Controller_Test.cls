@isTest
public class QQ_PM_Controller_Test {
    @isTest
    public static void runTest()
    {
        Test.startTest();
        ASP_QQ__c QQ = new ASP_QQ__c();
        QQ.Stage__c = 'Pending';
        QQ.Status__c = 'Pending for Validation';
        QQ.Domain__c = 'Preventive Maintenance';
        QQ.Source__c = 'External';
        QQ.Expiration_Date__c = Date.today();
        QQ.From_Date__c = Date.today();
        QQ.FMV_Date__c = Date.today();
        ASP_PM_Line_Items__c quoteitem= new ASP_PM_Line_Items__c();
       // quoteitem.ASP_QQ__c = QQ.Id;
        quoteitem.Offer_Master_Id__c = 'TestofferId';
        List <ASP_PM_Line_Items__c> quoteitemlst = new List <ASP_PM_Line_Items__c>();
        quoteitemlst.add(quoteitem);
        PM_Line_Item_AddOn__c addonitem = new PM_Line_Item_AddOn__c();
        //addonitem.PM_Line_Items__c = quoteitem.Id;
        addonitem.Offer_Master_Id__c = 'TestofferId';
        List <PM_Line_Item_AddOn__c> addonlst = new List <PM_Line_Item_AddOn__c>();
        addonlst.add(addonitem);        
        QQ_PM_Controller.submitPMquote(QQ,quoteitemlst,addonlst);
        Test.stopTest();
    }
}