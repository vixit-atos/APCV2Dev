@isTest
global class APC_mockSalesorderresponse implements HttpCalloutMock{
global HTTPResponse respond(HTTPRequest req) {
        
        System.assertEquals('callout:paragon_getsalesorder', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"SalesOrderResponse":{"ReturnCode":"00","ReturnMessage":"Success","SalesOrderHeader":'+
                    '{"SalesOrderNumber":17412491,"SalesOrderType":"ZFSO","CustomerPONumber":"PA19070101",'+
                    '"SoldToParty":"FKHMD","FacingPDC":"FL28","CreatedOn":"07/01/2019"},"SalesOrderItem":'+
                    '[{"OrderLineNumber":11,"Material":"05-23045-002","Quantity":1,"Plant":"FL28","ShippingStatus":'+
                    '"Shipped","Delivery":8146542304,"OriginalDelivery":8146528755,"ShippingCondition":"DDS- Schneider",'+
                    '"Invoice":1033795620,"PlannerCode":"PG2","Vendor":"AD75","ETA":"07/02/2019"},{"OrderLineNumber":21,'+
                    '"Material":"06-39636-000","Quantity":3,"Plant":"FL28","ShippingStatus":"Shipped","Delivery":8146542303,'+
                    '"OriginalDelivery":8146528755,"ShippingCondition":"DDS- Schneider","Invoice":1033795620,"PlannerCode":"EL2",'+
                    '"Vendor":"A867","ETA":"07/02/2019"},{"OrderLineNumber":31,"Material":"22-65772-001","Quantity":1,"Plant":"FL28",'+
                    '"ShippingStatus":"Shipped","Delivery":8146542304,"OriginalDelivery":8146528755,"ShippingCondition":"DDS- Schneider",'+
                    '"Invoice":1033795620,"PlannerCode":"HV2","Vendor":"S095","ETA":"07/02/2019"}]}}');
        res.setStatusCode(200);
        return res;
    }
}