({
    doinit : function(component, event, helper){
        helper.getloggedusercontactid(component, event, helper);
        helper.getloggeduseraccountid(component, event, helper);
       // helper.getDealerContacts(component, event, helper);
    },
    navtoTBB : function(component, event, helper) {
        component.find("navService").navigate({    
            type: "standard__namedPage",
            attributes: {
                "pageName": component.get("v.pagename")    
            }
        });
    },
    openModal : function(component, event, helper) {        
        var bucketclicked = event.currentTarget.dataset.id;
        if(bucketclicked == 'tile1'){
            component.set("v.bucketname",'Order I\'m Trying to Place');
            component.set("v.whichbucket", bucketclicked);
        } else if(bucketclicked == 'tile2'){
            component.set("v.bucketname",'An Existing Order');
            component.set("v.whichbucket", bucketclicked);
        }else if(bucketclicked == 'tile3'){
            component.set("v.bucketname",'An Order I Have Received');
            component.set("v.whichbucket", bucketclicked);
        }else if(bucketclicked == 'tbb'){
            
            component.set("v.bucketname",'Thomas Built Bus \(TBB\)');
            component.set("v.whichbucket", bucketclicked);
            component.set("v.isbucketclicked", true);
        }        
    },
    closeModal :function(component, event, helper) {       
       
        helper.handledeletefilesonclosemodal(component, event, helper);
        component.find("navService").navigate({    
                                type: "standard__namedPage",
                                attributes: {
                                    "pageName": "apc-home"    
                                }
                            });      
    },  
    submitclicked: function(component, event, helper){
        component.set("v.IsSpinner", true);
        if(component.get("v.whichbucket") == "tile1")
        {
            helper.checkbucket1optionalfieldsvalidity(component, event, helper);
        }  else if (component.get("v.whichbucket") == "tile3") {           
            helper.checkbucket3optionalfieldsvalidity(component, event, helper);
            
        }else if(component.get("v.whichbucket") == "tbb"){
            helper.checktbboptionalfieldsvalidity(component, event, helper);        
        }
            else{
                helper.createcaseandorderrecord(component, event, helper); 
            }
        
    }    
})