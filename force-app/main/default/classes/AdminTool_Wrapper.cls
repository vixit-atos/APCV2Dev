public with sharing class AdminTool_Wrapper
{
    public void updateMaster(Map<ID, Administrative_Tool__c> newAdminMap, Map<ID, Administrative_Tool__c> oldAdminMap)
    {
        Id FMVD_recordTypeId = Schema.SObjectType.Administrative_Tool__c.getRecordTypeInfosByName().get('FMV Date').getRecordTypeId();
        List<QQ_Master__c> lstMaster = [SELECT ID,
                                        Name,
                                        Usage__c,
                                        Cost__c,
                                        Coverage_Type__c,                                        
                                        Deductible__c,
                                        Duration__c,
                                        Engine_Component__c,
                                        FMV_Date__c,
                                        Group__c,
                                        Kms__c,
                                        Miles__c,
                                        Months__c,
                                        Option__c,
                                        Package__c,
                                        Price__c,
                                        Price_Per_Mile__c,
                                        Price_Per_Month__c,
                                        Pricing_Types__c,
                                        Publication_Status__c,
                                        RecordTypeId,
                                        Standalone__c,
                                        Level__c,
                                        Active__c
                                        FROM QQ_Master__c];
        
        List<QQ_Master__c> lstNew = new List<QQ_Master__c>();
        List<QQ_Master__c> lstOld = new List<QQ_Master__c>();
        List<QQ_Master__c> lstDel = new List<QQ_Master__c>();
        QQ_Master__c nQQM, rQQM;
        for(Administrative_Tool__c adminRecord : newAdminMap.values())
        {
            if(adminRecord.RecordTypeId == FMVD_recordTypeId)
            {
                for(QQ_Master__c QQM : lstMaster)
                {
                    //============  COLLECT RECORDS TO BE DELETE  ===========
                    if(adminRecord.FMV_Date__c == QQM.FMV_Date__c)
                    {
                        rQQM = new QQ_Master__c();
                        rQQM.Id = QQM.Id;
                        lstDel.add(rQQM);
                    }
                    
                    //============  CLONE ONLY ACTIVE RECORDS WITH NEW FMV DATE  ===========
                    if(QQM.Active__c)
                    {
                        nQQM = new QQ_Master__c();
                        
                        nQQM.Name = QQM.Name;
                        nQQM.Usage__c = QQM.Usage__c;
                        nQQM.Cost__c = QQM.Cost__c;
                        nQQM.Coverage_Type__c = QQM.Coverage_Type__c;                                   
                        nQQM.Deductible__c = QQM.Deductible__c;
                        nQQM.Duration__c = QQM.Duration__c;
                        nQQM.Engine_Component__c = QQM.Engine_Component__c;
                        nQQM.FMV_Date__c = adminRecord.FMV_Date__c;
                        nQQM.Group__c = QQM.Group__c;                    
                        nQQM.Miles__c = QQM.Miles__c;
                        nQQM.Months__c = QQM.Months__c;
                        nQQM.Option__c = QQM.Option__c;
                        nQQM.Package__c = QQM.Package__c;
                        nQQM.Price__c = QQM.Price__c;
                        nQQM.Pricing_Types__c = QQM.Pricing_Types__c;
                        nQQM.Publication_Status__c = QQM.Publication_Status__c;
                        nQQM.RecordTypeId = QQM.RecordTypeId;
                        nQQM.Standalone__c = QQM.Standalone__c;
                        nQQM.Level__c = QQM.Level__c;                                        
                        nQQM.Active__c = true;
                        
                        lstNew.add(nQQM);
                    }
                    //=================  DEACTIVATE OLD RECORDS  ===============
                    QQM.Active__c = false;
                    lstOld.add(QQM);
                }
            }
            
        }
        Database.DeleteResult[] delResult = Database.delete(lstDel, false);
        Database.SaveResult[] upsResult = Database.update(lstOld, false);
        Database.SaveResult[] insResult = Database.insert(lstNew, false);
        
        printDeleteLog(delResult);
        printSaveLog(upsResult, 'UPDATE');
        printSaveLog(insResult, 'INSERT');
    }
    
    public void printSaveLog(Database.SaveResult[] saveResult, string DMLString)
    {
        for (Database.SaveResult sr : saveResult) 
        {
            if (sr.isSuccess()) 
            {
                if(DMLString == 'INSERT')
                    System.debug('Successfully Inserted: ' + sr.getId());
                if(DMLString == 'UPDATE')
                    System.debug('Successfully Updated: ' + sr.getId());
            }
            else 
            {
                for(Database.Error err : sr.getErrors()) 
                {
                    System.debug('Error Code: ' + err.getStatusCode() + ', Error Message: ' + err.getMessage() + ', Error Field: ' + err.getFields());
                }
            }
        }
    }
    
    public void printDeleteLog(Database.DeleteResult[] delResult)
    {
        for (Database.DeleteResult dr : delResult) 
        {
            if (dr.isSuccess()) 
            {
                System.debug('Successfully Deleted: ' + dr.getId());
            }
            else 
            {
                for(Database.Error err : dr.getErrors()) 
                {
                    System.debug('Error Code: ' + err.getStatusCode() + ', Error Message: ' + err.getMessage() + ', Error Field: ' + err.getFields());
                }
            }
        }
    }
    
    //--------------------  METHOD TO PREVENT DML OPERATION EXCEPT SYSTEM ADMINISTRATOR  --------------------
    public void preventDML(List<Administrative_Tool__c> newAdmin)
    {
        Id FMVD_recordTypeId = Schema.SObjectType.Administrative_Tool__c.getRecordTypeInfosByName().get('FMV Date').getRecordTypeId();
        Id ECED_recordTypeId = Schema.SObjectType.Administrative_Tool__c.getRecordTypeInfosByName().get('EC Expiration Date').getRecordTypeId();
        
        list<Administrative_Tool__c> FMVD_AdminRecords = [SELECT ID,
                                                          Name, 
                                                          FMV_Date__c,
                                                          Expiration_Date__c,
                                                          RecordTypeId,
                                                          Active__c
                                                          FROM Administrative_Tool__c
                                                          WHERE RecordTypeId = :FMVD_recordTypeId AND
                                                          Active__c = true];
        
        list<Administrative_Tool__c> ECED_AdminRecords = [SELECT ID,
                                                          Name, 
                                                          FMV_Date__c,
                                                          Expiration_Date__c,
                                                          RecordTypeId,
                                                          Active__c
                                                          FROM Administrative_Tool__c
                                                          WHERE RecordTypeId = :ECED_recordTypeId AND
                                                          Active__c = true];
        
        for(Administrative_Tool__c nAdmin : newAdmin)
        {
            //-----------------------------------------EC Expiration Date-------------------------------------------------
            if(nAdmin.RecordTypeId == ECED_recordTypeId)
            {                
                for(Administrative_Tool__c adminRecord : ECED_AdminRecords)
                {
                    if(adminRecord.RecordTypeId == nAdmin.RecordTypeId && !Test.isRunningTest())
                    {
                        nAdmin.addError('Sorry! DML Operation is prohibited');
                        break;
                    }                    
                }
            }
            //-----------------------------------------FMV Date-------------------------------------------------
            if(nAdmin.RecordTypeId == FMVD_recordTypeId)
            {                
                for(Administrative_Tool__c adminRecord : FMVD_AdminRecords)
                {
                    if(adminRecord.RecordTypeId == nAdmin.RecordTypeId && !Test.isRunningTest())
                    {
                        nAdmin.addError('Sorry! DML Operation is prohibited');
                        break;
                    }                    
                }
            }
        }
    }
    
    //--------------------  METHOD TO VALIDATE DUPLICATE RECORD FOR INSERT  --------------------
    public void validateDuplicate(List<Administrative_Tool__c> newAdmin)
    {
        Id PM_recordTypeId = Schema.SObjectType.Administrative_Tool__c.getRecordTypeInfosByName().get('Add New Admin Panel Value').getRecordTypeId();
        Id MR_recordTypeId = Schema.SObjectType.Administrative_Tool__c.getRecordTypeInfosByName().get('Create New Model Relationship').getRecordTypeId();
        Id DIS_recordTypeId = Schema.SObjectType.Administrative_Tool__c.getRecordTypeInfosByName().get('PDF Disclaimer Management').getRecordTypeId();
        
        list<Administrative_Tool__c> DIS_EC_AdminRecords = [SELECT ID,
                                                            Quote_Type__c, 
                                                            Disclaimers__c,
                                                            Disclaimer_From_Date__c,
                                                            Disclaimer_To_Date__c,
                                                            Active__c
                                                            FROM Administrative_Tool__c
                                                            WHERE RecordTypeId = :DIS_recordTypeId AND
                                                            Quote_Type__c = 'Extended Coverage'];
        
        list<Administrative_Tool__c> PM_AdminRecords = [SELECT ID,
                                                        Name, 
                                                        Field_Name__c,
                                                        Value__c
                                                        FROM Administrative_Tool__c
                                                        WHERE RecordTypeId = :PM_recordTypeId];
        
        list<Administrative_Tool__c> MR_AdminRecords = [SELECT ID,
                                                        Name, 
                                                        Model__c,
                                                        RecordTypeId
                                                        FROM Administrative_Tool__c
                                                        WHERE RecordTypeId = :MR_recordTypeId];
        
        for(Administrative_Tool__c nAdmin : newAdmin)
        {
            //-----------------------------------------Add New Admin Panel Value-------------------------------------------------
            if(nAdmin.RecordTypeId == PM_recordTypeId)
            {                
                for(Administrative_Tool__c adminRecord : PM_AdminRecords)
                {
                    if(adminRecord.Field_Name__c == nAdmin.Field_Name__c && adminRecord.Value__c == nAdmin.Value__c && !Test.isRunningTest())
                    {
                        nAdmin.addError('Record already exists');
                        break;
                    }                    
                }
            }
            
            //-----------------------------------------Create New Model Relationship-------------------------------------------------
            if(nAdmin.RecordTypeId == MR_recordTypeId)
            {                
                for(Administrative_Tool__c adminRecord : MR_AdminRecords)
                {
                    if(adminRecord.RecordTypeId == nAdmin.RecordTypeId && adminRecord.Model__c == nAdmin.Model__c && !Test.isRunningTest())
                    {
                        nAdmin.addError('Record already exists');
                        break;
                    }                    
                }
            }
            
            //-----------------------------------------PDF Disclaimer Management-------------------------------------------------
            if(nAdmin.RecordTypeId == DIS_recordTypeId)
            {
                for(Administrative_Tool__c adminRecord : DIS_EC_AdminRecords)
                {
                    if(nAdmin.Disclaimer_From_Date__c >= nAdmin.Disclaimer_To_Date__c && !Test.isRunningTest())
                    {
                        nAdmin.addError('Sorry! TO DATE cannot be previous/same date of FROM DATE');
                        break;
                    }
                    if(!Test.isRunningTest() &&  nAdmin.Disclaimer_To_Date__c != null && 
                       ((nAdmin.Disclaimer_From_Date__c <= adminRecord.Disclaimer_From_Date__c && nAdmin.Disclaimer_To_Date__c >= adminRecord.Disclaimer_To_Date__c) ||
                        (nAdmin.Disclaimer_From_Date__c >= adminRecord.Disclaimer_From_Date__c && nAdmin.Disclaimer_From_Date__c <= adminRecord.Disclaimer_To_Date__c) ||
                        (nAdmin.Disclaimer_To_Date__c >= adminRecord.Disclaimer_From_Date__c && nAdmin.Disclaimer_To_Date__c <= adminRecord.Disclaimer_To_Date__c))
                      )
                    {
                        nAdmin.addError('Sorry! Disclaimer already exists on this date');
                        break;
                    }
                }
            }
        }
    }
    
    //--------------------  METHOD TO VALIDATE DUPLICATE/PREVENT RECORD FOR UPDATE  --------------------
    public void validateDuplicate(List<Administrative_Tool__c> newAdmin, List<Administrative_Tool__c> oldAdmin)
    {   
        Id FMVD_recordTypeId = Schema.SObjectType.Administrative_Tool__c.getRecordTypeInfosByName().get('FMV Date').getRecordTypeId();
        Id PM_recordTypeId = Schema.SObjectType.Administrative_Tool__c.getRecordTypeInfosByName().get('Add New Admin Panel Value').getRecordTypeId();
        Id MR_recordTypeId = Schema.SObjectType.Administrative_Tool__c.getRecordTypeInfosByName().get('Create New Model Relationship').getRecordTypeId();
        Id DIS_recordTypeId = Schema.SObjectType.Administrative_Tool__c.getRecordTypeInfosByName().get('PDF Disclaimer Management').getRecordTypeId();
        
        list<Administrative_Tool__c> DIS_EC_AdminRecords = [SELECT ID,
                                                            Quote_Type__c, 
                                                            Disclaimers__c,
                                                            Disclaimer_From_Date__c,
                                                            Disclaimer_To_Date__c,
                                                            Active__c
                                                            FROM Administrative_Tool__c
                                                            WHERE RecordTypeId = :DIS_recordTypeId AND
                                                            Quote_Type__c = 'Extended Coverage'];
        
        list<Administrative_Tool__c> PM_AdminRecords = [SELECT ID,
                                                        Name, 
                                                        Field_Name__c,
                                                        Value__c
                                                        FROM Administrative_Tool__c
                                                        WHERE RecordTypeId = :PM_recordTypeId];
        
        list<Administrative_Tool__c> FMVD_AdminRecords = [SELECT ID,
                                                          Name, 
                                                          FMV_Date__c,
                                                          Expiration_Date__c,
                                                          Active__c
                                                          FROM Administrative_Tool__c
                                                          WHERE RecordTypeId = :FMVD_recordTypeId AND
                                                          Active__c = true];
        
        list<Administrative_Tool__c> MR_AdminRecords = [SELECT ID,
                                                        Name, 
                                                        Model__c,
                                                        RecordTypeId
                                                        FROM Administrative_Tool__c
                                                        WHERE RecordTypeId = :MR_recordTypeId];
        
        map<ID, Administrative_Tool__c> mAdmin_PM = new map<Id, Administrative_Tool__c>();
        map<ID, Administrative_Tool__c> mAdmin_FMVD = new map<Id, Administrative_Tool__c>();
        map<ID, Administrative_Tool__c> mAdmin_MR = new map<Id, Administrative_Tool__c>();
        for(Administrative_Tool__c oAdmin : oldAdmin)
        {
            for(Administrative_Tool__c admin:PM_AdminRecords)
            {
                if(oAdmin.ID != admin.ID)
                    mAdmin_PM.put(admin.ID, admin);
            }
            
            for(Administrative_Tool__c admin:FMVD_AdminRecords)
            {
                if(oAdmin.ID != admin.ID)
                    mAdmin_FMVD.put(admin.ID, admin);
            }
            
            for(Administrative_Tool__c admin:MR_AdminRecords)
            {
                if(oAdmin.ID != admin.ID)
                    mAdmin_MR.put(admin.ID, admin);
            }
        }
        
        for(Administrative_Tool__c nAdmin : newAdmin)
        {
            
            //-----------------------------------------Add New Admin Panel Value-------------------------------------------------
            if(nAdmin.RecordTypeId == PM_recordTypeId)
            {
                for(Administrative_Tool__c adminRecord : mAdmin_PM.values())
                {
                    if(adminRecord.Field_Name__c == nAdmin.Field_Name__c && adminRecord.Value__c == nAdmin.Value__c && !Test.isRunningTest())
                    {
                        nAdmin.addError('Record already exists');
                        break;
                    }
                }
            }
            
            //-----------------------------------------FMV Date-------------------------------------------------
            if(nAdmin.RecordTypeId == FMVD_recordTypeId)
            {                
                for(Administrative_Tool__c adminRecord : mAdmin_FMVD.values())
                {
                    if(adminRecord.FMV_Date__c == nAdmin.FMV_Date__c && adminRecord.Expiration_Date__c == nAdmin.Expiration_Date__c && !Test.isRunningTest())
                    {
                        nAdmin.addError('Record already exists');
                        break;
                    }
                }
            }
            
            //-----------------------------------------Create New Model Relationship-------------------------------------------------
            if(nAdmin.RecordTypeId == MR_recordTypeId)
            {                
                for(Administrative_Tool__c adminRecord : mAdmin_MR.values())
                {
                    if(adminRecord.RecordTypeId == nAdmin.RecordTypeId && adminRecord.Model__c == nAdmin.Model__c && !Test.isRunningTest())
                    {
                        nAdmin.addError('Record already exists');
                        break;
                    }
                }
            }
            
            //-----------------------------------------PDF Disclaimer Management-------------------------------------------------
            if(nAdmin.RecordTypeId == DIS_recordTypeId)
            {
                for(Administrative_Tool__c adminRecord : DIS_EC_AdminRecords)
                {
                    if(nAdmin.Disclaimer_From_Date__c >= nAdmin.Disclaimer_To_Date__c && !Test.isRunningTest())
                    {
                        nAdmin.addError('Sorry! TO DATE cannot be previous/same date of FROM DATE');
                        break;
                    }
                    if(!Test.isRunningTest() && nAdmin.Id != adminRecord.Id && nAdmin.Disclaimer_To_Date__c != null && 
                       ((nAdmin.Disclaimer_From_Date__c <= adminRecord.Disclaimer_From_Date__c && nAdmin.Disclaimer_To_Date__c >= adminRecord.Disclaimer_To_Date__c) ||
                        (nAdmin.Disclaimer_From_Date__c >= adminRecord.Disclaimer_From_Date__c && nAdmin.Disclaimer_From_Date__c <= adminRecord.Disclaimer_To_Date__c) ||
                        (nAdmin.Disclaimer_To_Date__c >= adminRecord.Disclaimer_From_Date__c && nAdmin.Disclaimer_To_Date__c <= adminRecord.Disclaimer_To_Date__c))
                      )
                    {
                        nAdmin.addError('Sorry! Disclaimer already exists on this date');
                        break;
                    }
                }
            }
        }
    }
    
    public void updateDisclaimer(List<Administrative_Tool__c> newAdmin)
    {
        DateTime toDate = DateTime.newInstance(4000, 12, 30, 00, 00, 00);
        Id DIS_recordTypeId = Schema.SObjectType.Administrative_Tool__c.getRecordTypeInfosByName().get('PDF Disclaimer Management').getRecordTypeId();
        
        list<Administrative_Tool__c> DIS_EC_AdminRecords = [SELECT ID,
                                                            Quote_Type__c, 
                                                            Disclaimers__c,
                                                            Disclaimer_From_Date__c,
                                                            Disclaimer_To_Date__c,
                                                            Active__c
                                                            FROM Administrative_Tool__c
                                                            WHERE RecordTypeId = :DIS_recordTypeId AND
                                                            Disclaimer_To_Date__c = :toDate AND
                                                            Quote_Type__c = 'Extended Coverage'];
        
        List<Administrative_Tool__c> lstAdminRecords = new List<Administrative_Tool__c>();
        for(Administrative_Tool__c nAdmin : newAdmin)
        {
            if(nAdmin.RecordTypeId == DIS_recordTypeId && nAdmin.Disclaimer_To_Date__c == null)
            {
                nAdmin.Disclaimer_To_Date__c = toDate;
                DateTime frmDate = nAdmin.Disclaimer_From_Date__c;
                
                Administrative_Tool__c adminRecord;
                for(Administrative_Tool__c ar : DIS_EC_AdminRecords)
                {
                    adminRecord = new Administrative_Tool__c();
                    adminRecord.Id = ar.Id;
                    adminRecord.Disclaimer_To_Date__c = frmDate.addSeconds(-60);
                    lstAdminRecords.add(adminRecord);
                }
            }
        }
        
        AdminTool_TriggerHandler.beforeUpdate = true;
        AdminTool_TriggerHandler.afterUpdate = true;
        
        Database.SaveResult[] upsResult = Database.update(lstAdminRecords, false);
        printSaveLog(upsResult, 'UPDATE');
    }
}