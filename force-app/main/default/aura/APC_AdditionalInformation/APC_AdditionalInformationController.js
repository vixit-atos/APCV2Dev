({
    doInit: function(component, event, helper){
        //helper.getuitheme(component, event, helper); 
        helper.getCase(component, event, helper);        
                    
    },    

    handleUploadFinished: function (component, event, helper) {
        var uploadedFiles = event.getParam("files");
        var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Success!",
                        message:'File uploaded successfully',
                        type: "success"});
                    toastEvent.fire();
        },  
    
    toggleSection : function(component, event, helper) {
        var sectionAuraId = event.target.getAttribute("data-auraId");
        // get section Div element using aura:id
         var sectionDiv = component.find(sectionAuraId).getElement();
        /* The search() method searches for 'slds-is-open' class, and returns the position of the match.
         * This method returns -1 if no match is found.
        */
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open'); 
        
        // -1 if 'slds-is-open' class is missing...then set 'slds-is-open' class else set slds-is-close class to element
        if(sectionState == -1){
            sectionDiv.setAttribute('class' , 'slds-section slds-is-open');
        }else{
            sectionDiv.setAttribute('class' , 'slds-section slds-is-close');
        }
   },

    handleaddrecipient: function(component, event, helper) {
        helper.handleaddrecipient(component, event, helper);
        
    },
    
    onrecipientchange: function(component, event, helper){ 
        var componentchanged = event.getSource().getLocalId();
        helper.checkforvalidrecipient(component, event, helper, componentchanged);
    },
    
   handlerecipientremove: function(component, event, helper){ 
       helper.handleremoverecipient(component, event, helper);     
    },
    
    handleSaveDescriptionData : function(component, event, helper){
        helper.saveDescriptionData(component, event, helper);
    },
    
    handleSaveAdditionalContactsData : function(component, event, helper){
        helper.saveCaseAdditionalContactsData(component, event, helper);
    }
     
})