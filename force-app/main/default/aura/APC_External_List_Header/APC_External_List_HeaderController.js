({
    handleCheck : function(component, event, helper) {
        var recordid = event.getParam("recordid");
        var checkvalue = event.getParam("checkvalue");
    },
    
    navtoviewall : function(component, event, helper) {
       
        component.find("navService").navigate({    
            type: "standard__namedPage",
            attributes: {
                "pageName": "view-all-cases"    
            }
        });
    },
    navtoviewallcontacts : function(component, event, helper) {
       
        component.find("navService").navigate({    
            type: "standard__namedPage",
            attributes: {
                "pageName": "view-all-contacts"    
            }
        });
    }
})