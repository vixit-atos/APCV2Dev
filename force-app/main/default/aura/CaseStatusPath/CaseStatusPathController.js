({
    handleSelect : function (component, event, helper) {
        //get selected Status value
        var selectStatus = event.getParam("detail").value;
         //set selected Status value
        component.set("v.picklistField.Status", selectStatus);
       
         
        component.find("record").saveRecord($A.getCallback(function(response) {
           try {
                       if (response.state === "SUCCESS") {
                        $A.get('e.force:refreshView').fire();
                        component.find('notifLib').showToast({
                            "variant": "success",
                            "message": "Record was updated sucessfully"
                        });
                    } else {
                        const res = response.getReturnValue()
                        if (res.startsWith('Error')) {
                            console.error('Apex '+res)
                        }
                        component.find('notifLib').showToast({
                            "variant": "error",
                            "message": "There was a problem updating the record."
                        });
                    }
          } catch(e) { 
            console.error('init apex callback: '+e)
          }
        }));
    }
})