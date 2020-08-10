({
    doinit : function(component, event, helper) {
       
        if(component.get("v.quoteid"))
        {
        var queryquoteSrvc = component.find("queryquoteservice");            
        queryquoteSrvc.getquoteData(component.get("v.quoteid") , function(result) {
            component.set("v.quote", result.quoteobj);
            component.set("v.quotecustomer", result.quoteobj.Customer_Name__r.Name);
            component.set("v.quoteitemlist", result.quoteitemlst);
            component.set("v.addonitems" , result.addonlst)
            component.set("v.newquotenum" , result.quoteobj.Name);
           
           var itemlist = component.get("v.quoteitemlist");
            itemlist.forEach(function(item) { 
                
                if(item.Program__c === 'PACKAGE'){
                    component.set("v.pkgexist" , true); 
                }
                if(item.Program__c === 'ATS'){
                    component.set("v.atsexist" , true); 
                }
                if(item.Program__c === 'TRANSMISSION'){
                    component.set("v.transmissionexist" , true); 
                }
            });
        });
        }
    }
    })