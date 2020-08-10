({
	doInit : function(component, event, helper) 
    {
        var category = "Chassis Model";
        helper.getItems(component, category, false);
        
		var category = "Group";
        helper.getItems(component, category, true);
        
        var category = "A85 Code";
        helper.getItems(component, category, true);
	},
    
    codeChange : function(component, event, helper) 
    {
        var selectedValues = event.getParam("value");
        component.set("v.AdminTool.A85_Code__c", selectedValues);
    },
    
    checkMandatory : function(component, event, helper)
    {
        var model = component.get("v.AdminTool.Model__c");
        var AdmGroup = component.get("v.AdminTool.Group__c");
        var A85Code = component.get("v.AdminTool.A85_Code__c");
        
        var allValid = true;
        var errorMessage = "";
        if(model === undefined || model === "")
        {
            allValid = false;
            errorMessage = "Model can't be left blank";
            component.find("UID_Model").showHelpMessageIfInvalid();
            component.find("UID_Model").focus();
        }
        if(AdmGroup === undefined || AdmGroup === "")
        {
            allValid = false;
            errorMessage = "Group can't be left blank";
            component.find("UID_Group").showHelpMessageIfInvalid();
            component.find("UID_Group").focus();
        }
        if(A85Code === undefined || A85Code === "")
        {
            allValid = false;
            errorMessage = "A85 Code can't be left blank";
            component.find("UID_A85Code").showHelpMessageIfInvalid();
            component.find("UID_A85Code").focus();
        }
        
        if(!allValid)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": errorMessage,
                "type" : "error"
            });
            toastEvent.fire(); 
        }
        
        var callback;
        var params = event.getParam('arguments');
        if (params)
        {
            callback = params.callback;
        }
        callback(allValid);
    }
})