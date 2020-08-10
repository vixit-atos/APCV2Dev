({
    SubmitQuote : function(component, event, helper)
    {
        var SubmitQuoteSrvc = component.find("SubmitQuickQuote");
        component.set("v.quote.Stage__c", "Complete");
        component.set("v.quote.Status__c", "Approved");
        component.set("v.quote.Source__c", "External");
        component.set("v.quote.Domain__c", "Extended Warranty");
        SubmitQuoteSrvc.submitquickquote(component.get("v.quote"), component.get("v.quoteitemlist"), function(result) {
            component.set("v.newquotenum", result.Name);
            component.set("v.quote", result); // PDF changes to get record Id after submission 
            component.set("v.qq_submitted", true);
            var submitEvent = $A.get("e.c:QQ_NQ_Submit_Save_event");        
            submitEvent.setParam("message", "event message here");
            submitEvent.fire();
        });
    }, 
    
    enablePreviewbtn :function(component, event, helper) 
    {
        event.getParam("value").length > 0 ? component.set("v.enablepreviewbtn", true):component.set("v.enablepreviewbtn", false);
    }, 
    
    CancelQuote : function(component, event, helper)
    {
        component.set("v.closeform", true);    
    }, 
    
    BackQuoteform : function(component, event, helper)
    {
        component.set("v.qq_previewmode", false); 
    }, 
    
    PreviewQuote : function(component, event, helper) 
    {
        component.set("v.qq_previewmode", true); 
        var itemlist = component.get("v.quoteitemlist");
        itemlist.forEach(function(item) { 
            //  alert(item.Coverage__c);
            if(item.Coverage__c == "DETROIT COVERAGE")
            {
                component.set("v.detroititem", true); 
            }
            if(item.Coverage__c == "TRUCK CHASSIS")
            {
                component.set("v.truckitem", true); 
            }
            if(item.Coverage__c == "FCCC")
            {
                component.set("v.fccitem", true); 
            }
            if(item.Coverage__c == "FCCC-TBB")
            {
                component.set("v.fcctbbitem", true); 
            }
        });
    }, 
    
    downloadPDF : function(component, event, helper) 
    {
        component.set("v.qq_pdfmode", true);
        // var recordID = component.get("v.newquotenum");
        let recordID = component.get("v.quote.Id");
        let url = window.location.href 
        let device = $A.get("$Browser.formFactor");
        url =  url.split("/s/")[0] + "/apex/QQ_ES_PDFViewer?UI_Type=External&recordId=" + recordID;
        if(device === "TABLET")
        {
            window.location.assign(url); 
        }
        else
        {
            window.open(url);  
        }        
    }
})