@istest
public class DTNA_UserMainFramIDdisplaycnrl_Test {
     static testMethod void Testmethod1() {
          User NAEuser =[select id,name,Mainframe_ID__c from  User where  SalesUserRole__c='NAE' Limit 1];
         UserMainframeID__c objUserMainframeId =new UserMainframeID__c();
          objUserMainframeId.Name='Test';
         objUserMainframeId.User__c=NAEuser.id;
         insert objUserMainframeId;
        
         
         DTNA_UserMainFramIDdisplaycontroller objusermf=new DTNA_UserMainFramIDdisplaycontroller();
         objusermf.SaveselectedMainframeid();
         objusermf.getmainframids();
     }

}