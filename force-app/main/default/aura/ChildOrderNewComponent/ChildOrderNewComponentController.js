({
    doInit : function(component, event, helper) {
        component.set("v.orderRecord.Material",component.get("v.orderRecord.Material").replace(/ /g, "&nbsp;"));
    },
    actionChanged : function(component, event, helper) {
        console.log("changed");
        component.getEvent("caseToCreateFromOrderRecord").setParams({
            detail: {
                orderRecord: component.get("v.orderRecord")
            }
        }).fire();
        /*var CAction = event.getSource().get('v.value');
        var PN = component.get('v.PartNumber');
        var OS = component.get('v.OrderStatus');
        var PON = component.get('v.PONumber');
        var OD = component.get('v.OriginalDelivery');
        var PDC = component.get('v.PDC');
        var SC = component.get('v.ShippingCondition');
        var TN = component.get('v.TrackingNumber');
        var AI = component.get('v.AddInfo');
        console.log(CAction+' '+component.get('v.AddInfo')+' '+component.get('v.PartNumber'));
        var ae = $A.get('e.c:OrderComponentEven');
        ae.setParams({'Action':CAction});
        ae.setParams({'PartNumber':PN});
        ae.setParams({'OrderStatus':OS});
        ae.setParams({'PONumber':PON});
        ae.setParams({'OriginalDelivery':OD});
        ae.setParams({'PDC':PDC});
        ae.setParams({'SC':SC});
        ae.setParams({'TN':TN});
        ae.setParams({'AI':AI});
        ae.fire();*/
    },
    // deprecated method - have to change
    goToCase : function(component, event, helper) {
        $A.get("e.force:navigateToSObject").setParams({
            "recordId": event.currentTarget.dataset.id
        }).fire();
    },     
})