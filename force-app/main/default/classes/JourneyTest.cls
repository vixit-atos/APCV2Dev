@isTest
public class JourneyTest {
    @testSetup
    static void setup() {
        System.debug('~~~~~~~~~~~~~~Running setup()~~~~~~~~~~~~~~');
        Id recordType = [SELECT ID FROM RecordType WHERE SObjectType = 'Opportunity' and Name = 'Customer Focused Request' LIMIT 1].Id;
        Opportunity opp = new Opportunity(Name='opp name', StageName='Submitted', CloseDate=System.today(), RecordTypeId=recordType);
        insert opp;
    }

    @isTest
    public static void firstTest() {
        System.debug('~~~~~~~~~~~~~~Running firstTest()~~~~~~~~~~~~~~');
        Opportunity opp = [SELECT Name FROM Opportunity WHERE Name = 'opp name'];
        JourneyController.getInitData(opp.Id, 'CRT', 'StageName');
    }
}