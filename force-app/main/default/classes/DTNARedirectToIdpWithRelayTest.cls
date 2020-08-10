@isTest
public class DTNARedirectToIdpWithRelayTest
{
    @isTest static void test_method_one() 
    {
        DTNARedirectToIdpWithRelayStateCtrler test = new DTNARedirectToIdpWithRelayStateCtrler();
        String test1= '';
        test1 = test.getIdpUrlWithRelayState();
        System.assertNotEquals(test1,null);
        test1 = test.getIdpTWSCommUrlWithRelayState();
        System.assertNotEquals(test1,null);
    }
}