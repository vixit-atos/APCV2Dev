({
    doinit : function(component, event, helper) {
        
       /* var dutyinfo = "ENGINE"+"     "+"SEVERE"+"                     "+"          "+"SHORT HAUL"+"                   "+"              "+"LONG HAUL                  "+"             "+"EFF LONG HALL\n"+
            "DD5"+"       "+"<10MPG                        "+"      "+"60K annual miles 10.1-11.9MPG  "+"    "+"60K annual miles 12.0MPG\n"+
            "DD8"+"       "+"6.5 MPG                       "+"        "+"60K annual miles 6.5-8.5MPG    "+"      "+"60K annual miles >8.5MPG\n"+
            "DD13"+"     "+"30K annual miles 5MPG"+"    "+"30K-60K annual miles 5.1-5.9MPG"+"   "+"60K annual miles 6.0-6.9MPG"+"    "+">60K annual 7MPG\n"+
            "DD15"+"     "+"30K annual miles 5MPG"+"    "+"30K-60K annual miles 5.1-5.9MPG"+"   "+"60K annual miles 6.0-6.9MPG"+"    "+">60K annual 7MPG\n"+
            "DD16"+"     "+"30K annual miles 5MPG"+"    "+"30K-60K annual miles 5.1-5.9MPG"+"   "+"60K annual miles 6.0-6.9MPG\n";
        
        // "Efficient Long Haul is xx miles/Km per year.\nLong Haul is xx miles/Km per year.\nOn-Highway is xx miles/Km per year.\nSevere is xx miles/Km per year.\nShort Haul is xx miles/Km per year.";
        component.set("v.dutyinfo" , dutyinfo);
        var pminfo = "PM1 includes basic services.\nPM2 includes PM1 and additional services.\nPM3 includes everything in PM1 and PM2, additional services, and allows add-ons to be purchased.\nPM1 and PM2 do not allow add-on purchases.";
        component.set("v.pminfo" , pminfo);*/
        var LineitemSrvc = component.find("Lineitemservice");            
        LineitemSrvc.getLineitemData('Package', function(result) {
            component.set("v.masterlineitems", result) ;
            component.set("v.enginemodellist" ,helper.getuniquelabelvalue(result ,'Engine_Model__c'));
            
        });  
        LineitemSrvc.getLineitemData('Add-On', function(result) {
            component.set("v.addonlist", result) ;
            //alert(JSON.stringify(result));
        });  
    },
    UpdateCustomer : function(component, event, helper) {
        component.set("v.quote.Customer_Name__c", event.getSource().get("v.value"))
    },
    handlechange : function(component, event, helper) {
        
        var name = event.getSource().get("v.name");
        var value = event.getSource().get("v.value");
        var options = event.getSource().get("v.options");
        var filterdlineitems ;
        
        switch(name) {
            case "Engine_Model__c":
                component.set("v.quoteitem.Duty_Cycle__c",'');
                component.set("v.quoteitem.Duration__c" , '');
                component.set("v.quoteitem.Air_Filter__c",'');
                component.set("v.quoteitem.Package__c",'');
                component.set("v.pricelist",'');
                component.set('v.severemessage' , '');
                filterdlineitems = helper.filterlineitemlist(component.get("v.masterlineitems"), name , value);                 
                component.set("v.enginemodelitems" ,filterdlineitems);
                component.set("v.dutycycleList", helper.getuniquelabelvalue(filterdlineitems ,'Duty_Cycle__c'));
                var addon_enginemodel = helper.filterlineitemlist(component.get("v.addonlist"), name , value);
                component.set("v.addonfor_engine" ,addon_enginemodel );
                component.set("v.quoteitem.Price__c" , '');
                component.set("v.durationList" , '');
                // alert(JSON.stringify(addon_enginemodel));
                break;
            case "Duty_Cycle__c":
                if(value === 'Severe'){
                    component.set('v.severemessage' , 'Please contact ASPhelp@daimler.com if you require a quote for severe duty cycle..');
                    component.set("v.quoteitem.Price__c" , '');
                    
                }
                else{
                    component.set("v.serviceintervallist",'');
                    filterdlineitems = helper.filterlineitemlist(component.get("v.enginemodelitems"), name , value);                 
                    component.set("v.dutylineitems" ,filterdlineitems);
                    component.set("v.packagelist", helper.getuniquelabelvalue(filterdlineitems ,'Package__c'));
                    component.set('v.severemessage' , '');
                    component.set("v.quoteitem.Duration__c" , '');
                    component.set("v.quoteitem.Air_Filter__c",'');
                    component.set("v.quoteitem.Package__c",'');
                    component.set("v.pricelist",'');
                    component.set("v.quoteitem.Price__c" , '');
                    component.set("v.durationList" , '');    
                }
                break;
            case "Package__c":
                //component.set("v.pricelist",'');
                component.set("v.quoteitem.Price__c" , '');
                component.set("v.serviceintervallist",'');
                component.set("v.quoteitem.Duration__c",'');
                component.set("v.quoteitem.Air_Filter__c",'');
                component.set("v.durationList",[]);
                if(component.get("v.quoteitem.Package__c") == 'PM3'){
                    filterdlineitems = helper.filterlineitemlist(component.get("v.dutylineitems"), name , value);                 
                    component.set("v.servicelineitem" ,filterdlineitems);
                    component.set("v.AirFilterList", helper.getuniquelabelvalue(filterdlineitems ,'Air_Filter_Type__c'));
                    component.set("v.quoteitem.Air_Filter__c",'');
                }
                else{
                    filterdlineitems = helper.filterlineitemlist(component.get("v.dutylineitems"), name , value);                 
                    component.set("v.durationlineitems" ,filterdlineitems);
                    //component.set("v.durationList", helper.getuniquelabelvalue(filterdlineitems ,'Name')); 
                    component.set("v.durationList", helper.getuniquelabelvalue(filterdlineitems ,'Duration__c'));                     
                }
                break;
            case "Air_Filter_Type__c":
                component.set("v.pricelist",'');
                component.set("v.serviceintervallist",'');
                component.set("v.quoteitem.Duration__c" , '');
                filterdlineitems = helper.filterlineitemlist(component.get("v.servicelineitem"), name , value); 
                //alert(JSON.stringify(filterdlineitems));                
                component.set("v.durationlineitems" ,filterdlineitems);
                //component.set("v.durationList", helper.getuniquelabelvalue(filterdlineitems ,'Name'));
                component.set("v.durationList", helper.getuniquelabelvalue(filterdlineitems ,'Duration__c'));                     
                break;
                
            case "Duration__c":
                filterdlineitems = helper.filterlineitemlist(component.get("v.durationlineitems"), name , value);                 
                component.set("v.pricelineitem" ,filterdlineitems);
                component.set("v.pricelist", helper.getuniquelabelvalue(filterdlineitems ,'Price__c'));               
                component.set("v.serviceintervallineitem" ,filterdlineitems);
                component.set("v.serviceintervallist", helper.getuniquelabelvalue(filterdlineitems ,'Service_Interval__c'));
                window.setTimeout(
                    $A.getCallback(function() {
                        component.set("v.quoteitem.Price__c" , filterdlineitems[0].Price__c);
                    }), 500
                );
                
                component.set("v.quoteitem.Offer_Master_Id__c" , filterdlineitems[0].Id);
                //component.set("v.quoteitem.Databook_Code__c" , filterdlineitems[0].Databook_Code__c);
                component.set("v.quoteitem.Duration__c" , filterdlineitems[0].Duration__c);
                component.set("v.quoteitem.Databook_Code__c" , filterdlineitems[0].Name);
                component.set("v.quoteitem.Program__c" , 'PACKAGE');
                component.set("v.disableaddbtn",helper.checklineitemadded(component.get("v.quoteitemlist"),'Offer_Master_Id__c',component.get("v.quoteitem.Offer_Master_Id__c"))); 
                var servicelist = component.get("v.ServiceList");
                var distanceinterval = filterdlineitems[0].Service_Int_Miles__c;
                var timeinterval = filterdlineitems[0].Service_Int_Months__c;
                helper.getofferservice(component.get("v.quoteitem.Offer_Master_Id__c") , component);
                // component.set("v.servicelisttable" ,helper.createservicetable(component.get("v.ServiceList") ,distanceinterval,timeinterval ));
                // alert(JSON.stringify(component.get("v.servicelisttable")));
                //component.set("v.ServiceList" , servicelist)
                break;
        }
        
    },
    addquoteitem : function(component, event, helper) {
        component.set("v.quoteitem.Total_Price__c" , component.get("v.quoteitem.Price__c"));        
        var itemList = component.get("v.quoteitemlist");
        var quoteobj = JSON.parse(JSON.stringify(component.get("v.quoteitem")));
        itemList.push(quoteobj);        
        component.set("v.quoteitemlist" , itemList ); 
        component.set("v.disableaddbtn",helper.checklineitemadded(component.get("v.quoteitemlist"),'Offer_Master_Id__c',component.get("v.quoteitem.Offer_Master_Id__c"))); 
        // alert('test')
    },
    removequoteitem : function(component, event, helper) {
        var name = event.getSource().get("v.name");       
        var updateditemlist = helper.removeByKey(component.get("v.quoteitemlist"), {
            key: 'Offer_Master_Id__c',
            value: name
        });
        component.set("v.quoteitemlist", updateditemlist);
        component.set("v.disableaddbtn",helper.checklineitemadded(component.get("v.quoteitemlist"),'Offer_Master_Id__c',component.get("v.quoteitem.Offer_Master_Id__c"))); 
        
    },
    addAddON : function(component, event, helper) {
        var name = event.getSource().get("v.name");
        var list = component.get("v.enableaddonlist");
        var obj = {};
        obj['Id'] = name;
        list.push(obj);
        component.set("v.enableaddonlist" , list);
    },
    UpdatePckgprice : function(component, event, helper) {
        var quoteitemlist = component.get("v.quoteitemlist");
        var addonitem = component.get("v.addonitems");
        var itemlist = [];
        quoteitemlist.forEach(function(item){
            var pckgaddon = helper.filterlineitemlist(addonitem,'Offer_Master_Id__c' , item['Offer_Master_Id__c']);
            var addontotal = pckgaddon.reduce(function(prev, cur) {
                return prev + cur.Price__c;
            }, 0);            
            item.Total_Price__c = item.Price__c + addontotal;
            itemlist.push(item); 
        });
        component.set("v.quoteitemlist" , itemlist);  
    },
    include_addon : function(component, event, helper)
    { 
        var name = event.getSource().get("v.name");
        var list = component.get("v.showaddonlist");
        var obj = {};
        obj['Id'] = name;
        list.push(obj);
        component.set("v.showaddonlist" , list);
    }
})