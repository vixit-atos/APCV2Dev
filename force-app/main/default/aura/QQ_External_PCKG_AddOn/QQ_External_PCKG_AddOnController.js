({
    doinit : function(component, event, helper) {
        var addon_api_label = [{ "label":"Drive Belt" , "api":"Drive_Belt_No_Of_Service__c" , "type" : "Drive_Belt_Type__c"},
                               { "label":"Air Filter" , "api":"Air_Filter_No_Of_Services__c" , "type" : "Air_Filter_Type__c"},
                               { "label":"Air Dryer" , "api":"Air_Dryer_No_Of_Service__c" , "type":"Air_Dryer_Type__c" },
                               {"label" : "Coolant" , "api": "Coolant_System_No_Of_Service__c" , "type" : "Coolant_System_No_Of_Service__c"},
                               {"label" : "DEF Filter" , "api": "DEF_Filter_No_Of_Service__c" , "type" : "DEF_Filter_No_Of_Service__c"},
                               {"label" : "Differential" , "api": "Differential_No_Of_Service__c" , "type" : "Differential_Service_Type__c"},
                               {"label" : "Intial Valve Lash" , "api": "Initial_Valve_Lash_No_Of_Service__c" , "type" : "Initial_Valve_Lash_No_Of_Service__c"},
                               {"label" : "Power Steering" , "api": "Power_Steering_No_Of_Service__c" , "type" : "Power_Steering_Type__c"},
                               {"label" : "Valve Lash" , "api": "Valve_Lash_Adj_No_Of_Service__c" , "type" : "Valve_Lash_Adj_No_Of_Service__c"}];
        
        
        
        
        var LineitemSrvc = component.find("Lineitemservice");
        
        LineitemSrvc.getLineitemData('Add_On', function(result) {
            var filteredresult = result ;
            var enginemodel = component.get("v.quoteitem.Engine_Model__c");
            var dutycycle = component.get("v.quoteitem.Duty_Cycle__c");
            var filteredresult1 = helper.filterlist_twofields(result , 'Engine_Model__c' , enginemodel , 'Duty_Cycle__c' ,dutycycle );
            var filteredresult2 = helper.filterlist_twofields(result , 'Engine_Model__c' , enginemodel , 'Duty_Cycle__c' ,'NA' );
           
            filteredresult = filteredresult1.concat(filteredresult2);
            
            var addonlist = component.get("v.addonlist");
            
             
            addon_api_label.forEach(function(element){
                
                var array = filteredresult.filter(function(item){ return item[element.api] > 0});
                var newarray = [];
                array.forEach(function(item2){
                    item2.label = element.label; 
                    item2.service = item2[element.api];
                    item2.type = item2[element.type];
                    if(item2.service == item2.type)
                    {
                        item2.type = element.label;
                        
                    }
                    newarray.push(item2);
                });
                
                addonlist = addonlist.concat(newarray) ; 
            });
            component.set("v.addonlist" , addonlist); 
          //   alert(JSON.stringify(addonlist));
            component.set("v.uniqueaddon" , helper.getuniquelabelvalue(addonlist , 'label'))
            var uniqueaddon = component.get("v.uniqueaddon");
            
            
            var servicelist_for_alladdon = [];
            uniqueaddon.forEach(function(element1 ,index){
                var filteradd = helper.filterlineitemlist(addonlist , 'label', element1.label);
                var uniquetype = helper.getuniquelabelvalue(filteradd , 'type');
                var servicelist_foraddon = [];
                uniquetype.forEach(function(element2 ,index){
                    var array = {};
                    array["addon"]  = element1.label;
                    array["type"] = element2.label;
                    array["list"] = helper.filterlist_twofields(addonlist , 'label' , element1.label , 'type' , element2.label);
                    servicelist_foraddon.push(array);
                });
                servicelist_for_alladdon = servicelist_for_alladdon.concat(servicelist_foraddon);
            });
            component.set("v.servicelist" , servicelist_for_alladdon);
            
        });   
    }
})