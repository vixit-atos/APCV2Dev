@isTest
public class CFR_Form_Test {
    @testSetup
    static void setup() {
        System.debug('~~~~~~~~~~~~~~Running setup()~~~~~~~~~~~~~~');
        Id cfrType = [SELECT ID FROM RecordType WHERE SObjectType = 'Opportunity' and Name = 'Customer Focused Request' LIMIT 1].Id;
        insert new Opportunity(Name='xx-1001: Existing CFR', StageName='Submitted', CloseDate=System.today(),
                                RecordTypeId=cfrType, Submitted_Date__c=Date.Today());
        Opportunity opp = new Opportunity(Name='opp name', StageName='Submitted', CloseDate=System.today(), RecordTypeId=cfrType);
        Account acc = new Account(name='acc name');
        insert opp;
        insert acc;
        insert new Opportunity_Account__c(Opportunity__c=opp.Id, Account__c=acc.Id);
        insert new Pricebook2(Name='CFR Models Price Book', IsActive=true);
        insert new Note(Title='title', Body='body', ParentId=opp.Id);
        insert new ContentVersion(Title='Test File', PathOnClient='Penguins.jpg', //doing this inserts a ContentDocument.
                        VersionData=Blob.valueOf('Test Content'), IsMajorVersion = true); //can't insert one directly
    }
    
    @isTest
    static void testGetInitData() {
        System.debug('~~~~~~~~~~~~~~Running getInitData()~~~~~~~~~~~~~~');
        Opportunity opp = [SELECT Name FROM Opportunity WHERE Name = 'opp name'];
        String response = CFR_Form_Controller.getInitData(opp.Id);
        CFR_Form_Controller.InitData res = (CFR_Form_Controller.InitData) JSON.deserialize(response, CFR_Form_Controller.InitData.class);
        System.debug(res);
    }

    @isTest
    static void testSubmitRequest() {
        System.debug('~~~~~~~~~~~~~~Running submitRequest()~~~~~~~~~~~~~~');
        Opportunity opp = [SELECT Name,StageName,RecordTypeId FROM Opportunity WHERE Name = 'opp name'];
        List<Note> notesToUpsert = new List<Note>{ new Note(Title='To Upsert', Body='body', ParentId=opp.Id) };
        List<Note> notesToDelete = [SELECT Id FROM Note WHERE ParentId = :opp.Id];
        Account acc = [SELECT Id FROM Account WHERE Name='acc name'];
        Opportunity_Account__c oppAcc = new Opportunity_Account__c(Opportunity__c=opp.Id, Account__c=acc.Id);
        List<Opportunity_Account__c> newOppAccs = new List<Opportunity_Account__c>{ oppAcc };
        List<Opportunity_Account__c> oppAccsToDelete = [SELECT Id FROM Opportunity_Account__c WHERE Opportunity__c = :opp.Id];
        CFR_Form_Controller.submitRequest(opp, notesToUpsert, notesToDelete, newOppAccs, oppAccsToDelete, 'cfrName');
    }

    @isTest
    static void deleteThings() {
        System.debug('~~~~~~~~~~~~~~Running deleteThings()~~~~~~~~~~~~~~');
        Opportunity opp = [SELECT Name FROM Opportunity WHERE Name = 'opp name'];
        CFR_Form_Controller.deleteCFR(opp.Id);

        List<ContentDocument> files = [SELECT Id FROM ContentDocument];
        CFR_Form_Controller.deleteFile(files[0].Id);
    }

    @isTest
    static void allMethodsNulls() {
        System.debug('~~~~~~~~~~~~~~Running allMethodsNulls()~~~~~~~~~~~~~~');
        CFR_Form_Controller.getInitData(null);
        CFR_Form_Controller.submitRequest(null, null, null, null, null, null);
        CFR_Form_Controller.deleteCFR(null);
        CFR_Form_Controller.deleteFile(null);
        CFR_Form_Controller.getName(null, null);
    }

    static Opportunity getNameUpsertAssert(Opportunity opp, String cfrName, String expectedName) {
        opp.name = CFR_Form_Controller.getName(opp, cfrName);
        System.debug(opp.name);
        System.assertEquals(expectedName, opp.name);
        upsert opp;
        return opp;
    }
    
    @isTest
    static void getNameNumbering() {
        System.debug('~~~~~~~~~~~~~~Running getNameNumbering()~~~~~~~~~~~~~~');
        delete [SELECT Id FROM Opportunity];
        Id cfrType = [SELECT Id FROM RecordType WHERE SObjectType = 'Opportunity' and Name = 'Customer Focused Request' LIMIT 1].Id;
        Opportunity opp;

        opp = new Opportunity(StageName='Submitted', Submitted_Date__c=Date.Today(), CloseDate=System.today(), RecordTypeId=cfrType);
        getNameUpsertAssert(opp, 'some name', 'xx-0001: some name');

        opp = new Opportunity(StageName='Submitted', Submitted_Date__c=Date.Today(), CloseDate=System.today(), RecordTypeId=cfrType);
        getNameUpsertAssert(opp, 'another name', 'xx-0002: another name');

        insert new Opportunity(Name='xx-8888: submitted last year', StageName='Submitted', Submitted_Date__c=Date.Today()-366, CloseDate= System.today()-366, RecordTypeId=cfrType);
        insert new Opportunity(Name='xx-7777: big number', StageName='Submitted', Submitted_Date__c=Date.Today(), CloseDate= System.today(), RecordTypeId=cfrType);
        opp = new Opportunity(StageName='Submitted', Submitted_Date__c=Date.Today(), CloseDate=System.today(), RecordTypeId=cfrType);
        getNameUpsertAssert(opp, 'cfr 4', 'xx-7778: cfr 4'); //8888 is from last year so 7777 is the biggest CFR number considered
        opp.StageName = 'New';
        getNameUpsertAssert(opp, 'new again', 'xx-xxxx: new again'); //becoming new goes back to xx-xxxx
        // System.debug(Limits.getQueries());
    }
    
    @isTest
    static void getNameUnexpectedUsage() {
        System.debug('~~~~~~~~~~~~~~Running getNameUnexpectedUsage()~~~~~~~~~~~~~~');
        delete [SELECT Id FROM Opportunity];
        Id cfrType = [SELECT Id FROM RecordType WHERE SObjectType = 'Opportunity' and Name = 'Customer Focused Request' LIMIT 1].Id;
        Opportunity opp;

        opp = new Opportunity(StageName='New', Submitted_Date__c=Date.Today(), CloseDate=System.today(), RecordTypeId=cfrType);
        getNameUpsertAssert(opp, 'new cfr with submitted_date', 'xx-xxxx: new cfr with submitted_date');

        insert new Opportunity(Name='no number', StageName='Submitted', Submitted_Date__c=Date.Today(), CloseDate= System.today(), RecordTypeId=cfrType);
        insert new Opportunity(Name='xx-9000 no colon', StageName='Submitted', Submitted_Date__c=Date.Today(), CloseDate= System.today(), RecordTypeId=cfrType);
        opp = new Opportunity(StageName='Submitted', Submitted_Date__c=Date.Today(), CloseDate=System.today(), RecordTypeId=cfrType);
        getNameUpsertAssert(opp, 'ignores malformed entries', 'xx-0001: ignores malformed entries');
        opp = new Opportunity(StageName='Submitted', Submitted_Date__c=Date.Today(), CloseDate=System.today(), RecordTypeId=cfrType);
        getNameUpsertAssert(opp, 'xx-7777: passing prefix to cfrName', 'xx-0002: xx-7777: passing prefix to cfrName');
        opp = new Opportunity(StageName='Submitted', Submitted_Date__c=Date.Today(), CloseDate=System.today(), RecordTypeId=cfrType);
        getNameUpsertAssert(opp, 'ignores number in the middle of the last one', 'xx-0003: ignores number in the middle of the last one');

        insert new Opportunity(Name='xx-987654: more than 4 digits', StageName='Submitted', Submitted_Date__c=Date.Today(), CloseDate= System.today(), RecordTypeId=cfrType);
        opp = new Opportunity(StageName='Submitted', Submitted_Date__c=Date.Today(), CloseDate=System.today(), RecordTypeId=cfrType);
        getNameUpsertAssert(opp, 'works with big numbers', 'xx-987655: works with big numbers');

        // getName returns null when given blank values
        System.assertEquals(null, CFR_Form_Controller.getName(null, null));
        System.assertEquals(null, CFR_Form_Controller.getName(opp, null));
        System.assertEquals(null, CFR_Form_Controller.getName(opp, ''));
        System.assertEquals(null, CFR_Form_Controller.getName(null, 'cfr name'));
        System.debug(Limits.getQueries());
    }
}