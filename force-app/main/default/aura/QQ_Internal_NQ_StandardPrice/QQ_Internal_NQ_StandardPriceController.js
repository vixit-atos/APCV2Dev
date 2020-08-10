({
    doInit : function(component, event, helper) 
    {
        var stdpricesrvc= component.find("standardpriceservice");
        //var id =  component.get("v.quoteitem").Id ; 
        stdpricesrvc.getstandardprice(component.get("v.quoteid"), function(result) {
            // alert(JSON.stringify(result));
            component.set("v.pricelist", result);            
        });
    }, 
    
    handlecheck : function(component, event, helper) 
    {
        var priceid = event.getSource().get("v.value");
        component.set("v.selectedmasterid", priceid );
        helper.upd_curr_price_DBcode_lineitem(component);
    }, 
    
    editmaster : function(component, event, helper)
    {
        var title = event.getSource().get("v.title"); 
        var masterid = event.getSource().get("v.name"); 
        var oldobj = helper.finditem(component.get("v.pricelist"), "Id", masterid);
        // component.set("v.olddbcode", oldobj.Databook_Code__c);
        component.set("v.editid", masterid);
        switch(title)
        {
            case "Edit Databook Code":
                component.set("v.enableDBedit", true);
                break;
            case "Edit Price":
                component.set("v.enablePriceedit", true);
                break;
        }        
    }, 
    
    updatemaster : function(component, event, helper) 
    {        
        var masterid = event.getSource().get("v.name"); 
        var updatedpricelist = component.get("v.pricelist") ; 
        var priceitem = updatedpricelist.find(function(item) {
            return item.Id == masterid;
        });
        //alert(JSON.stringify(priceitem));
        var mastersrvc = component.find("masterupdatesrvc");
        mastersrvc.updatemaster(priceitem.Id, priceitem.Price__c, priceitem.Name, function(result){
            component.set("v.enableDBedit", false);
            component.set("v.enablePriceedit", false);
            //alert(JSON.stringify(result));
        });
        
        if(component.get("v.selectedmasterid"))
        {
            helper.upd_curr_price_DBcode_lineitem(component);
        }
    }, 
    
    cancelmaster : function(component, event, helper) 
    {
        component.set("v.enableDBedit", false);
        component.set("v.enablePriceedit", false);
        var stdpricesrvc= component.find("standardpriceservice");
        stdpricesrvc.getstandardprice(component.get("v.quoteid"), function(result) {
            component.set("v.pricelist", result);   
        });
    }
})