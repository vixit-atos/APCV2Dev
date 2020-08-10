@isTest
public class QQ_community_userinfo_Test {

    @isTest
    public static void runTest()
    {
        Test.startTest();
        QQ_community_userinfo.fetchUser();
        QQ_community_userinfo.fetchURL('External Quick Quote');
        Test.stopTest();
    }
}