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
            var itemlist = component.get("v.quoteitemlist");
                      

                    component.set("v.detroititem" , true); 
               
                    component.set("v.truckitem" , true); 
              
                    component.set("v.fccitem" , true); 
                
            
        });
        }}
        
    })