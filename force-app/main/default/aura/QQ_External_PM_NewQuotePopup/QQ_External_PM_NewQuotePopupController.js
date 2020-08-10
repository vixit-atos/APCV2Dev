({
    SubmitQuote : function(component, event, helper) {
        var SubmitQuoteSrvc = component.find("SubmitQuickQuote");
        component.set("v.quote.Stage__c" , "Complete");
        component.set("v.quote.Status__c" , "Approved");
        component.set("v.quote.Source__c" , "External");
        component.set("v.quote.Domain__c" , "Preventive Maintenance")
        
        SubmitQuoteSrvc.submitquickquote(component.get("v.quote"), component.get("v.quoteitemlist"), component.get("v.addonitems") , function(result) {
            component.set("v.newquotenum" , result.Name);
            component.set("v.quote" , result);
            component.set("v.qq_submitted" , true);
            var submitEvent = $A.get("e.c:QQ_NQ_Submit_Save_event");        
            submitEvent.setParam("message", "event message here");
            submitEvent.fire();
            
        });
    },
    enablePreviewbtn :function(component, event, helper) {
        event.getParam("value").length > 0 ? component.set("v.enablepreviewbtn" , true):component.set("v.enablepreviewbtn" , false);
           
    } ,
    BackQuoteform : function(component, event, helper) {
        component.set("v.qq_previewmode" , false); 
    },
    CancelQuote : function(component, event, helper) {
        component.set("v.closeform" , true);    
    } ,
    PreviewQuote : function(component, event, helper) {
        component.set("v.qq_previewmode" , true); 
        var itemlist = component.get("v.quoteitemlist");
        itemlist.forEach(function(item) { 
            
            if(item.Program__c === 'PACKAGE'){
                component.set("v.pkgexist" , true); 
            }
            if(item.Program__c === 'ATS'){
                component.set("v.atsexist" , true); 
            }
            if(item.Program__c === 'TRANSMISSION'){
                component.set("v.transmissionexist" , true); 
            }
        });
    },
    downloadPDF : function(component, event, helper) {
        component.set("v.qq_pdfmode" , true);
        
       // var recordID = component.get("v.newquotenum");
       var recordID = component.get("v.quote.Id");
       // alert(recordId);
        var url = window.location.href 
        var device = $A.get("$Browser.formFactor");
        url =  url.split('/s/')[0] + "/apex/QQ_PM_PDFViewer?recordId=" + recordID;       
        if(device === 'TABLET'){
            window.location.assign(url); 
        }else{
          window.open(url);  
        }
      
    }
})