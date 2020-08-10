({
	getResponse: function(component, order,Ordernumber) {
        // create a server side action. 
        $A.util.removeClass(component.find("spinner"), "slds-hide");
        var action = component.get("c.getpartvalidate"); 
        var isValid        = true;
        //code added by vyshnavi as part of more space bugs fix
        component.set('v.IsthisPricing',' ');
        component.set('v.IsPricing','');
        //code ends here
        if(!Ordernumber){
            $A.util.addClass(component.find("spinner"), "slds-hide");    
            order.set("v.errors", [{message:"Part Number cannot be blank"}]);
            isValid=false;                    
        } 
        //code added by vyshnavi more spaces bug fix
        if(Ordernumber.substr(Ordernumber.length-1,1) == " "){
            $A.util.addClass(component.find("spinner"), "slds-hide"); 
            order.set("v.errors", [{message:"The part Number entered with space."}]);
           /* var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": 'Error',
                "type": 'error',
                "message": "The part Number entered with space. Please reenter the correct Paragon Part Number"
            });
            toastEvent.fire();*/
            isValid=false;
            //code ends here
        }
        
        // set the url parameter for getpartvalidate method (to use as endPoint) 
        /*action.setParams({
            "partnumber": Ordernumber
        });*/
        //Added as per Coreteam comments
         action.setParams({
            "partnumber": Ordernumber                     
        });
        action.setCallback(this, function(response) {
            $A.util.addClass(component.find("spinner"), "slds-hide");
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                // set the response(return String) to response attribute.      
                var result = response.getReturnValue();                
                console.log('result ---->' + JSON.stringify(result));
                component.set("v.response", result.message);
                component.set("v.isActive", result.isActive);
                component.set("v.partdescription", result.partdescription);
                component.set("v.plannercode", result.plannercode);
                component.set("v.vendor", result.vendor);
                component.set("v.VMRSCode", result.VMRSCode);
                component.set("v.Volume", result.Volume);
                component.set("v.UnitofMeasure", result.UnitofMeasure);
                component.set("v.Length", result.Length);
                component.set("v.Width", result.Width);
                component.set("v.height", result.height);
                component.set("v.volunit", result.volunit);
                component.set("v.GrossWeight", result.GrossWeight);
                component.set("v.WeightUnit", result.WeightUnit);
                component.set("v.USPDCPackSize", result.USPDCPackSize);
                component.set("v.USDSPackSize", result.USDSPackSize);
                component.set("v.CAPDCPackSize", result.CAPDCPackSize);
                component.set("v.CADSPackSize", result.CADSPackSize);
                var lastresponse=component.get('v.response');
                console.log('values are '+lastresponse)
                console.log('lastresponse'+lastresponse+'state'+state);  
                //changed the code as part of more space bug fix by vyshnavi
                if((lastresponse=='Part is Invalid')||(lastresponse=='Part is Invalid' && Ordernumber.length<12)||(lastresponse=='Part is Invalid' && Ordernumber.length>12 && Ordernumber.length<30)) {
                    $A.util.addClass(component.find("spinner"), "slds-hide");    
                    component.set('v.IsthisPricing',''); 
                    component.set('v.IsPricing',''); 
                    order.set("v.errors", [{message:"The part Number entered could not be found."}]);
                    //order.set("v.errors", [{message:"Part is Invalid"}]);
                   /* var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": 'Error',
                        "type": 'error',
                        "message": "The part Number entered could not be found. Please reenter the correct Paragon Part Number"
                    });
                    toastEvent.fire();*/
                    isValid=false;
                }
                
                if(Ordernumber.length>30){
                   order.set("v.errors", [{message:"The part number is invalid. Please reenter"}]);
                   $A.util.addClass(component.find("spinner"), "slds-hide"); 
                    /*var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": 'Error',
                        "type": 'error',
                        "message": "The part number is invalid. Please reenter the correct Paragon Part Number"
                    });
                    toastEvent.fire();*/
                    isValid=false;                    
                }
                
                
                else if(isValid){             		
                    order.set("v.errors", '');
                }
                if(lastresponse=='Part is Valid'){             
                    component.set('v.IsthisPricing','Yes'); 
                    /*var toastEvent = $A.get("e.force:showToast");
    		  			toastEvent.setParams({
        				"title": "Success!",
        				"message": "Part is Valid."
              });
    		   toastEvent.fire();*/
              }               
            }else if(state = "ERROR"){
                errorMsg = response.getError()[0];
                let toastParams = {
                    title: "Error",
                    message: errorMsg, // Default error message
                    type: "error"
                };
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams(toastParams);
                toastEvent.fire();
            }
        });
        //code added here as part of more spaces bug fix
        if(isValid){
        $A.enqueueAction(action);            
        }
        
	},
    
    
    SaveRecord : function(component,event,helper){
        
        //alert('SaveRecord function calling in APC COmponent');
        var order =component.find("order");        
        var Ordernumber = order.get("v.value");
        var isValid        = true;
        var ORecord = component.get('v.RecordforSave');	
        var SelectedValue=component.get('v.SelectedValue'); 
        var flag='false';
        var Apc_Reason;
        var SubAction;
        var PDCLocation;
        var ItemReason;
        
        var IsPricing=component.get('v.IsPricing');       
        if(IsPricing=="Yes"){             
            var selectItem1 =component.find("selectItemreason");             			 
            selectItem1.showHelpMessageIfInvalid();             
            //alert("isPricing second time Conditon calling");            		            	                       
            ItemReason=component.find("selectItemreason").get("v.value");
            //alert("ItemReason"+ItemReason);
            if(ItemReason=="1"){
                ItemReason='Need to order';
            }else if(ItemReason=="2"){
                ItemReason='Customer quote';
            }
            if (selectItem1.get("v.validity").valid){
                flag='true';
                ORecord.push({'LOC_Code__c':component.get('v.dealerCode'),'Able_to_find_the_part_in_Paragon__c':'Yes','Part_No__c':component.get('v.OrderNumber'),'Pricing_Request__c':'Yes','SAP_Order__c':component.get('v.SAPNumber'),'NSN_Order__c':component.get('v.QuoteNumber'),'Reactivation_Reason__c':ItemReason,'Additional_Information__c':component.get('v.AdditionalInfo'),'Additional_Recipients__c':component.get('v.emailRecipient'),'APC_Reason__c':'Price Request','isActive__c':component.get('v.isActive'),'Part_Description__c':component.get('v.partdescription'),'Vendor_Code__c':component.get('v.vendor'),'Planner_Code__c':component.get('v.plannercode'),
                              'VMRSCode__c':component.get('v.VMRSCode'),'Volume__c':component.get('v.Volume'),'UnitofMeasure__c':component.get('v.UnitofMeasure'),'Length__c':component.get('v.Length'),'Width__c':component.get('v.Width'),'Height__c':component.get('v.height'),'Volumeunit__c':component.get('v.volunit'),'GrossWeight__c':component.get('v.GrossWeight'),'WeightUnit__c':component.get('v.WeightUnit'),'USPDCPackSize__c':component.get('v.USPDCPackSize'),'USDSPackSize__c':component.get('v.USDSPackSize'),'CAPDCPackSize__c':component.get('v.CAPDCPackSize'),'CADSPackSize__c':component.get('v.CADSPackSize')});
                component.set('v.RecordforSave',ORecord); 
            }       
        }
        if(IsPricing=="No"){
            //alert('SaveRecord function executing before if conditions'+SelectedValue);
            if(SelectedValue=="1"){			
                var quantity =component.find("quantity");       
                quantity.showHelpMessageIfInvalid(); 			
                var lead =component.find("lead");       
                lead.showHelpMessageIfInvalid(); 	
                if(SelectedValue=="1"){             	
                    Apc_Reason='Lead Time';
                    SubAction = component.get('v.LeadStock');
                    if(SubAction=="1"){
                        SubAction='Stock';
                    }else if(SubAction=="2"){
                        SubAction='Critical';
                    }else if(SubAction=="3"){
                        SubAction='Direct Ship';
                    }
                }
                if(lead.get("v.validity").valid && quantity.get("v.validity").valid){
                    flag='true';
                    ORecord.push({'LOC_Code__c':component.get('v.dealerCode'),'Able_to_find_the_part_in_Paragon__c':'Yes','Part_No__c':component.get('v.OrderNumber'),'Pricing_Request__c':'No','Quantity__c':component.get('v.Quantity'),'Additional_Information__c':component.get('v.AdditionalInformation'),'Additional_Recipients__c':component.get('v.emailRecipient'),'APC_Reason__c':Apc_Reason,'isActive__c':component.get('v.isActive'),'Lead_Time_Reason__c':SubAction,'Part_Description__c':component.get('v.partdescription'),'Vendor_Code__c':component.get('v.vendor'),'Planner_Code__c':component.get('v.plannercode'),
                                  'VMRSCode__c':component.get('v.VMRSCode'),'Volume__c':component.get('v.Volume'),'UnitofMeasure__c':component.get('v.UnitofMeasure'),'Length__c':component.get('v.Length'),'Width__c':component.get('v.Width'),'Height__c':component.get('v.height'),'Volumeunit__c':component.get('v.volunit'),'GrossWeight__c':component.get('v.GrossWeight'),'WeightUnit__c':component.get('v.WeightUnit'),'USPDCPackSize__c':component.get('v.USPDCPackSize'),'USDSPackSize__c':component.get('v.USDSPackSize'),'CAPDCPackSize__c':component.get('v.CAPDCPackSize'),'CADSPackSize__c':component.get('v.CADSPackSize')});
                    component.set('v.RecordforSave',ORecord);
                }
                //alert('SaveRecord function executing in 1 and 5'+JSON.stringify(component.get("v.RecordforSave")));                            
            }else if(SelectedValue=="5"){                
                Apc_Reason='Pack Size';
                var quantity1 =component.find("quantity1");       
                quantity1.showHelpMessageIfInvalid();
                //alert('quantity1'+quantity1);
                if(quantity1.get("v.validity").valid){
                    flag='true';
                    ORecord.push({'LOC_Code__c':component.get('v.dealerCode'),'Able_to_find_the_part_in_Paragon__c':'Yes','Part_No__c':component.get('v.OrderNumber'),'Pricing_Request__c':'No','Quantity__c':component.get('v.Quantity'),'Additional_Information__c':component.get('v.AdditionalInformation'),'Additional_Recipients__c':component.get('v.emailRecipient'),'APC_Reason__c':Apc_Reason,'isActive__c':component.get('v.isActive'),'Lead_Time_Reason__c':SubAction,'Part_Description__c':component.get('v.partdescription'),'Vendor_Code__c':component.get('v.vendor'),'Planner_Code__c':component.get('v.plannercode'),
                                  'VMRSCode__c':component.get('v.VMRSCode'),'Volume__c':component.get('v.Volume'),'UnitofMeasure__c':component.get('v.UnitofMeasure'),'Length__c':component.get('v.Length'),'Width__c':component.get('v.Width'),'Height__c':component.get('v.height'),'Volumeunit__c':component.get('v.volunit'),'GrossWeight__c':component.get('v.GrossWeight'),'WeightUnit__c':component.get('v.WeightUnit'),'USPDCPackSize__c':component.get('v.USPDCPackSize'),'USDSPackSize__c':component.get('v.USDSPackSize'),'CAPDCPackSize__c':component.get('v.CAPDCPackSize'),'CADSPackSize__c':component.get('v.CADSPackSize')});
                    component.set('v.RecordforSave',ORecord);
                }
            }else if(SelectedValue=="2"){
                var selectItelocation =component.find("selectItelocation");       
                selectItelocation.showHelpMessageIfInvalid();                        
                PDCLocation=component.get('v.SelectedPDCValue');
                if(PDCLocation=="1"){
                    PDCLocation='FL02-MEMPHIS';
                }else if(PDCLocation=="2"){
                    PDCLocation='FL19-CANTON';
                }else if(PDCLocation=="3"){
                    PDCLocation='FL20-ATLANTA';
                }else if(PDCLocation=="4"){
                    PDCLocation='FL24-BRIDGEPORT';
                }else if(PDCLocation=="5"){
                    PDCLocation='FL25-INDIANAPOLIS';
                }else if(PDCLocation=="6"){
                    PDCLocation='FL26-DALLAS';
                }else if(PDCLocation=="7"){
                    PDCLocation='FL28-DES MOINES';
                }else if(PDCLocation=="8"){
                    PDCLocation='FL43-RENO';
                }else if(PDCLocation=="9"){
                    PDCLocation='FL52-CALGARY';
                }
                if(selectItelocation.get("v.validity").valid){
                    flag='true';
                    ORecord.push({'LOC_Code__c':component.get('v.dealerCode'),'Able_to_find_the_part_in_Paragon__c':'Yes','Part_No__c':component.get('v.OrderNumber'),'Pricing_Request__c':'No','PDC__c':PDCLocation,'Additional_Information__c':component.get('v.AdditionalInformation'),'Additional_Recipients__c':component.get('v.emailRecipient'),'APC_Reason__c':'PDC Stock Check','isActive__c':component.get('v.isActive'),'Part_Description__c':component.get('v.partdescription'),'Vendor_Code__c':component.get('v.vendor'),'Planner_Code__c':component.get('v.plannercode'),
                                  'VMRSCode__c':component.get('v.VMRSCode'),'Volume__c':component.get('v.Volume'),'UnitofMeasure__c':component.get('v.UnitofMeasure'),'Length__c':component.get('v.Length'),'Width__c':component.get('v.Width'),'Height__c':component.get('v.height'),'Volumeunit__c':component.get('v.volunit'),'GrossWeight__c':component.get('v.GrossWeight'),'WeightUnit__c':component.get('v.WeightUnit'),'USPDCPackSize__c':component.get('v.USPDCPackSize'),'USDSPackSize__c':component.get('v.USDSPackSize'),'CAPDCPackSize__c':component.get('v.CAPDCPackSize'),'CADSPackSize__c':component.get('v.CADSPackSize')});
                    component.set('v.RecordforSave',ORecord);
                }
            }else if(SelectedValue=="3"){            
                var selectItem1 =component.find("selectItemreason");
                selectItem1.showHelpMessageIfInvalid();              
                ItemReason=component.get('v.SelectedReasonValue');
                //alert("ItemReason"+ItemReason);
                if(ItemReason=="1"){
                    ItemReason='Need to order';
                }else if(ItemReason=="2"){
                    ItemReason='Customer quote';
                }
                if(selectItem1.get("v.validity").valid){
                    flag='true';
                    ORecord.push({'LOC_Code__c':component.get('v.dealerCode'),'Able_to_find_the_part_in_Paragon__c':'Yes','Part_No__c':component.get('v.OrderNumber'),'Pricing_Request__c':'No','Reactivation_Reason__c':ItemReason,'Additional_Information__c':component.get('v.AdditionalInformation'),'Additional_Recipients__c':component.get('v.emailRecipient'),'APC_Reason__c':'Reactivation','isActive__c':component.get('v.isActive'),'Part_Description__c':component.get('v.partdescription'),'Vendor_Code__c':component.get('v.vendor'),'Planner_Code__c':component.get('v.plannercode'),
                                  'VMRSCode__c':component.get('v.VMRSCode'),'Volume__c':component.get('v.Volume'),'UnitofMeasure__c':component.get('v.UnitofMeasure'),'Length__c':component.get('v.Length'),'Width__c':component.get('v.Width'),'Height__c':component.get('v.height'),'Volumeunit__c':component.get('v.volunit'),'GrossWeight__c':component.get('v.GrossWeight'),'WeightUnit__c':component.get('v.WeightUnit'),'USPDCPackSize__c':component.get('v.USPDCPackSize'),'USDSPackSize__c':component.get('v.USDSPackSize'),'CAPDCPackSize__c':component.get('v.CAPDCPackSize'),'CADSPackSize__c':component.get('v.CADSPackSize')});
                    component.set('v.RecordforSave',ORecord);
                }
            }
                else if(SelectedValue=="4"){
                    flag='true';
                    ORecord.push({'LOC_Code__c':component.get('v.dealerCode'),'Able_to_find_the_part_in_Paragon__c':'Yes','Part_No__c':component.get('v.OrderNumber'),'Pricing_Request__c':'No','Additional_Information__c':component.get('v.AdditionalInformation'),'Additional_Recipients__c':component.get('v.emailRecipient'),'APC_Reason__c':'Weight and Dimensions','isActive__c':component.get('v.isActive'),'Part_Description__c':component.get('v.partdescription'),'Vendor_Code__c':component.get('v.vendor'),'Planner_Code__c':component.get('v.plannercode'),
                                  'VMRSCode__c':component.get('v.VMRSCode'),'Volume__c':component.get('v.Volume'),'UnitofMeasure__c':component.get('v.UnitofMeasure'),'Length__c':component.get('v.Length'),'Width__c':component.get('v.Width'),'Height__c':component.get('v.height'),'Volumeunit__c':component.get('v.volunit'),'GrossWeight__c':component.get('v.GrossWeight'),'WeightUnit__c':component.get('v.WeightUnit'),'USPDCPackSize__c':component.get('v.USPDCPackSize'),'USDSPackSize__c':component.get('v.USDSPackSize'),'CAPDCPackSize__c':component.get('v.CAPDCPackSize'),'CADSPackSize__c':component.get('v.CADSPackSize')});
                    component.set('v.RecordforSave',ORecord);    
                }
            
        }
        console.log(JSON.stringify(component.get('v.RecordforSave')));
     if(flag=='true'){
        var rec = component.get('v.RecordforSave');
        //var action = component.get('c.CaseSubmitOrder');                   
        var action = component.get('c.submitOrderRecords');
        var dealerContact = component.get('v.dealerContact');
        $A.util.removeClass(component.find("spinner2"), "slds-hide");
        /*action.setParams({
            'Odt' : rec
        });*/
         action.setParams({
                params : {},               
             	Odt : rec,
             ContactRole : dealerContact
            });
        action.setCallback(this,function(res){
            $A.util.addClass(component.find("spinner2"), "slds-hide");
            var state = res.getState();
            //alert("state"+state+'values'+JSON.stringify(component.get("v.RecordforSave").length));
            if(state=='SUCCESS'){
                if(IsPricing=="No"){                    
                     let result = res.getReturnValue();
                     //alert('Line Number@@@@210'+JSON.stringify(result));
                     component.find("fileUpload").uploadToRecord(result[0].Id);
                }
                else{
                    if(IsPricing=="Yes" && component.get("v.RecordforSave").length>0){
                        //alert('Line Number@@@@215');
                        $A.util.addClass(component.find("spinner2"), "slds-hide");
                        component.find('notifLib').showNotice({
                            "variant": "success",
                            "header": "Success!",
                            "message": "Case is created successfully.",
                            closeCallback: function() {
                                //location.reload();
                                component.find("navService").navigate({    
                                    type: "standard__namedPage",
                                    attributes: {
                                        "pageName": "home"    
                                    }
                                });
                            }
                        }); 
                    }
                }
            }else {
                helper.apexCallbackElse(component,event,helper,res);
            }             
        });
        $A.enqueueAction(action); 
       }
    },
    getContacts :function(component,event,helper){
        var code = component.get('v.dealerCode');
        console.log('getting contacts for:'+code);
         var action = component.get('c.getDealerContacts'); 
        action.setParams({
            'dealerCode' : code
        });
        
        action.setCallback(this,function(res){
            var state = res.getState();
            //alert("state"+state);
            if(state=='SUCCESS'){
          		console.log( res.getReturnValue());    
                component.set("v.contactsPicklistValues", res.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
    },
    uploadingSave : function(component, event, helper, parentId){
        var fileInput = component.find("fileId").get("v.files");
        //alert('In Line Number 41'+fileInput.length);
        if(fileInput.length > 0){
            var file = fileInput[0];
            var fr = new FileReader();
            var self = this;
            fr.onload = function() {
                var fileContents = fr.result;
                var base64Mark = 'base64,';
                var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
                fileContents = fileContents.substring(dataStart);
                self.upload(component, file, fileContents, parentId);
            };
            fr.readAsDataURL(file);
        }
    },
    apexCallbackElse : function(component,event,helper,response){
        let state = response.getState();
        if (state === "INCOMPLETE") {
            helper.showToast(component,"INCOMPLETE!","INCOMPLETE","warning");
        }
        else if (state === "ERROR") {
            let errors = response.getError();
            if (errors) {
                if (errors[0] && errors[0].message) {
                    helper.showToast(component,"ERROR!","Error message: " + errors[0].message,"error");
                }
            } else {
                console.log("Unknown error");
                helper.showToast(component,"ERROR!","Unknown error","error");
            }
        }
    },
    showToast : function(component,title,msg,variant){
        component.find('notifLib').showToast({
            title: title,
            message: msg,
            variant: variant
        });
    },
    upload: function(component, file, fileContents, parentId) {
        var action = component.get("c.saveTheFile"); 
 		//alert('Line Number59999'+parentId);
        action.setParams({
            parentId:parentId,
            fileName: file.name,
            base64Data: encodeURIComponent(fileContents), 
            contentType: file.type
        });
 
        action.setCallback(this, function(a) {
            var state = a.getState();
            //alert('In Line Number 68'+state);
            if(state == 'SUCCESS'){
                if(a.getReturnValue()){                   
                    component.find("fileId").set("v.files",'');                  
                }
            }
            
        });
        $A.enqueueAction(action);  
    },
    mainReference: 0,
    fetchCasesFromTypeNumber: function(component, event, helper, conditions) {
        $A.util.removeClass(component.find("spinner"),"slds-hide");
		let localReference = helper.mainReference = new Date().getTime();
        
    	var action = component.get('c.getCasesFromTypeNumber');
        action.setParams({
            conditions: conditions
        });
        action.setCallback(this,function(response){
            if(localReference===helper.mainReference) {
                $A.util.addClass(component.find("spinner"),"slds-hide");
                var state = response.getState();
                if(state=='SUCCESS'){
                    let cases = response.getReturnValue();
                    console.log("cases => ", JSON.stringify(cases));
                    if(cases && cases.length>0) {
                        let message = "";
                        let unResolvedCase = cases.find(rec=>rec.Status!=="Resolved");
                        if(unResolvedCase) {
                            message = "Case already exists. Do you want to go to case?";
                        } else {
                            message = "Case is resolved. Do you want to create new case?";
                        }
                        setTimeout(function() {
                            let caseModal = {
                                show: true,
                                message: message,
                                isResolved: unResolvedCase ? false : true,
                                caseId: unResolvedCase ? unResolvedCase.Id : "",
                                noFunction: function() {
                                    component.find("navService").navigate({    
                                        type: "comm__namedPage",
                                        attributes: {
                                            "pageName": "home"    
                                        }
                                    });
                                }
                            };
                            console.log("caseModal => ", caseModal);
                            component.set("v.caseModal", caseModal);
                        }, 0);
                    }else{                        
                     	helper.SaveRecord(component,event,helper);
                    }
                } else {
                     helper.apexCallbackElse(component,event,helper,response);                    
                }
            }
        });
        
        $A.enqueueAction(action);
    },
})