({
    doInit : function(component, event, helper) {
        var today = new Date() ;
        var expirationdate = today.setDate(today.getDate() + 60); 
        component.set("v.quote.Expiration_Date__c",$A.localizationService.formatDate(expirationdate, "YYYY-MM-DD"));       
    },
    handleChange : function(component, event, helper) {
        var name = event.getSource().get("v.name");
        
        switch(name) {
            case "PM":
                component.set("v.showPackage", true);
                component.set("v.PMsection" , 'PM');
                component.set("v.ATSsection" , '');
                component.set("v.TMsection" , '');
                break;
            case "ATS":
                component.set("v.showATS", true);
                component.set("v.PMsection" , '');
                component.set("v.ATSsection" , 'ATS');
                component.set("v.TMsection" , '');
                break;
            case "TRANSMISSION":
                component.set("v.showTransmission", true);
                component.set("v.PMsection" , '');
                component.set("v.ATSsection" , '');
                component.set("v.TMsection" , 'TM');
                break;
                
        }
        
    },
    UpdateCustomer : function(component, event, helper) {
        component.set("v.showPackage", false);
        component.set("v.showATS", false);
        component.set("v.showTransmission", false);
        component.set("v.quoteitemlist" , [] ) ;
        component.set("v.quote.Customer_Name__c", component.get("v.selectedLookUpRecord").Id);
        component.set("v.quotecustomer", component.get("v.selectedLookUpRecord").Name);      
        
    },
    addcustomer : function(component, event, helper) { 
        component.set("v.showaddbutton" , false);
        var InsertCustmrSrvc = component.find("InsertCustomerSrvc");                
        InsertCustmrSrvc.createQQcustomer(component.get("v.accountkeyword"),function(result){
            component.set("v.quote.Customer_Name__c" , result.Id);             
            component.set("v.quotecustomer", component.get("v.accountkeyword"));            
            var appEvent = $A.get("e.c:QQ_selectedsObjectRecordEvent");  
            appEvent.setParams({"recordByEvent" : result }); 
            appEvent.fire();
        }); 
    },
    removeCoverage : function(component, event, helper) {
        var name = event.getSource().get("v.name");
        var label = event.getSource().get("v.label");
        var updatedquoteitemlist;
        
        //alert(JSON.stringify(component.get("v.quoteitemlist")));
        switch(name) {
            case "PM":
                updatedquoteitemlist = helper.removeobjectpropertyval(component.get("v.quoteitemlist") , 'Program__c' , 'PACKAGE');
                component.set("v.quoteitemlist" , updatedquoteitemlist ) ;        
                component.set("v.showPackage",false);
                break;
            case "ATS":
                updatedquoteitemlist = helper.removeobjectpropertyval(component.get("v.quoteitemlist") , 'Program__c' , 'ATS');
                component.set("v.quoteitemlist" , updatedquoteitemlist ) ; 
                component.set("v.showATS", false);
                break;
            case "TRANSMISSION":
                updatedquoteitemlist = helper.removeobjectpropertyval(component.get("v.quoteitemlist") , 'Program__c' , 'TRANSMISSION');
                component.set("v.quoteitemlist" , updatedquoteitemlist ) ; 
                component.set("v.showTransmission", false);
                break;
        }},
    
})