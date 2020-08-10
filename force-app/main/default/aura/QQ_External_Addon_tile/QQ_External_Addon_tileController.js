({
    doinit : function(component, event, helper) {
        //alert(JSON.stringify(component.get("v.addonitems")));
        var addonname = component.get("v.addonname");
        if(addonname == 'Air Filter')
        {
            var pkgairfilter = component.get("v.airfilter");
            //alert(pkgairfilter);
            var airfilteroption = [{ "label":pkgairfilter , "value":pkgairfilter }];
            component.set("v.typeoptions" , airfilteroption);
        }
        else{
        var servicelist = component.get("v.servicelist");  
        // alert(JSON.stringify(servicelist))
        
        var typefound = servicelist.filter(function(element) {
            return element['addon'] === addonname;
        });
        component.set("v.typeoptions" , helper.getuniquelabelvalue(typefound, 'type'));
        }
    },
    
    handlechange : function(component, event, helper) {
        var name = event.getSource().get("v.name");
        var value = event.getSource().get("v.value");
        var addonname = component.get("v.addonname");
        switch(name){
            case 'type':
                var servicelist = component.get("v.servicelist");
                var servicefound = servicelist.find(function(element) {
                    return element['addon'] === addonname && element['type'] === value;
                });
                component.set("v.servicetypeselected" , servicefound['list']);
                component.set('v.serviceoption' , helper.getuniquelabelvalue(servicefound['list'], 'service'));
                component.set("v.addonitem.Price__c" , '') ;
                break;
            case 'service':
                var value = event.getSource().get("v.value");
                var servicetypeselected = component.get("v.servicetypeselected");
                var item = servicetypeselected.find(function(element) {
                    return element['service'] === value; 
                });
                component.set("v.addonitem.Price__c" , item.Price__c) ;
                //RA PH II - SPRINT II
                component.set("v.addonitem.Databook_Code__c" , item.Name);
             //   component.set("v.addonitem.Databook_Code__c" , item.Databook_Code__c);
                break;
        }},
    saveaddon : function(component, event, helper) {
        var addonitems = component.get("v.addonitems"); 
        
        component.set("v.addonitem.Offer_Master_Id__c" , component.get("v.offermasterid"));
        component.set("v.addremove",false);
        var addonname = component.get("v.addonname");
        component.set("v.addonitem.Add_On__c" , addonname) ;
        addonitems.push(component.get("v.addonitem"));
        component.set("v.addonitems" ,addonitems );         
    },
    removeaddon : function(component, event, helper) {
        component.set("v.addremove",true)
        var addonname = component.get("v.addonname");
        var emptyobject = JSON.parse(JSON.stringify(component.get("v.emptyitem")));
        var updateditemlist = helper.removeByKey(component.get("v.addonitems"), {
            key: 'Add_On__c',
            value: addonname
        });
        component.set("v.addonitems", updateditemlist);
        component.set("v.addonitem" , emptyobject )
        //alert(component.get("v.addonitems").length);
    }    
    
})