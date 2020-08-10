({
    doinit : function(component, event, helper) 
    {
        component.set("v.quoteitem.A85_Code__c" , component.get("v.quote.A85_Code__c"));
        component.set("v.quoteitem.Coverage__c" , 'FCCC');
        
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
    handleChange : function(component, event, helper)
    {
        var name = event.getSource().get("v.name");
        var value = event.getSource().get("v.value");
        var options = event.getSource().get("v.options");
        var showDuration = false;
        var saveFlag = false;
        
        var filterdlineitems 
        switch(name) {
            case "Model__c":
                var DependentPicklstSrvc = component.find("DependentPicklstSrvc");                
                DependentPicklstSrvc.getdeplist('ASP_QQ_Line_Item__c','Model__c',component.get("v.quoteitem.Model__c"),"Group__c",function(result) {
                    component.set("v.quoteitem.Group__c" , result[0].value);
                    filterdlineitems = helper.filterlineitemlist(component.get("v.masterlineitems"), 'Groups' , component.get("v.quoteitem.Group__c"));
                    component.set("v.grouplineitems" , filterdlineitems); 
                    component.set("v.quoteitem.Duration_Final__c" ,'');
                    component.set("v.packagetype" ,'');
                    component.set("v.quoteitem.Standalone_Package_1__c" ,'');
                    component.set("v.quoteitem.Price__c" ,'');  
                });
                break;
            case "Group__c":
                break;
            case "Level__c":                
                break;
            case "Package":
                component.set("v.packagelineitems",helper.filterlineitemlist(component.get("v.grouplineitems"), 'Level' , component.get("v.quoteitem.Level__c")));
                component.set("v.standalonelist", helper.getuniquelabelvalue(component.get("v.packagelineitems") ,'StandalonePackage'));                
                component.set("v.quoteitem.Price__c" ,'');
                break;
            case "StandalonePackage":
                filterdlineitems = helper.filterlineitemlist(component.get("v.packagelineitems"), name , value);                 
                component.set("v.durationlineitems" ,filterdlineitems);
                component.set("v.durationlist", helper.getuniquelabelvalue(filterdlineitems ,'Duration'));
                component.set("v.quoteitem.Price__c" ,'');
                component.set("v.quoteitem.Duration_Final__c",'');
                component.set("v.quoteitem.Months__c", '');
                component.set("v.quoteitem.Miles__c", '');
                showDuration = true;
                break;
            case "Duration":
                component.set("v.customduration", false);
                component.set("v.customduration", false);
                component.set("v.createdduration" , false); 
                component.set("v.quoteitem.Months__c" , '');
                component.set("v.quoteitem.Miles__c" , '');
                component.set("v.quote.Quote_Type__c" , 'Standard');
                component.set("v.quote.Duration_Final__c",value);
                filterdlineitems = helper.filterlineitemlist(component.get("v.durationlineitems"), name , value);
                component.set("v.finallineitem",filterdlineitems[0]);                
                component.set("v.quoteitem.Databook_Code__c" , filterdlineitems[0].Name);
                component.set("v.quoteitem.Price__c" , filterdlineitems[0].Price)
                component.set("v.quoteitem.Master_Coverage__c" , filterdlineitems[0].Id); 
                component.set("v.quoteitem.Months__c" , filterdlineitems[0].Months);
                component.set("v.quoteitem.Miles__c" , filterdlineitems[0].Miles);
                
                showDuration = true;
                saveFlag = true;                
                break;
        }
        helper.mandatorycheck(component);
        
        component.set("v.showDuration", showDuration);
        var appEvent = $A.get("e.c:QQ_App_Event");
        appEvent.setParams({
            "saveFlag" : saveFlag
        });
        appEvent.fire();
    },
    createduration : function(component, event, helper) 
    {
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
    editduration : function(component, event, helper)
    {
        component.set("v.createdduration" , false);        
    }  
})