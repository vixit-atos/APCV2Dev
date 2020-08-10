({
    doinit : function(component, event, helper) {
        var queryquoteSrvc = component.find("queryquoteservice");            
        queryquoteSrvc.getquoteData(component.get("v.quoteid") , function(result) {
            component.set("v.quote", result.quoteobj);
            var customer = result.quoteobj.Customer_Name__r.Name; 
            //  alert(result.quoteobj.Customer_Name__r)
            component.set("v.quotecustomer" ,customer );
            component.set("v.quoteitem", result.quoteitemlst[0]);
            component.set("v.haseditaccess", result.userhaseditaccess);
            component.set("v.notelist", result.notelst); 
        });
    }
})