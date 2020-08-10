({
	initializeComponent : function(cmp, event, helper) {
		helper.getEWRInformation(cmp);
	},
    
    addEWRs : function(cmp, event, helper){
        helper.attachEWRs(cmp);
        helper.getEWRInformation(cmp);
        cmp.set("v.ewrString", "");
    },
})