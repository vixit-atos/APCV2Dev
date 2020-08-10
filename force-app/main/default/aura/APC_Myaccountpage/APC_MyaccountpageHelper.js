({
    getprimaryaccountinfo : function(component, event, helper){
         debugger;       
		var action = component.get("c.getloggeduserprimaryaccountinfo");
        action.setCallback(this, function(response){    debugger;  
            var state = response.getState();            
            if(state=='SUCCESS'){ 
                var primaryaccounts = response.getReturnValue();
                    component.set("v.primaryaccountID", primaryaccounts.Id);
            }
            else{
                console.log('Error'+ response.getError());
            }
        });
        $A.enqueueAction(action);
    },
	getvisibleaccountsofloggeduser : function(component, event, helper) {
        debugger;       
		var action = component.get("c.getuservisibleaccountdetails");
        action.setCallback(this, function(response){    debugger;  
            var state = response.getState();            
            if(state=='SUCCESS'){ 
                var accountslist = [];
                accountslist = response.getReturnValue();
                if(accountslist.length > 0){
                    component.set("v.hasvisibleaccount", true);
                    component.set("v.data", accountslist);
                }else{
                    component.set("v.hasvisibleaccount", false);
                }
            }
            else{
                console.log('Error'+ response.getError());
            }
        });
        $A.enqueueAction(action);
	}
})