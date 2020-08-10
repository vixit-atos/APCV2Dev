@isTest
public class CFR_Models_Impacted_Test {

    @testSetup
    static void setup() {
        System.debug('~~~~~~~~~~~~~~Running setup()~~~~~~~~~~~~~~');
        List<String> names = new List<String>{ 'P3 113', '108SD' };
        List<String> families = new List<String>{ 'Freightliner', 'Freightliner' };
        List<String> cabTypes = new List<String>{ 'Day;Crew', 'DAY;XTND' };
        List<Integer> prices = new List<Integer>{ 100, 200 };
        String result = CFR_Models_Impacted_Controller.upsertProducts(names, families, cabTypes, prices);
        System.assertEquals('Success', result, result);
        List<Product2> prods = [SELECT Name,Family,Cab_Types__c FROM Product2];
        System.assertEquals(2, prods.size());
        System.debug(prods);

        Id recordType = [SELECT ID FROM RecordType WHERE SObjectType = 'Opportunity' and Name = 'Customer Focused Request' LIMIT 1].Id;
        Opportunity opp = new Opportunity(Name='opp name', StageName='Submitted', CloseDate=System.today(), RecordTypeId=recordType);
        insert opp;
        Id cfrPbId = [SELECT Id FROM Pricebook2 WHERE Name='CFR Models Price Book'].Id;
        List<PricebookEntry> pbes = [SELECT Product2.Name,UnitPrice FROM PricebookEntry
                                    WHERE Name IN :names AND IsActive = TRUE AND Pricebook2Id = :cfrPbId];
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId=opp.Id, PriceBookEntryId=pbes[0].Id, Product2Id=prods[0].Id,
                                                            Quantity=100, UnitPrice=1, Cab_Type__c='Day');
        OpportunityLineItem oli2 = new OpportunityLineItem(OpportunityId=opp.Id, PriceBookEntryId=pbes[1].Id, Product2Id=prods[1].Id,
                                                            Quantity=200, UnitPrice=1, Cab_Type__c='XTND');
        insert new List<OpportunityLineItem>{ oli, oli2 };
    }
    // @testSetup
    // static void setup() {
    //     System.debug('~~~~~~~~~~~~~~Running setup()~~~~~~~~~~~~~~');
    //     //everything required for OpportunityLineItem
    //     Id recordType = [SELECT ID FROM RecordType WHERE SObjectType = 'Opportunity' and Name = 'Customer Focused Request' LIMIT 1].Id;
    //     Opportunity opp = new Opportunity(Name='opp name', StageName='Submitted', CloseDate=System.today(), RecordTypeId=recordType);
    //     Id StandardPbId = Test.getStandardPricebookId();
    //     insert new Pricebook2()
    //     Pricebook2 cfrPb = new Pricebook2(Name='CFR Models Price Book', IsActive=true);
    //     Product2 prod = new Product2(Name='P3 113', Family='Freightliner', Cab_Types__c='Day;Crew');
    //     Product2 prod2 = new Product2(Name='108SD', Family='Freightliner', Cab_Types__c='Day;XTND');
    //     insert opp;
    //     insert cfrPb;
    //     insert new List<Product2>{ prod, prod2 };
    //     List<PricebookEntry> pbes = new List<PricebookEntry> {
    //         new PricebookEntry(Product2Id=prod.Id, Pricebook2Id=StandardPbId, UnitPrice=1, UseStandardPrice=false, IsActive=true),
    //         new PricebookEntry(Product2Id=prod.Id, Pricebook2Id=cfrPb.Id, UnitPrice=1, UseStandardPrice=false, IsActive=true),
    //         new PricebookEntry(Product2Id=prod2.Id, Pricebook2Id=StandardPbId, UnitPrice=1, UseStandardPrice=false, IsActive=true),
    //         new PricebookEntry(Product2Id=prod2.Id, Pricebook2Id=cfrPb.Id, UnitPrice=1, UseStandardPrice=false, IsActive=true)
    //     };
    //     insert pbes;
    //     OpportunityLineItem oli = new OpportunityLineItem(OpportunityId=opp.Id, PriceBookEntryId=pbes[1].Id, Product2Id=prod.Id,
    //                     Quantity=100, UnitPrice=1, Cab_Type__c='Day');
    //     OpportunityLineItem oli2 = new OpportunityLineItem(OpportunityId=opp.Id, PriceBookEntryId=pbes[1].Id, Product2Id=prod2.Id,
    //                     Quantity=200, UnitPrice=1, Cab_Type__c='XTND');
    //     insert new List<OpportunityLineItem>{ oli, oli2 };
    // }

    @isTest
    static void testGetModels() {
        System.debug('~~~~~~~~~~~~~~Running testGetModels()~~~~~~~~~~~~~~');
        Opportunity opp = [SELECT Name FROM Opportunity WHERE Name = 'opp name'];
        CFR_Models_Impacted_Controller.getModels(opp.Id);
    }

    @isTest
    static void testUpdateModels() {
        System.debug('~~~~~~~~~~~~~~Running testUpdateModels()~~~~~~~~~~~~~~');
        List<Product2> products = [SELECT Name, Family FROM Product2];
        Map<String, Map<String,String>> models = new Map<String, Map<String,String>> {
            (String) products[0].Id => new Map<String,String> { 'Day' => '100', 'Crew' => '300' }
        };
        Opportunity opp = [SELECT Name FROM Opportunity WHERE Name = 'opp name'];
        CFR_Models_Impacted_Controller.updateModels(models, opp.Id);
    }

    @isTest
    static void testDeleteProducts() {
        System.debug('~~~~~~~~~~~~~~Running testDeleteProducts()~~~~~~~~~~~~~~');
        List<String> names = new List<String>{ 'P3 113' };
        String result = CFR_Models_Impacted_Controller.deleteProducts(names);
        System.assertEquals('Success', result, result);
        result = CFR_Models_Impacted_Controller.deleteProducts(null);
        System.assertNotEquals('Success', result, result);
    }

    private static void testUpsertProducts() {
        System.debug('~~~~~~~~~~~~~~Running upsertProducts()~~~~~~~~~~~~~~');
        // String upsertProducts(List<String> names, List<String> families, List<String> cabTypes, List<Integer> prices)
        List<String> names = new List<String>{ 'P3 113' };
        List<String> families = new List<String>{ 'Freightliner' };
        List<String> cabTypes = new List<String>{ 'DAY' };
        List<Integer> prices = new List<Integer>{ 500 };
        String result = CFR_Models_Impacted_Controller.upsertProducts(names, families, cabTypes, prices);
        System.assertEquals('Success', result, result);
        List<Product2> prods = [SELECT Name,Family,Cab_Types__c FROM Product2 WHERE Name = 'Model Name'];
        // System.assertEquals(1, prods.size());
        // Product2 p = prods[0];
        // System.assertEquals('Model Name', p.Name);
        // System.assertEquals('Freightliner', p.Family);
        // System.assertEquals('DAY;XTND', p.Cab_Types__c);
    }



    @isTest
    static void throwExceptions() {
        System.debug('~~~~~~~~~~~~~~Running throwExceptions()~~~~~~~~~~~~~~');
        List<Product2> products = [SELECT Name, Family FROM Product2];
        Map<String, Map<String,String>> models = new Map<String, Map<String,String>> {
            (String) products[0].Id => new Map<String,String> { 'Day' => 'purple' },
            'not a valid Id' => new Map<String,String> { 'Day' => '100' }
        };
        Opportunity opp = [SELECT Name FROM Opportunity WHERE Name = 'opp name'];
        CFR_Models_Impacted_Controller.updateModels(models, opp.Id);
    }
}