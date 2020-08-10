@isTest(SeeAllData=true)
public class TableauReport_test {
    
   public static testMethod void testTableauReport(){
      
        List<Group> TRgroup=[Select Id From group where group.Name='Tableau Report NAM'];
   //    system.debug('****'+TRgroup);
       
      // Group gp = new Group();
     //  gp.Name = 'Tableau Report NAM';
     //  gp.Id='00G3D000000iF1YUAU';
       User thisUser= [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
     GroupMember grpMem1 = new GroupMember();
     grpMem1.GroupId = TRgroup.get(0).Id; 
       grpMem1.UserOrGroupId = thisUser.Id;
      Database.insert(grpMem1);
       Region__c TR = new Region__c();
       ApexPages.StandardController sc = new ApexPages.StandardController(TR);   
       TableauReport  Regi = new TableauReport (sc);  
      
   }
}