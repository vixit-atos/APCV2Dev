({
    getQQ_Master : function(component, recordType, UI_Type)
    {
        var self = this;
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
                var filterdlineitems = self.filterlineitemlist(result, "Usage", component.get("v.quoteitem.Usage__c"));
                component.set("v.usagelineitems", filterdlineitems);
                component.set("v.componentoptions", self.getuniquelabelvalue(filterdlineitems, "EngineComponent"));
            }
        });
        
        $A.enqueueAction(action);        
    },
    
    getuniquelabelvalue : function(objectarray, fieldname) 
    {
        var uniqueobject  = objectarray.map(function(item){ return item[fieldname]}).
        filter(function(value, index, self){ return self.indexOf(value) === index});        
        //alert(JSON.stringify(uniqueobject));
        
        /*if(fieldname != "Name")
        {
            uniqueobject.sort(function(a,b) {return (a > b) ? 1 : -1 })
        }*/
        var reA = /[^a-zA-Z]/g;
        var reN = /[^0-9]/g;
        
        uniqueobject.sort(function(a,b) {var aA = a.replace(reA, "");
                                         var bA = b.replace(reA, "");
                                         if (aA === bA) {
                                             var aN = parseInt(a.replace(reN, ""), 10);
                                             var bN = parseInt(b.replace(reN, ""), 10);
                                             return aN === bN ? 0 : aN > bN ? 1 : -1;
                                         } else {
                                             return aA > bA ? 1 : -1;
                                         } })
        
        
        
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
            //alert(JSON.stringify(item));
            //alert(item[fieldname]);
            //alert(fieldvalue);
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
            if (quoteitem[item] == "" || quoteitem[item] == undefined) {
                mandatoryfieldpopulated = false;
            }
        });
        
        component.set("v.qq_cvg_completed", mandatoryfieldpopulated)
    },
    
    autohandlechange : function(index, lineitems, component)
    {
        try
        {
            var self = this;
            var fielditem = component.get("v.fieldorder")[index];
            var uniqueoption = self.getuniquelabelvalue(lineitems, fielditem["name"]);
            
            var fieldorderarray = component.get("v.fieldorder");
            fieldorderarray.forEach(function(item, indx){
                if(indx >= index)
                {
                    component.set(item["options"], []);
                    component.set("v.quoteitem." + item["setfieldname"], "");
                }
            });
            component.set(fielditem["options"], uniqueoption);
            
            if(uniqueoption.length == 0)
            {
                self.autohandlechange(index + 1, lineitems, component); 
            }
            if(uniqueoption.length == 1)
            {
                component.set(fielditem["filterdlineitems"], lineitems);
                component.set("v.quoteitem." + fielditem["setfieldname"], uniqueoption[0].value);
                if(index === fieldorderarray.length - 1)
                {
                    component.set("v.quoteitem.Price__c", lineitems[0].Price);
                    component.set("v.quoteitem.Master_Coverage__c", lineitems[0].Id);
                    component.set("v.quoteitem.Databook_Code__c", lineitems[0].Name);
                    component.set("v.quoteitem.Months__c", lineitems[0].Months);
                    component.set("v.quoteitem.Miles__c", lineitems[0].Miles);
                    component.set("v.quoteitem.Duration_Final__c", lineitems[0].Duration);
                    component.set("v.quote.Duration_Final__c", lineitems[0].Duration);
                }
                self.autohandlechange(index + 1, lineitems, component);   
            }
            if(uniqueoption.length > 1)
            {
                component.set(fielditem["filterdlineitems"], lineitems); 
            }  
        }
        catch(error) 
        {
            //alert(error.message);
        }
    }    
    
})