@isTest public class fetchInfoControllerTest {
    @isTest static void testGetProfile(){
        Profile testProfile = new Profile();
        Test.startTest();
        List<Profile> testProfileList = [SELECT ID, Name FROM Profile WHERE Name LIKE 'DTNA - WST Sales' LIMIT 1];
        if(testProfileList.size() > 0){
            List<User> testUser = [SELECT ID, ProfileID FROM User WHERE ProfileID = :testProfileList[0].Id AND isActive = TRUE];
            if(testUser.size() > 0){
                system.runas(testUser[0]){
                    testProfile = fetchInfoController.getUserProfile();
                }
            }
        }
        Test.StopTest();
        system.assertEquals('DTNA - WST Sales', testProfile.Name);
    }
}