({
    pillarprice : function(pricepermile,desiredmile,pricepermonth,desiredmonth)
    {        
        return  ((pricepermile*desiredmile) + (pricepermonth * desiredmonth))/2;		
    },
    
    totalcalculation : function(component)
    {
        /*
        var pillarprice = component.get("v.pillarprice");
        var costprice = component.get("v.quoteitem.Cost__c");
        var margin = pillarprice - costprice;
        var margin1=margin/pillarprice;
        var marginpercent = Math.round(margin1*100);
        component.set("v.quoteitem.Margin__c" , marginpercent);
        */
        
        var pillarprice = component.get("v.pillarprice");
        var AMFprice = component.get("v.AMFprice");
        var RFprice = component.get("v.RFprice");
        var SP_point = component.get("v.quoteitem.Second_Price_Point__c");
        var eyeadjprice = component.get("v.quoteitem.Eye_Test_Adjustment__c");
        
        //var costprice = component.get("v.quoteitem.Cost_Price__c");
        var costprice = component.get("v.quoteitem.Cost__c");
        
        var totalpricebeforeSP =  pillarprice +  AMFprice + RFprice + eyeadjprice 
        
        var SPprice = -1 * Math.round((SP_point * totalpricebeforeSP)/100);
        var totalpricebeforerounding =  totalpricebeforeSP + SPprice;
        
        var totaprice_final =  Math.round(totalpricebeforerounding/5) * 5;
        var margin = totaprice_final - costprice
        var marginpercent = (margin/totaprice_final)*100;
        component.set("v.SPprice" ,SPprice );
        component.set("v.quoteitem.Price__c" , totaprice_final);
        component.set("v.quoteitem.Margin__c" , marginpercent.toFixed(2));
    },
    
    historysorting : function(array)
    {
        var sortedpricehistory =  array.sort(function(a, b) {            
            return a["Months__c"] - b["Months__c"] || a["Miles__c"] - b["Miles__c"];
        });
        
        return sortedpricehistory ;
    }
})