public without sharing class sObjectServerControllerWOSharing {
    
    /*
     * Used to retrieve the field metadata information for multiple fields
     * requestName used for logging purposes
     * objectFieldMaps holds the sObjectType and associated fields
     * Returns JSONified Map<String,List<Schema.DescribeFieldResult>>
     */
    @AuraEnabled public static String getDescribeFieldResults(String requestName, Map<String,List<String>> objectFieldMaps){
        String loggerCategory = requestName + ' sObject Describe Fields';
        Map<String,List<Schema.DescribeFieldResult>> objectMetadataMap = new Map<String, List<Schema.DescribeFieldResult>>();
        List<Schema.DescribeFieldResult> fieldMetadata = new List<Schema.DescribeFieldResult>();
        String sObjectType = '';
        
        try{
            for(String key: objectFieldMaps.keyset()){
                for(String field : objectFieldMaps.get(key)){
                    fieldMetadata.add(Schema.getGlobalDescribe().get(key).getDescribe().fields.getMap().get(field).getDescribe());
                }
                objectMetadataMap.put(key, fieldMetadata);
                fieldMetadata = new List<Schema.DescribeFieldResult>();
            }
            
            return JSON.serializePretty(objectMetadataMap);
        }
        
        catch(Exception e){
            Logger.insertLog(loggerCategory, null, e, 'An error occurred with the inputs provided. objectFieldMaps: ' + objectFieldMaps, false);
            return null;
        }
    }
    
    /*
     * Used to retrieve the type of sObject a specific record
     * requestName used for logging purposes
     * recordId used to find that specific ID's sObjectType
     * returns the sObjectType's Name
     */
    @AuraEnabled public static String getSObjectTypeByRecordId(String requestName, ID recordId){
        String loggerCategory = requestName + 'sObject ObjectType By RecordID';
        //Returns the Id's SObjectType
        try{
            return recordId.getSobjectType().getDescribe().getName();
        }catch(Exception e){
            Logger.insertLog(loggerCategory, null, e, 'An error occurred with the inputs provided. recordId: ' + recordId, false);
            return null;
        }
    }
    
    /*
     * Performs DML functions through a switch case
     * dmlType used for the switch case for operations
     * objects used as the data being modified in the database
     *  through parsing and looping through a Map of String:sObjects[]
     * allorNone used to determine to shortcircuit if true
     * requestName used for logging purposes
     */
    @AuraEnabled public static Boolean performDML(String dmlType, List<sObject> objects, Boolean allOrNone, String requestName){
        String loggerCategory = requestName + ' sObject ' + dmlType;
        Map <String, Schema.SObjectField> fieldMap = new Map <String, Schema.SObjectField>();
        Map<String, List<sObject>> sObjectTypeObjectsMap;
        if(objects != null){
            sObjectTypeObjectsMap = parseSObjects(objects);
        }
        Schema.DescribeFieldResult dfr;
        String currentFieldData = '';
        Database.SaveResult[] srs;
        Database.DeleteResult[] drs;
        Database.UpsertResult[] urs;
        Boolean deletedBadId = false;
        
        SavePoint sp = Database.setSavePoint();
        try{
            for(String sObjType : sObjectTypeObjectsMap.keyset()){
                switch on dmlType{
                    when 'Update'{
                        srs = Database.update(sObjectTypeObjectsMap.get(sObjType), allOrNone);
                        return checkSaveResults(srs, loggerCategory);
                    }
                    when 'Insert'{
                        srs = Database.insert(sObjectTypeObjectsMap.get(sObjType), allOrNone);
                        return checkSaveResults(srs, loggerCategory);
                    }
                    when 'Delete'{
                        drs = Database.delete(sObjectTypeObjectsMap.get(sObjType), allOrNone);
                        return true;
                    }
                }
            }
            Logger.insertLog(loggerCategory, null, 'Error', 'DML provided is not supported. DMLType: ' + dmlType + ' SObjects ' + objects, false);
            return false;
        }catch(exception e){
            system.debug('Rollback');
            Database.rollback(sp);
            Logger.insertLog(loggerCategory, null, e, 'DML provided is not supported. DMLType: ' + dmlType + ' SObjects ' + objects, false);
            return false;
        }
    }
    
    /*
     * Used to retrieve the query results. Splits on Keywords SELECT and FIND
     * requestName used for logging purposes
     * query is the query prebuilt by a developer to be queried for
     * returns the query results
     */
    @AuraEnabled public static List<List<sObject>> performQuery(String requestName, String query){
        String loggerCategory = 'sObject Query';
        String queryStart = query.substring(0,6);
        List<List<sObject>> queryResults = new List<List<sObject>>();
        try{
            if(queryStart.contains('SELECT')){
                queryResults.add(Database.query(query));
                return queryResults;
            }
            else if(queryStart.contains('FIND')){
                return search.query(query);
            }
            else{
                Logger.insertLog(loggerCategory, null, 'Error', 'The query provided isn\'t an SOQL or SOSL type. Query : ' + query, false);
                return null;
            }
        
        }catch(Exception e){
            Logger.insertLog(loggerCategory, null, e, 'An error occurred with the query provided. Query: ' + query, false);
            return null;
        }
    }
    
    /*
     * Parses a list of sObjects into their own map of lists
     * jsonObjects used to split apart and must be in JSON formatting
     * returns a Map of String and List of Objects
     * String being the sObjectType
     * List of Objects being the associated records
     */
    private static Map<String, List<SObject>> parseSObjects(List<sObject> jsonSObjects){
        Map<String, List<sObject>> sObjectTypeObjectsMap = new Map<String, List<sObject>>();
        String sObjectType = '';
        
        for(sObject so : jsonSObjects){
            sObjectType = String.valueOf(so.getSObjectType());
            List<sObject> tempList = sObjectTypeObjectsMap.get(sObjectType);
            if(tempList == null){
                templist = new List<sObject>();
            }
            tempList.add(so);
            sObjectTypeObjectsMap.put(String.ValueOf(sObjectType), tempList);
        }
        return sObjectTypeObjectsMap;
    }
    
    /*
     * Checks the Save Results provided and
     * Any errors are handled accordingly and passed back up
     * srs used to check if any errors occurred during the process
     * allOrNone used to short-circuit the operation and rollback if required
     * sp used to rollback the server if an issue occurs
     * requestName used for logging purposes
     * loggerCategory used for logging purposes
     * objects used for logging purposes on allOrNone failure
     */ 
    private static Boolean checkSaveResults(Database.SaveResult[] srs, String loggerCategory){
        Database.SaveResult[] returningObjects = new Database.SaveResult[]{};
        for(Database.SaveResult sr : srs){
            if(!sr.isSuccess()){ returningObjects.add(sr); }
        }
        Logger.insertLog(loggerCategory, null, 'Warning', 'These records have not been modified. SaveResults ' + returningObjects, false);
        return true;
    }
}