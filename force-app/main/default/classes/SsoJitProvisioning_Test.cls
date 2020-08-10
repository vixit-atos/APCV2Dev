@isTest
public class SsoJitProvisioning_Test {
    private class TestHelper {
        SsoJitProvisioning handler = new SsoJitProvisioning();
        User crmAdmin = [SELECT Name FROM User Where Name='CRM API Admin'];
        Account acc = null;
        Contact con = null;
        Map<String,String> attributes = new Map<String, String> { 
            'FirstName'=>'John',
            'LastName'=>'Smith',
            'Email'=>'some@email.com',
            'State'=>'OR', //UserPrimaryOrgCode cn is the dealercode
            'UserPrimaryOrgCode' => 'cn=0001,ou=Dealers,ou=organizations,o=freightliner,o=dcx.com',
            'UserApplicationRoles' => 'cn=aspquickquote_user,ou=people,o=freightliner,o=dcx.com^cn=testpermset,ou=people,o=freightliner,o=dcx.com'
        };
        
        public Account insertAccount(Account acc) {
            if (acc==null)
                acc = new Account(Dealer_Code__c='0001',Name='Test Account');
            try { insert acc; }
            catch(Exception e) { System.assert(false,'Failed to insert acc: '+e); }
            this.acc = acc;
            System.debug('Inserted Account '+acc);
            return acc;
        }

        public Contact insertContact(Contact con) {
            if (con==null) {
                con = new Contact(Email='some@email.com',FirstName='Test',LastName='Contact');
                if (this.acc!=null)
                    con.AccountId = this.acc.Id;
            }
            try { insert con; }
            catch(Exception e) { System.assert(false,'Failed to insert con: '+e); }
            this.con = con;
            System.debug('Inserted Contact '+con);
            return con;
        }
    }
    
    @testSetup
    static void setup() {
        System.debug('~~~~~~~~~~~~~~Running setup()~~~~~~~~~~~~~~');
        TestHelper th = new TestHelper();
        th.attributes.put('FirstName','Initial');
        th.attributes.put('LastName','User');
        th.attributes.put('Email','initial@user.com');
        th.attributes.put('UserPrimaryOrgCode','INIT');
        List<External_Role_Permission_Set_Assignment__mdt> permissionByRole = [SELECT Permission_Set__c,Role__c
                                                                        FROM External_Role_Permission_Set_Assignment__mdt];
        if (permissionByRole.size() > 1)
            th.attributes.put('UserApplicationRoles',permissionByRole[0].Role__c+','+permissionByRole[1].Role__c);

        Account acc = th.insertAccount(new Account(Dealer_Code__c='INIT',Name='Initial Account'));
        User u = th.handler.createUser(null,null,null,'INITIAL',th.attributes,null);
        
        th.insertContact(new Contact(Email='same@email.com',FirstName='Earlier',LastName='NoAccount'));
        acc = th.insertAccount(new Account(Dealer_Code__c='SAME',Name='Same Account'));
        th.insertContact(new Contact(AccountId=acc.Id,Email='same@email2.com',FirstName='Earlier',LastName='WithAccount'));
    }
    
    @isTest
    static void createAll() {
        System.debug('~~~~~~~~~~~~~~Running createAll()~~~~~~~~~~~~~~');
        TestHelper th = new TestHelper();
        System.runAs(th.crmAdmin) {
            User u = th.handler.createUser(null,null,null,'FEDID1',th.attributes,null);
            System.assertNotEquals(null,u,'User should not be null');
            User newUser = [SELECT ContactId,AccountId,LastName,FederationIdentifier,Email,TimeZoneSidKey FROM User WHERE Id=:u.Id];
            System.assertEquals(u.LastName, newUser.LastName, 'The new user\'s last name does not match');
            System.assertEquals(u.FederationIdentifier, newUser.FederationIdentifier, 'The new user\'s fedId does not match');
            System.assert(newUser.ContactId != null);
            System.assert(newUser.AccountId != null);
            Contact userContact = [SELECT LastName,Email,MailingState FROM Contact WHERE Id=:newUser.ContactId];
            System.assertEquals(userContact.LastName, newUser.LastName, 'New contact\'s last name does not match new user\'s');
            System.assertEquals(userContact.Email, newUser.Email, 'New contact\'s email does not match new user\'s');
            Account userAccount = [SELECT Name,Dealer_Code__c FROM Account WHERE Id=:newUser.AccountId];
            System.assertEquals(userAccount.Name, '0001 Account', 'New account does not have expected name');
            System.assertEquals(userAccount.Dealer_Code__c, '0001', 'New account does not have expected dealer code');
            System.assertEquals('OR', userContact.MailingState, 'New user does not live in the right state');   
            System.assertEquals('America/Los_Angeles', newUser.TimeZoneSidKey, 'New user does not have the right time zone');   
        }
    }

    @isTest
    static void existingAccount() {
        System.debug('~~~~~~~~~~~~~~Running existingAccount()~~~~~~~~~~~~~~');
        TestHelper th = new TestHelper();
        System.runAs(th.crmAdmin) {
            Account acc = th.insertAccount(null);
            User u = th.handler.createUser(null,null,null,'FEDID1',th.attributes,null);
            System.assertNotEquals(null,u,'User should not be null');
            User newUser = [SELECT ContactId,AccountId,LastName,FederationIdentifier,Email FROM User WHERE Id=:u.Id];
            System.assertNotEquals(null,newUser.ContactId,'User has a null contact');
            System.assertNotEquals(null,newUser.AccountId,'User has a null account');
            Contact userContact = [SELECT LastName, Email FROM Contact WHERE Id=:newUser.ContactId];
            System.assertEquals(userContact.LastName, newUser.LastName, 'New contact\'s last name does not match new user\'s');
            System.assertEquals(userContact.Email, newUser.Email, 'New contact\'s email does not match new user\'s');
            Account userAccount = [SELECT Name,Dealer_Code__c FROM Account WHERE Id=:newUser.AccountId];
            System.assertEquals(userAccount.Name, 'Test Account', 'New account does not have expected name');
            System.assertEquals(userAccount.Dealer_Code__c, '0001', 'New account does not have expected dealer code');
        }
    }


    @isTest
    static void existingAccountAndContact() {
        System.debug('~~~~~~~~~~~~~~Running existingAccountAndContact()~~~~~~~~~~~~~~');
        TestHelper th = new TestHelper();
        System.runAs(th.crmAdmin) {
            th.insertAccount(null);
            th.insertContact(null);
            User u = th.handler.createUser(null,null,null,'FEDID1',th.attributes,null);
            System.assertNotEquals(null,u,'User should not be null');
            User newUser = [SELECT ContactId,AccountId,LastName,FederationIdentifier,Email FROM User WHERE Id=:u.Id];
            System.assertNotEquals(null,newUser.ContactId,'User has a null contact');
            System.assertEquals(u.LastName, newUser.LastName, 'The new user\'s last name does not match');
            System.assertEquals(u.FederationIdentifier, newUser.FederationIdentifier, 'The new user\'s fedId does not match');
            System.assert(newUser.ContactId != null);
            System.assert(newUser.AccountId != null);
            Contact userContact = [SELECT LastName,Email FROM Contact WHERE Id=:newUser.ContactId];
            System.assertEquals('Contact', userContact.LastName, 'New contact\'s last name does not match new user\'s');
            System.assertEquals(newUser.Email, userContact.Email, 'New contact\'s email does not match new user\'s');
            Account userAccount = [SELECT Name,Dealer_Code__c FROM Account WHERE Id=:newUser.AccountId];
            System.assertEquals('Test Account', userAccount.Name, 'New account does not have expected name');
            System.assertEquals('0001', userAccount.Dealer_Code__c, 'New account does not have expected dealer code');
        }
    }


    @isTest
    static void permissionSets() {
        System.debug('~~~~~~~~~~~~~~Running permissionSets()~~~~~~~~~~~~~~');
        TestHelper th = new TestHelper();
        List<External_Role_Permission_Set_Assignment__mdt> permissionByRole = [SELECT Permission_Set__c,Role__c
                                                                        FROM External_Role_Permission_Set_Assignment__mdt];
        if (permissionByRole.size() < 3) {
            System.debug('PERMISSIONSETS TEST NOT RUNNING');
            System.debug('There are less than 3 entries in External_Role_Permission_Set_Assignment__mdt');
            System.debug('At least 3 entries are required to properly test permission sets');
            return; //allows the test to pass if there are less than 3 roles in mdt
        }
        System.runAs(th.crmAdmin) {
            User u = [SELECT Name FROM User WHERE Email='initial@user.com' AND FederationIdentifier='INITIAL'];
            th.attributes.put('UserApplicationRoles',permissionByRole[1].Role__c+','+permissionByRole[2].Role__c);//'PartnerCore_Permission_Set,testpermset');
            th.handler.updateUser(u.Id,null,null,null,'INITIAL',th.attributes,null);
            Integer psa = [SELECT count() FROM PermissionSetAssignment WHERE AssigneeId =: u.Id];
            System.assertEquals(3, psa); //add two initially, add one, remove one, and the profile one that can't be removed
            List<PermissionSetAssignment> psas = [SELECT PermissionSetId,AssigneeId FROM PermissionSetAssignment WHERE AssigneeId =: u.Id];
            System.debug('psas '+psas);
        }
    }

    @isTest
    static void multipleAccounts() { 
        System.debug('~~~~~~~~~~~~~~Running multipleAccounts()~~~~~~~~~~~~~~');
        TestHelper th = new TestHelper();
        System.runAs(th.crmAdmin) {
            th.insertAccount(null);
            th.insertAccount(null);
            User u = th.handler.createUser(null,null,null,'FEDID1',th.attributes,null);
            System.assertEquals(null,u,'User was created with multiple accounts');
        }
    }

    @isTest
    static void expectedContactAlreadyHasAUser() {
        System.debug('~~~~~~~~~~~~~~Running expectedContactAlreadyHasAUser()~~~~~~~~~~~~~~');
        TestHelper th = new TestHelper();
        System.runAs(th.crmAdmin) {
            th.insertContact(null);
            User u = th.handler.createUser(null,null,null,'FEDID1',th.attributes,null);
            User u2 = th.handler.createUser(null,null,null,'FEDID2',th.attributes,null);
            System.assert(u!=null,'First user should have been created properly');
            System.assertNotEquals(null,u2,'Second user should have been created even though the expected contact already belongs to someone');
        }
    }
        
    @isTest
    static void timezones() {
        System.debug('~~~~~~~~~~~~~~Running timezones()~~~~~~~~~~~~~~');
        //I tried running all 50 states and got error: Too many SOQL queries
        TestHelper th = new TestHelper();
        System.runAs(th.crmAdmin) {
            List<String> states = new List<String>{'CA','AZ','AL','CT','AK','HI'};
            List<String> sidKeys = new List<String>{'America/Los_Angeles','America/Denver','America/Chicago','America/New_York','America/Anchorage','Pacific/Honolulu'};
            Integer i = 0;
            for (String s : states) {
                th.attributes.put('State',s);
                th.attributes.put('Email',i+'user@email.com');
                User u = th.handler.createUser(null,null,null,'FEDID'+i,th.attributes,null);
                System.assertEquals(u.TimeZoneSidKey,sidKeys[i++]);
            }
        }
    }

    @isTest
    static void reactivateUser() {
        System.debug('~~~~~~~~~~~~~~Running reactivateUser()~~~~~~~~~~~~~~');
        TestHelper th = new TestHelper();
        System.runAs(th.crmAdmin) {
            User u = [SELECT Name FROM User WHERE Email='initial@user.com' AND FederationIdentifier='INITIAL'];
            u.IsActive = false;
            try { update u; }
            catch(Exception e) { System.assert(false,'Failed to deactivate user: '+e); }
            User createdUser = [SELECT IsActive FROM User WHERE FederationIdentifier='INITIAL'];
            System.assert(!createdUser.IsActive,'User is active when he should not be');
            th.handler.updateUser(u.Id,null,null,null,'INITIAL',th.attributes,null);
            //createdUser = [SELECT IsActive FROM User WHERE Id = :u.Id];
            List<User> reactivated  = [SELECT IsActive FROM User WHERE FederationIdentifier='INITIAL'];
            System.assertEquals(1,reactivated.size(),'Did not find one user. Found '+reactivated.size());
            System.assert(reactivated[0].IsActive,'User was not reactivated');
        }
    }

     @isTest
    static void failToCreateUsers() { //throw JitExceptions
        System.debug('~~~~~~~~~~~~~~Running failToCreateUsers()~~~~~~~~~~~~~~');
        TestHelper th = new TestHelper();
        System.runAs(th.crmAdmin) {
            User u = th.handler.createUser(null,null,null,'FEDID1', null, null);
            System.assertEquals(null,u,'attributes is null. User should have not have been created');
        
            th.attributes.put('Email','');
            u = th.handler.createUser(null,null,null,'FEDID1', th.attributes, null);
            System.assertEquals(null,u,'Email is null. User should have not have been created');
        
            th.attributes.put('Email','test@test.com');
            th.attributes.put('UserPrimaryOrgCode','');
            u = th.handler.createUser(null,null,null,'FEDID1', th.attributes, null);
            System.assertEquals(null,u,'Dealer Code is null. User should have not have been created');
            
            th.attributes.put('UserPrimaryOrgCode','cn=0008,');
            th.attributes.put('LastName','');
            u = th.handler.createUser(null,null,null,'FEDID1', th.attributes, null);
            System.assertEquals(null,u,'No LastName. User should have not have been created');

            th.attributes.put('LastName','Smith');
            u = th.handler.createUser(null,null,null,'FEDID1', th.attributes, null);
            System.assert(u!=null,'User should have actually been created this time');
            u = th.handler.createUser(null,null,null,'FEDID1', th.attributes, null);
            System.assertEquals(null,u,'User with this FEDID exists. User should have not have been created');        
        }
    }

    @isTest
    static void multipleContacts() {
        System.debug('~~~~~~~~~~~~~~Running multipleContacts()~~~~~~~~~~~~~~');
        TestHelper th = new TestHelper();
        System.runAs(th.crmAdmin) {
            th.insertContact(new Contact(Email='same@email.com',FirstName='Later',LastName='NoAccount'));
            th.attributes.put('Email','same@email.com');
            User u = th.handler.createUser(null,null,null,'FEDID1', th.attributes, null);
            Contact usersContact = [SELECT FirstName,LastName,LastModifiedDate FROM contact WHERE id=:u.contactid];
            System.assertEquals('Later', usersContact.firstname);

            Account acc = [SELECT Name FROM Account WHERE Dealer_Code__c='SAME'];
            th.insertContact(new Contact(AccountId=acc.Id,Email='same@email2.com',FirstName='Later',LastName='WithAccount'));
            th.attributes.put('Email','same@email2.com');
            th.attributes.put('UserPrimaryOrgCode','SAME');
            u = th.handler.createUser(null,null,null,'FEDID2', th.attributes, null);
            usersContact = [SELECT FirstName,LastName,LastModifiedDate FROM contact WHERE id=:u.contactid];
            System.assertEquals('Later', usersContact.firstname);
        }
    }
}