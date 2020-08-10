@isTest
public class QQ_PM_Ext_Controller_TEST 
{
    @isTest
    public static void runTest()
    {
        string enginemodelval = '';
        string vocationalval = '';
        string vocationalval1 = '';
        string packagename = '';
        string firstName = '';
        string durationval = '';
      //  ASP_PM_Coverage_Master__c offermaster = [Select Id from ASP_PM_Coverage_Master__c Limit 1];
        Test.startTest();
        ASP_QQ__c QQ = new ASP_QQ__c();
        QQ.Stage__c = 'Pending';
        QQ.Status__c = 'Pending for Validation';
        QQ.Domain__c = 'Extended Warranty';
        QQ.Source__c = 'Internal';
        QQ.Expiration_Date__c = Date.today();
        QQ.From_Date__c = Date.today();
        QQ.FMV_Date__c = Date.today();
        INSERT QQ;
       
        
        
        QQ_PM_Ext_Controller.getDurationDb(enginemodelval, vocationalval);
        // QQ_PM_Ext_Controller.getofferservice(offermaster.Id);
        QQ_PM_Ext_Controller.getMasterLineitems(packagename);
        QQ_PM_Ext_Controller.getPMQuotedata(QQ.Id);
        
        string engineModel = 'DD15';
        string dutyCycle = 'Short Haul';
        string AddONType = '';
        string AddONFilter = '1-Stage';
        string ServiceTime = '5';
        
        AddONType = 'Drive Belt';
        QQ_PM_Ext_Controller.getDatabookCode(engineModel, dutyCycle, AddONType, AddONFilter, ServiceTime);
        AddONType = 'Air Filter';
        QQ_PM_Ext_Controller.getDatabookCode(engineModel, dutyCycle, AddONType, AddONFilter, ServiceTime);
        AddONType = 'Air Dryer'; 
        QQ_PM_Ext_Controller.getDatabookCode(engineModel, dutyCycle, AddONType, AddONFilter, ServiceTime);
        AddONType = 'Coolant';
        QQ_PM_Ext_Controller.getDatabookCode(engineModel, dutyCycle, AddONType, AddONFilter, ServiceTime);
        AddONType = 'DEF Filter';
        QQ_PM_Ext_Controller.getDatabookCode(engineModel, dutyCycle, AddONType, AddONFilter, ServiceTime);
        AddONType = 'Differential';
        QQ_PM_Ext_Controller.getDatabookCode(engineModel, dutyCycle, AddONType, AddONFilter, ServiceTime);
        AddONType = 'Intial Valve Lash';
        QQ_PM_Ext_Controller.getDatabookCode(engineModel, dutyCycle, AddONType, AddONFilter, ServiceTime);
        AddONType = 'Power Steering';
        QQ_PM_Ext_Controller.getDatabookCode(engineModel, dutyCycle, AddONType, AddONFilter, ServiceTime);
        AddONType = 'Valve Lash';
        QQ_PM_Ext_Controller.getDatabookCode(engineModel, dutyCycle, AddONType, AddONFilter, ServiceTime);
        
        Test.stopTest();
    }
}