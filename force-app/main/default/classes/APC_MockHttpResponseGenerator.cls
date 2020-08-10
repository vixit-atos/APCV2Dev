@isTest
global class APC_MockHttpResponseGenerator implements HttpCalloutMock {
 global HTTPResponse respond(HTTPRequest req) {
        
        System.assertEquals('callout:paragon_getpartvalidate', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"CADSPackSize":"6.000 ","CAPDCPackSize":"6.000 ","GrossWeight":"3.580 ",'
                    +'"height":"2.200 ","isActive":"Y","Length":"14.500 ","message":"Part is Valid",'
                    +'"partdescription":"FILTER","PlannerCode":"PG1","UnitofMeasure":"IN","USDSPackSize":"6.000 ",'
                    +'"USPDCPackSize":"6.000 ","Vendor":"CUM2","VMRSCode":"045-011-005","Volume":"243.000 ",'
                    +'"volunit":"IN3","WeightUnit":"LB","Width":"10.000 ","Volumeunit":"1","PartActive":"Y",'
                    +'"ParagonPartDescription":"xyz","ParagonPartNumber":"121","PartNum":"121","ValidationMode":"Y",'
                    +'"RetMsg":"Part is Valid","RetCode":"12312"}');
        res.setStatusCode(200);
        return res;
    }
}