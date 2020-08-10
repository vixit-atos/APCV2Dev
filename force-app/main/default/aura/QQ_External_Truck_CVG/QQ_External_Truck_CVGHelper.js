({
    getQQ_Master : function(component, recordType, UI_Type)
    {
        var action = component.get("c.getQQ_Master");
        action.setParams({
            "recordType" : recordType, 
            "UI_Type" : UI_Type
        });        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") 
            {
                var result = response.getReturnValue();
                component.set("v.masterlineitems", result);
            }
        });
        
        $A.enqueueAction(action);        
    }, 
    
    getModel : function(component)
    {
        var A85_Code = component.get("v.quote.A85_Code__c");
        var action = component.get("c.getModel");
        action.setParams({
            "A85_Code" : A85_Code
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.modellist", result);
            }
        });
        $A.enqueueAction(action);
    }, 
    
    setGroup : function(component, engineModel)
    {
        var self = this;
        var action = component.get("c.getGroup");
        action.setParams({
            "engineModel" : engineModel
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") 
            {
                var resGroup = response.getReturnValue();
                component.set("v.quoteitem.Group__c", resGroup);
                
                var filterdlineitems = self.filterlineitemlist(component.get("v.masterlineitems"), "Groups", resGroup);
                //alert(JSON.stringify(filterdlineitems));
                component.set("v.grouplineitems", filterdlineitems);
                
                //------------------  POPULATING PACKAGE  -------------------------
                component.set("v.packagelineitems", self.filterlineitemlist(component.get("v.grouplineitems"), "Level", component.get("v.quoteitem.Level__c")));
                component.set("v.packagelist", self.getuniquelabelvalue(component.get("v.packagelineitems"), "TruckCoveragePackage"));
                component.set("v.standalonelist", self.getuniquelabelvalue(component.get("v.packagelineitems"), "StandalonePackage"));
                
                component.set("v.packageTypeList", component.get("v.truckpackagetypelist"));
                if(component.get("v.packagelist").length === 0)
                {
                    var listItem = component.get("v.packageTypeList");
                    var result = [];
                    result.push(listItem[1]);
                    component.set("v.packageTypeList", result);
                    component.set("v.packagetype", result[0].value);
                }
                if(component.get("v.standalonelist").length === 0)
                {
                    var listItem = component.get("v.packageTypeList");
                    var result = [];
                    result.push(listItem[0]);
                    component.set("v.packageTypeList", result);
                    component.set("v.packagetype", result[0].value);
                }
            }
        });
        
        $A.enqueueAction(action);        
    }, 
    
    getuniquelabelvalue : function(objectarray, fieldname)
    {
        var uniqueobject  = objectarray.map(function(item){ return item[fieldname]}).
        filter(function(value, index, self){ return self.indexOf(value) === index});
        /*if(fieldname != "Name")
        {
            uniqueobject.sort(function(a, b) {return (a > b) ? 1 : -1 })
        }*/
        var reA = /[^a-zA-Z]/g;
        var reN = /[^0-9]/g;
        
        uniqueobject.sort(function(a, b) {var aA = a.replace(reA, "");
                                          var bA = b.replace(reA, "");
                                          if (aA === bA)
                                          {
                                              var aN = parseInt(a.replace(reN, ""), 10);
                                              var bN = parseInt(b.replace(reN, ""), 10);
                                              return aN === bN ? 0 : aN > bN ? 1 : -1;
                                          }
                                          else 
                                          {
                                              return aA > bA ? 1 : -1;
                                          } 
                                         });
        var labelvaluelist = [];
        uniqueobject.forEach(function(item) {
            if(item)
            {
                var uniqueitem = {};
                uniqueitem.label=item;
                uniqueitem.value=item;
                labelvaluelist.push(uniqueitem);
            }
        });
        return labelvaluelist;
    }, 
    
    filterlineitemlist : function(objectarray, fieldname, fieldvalue)
    {
        return objectarray.filter(function(item){
            if(item[fieldname] != undefined)
                return item[fieldname].includes(fieldvalue);
        });
    }, 
    
    mandatorycheck: function(component) 
    {
        var quoteitem = component.get("v.quoteitem");
        var mandatoryfield = ["A85_Code__c", "Duration_Final__c"];
        var mandatoryfieldpopulated = true;
        mandatoryfield.forEach(function(item) {
            if (quoteitem[item] == "" || quoteitem[item] == undefined) 
            {
                mandatoryfieldpopulated = false;
            }
        });
        
        component.set("v.qq_cvg_completed", mandatoryfieldpopulated)
    },  
    
    removeByKey : function (array, params)
    {
        array.some(function(item, index) {
            if(array[index][params.key] === params.value)
            {
                // found it!
                array.splice(index, 1);
                return true; // stops the loop
            }
            return false;
        });
        return array;
    }, 
    
    checklineitemadded : function (array, fieldname, fieldvalue)
    {
        var obj = array.find(function (obj) { 
            return obj[fieldname] === fieldvalue; 
        });
        return obj ? true : false;
    }
})