@isTest public class GasUserProvisioningTest {
    @isTest static void createUserTest(){
        List<SSO_JIT_Provisioning__mdt> gasMetadata = [SELECT Id, Default_Timezone__c, EmailKey__c, LanguageKey__c, Login_Profile__c,User_Name_Suffix__c FROM SSO_JIT_Provisioning__mdt
                                                   WHERE Label = 'GAS' LIMIT 1];
        List<Profile> profile = [SELECT Id FROM Profile WHERE Name =: gasMetadata[0].Login_Profile__c LIMIT 1];
        User currentUser1 = new User();
        currentUser1.LastName = 'TestGASLN';
        currentUser1.FirstName = 'TestGasFN';
        currentUser1.Email = 'john@smith.com';
        currentUser1.phone = '000-000-0000';
        currentUser1.LocaleSidKey = 'en_US';
        currentUser1.EmailEncodingKey = 'ISO-8859-1';
        currentUser1.FederationIdentifier = 'tester1';
        currentUser1.ProfileId = profile[0].Id;
        currentUser1.DTNA_Department__c = 'ITC/NS1';
        currentUser1.isActive = true;
        currentUser1.UserName = currentUser1.Email + '.dtna.' + gasMetadata[0].User_Name_Suffix__c + '.' + currentUser1.FederationIdentifier;
        currentUser1.Alias = (currentUser1.FirstName != null ? currentUser1.FirstName.substring(0,1) : '') + currentUser1.LastName.substring(0, Math.min(currentUser1.LastName.length(), 4));
        currentUser1.TimeZoneSidKey = 'America/Los_Angeles';
        currentUser1.LanguageLocaleKey = 'en_US';
        insert currentUser1;
        User currentUser2 = new User();
        currentUser2.LastName = 'TestGASLN';
        currentUser2.FirstName = 'TestGasFN';
        currentUser2.Email = 'john@smith.com';
        currentUser2.phone = '000-000-0000';
        currentUser2.LocaleSidKey = 'en_US';
        currentUser2.EmailEncodingKey = 'ISO-8859-1';
        currentUser2.FederationIdentifier = 'tester10';
        currentUser2.ProfileId = profile[0].Id;
        currentUser2.DTNA_Department__c = 'ITC/NS';
        currentUser2.Level_2__c = true;
        currentUser2.isActive = true;
        currentUser2.UserName = currentUser2.Email + '.dtna.' + gasMetadata[0].User_Name_Suffix__c + '.' + currentUser2.FederationIdentifier;
        currentUser2.Alias = (currentUser2.FirstName != null ? currentUser2.FirstName.substring(0,1) : '') + currentUser2.LastName.substring(0, Math.min(currentUser2.LastName.length(), 4));
        currentUser2.TimeZoneSidKey = 'America/Los_Angeles';
        currentUser2.LanguageLocaleKey = 'en_US';
        insert currentUser2;
        Map<String,String> attributes1 = new Map<String, String> { 
            'givenName'=>'John',
            'sn'=>'Smith',
            'mail'=>'john@smith.com',
            'dcxPostalAddress'=>'Portland, OR', 
            'l' => 'Portland',
            'uid' => 'Tester1',
            'dcxDepartmentAbbr' => 'ITC/NS1'   
        };
        Map<String,String> attributes2 = new Map<String, String> { 
            'givenName'=>'John',
            'sn'=>'Smith',
            'mail'=>'john@smith.com',
            'dcxPostalAddress'=>'Portland, AK', 
            'l' => 'Portland',
            'uid' => 'Tester2'
        };
        Map<String,String> attributes3 = new Map<String, String> { 
            'givenName'=>'John',
            'sn'=>'Smith',
            'mail'=>'john@smith.com',
            'dcxPostalAddress'=>'Portland, HI', 
            'l' => 'Portland',
            'uid' => 'Tester3'
        };
        Map<String,String> attributes4 = new Map<String, String> { 
            'givenName'=>'John',
            'sn'=>'Smith',
            'mail'=>'john@smith.com',
            'dcxPostalAddress'=>'Portland, AZ', 
            'l' => 'Portland',
            'uid' => 'Tester4'
        };
        Map<String,String> attributes5 = new Map<String, String> { 
            'givenName'=>'John',
            'sn'=>'Smith',
            'mail'=>'john@smith.com',
            'dcxPostalAddress'=>'Portland, CT', 
            'l' => 'Portland',
            'uid' => 'Tester5'
        };
        Map<String,String> attributes6 = new Map<String, String> { 
            'givenName'=>'John',
            'sn'=>'Smith',
            'mail'=>'john@smith.com',
            'dcxPostalAddress'=>'Portland, AL', 
            'l' => 'Portland',
            'uid' => 'Tester6'
        }; 
        Map<String,String> attributes7 = new Map<String, String> { 
            'givenName'=>'John',
            'sn'=>'Smith',
            'mail'=>'john@smith.com',
            'dcxPostalAddress'=>'Portland, XX',
            'l' => 'Portland',
            'uid' => 'Tester7',
            'dcxSupervisor' => 'tester1' 
        };
        GasUserProvisioning gas = new GasUserProvisioning();
        User currentUser = new user();
        currentUser = gas.createUser(null, null, null, 'Tester1', attributes1, null); 
        testUser(createTestUser(attributes1), currentUser);
        currentUser = gas.createUser(null, null, null, 'Tester2', attributes2, null); 
        testUser(createTestUser(attributes2), currentUser);
        currentUser = gas.createUser(null, null, null, 'Tester3', attributes3, null);
        testUser(createTestUser(attributes3), currentUser);
        currentUser = gas.createUser(null, null, null, 'Tester4', attributes4, null);
        testUser(createTestUser(attributes4), currentUser);
        currentUser = gas.createUser(null, null, null, 'Tester5', attributes5, null);
        testUser(createTestUser(attributes5), currentUser);
        currentUser = gas.createUser(null, null, null, 'Tester6', attributes6, null);
        testUser(createTestUser(attributes6), currentUser);
        currentUser = gas.createUser(null, null, null, 'Tester7', attributes7, null);
        testUser(createTestUser(attributes7), currentUser);
    }
    
    @isTest static void createUserExceptionTest(){
        GasUserProvisioning gas = new GasUserProvisioning();
        User currentUser = gas.createUser(null, null, null, 'Tester', null, null); 
        system.assertEquals(null, currentUser);
    }
    
    @isTest static void updateUserExceptionTest(){
        GasUserProvisioning gas = new GasUserProvisioning();
        Map<Id, User> beforeUpdate = new Map<Id, User>([SELECT LastModifiedDate FROM User]);
        gas.updateUser(null, null, null, null, 'Tester', null, null); 
        Map<Id, User> afterUpdate = new Map<id, User>([SELECT LastModifiedDate FROM User]);
        for(Id userId : beforeUpdate.keySet()){
            system.assertEquals(beforeUpdate.get(userId).LastModifiedDate, afterUpdate.get(userId).LastModifiedDate);
        }
    }
    
    @isTest static void createUserNameChangeTest(){
        Map<String,String> attributes1 = new Map<String, String> { 
            'givenName'=>'John',
            'sn'=>'Smith',
            'mail'=>'john@smith.com',
            'dcxPostalAddress'=>'Portland, OR', 
            'l' => 'Portland',
            'uid' => 'Tester1'
        };
        Map<String,String> attributes2 = new Map<String, String> { 
            'givenName'=>'Hank',
            'sn'=>'Smith',
            'mail'=>'john@smith.com',
            'dcxPostalAddress'=>'Portland, OR', 
            'l' => 'Portland',
            'uid' => 'Tester1'
        };
        GasUserProvisioning gas = new GasUserProvisioning();
        User createdUser = gas.createUser(null, null, null, 'Tester1', attributes1, null); 
        gas.updateUser(createdUser.Id, null, null, null, 'Tester1', attributes1, null); 
        List<User> afterUpdate = [SELECT Id, FirstName FROM User where Id =: createdUser.id LIMIT 1];
        system.assertEquals(createdUser.Firstname, afterUpdate[0].FirstName);
    }
    
    @isTest static void updateUserTest(){
        List<SSO_JIT_Provisioning__mdt> gasMetadata = [SELECT Id, Default_Timezone__c, EmailKey__c, LanguageKey__c, Login_Profile__c,User_Name_Suffix__c FROM SSO_JIT_Provisioning__mdt
                                                   WHERE Label = 'GAS' LIMIT 1];
        List<Profile> profile = [SELECT Id FROM Profile WHERE Name =: gasMetadata[0].Login_Profile__c LIMIT 1];
        User currentUser = new User();
        currentUser.LastName = 'TestGASLN';
        currentUser.FirstName = 'TestGasFN';
        currentUser.Email = 'john@smith.com';
        currentUser.phone = '000-000-0000';
        currentUser.LocaleSidKey = 'en_US';
        currentUser.EmailEncodingKey = 'ISO-8859-1';
        currentUser.FederationIdentifier = 'tester1';
        currentUser.ProfileId = profile[0].Id;
        currentUser.isActive = true;
        currentUser.UserName = currentUser.Email + '.dtna.' + gasMetadata[0].User_Name_Suffix__c + '.' + currentUser.FederationIdentifier;
        currentUser.Alias = (currentUser.FirstName != null ? currentUser.FirstName.substring(0,1) : '') + currentUser.LastName.substring(0, Math.min(currentUser.LastName.length(), 4));
        currentUser.TimeZoneSidKey = 'America/Los_Angeles';
        currentUser.LanguageLocaleKey = 'en_US';
        insert currentUser;
        
        Map<String,String> attributes = new Map<String, String> { 
            'givenName'=>'John',
            'sn'=>'Smith',
            'mail'=>'john@smith.com',
            'dcxPostalAddress'=>'Portland, OR', 
            'l' => 'Portland',
            'uid' => 'tester1'
        };
        GasUserProvisioning gas = new GasUserProvisioning();
        gas.updateUser(currentUser.Id, null, null, null, 'Tester1', attributes, null); 
        currentUser = [Select Id, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, Email, FederationIdentifier, LastName, FirstName, TimeZoneSidKey, UserName
                       FROM User 
                       WHERE Id =: currentUser.Id
                       LIMIT 1];
        testUser(createTestUser(attributes), currentUser);
    }
    
    private static void testUser(User expectedUser, User actualUser){
        system.assertEquals(expectedUser.FirstName, actualUser.FirstName);
        system.assertEquals(expectedUser.LastName, actualuser.LastName);
        system.assertEquals(expectedUser.email, actualuser.email);
        system.assertEquals(expectedUser.FederationIdentifier, actualUser.FederationIdentifier);
        system.assertEquals(expectedUser.ProfileId, actualUser.ProfileId);
        system.assertEquals(expectedUser.UserName, actualUser.UserName);
        system.assertEquals(expectedUser.LocaleSidKey, actualUser.LocaleSidKey);
        system.assertEquals(expectedUser.EmailEncodingKey, actualUser.EmailEncodingKey);
        system.assertEquals(expectedUser.LanguageLocaleKey, actualUser.LanguageLocaleKey);
    }
    
    private static User createTestUser(Map<String,String> attributes){
        List<SSO_JIT_Provisioning__mdt> gasMetadata = [SELECT Id, Default_Timezone__c, EmailKey__c, LanguageKey__c, Login_Profile__c,User_Name_Suffix__c FROM SSO_JIT_Provisioning__mdt
                                                   WHERE Label = 'GAS' LIMIT 1];
        List<Profile> p = [SELECT Id FROM Profile Where Name =: gasMetadata[0].Login_Profile__c Limit 1];
        User u = new user(
        	FirstName = attributes.get('givenName'),
            LastName = attributes.get('sn'),
            Email = attributes.get('mail'),
            federationIdentifier = attributes.get('uid'),
            profileId = p[0].id,
            LocaleSIdKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US'
        );
        u.UserName = u.Email + '.dtna.' + gasMetadata[0].User_Name_Suffix__c + '.' + u.FederationIdentifier;
        system.debug(u);
        return u;
       
    }
}