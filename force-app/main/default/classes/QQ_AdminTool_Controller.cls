public class QQ_AdminTool_Controller 
{
    public class KeyValue 
    {
        @AuraEnabled 
        public string value {get; set;}
        @AuraEnabled 
        public string label {get; set;}
    }
    
    @AuraEnabled
    public static string getRecordType(string recordTypeId)
    {
        string RecordType = Schema.getGlobalDescribe().get('Administrative_Tool__c').getDescribe().getRecordTypeInfosById().get(recordTypeId).getName();
        return RecordType;
    }
    
    @AuraEnabled
    public static list<KeyValue> getItem(string category)
    {
        //system.debug('Category: ' + category);
        list<Administrative_Tool__c> lstItems = [SELECT ID,
                                                 Name,
                                                 Value__c,
                                                 Sort_Order__c
                                                 FROM Administrative_Tool__c
                                                 WHERE Field_Name__c = :category AND
                                                 RecordType.Name = 'Add New Admin Panel Value' AND
                                                 Active__c = true
                                                 ORDER BY Value__c ASC];
        
        list<KeyValue> lstKV = new list<KeyValue>();
        KeyValue KV;
        for(Administrative_Tool__c AT : lstItems)
        {
            KV = new KeyValue();
            KV.value = AT.Value__c;
            KV.label = AT.Value__c;
            lstKV.add(KV);
        }
        return lstKV;
    }
    
    @AuraEnabled
    public static list<KeyValue> getPicklistItem(string category)
    {
        Schema.DescribeFieldResult fieldResult;
        if(category == 'Group')
            fieldResult = Administrative_Tool__c.Group__c.getDescribe();
        if(category == 'A85 Code')
            fieldResult = Administrative_Tool__c.A85_Code__c.getDescribe();
        if(category == 'Quote Type')
            fieldResult = Administrative_Tool__c.Quote_Type__c.getDescribe();
        
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        list<KeyValue> lstKV = new list<KeyValue>();
        KeyValue KV;
        for( Schema.PicklistEntry pickListVal : ple)
        {
            KV = new KeyValue();
            KV.value = pickListVal.getValue();
            KV.label = pickListVal.getLabel();
            lstKV.add(KV);
        }
        return lstKV;  
    }
    
    @AuraEnabled
    public static string getParentID(string QuoteType)
    {
        string parentID = '';
        try
        {
            parentID = [SELECT ID,
                        Name,
                        CreatedDate
                        FROM Administrative_Tool__c
                        WHERE Quote_Type__c = :QuoteType 
                        ORDER BY CreatedDate DESC LIMIT 1].ID;
            
        }
        catch(Exception exp)
        {
            system.debug('Line: ' + exp.getLineNumber() + ', Error: ' + exp.getMessage());
        }
        return parentID;
    }
    
    @AuraEnabled
    public static boolean verifyDuplicate(Administrative_Tool__c AdminTool)
    {
        boolean duplicateExist = false;
        
        Id recordTypeId = Schema.SObjectType.Administrative_Tool__c.getRecordTypeInfosByName().get('Create New Model Relationship').getRecordTypeId();
        
        List<Administrative_Tool__c> AdminRecords = new List<Administrative_Tool__c>();
        if(AdminTool.ID == null)
        {
            AdminRecords = [SELECT ID,
                            Name, 
                            Model__c,
                            RecordTypeId
                            FROM Administrative_Tool__c
                            WHERE RecordTypeId = :recordTypeId ];
        }
        else
        {
            AdminRecords = [SELECT ID,
                            Name, 
                            Model__c,
                            RecordTypeId
                            FROM Administrative_Tool__c
                            WHERE RecordTypeId = :recordTypeId AND ID != :AdminTool.ID ];
        }
        
        for(Administrative_Tool__c admin:AdminRecords)
        {
            if(AdminTool.RecordTypeId == recordTypeId && AdminTool.Model__c == admin.Model__c)
            {   
                duplicateExist = true;
                break;
            }
        }
        
        return duplicateExist;
    }
    
    @AuraEnabled
    public static string validateDisclaimer(Administrative_Tool__c AdminTool)
    {
        string validationMSG = 'SUCCESS';
        
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
        
        if(AdminTool.RecordTypeId == DIS_recordTypeId)
        {
            for(Administrative_Tool__c adminRecord : DIS_EC_AdminRecords)
            {
                if(AdminTool.Disclaimer_From_Date__c >= AdminTool.Disclaimer_To_Date__c)
                {
                    validationMSG = 'Sorry! TO DATE cannot be previous/same date of FROM DATE';
                    break;
                }
                if(AdminTool.Disclaimer_To_Date__c == null && AdminTool.Disclaimer_From_Date__c <= adminRecord.Disclaimer_From_Date__c)
                {
                    validationMSG = 'Sorry! Disclaimer already exists on this date';
                    break;
                }
                if(AdminTool.Disclaimer_To_Date__c != null && 
                   ((AdminTool.Disclaimer_From_Date__c <= adminRecord.Disclaimer_From_Date__c && AdminTool.Disclaimer_To_Date__c >= adminRecord.Disclaimer_To_Date__c) ||
                    (AdminTool.Disclaimer_From_Date__c >= adminRecord.Disclaimer_From_Date__c && AdminTool.Disclaimer_From_Date__c <= adminRecord.Disclaimer_To_Date__c) ||
                    (AdminTool.Disclaimer_To_Date__c >= adminRecord.Disclaimer_From_Date__c && AdminTool.Disclaimer_To_Date__c <= adminRecord.Disclaimer_To_Date__c))
                  )
                {
                    validationMSG = 'Sorry! Disclaimer already exists on this date';
                    break;
                }
            }
        }
        
        return validationMSG;
    }
    
    @AuraEnabled
    public static Id submitRecord(Administrative_Tool__c AdminTool)
    {
        try
        {
            UPSERT AdminTool;
        }
        catch(Exception exp)
        {
            system.debug('Line: ' + exp.getLineNumber() + ', Error: ' + exp.getMessage());
        }
        return AdminTool.Id;
    }
    
    @AuraEnabled
    public static ID saveFile(String fileName, String base64Data, String contentType, String policyDesc) 
    {
        ID AttachID = null;
        try
        {
            //List<Attachment> lstAttachment = [SELECT ID, Name FROM Attachment WHERE Description LIKE '%Extended Coverage%'];
            //Database.delete(lstAttachment, false);
            
            base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
            Attachment attach = new Attachment();
            
            string[] Desc_Array = policyDesc.split('-');
            attach.parentId = getParentID(Desc_Array[1]);
            attach.Body = EncodingUtil.base64Decode(base64Data);
            attach.Name = fileName;
            attach.ContentType = contentType;
            attach.Description = policyDesc;
            INSERT attach;
            AttachID = attach.Id;
        }
        catch(Exception exp)
        {
            system.debug('Line: ' + exp.getLineNumber() + ', Error: ' + exp.getMessage());
        }
        return AttachID;
    }
}