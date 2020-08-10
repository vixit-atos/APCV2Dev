({
    doinit : function(component, event, helper) {
        component.set("v.quoteitem.A85_Code__c" , component.get("v.quote.A85_Code__c"));
        var LineitemSrvc = component.find("Lineitemservice");            
        LineitemSrvc.getLineitemData(component.get("v.quoteitem.Coverage__c") , function(result) {
            component.set("v.masterlineitems", result) ;
            
            var DependentPicklstSrvc = component.find("DependentPicklstSrvc");
            var filterdlineitems;
            
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
                    
                    filterdlineitems = helper.filterlineitemlist(component.get("v.masterlineitems"), 'Usage' ,component.get("v.quoteitem.Usage__c"));
                    component.set("v.usagelineitems" ,filterdlineitems );
                    component.set("v.componentoptions" ,helper.getuniquelabelvalue(filterdlineitems ,'EngineComponent'));
                }
            });  
        });
    },
    handleChange : function(component, event, helper) {
        var name = event.getSource().get("v.name");
        var value = event.getSource().get("v.value");
        if(value == 'None'){
            value = null;
        }
        var options = event.getSource().get("v.options");
        var filterdlineitems
        var saveFlag = false;
        
        switch(name) {
            case "A85 Code":
                component.set("v.quoteitem.A85_Code__c" , component.get("v.quote.A85_Code__c"));
                component.set("v.quoteitem.Coverage__c" , '');
                component.set("v.Coveragetypeoptions",[]);
                component.set("v.optionslist",[]);
                component.set("v.durationlist",[]);
                component.set("v.finallineitem",[]);
                component.set("v.quoteitem.Coverage_Type_1__c",'');
                component.set("v.quoteitem.Option_1__c",'');
                component.set("v.quoteitem.Duration_Final__c",'')
                var DependentPicklstSrvc = component.find("DependentPicklstSrvc");                
                DependentPicklstSrvc.getdeplist('ASP_QQ_Line_Item__c','A85_Code__c',component.get("v.quote.A85_Code__c"),"Coverage__c",function(result) {
                    component.set("v.CoverageOptions" , result);
                });                
                break;
            case "Coverage__c":
                component.set("v.quoteitem.Coverage__c" , value);
                var LineitemSrvc = component.find("Lineitemservice");            
                LineitemSrvc.getLineitemData(component.get("v.quoteitem.Coverage__c") , function(result) {
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
                                component.set("v.componentoptions" ,helper.getuniquelabelvalue(filterdlineitems ,'Engine_Component_1__c'));
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
                    component.set("v.Coveragetypeoptions",[]);
                    component.set("v.optionslist",[]);
                    component.set("v.durationlist",[]);
                    component.set("v.finallineitem",[]); 
                    component.set('v.errorMessage' , '');
                    component.set("v.quoteitem.Engine_Component_1__c",'');
                    component.set("v.quoteitem.Coverage_Type_1__c",'');
                    component.set("v.quoteitem.Option_1__c",'');
                    component.set("v.quoteitem.Duration_Final__c",'');
                    component.set("v.quoteitem.Model__c",'')
                    component.set("v.quoteitem.Deductible_1__c" , '');
                    component.set("v.quoteitem.Level__c",'')
                    component.set("v.quoteitem.Level__c",'')
                });
                break;
            case "Usage":
                filterdlineitems = helper.filterlineitemlist(component.get("v.masterlineitems"), name , value)
                component.set("v.usagelineitems" ,filterdlineitems);                 
                helper.autohandlechange(0,filterdlineitems,component);                  
                component.set('v.errorMessage' , '');
                component.set("v.quoteitem.Price__c",'');                
                break; 
            case "EngineComponent":                
                filterdlineitems = helper.filterlineitemlist(component.get("v.usagelineitems"), name , value)
                component.set("v.complineitems" ,filterdlineitems );
                helper.autohandlechange(1,filterdlineitems,component);                
                component.set("v.quoteitem.Price__c",'');               
                break;
            case "CoverageType": 
                filterdlineitems = helper.filterlineitemlist(component.get("v.complineitems"), name , value);
                component.set("v.cvrgtypelineitems" ,filterdlineitems );
                helper.autohandlechange(2,filterdlineitems,component);
                component.set("v.quoteitem.Price__c",'');
                break;
            case "Option":
                filterdlineitems = helper.filterlineitemlist(component.get("v.cvrgtypelineitems"), name , value);
                component.set("v.optionslineitems" ,filterdlineitems );
                helper.autohandlechange(3,filterdlineitems,component);
                break;
            case "Deductible":
                filterdlineitems = helper.filterlineitemlist(component.get("v.deductiblelineitems"), name , value);
                helper.autohandlechange(4,filterdlineitems,component);
                component.set("v.quoteitem.Price__c",'');
                break;
            case "Duration":
                component.set("v.customduration", false);
                component.set("v.customduration", false);
                component.set("v.createdduration" , false); 
                component.set("v.quoteitem.Months__c" , '');
                component.set("v.quoteitem.Months__c" , '');
                component.set("v.quote.Quote_Type__c" , 'Standard');
                component.set("v.quote.Duration_Final__c",value);                
                filterdlineitems = helper.filterlineitemlist(component.get("v.durationlineitems"), name , value);
                component.set("v.finallineitem",filterdlineitems[0]);
                component.set("v.quoteitem.Databook_Code__c" , filterdlineitems[0].Name);
                component.set("v.quoteitem.Price__c" , filterdlineitems[0].Price);
                component.set("v.quoteitem.Master_Coverage__c" , filterdlineitems[0].Id);
                component.set("v.quoteitem.Months__c" , filterdlineitems[0].Months);
                component.set("v.quoteitem.Miles__c" , filterdlineitems[0].Miles);
                
                saveFlag = true;
                break;       
        }
        // helper.mandatorycheck(component);
        
        var appEvent = $A.get("e.c:QQ_App_Event");
        appEvent.setParams({
            "saveFlag" : saveFlag
        });
        appEvent.fire();
    },
    createduration : function(component, event, helper) {
        
        component.set("v.quote.Quote_Type__c" , 'Custom'); 
        component.set("v.quoteitem.Databook_Code__c" , 'Custom Quote'); 
        component.set("v.quoteitem.Price__c" , ''); 
        // component.set("v.createdduration" , true);
        let custommonth = component.get("v.quoteitem.Months__c") ? component.get("v.quoteitem.Months__c") : 0;
        let custommiles = component.get("v.quoteitem.Miles__c") ? component.get("v.quoteitem.Miles__c") : 0;
        let custommiles_K = Math.round(custommiles/1000,0);
        let customkm_K = Math.round(custommiles_K * 1.6 , 0);
        
        let customduration = custommonth.toString() + " mo /" + custommiles_K.toString() + "k mi /"  + customkm_K.toString() + "k km";
        
        component.set("v.quoteitem.Duration_Final__c", customduration); 
        component.set("v.quote.Duration_Final__c",customduration);
        
        var appEvent = $A.get("e.c:QQ_App_Event");
        appEvent.setParams({
            "saveFlag" : true
        });
        appEvent.fire();
    },
    editduration : function(component, event, helper) {
        component.set("v.createdduration" , false);        
    }
})