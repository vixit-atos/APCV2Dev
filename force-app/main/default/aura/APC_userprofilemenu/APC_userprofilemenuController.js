({
    init: function(component, event, helper){
        var action = component.get("c.getusernameinfo");
        action.setCallback(this, function(response){
            var state = response.getState();           
            if(state === "SUCCESS"){
                component.set("v.username", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    handleClick : function(component, event, helper) {
        var source = event.getSource();
        var label = source.get("v.label");
        console.log('label'+label);
        if(label=="Home"){
            component.find("navService").navigate({    
                type: "standard__namedPage",
                attributes: {
                    "pageName": "apc-home"    
                }
            });
        }  else if(label=="Contacts"){
            component.find("navService").navigate({    
                type: "standard__namedPage",
                attributes: {
                    "pageName": "view-all-contacts"    
                }});
        } else if(label=="Log out"){
            component.find("navService").navigate({    
                type: "comm__loginPage",
                attributes: {
                    actionName: 'logout'
                }
            });
        } else if(label=="My Account"){
             component.find("navService").navigate({    
                type: "standard__namedPage",
                attributes: {
                    "pageName": "apcmyaccount"    
                }});
            /*
            var loggedinuser;
            debugger;
            var action = component.get("c.getloggeduseraccountid");
            action.setCallback(this, function(response){
                var state = response.getState();
                debugger;
                if(state === "SUCCESS"){
                    component.find("navService").navigate({    
                        type: 'standard__recordPage',
                        attributes: {
                            recordId: response.getReturnValue(), 
                            objectApiName: 'Account',
                            actionName: 'view'
                        }
                    });
                }
            });
            $A.enqueueAction(action);
            
            component.find("navService").navigate({    
                type: "comm__namedPage",
                attributes: {
                    name: "Account Detail"    
                }
            });*/
        }
        
    }
})