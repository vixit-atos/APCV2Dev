/**
    * ─────────────────────────────────────────────────────────────────────────────────────────────────┐
    * One or two sentence summary of this class.
    *
    * This classes is used to Update Mainframeid  
    * 
    * ──────────────────────────────────────────────────────────────────────────────────────────────────
    * @author         Hareesh goud nellykonda   
    * @modifiedBy          
    * @version        1.0
    * @created        05-03-2017
    * @modified       MM-DD-YYYY
    * ──────────────────────────────────────────────────────────────────────────────────────────────────
    * @changes
    * modifiedBy            
    * MM-DD-YYYY      Explanation of the change.  Multiple lines can be used to explain the change, but
    *                 each line should be indented till left aligned with the previous description text.
    *
    * modifiedBy           
    * MM-DD-YYYY      Each change to this file should be documented by incrementing the version number,
    *                 and adding a new entry to this @changes list. Note that there is a single blank
    *                 line between each @changes entry.
    * ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public with sharing class DTNA_UserMainFramIDdisplaycontroller {   
    String Logedinuserid;
    public String selectedValue{get;set;}
    List<UserMainframeID__c> lstUserMainframeids  {get; set;}  
    
    public DTNA_UserMainFramIDdisplaycontroller(){
        Logedinuserid =UserInfo.getUserId();
        lstUserMainframeids  =new List<UserMainframeID__c>();
        
    }
     /*******************************************************************************************************
    * @description: this method is used to get logedinuser mainfameids 
    *               
    * @return : List<SelectOption> 
    */
    public List<SelectOption> getmainframids(){   
        List<SelectOption> option = new List<SelectOption>();
        for(UserMainframeID__c ObjUserMainframeID: [select id,name,User__c,User__r.Mainframe_ID__c from UserMainframeID__c where User__c =:Logedinuserid  ]){
            if(ObjUserMainframeID.name==ObjUserMainframeID.User__r.Mainframe_ID__c){
                selectedValue=ObjUserMainframeID.User__r.Mainframe_ID__c;
            }
            option.add(new SelectOption(ObjUserMainframeID.name,ObjUserMainframeID.name));
            
        }
        return option;      
    }
    /*******************************************************************************************************
    * @description: this method is used to Update MainFrameid selected by user 
    *               
    * @return : Void
    */
    public Void SaveselectedMainframeid() {
        User objuser=[select id,Mainframe_ID__c from user where id =:Logedinuserid];
        User objusertoupdate =new User();
        String strMainframeidupdate= Label.Mainframe_Id_Update_message;

        objusertoupdate.id=objuser.id;
        objusertoupdate.Mainframe_ID__c =selectedValue;
        if(objusertoupdate!=null) {  
            try{   
                update objusertoupdate;
                
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,strMainframeidupdate);
                ApexPages.addMessage(myMsg);
            }Catch(Exception e){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,+e.getMessage());
                ApexPages.addMessage(myMsg);
                system.debug('Print  Exception : '+e);
            }
        }
        
    }
    
    
}