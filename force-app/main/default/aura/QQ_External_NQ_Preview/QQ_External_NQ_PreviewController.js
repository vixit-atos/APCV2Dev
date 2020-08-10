({
    doinit : function(component, event, helper) {
        if(component.get("v.quoteid"))
        {
            var queryquoteSrvc = component.find("queryquoteservice");            
            queryquoteSrvc.getquoteData(component.get("v.quoteid") , function(result) {
                component.set("v.quote", result.quoteobj);
                component.set("v.quotecustomer", (result.quoteobj.Customer_Name__r).Name);
                
                component.set("v.quoteitemlist", result.quoteitemlst);
                component.set("v.newquotenum" , result.quoteobj.Name);
                //alert(JSON.stringify(result.quoteitemlst));
                var itemlist = component.get("v.quoteitemlist");
                itemlist.forEach(function(item) { 
                    if(item.Coverage__c == 'DETROIT COVERAGE'){
                        component.set("v.detroititem" , true); 
                    }
                    if(item.Coverage__c == 'TRUCK CHASSIS'){
                        component.set("v.truckitem" , true); 
                    }
                    if(item.Coverage__c == 'FCCC'){
                        component.set("v.fccitem" , true); 
                    }
                    if(item.Coverage__c == 'FCCC-TBB'){
                        component.set("v.fcctbbitem" , true); 
                    }
                });
            });
        }}
})