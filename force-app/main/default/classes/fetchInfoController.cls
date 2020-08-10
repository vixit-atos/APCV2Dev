/**
 * @File Name          : fetchInfoController.cls
 * @Description        : 
 * @Author             : VIXIT BHARDWAJ - ATOS SYNTEL INC
 * @Group              : 
 * @Last Modified By   : VIXIT BHARDWAJ - ATOS SYNTEL INC
 * @Last Modified On   : 4/7/2020, 8:20:01 AM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    4/7/2020   VIXIT BHARDWAJ - ATOS SYNTEL INC     Initial Version
**/
public class fetchInfoController{

    @AuraEnabled
    public static Profile getUserProfile() {
        List<Profile> profile = [SELECT Name FROM Profile WHERE ID =: UserInfo.getProfileId() LIMIT 1];
        //System.debug('getUserProfile'+ profile[0]);
        return profile[0];
    }
}