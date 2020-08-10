({
	fetchData: function (component, numberOfRecords) {
        var dataPromise;
        var recordID = component.get("v.recordId");
        var action = component.get("c.getAttachmentList");
        
        action.setParams({ "currendRecID" : recordID });        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
              component.set("v.data", response.getReturnValue());
            } 
            else {
              console.log(state);
            }
        });

        /*dataPromise = component.get("c.getAttachmentList");;
        dataPromise.then(function(results) {
            component.set('v.data', results);
        });*/
    }
})