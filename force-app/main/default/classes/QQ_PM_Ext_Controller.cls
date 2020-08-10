public with sharing class QQ_PM_Ext_Controller  
{
    @AuraEnabled    
    Public static List<ASP_PM_Coverage_Master__c> getDurationDb(String enginemodelval, string vocationalval)
    {
        return [Select Id, Name,ATS_Service__c from ASP_PM_Coverage_Master__c where Engine_Model__c= : enginemodelval and Duty_Cycle__c =:vocationalval];
    }
    
    @AuraEnabled
    public static string getDatabookCode(string engineModel, string dutyCycle, string AddONType, string AddONFilter, string ServiceTime)
    {
        string DBCode = '';
        try
        {
            if(AddONType == 'Drive Belt')
                DBCode = [SELECT Name FROM ASP_PM_Coverage_Master__c WHERE Engine_Model__c = :engineModel AND Duty_Cycle__c = :dutyCycle AND Drive_Belt_Type__c = :AddONFilter AND Drive_Belt_No_Of_Service__c = :ServiceTime].Name;
            if(AddONType == 'Air Filter')
                DBCode = [SELECT Name FROM ASP_PM_Coverage_Master__c WHERE Engine_Model__c = :engineModel AND Air_Filter_Type__c = :AddONFilter AND Air_Filter_No_Of_Services__c = :ServiceTime].Name;
            if(AddONType == 'Air Dryer')
                DBCode = [SELECT Name FROM ASP_PM_Coverage_Master__c WHERE Engine_Model__c = :engineModel AND Air_Dryer_Type__c = :AddONFilter AND Air_Dryer_No_Of_Service__c = :ServiceTime].Name;
            if(AddONType == 'Coolant')
                DBCode = [SELECT Name FROM ASP_PM_Coverage_Master__c WHERE Engine_Model__c = :engineModel AND Duty_Cycle__c = :dutyCycle AND Coolant_System_No_Of_Service__c = :ServiceTime].Name;
            if(AddONType == 'DEF Filter')
                DBCode = [SELECT Name FROM ASP_PM_Coverage_Master__c WHERE Engine_Model__c = :engineModel AND DEF_Filter_No_Of_Service__c = :ServiceTime].Name;
            if(AddONType == 'Differential')
                DBCode = [SELECT Name FROM ASP_PM_Coverage_Master__c WHERE Engine_Model__c = :engineModel AND Duty_Cycle__c = :dutyCycle AND Differential_Service_Type__c = :AddONFilter AND Differential_No_Of_Service__c = :ServiceTime].Name;
            if(AddONType == 'Intial Valve Lash')
                DBCode = [SELECT Name FROM ASP_PM_Coverage_Master__c WHERE Engine_Model__c = :engineModel AND Initial_Valve_Lash_No_Of_Service__c = :ServiceTime].Name;
            if(AddONType == 'Power Steering')
                DBCode = [SELECT Name FROM ASP_PM_Coverage_Master__c WHERE Engine_Model__c = :engineModel AND Duty_Cycle__c = :dutyCycle AND Power_Steering_Type__c = :AddONFilter AND Power_Steering_No_Of_Service__c = :ServiceTime].Name;
            if(AddONType == 'Valve Lash')
                DBCode = [SELECT Name FROM ASP_PM_Coverage_Master__c WHERE Engine_Model__c = :engineModel AND Valve_Lash_Adj_No_Of_Service__c = :ServiceTime].Name;
        }
        catch(Exception exp)
        {
            DBCode = '';
            system.debug('Line: ' + exp.getLineNumber() + ', Error: ' + exp.getMessage());
        }
        return DBCode;
    }
    
    @AuraEnabled
    public static List<ASP_PM_Coverage_Master__c> getMasterLineitems(String packagename )
    {
        String qqQuery='';
        String packageval ='\'%' + String.escapeSingleQuotes(packagename.trim()) + '%\'';
        system.debug(packageval);
        
        qqQuery += 'SELECT Id, Name, Air_Filter_No_Of_Services__c, Power_Steering_Type__c, Coolant_System_No_Of_Service__c, ';
        qqQuery += 'DEF_Filter_No_Of_Service__c, Valve_Lash_Adj_No_Of_Service__c, Initial_Valve_Lash_No_Of_Service__c, ';
        qqQuery += 'Engine_Model__c, Air_Filter_Type__c, Miles__c, Record_Name_Add_On_1__c, Service_Interval__c, Service_Int_Miles__c, ';
        qqQuery += 'Service_Int_Months__c, Duty_Cycle__c, Record_Name_Add_On_2__c, Kms__c, Unique_Record_Name__c, Databook_Code__c, Duration__c, ';
        qqQuery += 'Package__c, Price__c, ATS_Service__c, Transmission_Model__c, Manufacturer__c, Air_Dryer_Type__c, ';
        qqQuery += 'Power_Steering_No_Of_Service__c,  Air_Dryer_No_Of_Service__c, Drive_Belt_Type__c, Differential_No_Of_Service__c, ';
        qqQuery += 'Differential_Service_Type__c, Drive_Belt_No_Of_Service__c ';
        qqQuery += 'FROM ASP_PM_Coverage_Master__c WHERE RecordType.name LIKE' + packageval + 'Order By Months__c ASC';
        list<ASP_PM_Coverage_Master__c>a =Database.query(qqQuery);
        system.debug(a);
        return Database.query(qqQuery);
    }
    
    @AuraEnabled    
    Public static List<Offer_Master_Service__c> getofferservice(Id offermasterid )
    {   
        List <Offer_Master_Service__c> offerservice = [SELECT Name,
                                                       Service_Frequency__c,
                                                       Service_Interval_Hours__c,
                                                       Service_Interval_Miles__c,
                                                       Service_Interval_Months__c,
                                                       Service_Type__c
                                                       FROM Offer_Master_Service__c
                                                       WHERE Offer_Master__c =:offermasterid];
        return offerservice;
    }
    
    @AuraEnabled
    public static wrapperQQ getPMQuotedata(Id QQId)
    {        
        ASP_QQ__c qqobj = [Select Id,Name,Quote_Type__c, Customer_Name__r.Name, Expiration_Date__c from ASP_QQ__c where Id=:QQId];
        List <ASP_PM_Line_Items__c> qqitemlst =  [Select Id,Program__c, Price__c , Engine_Model__c,Package__c,Duty_Cycle__c,Air_Filter__c,Name,Total_Price__c,Transmission_Model__c,Manufacturer__c,Offer_Master_Id__c,Databook_Code__c,Duration__c from ASP_PM_Line_Items__c  where ASP_QQ__c =:QQId];
        List <PM_Line_Item_AddOn__c> addonlst =  [Select Id,Add_On__c,Manufacturer__c,Name,Price__c,Service_Name__c,Offer_Master_Id__c,Databook_Code__c from PM_Line_Item_AddOn__c where PM_Line_Items__c IN :qqitemlst];        
        
        wrapperQQ qqrecord = new wrapperQQ(); 
        qqrecord.quoteobj = qqobj;
        qqrecord.quoteitemlst = qqitemlst;
        qqrecord.addonlst = addonlst;
        return qqrecord;        
    }
    
    public class wrapperQQ 
    {
        @AuraEnabled Public ASP_QQ__c quoteobj;
        @AuraEnabled Public List <ASP_PM_Line_Items__c> quoteitemlst;
        @AuraEnabled Public List <PM_Line_Item_AddOn__c> addonlst;
        
    }    
}