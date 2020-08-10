({
    doInit : function(component) {
        var action = component.get("c.getPickListValuesIntoList");
        action.setParams({
            objectType: component.get("v.sObjectName"),
            selectedField: component.get("v.fieldName")
        });
        action.setCallback(this, function(response) {
            var list = response.getReturnValue();
            var fieldNames = [];
        	list.forEach(function(item) {
                var listobj = {};
            	listobj.label=item;
                listobj.value=item;
                fieldNames.push(listobj);
        	});
            component.set("v.picklistValues", fieldNames);
		            
        })
        $A.enqueueAction(action);
    }
})