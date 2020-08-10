/**
* @File Name          : APC_TemplateController.apxc
* @Description        : Displays Templates in Internal case detail page.
* @Developer          :	Akhila Putta,Sumit Kumar Datta
Null Checks added 04/13/2020 SKD
**/

public With Sharing class APC_TemplateController {
    @AuraEnabled 
    public static Map<String, List<String>> getDependentMap(sObject objDetail, string contrfieldApiName,string depfieldApiName) {
        String controllingField = contrfieldApiName.toLowerCase();
        String dependentField = depfieldApiName.toLowerCase();
        
        Map<String,List<String>> objResults = new Map<String,List<String>>();
        
        Schema.sObjectType objType = objDetail.getSObjectType();
        if (objType==null){
            return objResults;
        }
        
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        
        if (!objFieldMap.containsKey(controllingField) || !objFieldMap.containsKey(dependentField)){
            return objResults;     
        }
        
        Schema.SObjectField theField = objFieldMap.get(dependentField);
        Schema.SObjectField ctrlField = objFieldMap.get(controllingField);
        
        
        List<Schema.PicklistEntry> contrEntries = ctrlField.getDescribe().getPicklistValues();
        List<PicklistEntryWrapper> depEntries = wrapPicklistEntries(theField.getDescribe().getPicklistValues());
        List<String> controllingValues = new List<String>();
        
        for (Schema.PicklistEntry ple : contrEntries) {
            String label = ple.getLabel();
            objResults.put(label, new List<String>());
            controllingValues.add(label);
        }
        String roleName = getProfileInfo();
        for (PicklistEntryWrapper plew : depEntries) {
            string stractive  = plew.active;
            if(stractive!=null)
                stractive = stractive.toLowerCase();
            if(roleName == 'apc supervisor' || stractive == 'true'){
                String label = plew.label;
                String validForBits = base64ToBits(plew.validFor);
                for (Integer i = 0; i < validForBits.length(); i++) {
                    String bit = validForBits.mid(i, 1);
                    if (bit == '1') {
                        objResults.get(controllingValues.get(i)).add(label);
                    }
                }
            }
        }
        return objResults;
    }
    
    @AuraEnabled 
    public static Template__c fetchTemplate(String theGroup, String theTitle)
    {
        Template__c returntemplte = new Template__c(); 
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;     
        returntemplte = [Select ID,Template__c,Description__c,IsActive__c FROM Template__c WHERE Group_Assigned__c =: theGroup AND Title_1__c =: theTitle ORDER BY Title_1__c];
        return returntemplte;
    }
    
    @AuraEnabled 
    public static list<string> fetchTitles(String theGroup, boolean isadmin)
    {     
        list<string> titlespicklist = new list<string>();
        list<Template__c> titlelist = new list<Template__c>();
        if(isadmin){
            titlelist = [Select Title_1__c FROM Template__c WHERE Group_Assigned__c =: theGroup ORDER BY  Title_1__c];
        }
        else{
            titlelist = [Select Title_1__c FROM Template__c WHERE Group_Assigned__c =: theGroup and IsActive__c=true ORDER BY  Title_1__c ];
        }
        if(!titlelist.isEmpty()){
            for(Template__c objtemplate: titlelist){
                
                titlespicklist.add(objtemplate.Title_1__c);
            }
        }        
        return titlespicklist;        
    }
    
    @AuraEnabled
    public static string getProfileInfo(){
        try{
            String profileId = UserInfo.getProfileId();
            return [SELECT Id, Name FROM Profile WHERE Id =:profileId].Name;
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage()); 
        }
    }
    
    @AuraEnabled
    public static string getRoleInfo(){
        String roleName ='';
        try{
            String userId = UserInfo.getUserId();
            User objUser = [select id,Name,UserRole.Name from User where id=:userId];
            if( objUser.UserRole.Name !=null )
                roleName = objUser.UserRole.Name.toLowercase();
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage()); 
        }
        return roleName;
    }
    
    @AuraEnabled
    public static string saveTemplate(string templateid, string groupassigned, string title, string description, boolean isactive, string templatedata, boolean isnew){
        String result ='';
        try{
            Template__c objtemplate = new Template__c();
            if(!isnew){
                objtemplate  = [Select ID,Group_Assigned__c,Title_1__c,Template__c,Description__c,IsActive__c FROM Template__c where Title_1__c=:title limit 1];
            }
            objtemplate.Group_Assigned__c = groupassigned;
            objtemplate.Title_1__c = title;
            objtemplate.Description__c = description;
            if(isactive!=null){
                objtemplate.IsActive__c = isactive;
            }
            objtemplate.Template__c = templatedata;
            upsert objtemplate;
            result = 'success';
        }catch(Exception e){
            result = e.getMessage();
            throw new AuraHandledException(e.getMessage()); 
        }
        return result;
    }
    
    public static String decimalToBinary(Integer val) {
        String bits = '';
        while (val > 0) {
            Integer remainder = Math.mod(val, 2);
            val = Integer.valueOf(Math.floor(val / 2));
            bits = String.valueOf(remainder) + bits;
        }
        return bits;
    }
    
    public static String base64ToBits(String validFor) {
        if (String.isEmpty(validFor)) return '';
        
        String validForBits = '';
        
        for (Integer i = 0; i < validFor.length(); i++) {
            String thisChar = validFor.mid(i, 1);
            Integer val = base64Chars.indexOf(thisChar);
            String bits = decimalToBinary(val).leftPad(6, '0');
            validForBits += bits;
        }
        
        return validForBits;
    }
    
    private static final String base64Chars = '' +
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
        'abcdefghijklmnopqrstuvwxyz' +
        '0123456789+/';
    
    
    private static List<PicklistEntryWrapper> wrapPicklistEntries(List<Schema.PicklistEntry> PLEs) {
        return (List<PicklistEntryWrapper>)
            JSON.deserialize(JSON.serialize(PLEs), List<PicklistEntryWrapper>.class);
    }
    
    public class PicklistEntryWrapper{
        public String active {get;set;}
        public String defaultValue {get;set;}
        public String label {get;set;}
        public String value {get;set;}
        public String validFor {get;set;}
        public PicklistEntryWrapper(){            
        }
        
    }
    
    public class PicklistWrapper{        
        public String label {get;set;}
        public String value {get;set;}        
    }
}