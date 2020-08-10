public  Without Sharing class APC_Custom_ChatterRelated {
  @AuraEnabled
    public static list<feeditem> fetchcasefeeditem(string recordId){
        list<feeditem> feeds = new list<feeditem>();
        feeds = [Select id, Body, CommentCount, CreatedDate, LikeCount, LinkUrl, ParentId, RelatedRecordId, Title, Type, SystemModstamp,CreatedBy.Name,
                 (SELECT Id, CommentBody, CreatedDate, CreatedBy.Name, FeedItemId, ParentId,SystemModstamp FROM FeedComments order by createddate desc) 
                 from feeditem where ParentId =:recordId and Type <> 'EmailMessageEvent'];
        return feeds;
    }
    @AuraEnabled
    public static list<feeditem> insertfeedcommentonfeeditem(string FeedItemId, string commentbody, string recordId){
        boolean commentinserted = false;
        FeedComment fc = new FeedComment(CommentBody=commentbody,FeedItemId = FeedItemId);
        list<feeditem> feeds = new list<feeditem>();
        try{
            insert fc;
            commentinserted = true;
        }catch(exception e){
            commentinserted = false;
            system.debug(e.getMessage());
        }      
        if(commentinserted){
           
            feeds = [Select id, Body, CommentCount, CreatedDate, LikeCount, LinkUrl, ParentId, RelatedRecordId, Title, Type, SystemModstamp,CreatedBy.Name,
                     (SELECT Id, CommentBody, CreatedDate, CreatedBy.Name, FeedItemId, ParentId,SystemModstamp FROM FeedComments order by createddate desc) 
                     from feeditem where ParentId =:recordId and Type <> 'EmailMessageEvent'];
            
        }
        return feeds;
    }
}