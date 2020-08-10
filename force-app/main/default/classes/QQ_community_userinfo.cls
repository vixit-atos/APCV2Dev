public class QQ_community_userinfo {
    
   @AuraEnabled 
    public static user fetchUser(){
       User u = [select id,Name from User where id =: userInfo.getUserId()];
        return u;
    }
    
    @AuraEnabled 
    public static string fetchURL(string communityname)
    {
       String fullUrl;
       Network myNetwork = [SELECT Id FROM Network WHERE Name =:communityname];
   	   fullUrl = Network.getLoginUrl(myNetwork.id);
	   return fullUrl;
    }


}