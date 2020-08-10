({
    UpdateCustomer : function(component, event, helper)
    {
        component.set("v.showDetroit", false);
        component.set("v.showTruck", false);
        component.set("v.showFCCC", false);
        component.set("v.quoteitemlist", [] ) ;
        component.set("v.quote.Customer_Name__c", component.get("v.selectedLookUpRecord").Id);
        component.set("v.quotecustomer", component.get("v.selectedLookUpRecord").Name); 
        var qqcustomer = component.find("quotecustomer");
        var qqcustomer_help = component.find("quotecustomerhelptext"); 
        if(component.get("v.quote.Customer_Name__c"))
        { 
            $A.util.removeClass(qqcustomer, "slds-has-error");
            $A.util.addClass(qqcustomer_help, "slds-hide");            
        }
        else
        {
            $A.util.addClass(qqcustomer, "slds-has-error");
            $A.util.removeClass(qqcustomer_help, "slds-hide");              
        }
    }, 
    
    addcustomer : function(component, event, helper) 
    { 
        component.set("v.showaddbutton", false);
        var InsertCustmrSrvc = component.find("InsertCustomerSrvc");                
        InsertCustmrSrvc.createQQcustomer(component.get("v.accountkeyword"), function(result){
            component.set("v.quote.Customer_Name__c", result.Id);             
            component.set("v.quotecustomer", component.get("v.accountkeyword"));            
            var appEvent = $A.get("e.c:QQ_selectedsObjectRecordEvent");  
            appEvent.setParams({"recordByEvent" : result }); 
            appEvent.fire();
        }); 
    }, 
    
    handlechange: function(component, event, helper) 
    {
        var name = event.getSource().get("v.name");
        var value = event.getSource().get("v.value");
        //alert("Name: " + name + ", Value: " + value);
        
        switch(name) 
        {    
            case "concession_TWS":
                if(value === "CONCESSION")
                    component.set("v.quote.TWS_Deal_No__c", "");
                
                if(value === "TWS DEAL NO")
                    component.set("v.quote.Concession__c", "");
                
                break;
                
            case "REVISON STATUS":    
                if(value === "New")
                    component.set("v.quote.TC_Date__c", "");
                
                break;
                
            case "REQUEST TYPE":    
                component.set("v.quote.TC_Date__c", "");
                
                break;
        }
    }, 
    
    editform : function(component, event, helper)
    {
        component.set("v.editmode", true)  ;
        
        var appEvent = $A.get("e.c:QQ_selectedsObjectRecordEvent");  
        appEvent.setParams({"recordByEvent" : component.get("v.quote.Customer_Name__r") }); 
        appEvent.fire();
        
        var TWSValue = component.get("v.quote.TWS_Deal_No__c");
        if(TWSValue != undefined)
        {
            component.set("v.concession_TWS", "TWS DEAL NO");
        } 
    }, 
    
    saveform :function(component, event, helper) 
    {
        var validcustomer = false;
        var qqcustomer = component.get("v.quotecustomer");
        var qqcustomer_help = component.get("v.quotecustomerhelptext");
        if(component.get("v.quote.Customer_Name__c"))
        { 
            validcustomer = true;
            $A.util.removeClass(qqcustomer, 'slds-has-error');
            $A.util.addClass(qqcustomer_help, 'slds-hide');            
        }
        else
        {
            $A.util.addClass(qqcustomer, 'slds-has-error');
            $A.util.removeClass(qqcustomer_help, 'slds-hide');
            validcustomer = false;            
        }
        
        var validgen = component.find("quoteform").reduce(function (validSoFar, inputCmp) {  
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get("v.validity").valid;
        }, true);
        
        if(validcustomer && validgen)
        {
            helper.updateQuote(component);
        }
        else
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "All (*)required field cannot be left blank and invalid value is not allowed.",
                "type" : "error"
            });
            toastEvent.fire();
        }
    }
})