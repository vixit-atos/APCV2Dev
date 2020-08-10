({
    doinit : function(component, event, helper) {
        var LineitemSrvc = component.find("Lineitemservice");            
        LineitemSrvc.getLineitemData('Transmission', function(result) {
            component.set("v.masterlineitems", result) ;
            component.set("v.manufacturelist" ,helper.getuniquelabelvalue(result ,'Manufacturer__c'));
            //alert(JSON.stringify(result));
        });  
    },
    handlechange : function(component, event, helper) {
        var name = event.getSource().get("v.name");
        var value = event.getSource().get("v.value");
        var options = event.getSource().get("v.options");
        var filterdlineitems ;
        switch(name) {
            case "Manufacturer__c":
                component.set("v.quoteitem.Transmission_Model__c",'');
                component.set("v.quoteitem.Name",'');
                component.set("v.quoteitem.Duty_Cycle__c",'');
                component.set("v.pricelist",'');
                component.set("v.quoteitem.Duration__c" , '');
                component.set("v.quoteitem.Price__c" , '');
                component.set("v.quoteitem.Offer_Master_Id__c" , '');
                filterdlineitems = helper.filterlineitemlist(component.get("v.masterlineitems"), name , value);                 
                component.set("v.manufacturelineitem" ,filterdlineitems);
                component.set("v.transmissionmodellist", helper.getuniquelabelvalue(filterdlineitems ,'Transmission_Model__c'));
                
                break;
            case "Transmission_Model__c":
                component.set("v.quoteitem.Name",'');
                component.set("v.quoteitem.Duty_Cycle__c",'');
                component.set("v.pricelist",'');
                component.set("v.quoteitem.Duration__c" , '');
                component.set("v.quoteitem.Price__c" , '');
                component.set("v.quoteitem.Offer_Master_Id__c" , '');                
                filterdlineitems = helper.filterlineitemlist(component.get("v.manufacturelineitem"), name , value);                 
                component.set("v.dutylineitems" ,filterdlineitems);
                component.set("v.durationList", helper.getuniquelabelvalue(filterdlineitems ,'Duration__c'));                
                break;            
            case "Duration__c":
                filterdlineitems = helper.filterlineitemlist(component.get("v.dutylineitems"), name , value); 
                component.set("v.quoteitem.Offer_Master_Id__c" , filterdlineitems[0].Id) ;
                component.set("v.quoteitem.Duration__c" , filterdlineitems[0].Duration__c);
                component.set("v.quoteitem.Price__c" , filterdlineitems[0].Price__c);
                component.set("v.quoteitem.Total_Price__c" , filterdlineitems[0].Price__c);
                component.set("v.quoteitem.Program__c" , 'TRANSMISSION');
                component.set("v.quoteitem.Offer_Master_Id__c" , filterdlineitems[0].Id);
                component.set("v.quoteitem.Databook_Code__c" , filterdlineitems[0].Name);
                helper.getofferservice(component.get("v.quoteitem.Offer_Master_Id__c") , component);
               	break;       
        }
     component.set("v.disableaddbtn",helper.checklineitemadded(component.get("v.quoteitemlist"),'Offer_Master_Id__c',component.get("v.quoteitem.Offer_Master_Id__c"))); 
                   
    },
    addquoteitem : function(component, event, helper) {
        var itemList = component.get("v.quoteitemlist"); 
        var quoteobj = JSON.parse(JSON.stringify(component.get("v.quoteitem")));
        itemList.push(quoteobj);        
        component.set("v.quoteitemlist" , itemList ); 
       	component.set("v.disableaddbtn",helper.checklineitemadded(component.get("v.quoteitemlist"),'Offer_Master_Id__c',component.get("v.quoteitem.Offer_Master_Id__c"))); 
            
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