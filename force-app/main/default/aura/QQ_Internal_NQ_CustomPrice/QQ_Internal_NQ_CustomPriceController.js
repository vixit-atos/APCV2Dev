({
    doinit : function(component, event, helper) 
    {
        var pillarsrvc= component.find("pillarservice");

        pillarsrvc.getpillardata(component.get("v.quoteid"), function(result) {
            component.set("v.pillarpricelist", result);
            var pillaroptions = [];
            result.forEach(function(item){
                var pillaritem={} ;
                pillaritem.label = item.Duration__c + "($" + item.Price__c + ")";
                pillaritem.value = item.Id;
                pillaroptions.push(pillaritem);
            });
            component.set("v.pillaroptions", pillaroptions);
            component.set("v.quoteitem.Margin__c", 0);            
        });
        
        var pricesrvc= component.find("pricehistoryservice");
        pricesrvc.getpricehistory(component.get("v.quoteid"), function(result) {
            component.set("v.qqpricehistorylist", helper.historysorting(result)); 
        });        
    }, 
    
    calcprice : function(component, event, helper) 
    {
        if(component.get("v.pillar1") && component.get("v.pillar2")) 
        {
            var pillarpricelist = component.get("v.pillarpricelist");
            var pillar1 = pillarpricelist.find(function(item) {
                return item.Id === component.get("v.pillar1");                
            });
            
            var pillar2 = pillarpricelist.find(function(item) {
                return item.Id === component.get("v.pillar2");
            });
            
            var miles_desired = component.get("v.quoteitem.Miles__c");
            var month_desired = component.get("v.quoteitem.Months__c"); 
            var price_pillar1 = helper.pillarprice(pillar1.Price_Per_Mile__c, miles_desired, pillar1.Price_Per_Month__c, month_desired) ;
            var price_pillar2 = helper.pillarprice(pillar2.Price_Per_Mile__c, miles_desired, pillar2.Price_Per_Month__c, month_desired) ;
            
            var pillarprice = Math.round((price_pillar1 + price_pillar2)  / 2, 0); 
            component.set("v.pillarprice", pillarprice);
            component.set("v.quoteitem.Margin__c", 0);
            
            //alert(pillar1.Duration__c);
            component.set("v.quoteitem.Lower_Pillar__c", pillar1.Duration__c + "($" + pillar1.Price__c + ")");
            component.set("v.quoteitem.Lower_Pillar_Months__c", pillar1.Months__c);
            component.set("v.quoteitem.Lower_Pillar_Miles__c", pillar1.Miles__c);
            component.set("v.quoteitem.Lower_Pillar_Price__c", pillar1.Price__c);
            
            component.set("v.quoteitem.Upper_Pillar__c", pillar2.Duration__c + "($" + pillar2.Price__c + ")");
            component.set("v.quoteitem.Upper_Pillar_Miles__c", pillar2.Miles__c);
            component.set("v.quoteitem.Upper_Pillar_Months__c", pillar2.Months__c);
            component.set("v.quoteitem.Upper_Pillar_Price__c", pillar2.Price__c);            
            
            helper.totalcalculation(component, event, helper);
        } 
    }, 
    
    handlechange : function(component, event, helper) 
    {
        var name = event.getSource().get("v.name");
        var value = event.getSource().get("v.value");
        var pillarprice = component.get("v.pillarprice");
        
        //alert("Name: " + name +", Value: " + value);
        switch(name)
        {
            case "Accelerated_Mileage_Factor__c":
                component.set("v.AMFprice", Math.round((value * pillarprice) /100));
                component.set("v.quoteitem.Pricing_Type__c", "Custom");
                helper.totalcalculation(component, event, helper);
                break;
                
            case "Risk_Factor__c":
                component.set("v.quoteitem.Pricing_Type__c", "Custom");
                var DependentPicklstSrvc = component.find("DependentPicklstSrvc");                
                DependentPicklstSrvc.getdeplist("ASP_QQ_Line_Item__c", "Risk_Factor__c", component.get("v.quoteitem.Risk_Factor__c"), "Risk_Factor_Value__c", function(result) {
                    component.set("v.RFprice", Number(result[0].value));
                    component.set("v.quoteitem.Risk_Factor_Value__c", result[0].value);
                    helper.totalcalculation(component, event, helper);
                });                
                break;
                
            case "subtracteyeadj":
                component.set("v.quoteitem.Pricing_Type__c", "Custom");
                var eyeadjprice = component.get("v.quoteitem.Eye_Test_Adjustment__c");
                component.set("v.quoteitem.Eye_Test_Adjustment__c", eyeadjprice - 5);
                component.set("v.quoteitem.Price__c", helper.totalcalculation(component, event, helper));
                break;
                
            case "addeyeadj":
                component.set("v.quoteitem.Pricing_Type__c", "Custom");
                var eyeadjprice = component.get("v.quoteitem.Eye_Test_Adjustment__c");
                component.set("v.quoteitem.Eye_Test_Adjustment__c", eyeadjprice + 5);
                helper.totalcalculation(component, event, helper);
                break;
                
            case "Second_Price_Point__c":                
                helper.totalcalculation(component, event, helper);
                if(value > 0)
                {
                    component.set("v.quoteitem.Pricing_Type__c", "2PP");
                }
                break;
        } 
    }, 
    
    saveprice : function(component, event, helper)
    {
        component.set("v.editpricemode", false);
        component.set("v.saved", true);        
    }, 
    
    editprice : function(component, event, helper) 
    {
        component.set("v.editpricemode", true);
        component.set("v.saved", false);
    }
})