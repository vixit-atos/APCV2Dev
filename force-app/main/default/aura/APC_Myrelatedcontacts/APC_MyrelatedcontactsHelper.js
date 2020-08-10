({
	getvisiblecontactsofloggeduser : function(component, event, helper) {
        debugger;       
		var action = component.get("c.getuservisiblecontactdetails");
        action.setCallback(this, function(response){    debugger;  
            var state = response.getState();            
            if(state=='SUCCESS'){ 
                var contactslist = [];
                contactslist = response.getReturnValue();
                if(contactslist.length > 0){
                    component.set("v.hasvisiblecontacts", true);
                    component.set("v.data", contactslist);
                }else{
                    component.set("v.hasvisiblecontacts", false);
                }
            }
            else{
                console.log('Error'+ response.getError());
            }
        });
        $A.enqueueAction(action);
	}
})