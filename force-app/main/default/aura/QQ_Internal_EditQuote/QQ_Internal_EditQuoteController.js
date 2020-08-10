({
    handleEvent : function(component, event, helper)
    {
        var saveFlag = event.getParam("saveFlag");
        component.set("v.saveFlag", saveFlag);
    },
    
    doInit : function(component, event, helper) 
    {
        var QuoteNum = component.get("v.QuoteNum");
        var action1 = component.get("c.getQuickQuote");
        action1.setParams({"QuoteNum":QuoteNum});
        action1.setCallback(this, function(response){
            var state = response.getState();            
            if(state === 'SUCCESS'){
                var resultData = response.getReturnValue();
                component.set("v.quote", resultData);
                
                var TWSValue = component.get("v.quote.TWS_Deal_No__c");
                if(TWSValue != undefined)
                {
                    component.set("v.concession_TWS", "TWS DEAL NO");
                } 
                
            }else if (state === 'ERROR'){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }else{
                console.log('Something went wrong, Please check with your admin');
            }
        });
        
        var action2 = component.get("c.getLineItem");
        action2.setParams({"QuoteNum":QuoteNum});
        action2.setCallback(this, function(response){
            var state = response.getState();            
            if(state === 'SUCCESS'){
                var resultData = response.getReturnValue();
                component.set("v.quoteitem", resultData);
            }else if (state === 'ERROR'){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }else{
                console.log('Something went wrong, Please check with your admin');
            }
        });
        
        var action3 = component.get("c.getAccount");
        action3.setParams({"QuoteNum":QuoteNum});
        action3.setCallback(this, function(response){
            var state = response.getState();            
            if(state === 'SUCCESS'){
                var resultData = response.getReturnValue();
                component.set("v.Customer", resultData);
            }else if (state === 'ERROR'){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }else{
                console.log('Something went wrong, Please check with your admin');
            }
        });
        $A.enqueueAction(action1);
        $A.enqueueAction(action2);
        $A.enqueueAction(action3);
    },
    
    updateCoverage : function(component, event, helper)
    {  
        var gencmp = component.find('genform');
        var odrcmp = component.find('odrform');
        
        //alert(JSON.stringify(component.get("v.quote")));
        
        var validcustomer = false;
        var qqcustomer = gencmp.find("quotecustomer");
        var qqcustomer_help = gencmp.find("quotecustomerhelptext");
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
                
        var validgen = gencmp.find('quoteform').reduce(function (validSoFar, inputCmp) {  
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        
        var validodr = odrcmp.find('quoteform').reduce(function (validSoFar, inputCmp) { 
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
            
        }, true);
        
        if(validcustomer && validgen && validodr)
        {   
            var customer = component.get("v.Customer");
            //alert(JSON.stringify(customer));
            
            var cvrgcmp = component.find("cvgform");
            var coverage = component.get("v.quoteitem.Coverage__c");
            let cvrg_section;
            switch(coverage) 
            {
                case 'DETROIT COVERAGE':
                    cvrg_section = cvrgcmp.find("detroitform");
                    break;
                case 'TRUCK CHASSIS':
                    cvrg_section = cvrgcmp.find("truckform");
                    break;
                default:
                    // code block
            }
            
            let validcvgsection = cvrg_section.find("quoteform").reduce(function (validSoFar, inputCmp) { 
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && inputCmp.get('v.validity').valid; 
            }, true);
            
            
            var SubmitQuoteSrvc = component.find("SubmitQuickQuote");
            component.set("v.quote.Customer_Name__c", customer.Id);
            component.set("v.quote.Stage__c" , "Pending");
            component.set("v.quote.Status__c" , "Pending for Validation");
            component.set("v.quote.Source__c" , "Internal");
            
            var Duration = component.get("v.quoteitem.Duration_Final__c");
            var Months = component.get("v.quoteitem.Months__c");
            var Miles = component.get("v.quoteitem.Miles__c");
            
            //alert("Duration: " + Duration + ", Months: " + Months + ", Miles: " + Miles);
            if((Months != undefined && Miles != undefined) && (Number(Months) != 0 && Number(Miles) != 0) && validcvgsection)
            { 
                var quoteitemlst = []; 
                var quoteitemobj = component.get("v.quoteitem");
                quoteitemlst.push(quoteitemobj);
                
                SubmitQuoteSrvc.submitquickquote(component.get("v.quote"), quoteitemlst, component.get("v.noteslist"), component.get("v.QuoteNum"), true, function(result) {
                    component.set("v.openpopup" , false);
                    var submitEvent = $A.get("e.c:QQ_NQ_Submit_Save_event");        
                    submitEvent.setParam("message", "event message here");
                    submitEvent.fire();
                });
            }
            else
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Duration cannot be left blank, if duration is not available please enter both months and miles.",
                    "type" : "error"
                });
                toastEvent.fire();
            }
        }
    },
    
    CancelQuote : function(component, event, helper)
    {
        component.set("v.closeform" , true);    
    }    
})