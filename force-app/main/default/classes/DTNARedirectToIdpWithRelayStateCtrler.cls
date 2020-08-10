public class DTNARedirectToIdpWithRelayStateCtrler 
{
    // IdP login url
        String idpUrlWithRelayState = 'https://idp-dtna.prd.freightliner.com/affwebservices/public/saml2sso?SPID=https://dtna.my.salesforce.com';
        String idpTWSCommUrlWithRelayState = 'https://idp-dtna.prd.freightliner.com/affwebservices/public/saml2sso?SPID=https://daimler.force.com/tws';
        

    public DTNARedirectToIdpWithRelayStateCtrler()
    {
        // Capture the RelayState parameter.
        String relayState = ApexPages.currentPage().getParameters().get('RelayState');
        String SSOType = ApexPages.currentPage().getParameters().get('Type');
        
        IDP_Initiated_URL_Mapping__mdt[] IDPURLMappings = [SELECT QualifiedApiName, IDP_URL__c FROM IDP_Initiated_URL_Mapping__mdt where QualifiedApiName = :SSOType];
        if(IDPURLMappings.size() == 1)
        {
            idpUrlWithRelayState = IDPURLMappings[0].IDP_URL__c;
        }
        
        
        if(relayState != null && relayState != '') 
        {
            // Attach the RelayState parameter to the IdP login url.
            idpUrlWithRelayState = idpUrlWithRelayState + '&RelayState=' + EncodingUtil.urlEncode(relayState, 'UTF-8');
        }
    }
    
    Public String getIdpUrlWithRelayState()
    {
        return idpUrlWithRelayState;
    }
    Public String getIdpTWSCommUrlWithRelayState()
    {
        return idpTWSCommUrlWithRelayState;
    }
}