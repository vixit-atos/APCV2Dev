@isTest public class PCSDriverTest {
    @testSetup static void setup(){
        insert new ConcessionRCURequest__c(Name = 'Endpoint');
        insert new EventInviteURLPrefix__c(TWSResidualPrefix__c = '.com/apex', TWSwsPrefix__c = '.com/apex');
    }
    @isTest static void testGenericDriver(){
        test.StartTest();
        Test.testSandboxPostCopyScript(
            new PCSGenericDriver(), UserInfo.getOrganizationId(),
            	UserInfo.getOrganizationID(), UserInfo.getOrganizationName());
        test.Stoptest();
    }
}