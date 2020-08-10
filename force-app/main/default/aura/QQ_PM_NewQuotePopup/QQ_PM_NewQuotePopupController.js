({
   openModel: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
      component.set("v.isOpen", true);
   },
 
   closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpen", false);
   },
 
   SubmitQuote : function(component, event, helper) {
        var SubmitQuoteSrvc = component.find("SubmitQuickQuote");
        alert(JSON.stringify(component.get("v.quoteitemlist")))
        SubmitQuoteSrvc.submitquickquote(component.get("v.quote"), component.get("v.quoteitemlist"), component.get("v.addonitems") , function(result) {
            alert(result.Name);
          //  component.set("v.qq_submitted" , true);
        });
    },
})