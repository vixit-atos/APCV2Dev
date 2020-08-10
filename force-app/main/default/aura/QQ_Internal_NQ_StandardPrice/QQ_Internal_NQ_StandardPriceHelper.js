({
    finditem : function(array, keyname, keyvalue) 
    {
        var found = array.find(function(item){
            return item[keyname] == keyvalue;
        });
        return found;
    },
    
    upd_curr_price_DBcode_lineitem : function(component) 
    {
        var priceid = component.get("v.selectedmasterid");
        var pricelist = component.get("v.pricelist");
        var priceitem = pricelist.find(function(item) {
            return item.Id == priceid;
        });
        component.set("v.quoteitem.Databook_Code__c" , priceitem.Name);
        component.set("v.quoteitem.Price__c" , priceitem.Price__c );
        var price = component.get("v.quoteitem.Price__c"); 
        var cost = component.get("v.quoteitem.Cost__c");
        
        var margin = (price - cost)*100/price ;
        //alert(margin.toFixed(2));
        component.set("v.quoteitem.Margin__c" , margin.toFixed(2));
        component.set("v.saved" , true);
    }
})