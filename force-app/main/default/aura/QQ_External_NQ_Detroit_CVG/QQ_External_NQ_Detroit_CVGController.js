({
    doinit : function(component, event, helper) {
        component.set("v.quoteitem.A85_Code__c" , component.get("v.quote.A85_Code__c"));
        component.set("v.quoteitem.Coverage__c" , 'DETROIT COVERAGE');
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
                    if(component.get("v.quoteitem.Coverage__c") == 'Detroit Coverage')
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
                    component.set("v.disableaddbtn" ,true);
                    
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
                if(value === 'DD13 HT'){
                    component.set('v.errorMessage' , 'Please contact ASPhelp@daimler.com if you require a quote for DD13 High Torque engines.');
                    var fieldorderarray = component.get("v.fieldorder");
                    fieldorderarray.forEach(function(item ,indx){
                        if(indx > 0)  {
                            component.set(item["options"] ,[]); 
                            component.set("v.quoteitem." + item["setfieldname"],''); 
                        }
                    });                    
                }
                else{
                    component.set('v.errorMessage' , '');
                    filterdlineitems = helper.filterlineitemlist(component.get("v.usagelineitems"), name , value)
                    component.set("v.complineitems" ,filterdlineitems );
                    helper.autohandlechange(1,filterdlineitems,component);
                    }
                component.set("v.quoteitem.Price__c",'');
               
                component.set("v.disableaddbtn" ,true);
                break;
            case "CoverageType": 
                filterdlineitems = helper.filterlineitemlist(component.get("v.complineitems"), name , value);
                component.set("v.cvrgtypelineitems" ,filterdlineitems );
                helper.autohandlechange(2,filterdlineitems,component);
                component.set("v.quoteitem.Price__c",'');
                component.set("v.disableaddbtn" ,true);
                break;
            case "Option":
                filterdlineitems = helper.filterlineitemlist(component.get("v.cvrgtypelineitems"), name , value);
                component.set("v.optionslineitems" ,filterdlineitems );
                helper.autohandlechange(3,filterdlineitems,component);  
                component.set("v.quoteitem.Price__c",'');
                component.set("v.disableaddbtn" ,true);
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
                filterdlineitems = helper.filterlineitemlist(component.get("v.durationlineitems"), name , value);
                component.set("v.finallineitem",filterdlineitems[0]);
                component.set("v.quoteitem.Databook_Code__c" , filterdlineitems[0].Name);
                component.set("v.quoteitem.Price__c" , filterdlineitems[0].Price);
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
        component.set("v.disableaddbtn",helper.checklineitemadded(component.get("v.quoteitemlist"),'Master_Coverage__c',component.get("v.quoteitem.Master_Coverage__c")));
        
        component.set("v.quoteitemlist" , itemList );        
    },
    removequoteitem : function(component, event, helper) {
        var name = event.getSource().get("v.name");       
        var updateditemlist = helper.removeByKey(component.get("v.quoteitemlist"), {
            key: 'Databook_Code__c',
            value: name
        });
        component.set("v.disableaddbtn",helper.checklineitemadded(component.get("v.quoteitemlist"),'Master_Coverage__c',component.get("v.quoteitem.Master_Coverage__c")));
        
        component.set("v.quoteitemlist", updateditemlist);
    } 
})