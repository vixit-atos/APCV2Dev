@isTest
public class ChatterTemplateControllerTest 
{
public static testmethod void getDependentMapTest()
{
	sObject sObj = Schema.getGlobalDescribe().get('Template__c').newSObject() ;
	ChatterTemplateController.getDependentMap(sObj,'Group_Assigned__c','Title_c__c');	
}

public static testmethod void fetchTemplateTest()
{
	Template__c newChatter = new Template__c();
	newChatter.Group_Assigned__c = 'Inside Sales';
	newChatter.Title_c__c = 'Cancel Confirmed';
	newChatter.Template__c = 'Hello, This is a test Template';
	insert newChatter;

	String theTemplate = ChatterTemplateController.fetchTemplate('Inside Sales', 'Cancel Confirmed');
	system.assertEquals(theTemplate, 'Hello, This is a test Template', 'Right template should have been returned');
}
}