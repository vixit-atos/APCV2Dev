@isTest public class PCSConfigUpdateTest {
    
    @testSetup static void setup(){
        insert new ConcessionRCURequest__c(Name = 'Endpoint');
		insert new ConcessionRCURequest__c(Name = 'clientCertName_x');
        insert new EventInviteURLPrefix__c(TWSResidualPrefix__c = '.com/apex', TWSwsPrefix__c = '.com/apex');
    }   
    
    @isTest static void testConnectionToTIMS(){
        test.startTest();
        PCSConfigUpdate config = new PCSConfigUpdate('https://dtna-iservices1-test.qa.freightliner.com:443/IIBGeneric_SOAP11Service', 'test@gmtestail.com');
        test.stopTest();
        List<ConcessionRCURequest__c> rcu = [SELECT ID, Value__c FROM ConcessionRCURequest__c LIMIT 1];
        System.assertEquals('https://dtna-iservices1-test.qa.freightliner.com:443/IIBGeneric_SOAP11Service', rcu[0].value__c);
    }
    
    
    @isTest static void testTWSAppSettingURLChanges(){
        EventInviteURLPrefix__c eiup = EventInviteURLPrefix__c.getOrgDefaults();
        String residuals = eiup.TWSResidualPrefix__c;
        String prefix = eiup.TWSwsPrefix__c;
        
        test.startTest();
        PCSConfigUpdate config = new PCSConfigUpdate('https://dtna-iservices1-test.qa.freightliner.com:443/IIBGeneric_SOAP11Service', 'test@gmtestail.com');
        test.stopTest();
        
        eiup = EventInviteURLPrefix__c.getOrgDefaults();
        String testResidualsRetain = eiup.TWSResidualPrefix__c;//Tests Retainment of location
        String testResidualsBase = eiup.TWSResidualPrefix__c;//Tests base change
        String testPrefixRetain = eiup.TWSwsPrefix__c;//Tests Retainment of Location
        String testPrefixBase = eiup.TWSwsPrefix__c;//Tests base change
        
        URL domain = URL.getSalesforceBaseUrl(); //Holds the current sandbox's base url
        String domainString = domain.toString(); //The String of the current sandbox's url
        domainString = domainString.mid(14, domainString.length());
        domainString = domainString.replace(']','');
        
        testResidualsRetain = testResidualsRetain.replace(domainString, '');
        testPrefixRetain = testPrefixRetain.replace(domainString, '');
        testResidualsBase = testResidualsBase.replace('/apex', '');
        testPrefixBase = testPrefixBase.replace('/apex', '');
        system.assertEquals('/apex', testResidualsRetain);
        system.assertEquals('/apex', testPrefixRetain);
        system.assertEquals(domainString, testResidualsBase);
        system.assertEquals(domainString, testPrefixBase);
        system.assertEquals(domainstring + '/', eiup.value__c);
    }
    
    @isTest static void testMandatoryContact(){
        test.StartTest();
        PCSConfigUpdate config = new PCSConfigUpdate('https://dtna-iservices1-test.qa.freightliner.com:443/IIBGeneric_SOAP11Service', 'test@gmtestail.com');
        test.StopTest();
        
        List<Contact> mandatoryContact = [SELECT ID FROM Contact WHERE Email = 'test@gmtestail.com' AND LastName = 'T3$T'];
        System.assertEquals(1, mandatoryContact.size());
    }    
}