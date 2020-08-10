({
    CancelSend : function(component, event, helper) {
        component.set("v.showreject" , false); 
    },
    SendtoGroup : function(component, event, helper) {
          var userId = $A.get("$SObjectType.CurrentUser.Id");
        var notesarray = JSON.parse(JSON.stringify(component.get("v.noteslist")));
        var noteobj = JSON.parse(JSON.stringify(component.get("v.noteitem")));
        notesarray.push(noteobj);
        component.set("v.noteslist" ,notesarray );
        component.set("v.quote.Stage__c" , "Complete");
        component.set("v.quote.Status__c" , "Rejected");
        component.set("v.quote.Rejected_By__c" , userId);
        component.set("v.quote.Rejected_On__c" ,new Date() );
       var validExpense = [].concat(component.find('rej')).reduce(function (validSoFar, inputCmp) {
         
          inputCmp.showHelpMessageIfInvalid();
           return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        
        if(validExpense){
           
            helper.callApprovalservice(component, event, helper);}
    }
})