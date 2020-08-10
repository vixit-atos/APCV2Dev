({
    escapeWeirdness: function(s){
         if(s != null && s.length > 0){
            s = s.replace(/&quot;/g, '\"');
            s = s.replace(/&amp;/g, '\&');
            s = s.replace(/&#39;/g, '\'');
            s = s.replace(/&lt;/g, '\<');
            s = s.replace(/&gt;/g, '\>');
        }
        return s;
        
    },
    
    getNoteInformation: function(cmp){
        var action = cmp.get("c.fetchNote");//creates an action to fetch note information
        action.setParams({"recordId": cmp.get("v.recordId"),
                          "title": "Data Codes"});
        action.setCallback(this, function(response) {
            var state = response.getState();//gets state of callback to respond to
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();//Retrieves the ContentNote's List of Strings
                cmp.find("codes").set("v.value", storeResponse);
            }
        });
        $A.enqueueAction(action);
        
        var action = cmp.get("c.fetchNote");//creates an action to fetch note information
        action.setParams({"recordId": cmp.get("v.recordId"),
                          "title": "What is it?"});
        action.setCallback(this, function(response) {
            var state = response.getState();//gets state of callback to respond to
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();//Retrieves the ContentNote's List of Strings
                storeResponse = this.escapeWeirdness(storeResponse);
                cmp.find("what").set("v.value", storeResponse);
            }
        });
        $A.enqueueAction(action);
        
        var action = cmp.get("c.fetchNote");//creates an action to fetch note information
        action.setParams({"recordId": cmp.get("v.recordId"),
                          "title": "Why is it important?"});
        action.setCallback(this, function(response) {
            var state = response.getState();//gets state of callback to respond to
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();//Retrieves the ContentNote's List of Strings
                storeResponse = this.escapeWeirdness(storeResponse);
                cmp.find("why").set("v.value", storeResponse);
            }
        });
        $A.enqueueAction(action);
        
        var action = cmp.get("c.fetchNote");//creates an action to fetch note information
        action.setParams({"recordId": cmp.get("v.recordId"),
                          "title": "High-Level Compatibility"});
        action.setCallback(this, function(response) {
            var state = response.getState();//gets state of callback to respond to
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();//Retrieves the ContentNote's List of Strings
				storeResponse = this.escapeWeirdness(storeResponse);
                cmp.find("compatibility").set("v.value", storeResponse);
            }
        });
        $A.enqueueAction(action);
    },
    
    tagImages: function(cmp){
        var action = cmp.get("c.tagImages");//creates an action to fetch the fab image
        action.setParams({"recordId": cmp.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();//gets state of callback to respond to
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();//Retrieves the ContentNote's List of Strings
            }
        });
        $A.enqueueAction(action);
    },
    
    getImages: function(cmp){
        var action = cmp.get("c.fetchImage");//creates an action to fetch the fab image
        action.setParams({"recordId": cmp.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();//gets state of callback to respond to
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();//Retrieves the ContentNote's List of Strings
                //Set each variable for the Note input into the Text Areas by ID
                cmp.set("v.imageId", storeResponse);
            }
        });
        $A.enqueueAction(action);
        
        var action = cmp.get("c.fetchImages");//creates an action to fetch the remainder of fab images
        action.setParams({"recordId": cmp.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();//gets state of callback to respond to
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();//Retrieves the ContentNote's List of Strings
                //Set each variable for the Note input into the Text Areas by ID
                console.log('@@@' + storeResponse + '@@@');
                cmp.set("v.imageList", storeResponse);
            }
        });
        $A.enqueueAction(action);
    },
    
    getTheSOP: function(cmp){
        var action = cmp.get("c.fetchTheAuraSOP");//creates the action of fetching the SOP, then dropping it
        action.setParams({"recordId": cmp.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();//gets state of callback to respond to
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();//Retrieves the ContentNote's List of Strings
                //Set each variable for the Note input into the Text Areas by ID
                cmp.set("v.droppedSOP", storeResponse);
            }else{
                console.log(response.getError());
            }
        });
        $A.enqueueAction(action);
    },
    
    getModels: function(cmp){
        var action = cmp.get("c.fetchModelImages");//creates an action to get the model images
        action.setParams({"recordId": cmp.get("v.recordId"),
                          "returnImages": 'true'});
        action.setCallback(this, function(response) {
            var state = response.getState();//gets state of callback to respond to
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();//Retrieves the ContentNote's List of Strings
                //Set each variable for the Note input into the Text Areas by ID
                cmp.set("v.modelImages", storeResponse);
            }
        });
        $A.enqueueAction(action);
    },
    
    publishFAB: function(cmp){
       var action = cmp.get("c.publishFAB");//Creates an action to publish the fab
        action.setParams({"recordId": cmp.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();//gets state of callback to respond to
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");//creates a toast event. Toasters toast toast.
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The FAB has been published successfully."
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);  
    },
    
    createNotes: function(cmp, codes, what, why, compatibility){
        var action = cmp.get("c.createContentNote");//creates an action to get content Notes
        action.setParams({"recordId": cmp.get("v.recordId"),
                          "title": "Data Codes",
                          "noteBody": codes});
        action.setCallback(this, function(response) {
            var state = response.getState();//gets state of callback to respond to
            if (state === "SUCCESS") {
                var action = cmp.get("c.createContentNote");//creates an action to get further related notes
                action.setParams({"recordId": cmp.get("v.recordId"),
                                  "title": "What is it?",
                                  "noteBody": what});
                action.setCallback(this, function(response) {
                    var state = response.getState();//gets state of callback to respond to
                    if (state === "SUCCESS") {
                        var action = cmp.get("c.createContentNote");//creates an action to get further related notes
                        action.setParams({"recordId": cmp.get("v.recordId"),
                                          "title": "Why is it important?",
                                          "noteBody": why});
                        action.setCallback(this, function(response) {
                            var state = response.getState();//gets state of callback to respond to
                            if (state === "SUCCESS") {
                                var action = cmp.get("c.createContentNote");//creates an action to get further related notes
                                action.setParams({"recordId": cmp.get("v.recordId"),
                                                  "title": "High-Level Compatibility",
                                                  "noteBody": compatibility});
                                action.setCallback(this, function(response) {
                                    var state = response.getState();//gets state of callback to respond to
                                    if (state === "SUCCESS") {
                                        var toastEvent = $A.get("e.force:showToast");//creates a toast event. Toasters toast toast.
                                        toastEvent.setParams({
                                            "title": "Success!",
                                            "message": "The bulletin information has been updated successfully."
                                        });
                                        toastEvent.fire();
                                    }
                                    cmp.set('v.clickedBoolean', false);
                                });
                                $A.enqueueAction(action);
                            }
                        });
                        $A.enqueueAction(action);
                    }
                });
                $A.enqueueAction(action);
            }
        });
        $A.enqueueAction(action);
    }
})