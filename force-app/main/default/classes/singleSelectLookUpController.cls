public class singleSelectLookUpController 
{
    //fetch lookup values based on object and search keyword
	@AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
        String searchKey = string.escapeSingleQuotes(searchKeyWord) + '%';
        
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        String sQuery =  'select id, Name from ' + string.escapeSingleQuotes(ObjectName) + ' where Name LIKE: searchKey order by createdDate DESC limit 5';
        List<sObject> lstOfRecords = Database.query(sQuery);
       
        return lstOfRecords;
    }
}