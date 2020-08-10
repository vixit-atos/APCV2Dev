/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Purpose:
* This class is to be used after a Sandbox refresh to allow a more realistic sandbox.
* NOTE: Email Deliverability All Email must be set manually
* User.MainframeID change to Non-Unique must be set manually
* Quote Activity Custom Link needs to manually change to VisualFore Page QuoteActivityConc
* WorkflowAlert Emails need manual change
* Approver Configuration best done manually as approvers can change and new settings can occur.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Chris  
* @modifiedBy     Chris     
* @version        1.0
* @created        6-25-2018
* ──────────────────────────────────────────────────────────────────────────────────────────────────
**/
public class PCSConfigUpdate{
    
    public PCSConfigUpdate(String rcuAddress, String errorEmailAddress){
        try{
            mainframeConnectionToTIMS(rcuAddress);
            twsAppSettingURLChanges();
            createMandatoryContact();
            if(Test.isRunningTest()){ 
                throw new CalloutException();
            }
            
        }catch(Exception e){
            //Send an email if an error occurs during update
            String[] toAddresses = new String[]{errorEmailAddress};
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddresses);
            mail.setSenderDisplayName('Salesforce Refresh Support');
            mail.setSubject('Error');
            mail.setPlainTextBody('The Post Copy Configuration has met with an unfortunate fate: ' + e.getStackTraceString());
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        }
    }
    
    @TestVisible private void mainframeConnectionToTIMS(String rcuAddress){
        List<ConcessionRCURequest__c> rcu = [SELECT ID, Name, Value__c from ConcessionRCURequest__c WHERE Name = 'Endpoint']; //Holds the Endpoint for updating to the Sandbox value        
        rcu[0].value__c = rcuAddress;
        List<ConcessionRCURequest__c> rcu2 = [SELECT ID, Name, Value__c from ConcessionRCURequest__c WHERE Name = 'clientCertName_x']; //Holds the clientCertName__x for updating to the Sandbox value
        rcu2[0].value__c = 'dtna_soa_gtwy_cert';
        rcu.add(rcu2[0]);
        update rcu;
    }
    
    @TestVisible private void twsAppSettingURLChanges(){
        //Gets the domain, removes the URL:[delegate= , and removes the ending bracket
        URL domain = URL.getSalesforceBaseUrl(); //Holds the current sandbox's base url
        String domainString = domain.toString(); //The String of the current sandbox's url
        domainString = domainString.mid(14, domainString.length());
        domainString = domainString.replace(']','');
        //Replace the base url with current sandbox base url
        EventInviteURLPrefix__c twsAppSettings = EventInviteURLPrefix__c.getOrgDefaults(); //Holds the twsAppSetting object
        String twsResidualPrefix = replaceBaseURLInString(twsAppSettings.TWSResidualPrefix__c, domainString);//Holds the replaced base url for ResidualPrefix
        String twsWsPrefix = replaceBaseURLInString(twsAppSettings.TWSwsPrefix__c, domainString);//Holds the replaced base url for WsPrefix
        String twsValue = domainString;
        twsAppSettings.TWSResidualPrefix__c = twsResidualPrefix;
        twsAppSettings.TWSwsPrefix__c = twsWsPrefix;
        twsAppSettings.value__c = twsValue + '/';
        Database.update(twsAppSettings, false);
    }
    
    @TestVisible private void createMandatoryContact(){
        insert new Contact(LastName = 'T3$T',Email = 'test@gmtestail.com',RecordTypeID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Dealership Contact').getRecordTypeId());
    }  
    @TestVisible private String replaceBaseURLInString(String urlString, String domainString){
        //Find the com, and replace with the provided domain string
        Integer locationOfCom = urlString.indexOf('com');//Location of the .com in URL
        String oldBaseURLString = urlString.substring(0, locationOfCom+3);//old URL for removal
        return urlString.replace(oldBaseURLString, domainString);
    } 
}