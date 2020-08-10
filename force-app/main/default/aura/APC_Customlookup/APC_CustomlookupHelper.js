({
    searchHelper : function(component,event,getInputkeyWord) {
        var action = component.get("c.fetchAccount");
        action.setParams({
            'searchKeyWord': getInputkeyWord
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", 'Search Result...');
                }
                component.set("v.listOfSearchRecords", storeResponse);
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchContactsList : function(component,event,dealerCode){
        var action = component.get("c.fetchcontactslist");
        action.setParams({
            'dealerCode': dealerCode
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                debugger;
                var storeResponse = response.getReturnValue();
                console.log('response.getReturnValue() :' +response.getReturnValue());
                 var dealercontactpicklist = [];
                var dealercontactpicklistadditional = [];
                 storeResponse.forEach(function(elem){   
                     debugger;
                    var optionlabel = '';
                    optionlabel += elem.FirstName ? elem.FirstName + ' ' : '';
                    optionlabel += elem.LastName ? elem.LastName : '';
                    optionlabel += ' ('+ elem.Email +' )';
                    var option = {
                        'label':optionlabel,
                        'value':elem.Id
                    }
                    dealercontactpicklist.push(option);
                    var optionadditional = {
                        'label':optionlabel,
                        'value':elem.Email
                    }
                    
                     dealercontactpicklistadditional.push(optionadditional);
                });
                debugger;
                console.log('dealercontactpicklist :' + JSON.stringify(dealercontactpicklist));
                component.set("v.contactNamesList", dealercontactpicklist);
                this.fireConatctsEvent(component,event,dealercontactpicklist,dealercontactpicklistadditional);
            }
        });
        $A.enqueueAction(action);
        
    },
    
    fireConatctsEvent : function(component,event,storeResponse, storeadditonalresponse){
        var evt = component.getEvent("contactsListEvnt") ;
        var selectedDealerCode = component.get("v.selectedRecord").Dealer_Code__c;
        evt.setParams({ "contactList":  storeResponse ,
                       "contactdealerlist": storeadditonalresponse,
                       "accountDealerCode":  selectedDealerCode });
        evt.fire();
    },
    
    fireCaseFormClearEvent : function(component,event){
        var evt = component.getEvent("ClearCaseForm") ;
        evt.setParams({ "clear":  "true" });
        evt.fire();
    }
    
})