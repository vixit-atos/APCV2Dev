({
    doInit : function(component, event, helper) 
    {
        var recordType = "TRUCK CHASSIS";
        var UI_Type = "EXTERNAL";
        
        component.set("v.quoteitem.A85_Code__c", component.get("v.quote.A85_Code__c"));
        component.set("v.quoteitem.Coverage__c", recordType);
        
        var DependentPicklstSrvc = component.find("DependentPicklstSrvc"); 
        DependentPicklstSrvc.getdeplist("ASP_QQ_Line_Item__c", "A85_Code__c", component.get("v.quote.A85_Code__c"), "Level__c", function(result) {
            component.set("v.quoteitem.Level__c", result[0].value);
            
            //------------------  POPULATING EXTENDED COVERAGE ITEMS  ---------------
            helper.getQQ_Master(component, recordType, UI_Type);
            
            //------------------  POPULATING CHASSIS MODEL  -------------------------
            helper.getModel(component);
        });
    }, 
    
    handleChange : function(component, event, helper)
    {
        var name = event.getSource().get("v.name");
        var value = event.getSource().get("v.value");
        if(value == "None")
            value = null;
        var options = event.getSource().get("v.options");
        var disableAdd = true;        
        var filterdlineitems;
                        
        switch(name)
        {
            case "Model":
                component.set("v.quoteitem.Group__c", "");
                component.set("v.packagetype", "");
                component.set("v.packagelist", []);
                component.set("v.quoteitem.Truck_Coverage_Package_1__c", "");
                component.set("v.standalonelist", []);
                component.set("v.quoteitem.Standalone_Package_1__c", "");
                component.set("v.durationlist", []);
                component.set("v.quoteitem.Duration_Final__c", "");
                component.set("v.quoteitem.Months__c", "");
                component.set("v.quoteitem.Miles__c", "");
                component.set("v.finalDuration", "");
                component.set("v.quoteitem.Price__c", "");
                
                //------------------  POPULATING GROUP  -------------------------
                var engineModel = value;
                helper.setGroup(component, engineModel);
                break;
                
            case "Group__c":
                break;
                
            case "Level__c":                
                break;
                
            case "PACKAGE":
                if(value == "PACKAGE")
                {
                    component.set("v.packagelist", []);
                    component.set("v.quoteitem.Truck_Coverage_Package_1__c", "");
                    component.set("v.durationlist", []);
                    component.set("v.quoteitem.Duration_Final__c", "");
                    component.set("v.quoteitem.Months__c", "");
                    component.set("v.quoteitem.Miles__c", "");
                    component.set("v.finalDuration", "");
                    component.set("v.quoteitem.Price__c", "");

                    //------------------  POPULATING PACKAGE  -------------------------
                    component.set("v.packagelineitems", helper.filterlineitemlist(component.get("v.grouplineitems"), "Level", component.get("v.quoteitem.Level__c")));
                    component.set("v.packagelist", helper.getuniquelabelvalue(component.get("v.packagelineitems"), "TruckCoveragePackage"));

                    //component.set("v.disableaddbtn", true);
                }
                if(value == "STANDALONE")
                { 
                    component.set("v.standalonelist", []);
                    component.set("v.quoteitem.Standalone_Package_1__c", "");
                    component.set("v.durationlist", []);
                    component.set("v.quoteitem.Duration_Final__c", "");
                    component.set("v.quoteitem.Months__c", "");
                    component.set("v.quoteitem.Miles__c", "");
                    component.set("v.finalDuration", "");
                    component.set("v.quoteitem.Price__c", "");
                    
                    //------------------  POPULATING STANDALONE  -------------------------
                    component.set("v.packagelineitems", helper.filterlineitemlist(component.get("v.grouplineitems"), "Level", component.get("v.quoteitem.Level__c")));
                    component.set("v.standalonelist", helper.getuniquelabelvalue(component.get("v.packagelineitems"), "StandalonePackage"));
                    
                    //component.set("v.disableaddbtn", true);
                }
                break;
                
            case "TruckCoveragePackage":
                component.set("v.durationlist", []);
                component.set("v.quoteitem.Duration_Final__c", "");
                component.set("v.finalDuration", "");
                component.set("v.quoteitem.Months__c", "");
                component.set("v.quoteitem.Miles__c", "");
                component.set("v.quoteitem.Price__c", "");
                
                component.set("v.quoteitem.Standalone_Package_1__c", "");
                component.set("v.quoteitem.Truck_Coverage_Package_1__c", value);
                
                //------------------  POPULATING DURATION  -------------------------
                filterdlineitems = helper.filterlineitemlist(component.get("v.packagelineitems"), name, value);                
                component.set("v.durationlineitems", filterdlineitems);
                component.set("v.durationlist", helper.getuniquelabelvalue(filterdlineitems, "Duration"));
                
                //component.set("v.disableaddbtn", true);                
                break;
                
            case "StandalonePackage":
                component.set("v.durationlist", []);
                component.set("v.quoteitem.Duration_Final__c", "");
                component.set("v.finalDuration", "");
                component.set("v.quoteitem.Months__c", "");
                component.set("v.quoteitem.Miles__c", "");
                component.set("v.quoteitem.Price__c", "");
                
                component.set("v.quoteitem.Standalone_Package_1__c", value);
                component.set("v.quoteitem.Truck_Coverage_Package_1__c", "");
                
                //------------------  POPULATING DURATION  -------------------------
                filterdlineitems = helper.filterlineitemlist(component.get("v.packagelineitems"), name, value);                 
                component.set("v.durationlineitems", filterdlineitems);
                component.set("v.durationlist", helper.getuniquelabelvalue(filterdlineitems, "Duration"));
                
                //component.set("v.disableaddbtn", true);
                break;
                
            case "Duration":
                component.set("v.customduration", false);
                component.set("v.customduration", false);
                component.set("v.createdduration", false); 
                component.set("v.quoteitem.Months__c", "");
                component.set("v.quoteitem.Miles__c", "");
                component.set("v.quote.Quote_Type__c", "Standard");
                component.set("v.quoteitem.Custom__c", false);
                
                filterdlineitems = helper.filterlineitemlist(component.get("v.durationlineitems"), name, value);
                
                /*alert("finallineitem: " + JSON.stringify(filterdlineitems[0]));
                alert("Record ID: " + filterdlineitems[0].Id);
                alert("Databook Code: " + filterdlineitems[0].Name);
                alert("Months: " + filterdlineitems[0].Months);
                alert("Miles: " + filterdlineitems[0].Miles);
                alert("Price: " + filterdlineitems[0].Price)
                alert("Duration: " + value);*/
                
                component.set("v.finallineitem", filterdlineitems[0]);
                component.set("v.quoteitem.Master_Coverage__c", filterdlineitems[0].Id);
                component.set("v.quoteitem.Databook_Code__c", filterdlineitems[0].Name);
                component.set("v.quoteitem.Months__c", filterdlineitems[0].Months);
                component.set("v.quoteitem.Miles__c", filterdlineitems[0].Miles);
                component.set("v.quoteitem.Price__c", filterdlineitems[0].Price);
                component.set("v.quoteitem.Duration_Final__c", value);
                component.set("v.quote.Duration_Final__c", value);
                component.set("v.finalDuration", value);
                
                disableAdd = helper.checklineitemadded(component.get("v.quoteitemlist"), "Master_Coverage__c", component.get("v.quoteitem.Master_Coverage__c"));
                //component.set("v.disableaddbtn", helper.checklineitemadded(component.get("v.quoteitemlist"), "Master_Coverage__c", component.get("v.quoteitem.Master_Coverage__c")));
                break;
        }
        helper.mandatorycheck(component);
        component.set("v.disableaddbtn", disableAdd);
    }, 
    
    addquoteitem : function(component, event, helper) 
    {
        var itemList = component.get("v.quoteitemlist"); 
        var quoteobj = JSON.parse(JSON.stringify(component.get("v.quoteitem")));
        itemList.push(quoteobj);        
        component.set("v.quoteitemlist", itemList ); 
        component.set("v.disableaddbtn", true);
    }, 
    
    removequoteitem : function(component, event, helper) 
    {
        var name = event.getSource().get("v.name");       
        var updateditemlist = helper.removeByKey(component.get("v.quoteitemlist"), {
            key: "Databook_Code__c", 
            value: name
        });
        component.set("v.quoteitemlist", updateditemlist);
    } 
})