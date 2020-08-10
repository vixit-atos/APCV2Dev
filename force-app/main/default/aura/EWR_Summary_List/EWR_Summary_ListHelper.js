({
    getEWRInformation : function(cmp) {
        var action = cmp.get("c.fetchEWRInformation");
        action.setParams({"recordId": cmp.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                cmp.set("v.EWRs", storeResponse);
            }
        });
        $A.enqueueAction(action);
    },
    
    attachEWRs : function(cmp){
        var self = this;
        var toastEvent = $A.get("e.force:showToast");
        var action = cmp.get("c.getEWRs");
        action.setParams({"recordId": cmp.get("v.recordId"), "EWRs" : cmp.get("v.ewrString")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                cmp.set("v.foundEWRs", storeResponse);
                var action = cmp.get("c.checkEWRError");
                action.setParams({"foundEWRs" : cmp.get("v.foundEWRs"),
                                  "EWRs" : cmp.get("v.ewrString")});
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var storeResponse = response.getReturnValue();
                        cmp.set("v.missingEWRs", storeResponse);
                        var action = cmp.get("c.attachEWRs");
                        action.setParams({"recordId": cmp.get("v.recordId"), "foundEWRs" : cmp.get("v.foundEWRs")});
                        action.setCallback(this, function(response) {
                            var state = response.getState();
                            if (state === "SUCCESS") {
                                var storeResponse = response.getReturnValue();
                                console.log(storeResponse);
                                if(storeResponse){
                                    if(storeResponse === 'true'){
                                    toastEvent.setParams({
                                        title : 'Successfully added EWRs to Opportunity',
                                        message:'The EWRs have been added to the opportunity',
                                        messageTemplate: 'The EWRs have been added to the opportunity',
                                        duration:' 5000',
                                        key: 'info_alt',
                                        type: 'success',
                                        mode: 'pester'
                                    });
                                    toastEvent.fire();
                                    self.getEWRInformation(cmp);
                                    }else if(storeResponse ==='false'){
                                       toastEvent.setParams({
                                        title : 'Enter a valid EWR number',
                                        message:'The Entered EWR(s) are not valid. Please check the EWR Number and try again',
                                        messageTemplate: 'The Entered EWR(s) are not valid. Please check the EWR Number and try again',
                                        duration:' 5000',
                                        key: 'info_alt',
                                        type: 'error',
                                        mode: 'pester'
                                    });
                                    toastEvent.fire(); 
                                    }else{
                                        toastEvent.setParams({
                                        title : 'EWR attached',
                                        message:'The Entered EWR(s) is attached to the CRF with ID: ' + storeResponse,
                                        messageTemplate: 'The Entered EWR(s) is attached to the CRF with ID: ' + storeResponse,
                                        duration:' 5000',
                                        key: 'info_alt',
                                        type: 'error',
                                        mode: 'pester'
                                    });
                                    toastEvent.fire(); 
                                    }
                                }else{
                                    toastEvent.setParams({
                                        title : 'Enter a valid EWR number',
                                        message:'The Entered EWR(s) are not valid. Please check the EWR Number and try again',
                                        messageTemplate: 'The Entered EWR(s) are not valid. Please check the EWR Number and try again',
                                        duration:' 5000',
                                        key: 'info_alt',
                                        type: 'error',
                                        mode: 'pester'
                                    });
                                    toastEvent.fire();
                                }
                            }else{
                                toastEvent.setParams({
                                    title : 'Enter a valid EWR number',
                                    message:'The Entered EWR(s) are not valid. Please check the EWR Number and try again',
                                    messageTemplate: 'The Entered EWR(s) are not valid. Please check the EWR Number and try again',
                                    duration:' 5000',
                                    key: 'info_alt',
                                    type: 'error',
                                    mode: 'pester'
                                });
                                toastEvent.fire();
                            }
                        });
                        $A.enqueueAction(action);
                    }else{
                        toastEvent.setParams({
                            title : 'Enter a valid EWR number3',
                            message:'The Entered EWR(s) are not valid. Please check the EWR Number and try again',
                            messageTemplate: 'The Entered EWR(s) are not valid. Please check the EWR Number and try again',
                            duration:' 5000',
                            key: 'info_alt',
                            type: 'error',
                            mode: 'pester'
                        });
                        toastEvent.fire();
                    }
                });
                $A.enqueueAction(action);
            }else{
                toastEvent.setParams({
                    title : 'Enter a valid EWR number',
                    message:'The Entered EWR(s) are not valid. Please check the EWR Number and try again',
                    messageTemplate: 'The Entered EWR(s) are not valid. Please check the EWR Number and try again',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})