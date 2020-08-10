/**
 * @File Name          : FeedCommentTriggerHandler.cls
 * @Description        : 
 * @Author             : VIXIT BHARDWAJ - ATOS SYNTEL INC
 * @Group              : 
 * @Last Modified By   : VIXIT BHARDWAJ - ATOS SYNTEL INC
 * @Last Modified On   : 5/12/2020, 3:18:16 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    5/12/2020   VIXIT BHARDWAJ - ATOS SYNTEL INC     Initial Version
**/
public with sharing class FeedCommentTriggerHandler extends TriggerHandler{
	public static boolean beforeInsert = false;
	public static boolean afterInsert = false;

    public override void beforeInsert(){
		if (trigger.isBefore && trigger.isInsert && !beforeInsert){
			beforeInsert = true;
		}
    }
	public override void afterInsert(){
		if (trigger.isAfter && trigger.isInsert && !afterInsert){
			afterInsert = true;
            FeedCommentAction obj = new FeedCommentAction();
            obj.updateStatus(Trigger.new);
		}
	}
/*
    public override void beforeUpdate(){}
    public override void afterUpdate(){}
    public override void beforeDelete(){}
    public override void afterDelete(){}  
*/
}