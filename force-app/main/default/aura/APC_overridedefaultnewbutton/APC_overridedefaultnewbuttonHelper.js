({ 
    createCaseFromContact : function(component, event, accountID, contactID) {
        //alert('multiple/contact/account');
        //-------case creation from contact fetching account id----------
        var recordTypeID = component.get("v.pageReference").state.recordTypeId; // For multiple record type
        component.set("v.recordTypeId", recordTypeID);
        var action = component.get("c.getRecordType");
        action.setParams({
            "recordTypeId" : recordTypeID
        });
        action.setCallback(this, function(response) {
            var CURL = window.location.href;
            if(contactID === undefined)
            {
                if(CURL.includes("Contact"))
                {
                    ContactId = CURL.split("%2F")[4];
                    contactID = ContactId;
                }
            }
            if(accountID === undefined)
            {
                if(CURL.includes("Account"))
                {
                    AccountId = CURL.split("%2F")[4];
                    accountID = AccountId;
                }
            }
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.recordType", result);
                
                var createRecordEvent = $A.get("e.force:createRecord");
                createRecordEvent.setParams({
                    "entityApiName": 'Case',
                    "recordTypeId": recordTypeID,
                    "defaultFieldValues": {
                        'AccountId' : accountID,
                        'ContactId' : contactID
                    }
                });
                createRecordEvent.fire();
                
            }
        });
        if(recordTypeID === undefined) // For single default record type
        {
            //alert('default/contact/account');
            var action = component.get("c.getDefaultRecordType");
            action.setCallback(this, function(response) {
                var CURL = window.location.href;
                if(contactID === undefined)
                {
                    if(CURL.includes("Contact"))
                    {
                        ContactId = CURL.split("%2F")[4];
                        contactID = ContactId;
                    }
                }
                if(accountID === undefined)
                {
                    if(CURL.includes("Account"))
                    {
                        AccountId = CURL.split("%2F")[4];
                        accountID = AccountId;
                    }
                }
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    component.set("v.defaultRecordType", result);
                    var RT = JSON.parse(JSON.stringify(result));
                    var RTObjArray = RT;
                    var RTObj = JSON.parse(JSON.stringify(RTObjArray[0]));
                    var RTName = RTObj.label;
                    component.set("v.defaultRecordTypeName",RTName);
                    var RTValue = RTObj.value;
                    component.set("v.defaultRecordTypeId",RTValue);
                    component.set("v.defaultcontactID",contactID);
                    var createRecordEvent = $A.get("e.force:createRecord");
                    createRecordEvent.setParams({
                        "entityApiName": 'Case',
                        "recordTypeId": RTValue,
                        "defaultFieldValues": {
                            'AccountId' : accountID,
                            'ContactId' : contactID
                        }
                    });
                    createRecordEvent.fire();
                    
                }
            });
        }
        $A.enqueueAction(action);	
    },
    
    createCaseFromCase : function(component, event) {
        //alert('multiple/Case');
        debugger;
        var recordTypeID = component.get("v.pageReference").state.recordTypeId; // For multiple record type
        component.set("v.recordTypeId", recordTypeID);
        var action = component.get("c.getRecordType");
        action.setParams({
            "recordTypeId" : recordTypeID
        });
        action.setCallback(this, function(response) {
            
            var CURL = window.location.href;
            var ContactId,AccountId;
            if(CURL.includes("Contact"))
            {
                ContactId = CURL.split("%2F")[4];
                component.set("v.ContactId", ContactId);
            }
            if(CURL.includes("Account"))
            {
                AccountId = CURL.split("%2F")[4];
                component.set("v.AccountId", AccountId);
            }
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var result = response.getReturnValue();debugger;
                component.set("v.recordType", result);
                if( result !='APC Core' && result !='APC Credit'&& result !='APC Invoice'&& result !='APC Order' && result !='APC Return'&& result !='APC TBB')
                {
                    var createRecordEvent = $A.get("e.force:createRecord");
                    createRecordEvent.setParams({
                        "entityApiName": 'Case',
                        "recordTypeId": recordTypeID,
                        "defaultFieldValues": {
                            'ContactId' : ContactId,
                            'AccountId' : AccountId
                        }
                    });
                    createRecordEvent.fire();
                }
                else  if(result =='APC Core' || result =='APC Credit'|| result =='APC Invoice'|| result =='APC Order'|| result =='APC Return'|| result =='APC TBB')
                {
                    //alert('Internal Case Creation Would called here');
                    $A.createComponent('c:APC_Internal_Casecreation', {
                        title: 'Internal Case Creation',
                        
                    }, function attachModal(modalCmp, status) {
                        if (component.isValid() && status === 'SUCCESS') {
                            var body = component.get("v.body");
                            body.push(modalCmp);
                            component.set("v.body", body);    
                        }
                    });
                    
                }
            }
        });
        if(recordTypeID == undefined) // For single default record type
        {
            //alert('default/Case');
            var action = component.get("c.getDefaultRecordType");
            
            action.setCallback(this, function(response) {
                var CURL = window.location.href;
                var ContactId, AccountId;
                if(CURL.includes("Contact"))
                {
                    ContactId = CURL.split("%2F")[4];
                    component.set("v.ContactId", ContactId);
                }
                if(CURL.includes("Account"))
                {
                    AccountId = CURL.split("%2F")[4];
                    component.set("v.AccountId", AccountId);
                }
                var state = response.getState();
                if (component.isValid() && state === "SUCCESS") {
                    var result = response.getReturnValue();
                    component.set("v.defaultRecordType", result);
                    var RT = JSON.parse(JSON.stringify(result));
                    var RTObjArray = RT;
                    var RTObj = JSON.parse(JSON.stringify(RTObjArray[0]));
                    var RTName = RTObj.label;
                    component.set("v.defaultRecordTypeName",RTName);
                    var RTValue = RTObj.value;
                    component.set("v.defaultRecordTypeId",RTValue);
                    
                    var createRecordEvent = $A.get("e.force:createRecord");
                    createRecordEvent.setParams({
                        "entityApiName": 'Case',
                        "recordTypeId": RTValue,
                        "defaultFieldValues": {
                            'ContactId' : ContactId,
                            'AccountId' : AccountId
                        }
                    });
                    createRecordEvent.fire();
                    
                }
            });
        }
        $A.enqueueAction(action);	
    }
})