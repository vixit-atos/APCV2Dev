({
     doInit : function(component, event, helper) {
        var Cid = component.get("v.recordId");
        component.set("v.CaseId",Cid);
         console.log('Cid: ' + Cid);
        var action = component.get("c.fetchLookUpValues");  
        action.setParams({            
            caseId: component.get("v.CaseId")
        });  
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();               
            }
            debugger;
            console.log('storeResponse@@'+storeResponse);
            component.set("v.listOfSearchRecords", storeResponse);
            //Console.log('Values rec'+listOfSearchRecords);
        }); 
        $A.enqueueAction(action);
    },
    SaveCaseAgent : function (component, event, helper) {
        var Cid = component.get("v.recordId");
        var selectedcompVal = component.get("v.SelectedVal");
        console.log('test@@@@'+selectedcompVal);
        if(selectedcompVal != '--None--'){
            var action = component.get("c.saveAgent");
            
            action.setParams({
                'caseid': Cid,
                'AgentId': selectedcompVal
            });
            action.setCallback(this, function(response) {
                var state = response.getState();  
                if (state === "SUCCESS") {
                    $A.get('e.force:refreshView').fire();
                    component.set("v.isOpen" , false);                   
                }
                else if (state === "INCOMPLETE") {
                    //alert('Dhruvil');
                }
                    else if (state === "ERROR") {
                         //alert('Dhruvil');
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    title: "Error!",
                                    message:"Error message: " + errors[0].message,
                                    type: "error"});
                                toastEvent.fire();
                                
                                //alert("Error message: " + errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                    }
            });
            $A.enqueueAction(action);
        }
        //var AgentId = (component.get("v.selectedLookUpRecord").Id).substring(0,15);
        
    },
    itemsChange : function(component, event, helper) {  
      //  alert(JSON.stringify(component.get("v.caserecord")))
        let refpartno = component.get("v.caserecord.Ref_Part_No__c");
        if(refpartno != null){
            component.set("v.refpartno_split" ,helper.find_space(refpartno));
        }
        let partno = component.get("v.caserecord.Product2__r.Name");
        let partid = component.get("v.caserecord.Product2__c");
        component.set('v.parturl','/lightning/r/'+ partid + '/view');
        //alert(partno);
        if(partno != null){
            component.set("v.partno_split" ,helper.find_space(partno));
        }
	},
    refresh : function(component, event, helper) {
        component.set("v.showspinner" , true);
        component.find('recordLoader').reloadRecord(true , function(){component.set("v.showspinner" , false)}); 
        
        $A.get('e.force:refreshView').fire();
    },
    closeRecord : function(component, event, helper) {        
        component.set("v.isOpen" , false);
    },
    editRecord : function(component, event, helper) {
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": component.get("v.recordId")
        });
        editRecordEvent.fire();
        
       
    },
    createTemplate : function(component, event, helper){
        component.find('showModal').showChildModal(true);
    },    
    assignagent : function(component, event, helper) {       
        component.set("v.isOpen" , true);
    },    
    handleRecordUpdated: function(component, event, helper) {
      if(component.get("v.caserecord.RecordType.Name") == 'Parts Pricing'){
    var eventParams = event.getParams();
    if(eventParams.changeType === "CHANGED") {
        // get the fields that changed for this record
        var changedFields = eventParams.changedFields;
        console.log('Fields that are changed: ' + JSON.stringify(changedFields));
        // record is changed, so refresh the component (or other component logic)
        var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "title": "Saved",
            "message": "The record was updated."
        });
       resultsToast.fire();

    } else if(eventParams.changeType === "LOADED") {
      //  console.log("account loaded:::::" + component.get("v.simpleRecord"));
        // record is loaded in the cache
    } else if(eventParams.changeType === "REMOVED") {
        // record is deleted and removed from the cache
    } else if(eventParams.changeType === "ERROR") {
        // there’s an error while loading, saving or deleting the record
    }
      }}
      
})