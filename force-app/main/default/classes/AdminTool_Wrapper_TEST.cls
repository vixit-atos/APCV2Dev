/**
 * @File Name          : AdminTool_Wrapper_TEST.cls
 * @Description        : 
 * @Author             : VIXIT BHARDWAJ - ATOS SYNTEL INC
 * @Group              : 
 * @Last Modified By   : VIXIT BHARDWAJ - ATOS SYNTEL INC
 * @Last Modified On   : 4/7/2020, 10:12:11 AM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    4/7/2020   VIXIT BHARDWAJ - ATOS SYNTEL INC     Initial Version
**/
@isTest
public class AdminTool_Wrapper_TEST 
{
    @isTest
    public static void runTest()
    {     
        Date dt = Date.today();
        
        QQ_Master__c QQM = new QQ_Master__c();
        QQM.Name = 'TEST';
        QQM.Cost__c = 0;
        QQM.Price__c = 0;
        QQM.Months__c = 0;
        QQM.Miles__c = 0;
        QQM.FMV_Date__c = dt;
        INSERT QQM;
        
        
        Id FMVD_recordTypeId = Schema.SObjectType.Administrative_Tool__c.getRecordTypeInfosByName().get('FMV Date').getRecordTypeId();
        Id ECED_recordTypeId = Schema.SObjectType.Administrative_Tool__c.getRecordTypeInfosByName().get('EC Expiration Date').getRecordTypeId();
        Id PM_recordTypeId = Schema.SObjectType.Administrative_Tool__c.getRecordTypeInfosByName().get('Add New Admin Panel Value').getRecordTypeId();
        Id MR_recordTypeId = Schema.SObjectType.Administrative_Tool__c.getRecordTypeInfosByName().get('Create New Model Relationship').getRecordTypeId();
        Id DIS_recordTypeId = Schema.SObjectType.Administrative_Tool__c.getRecordTypeInfosByName().get('PDF Disclaimer Management').getRecordTypeId();
        
        Administrative_Tool__c adm1 = new Administrative_Tool__c();
        adm1.FMV_Date__c = dt;
        adm1.Active__c = true;
        adm1.RecordTypeId = FMVD_recordTypeId;
        INSERT adm1;
        
        Administrative_Tool__c adm11 = new Administrative_Tool__c();
        adm11.FMV_Date__c = dt.addDays(3);
        adm11.Active__c = true;
        adm11.RecordTypeId = FMVD_recordTypeId;
        INSERT adm11;
        
        Administrative_Tool__c adm2 = new Administrative_Tool__c();        
        adm2.Expiration_Date__c = dt.addDays(7);
        adm2.Active__c = true;
        adm2.RecordTypeId = ECED_recordTypeId;
        INSERT adm2;
        
        Administrative_Tool__c adm21 = new Administrative_Tool__c();        
        adm21.Expiration_Date__c = dt.addDays(8);
        adm21.Active__c = true;
        adm21.RecordTypeId = ECED_recordTypeId;
        INSERT adm21;
              
        AdminTool_Wrapper obj = new AdminTool_Wrapper();
        List<Administrative_Tool__c> lstAdmin = new List<Administrative_Tool__c>();
        lstAdmin.add(adm1);
        lstAdmin.add(adm11);
        lstAdmin.add(adm2);
        lstAdmin.add(adm21);            
        obj.preventDML(lstAdmin);
       
        
        
        Administrative_Tool__c adm3 = new Administrative_Tool__c();
        adm3.Field_Name__c = 'Engine Component';
        adm3.Value__c = 'DD-TEST1';
        adm3.RecordTypeId = PM_recordTypeId;
        INSERT adm3;
        
        Administrative_Tool__c adm4 = new Administrative_Tool__c();
        adm4.Field_Name__c = 'Engine Component';
        adm4.Value__c = 'DD-TEST2';
        adm4.RecordTypeId = PM_recordTypeId;
        INSERT adm4;
        
        Administrative_Tool__c adm5 = new Administrative_Tool__c();
        adm5.Group__c = 'HD';
        adm5.Model__c = 'Econic';
        adm5.RecordTypeId = MR_recordTypeId;
        INSERT adm5;
               
        Administrative_Tool__c adm6 = new Administrative_Tool__c();
        adm6.Group__c = 'HD';
        adm6.Model__c = 'Econic';
        adm6.RecordTypeId = MR_recordTypeId;
        INSERT adm6;
        
        DateTime toDate = DateTime.newInstance(4000, 12, 30, 00, 00, 00);
        Administrative_Tool__c adm7 = new Administrative_Tool__c();
        adm7.Quote_Type__c = 'Extended Coverage';
        adm7.Disclaimers__c = 'Daimler test disclaimer';
        adm7.Disclaimer_From_Date__c = dt.addDays(11);
        adm7.Disclaimer_To_Date__c = toDate;
        adm7.RecordTypeId = DIS_recordTypeId;
        INSERT adm7;
        
        
        List<Administrative_Tool__c> newAdmin1 = new List<Administrative_Tool__c>();
        newAdmin1.add(adm1);
        List<Administrative_Tool__c> oldAdmin1 = new List<Administrative_Tool__c>(newAdmin1);
        
        obj.validateDuplicate(newAdmin1, oldAdmin1);
        obj.validateDuplicate(newAdmin1);
        
        
        List<Administrative_Tool__c> newAdmin4 = new List<Administrative_Tool__c>();
        newAdmin4.add(adm4);
        List<Administrative_Tool__c> oldAdmin4 = new List<Administrative_Tool__c>(newAdmin4);
        
        obj.validateDuplicate(newAdmin4, oldAdmin4);
        obj.validateDuplicate(newAdmin4);
        
        
        List<Administrative_Tool__c> newAdmin6 = new List<Administrative_Tool__c>();
        newAdmin6.add(adm6);
        List<Administrative_Tool__c> oldAdmin6 = new List<Administrative_Tool__c>(newAdmin6);
        
        obj.validateDuplicate(newAdmin6, oldAdmin6);
        obj.validateDuplicate(newAdmin6);
        
        
        List<Administrative_Tool__c> newAdmin7 = new List<Administrative_Tool__c>();
        newAdmin7.add(adm7);
        List<Administrative_Tool__c> oldAdmin7 = new List<Administrative_Tool__c>(newAdmin7);
        
        obj.validateDuplicate(newAdmin7, oldAdmin7);
        obj.validateDuplicate(newAdmin7);
        
        
        Administrative_Tool__c ad = new Administrative_Tool__c();
        ad.Id = adm1.Id;
        ad.FMV_Date__c = dt;
        AdminTool_TriggerHandler.beforeUpdate = false;
        AdminTool_TriggerHandler.afterUpdate = false;
        UPDATE ad;
        
        Administrative_Tool__c adm = new Administrative_Tool__c();
        adm.Id = adm1.Id;
        adm.FMV_Date__c = dt.addDays(3);
        adm.Quote_Type__c = 'Extended Coverage';
        adm.Disclaimers__c = 'Daimler test disclaimer';
        adm.Active__c = true;
        UPDATE adm;
        DELETE adm;
        
        Administrative_Tool__c adm70 = new Administrative_Tool__c();
        adm70.Quote_Type__c = 'Extended Coverage';
        adm70.Disclaimers__c = 'Daimler test disclaimer';
        adm70.Disclaimer_From_Date__c = dt.addDays(150);
        adm70.RecordTypeId = DIS_recordTypeId;
        List<Administrative_Tool__c> lstAdmin2 = new List<Administrative_Tool__c>();
        lstAdmin2.add(adm70);
        obj.updateDisclaimer(lstAdmin2);
        
        Map<ID, Administrative_Tool__c> newAdminMap = new Map<ID, Administrative_Tool__c>();
        Map<ID, Administrative_Tool__c> oldAdminMap = new Map<ID, Administrative_Tool__c>();
        newAdminMap.put(adm1.Id, adm1);
        oldAdminMap.put(adm1.Id, adm1);
        obj.updateMaster(newAdminMap, oldAdminMap);
        
    }
}