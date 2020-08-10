({
    doInit : function(component, event, helper)
    {
        var QuoteNum = component.get("v.QuoteNum");
        if(QuoteNum != "")
        {
            var action1 = component.get("c.getQuickQuote");
            action1.setParams({"QuoteNum":QuoteNum});
            action1.setCallback(this, function(response){
                var state = response.getState();            
                //alert(state);
                if(state === 'SUCCESS'){
                    var resultData = response.getReturnValue();
                    component.set("v.quote", resultData);
                    //alert(resultData.pbName);
                }else if (state === 'ERROR'){
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }else{
                    console.log('Something went wrong, Please check with your admin');
                }
            });
            
            var action2 = component.get("c.getLineItem");
            action2.setParams({"QuoteNum":QuoteNum});
            action2.setCallback(this, function(response){
                var state = response.getState();            
                //alert(state);
                if(state === 'SUCCESS'){
                    var resultData = response.getReturnValue();
                    component.set("v.quoteitem", resultData);
                    //alert(resultData.pbName);
                }else if (state === 'ERROR'){
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }else{
                    console.log('Something went wrong, Please check with your admin');
                }
            });
            $A.enqueueAction(action1);
            $A.enqueueAction(action2);
        }
    },
    
    handleChange : function(component, event, helper)
    {
        var name = event.getSource().get("v.name");
        var value = event.getSource().get("v.value");
        var options = event.getSource().get("v.options");
        var saveFlag = false;
        
        //alert("Name: " + name + ", Value: " + value + ", Option: " + JSON.stringify(options));
        var filterdlineitems 
        switch(name) {
            case "A85 CODE":
                component.set("v.quoteitem" , {'sobjectType': 'ASP_QQ_Line_Item__c'});
                component.set("v.packagetype" , '');
                var DependentPicklstSrvc = component.find("DependentPicklstSrvc");                
                DependentPicklstSrvc.getdeplist('ASP_QQ_Line_Item__c','A85_Code__c',component.get("v.quote.A85_Code__c"),"Coverage__c",function(result) {
                    component.set("v.CoverageOptions" , result);
                });                
                break;
            case "Coverage__c":
                //alert(value);
                component.set("v.quoteitem" , {'sobjectType': 'ASP_QQ_Line_Item__c'});
                component.set("v.quoteitem.A85_Code__c" , component.get("v.quote.A85_Code__c"));
                component.set("v.quoteitem.Coverage__c" , value);
                component.set("v.quote.Coverage__c" , value);
                
                var LineitemSrvc = component.find("Lineitemservice");            
                LineitemSrvc.getLineitemData(value , function(result) {
                    component.set("v.masterlineitems", result) ;
                    var DependentPicklstSrvc = component.find("DependentPicklstSrvc");
                    if(component.get("v.quoteitem.Coverage__c") == 'DETROIT COVERAGE')
                    {
                        DependentPicklstSrvc.getdeplist('ASP_QQ_Line_Item__c','A85_Code__c',component.get("v.quote.A85_Code__c"),"Usage__c",function(result) {
                            
                            if(result.length > 1) 
                            {
                                component.set("v.usageoptions" , result)
                            }
                            else{
                                component.set("v.usageoptions" , []);
                                component.set("v.quoteitem.Usage__c" , result[0].value);
                            }
                            if(component.get("v.quoteitem.Usage__c"))
                            {
                                
                                filterdlineitems = helper.filterlineitemlist(component.get("v.masterlineitems"), 'Usage__c' ,component.get("v.quoteitem.Usage__c"));
                                component.set("v.usagelineitems" ,filterdlineitems );
                                component.set("v.componentoptions" ,helper.getuniquelabelvalue(filterdlineitems ,'Engine_Component__c'));
                            }
                        });
                    }
                    else
                    {
                        
                        DependentPicklstSrvc.getdeplist('ASP_QQ_Line_Item__c','A85_Code__c',component.get("v.quote.A85_Code__c"),"Level__c",function(result) {
                            component.set("v.quoteitem.Level__c" , result[0].value);
                            
                        });
                        var DependentPicklstSrvc = component.find("DependentPicklstSrvc");                
                        DependentPicklstSrvc.getdeplist('ASP_QQ_Line_Item__c','Coverage__c',component.get("v.quoteitem.Coverage__c"),"Model__c",function(result) {
                            component.set("v.modellist" , result);
                        });
                        
                    }
                    /*  component.set("v.Coveragetypeoptions",[]);
                    component.set("v.optionslist",[]);
                    component.set("v.durationlist",[]);
                    component.set("v.finallineitem",[]);  */                   
                    
                    
                });
                break;
            case "Usage__c":
                filterdlineitems = helper.filterlineitemlist(component.get("v.masterlineitems"), name , value)
                component.set("v.usagelineitems" ,filterdlineitems);                 
                helper.autohandlechange(0,filterdlineitems,component);
                component.set("v.quoteitem.Price__c",'');        
                break; 
            case "EngineComponent":                
                filterdlineitems = helper.filterlineitemlist(component.get("v.usagelineitems"), name , value)
                component.set("v.complineitems" ,filterdlineitems );
                helper.autohandlechange(1,filterdlineitems,component);
                break;
            case "Coverage_Type__c":
                if(component.get("v.quoteitem.Coverage_Type__c")== 'Ext Clutch','Ext Transmission'){
                    filterdlineitems = helper.filterlineitemlist(component.get("v.complineitems"), name , value)
                    component.set("v.deductiblelineitems" ,filterdlineitems );
                    component.set("v.deductiblelist", helper.getuniquelabelvalue(filterdlineitems ,'Deductible__c')); 
                    //component.set("v.quoteitem.Duration_Final__c",'');
                    //component.set("v.quoteitem.Deductible__c",'');
                    //component.set("v.durationlist" , []);
                    component.set("v.quoteitem.Deductible__c" , component.get("v.deductiblelist")[0].value);    
                    component.set("v.quoteitem.Duration_Final__c",'');
                    
                    filterdlineitems = helper.filterlineitemlist(component.get("v.deductiblelineitems"), 'Deductible__c' , component.get("v.quoteitem.Deductible__c"));
                    component.set("v.durationlineitems" ,filterdlineitems );
                    component.set("v.durationlist", helper.getuniquelabelvalue(filterdlineitems ,'Name'));
                }
                else{
                    filterdlineitems = helper.filterlineitemlist(component.get("v.complineitems"), name , value)
                    component.set("v.optionslist", helper.getuniquelabelvalue(filterdlineitems ,'Option__c'));
                    component.set("v.cvrgtypelineitems" ,filterdlineitems );
                    component.set("v.durationlist",[]);
                    component.set("v.finallineitem",[]);
                    component.set("v.quoteitem.Option__c",'');
                    component.set("v.quoteitem.Duration_Final__c",'');
                    component.set("v.quoteitem.Deductible__c",'');}
                break;
            case "Option__c":
                filterdlineitems = helper.filterlineitemlist(component.get("v.cvrgtypelineitems"), name , value)
                component.set("v.deductiblelineitems" ,filterdlineitems );
                component.set("v.deductiblelist", helper.getuniquelabelvalue(filterdlineitems ,'Deductible__c'));                 
                component.set("v.finallineitem",[]);
                // component.set("v.durationlineitems",[]);
                if(component.get("v.deductiblelist").length == 1){
                    //alert(JSON.stringify(component.get("v.deductiblelist")[0]))
                    component.set("v.quoteitem.Deductible__c" , component.get("v.deductiblelist")[0].value);
                    filterdlineitems = helper.filterlineitemlist(component.get("v.deductiblelineitems"), 'Deductible__c' , component.get("v.quoteitem.Deductible__c"));
                    component.set("v.durationlineitems" ,filterdlineitems );
                    component.set("v.durationlist", helper.getuniquelabelvalue(filterdlineitems ,'Name'));
                }
                component.set("v.quoteitem.Duration_Final__c",'');
                break;
            case "Deductible__c":
                filterdlineitems = helper.filterlineitemlist(component.get("v.deductiblelineitems"), name , value)
                component.set("v.durationlineitems" ,filterdlineitems );
                component.set("v.durationlist", helper.getuniquelabelvalue(filterdlineitems ,'Name'));                   	
                component.set("v.finallineitem",[]);
                component.set("v.quoteitem.Duration_Final__c",'');
                break;
            case "Model__c":
                component.set("v.quoteitem.Group__c" , '');
                component.set("v.packagetype" , '');
                component.set("v.quoteitem.Truck_Coverage_Package__c",'');
                component.set("v.quoteitem.Standalone_Package__c" , '');
                component.set("v.quoteitem.Duration_Final__c" , '');                
                component.set("v.quoteitem.Standalone_Coverage__c" , '');
                component.set("v.quoteitem.Price__c",'');
                var DependentPicklstSrvc = component.find("DependentPicklstSrvc");                
                DependentPicklstSrvc.getdeplist('ASP_QQ_Line_Item__c','Model__c',component.get("v.quoteitem.Model__c"),"Group__c",function(result) {
                    component.set("v.quoteitem.Group__c" , result[0].value);
                    filterdlineitems = helper.filterlineitemlist(component.get("v.masterlineitems"), 'Group__c' , component.get("v.quoteitem.Group__c"));
                    component.set("v.grouplineitems" , filterdlineitems);
                    
                    
                    if(component.get("v.quoteitem.Coverage__c") == "FCCC"){
                        component.set("v.packagetype" , component.get("v.FCCCpackagetypelist")[0].value ) ; 
                        component.set("v.packagelineitems",helper.filterlineitemlist(component.get("v.grouplineitems"), 'Level__c' , component.get("v.quoteitem.Level__c")));
                        component.set("v.standalonelist", helper.getuniquelabelvalue(component.get("v.packagelineitems") ,'Standalone_Package__c'));                
                    }
                });
                break;
            case "Group__c":
                break;
            case "Level__c":                
                break;
            case "Package":
                if(value == "PACKAGE"){
                    component.set("v.packagelineitems",helper.filterlineitemlist(component.get("v.grouplineitems"), 'Level__c' , component.get("v.quoteitem.Level__c")));
                    component.set("v.packagelist", helper.getuniquelabelvalue(component.get("v.packagelineitems") ,'Truck_Coverage_Package__c'));  
                    
                }
                if(value == "STANDALONE")
                {
                    
                    component.set("v.packagelineitems",helper.filterlineitemlist(component.get("v.grouplineitems"), 'Level__c' , component.get("v.quoteitem.Level__c")));
                    component.set("v.standalonelist", helper.getuniquelabelvalue(component.get("v.packagelineitems") ,'Standalone_Package__c'));                
                    
                }
                component.set("v.quoteitem.Truck_Coverage_Package__c",'');
                component.set("v.quoteitem.Standalone_Package__c" , '');
                component.set("v.quoteitem.Duration_Final__c" , '');                
                component.set("v.quoteitem.Standalone_Coverage__c" , '');
                component.set("v.quoteitem.Price__c",'');
                break;
            case "Standalone_Package__c":
                filterdlineitems = helper.filterlineitemlist(component.get("v.packagelineitems"), name , value);                 
                component.set("v.durationlineitems" ,filterdlineitems);
                component.set("v.durationlist", helper.getuniquelabelvalue(filterdlineitems ,'Name'));
                break;
            case "Truck_Coverage_Package__c":
                filterdlineitems = helper.filterlineitemlist(component.get("v.packagelineitems"), name , value);                
                component.set("v.durationlineitems" ,filterdlineitems);
                component.set("v.durationlist", helper.getuniquelabelvalue(filterdlineitems ,'Name'));
                break;
            case "Name":
                component.set("v.customduration", false);
                component.set("v.customduration", false);
                component.set("v.createdduration" , false); 
                component.set("v.quoteitem.Months__c" , '');
                component.set("v.quoteitem.Months__c" , '');
                component.set("v.quote.Quote_Type__c" , 'Standard');
                component.set("v.quoteitem.Pricing_Type__c" , 'Standard');
                filterdlineitems = helper.filterlineitemlist(component.get("v.durationlineitems"), name , value);
                component.set("v.finallineitem",filterdlineitems[0]);
                component.set("v.quoteitem.Months__c" , filterdlineitems[0].Months__c);
                component.set("v.quoteitem.Miles__c" , filterdlineitems[0].Miles__c);
                component.set("v.quoteitem.Price__c", filterdlineitems[0].Price__c);
                component.set("v.quoteitem.Duration_Final__c", filterdlineitems[0].Name);
                component.set("v.quote.Duration_Final__c", filterdlineitems[0].Name); 
                break;
        }
        helper.mandatorycheck(component);
        
        var appEvent = $A.get("e.c:QQ_App_Event");
        appEvent.setParams({
            "saveFlag" : saveFlag
        });
        appEvent.fire();
    },
    
    createduration : function(component, event, helper) 
    {
        component.set("v.quote.Quote_Type__c" , 'Custom');
        component.set("v.quoteitem.Pricing_Type__c" , 'Custom'); // Bug Id :123
        component.set("v.quoteitem.Databook_Code__c" , 'Custom Quote'); 
        component.set("v.quoteitem.Price__c" , ''); 
        component.set("v.createdduration" , true);
        var custommonth = component.get("v.quoteitem.Months__c");
        var custommiles_K = Math.round(component.get("v.quoteitem.Miles__c")/1000,0);
        var customkm_K = Math.round(custommiles_K * 1.6 , 0);
        var customduration = custommonth.toString() + " mo /" + custommiles_K.toString() + "k mi /"  + customkm_K.toString() + "k km";
        component.set("v.quoteitem.Duration_Final__c", customduration); 
        component.set("v.quote.Duration_Final__c",customduration);
        helper.mandatorycheck(component);
    },
    
    editduration : function(component, event, helper)
    {
        component.set("v.createdduration" , false);
    },
    
    editCoverage : function(component, event, helper) 
    {
        component.set("v.openpopup" , true);
    },
    
    editform: function(component, event, helper) 
    {
        component.set("v.editmode" , true);
    },
    
    saveform :function(component, event, helper)
    {
        component.set("v.editmode" , false)  ;
    }    
})