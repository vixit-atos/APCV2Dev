@isTest public class multiSelectLookupCrtlTest {
    @testSetup static void testSetup(){
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name='Test'));
        accounts.add(new Account(Name='Excluded'));
        insert accounts;
    }
    
    @isTest static void fetchObjectValuesTest(){
        List<sObject> results = new List<sObject>();
        Account excludedAccount = [SELECT Id FROM Account where Name = 'Excluded' LIMIT 1];
        List<sObject> testList = new List<sObject>();
        String userInput = 'T';
        String objectName = 'Account';
        List<sObject> excludedItems = new List<sObject>();
        excludedItems.add(excludedAccount);
        String queryField = 'CreatedDate';
        String queryWhere = 'Id != NULL';
        String queryOrder = 'CreatedDate';
        String queryLimit = '1';
        test.startTest();
        results = multiSelectLookupCtrl.fetchObjectValues(userInput, objectName, excludedItems, queryField, queryWhere, queryOrder, queryLimit);
        system.assertEquals(1, results.size());
        test.stopTest();
    }
    
    @isTest static void fetchFieldValuesTestSuccess(){
        String type = 'Account';
        String fieldName = 'UTP_Version__c';
        String userInput = '0';
        Account a = [SELECT Id FROM Account LIMIT 1];
        List<String> excludedItems = new List<String>();
        
        excludedItems.add(a.Id);
        test.startTest();
        multiSelectLookupCtrl.fetchFieldValues(type, fieldName, userInput, excludedItems);
        test.stopTest();
    }
    
    @isTest static void fetchFieldValuesTestBadFieldName(){
        String type = 'Account';
        String fieldName = 'Name';
        String userInput = '0';
        Account a = [SELECT Id FROM Account LIMIT 1];
        List<String> excludedItems = new List<String>();
        
        excludedItems.add(a.Id);
        test.startTest();
        multiSelectLookupCtrl.fetchFieldValues(type, fieldName, userInput, excludedItems);
        test.stopTest();
    }
    
    @isTest static void fetchFieldValuesTestBadObjectName(){
        String type = 'BadObject';
        String fieldName = 'Name';
        String userInput = '0';
        Account a = [SELECT Id FROM Account LIMIT 1];
        List<String> excludedItems = new List<String>();
        
        excludedItems.add(a.Id);
        test.startTest();
        multiSelectLookupCtrl.fetchFieldValues(type, fieldName, userInput, excludedItems);
        test.stopTest();
    }
    
    @isTest static void fetchFieldValuesTestNoFieldName(){
        String type = 'Account';
        String fieldName = '';
        String userInput = '0';
        Account a = [SELECT Id FROM Account LIMIT 1];
        List<String> excludedItems = new List<String>();
        
        excludedItems.add('fafda');
        test.startTest();
        multiSelectLookupCtrl.fetchFieldValues(type, fieldName, userInput, excludedItems);
        test.stopTest();
    }
    
    @isTest static void fetchFieldValuesTestNoUserInput(){
        List<String> values = new List<String>();
        String type = 'Account';
        String fieldName = 'UTP_Version__c';
        String userInput = '';
        Account a = [SELECT Id FROM Account LIMIT 1];
        List<String> excludedItems = new List<String>();
        
        excludedItems.add(a.Id);
        test.startTest();
        values = multiSelectLookupCtrl.fetchFieldValues(type, fieldName, userInput, excludedItems);
        test.stopTest();
    }
    
    @isTest static void createSobjectTestSuccess(){
        String results = '';
        test.startTest();
        results = multiSelectLookupCtrl.createSobject(new Account(Name='t3$T'), 'SELECT ID FROM Account Where Id = ');
        test.stopTest();
    }
    
    @isTest static void createSobjectTestBadInsert(){
        String results = '';
        test.startTest();
        results = multiSelectLookupCtrl.createSobject(new Account(Name='Test'), 'SELECT ID FROM Account Where Id = ');
        test.stopTest();
    }
    
}