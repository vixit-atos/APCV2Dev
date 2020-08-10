@isTest
public class TemplateController_Test 
{
    public static testmethod void getDependentMapTest()
    {
        sObject sObj = Schema.getGlobalDescribe().get('Template__c').newSObject() ;
        TemplateController.getDependentMap(sObj,'Group_Assigned__c','Title_c__c');
        TemplateController.getDependentMap(sObj,'Group_Assigned__c','Title_1__c');	
        return;
    }
    
    public static testmethod void fetchTemplateTest()
    {
        Template__c newTemplate = new Template__c();
        newTemplate.Group_Assigned__c = 'Core Team';
        newTemplate.Title_1__c = 'Cancel Confirmed';
        newTemplate.Template__c = 'Hello, This is a test Template';
        insert newTemplate;
        
      Template__c Template = TemplateController.fetchTemplate('Core Team', 'Cancel Confirmed');
      system.assertEquals(Template.Template__c, 'Hello, This is a test Template');
        TemplateController.getRoleInfo();
		TemplateController.saveTemplate(template.id, 'Core Team', 'Cancel Confirmed', 'description', true, 'templatedata', false);
        try{
            TemplateController.saveTemplate(null, null, null, null, true, null, false);
        }catch(Exception ex){}
        TemplateController.PicklistEntryWrapper obj = new TemplateController.PicklistEntryWrapper();
        obj.defaultValue = 'test';
        obj.value = 'test';
    }
    
    public static testmethod void fetchTitlesTest()
    {
        /*String newTitle = new Title_1__c();
        newTemplate.Group_Assigned__c = 'Core Team';
        newTemplate.Title_1__c = 'Cancel Confirmed';
        newTemplate.Template__c = 'Hello, This is a test Template';
        insert newTitle;*/
        
      TemplateController.fetchTitles('Core Team',true);
      //system.assertEquals(Template.Title_1__c, 'Cancel Confirmed');
    }
}