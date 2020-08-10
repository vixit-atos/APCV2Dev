({
   loadApprovals : function(cmp) {
        // Load all contact data
        var action = cmp.get("c.getItemToApprove"); 
       	action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                cmp.set("v.approvals", response.getReturnValue());
                this.updateTotal(cmp);
            }

            // Display toast message to indicate load status
           var toastEvent = $A.get("e.force:showToast");
            if (state === 'SUCCESS'){
                 var totalItems = cmp.get("v.totalItemToApprove");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": " Your approval item have been loaded successfully. You have " + totalItems + " items."
                });
            }
            toastEvent.fire();
        });
         $A.enqueueAction(action);
    },
    
    updateTotal: function(cmp) {
      var approvals = cmp.get("v.approvals");
      cmp.set("v.totalItemToApprove", approvals.length);
    }
})