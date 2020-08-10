public class TableauReport {

//List<Id> usersIdsInGroup= new List<Id>();

public Boolean UserInGroup{get;set;}


    public TableauReport(ApexPages.StandardController controller) {
       UserInGroup= False;
       
        List<GroupMember> groupMembers=[Select Id, group.type, UserOrGroupId From GroupMember where group.Name='Tableau Report NAM'];
    
        for(GroupMember gm : groupMembers){
        if(userinfo.getUserid()== gm.UserOrGroupId ){
            //usersIdsInGroup.add(gm.UserOrGroupId);
            UserInGroup=true;
            break;
            }
       }
    }
}