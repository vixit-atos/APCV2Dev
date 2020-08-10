({
    doinit : function(component, event, helper) {
        component.set("v.quoteitem.A85_Code__c" , component.get("v.quote.A85_Code__c"));
        component.set("v.quoteitem.Coverage__c" , 'TRUCK CHASSIS');
        
        var LineitemSrvc = component.find("Lineitemservice");            
        LineitemSrvc.getLineitemData(component.get("v.quoteitem.Coverage__c") , function(result) {
            component.set("v.masterlineitems", result) ;
            var DependentPicklstSrvc = component.find("DependentPicklstSrvc");
            var filterdlineitems;
            var DependentPicklstSrvc = component.find("DependentPicklstSrvc"); 
            DependentPicklstSrvc.getdeplist('ASP_QQ_Line_Item__c','A85_Code__c',component.get("v.quote.A85_Code__c"),"Level__c",function(result) {
                component.set("v.quoteitem.Level__c" , result[0].value); 
            });
            
            DependentPicklstSrvc.getdeplist('ASP_QQ_Line_Item__c','Coverage__c',component.get("v.quoteitem.Coverage__c"),"Model__c",function(result) {
                component.set("v.modellist" , result);
            });
            
            
        });
        
        
    },
    handleChange : function(component, event, helper) {
        var name = event.getSource().get("v.name");
        var value = event.getSource().get("v.value");
        var options = event.getSource().get("v.options");
        var filterdlineitems 
        switch(name) {
            case "Model":
                component.set("v.quoteitem.Group__c" , '');
                component.set("v.packagetype" , '');
                component.set("v.quoteitem.Truck_Coverage_Package_1__c",'');
                component.set("v.quoteitem.Standalone_Package__c" , '');
                component.set("v.quoteitem.Duration_Final__c" , '');
                component.set("v.quoteitem.Standalone_Package_1__c" , '');
                
                component.set("v.quoteitem.Price__c",'');
                var DependentPicklstSrvc = component.find("DependentPicklstSrvc");                
                DependentPicklstSrvc.getdeplist('ASP_QQ_Line_Item__c','Model__c',component.get("v.quoteitem.Model__c"),"Group__c",function(result) {
                    component.set("v.quoteitem.Group__c" , result[0].value);
                    filterdlineitems = helper.filterlineitemlist(component.get("v.masterlineitems"), 'Groups' , component.get("v.quoteitem.Group__c"));
                    component.set("v.grouplineitems" , filterdlineitems); 
                });
                break;
            case "Group__c":
                break;
            case "Level__c":                
                break;
            case "PACKAGE":
                if(value == "PACKAGE"){
                    component.set("v.packagelineitems",helper.filterlineitemlist(component.get("v.grouplineitems"), 'Level' , component.get("v.quoteitem.Level__c")));
                    component.set("v.packagelist", helper.getuniquelabelvalue(component.get("v.packagelineitems") ,'TruckCoveragePackage'));                
                    component.set("v.quoteitem.Duration_Final__c",'');
                    component.set("v.quoteitem.Price__c",'');
                    component.set("v.quoteitem.Truck_Coverage_Package_1__c",'');
                    component.set("v.quoteitem.Standalone_Package__c" , '');
                    component.set("v.quoteitem.Duration_Final__c" , ''); 
                    component.set("v.quoteitem.Standalone_Package_1__c" , '');
                    component.set("v.disableaddbtn" ,true);
                }
                if(value == "STANDALONE")
                { 
                    component.set("v.packagelineitems",helper.filterlineitemlist(component.get("v.grouplineitems"), 'Level' , component.get("v.quoteitem.Level__c")));
                    component.set("v.standalonelist", helper.getuniquelabelvalue(component.get("v.packagelineitems") ,'StandalonePackage'));                
                    component.set("v.quoteitem.Duration_Final__c",'');
                    component.set("v.quoteitem.Price__c",'');
                    component.set("v.quoteitem.Truck_Coverage_Package_1__c",'');
                    component.set("v.quoteitem.Standalone_Package__c" , '');
                    component.set("v.quoteitem.Duration_Final__c" , '');
                    component.set("v.disableaddbtn" ,true);
                }
                break;
            case "StandalonePackage":
                filterdlineitems = helper.filterlineitemlist(component.get("v.packagelineitems"), name , value);                 
                component.set("v.durationlineitems" ,filterdlineitems);
                component.set("v.durationlist", helper.getuniquelabelvalue(filterdlineitems ,'Duration'));
                component.set("v.quoteitem.Duration_Final__c",'');
                component.set("v.quoteitem.Price__c",'');
                component.set("v.disableaddbtn" ,true);
                break;
            case "TruckCoveragePackage":
                filterdlineitems = helper.filterlineitemlist(component.get("v.packagelineitems"), name , value);                
                component.set("v.durationlineitems" ,filterdlineitems);
                component.set("v.durationlist", helper.getuniquelabelvalue(filterdlineitems ,'Duration'));
                component.set("v.quoteitem.Duration_Final__c",'');
                component.set("v.quoteitem.Price__c",'');
                component.set("v.disableaddbtn" ,true);
                
                break;
            case "Duration":
                component.set("v.customduration", false);
                component.set("v.customduration", false);
                component.set("v.createdduration" , false); 
                component.set("v.quoteitem.Months__c" , '');
                component.set("v.quoteitem.Months__c" , '');
                component.set("v.quote.Quote_Type__c" , 'Standard'); 
                filterdlineitems = helper.filterlineitemlist(component.get("v.durationlineitems"), name , value);
                component.set("v.finallineitem",filterdlineitems[0]);                
                component.set("v.quoteitem.Databook_Code__c" , filterdlineitems[0].Name);
                component.set("v.quoteitem.Price__c" , filterdlineitems[0].Price)
                component.set("v.quoteitem.Master_Coverage__c" , filterdlineitems[0].Id);
                component.set("v.quoteitem.Months__c" , filterdlineitems[0].Months);
                component.set("v.quoteitem.Miles__c" , filterdlineitems[0].Miles);
                component.set("v.disableaddbtn",helper.checklineitemadded(component.get("v.quoteitemlist"),'Master_Coverage__c',component.get("v.quoteitem.Master_Coverage__c")));
                
                break;
        }
        helper.mandatorycheck(component);
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
            key: 'Databook_Code__c',
            value: name
        });
        component.set("v.quoteitemlist", updateditemlist);
    } 
})