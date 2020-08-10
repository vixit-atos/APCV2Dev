public class AdminTool_TriggerHandler extends TriggerHandler
{
    public static boolean beforeInsert = false;
    public static boolean afterInsert = false;
    public static boolean beforeUpdate = false;
    public static boolean afterUpdate = false;
    public static boolean beforeDelete = false;
    public static boolean afterDelete = false;
    
    public override void beforeInsert()
    {
        if(Trigger.isBefore && Trigger.isInsert && !beforeInsert)
        {
            beforeInsert = true;
            AdminTool_Wrapper obj = new AdminTool_Wrapper();
            //====== preventDML used to prevent creation of new record of FMV Date record type =====
            obj.preventDML((List<Administrative_Tool__c>)trigger.new);
            obj.validateDuplicate((List<Administrative_Tool__c>)trigger.new);
            
            //====== Update disclaimer of PDF Disclaimer Management record type =======
            obj.updateDisclaimer((List<Administrative_Tool__c>)trigger.new);
        }
    }
    public override void afterInsert()
    {
        if(trigger.isAfter && trigger.isInsert && !afterInsert)
        {
            afterInsert = true;
        }
    }
    public override void beforeUpdate()
    {
        if(trigger.isBefore && trigger.isUpdate && !beforeUpdate)
        {
            beforeUpdate = true;
            AdminTool_Wrapper obj = new AdminTool_Wrapper();
            obj.validateDuplicate((List<Administrative_Tool__c>)trigger.new, (List<Administrative_Tool__c>)trigger.old);
            
            //====== Update disclaimer of PDF Disclaimer Management record type =======
            obj.updateDisclaimer((List<Administrative_Tool__c>)trigger.new);
        }
    }
    public override void afterUpdate()
    {
        if(Trigger.isAfter && Trigger.isUpdate && !afterUpdate)
        {
            afterUpdate = true;
            AdminTool_Wrapper obj = new AdminTool_Wrapper();
            //====== Update QQ_Master with FMV Date of FMV Date record type =====
            obj.updateMaster((map<ID, Administrative_Tool__c>)trigger.newMap, (map<ID, Administrative_Tool__c>)trigger.oldMap);
        }
    }
    public override void beforeDelete()
    {
        if(Trigger.isBefore && Trigger.isDelete && !beforeDelete)
        {
            beforeDelete = true;
            AdminTool_Wrapper obj = new AdminTool_Wrapper();
            //====== PreventDML used to prevent deletion of record of FMV Date record type =====
            obj.preventDML((List<Administrative_Tool__c>)trigger.old);
        }
    }
    public override void afterDelete()
    {
        if(Trigger.isAfter && Trigger.isDelete && !afterDelete)
        {
            afterDelete = true;
        }
    }
}