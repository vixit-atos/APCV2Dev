({
    doInit : function(component, event, helper) 
    {
        var category = "Quote Type";
        var action = component.get("c.getPicklistItem");
        action.setParams({
            "category" : category
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") 
            {
                var result = response.getReturnValue();
                component.set("v.QuoteTypes", result);
            }
        });
                
        $A.enqueueAction(action);
    },
   
    uploadFile : function(component, event, helper)
    {
        var errFlag = false;
        var errMessage = "";
        
        
        if(component.find("UID_Policy1").get("v.files") == null &&
           component.find("UID_Policy2").get("v.files") == null &&
           component.find("UID_Policy3").get("v.files") == null)
        {
            errFlag = true;
            errMessage = "Please select at least one valid file";            
        }
        
        var quoteType = component.get("v.AdminTool.Quote_Type__c");
        if(quoteType === undefined)
        {
            errFlag = true;
            errMessage = "Please select Quote Type";
            component.find("UID_QuoteType").showHelpMessageIfInvalid();
            component.find("UID_QuoteType").focus();
        }
        
        if(component.find("UID_Policy3").get("v.files") != null)
        {
            var fileName = component.find("UID_Policy3").get("v.files")[0]['name'];
            if(fileName != "Policy Manual-3.jpg")
            {
                errFlag = true;
                errMessage = "File name must be \"Policy Manual-3.jpg\"";
            }
            var fileSize = component.get("v.policyDesc3");
            if(fileSize > 200 || fileSize <= 0 || fileSize === undefined)
            {
                errFlag = true;
                errMessage = "Image size should be between 1 and 200";
            }
            if(!errFlag)
            {   
                helper.uploadHelper(component, event, fileName);
            }
        }
        if(component.find("UID_Policy2").get("v.files") != null)
        {
            var fileName = component.find("UID_Policy2").get("v.files")[0]['name'];
            if(fileName != "Policy Manual-2.jpg")
            {
                errFlag = true;
                errMessage = "File name must be \"Policy Manual-2.jpg\"";
            }
            var fileSize = component.get("v.policyDesc2");
            if(fileSize > 200 || fileSize <= 0 || fileSize === undefined)
            {
                errFlag = true;
                errMessage = "Image size should be between 1 and 200";
            }
            if(!errFlag)
            {            
                helper.uploadHelper(component, event, fileName);
            }
        }
        if(component.find("UID_Policy1").get("v.files") != null)
        {
            var fileName = component.find("UID_Policy1").get("v.files")[0]['name'];
            if(fileName != "Policy Manual-1.jpg")
            {
                errFlag = true;
                errMessage = "File name must be \"Policy Manual-1.jpg\"";
            }
            var fileSize = component.get("v.policyDesc1");
            if(fileSize > 200 || fileSize <= 0 || fileSize === undefined)
            {
                errFlag = true;
                errMessage = "Image size should be between 1 and 200";
            }
            if(!errFlag)
            {
                helper.uploadHelper(component, event, fileName);
            }
        }
        
        if(errFlag)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": errMessage,
                "type" : "error"
            });
            toastEvent.fire();
        }
    },
    
    handleFilesChange1 : function(component, event, helper) 
    {
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
            var element = document.getElementById("divFile1");
            element.classList.remove("slds-text-color_error");
            element.classList.add("slds-text-color_success");
        }
        component.set("v.fileName1", fileName);
    },
    
    handleFilesChange2 : function(component, event, helper) 
    {
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
            var element = document.getElementById("divFile2");
            element.classList.remove("slds-text-color_error");
            element.classList.add("slds-text-color_success");
        }
        component.set("v.fileName2", fileName);
    },
    
    handleFilesChange3 : function(component, event, helper) 
    {
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
            var element = document.getElementById("divFile3");
            element.classList.remove("slds-text-color_error");
            element.classList.add("slds-text-color_success");
        }
        component.set("v.fileName3", fileName);
    }
})