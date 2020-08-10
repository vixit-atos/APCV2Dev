@isTest
public class QQ_PM_PDFController_TEST
{
    @isTest
    public static void runTest()
    {
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect/Customer').getRecordTypeId();
        string AO_AddOns='';
        Account acc = new Account();
        acc.Name = 'Daimler';
        acc.RecordTypeId = RecordTypeId;
        INSERT acc;
        
        ASP_QQ__c QQ = new ASP_QQ__c();
        QQ.Stage__c = 'Pending';
        QQ.Status__c = 'Pending for Validation';
        QQ.Domain__c = 'Preventive Maintenance';
        QQ.Source__c = 'External';
        QQ.Expiration_Date__c = Date.today();
        QQ.From_Date__c = Date.today();
        QQ.Customer_Name__c = acc.ID;
        QQ.FMV_Date__c = Date.today();
        INSERT QQ;
        
        ASP_QQ__c QQName = [SELECT Id, Name FROM ASP_QQ__c WHERE Id = : QQ.Id];
        System.debug('TEST-Record Name: ' + QQName.Name);
        
        ASP_PM_Line_Items__c PM = new ASP_PM_Line_Items__c();
        PM.Air_Filter__c = '1-Stage High Capacity';
        PM.ASP_QQ__c = QQ.ID;
        PM.Databook_Code__c = 'WMP-548';
        //PM.DB_Code__c = 'WMP-548';
        PM.Duration__c = '3 yr / 100k mi / 161k km';
        PM.Duty_Cycle__c = 'Long Haul';
        PM.Engine_Model__c = 'DD15';
        PM.Manufacturer__c = '';
        PM.Offer_Master_Id__c = '';
        PM.Package__c = 'PM3';
        PM.Price__c = 0;
        PM.Program__c = 'PACKAGE';
       // PM.Offer__c = '';
        PM.Service__c = '';
        PM.Service_Interval__c = '';
        PM.Total_Price__c = 9825.00;
        PM.Transmission_Model__c = 'Allison 1000 Series';  
        INSERT PM;
        
        ASP_PM_Line_Items__c PM1 = new ASP_PM_Line_Items__c();
        PM1.Air_Filter__c = '1-Stage High Capacity';
        PM1.ASP_QQ__c = QQ.ID;
        PM1.Databook_Code__c = 'WMP-548';
        //PM1.DB_Code__c = 'WMP-548';
        PM1.Duration__c = '3 yr / 100k mi / 161k km';
        PM1.Duty_Cycle__c = 'Long Haul';
        PM1.Engine_Model__c = 'DD15';
        PM1.Manufacturer__c = 'Allison';
        PM1.Offer_Master_Id__c = '';
        PM1.Package__c = 'PM3';
        PM1.Price__c = 0;
        PM1.Program__c = 'TRANSMISSION';
       // PM1.Offer__c = '';
        PM1.Service__c = '';
        PM1.Service_Interval__c = '';
        PM1.Total_Price__c = 9825.00;
        PM1.Transmission_Model__c = 'Allison 1000 Series';  
        INSERT PM1;
        
        ASP_PM_Line_Items__c PM2 = new ASP_PM_Line_Items__c();
        PM2.Air_Filter__c = '1-Stage High Capacity';
        PM2.ASP_QQ__c = QQ.ID;
        PM2.Databook_Code__c = 'WMP-548';
        //PM2.DB_Code__c = 'WMP-548';
        PM2.Duration__c = '3 yr / 100k mi / 161k km';
        PM2.Duty_Cycle__c = 'Long Haul';
        PM2.Engine_Model__c = 'DD15';
        PM2.Manufacturer__c = '';
        PM2.Offer_Master_Id__c = '';
        PM2.Package__c = 'PM3';
        PM2.Price__c = 0;
        PM2.Program__c = 'ATS';
       // PM2.Offer__c = '';
        PM2.Service__c = '';
        PM2.Service_Interval__c = '';
        PM2.Total_Price__c = 9825.00;
        PM2.Transmission_Model__c = 'Allison 1000 Series';  
        INSERT PM2;
        
        PM_Line_Item_AddOn__c AO = new PM_Line_Item_AddOn__c();
        AO.Add_On__c = 'AIR FILTER';
        AO.Manufacturer__c = 'DONALDSON 1-STAGE HIGH CAPACITY';
        AO.Offer_Master_Id__c = '';
        AO.PM_Line_Items__c = PM.ID;
        AO.Price__c = 1600.00;
        AO.Service_Name__c = '4';
        INSERT AO;
        
        PM_Line_Item_AddOn__c AO1 = new PM_Line_Item_AddOn__c();
        AO1.Add_On__c = 'AIR FILTER';
        AO1.Manufacturer__c = 'DONALDSON 1-STAGE HIGH CAPACITY';
        AO1.Offer_Master_Id__c = '';
        AO1.PM_Line_Items__c = PM1.ID;
        AO1.Price__c = 1600.00;
        AO1.Service_Name__c = '4';
        INSERT AO1;
        
        PM_Line_Item_AddOn__c AO2 = new PM_Line_Item_AddOn__c();
        AO2.Add_On__c = 'AIR FILTER';
        AO2.Manufacturer__c = 'DONALDSON 1-STAGE HIGH CAPACITY';
        AO2.Offer_Master_Id__c = '';
        AO2.PM_Line_Items__c = PM2.ID;
        AO2.Price__c = 1600.00;
        AO2.Service_Name__c = '4';
        INSERT AO2;
                
        Id PKG_RecordTypeId = Schema.SObjectType.ASP_PM_Coverage_Master__c.getRecordTypeInfosByName().get('Package').getRecordTypeId();
        ASP_PM_Coverage_Master__c OM = new ASP_PM_Coverage_Master__c();
        OM.RecordTypeId = PKG_RecordTypeId;
        OM.Name = 'WMP-548';
        OM.Databook_Code__c = 'WMP-548';
        OM.Duration__c = '3 yr / 100k mi / 161k km';
        OM.Package__c = 'PM3';
        OM.Engine_Model__c = 'DD15';
        OM.Duty_Cycle__c = 'Long Haul';
        OM.Air_Filter_Type__c = '1-Stage High Capacity';
        INSERT OM;
        
        Id TRANS_RecordTypeId = Schema.SObjectType.ASP_PM_Coverage_Master__c.getRecordTypeInfosByName().get('Transmission').getRecordTypeId();
        //system.debug('Record Type ID: ' + TRANS_RecordTypeId);
        ASP_PM_Coverage_Master__c OM2 = new ASP_PM_Coverage_Master__c();
        OM2.RecordTypeId = TRANS_RecordTypeId;
        OM2.Manufacturer__c = 'Allison';
        OM2.Transmission_Model__c = 'Allison 1000 Series';
        OM2.Name = 'WMP-549';
        OM2.Duration__c = '3 yr / 100k mi / 161k km';
        OM2.Months__c = 36;
        OM2.Price__c = 8000;
        OM2.Miles__c = 100000;
        OM2.Databook_Code__c = 'WMP-548';
        INSERT OM2;
                
        Offer_Master_Service__c OMS1 = new Offer_Master_Service__c();
        OMS1.Offer_Master__c = OM.ID;
        OMS1.Service_Type__c = 'Oil Analysis';
        OMS1.Service_Frequency__c = 2;
        OMS1.Service_Interval_Miles__c = 45000;
        OMS1.Service_Interval_Months__c = 18;
        INSERT OMS1;
                
        QQ_PM_PDFController.recordID = QQName.Name;
        QQ_PM_PDFController obj = new QQ_PM_PDFController();
    }
}