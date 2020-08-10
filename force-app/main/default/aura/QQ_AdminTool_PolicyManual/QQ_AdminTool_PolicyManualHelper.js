({
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000,     //Chunk Max size 750Kb 
    
    uploadHelper: function(component, event, fileName) 
    {
        var self = this;
        var fileInput;
        var file = [];
        var policyDesc = "";
        
        
        if(fileName === "Policy Manual-1.jpg" && (component.find("UID_Policy1").get("v.files") != null))
        {
            if (component.find("UID_Policy1").get("v.files").length > 0)
            {
                fileInput = component.find("UID_Policy1").get("v.files");
                file = fileInput[0];
                policyDesc = component.get("v.policyDesc1") + '-' + component.get("v.AdminTool.Quote_Type__c");
                if (file.size > self.MAX_FILE_SIZE) {
                    component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
                    return;
                }
            }
        }
        if(fileName === "Policy Manual-2.jpg" && (component.find("UID_Policy2").get("v.files") != null))
        {
            if (component.find("UID_Policy2").get("v.files").length > 0)
            {
                fileInput = component.find("UID_Policy2").get("v.files");
                file = fileInput[0];
                policyDesc = component.get("v.policyDesc2") + '-' + component.get("v.AdminTool.Quote_Type__c");
                if (file.size > self.MAX_FILE_SIZE) {
                    component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
                    return;
                }
            }
        }
        if(fileName === "Policy Manual-3.jpg" && (component.find("UID_Policy3").get("v.files") != null))
        {
            if (component.find("UID_Policy3").get("v.files").length > 0){
                fileInput = component.find("UID_Policy3").get("v.files");
                file = fileInput[0];
                policyDesc = component.get("v.policyDesc3") + '-' + component.get("v.AdminTool.Quote_Type__c");
                if (file.size > self.MAX_FILE_SIZE) {
                    component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
                    return;
                }
            }
        }
        
        try 
        {
            var objFileReader = new FileReader();
            objFileReader.onload = $A.getCallback(function() {
                var fileContents = objFileReader.result;
                var base64 = 'base64,';
                var dataStart = fileContents.indexOf(base64) + base64.length;
                fileContents = fileContents.substring(dataStart);                    
                self.uploadProcess(component, file, policyDesc, fileContents);
            });
            objFileReader.readAsDataURL(file);
        }
        catch(err) 
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                //"message": "From Client: " + err.message,
                "message":"",
                "type" : "error"
            });
            toastEvent.fire();
        }
    },
    
    uploadProcess: function(component, file, policyDesc, fileContents) 
    {
        var startPosition = 0;
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);        
        this.uploadInChunk(component, file, policyDesc, fileContents, startPosition, endPosition, '');
    },
    
    uploadInChunk: function(component, file, policyDesc, fileContents, startPosition, endPosition, attachId) 
    {
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.saveFile");
        action.setParams({
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            policyDesc: policyDesc,
            fileId: attachId
        });        
        
        action.setCallback(this, function(response) {
            attachId = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
                if (startPosition < endPosition) {
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId);
                } else {
                    //alert('File has been uploaded successfully');
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "File has been uploaded successfully",
                        "type" : "success"
                    });
                    toastEvent.fire();
                }
            } else if (state === "INCOMPLETE") {
                //alert("From server: " + response.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "From server: " + response.getReturnValue(),
                    "type" : "error"
                });
                toastEvent.fire();
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action);
    }
})