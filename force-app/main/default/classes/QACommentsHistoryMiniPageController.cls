public with sharing class QACommentsHistoryMiniPageController 
{
    
    public id str {get;set;}                     //stores the value of the parameter(Concession id)
    public boolean showbutton {get;set;} // Used to render the back button
    public String button {get;set;}      // Used to store the parameter value which toggles the visibility of back button
    public List<Quote_Activity_Comment_History__c > QACommentsHistory {get;set;}  // Used to store and display Coments History
    public List<Quote_Activity_Comment_History__c> CommentsList;                     // Used to query and store related comments
    public String URL {get;set;}
    public String ProfileName {get;set;}

    public QACommentsHistoryMiniPageController ()
    {
        try
        {
            String strUserId = UserInfo.getUserId();
            ProfileName = [Select Profile.Name from User where Id = :strUserId].Profile.Name;
            str = ApexPages.currentPage().getParameters().get('ConcessionId') ;//Currentpage.getparameter('ConcessionId');   // retrieve the parameter
            URL= ApexPages.currentPage().getParameters().get('retURL');
            button =ApexPages.currentPage().getParameters().get('button');  // retrieve the parameter
            if (button == 'true')
                showbutton=false;                                                                                   // rendering the back button
            else
                showbutton=true ;
            
            system.debug('######'+str);
             
            if(str!=null && ProfileName.Contains('DOA'))
                CommentsList= [select ConcessionId__c,Concession_Number__c, Comment__c,Date_time__c,CreatedBy.Name,RecordType.Name from Quote_Activity_Comment_History__c where ConcessionId__c =: str ORDER BY Date_time__c desc ];
            else if(str!=null)
                CommentsList= [select ConcessionId__c,Concession_Number__c, Comment__c,Date_time__c,CreatedBy.Name,RecordType.Name from Quote_Activity_Comment_History__c where RecordType.Name = 'Deal Comments' and ConcessionId__c =: str ORDER BY Date_time__c desc ];

        }
        catch(Exception e)
        {
            system.debug(e);
        }
        
        QACommentsHistory = CommentsList;
        system.debug('******************'+CommentsList);
        system.debug('******************'+QACommentsHistory);
        system.debug('******************'+QACommentsHistory);
    
    }
    
    public PageReference returnback()  // back button click
    {
        
        //PageReference pageRef= new PageReference('/apex/QuoteActivityConc');
        PageReference pageRef= new PageReference(URL);
        //PageReference pageRef= new PageReference('/apex/QuoteActivityConcMobile');
        //pageRef.setredirect(true); 
        
        return pageRef;
    }
    
}