@isTest
public class PartnerUserPlusTabControllerTest {
    public static testMethod void testPartnerUserPlusTabController(){        
        Test.startTest();
        PartnerUserPlusTabController testPartnerUserPlusTabController = new PartnerUserPlusTabController();
        testPartnerUserPlusTabController.setupObj();
        testPartnerUserPlusTabController.addObjectLinkAsPair();
        Test.stopTest();
        
    }
    
    public static testMethod void testObject(){
        PartnerUserPlusTabController.objectLink testObject1 = new PartnerUserPlusTabController.ObjectLink('Account', 'google.com', 'google.jpg');
        system.assertEquals(testObject1.objectName, testObject1.getObjectName());  
        system.assertEquals(testObject1.Url, testObject1.getUrl());  
        system.assertEquals(testObject1.ImgUrl, testObject1.getImgUrl());  
        system.assertEquals(testObject1.iconClass, testObject1.geticonClass());  
        system.assertEquals(testObject1.iconUrl, testObject1.geticonUrl());  
        system.assertEquals(testObject1.mobile, testObject1.getmobile());
        
        PartnerUserPlusTabController.objectLink testObject2 = new PartnerUserPlusTabController.ObjectLink('Account', 'google.com', 'google.jpg', 'iconURL', 'iconURL');
        system.assertEquals(testObject2.objectName, testObject2.getObjectName());  
        system.assertEquals(testObject2.Url, testObject2.getUrl());  
        system.assertEquals(testObject2.ImgUrl, testObject2.getImgUrl());  
        system.assertEquals(testObject2.iconClass, testObject2.geticonClass());  
        system.assertEquals(testObject2.iconUrl, testObject2.geticonUrl());  
        system.assertEquals(testObject2.mobile, testObject2.getmobile());
        
        PartnerUserPlusTabController.objectLink testObject3 = new PartnerUserPlusTabController.ObjectLink();
        system.assertEquals(testObject3.objectName, testObject3.getObjectName());  
        system.assertEquals(testObject3.Url, testObject3.getUrl());  
        system.assertEquals(testObject3.ImgUrl, testObject3.getImgUrl());  
        system.assertEquals(testObject3.iconClass, testObject3.geticonClass());  
        system.assertEquals(testObject3.iconUrl, testObject3.geticonUrl());  
        system.assertEquals(testObject3.mobile, testObject3.getmobile());
        
        PartnerUserPlusTabController.objectPair testObjectPair = new PartnerUserPlusTabController.objectPair(testObject1, testObject2);
        system.assertEquals(testObjectPair.leftObj, testObjectPair.getleftObj());
        system.assertEquals(testObjectPair.rightObj, testObjectPair.getrightObj());
    }

}