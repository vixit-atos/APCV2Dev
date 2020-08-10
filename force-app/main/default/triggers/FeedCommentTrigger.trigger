/**
 * @File Name          : FeedCommentTrigger.trigger
 * @Description        : 
 * @Author             : VIXIT BHARDWAJ - ATOS SYNTEL INC
 * @Group              : 
 * @Last Modified By   : VIXIT BHARDWAJ - ATOS SYNTEL INC
 * @Last Modified On   : 5/12/2020, 3:19:39 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    5/12/2020   VIXIT BHARDWAJ - ATOS SYNTEL INC     Initial Version
**/
trigger FeedCommentTrigger on FeedComment (
    before insert,
    after insert) {
        
    new FeedCommentTriggerHandler().run();
        
}