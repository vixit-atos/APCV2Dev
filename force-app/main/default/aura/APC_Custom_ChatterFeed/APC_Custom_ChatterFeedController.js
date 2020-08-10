({
	doInit : function(component, event, helper) {    
	helper.fetchcasefeed(component, event, helper);
	},
    toggleSection : function(component, event, helper) {
        debugger;
        var sectionAuraId = event.target.getAttribute("data-auraId");
        var sectionDiv = document.getElementById(sectionAuraId); // component.find(sectionAuraId).getElement();        
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open'); 
        if(sectionState == -1){
            sectionDiv.setAttribute('class' , 'slds-section slds-is-open');
        }else{
            sectionDiv.setAttribute('class' , 'slds-section slds-is-close');
        }
    }
})