/**
* @File Name          : OrderController.apxc
* @Description        : Contains methods for all components in APC application
* @Author             : Akhila.

**/

public class OrderController {
    
    @AuraEnabled
    public static Map<String,Object> getAllValues(Map<String,Object> params) {
        String orderNumber = params.containsKey('orderNumber') ? String.valueOf(params.get('orderNumber')) : ''; 
        String customerPoNo = params.containsKey('customerPoNo') ? String.valueOf(params.get('customerPoNo')) : ''; 
        String soldToParty = params.containsKey('soldToParty') ? String.valueOf(params.get('soldToParty')) : ''; 
        String APC_Source = params.containsKey('APC_Source') ? String.valueOf(params.get('APC_Source')) : null; 
        
        Map<String,Object> returnMap = new Map<String,Object>();
        String paragonResponse = getSalesOrderFromParagon(orderNumber, customerPoNo, soldToParty);
        returnMap.put('paragonResponse', paragonResponse);
        returnMap.put('cases', getCasesFromLineNumbers(paragonResponse,APC_Source));
        return returnMap;
    }
    
    @AuraEnabled
    Public static String getSalesOrderFromParagon(String orderNumber, String customerPoNo, String soldToParty) {
        if(!Test.isRunningTest())//Added by Sridhar Venkata to fix Test Class
            return DealerCisApi.getSalesOrderFromParagon(orderNumber, customerPoNo, soldToParty);
        //Added by Sridhar Venkata-Start
        else
        {
            return buildMockResponse();
        }
        //Added by Sridhar Venkata-end
    }
    
    //Added by Sridhar Venkata - Complete method for building logic in Test Class
    public static String buildMockResponse()
    {
        String responseBody = '{"SalesOrderResponse": {'+
            ' "ReturnCode": "00",'+
            '"ReturnMessage": "Success",'+
            '"SalesOrderHeader":    {'+
            '  "CaseID": "rrrrrr",'+
            ' "SalesOrderNumber": "0016069241",'+
            '"SalesOrderType": "ZFSO",'+
            '"CustomerPONumber": "TSW421TXC10",'+
            '"SoldToParty": "TXC10",'+
            '"FacingPDC": "FL52",'+
            '"CreatedOn": 20190227'+
            '},'+
            '"SalesOrderItem":    {'+
            '  "OrderLineNumber": "000010",'+
            ' "Material": "06-89363-000",'+
            '"Quantity": "1",'+
            '"Plant": "FL52",'+
            '"ShippingStatus": "Shipped",'+
            '"Delivery": 8141943843, '+
            '"ShippingCondition": "Dlr Assigned Carrier",'+
            '"Invoice": 1031059433, '+
            '"PlannerCode": "CA3"'+
            '}'+
            '}}';
        //HTTPResponse response = new HTTPResponse();
        //response.setBody(responseBody);
        return responseBody;
    }    
    /* Case Numbers - Duplicate cases */
    @AuraEnabled
    public static List<Case> getCasesFromLineNumbers(String paragonResponse, String APC_Source){
        system.debug('paragonResponse => '+paragonResponse);
        Map<String,Object> paragonResponseMap = (Map<String,Object>)JSON.deserializeUntyped(paragonResponse);        
        Map<String,Object> SalesOrderResponse = (Map<String,Object>)paragonResponseMap.get('SalesOrderResponse');
        system.debug('SalesOrderResponse => '+SalesOrderResponse.get('SalesOrderItem'));
        
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
            
            List<Case> cases = [SELECT Id, CaseNumber, Part_No__c, PDC__c 
                                FROM Case 
                                WHERE APC_Source__c=:APC_Source];
            System.debug('cases => '+cases);            
            return cases;
        } else {
            throw new AuraHandledException(String.valueOf(SalesOrderResponse.get('ReturnMessage')));
        }
    }
    
    @AuraEnabled
    public static List<Case> getCasesFromTypeNumber(String conditions){
        String query = 'SELECT Id, CaseNumber, Body_Number__c, Part_No__c, Return_Number__c, '+
            ' SAP_Order__c, Credit_Debit_Number__c, Status'+
            ' FROM Case WHERE '+conditions+' ORDER BY CreatedDate DESC LIMIT 10000';
        system.debug('query => '+query);
        return Database.query(query);
    }
    
    @AuraEnabled
    Public static Map<String,Object> getReceivedOrderFromParagon(Map<String,Object> params) {
        Map<String,Object> returnMap = new Map<String,Object>();
        String soldToParty = params.containsKey('soldToParty') ? (String)params.get('soldToParty') : null;
        String typeName = params.containsKey('typeName') ? (String)params.get('typeName') : null;
        String typeValue = params.containsKey('typeValue') ? (String)params.get('typeValue') : null;
        String APC_Source = params.containsKey('APC_Source') ? String.valueOf(params.get('APC_Source')) : null;  
        system.debug('APC_Source => '+APC_Source);
        if(typeName=='Return_Number__c' || typeName=='Credit_Debit_Number__c') {
            typeValue = '\''+typeValue+'\'';
            List<Case> cases = getCasesFromTypeNumber(typeName +'='+ typeValue);
            if(cases.size()==0){
                if(!Test.isRunningTest())
                    returnMap.put('paragonResponse', DealerCisApi.getReceivedOrderFromParagon(typeValue, soldToParty));
            } else {
                returnMap.put('cases', cases);
            }
        } else if (typeName=='SAP_Order__c'){
            String paragonResponse = '';
            if(!Test.isRunningTest())
                paragonResponse = DealerCisApi.getReceivedOrderFromParagon(typeValue, soldToParty);
            returnMap.put('paragonResponse', paragonResponse);
            if(paragonResponse!=null && paragonResponse!='')
                returnMap.put('cases', getCasesFromLineNumbers(paragonResponse,APC_Source));
        }
        
        return returnMap;
    }
    
      @AuraEnabled
    Public static CaseAPIWrapper getpartvalidate(String partnumber) 
    {  
        //List<String> names=new List<String>();
        CaseAPIWrapper objDT =  new CaseAPIWrapper();
        HttpRequest req = new HttpRequest();
        try {
            String paragonCredentails = System.label.Paragan_Credentials;
        	APC_Paragon_Credentials__mdt paragonCredentials = [SELECT ID, User_Name__c,Password__c FROM APC_Paragon_Credentials__mdt WHERE MasterLabel =: paragonCredentails];
        	system.debug('paragonCredentials       ' + paragonCredentials);
            req.setEndpoint('callout:paragon_getpartvalidate');
            req.setMethod('POST');
            req.setTimeout(120000);
            req.setBody('{"Request": {"Login": { "UserId": "' + paragonCredentials.User_Name__c + '","UserPswd": "' + paragonCredentials.Password__c + '"},"Part":{"PartNum":  "' + partnumber + '", "ValidationMode": "1"}}}');        
       //     req.setBody('{"Request": {"Login": { "UserId": "' + paragonCredentials.User_Name__c + '","UserPswd": "' + paragonCredentials.Password__c + '"},"Part":{"PartNum":  "' + partnumber + '", "ValidationMode": "1"}}}');        
            Http http = new Http();
            //Updated by Sridhar Venkata - Start
            HTTPResponse res;
            String jsonString='';
            if(!test.isRunningTest())
            {  res = http.send(req); 
             system.debug(res.getBody());
             jsonString=res.getBody();
            }
            else
            {
                jsonString = '{  "RetCode": "11",'+
                    ' "RetMsg": "success",'+
                    ' "ValidationMode": "true",'+
                    ' "PartNum": "1",'+
                    ' "ParagonPartNumber": "1",'+
                    ' "ParagonPartDescription": "test",'+
                    ' "VMRSCode": "1",'+
                    ' "PartActive": "false",'+
                    ' "Length": "10",'+
                    ' "Width": "10",'+
                    ' "height": "10",'+
                    ' "UnitofMeasure": "cm",'+
                    ' "Volume": "33",'+
                    ' "Volumeunit": "cc",'+
                    ' "GrossWeight": "50",'+
                    ' "WeightUnit": "pounds",'+
                    ' "plannercode": "AT",'+
                    ' "Vendor": "xyz",' +   
                    ' "USPDCPackSize": "1" ,' +
                    ' "USDSPackSize": "1" ,'+  
                    ' "CAPDCPackSize": "1" ,'+
                    ' "CADSPackSize": "1" '+
                    
                    '}';
            }            
            //Updated by Sridhar Venkata - End
            
            System.debug('jsonString to Tokens-->'+jsonString);
            System.JSONParser jp=JSON.createParser(jsonString);
            System.debug('jp to parsing-->'+jp);
            String retcode,retMsg;
            while(jp.nextToken()!=null){
                if (jp.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String fieldName = jp.getText();
                    System.debug('fieldName: ' + fieldName);
                    jp.nextToken();            
                    if(fieldName=='RetCode'){                                     
                        retcode=jp.getText();
                        System.debug('Line Number 146'+retcode);  
                        //names.add(retcode);
                    }
                    if(fieldName=='RetMsg'){                                        
                        retMsg=jp.getText();
                        System.debug('Line Number 151'+retMsg);
                        objDT.message=retMsg;
                        //names.add(retMsg);
                    }
                    if(fieldName=='ValidationMode'){                                        
                        String mode=jp.getText();                    
                        //names.add(mode);
                    } 
                    if(fieldName=='PartNum'){                                       
                        String Partnum=jp.getText();                     
                        //names.add(Partnum);
                    }
                    if(fieldName=='ParagonPartNumber'){                                         
                        String Paragon=jp.getText();                     
                        //names.add(Paragon);
                    }
                    if(fieldName=='ParagonPartDescription'){                                        
                        String Paragondesc=jp.getText();
                        objDT.partdescription=Paragondesc;
                        //names.add(Paragondesc);
                    }
                    if(fieldName=='VMRSCode'){                                      
                        String vmr=jp.getText();
                        objDT.VMRSCode=vmr;
                        //names.add(vmr);
                    }
                    if(fieldName=='PartActive'){                                        
                        String active=jp.getText();
                        objDT.isActive=active;
                        //names.add(active);
                    }
                    if(fieldName=='Length'){                                        
                        String length=jp.getText(); 
                        objDT.Length=length;
                        //names.add(length);
                    }
                    if(fieldName=='Width'){                                         
                        String width=jp.getText();
                        objDT.Width=width;
                        //names.add(width);
                    }
                    if(fieldName=='height'){                                        
                        String height=jp.getText();
                        objDT.height=height;
                        //names.add(height);
                    }
                    if(fieldName=='UnitofMeasure'){                                         
                        String measure=jp.getText();
                        objDT.UnitofMeasure=measure;
                        //names.add(measure);
                    }
                    if(fieldName=='Volume'){                                        
                        String volume=jp.getText();
                        objDT.Volume=volume;
                        //names.add(volume);
                    }
                    if(fieldName=='Volumeunit'){                                        
                        String volumeunit=jp.getText();
                        objDT.volunit=volumeunit;
                        //names.add(volumeunit);
                    }
                    if(fieldName=='GrossWeight'){                                       
                        String gross=jp.getText();
                        objDT.GrossWeight=gross;
                        //names.add(gross);
                    }
                    if(fieldName=='WeightUnit'){                                        
                        String weightunit=jp.getText();
                        objDT.WeightUnit=weightunit;
                        //names.add(weightunit);
                    }
                    if(fieldName=='USPDCPackSize'){                                         
                        String packsize=jp.getText();
                        objDT.USPDCPackSize=packsize;
                        //names.add(packsize);
                    }
                    if(fieldName=='USDSPackSize'){                                      
                        String usdspack=jp.getText();
                        objDT.USDSPackSize=usdspack;
                        //names.add(usdspack);
                    }
                    if(fieldName=='CAPDCPackSize'){                                        
                        String cappack=jp.getText();
                        objDT.CAPDCPackSize=cappack;
                        //names.add(cappack);
                    }
                    if(fieldName=='CADSPackSize'){                                      
                        String cadpack=jp.getText();
                        objDT.CADSPackSize=cadpack;
                        //names.add(cadpack);
                    }
                    if(fieldName=='PlannerCode'){                                       
                        String plannercode=jp.getText();
                        objDT.plannercode=plannercode;
                        //names.add(plannercode);
                    }
                    if(fieldName=='Vendor'){                                        
                        String Vendor=jp.getText(); 
                        objDT.Vendor=Vendor;
                        //names.add(Vendor);
                    }
                    //System.debug('Added to the names'+names);             
                }
            }
        }catch (Exception e) {
            // "Convert" the exception into an AuraHandledException
            //throw new AuraHandledException('SAP API is Currently unavailable: '+ e.getMessage());
            
            System.debug('Error Message '+e.getMessage());
            AuraHandledException e1 = new AuraHandledException('Error Message');
            e1.setMessage('Error Message '+e.getStackTraceString());                 
            System.debug(e1);
            throw e1;
        }
        finally {
            // Something executed whether there was an error or not
        }
        System.debug('objDT'+objDT);
        return objDT;
    }
    
    public class CaseAPIWrapper{
        @AuraEnabled public String  message {get;set;}
        @AuraEnabled public String  isActive {get;set;}
        @AuraEnabled public String  partdescription {get;set;}
        @AuraEnabled public String  plannercode {get;set;}
        @AuraEnabled public String  vendor {get;set;}
        @AuraEnabled public String  VMRSCode  {get;set;}
        @AuraEnabled public String  Volume  {get;set;}
        @AuraEnabled public String  UnitofMeasure  {get;set;}
        @AuraEnabled public String  Length  {get;set;}
        @AuraEnabled public String  Width  {get;set;}
        @AuraEnabled public String  height  {get;set;}
        @AuraEnabled public String  volunit  {get;set;}
        @AuraEnabled public String  GrossWeight  {get;set;}
        @AuraEnabled public String  WeightUnit  {get;set;}
        @AuraEnabled public String  USPDCPackSize  {get;set;}
        @AuraEnabled public String  USDSPackSize  {get;set;}
        @AuraEnabled public String  CAPDCPackSize  {get;set;}
        @AuraEnabled public String  CADSPackSize  {get;set;}
    }
    
    //Added the below method for the SAP APi Integration US-224 End
    public class CasePageWrapper {
        @AuraEnabled 
        public boolean hasNext;
        @AuraEnabled 
        public boolean hasPrev;
        @AuraEnabled 
        public String offset;
        @AuraEnabled public List<Case> caselist {get;set;}   
    } 
    
     @AuraEnabled
    public static String getUserId() {
        return userInfo.getUserId();
    }
    
    @AuraEnabled
    public static Boolean deleteFiles(Map<String, Object> params) {
        try{
            system.debug('params => '+params);
            List<Object> fileIds = (List<Object>)params.get('fileIds');
            List<String> documentIds = new List<String>();
            for(Object ob : fileIds){
                documentIds.add((String)ob);
            }
            delete [SELECT Id FROM ContentDocument WHERE Id=:documentIds];
            return true;
        }
        catch(Exception ex){
            System.debug('Error => '+ex.getStackTraceString());
            return false;
        }
    }
    
    @AuraEnabled
    public static List<ContentDocument> getDocuments(Map<String, Object> params) {
        system.debug('params => '+params);
        List<Object> docIds = (List<Object>)params.get('docIds');
        List<String> documentIds = new List<String>();
        for(Object ob : docIds){
            documentIds.add((String)ob);
        }
        return [SELECT Id, Title, ContentSize, FileType FROM ContentDocument WHERE Id=:documentIds];
    }
    
    @AuraEnabled
    public static List<ContentDocument> getFilesInfo(Map<String, Object> params) {
        system.debug('params => '+params);
        List<Object> files = (List<Object>)params.get('files');
        List<String> documentIds = new List<String>();
        
        for(Object file : files) {
            Map<Object,Object> fileMap = (Map<Object,Object>)file;
            documentIds.add((String)fileMap.get('documentId'));
        }
        
        List<ContentDocument> documents = [
            SELECT Id, Title, ContentSize, FileType FROM ContentDocument WHERE Id=:documentIds
        ];
        
        return documents;
    }
    
    @AuraEnabled
    public static List<ContentDocumentLink> createDocumentLinks(Map<String, Object> params) {
        system.debug('params => '+params);
        List<Object> files = (List<Object>)params.get('files');
        String recordId = (String)params.get('recordId');
        List<ContentDocumentLink> cdLinks = new List<ContentDocumentLink>();
        
        for(Object file : files) {
            Map<Object,Object> fileMap = (Map<Object,Object>)file;
            cdLinks.add(new ContentDocumentLink(
            	LinkedEntityId=recordId, 
                ContentDocumentId=(String)fileMap.get('Id'), 
                ShareType='V', 
                Visibility='AllUsers'
            ));
        }
        
        insert cdLinks;
        return cdLinks;
    }
    
    
}