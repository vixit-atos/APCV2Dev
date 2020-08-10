({
	removeobjectpropertyval : function(array,fieldname,fieldvalue) 
    {
        var updatedarray = array.filter(function(item){
            return item[fieldname] != fieldvalue; 
        });
        return updatedarray;  
	},
    
    getFMVDate : function(component)
    {
        var action = component.get("c.getFMVDate");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS")
            {
                var result =  response.getReturnValue();
                component.set("v.quote.FMV_Date__c", result);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    getExpDate : function(component)
    {
        var action = component.get("c.getExpDate");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS")
            {
                var result =  response.getReturnValue();
                component.set("v.quote.Expiration_Date__c", result);
            }
        });
        
        $A.enqueueAction(action);
    }
})