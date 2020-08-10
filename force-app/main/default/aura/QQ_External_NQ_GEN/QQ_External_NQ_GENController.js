({
    doInit : function(component, event, helper) 
    {
        helper.getFMVDate(component);
        helper.getExpDate(component);
    }, 
    
    handleChange : function(component, event, helper) 
    {
        var label = event.getSource().get("v.label");
        //alert("Label" + JSON.stringify(label));
        
        switch(label)
        {
            case "A85 Code":
                component.set("v.A85value", component.get("v.quote.A85_Code__c"));
                component.set("v.showDetroit", false);
                component.set("v.showTruck", false);
                component.set("v.showFCCC", false);
                component.set("v.showFCCCTBB", false);
                component.set("v.quoteitemlist", [] ) ; 
                var DependentPicklstSrvc = component.find("DependentPicklstSrvc");                
                DependentPicklstSrvc.getdeplist("ASP_QQ_Line_Item__c", "A85_Code__c", component.get("v.quote.A85_Code__c"), "Coverage__c", function(result)
                                                { component.set("v.CoverageOptions", result); }); 
                break;
                
            case "DETROIT COVERAGE":
                component.set("v.showDetroit", true);
                component.set("v.detroitsection", "detroit");
                component.set("v.trucksection", "");
                component.set("v.fcccsection", "");
                component.set("v.fccctbbsection", "");
                break;
                
            case "TRUCK CHASSIS":
                component.set("v.showTruck", true);
                component.set("v.detroitsection", "");
                component.set("v.trucksection", "truck");
                component.set("v.fcccsection", "");
                component.set("v.fccctbbsection", "");
                break;
                
            case "FCCC":
                component.set("v.showFCCC", true);
                component.set("v.detroitsection", "");
                component.set("v.trucksection", "");
                component.set("v.fcccsection", "fccc");
                component.set("v.fccctbbsection", "");
                break;
                
            case "FCCC-TBB":
                component.set("v.showFCCCTBB", true);
                component.set("v.detroitsection", "");
                component.set("v.trucksection", "");
                component.set("v.fcccsection", "");
                component.set("v.fccctbbsection", "fccctbb");
                break;
        }
    },
    
    removeCoverage : function(component, event, helper) 
    {
        var label = event.getSource().get("v.label");
        var updatedquoteitemlist;
        updatedquoteitemlist = helper.removeobjectpropertyval(component.get("v.quoteitemlist"), "Coverage__c", label);
        component.set("v.quoteitemlist", updatedquoteitemlist ) ;
        
        switch(label) 
        {
            case "DETROIT COVERAGE":
                component.set("v.showDetroit", false);
                break;
            case "TRUCK CHASSIS":
                component.set("v.showTruck", false);
                break;
            case "FCCC":
                component.set("v.showFCCC", false);
                break;
            case "FCCC-TBB":
                component.set("v.showFCCCTBB", false);
                break;
        }
    }, 
    
    UpdateCustomer : function(component, event, helper) 
    {
        component.set("v.showDetroit", false);
        component.set("v.showTruck", false);
        component.set("v.showFCCC", false);
        component.set("v.showFCCCTBB", false);
        component.set("v.quoteitemlist", []);
        component.set("v.quote.Customer_Name__c", component.get("v.selectedLookUpRecord").Id);
        component.set("v.quotecustomer", component.get("v.selectedLookUpRecord").Name);  
    }, 
    
    addcustomer : function(component, event, helper) 
    { 
        component.set("v.showaddbutton", false);
        var InsertCustmrSrvc = component.find("InsertCustomerSrvc");                
        InsertCustmrSrvc.createQQcustomer(component.get("v.accountkeyword"), function(result){
            component.set("v.quote.Customer_Name__c", result.Id);             
            component.set("v.quotecustomer", component.get("v.accountkeyword"));            
            var appEvent = $A.get("e.c:QQ_selectedsObjectRecordEvent");  
            appEvent.setParams({"recordByEvent" : result }); 
            appEvent.fire();
        }); 
    }
})