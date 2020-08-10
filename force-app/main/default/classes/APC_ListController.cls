/**
* @File Name          : APC_ListController.apxc
* @Description        : Contains methods for all components in APC application
* @Author             : Sumit Datta, Chandrika
* @Group              : 
* @Last Modified By   : Sumit Datta
* @Last Modified On   : 01/20/2020, 9:46:00 AM
* @Modification Log   : 
*==============================================================================
* Ver         Date                     Author                    Modification
*==============================================================================
* 1.0    10/21/2019, 9:46:00 AM       Sumit Datta             Initial Version
**/
public  With Sharing class APC_ListController{
    
    static final set<string> RECORDTYPENAMELIST = new set<string>{'APC Order','APC Invoice','APC Credit','APC Core','APC Return','APC TBB'};
    static final list<recordtype> RECORDTYPELIST = new list<recordtype>([select id from recordtype where sobjecttype = 'case' and name in: RECORDTYPENAMELIST]);
    static final Set<ID> RECORDTYPEIDs = (new Map<Id,SObject>(RECORDTYPELIST)).keySet();   
    
    @AuraEnabled
    public static String getUserName(){
        return userinfo.getName();
    }
    
    @AuraEnabled        
    public static List<String> getPickListValuesIntoList(){
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Case.APC_Order_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            System.debug('Values in Rating are: '+pickListValuesList);
        }     
        return pickListValuesList;
    }
    
    @AuraEnabled
    public static List<CaseWrapper> getCaseRecords(String stagefilter, String statusfilter, String domain, String source) {      
        //Visbility of the cases is governed by the Shared Set in the community
        List<Case> cs_ls =  [SELECT AccountId,CaseNumber,ClosedDate,IsClosed,Origin,Priority,
                             Status,Subject,Request_Type__c,CreatedDate,CreatedBy.FirstName,
                             CreatedBy.LastName,LastModifiedDate, CreatedBy.Name, Part_No__c,
                             SAP_Order_Number__c, APC_PO_Number__c,CreatedBy.Profile.Name
                             from Case Where RecordType.Name IN :RECORDTYPENAMELIST ORDER BY LastModifiedDate DESC LIMIT 1500] ;
        
        List <CaseWrapper> csWrpLls = new List<CaseWrapper>();
        CaseWrapper csrecord;
        for(Case cs : cs_ls )
        {
            csrecord = new CaseWrapper(); 
            csrecord.Id = cs.Id;
            csrecord.CaseNumber = cs.CaseNumber;
            csrecord.CreatedDate = getformatteddate(cs.createddate);
            // csrecord.subject = cs.subject;
            csrecord.status = cs.Status;
            csrecord.priority = cs.priority;
            csrecord.actionrequested = cs.Request_Type__c;
            csrecord.subject = cs.subject;
            //csrecord.createdByNm = cs.CreatedBy.FirstName + ' ' + cs.CreatedBy.LastName;
            csrecord.partnumber = cs.Part_No__c;
            csrecord.lastresponse = getformatteddate(cs.LastModifiedDate);
            csrecord.sapordernumber = cs.SAP_Order_Number__c;
            csrecord.customerpo = cs.APC_PO_Number__c;
            if(cs.CreatedBy.Profile.Name == 'DEALER-PARTNER-COMMUNITY'){
                csrecord.createdByNm = cs.CreatedBy.FirstName + ' ' + cs.CreatedBy.LastName;
            }else{
                csrecord.createdByNm = 'Internal Agent';
            }
            csWrpLls.add(csrecord);
        } 
        return csWrpLls ;
    }
    
    @AuraEnabled
    public static Map<String,Object> getAllValues(String orderNumber, String customerPoNo, String soldToParty, String APC_Source, boolean isexternal) {
        // Add Security check here
        if(isexternal && !APC_MasterController.does_user_has_account_access(getSoldtopartyfromaccountid(soldToParty))){
              APC_MasterController.CustomAPIExceptionData data = new APC_MasterController.CustomAPIExceptionData('Security Breach','You do not have access to this Dealer' + soldToParty, 6);
              throw new AuraHandledException(JSON.serialize(data));
        }
        String soldtoparty2 = getSoldtopartyfromaccountid(soldToParty);
        // Added  String.escapeSingleQuotes and trimmed any trailing and leading spaces
        system.debug('APC_Source: ' +APC_Source);
        
        String orderNumber1 = String.escapeSingleQuotes(orderNumber.trim()) != null ? String.escapeSingleQuotes(orderNumber.trim()) : ''; 
        String customerPoNo1 = String.escapeSingleQuotes(customerPoNo.trim()) != null ? String.escapeSingleQuotes(customerPoNo.trim()) : ''; 
        String soldToParty1 = String.escapeSingleQuotes(soldtoparty2.trim()) != null ? String.escapeSingleQuotes(soldtoparty2.trim()) : ''; 
        String APC_Source1 = String.escapeSingleQuotes(APC_Source.trim()) !=null ? String.escapeSingleQuotes(APC_Source.trim()) : null; 
        
        Map<String,Object> returnMap = new Map<String,Object>();
        String paragonResponse = getSalesOrderFromParagon(orderNumber1, customerPoNo1, soldToParty1);
        returnMap.put('paragonResponse', paragonResponse);
        
        if(orderNumber1 != ''){
            returnMap.put('cases', getCasesFromLineNumbers(paragonResponse,APC_Source1, orderNumber1, 'SAP_Order_Number__c' ));
        }
        else if (customerPoNo1 != ''){
            returnMap.put('cases', getCasesFromLineNumbers(paragonResponse,APC_Source1, customerPoNo1, 'APC_PO_Number__c'));
        }
        else{
            returnMap.put('cases', getCasesFromLineNumbers(paragonResponse,APC_Source1, '', ''));
        }       
        return returnMap;
    }
    
    @AuraEnabled
    Public static String getSalesOrderFromParagon(String orderNumber, String customerPoNo, String soldToParty) {
        // Add Security check here
         // Added  String.escapeSingleQuotes and trimmed any trailing and leading spaces is already performed at previous method
        return DealerCisApi.getSalesOrderFromParagon(orderNumber, customerPoNo, soldToParty);       
    }    
    
    @AuraEnabled
    Public static Map<String,Object> getReceivedOrderFromParagon(String typeName, String typeValue, String soldToParty, String APC_Source, boolean isexternal) {
        
        // Add Security check Here
         if(isexternal && !APC_MasterController.does_user_has_account_access_accountid(soldToParty)){
              APC_MasterController.CustomAPIExceptionData data = new APC_MasterController.CustomAPIExceptionData('Security Breach','You do not have access to this Dealer' + soldToParty, 6);
              throw new AuraHandledException(JSON.serialize(data));
        }
        // Check for SOQL Injection Added to prevent single quotes , trailing and leading spaces  
        String soldtoparty2 = getSoldtopartyfromaccountid(soldToParty);
        Map<String,Object> returnMap = new Map<String,Object>();
        String typeName1 = String.escapeSingleQuotes(typeName.trim()) !=null ? String.escapeSingleQuotes(typeName.trim()) : null;
        String typeValue1 = String.escapeSingleQuotes(typeValue.trim()) !=null ? String.escapeSingleQuotes(typeValue.trim()) : null;
        String soldToParty1 = String.escapeSingleQuotes(soldtoparty2.trim()) !=null ? String.escapeSingleQuotes(soldtoparty2.trim()) : null;        
        String APC_Source1 = String.escapeSingleQuotes(APC_Source.trim()) !=null ? String.escapeSingleQuotes(APC_Source.trim()) : null; 
        
        
        system.debug('APC_Source => '+APC_Source1);
        system.debug('typeName1 => '+typeName1);
        if(typeName1=='Return_Number__c' || typeName1=='Credit_Debit__c') 
        {
            typeValue1 = '\''+typeValue1+'\'';
            List<Case> cases = getCasesFromTypeNumber(typeName1 +'='+ typeValue1);
            if(cases.size()==0)
            {               
                returnMap.put('paragonResponse', DealerCisApi.getReceivedOrderFromParagon(typeValue1, soldToParty1));
            } else 
            {
                returnMap.put('paragonResponse', DealerCisApi.getReceivedOrderFromParagon(typeValue1, soldToParty1));
                returnMap.put('cases', cases);
            }
        } else if (typeName1=='SAP_Order_Number__c')
        {
            String paragonResponse = '';
            paragonResponse = DealerCisApi.getReceivedOrderFromParagon(typeValue1, soldToParty1);
            
            system.debug('paragonResponse =>'+paragonResponse );
            returnMap.put('paragonResponse', paragonResponse);
            
            if(paragonResponse!=null && paragonResponse!='')
                returnMap.put('cases', getCasesFromLineNumbers(paragonResponse,APC_Source1,typeValue1,'SAP_Order_Number__c'));
        }
        system.debug('returnMap =>' +returnMap);
        return returnMap;
    }
        
    @AuraEnabled
    public static List<Case> getCasesFromLineNumbers(String paragonResponse, String APC_Source, String requestnumber, String requesttype ){
        // Add Security check here
        // Added  String.escapeSingleQuotes and trimmed any trailing and leading spaces in the previous method
        system.debug('paragonResponse => '+paragonResponse);
       
        Map<String,Object> paragonResponseMap = (Map<String,Object>)JSON.deserializeUntyped(paragonResponse);        
        Map<String,Object> SalesOrderResponse = (Map<String,Object>)paragonResponseMap.get('SalesOrderResponse');
        
        system.debug('SalesOrderResponse => '+SalesOrderResponse.get('SalesOrderItem'));
        
        
        String query = 'SELECT Id, CaseNumber, Body_Number__c, Part_No__c, Return_Number__c, APC_Line_Number__c,SAP_Order_Number__c, Credit_Debit__c, Status, '+
                       'PDC_Location__c ,Description, Action__c, Multiple_Parts__c FROM Case Where status != \'Closed\' ';     
        
        if(requesttype != '' && requestnumber != ''){
            query += ' and APC_Source__c=\''+APC_Source+'\' and ' + requesttype + '=\''+requestnumber + '\'';
        }
        query += ' and RecordTypeId  IN (\''+ String.join((Iterable<String>)RECORDTYPEIDs, '\',\'')+'\')'; // Record Type Check Sumit Datta 01/13/2020
        system.debug('query : ' + query);
        
        if(String.valueOf(SalesOrderResponse.get('ReturnCode'))=='00') {
            List<Object> lineItems = new List<Object>();
            if(SalesOrderResponse.get('SalesOrderItem') instanceof List<Object>) {
                lineItems = (List<Object>)SalesOrderResponse.get('SalesOrderItem');
            } else {
                lineItems.add(SalesOrderResponse.get('SalesOrderItem'));
            }
            List<String> lineNumbers = new List<String>();
            
            for(Object obj : lineItems) {
                lineNumbers.add(String.valueOf(((Map<String,Object>)obj).get('OrderLineNumber')));
            }            
            System.debug('lineNumbers => '+lineNumbers);
            
            List<Case> cases = database.query(query);            
            
            System.debug('cases => '+cases);            
            return cases;
        } else {
            throw new AuraHandledException(String.valueOf(SalesOrderResponse.get('ReturnMessage')));
        }
    }    
    
    @AuraEnabled
    public static List<Case> getCasesFromTypeNumber(String conditions){
        // Add REcord Type Check here Visibility of the cases is managed by Shared Set
        // Added  String.escapeSingleQuotes  and trimmed any trailing and leading spaces already  in previous method
        system.debug('getCasesFromTypeNumber conditions => '+conditions);
        
        String query =  'SELECT Id, CaseNumber, Body_Number__c, Part_No__c, Return_Number__c,APC_Line_Number__c,'+
                        ' SAP_Order_Number__c, Credit_Debit__c, Status, Multiple_Parts__c '+
                        ' FROM Case WHERE status != \'Closed\' AND '+conditions+
                        ' and RecordTypeId  IN (\''+ String.join((Iterable<String>)RECORDTYPEIDs, '\',\'')+'\')'+
                        ' ORDER BY CreatedDate DESC LIMIT 1000';
        system.debug('query => '+query);
        return Database.query(query);
    }    
    
    public class CaseWrapper{
        @AuraEnabled Public String Id;
        @AuraEnabled Public String CaseNumber;
        @AuraEnabled Public String createdByNm;
        @AuraEnabled Public String subject;
        @AuraEnabled Public String status;
        @AuraEnabled Public String priority;
        @AuraEnabled Public String CreatedDate; 
        @AuraEnabled Public String actionrequested;
        @AuraEnabled Public String partnumber;
        @AuraEnabled Public String sapordernumber;
        @AuraEnabled Public String customerpo;
        @AuraEnabled Public String lastresponse;            
        @AuraEnabled Public String Description; 
        @AuraEnabled Public String actionselected;            
        @AuraEnabled Public boolean isselected; 
        @AuraEnabled Public boolean isdisabled;
        @AuraEnabled Public list<String> documentids;
        
    }
    
    // Added by Sumit 01/13/2020 to get formated date for list view
    
    public static string getformatteddate (DateTime d)
    {
        return DateTime.newInstance(d.year(),d.month(),d.day()).format('MM/dd/yyyy');
    }
    
    public static string getSoldtopartyfromaccountid(string soldtoparty){
        account a = new account();
        a= [select dealer_code__c from account where id=:soldtoparty];
        String dealercode = '';
        if(a!= null){
            if(a.Dealer_code__c.length() == 4){
                dealercode = 'F'+a.Dealer_code__c;
            }else{
                dealercode =  a.Dealer_code__c;
            }
        }
        system.debug('dealercode: '+ dealercode);
        return dealercode;
    }
    
}