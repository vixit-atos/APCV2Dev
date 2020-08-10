@isTest public class sObjectServerControllerTest {
    @testSetup static void testSetup(){
        Account parent = new Account(Name='Test Account');
        insert parent;
        insert new Account(Name = 'Test Child Account', ParentId = parent.Id);
        insert new Contact(LastName = 'Test Contact', Phone = '0000000000', Email='test@gmtestail.com');
    }
    
    @isTest static void testGetDescribeFieldsSingleSObjectSingleField(){
        String requestName = 'Test';
        List<String> fields = new List<String>{'Name'};
        Map<String, List<String>> objectFieldMap = new Map<String, List<String>>();
        objectFieldMap.put('Account', fields);
        String results = '';
        
        test.startTest();
        results = sObjectServerController.getDescribeFieldResults(requestName, objectFieldMap);
        system.assertNotEquals(null, results);
        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(results);
        system.assertNotEquals(null, m.get('Account'));
        test.stopTest();
    }
    
    @isTest static void testGetDescribeFieldsSingleSObjectMultiField(){
        String requestName = 'Test';
        List<String> fields = new List<String>{'Name', 'Id'};
        Map<String, List<String>> objectFieldMap = new Map<String, List<String>>();
        objectFieldMap.put('Account', fields);
        String results = '';
        
        test.startTest();
        results = sObjectServerController.getDescribeFieldResults(requestName, objectFieldMap);
        system.assertNotEquals(null, results);
        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(results);
        system.assertNotEquals(null, m.get('Account'));
        test.stopTest();
    }
    
    @isTest static void testGetDescribeFieldsMultiSObjectSingleField(){
        String requestName = 'Test';
        List<String> fields = new List<String>{'Name'};
        Map<String, List<String>> objectFieldMap = new Map<String, List<String>>();
        objectFieldMap.put('Account', fields);
        objectFieldMap.put('Contact', fields);
        String results = '';
        
        test.startTest();
        results = sObjectServerController.getDescribeFieldResults(requestName, objectFieldMap);
        system.assertNotEquals(null, results);
        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(results);
        system.assertNotEquals(null, m.get('Account'));
        system.assertNotEquals(null, m.get('Contact'));
        test.stopTest();
    }
    
    @isTest static void testGetDescribeFieldsMultiSObjectMultiField(){
        String requestName = 'Test';
        List<String> fields = new List<String>{'Name', 'Id'};
        Map<String, List<String>> objectFieldMap = new Map<String, List<String>>();
        objectFieldMap.put('Account', fields);
        objectFieldMap.put('Contact', fields);
        String results = '';
        
        test.startTest();
        results = sObjectServerController.getDescribeFieldResults(requestName, objectFieldMap);
        system.assertNotEquals(null, results);
        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(results);
        system.assertNotEquals(null, m.get('Account'));
        system.assertNotEquals(null, m.get('Contact'));
        test.stopTest();
    }
    
    @isTest static void testGetDescribeFieldsSingleSObjectBadField(){
        String requestName = 'Test';
        List<String> fields = new List<String>{'fakeField'};
        Map<String, List<String>> objectFieldMap = new Map<String, List<String>>();
        objectFieldMap.put('Account', fields);
        objectFieldMap.put('Contact', fields);
        String results = '';
        
        test.startTest();
        results = sObjectServerController.getDescribeFieldResults(requestName, objectFieldMap);
        system.debug(results);
        system.assertEquals(null, results);
        checkLogCreation();
        test.stopTest();
    }
    
    @isTest static void testGetDescribeFieldsMultiSObjectBadField(){
        String requestName = 'Test';
        List<String> fields = new List<String>{'fakeField'};
        Map<String, List<String>> objectFieldMap = new Map<String, List<String>>();
        objectFieldMap.put('Account', fields);
        objectFieldMap.put('Contact', fields);
        String results = '';
        
        test.startTest();
        results = sObjectServerController.getDescribeFieldResults(requestName, objectFieldMap);
        system.debug(results);
        system.assertEquals(null, results);
        checkLogCreation();
        test.stopTest();
    }
    
    @isTest static void testGetDescribeFieldsBadSObject(){
        String requestName = 'Test';
        List<String> fields = new List<String>{'Name'};
        Map<String, List<String>> objectFieldMap = new Map<String, List<String>>();
        objectFieldMap.put('FakeObject', fields);
        String results = '';
        
        test.startTest();
        results = sObjectServerController.getDescribeFieldResults(requestName, objectFieldMap);
        system.debug(results);
        system.assertEquals(null, results);
        checkLogCreation();
        test.stopTest();
    }
    
    @isTest static void testBadDMLCallPerformDML(){
        String requestName = 'Test';
        List<sObject> so = new List<sObject>();
        so.add(new Account(Name='InsertedAccount'));
        Boolean results = true;
        
        test.startTest();
        results = sObjectServerController.performDML('Upsert', so, true, requestName);
        system.assertEquals(false, results);
        test.stopTest();
    }
    
    @isTest static void testInsertSingleObject(){
        String requestName = 'Test';
        List<sObject> so = new List<sObject>();
        so.add(new Account(Name='InsertedAccount'));
        String results = '';
        
        test.startTest();
        sObjectServerController.performDML('Insert', so, True, requestName);
        Account a = [SELECT Id FROM Account WHERE Name = 'InsertedAccount' LIMIT 1];
        system.assertNotEquals(null, a);
        test.stopTest();
    }
    
    @isTest static void testInsertMultiObject(){
        String requestName = 'Test';
        List<sObject> sos = new List<sObject>();
        for(Integer i = 0; i < 201; i++){
            sos.add(new Contact(LastName='Test' + i, Phone='0000000000'));
        }
        String results = '';
        
        test.startTest();
        sObjectServerController.performDML('Insert', sos, True, requestName);
        List<Contact> contacts = [SELECT Id FROM Contact];
        system.assertEquals(202, contacts.size());
        test.stopTest();
    }
    
    @isTest static void testInsertPartialListSuccess(){
        String requestName = 'Test';
        List<sObject> sos = new List<sObject>();
        for(Integer i = 0; i < 2; i++){
            if(i==0){
                sos.add(new Opportunity(Name='Test', StageName='New', CloseDate=Date.Today()));
            }else{
                sos.add(new Opportunity(Name='Test', CloseDate=Date.Today()));            
            }
        }
        String results = '';
        
        test.startTest();
        sObjectServerController.performDML('Insert', sos, false, requestName);
        List<Opportunity> opportunities = [SELECT Id FROM Opportunity];
        system.assertEquals(1, opportunities.size());
        test.stopTest();
    }
    
    @isTest static void testInsertPartialListRollback(){
        String requestName = 'Test';
        List<sObject> sos = new List<sObject>();
        for(Integer i = 0; i < 2; i++){
            if(i==0){
                sos.add(new Opportunity(Name='Test', StageName='New', CloseDate=Date.Today()));
            }else{
                sos.add(new Opportunity(Name='Test', CloseDate=Date.Today()));            
            }
        }
        String results = '';
        
        test.startTest();
        sObjectServerController.performDML('Insert', sos, true, requestName);
        List<Opportunity> opportunities = [SELECT Id FROM Opportunity];
        system.assertEquals(0, opportunities.size());
        test.stopTest();
    }
    
    @isTest static void testUpdateSingleObject(){
        String requestName = 'Test';
        List<sObject> so = new List<sObject>();
        Account a = [SELECT Id FROM Account LIMIT 1];
        a.Name = 'UpdatedName';
        so.add(a);
        
        test.startTest();
        sObjectServerController.performDML('Update', so, True, requestName);
        a = [SELECT Id FROM Account WHERE Name = 'UpdatedName' LIMIT 1];
        system.assertNotEquals(null, a);
        test.stopTest();
    }
    
    @isTest static void testUpdateMultiObject(){
        String requestName = 'Test';
        List<sObject> sos = new List<sObject>();
        List<Account> accounts = [SELECT Id FROM Account];
        for(Account a : accounts){
            a.AnnualRevenue = 1;
        }
        sos.addall(accounts);
        
        test.startTest();
        sObjectServerController.performDML('Update', sos, True, requestName);
        accounts = [SELECT Id FROM Account WHERE AnnualRevenue = 1];
        system.assertEquals(2, accounts.size());
        test.stopTest();
    }
    
    @isTest static void testUpdatePartialListSuccess(){
        String requestName = 'Test';
        List<sObject> sos = new List<sObject>();
        Boolean success = true;
        List<Account> accounts = [SELECT Id FROM Account];
        for(Account a : accounts){
            a.Name = 'Test Account';
        }
        
        sos.addall(accounts);
        
        test.startTest();
        sObjectServerController.performDML('Update', sos, False, requestName);
        accounts = [SELECT Id FROM Account WHERE Name = 'Test Account'];
        system.assertEquals(1, accounts.size());
        test.stopTest();    
    }
    
    @isTest static void testUpdatePartialListFail(){
        String requestName = 'Test';
        List<sObject> sos = new List<sObject>();
        List<Account> accounts = [SELECT Id FROM Account];
        accounts[0].id = '001000000000000000';
        sos.addall(accounts);
        
        test.startTest();
        sObjectServerController.performDML('Update', sos, True, requestName);
        accounts = [SELECT Id FROM Account WHERE Id = '001000000000000000'];
        system.assertEquals(0, accounts.size());
        checkLogCreation();
        test.stopTest();  
    }
    
    @isTest static void testDeleteSingleObject(){
        String requestName = 'Test';
        List<sObject> so = new List<sObject>();
        Account a = [SELECT Id, isDeleted FROM Account LIMIT 1];
        ID testId = a.id;
        so.add(a);
        
        test.startTest();
        sObjectServerController.performDML('Delete', so, True, requestName);
        List<Account> accounts = [SELECT Id FROM Account];
        for(Account acct : accounts){
            system.assertNotEquals(testId, acct.id);
        }
        test.stopTest();
    }
    
    @isTest static void testDeleteMultiObject(){
        String requestName = 'Test';
        List<sObject> sos = new List<sObject>();
        List<Account> accounts = [SELECT Id FROM Account];
        List<Account> emptyList = new List<Account>();
        sos.addall(accounts);
        
        test.startTest();
        sObjectServerController.performDML('Delete', sos, True, requestName);
        accounts = [SELECT Id FROM Account];
        system.assertEquals(emptyList, accounts);
        test.stopTest();
    }
	
    @isTest static void testDeleteNoAccess(){
        String requestName = 'Test';
        List<sObject> sos = new List<sObject>();
        List<Account> accounts = [SELECT Id FROM Account];
        Integer count = 0;
        for(Account a : accounts){
            if(count == 0){
                a.id = '001000000000000000';
                count++;
            }
        }
        sos.addall(accounts);
        List<Profile> profiles = [SELECT Id FROM Profile WHERE Name = 'DTNA - Core' LIMIT 1];
        Id profileId;
        for(Profile p : profiles){
            profileId = p.id;
        }
        User testUser = [SELECT Id FROM User where ProfileId =: profileId AND isActive = true LIMIT 1];
        system.runAs(testUser){
            test.startTest();
            sObjectServerController.performDML('Delete', sos, True, requestName);
            test.stopTest();            
        }
        system.assertEquals(2, accounts.size());
    }
    
    @isTest static void testDeletePartialListPermissionBlock(){
        String requestName = 'Test';
        List<sObject> sos = new List<sObject>();
        List<Account> accounts = [SELECT Id FROM Account];
        Integer count = 0;
        insert new Case(Subject='Test');
        List<Profile> profiles = [SELECT Id FROM Profile WHERE Name = 'DTNA - Core' LIMIT 1];
        Id profileId;
        for(Profile p : profiles){
            profileId = p.id;
        }
        User testUser = [SELECT Id FROM User where ProfileId =: profileId AND isActive = True LIMIT 1];
        
        system.runAs(testUser){
            insert new Case(Subject = 'User');
        }
        List<Case> cases = [SELECT Subject FROM Case];
        sos = [SELECT Subject FROM Case];
        system.runAs(testuser){
            test.startTest();
            sObjectServerController.performDML('Delete', sos, False, requestName);
            test.stopTest(); 
        }
        cases = [SELECT Id FROM Case];
        system.assertEquals(1, cases.size());

    }    
    
    @isTest static void testSOQLQuerySuccess(){
        String requestName = 'Test';
        String query = 'SELECT Id FROM Account WHERE Id != NULL LIMIT 1';
        List<List<sObject>> testList;
        
        test.startTest();
        
        testList = sObjectServerController.performQuery(requestName, query);
        system.assertNotEquals(NULL, testList);
        system.assertEquals(1, testList.size());
        
        test.stopTest();
    }
    
    @isTest static void testSOQLQueryFail(){
        String requestName = 'Test';
        String failQuery = 'SELECT failField FROM fakeObject WHERE failField != NULL LIMIT 1';
        List<List<sObject>> testList;
        
        test.startTest();
        
        testList = sObjectServerController.performQuery(requestName, failQuery);
        system.assertEquals(NULL, testList);
        checkLogCreation();
        
        test.stopTest();
    }
    
    @isTest static void testSOSLQuerySuccess(){
        String requestName = 'Test';
        String query = 'FIND \'' + requestName + '\' IN ALL FIELDS RETURNING Account(Id, Name), Contact';
        List<List<sObject>> testList;
        
        test.startTest();
        testList = sObjectServerController.performQuery(requestName, query);
        system.assertNotEquals(NULL, testList);
        system.assertEquals(2, testList.size());
        
        test.stopTest();
    }
    
    @isTest static void testSOSLQuerySubstringFail(){
        String requestName = 'Test';
        String failQuery = 'F!ND \'' + requestName + '\' IN ALL FIELDS RETURNING Account(Id, Name), Contact';
        List<List<sObject>> testList;
        
        test.startTest();
        
        testList = sObjectServerController.performQuery(requestName, failQuery);
        system.assertEquals(NULL, testList);
        checkLogCreation();
        test.stopTest();
    }
    
    @isTest static void testSOSLQueryFail(){
        String requestName = 'Test';
        String failQuery = 'Find failField IN ALL FIELDS RETURNING fakeObject(Id, Name)';
        List<List<sObject>> testList;
        
        test.startTest();
        
        testList = sObjectServerController.performQuery(requestName, failQuery);
        system.assertEquals(NULL, testList);
        checkLogCreation();
        test.stopTest();
    }
    
    @isTest static void testGetSObjectTypeSuccess(){
        String requestName = 'Test';
        Account a = [SELECT Id FROM Account LIMIT 1];
        String results = '';
        
        test.startTest();
        results = sObjectServerController.getSObjectTypeByRecordId(requestName, a.Id);
        system.assertEquals('Account', results);
    }
    
    @isTest static void testGetSObjectTypeBadId(){
        String requestName = 'Test';
        String failId = '000000000000000000';
        String results = '';
        
        test.startTest();
        
        results = sObjectServerController.getSObjectTypeByRecordId(requestName, failID);
        system.assertEquals(null, results);
        checkLogCreation();
        
        test.stopTest();
    }
    
    private static void checkLogCreation(){
        List<Log__c> logList = [SELECT Id FROM Log__c];
        system.assertNotEquals(NULL, logList);
        system.assertNotEquals(0, logList.size());
        delete logList;
    }
}