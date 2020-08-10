({
	doInit: function(component, event, helper) {
        component.set("v.globalid",component.getGlobalId());
        var obj = component.get("v.record");
        
        var field = component.get("v.fieldname");  
        var record = [];
        field.forEach(function(item) {
            var data = {};
            data.label = item.label;
            data.value = obj[item.Field];
            record.push(data);
		});
        component.set("v.recorddata",record); 
	},
    onCheck: function(component, event, helper) {
        var checkCmp = component.find("checkbox");
        var recordid = event.getSource().get("v.name");
        var checkvalue = event.getSource().get("v.checked");
        var checkevent = $A.get("e.c:QQ_rowcheckevent");
        checkevent.setParams(
            {"recordid" : recordid ,
             "checkvalue" : checkvalue }
        );
        checkevent.fire();
   },
    quotenumclicked :function(component, event, helper) {
        component.set("v.openpopup" , true);
        component.set("v.showpreview" , true);
        //var record = component.get("v.record");
      /*  var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef  : "c:QQ_Internal_ApprovalPopup" ,
            componentAttributes : {
                quoteid : record.Id,
                quotestatus :record.Status,
                quotenum : record.Name,
                openpopup : true 
            }
            });
		//	evt.fire();*/

        var cmpTarget = component.find('externalmodal');
       // var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
       // $A.util.addClass(cmpBack, 'slds-backdrop--open'); 
    }
})