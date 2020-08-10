({
    doInit : function(component, event, helper) 
    {
        var recordType = "TRUCK CHASSIS";
        var UI_Type = "INTERNAL";
        
        var duration = component.get("v.quoteitem.Duration_Final__c");
        if(duration != null && duration != undefined && duration != "")
        {
            component.set("v.finalDuration", duration);
            var appEvent = $A.get("e.c:QQ_App_Event");
            appEvent.setParams({
                "saveFlag" : true
            });
            appEvent.fire();
        }
        
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
        //var options = event.getSource().get("v.options");
        
        var filterdlineitems;
        var saveFlag = false;
        //var showDuration = false;
        
        //alert("Name: " + name + ", Value: " + value);
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
                
                //showDuration = true;
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
                
                //showDuration = true;
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
                
                //showDuration = true;
                saveFlag = true;
                break;
        }
        
        helper.mandatorycheck(component);
        
        //component.set("v.showDuration", showDuration);
        var appEvent = $A.get("e.c:QQ_App_Event");
        appEvent.setParams({
            "saveFlag" : saveFlag
        });
        appEvent.fire();
    }, 
    
    createduration : function(component, event, helper) 
    {
        component.set("v.quote.Quote_Type__c", "Custom"); 
        component.set("v.quoteitem.Custom__c", true);
        component.set("v.quoteitem.Databook_Code__c", "Custom Quote"); 
        component.set("v.quoteitem.Price__c", ""); 
        // component.set("v.createdduration", true);
        let custommonth = component.get("v.quoteitem.Months__c") ? component.get("v.quoteitem.Months__c") : 0;
        let custommiles = component.get("v.quoteitem.Miles__c") ? component.get("v.quoteitem.Miles__c") : 0;
        let custommiles_K = Math.round(custommiles/1000, 0);
        let customkm_K = Math.round(custommiles_K * 1.6, 0);
        
        let customduration = custommonth.toString() + " mo /" + custommiles_K.toString() + "k mi /"  + customkm_K.toString() + "k km";
        
        component.set("v.quoteitem.Duration_Final__c", customduration); 
        component.set("v.quote.Duration_Final__c", customduration);
        component.set("v.finalDuration", customduration);
        
        var saveFlag = false;        
        if(component.get("v.quoteitem.Months__c") != "" && component.get("v.quoteitem.Miles__c") != "" && component.get("v.quoteitem.Months__c") != undefined && component.get("v.quoteitem.Miles__c") != undefined)
        {
            saveFlag = true;
        }
        var appEvent = $A.get("e.c:QQ_App_Event");
        appEvent.setParams({
            "saveFlag" : saveFlag
        });
        appEvent.fire();
    },
    
    editduration : function(component, event, helper) 
    {
        component.set("v.createdduration", false);        
    }
})