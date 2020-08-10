@isTest
public class RoleUtils_Test {
    //Test method to fetch the sub ordinates users
	@isTest
    public static void runTest()
    {
        Try
         {
            //get roleid
            String roleid = UserInfo.getUserRoleId();
            //get subordinate users
            Set<ID> abc = RoleUtils.getRoleSubordinateUsers(roleid);
             
             
            //get roleid
            UserRole SMRSpecialistUser =  [SELECT Id FROM UserRole WHERE Name = 'SMR Specialist' LIMIT 1];
            //get subordinate users
            Set<ID> specialistSubordinates = RoleUtils.getRoleSubordinateUsers(SMRSpecialistUser.Id);
		 }
         Catch(Exception e)
         {
             system.debug('exception '+e.getMessage());
         }
    }
}