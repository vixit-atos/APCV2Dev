({ 
    doInit : function(component, event, helper) 
    {
        debugger;
        var CURL = window.location.href;
        var ContactId;
        if(CURL.includes("def_contact_id"))
        {
            ContactId = CURL.substr(CURL.indexOf('%3D')+3, 15);
            component.set("v.ContactId", ContactId);
            var action = component.get("c.getAccountId");
            action.setParams({conId : ContactId});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS")
                {
                    var AccountId = response.getReturnValue();
                    component.set("v.AccountId", AccountId);
                    component.set("v.ContactId", ContactId);
                    helper.createCaseFromContact(component, event, AccountId, ContactId);
                }
            });
            $A.enqueueAction(action);  
        }
        
        if(!CURL.includes("Contact") && !CURL.includes("def_contact_id") && !CURL.includes("Case/new?inContextOfRef"))
        {
            helper.createCaseFromCase(component, event);
        }
        
        if(CURL.includes("Contact"))
        {
            ContactId = CURL.split("/")[6];
            component.set("v.ContactId", ContactId);
            var action = component.get("c.getAccountId");
            action.setParams({conId : ContactId});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS")
                {
                    var AccountId = response.getReturnValue();
                    component.set("v.AccountId", AccountId);
                    component.set("v.ContactId", ContactId);
                    helper.createCaseFromContact(component, event, AccountId, ContactId);
                }
            });
            $A.enqueueAction(action);
        }
        
        if(CURL.includes("Case/new?inContextOfRef"))
        {
            var PURL = document.referrer;
            ContactId = PURL.split("/")[6];
            component.set("v.ContactId", ContactId);
            var action = component.get("c.getAccountId");
            action.setParams({conId : ContactId});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS")
                {
                    var AccountId = response.getReturnValue();
                    component.set("v.AccountId", AccountId);
                    component.set("v.ContactId", ContactId);
                    if(AccountId == undefined)
                    {
                        helper.createCaseFromContact(component, event, AccountId, ContactId);
                    }
                }
                if(state === "ERROR")
                {
                    helper.createCaseFromCase(component, event);
                }
            });
            $A.enqueueAction(action);
        }
    }
})