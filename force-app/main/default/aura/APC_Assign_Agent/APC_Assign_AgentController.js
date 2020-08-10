({
	init : function(component, event, helper) {
       
    },
    closequickaction: function(component, event, helper) {
    $A.get("e.force:closeQuickAction").fire() 
    }
})