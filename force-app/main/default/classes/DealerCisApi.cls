public class DealerCisApi {
    
    public static String getSalesOrderFromParagon(String orderNumber, String customerPoNo, String soldToParty) {
        String paragonCredentails = System.label.Paragan_Credentials;
        APC_Paragon_Credentials__mdt paragonCredentials = [SELECT ID, User_Name__c,key__c,encrypted_password__c FROM APC_Paragon_Credentials__mdt WHERE MasterLabel =: paragonCredentails];
        
        String Password = APC_MasterController.decryptedpassword(paragonCredentials.encrypted_password__c,paragonCredentials.key__c);
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:paragon_getsalesorder');
        req.setMethod('POST');
        req.setTimeout(120000);
        req.setBody('{"SalesOrderRequest": {"Login": {"Userid": "' + paragonCredentials.User_Name__c + '","UserPswd": "' + Password + '"},"OrderInfo": {"CaseID": "","OrderNumber": "'+orderNumber+'","CustomerPONumber": "'+customerPoNo+'","SoldToParty": "'+soldToParty+'"}}}'); 
        system.debug('request => '+req);
        system.debug('request body => '+req.getBody());
        Http http = new Http();
        HTTPResponse res = http.send(req); 
        system.debug('response body => '+res.getBody());
        system.debug('response'+ res );
        return res.getBody();
    }    
    public static String getReceivedOrderFromParagon(String orderNumber, String soldToParty) {
        String paragonCredentails = System.label.Paragan_Credentials;
        APC_Paragon_Credentials__mdt paragonCredentials = [SELECT ID, User_Name__c,key__c,encrypted_password__c FROM APC_Paragon_Credentials__mdt WHERE MasterLabel =: paragonCredentails];
        
        String Password = APC_MasterController.decryptedpassword(paragonCredentials.encrypted_password__c,paragonCredentials.key__c);
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:paragon_getsalesorder');
        req.setMethod('POST');
        req.setTimeout(120000);
        req.setBody('{"SalesOrderRequest": {"Login": {"Userid": "' + paragonCredentials.User_Name__c + '","UserPswd": "' + Password + '"},"OrderInfo": { "CaseID": "", "OrderNumber": "'+orderNumber+'", "SoldToParty": "'+soldToParty+'"}}} '); 
        system.debug('request => '+req);
        Http http = new Http();
        HTTPResponse res = http.send(req); 
        system.debug('response body => '+res.getBody());
        return res.getBody();
    }  
    
}