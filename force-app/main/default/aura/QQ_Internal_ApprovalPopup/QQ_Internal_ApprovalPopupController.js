({
    doinit : function(component, event, helper)
    {
        var oldstatus = component.get("v.quotestatus");    
        switch(oldstatus){            
            case "Draft":
                break;
            case "Pending for Validation":
                component.set("v.saved", true);
                component.set("v.showapprovalbtn", true);                
                break;
            case "Pending for Cost":
                //component.set("v.saved", true);
                component.set("v.showapprovalbtn", true); 
                break;
            case "Pending for Price":
                component.set("v.showapprovalbtn", true); 
                break;
            case "Pending for Control":
                component.set("v.showapprovalbtn", true); 
                component.set("v.saved", true);
                break;
            case "Pending for Management":
                component.set("v.showapprovalbtn", true); 
                component.set("v.saved", true);
                break;
                
        }
        helper.getapprovalqueuedetails(component);
    }, 
    
    AcceptQuote : function(component, event, helper) 
    {
        var oldstatus = component.get("v.quotestatus");
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        //alert($A.get("$Locale.datetimeFormat"));
        var nowdatetime = $A.localizationService.formatDate(new Date(),  $A.get("$Locale.datetimeFormat"));
        //alert(nowdatetime);
        
        switch(oldstatus)
        {            
            case "Draft":
                component.set("v.quote.Status__c", "Pending for Validation");
                component.set("v.quote.Stage__c", "Pending");
                break;
            case "Pending for Validation":
                component.set("v.quote.Status__c", "Pending for Cost");
                component.set("v.quote.Stage__c", "Pending");
                component.set("v.quote.Vld_Approved_By__c", userId);
                component.set("v.quote.Vld_Approved_On__c", new Date());
                break;
            case "Pending for Cost":
                component.set("v.quote.Status__c", "Pending for Price");
                component.set("v.quote.Stage__c", "Pending");
                component.set("v.quote.Cost_Approved_By__c", userId);
                component.set("v.quote.Cost_Approved_On__c", new Date());
                break;
            case "Pending for Price":
                component.set("v.quote.Status__c", "Pending for Control");
                component.set("v.quote.Stage__c", "Pending");
                component.set("v.quote.Price_Approved_By__c", userId);
                component.set("v.quote.Price_Approved_On__c", new Date());
                break;
            case "Pending for Control":
                component.set("v.quote.Status__c", "Pending for Management");
                component.set("v.quote.Stage__c", "Pending");
                component.set("v.quote.Ctrl_Approved_By__c", userId);
                component.set("v.quote.Ctrl_Approved_On__c", new Date());
                break;
            case "Pending for Management":
                component.set("v.quote.Status__c", "Approved");
                component.set("v.quote.Stage__c", "Complete");
                component.set("v.quote.Mgmt_Approved_By__c", userId);
                component.set("v.quote.Mgmt_Approved_On__c", new Date());
                // helper.createnewmastrc(component);
                break;
        }
        
        helper.callApprovalservice(component); 
    }, 
    
    RejectQuote : function(component, event, helper)
    {
        component.set("v.showreject", true);         
    }, 
    
    ReviseQuote : function(component, event, helper) 
    {
        component.set("v.showrevise", true); 
        var groupoption;
        var oldstatus = component.get("v.quotestatus");
        switch(oldstatus)
        {            
            case "Draft":
                component.set("v.quote.Status__c", "Pending for Validation");
                component.set("v.quote.Stage__c", "Pending");
                break;
            case "Pending for Validation":
                groupoption = [{ "label":"Draft", "value":"Draft"}];
                break;
            case "Pending for Cost":
                groupoption = [{ "label":"Validation", "value":"Validation"}];
                break;
            case "Pending for Price":
                groupoption = [{ "label":"Cost", "value":"Cost"}, 
                               { "label":"Validation", "value":"Validation"}];
                break;
            case "Pending for Control":
                groupoption = [{ "label":"Price", "value":"Price"}, 
                               { "label":"Cost", "value":"Cost"}, 
                               { "label":"Validation", "value":"Validation"}];
                break;
            case "Pending for Management":
                groupoption = [{ "label":"Control", "value":"Control"}, 
                               { "label":"Price", "value":"Price"}, 
                               { "label":"Cost", "value":"Cost"}, 
                               { "label":"Validation", "value":"Validation"}];
                break;
        }
        component.set("v.groupooptions", groupoption);
    }, 
    
    Saveforlater : function(component, event, helper) 
    {
        helper.callApprovalservice(component); 
    }, 
    
    downloadPDF : function(component, event, helper) 
    {
        var recordID = component.get("v.quotenum");
        window.open("/apex/QQ_ES_PDFViewer?UI_Type=Internal&recordID=" + recordID, "_blank", "toolbar=0, location=0, menubar=0, resizable=1, width=900, height=600, top=0, left=200");
    }, 
    
    CancelQuote : function(component, event, helper) 
    {
        component.set("v.closeform", true);    
    } 
    
})