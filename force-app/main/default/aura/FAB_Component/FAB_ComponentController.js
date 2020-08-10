({
	initializeComponent : function(cmp, event, helper){
        //Gathers Detail info if not a child
        if(cmp.get("v.recordId")){
            helper.getNoteInformation(cmp);
            helper.getImages(cmp);
            helper.getTheSOP(cmp);
            helper.getModels(cmp);
        }
    },
    
    handleUploadFinished: function(cmp, event, helper){
        helper.tagImages(cmp);
        helper.getImages(cmp);
    },
    
    saveFAB: function(cmp, event, helper){
        if(!cmp.get('v.clickedBoolean')){
            cmp.set('v.clickedBoolean', true);
            var codes = cmp.find("codes").get("v.value");//pulls the codes information
            var what = cmp.find("what").get("v.value");//pulls the what is it information
            var why = cmp.find("why").get("v.value");//pulls the why is it improtant information
            var compatibility = cmp.find("compatibility").get("v.value");//pulls the high-level compatibility information
            helper.createNotes(cmp, codes, what, why, compatibility);
        }
    },
    
    print: function(cmp, event,helper){
        var urlString = "/apex/FAB_VF_Page?id=" + cmp.get("v.recordId");//Uses the URL string for redirecting to the Visualforce PDF Page
        var urlEvent = $A.get("e.force:navigateToURL");//Event to fire a redirect to the VF PDF page
        urlEvent.setParams({
            "url": urlString,
            "isredirect": "true"
        });
        urlEvent.fire();
        
    },
    
    publish: function(cmp,helper){
        var action = cmp.get("c.publishFAB");//Action to que publishing the fab and sending through email
        action.setParams({"recordId": cmp.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
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
    }
})