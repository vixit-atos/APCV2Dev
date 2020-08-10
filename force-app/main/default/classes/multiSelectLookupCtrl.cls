public with sharing class multiSelectLookupCtrl {
    @AuraEnabled
    public static List < sObject > fetchObjectValues(String userInput, String objectName, List<sObject> excludedItems, 
                                                    String queryFields, String queryWhere, String queryOrder, String queryLimit) {
        String searchKey = '%' + userInput + '%';
        List < sObject > returnList = new List < sObject > ();
 
        List<string> excludedIds = new List<string>();
        for(sObject item : excludedItems )
            excludedIds.add(item.id);
            
        if (queryFields.length()>0) queryFields = ','+queryFields;
        if (queryWhere.length()>0) queryWhere = 'AND ('+queryWhere+')';//'AND '+queryWhere;//
        if (queryLimit.length()>0) queryLimit = 'LIMIT '+queryLimit;
        
        String sQuery =  'SELECT Id, Name'+queryFields+' FROM '+objectName+' WHERE Name LIKE :searchKey'+
                            ' AND Id NOT IN :excludedIds '+queryWhere+' ORDER BY '+queryOrder+' '+queryLimit;
        System.debug(sQuery);
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
    
	@AuraEnabled
    public static List<String> fetchFieldValues(String type, String fieldName, String userInput, List<String> excludedItems) {
        Schema.SObjectType convertType = Schema.getGlobalDescribe().get(type);
        if (convertType==null)
            return new List<String> {type+' is not a valid object type'};
        Sobject sobj = convertType.newSObject();
        Map<String,Schema.SObjectField> fieldMap = sobj.getSObjectType().getDescribe().fields.getMap();
        if (fieldMap.get(fieldName)==null)
            return new List<String> {'No field called '+fieldName+' found on '+sobj.getSObjectType()};
        Schema.DescribeFieldResult dfr = fieldMap.get(fieldName).getDescribe();
        Schema.DisplayType fieldType = dfr.getType();
        if (fieldType != Schema.DisplayType.MULTIPICKLIST && fieldType != Schema.DisplayType.PICKLIST)
            return new List<String> {fieldName+' is not a picklist'};
        List<Schema.PicklistEntry> values = dfr.getPickListValues();
        List<String> results = new List<String>();
        Map<String,Boolean> excluded = new Map<String,Boolean>();
        for (String s : excludedItems)
            excluded.put(s,true);
        system.debug(excluded);
        for (Schema.PicklistEntry pe : values) {
            String val = pe.getLabel();
            if (excluded==null || excluded.get(val)!=true) {
                if(val.toLowerCase().contains(userInput.toLowerCase()))
                    results.add(val);
                else if (userInput=='')
                    results.add(val);
            }
        }
        results.add(fieldType.name());
        return results;
    }

    @AuraEnabled
    public static String createSobject(Sobject sobj, String query) {
        try {
            insert(sobj);
            if (query != '')
                sobj = Database.query(query+'\''+sobj.Id+'\'');
            return JSON.serialize(sobj);
        } catch(Exception e) {
            return e.getMessage();
        }
    }
}