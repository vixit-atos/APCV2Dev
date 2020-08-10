({
    doInit : function(component, event, helper) 
    {
        var recordType = "DETROIT COVERAGE";
        var UI_Type = "EXTERNAL";
        
        component.set("v.quoteitem.A85_Code__c", component.get("v.quote.A85_Code__c"));
        component.set("v.quoteitem.Coverage__c", recordType);
        
        var DependentPicklstSrvc = component.find("DependentPicklstSrvc");                
        DependentPicklstSrvc.getdeplist("ASP_QQ_Line_Item__c", "A85_Code__c", component.get("v.quote.A85_Code__c"), "Usage__c", function(result) {
            if(result.length > 1) 
            {
                component.set("v.usageoptions", result)
            }
            else
            {
                component.set("v.usageoptions", []);
                component.set("v.quoteitem.Usage__c", result[0].value);
            }
            if(component.get("v.quoteitem.Usage__c"))
            {
                //------------------  POPULATING EXTENDED COVERAGE ITEMS  ---------------
                helper.getQQ_Master(component, recordType, UI_Type);
            }
        });
    }, 
    
    handleChange : function(component, event, helper) 
    {
        var recordType = "DETROIT COVERAGE";
        var UI_Type = "EXTERNAL";
        
        var name = event.getSource().get("v.name");
        var value = event.getSource().get("v.value");
        if(value == "None")
            value = null;
        var options = event.getSource().get("v.options");
        component.set("v.disableAdd", true);
        var disableAdd = true;
        var filterdlineitems;
        
        switch(name) 
        {
            case "Usage":
                component.set("v.componentoptions", []);
                component.set("v.quoteitem.Engine_Component_1__c", "");
                component.set("v.Coveragetypeoptions", []);
                component.set("v.quoteitem.Coverage_Type_1__c", "");
                component.set("v.optionslist", []);
                component.set("v.quoteitem.Option_1__c", "");
                component.set("v.deductiblelist", []);
                component.set("v.quoteitem.Deductible_1__c", "");
                component.set("v.durationlist", []);
                component.set("v.quoteitem.Duration_Final__c", "");
                component.set("v.quoteitem.Months__c", "");
                component.set("v.quoteitem.Miles__c", "");
                component.set("v.finalDuration", "");
                component.set("v.errorMessage", "");
                component.set("v.quoteitem.Price__c", "");
                
                //component.set("v.quoteitem.Usage__c", value);
                //------------------  POPULATING EXTENDED COVERAGE ITEMS  ---------------
                helper.getQQ_Master(component, recordType, UI_Type);
                
                //helper.autohandlechange(0, filterdlineitems, component);               
                break;
                
            case "EngineComponent":
                component.set("v.Coveragetypeoptions", []);
                component.set("v.quoteitem.Coverage_Type_1__c", "");
                component.set("v.optionslist", []);
                component.set("v.quoteitem.Option_1__c", "");
                component.set("v.deductiblelist", []);
                component.set("v.quoteitem.Deductible_1__c", "");
                component.set("v.durationlist", []);
                component.set("v.quoteitem.Duration_Final__c", "");
                component.set("v.quoteitem.Months__c", "");
                component.set("v.quoteitem.Miles__c", "");
                component.set("v.finalDuration", "");
                component.set("v.errorMessage", "");
                component.set("v.quoteitem.Price__c", "");
                
                if(value === "DD13 HT")
                {
                    component.set("v.errorMessage", "Please contact ASPhelp@daimler.com if you require a quote for DD13 High Torque engines.");
                    var fieldorderarray = component.get("v.fieldorder");
                    fieldorderarray.forEach(function(item, indx){
                        if(indx > 0)  
                        {
                            component.set(item["options"], []); 
                            component.set("v.quoteitem." + item["setfieldname"], ""); 
                        }
                    });                    
                }
                else
                {
                    //------------------  POPULATING COVERAGE TYPE  -------------------------
                    //component.set("v.quoteitem.Engine_Component_1__c", value);
                    filterdlineitems = helper.filterlineitemlist(component.get("v.usagelineitems"), name, value);
                    component.set("v.complineitems", filterdlineitems);
                    //var uniqueoption = helper.getuniquelabelvalue(filterdlineitems, "CoverageType");
                    //component.set("v.Coveragetypeoptions", uniqueoption);
                    
                    helper.autohandlechange(1, filterdlineitems, component);
                }
                
                //component.set("v.disableaddbtn", true);
                break;
                
            case "CoverageType":
                component.set("v.optionslist", []);
                component.set("v.quoteitem.Option_1__c", "");
                component.set("v.deductiblelist", []);
                component.set("v.quoteitem.Deductible_1__c", "");
                component.set("v.durationlist", []);
                component.set("v.quoteitem.Duration_Final__c", "");
                component.set("v.quoteitem.Months__c", "");
                component.set("v.quoteitem.Miles__c", "");
                component.set("v.finalDuration", "");
                component.set("v.errorMessage", "");
                component.set("v.quoteitem.Price__c", "");
                
                //------------------  POPULATING OPTION  -------------------------
                //component.set("v.quoteitem.Coverage_Type_1__c", value);
                filterdlineitems = helper.filterlineitemlist(component.get("v.complineitems"), name, value);
                component.set("v.cvrgtypelineitems", filterdlineitems);
                //var uniqueoption = helper.getuniquelabelvalue(filterdlineitems, "Option");
                //component.set("v.optionslist", uniqueoption);
                
                helper.autohandlechange(2, filterdlineitems, component);
                //component.set("v.disableaddbtn", true);
                break;
                
            case "Option":
                component.set("v.deductiblelist", []);
                component.set("v.quoteitem.Deductible_1__c", "");
                component.set("v.durationlist", []);
                component.set("v.quoteitem.Duration_Final__c", "");
                component.set("v.quoteitem.Months__c", "");
                component.set("v.quoteitem.Miles__c", "");
                component.set("v.finalDuration", "");
                component.set("v.errorMessage", "");
                component.set("v.quoteitem.Price__c", "");
                
                //------------------  POPULATING DURATION  -------------------------
                //component.set("v.quoteitem.Option_1__c", value);
                filterdlineitems = helper.filterlineitemlist(component.get("v.cvrgtypelineitems"), name, value);
                component.set("v.optionslineitems", filterdlineitems);
                //var uniqueoption = helper.getuniquelabelvalue(filterdlineitems, "Deductible");
                //component.set("v.deductiblelist", uniqueoption);
                
                helper.autohandlechange(3, filterdlineitems, component);
                //component.set("v.disableaddbtn", true);
                break;
                
            case "Deductible":
                component.set("v.durationlist", []);
                component.set("v.quoteitem.Duration_Final__c", "");
                component.set("v.quoteitem.Months__c", "");
                component.set("v.quoteitem.Miles__c", "");
                component.set("v.finalDuration", "");
                component.set("v.errorMessage", "");
                component.set("v.quoteitem.Price__c", "");
                
                //------------------  POPULATING DURATION  -------------------------
                //component.set("v.quoteitem.Deductible_1__c", value);
                filterdlineitems = helper.filterlineitemlist(component.get("v.optionslineitems"), name, value);
                component.set("v.durationlineitems", filterdlineitems);
                //var uniqueoption = helper.getuniquelabelvalue(filterdlineitems, "Duration");
                //component.set("v.durationlist", uniqueoption);
                
                helper.autohandlechange(4, filterdlineitems, component);
                break;
                
            case "Duration":
                component.set("v.errorMessage", "");                    
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
        if(!component.get("v.disableAdd"))
            component.set("v.disableaddbtn", false);
        else
            component.set("v.disableaddbtn", disableAdd);
    }, 
    
    addquoteitem : function(component, event, helper) 
    {
        var itemList = component.get("v.quoteitemlist"); 
        var quoteobj = JSON.parse(JSON.stringify(component.get("v.quoteitem")));
        itemList.push(quoteobj); 
        component.set("v.disableaddbtn", helper.checklineitemadded(component.get("v.quoteitemlist"), "Master_Coverage__c", component.get("v.quoteitem.Master_Coverage__c")));
        
        component.set("v.quoteitemlist", itemList);        
    }, 
    
    removequoteitem : function(component, event, helper)
    {
        var name = event.getSource().get("v.name");       
        var updateditemlist = helper.removeByKey(component.get("v.quoteitemlist"), {
            key: "Databook_Code__c", 
            value: name
        });
        component.set("v.disableaddbtn", helper.checklineitemadded(component.get("v.quoteitemlist"), "Master_Coverage__c", component.get("v.quoteitem.Master_Coverage__c")));
        
        component.set("v.quoteitemlist", updateditemlist);
    } 
})