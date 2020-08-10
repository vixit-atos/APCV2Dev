({
    doinit : function(component, event, helper) {
        /*var dutyinfo = "Efficient Long Haul is xx miles/Km per year.\nLong Haul is xx miles/Km per year.\nOn-Highway is xx miles/Km per year.\nSevere is xx miles/Km per year.\nShort Haul is xx miles/Km per year.";
        component.set("v.dutyinfo" , dutyinfo);*/
        var LineitemSrvc = component.find("Lineitemservice");            
        LineitemSrvc.getLineitemData('ATS', function(result) {
            component.set("v.masterlineitems", result) ;
            component.set("v.EngineModelList" ,helper.getuniquelabelvalue(result ,'Engine_Model__c'));
            //alert(JSON.stringify(result));
        });  
    },
    handlechange : function(component, event, helper) {
        var name = event.getSource().get("v.name");
        var value = event.getSource().get("v.value");
        var options = event.getSource().get("v.options");
        var filterdlineitems ;
        
        switch(name) {
            case "Engine_Model__c":
                component.set("v.quoteitem.Duration__c" , '');
                component.set("v.quoteitem.Duty_Cycle__c",'');
                component.set("v.quoteitem.ATS_Service__c",'');
                component.set("v.quoteitem.Price__c" , '');
                component.set("v.quoteitem.Offer_Master_Id__c" , '');
                filterdlineitems = helper.filterlineitemlist(component.get("v.masterlineitems"), name , value);                 
                component.set("v.enginemodelitems" ,filterdlineitems);
                component.set("v.dutycycleList", helper.getuniquelabelvalue(filterdlineitems ,'Duty_Cycle__c'));
                break;
            case "Duty_Cycle__c":
                component.set("v.pricelist",'');
                component.set("v.quoteitem.Price__c" , '');
                component.set("v.quoteitem.Offer_Master_Id__c" , '');
                component.set("v.quoteitem.Duration__c" , '');
                filterdlineitems = helper.filterlineitemlist(component.get("v.enginemodelitems"), name , value);                 
                component.set("v.atsservicelineitems" ,filterdlineitems);
                component.set("v.atsservice", helper.getuniquelabelvalue(filterdlineitems ,'ATS_Service__c'));
                break;
            case "ATS_Service__c":
                component.set("v.pricelist",'');
                component.set("v.quoteitem.Price__c" , '');
                component.set("v.quoteitem.Offer_Master_Id__c" , '');
                component.set("v.quoteitem.Duration__c" , '');
                filterdlineitems = helper.filterlineitemlist(component.get("v.enginemodelitems"), name , value);                 
                component.set("v.atsservicelineitems" ,filterdlineitems);
                component.set("v.durationList", helper.getuniquelabelvalue(filterdlineitems ,'Duration__c'));
                break;
            case "Duration__c":
                filterdlineitems = helper.filterlineitemlist(component.get("v.atsservicelineitems"), name , value);
                
               /* component.set("v.pricelineitem" ,filterdlineitems);
                component.set("v.pricelist", helper.getuniquelabelvalue(filterdlineitems ,'Price__c'));               
                component.set("v.serviceintervallineitem" ,filterdlineitems);
                component.set("v.serviceintervallist", helper.getuniquelabelvalue(filterdlineitems ,'Service_Interval__c')); */
                
                component.set("v.quoteitem.Price__c", filterdlineitems[0].Price__c);
                component.set("v.quoteitem.Total_Price__c", filterdlineitems[0].Price__c);
                component.set("v.quoteitem.Duration__c", filterdlineitems[0].Duration__c);
                component.set("v.quoteitem.Offer_Master_Id__c", filterdlineitems[0].Id);
                component.set("v.quoteitem.Databook_Code__c", filterdlineitems[0].Name);
                component.set("v.quoteitem.Program__c" , 'ATS');
                helper.getofferservice(component.get("v.quoteitem.Offer_Master_Id__c") , component);
                                
                // component.set("v.disableaddbtn",helper.checklineitemadded(component.get("v.quoteitemlist"),'Offer_Master_Id__c',component.get("v.quoteitem.Offer_Master_Id__c"))); 
                break;
        }
        component.set("v.disableaddbtn",helper.checklineitemadded(component.get("v.quoteitemlist"),'Offer_Master_Id__c',component.get("v.quoteitem.Offer_Master_Id__c"))); 
        
    },
    addquoteitem : function(component, event, helper) {
        var itemList = component.get("v.quoteitemlist"); 
        var quoteobj = JSON.parse(JSON.stringify(component.get("v.quoteitem")));
        itemList.push(quoteobj);        
        component.set("v.quoteitemlist" , itemList ); 
        component.set("v.disableaddbtn",true);
    },
    removequoteitem : function(component, event, helper) {
        var name = event.getSource().get("v.name");       
        var updateditemlist = helper.removeByKey(component.get("v.quoteitemlist"), {
            key: 'Offer_Master_Id__c',
            value: name
        });
        component.set("v.quoteitemlist", updateditemlist);
    } 
})