({
    CancelSend : function(component, event, helper) {
        component.set("v.showrevise" , false); 
    },
    SendtoGroup : function(component, event, helper) {
        
        var grouptosend = component.get("v.group");
        
        
        var notesarray = JSON.parse(JSON.stringify(component.get("v.noteslist")));
        var noteobj = JSON.parse(JSON.stringify(component.get("v.noteitem")));
        notesarray.push(noteobj);
        component.set("v.noteslist" ,notesarray );
        
        switch(grouptosend){
            case "Draft":
                component.set("v.quote.Status__c" , "Draft");
                component.set("v.quote.Stage__c" , "Draft");
                break;
            case "Validation":
                component.set("v.quote.Status__c" , "Pending for Validation");
                component.set("v.quote.Stage__c" , "Pending");
                break;
            case "Cost":
                component.set("v.quote.Status__c" , "Pending for Cost");
                component.set("v.quote.Stage__c" , "Pending");
                break;
            case "Price":
                component.set("v.quote.Status__c" , "Pending for Price");
                component.set("v.quote.Stage__c" , "Pending");
                break;
        }
         var validExpense = [].concat(component.find('rev')).reduce(function (validSoFar, inputCmp) {
         
           inputCmp.showHelpMessageIfInvalid();
           return validSoFar && inputCmp.get('v.validity').valid;
       }, true);
        
        if(validExpense){
            helper.callApprovalservice(component, event, helper);}
    }
})