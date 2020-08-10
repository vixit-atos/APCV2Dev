public class PartnerUserPlusTabController {
    public List<objectPair> ObjectLinkToShow{get;set;}
    public List<objectLink> allObjectLink{get;set;}
    
    public PartnerUserPlusTabController()
    {
        ObjectLinkToShow = new List<objectPair>();
        allObjectLink = new List<objectLink>();
        setupObj();
        addObjectLinkAsPair();
    }
    
    @TestVisible
    private void addObjectLinkAsPair(){
        Integer sizeOfObject = allObjectLink.size();
        List<objectLink> rightObjectList = new List<objectLink>();
        List<objectLink> leftObjectList = new List<objectLink>();
        Integer check =  (Integer)Math.ceil((double)sizeOfObject / 2.0); 
        for (Integer i = 0; i < allObjectLink.size(); i++){
            if (i < check){
                leftObjectList.add(allObjectLink.get(i));
            }
            else{
                rightObjectList.add(allObjectLink.get(i));
            }
        }       
        for(Integer j = 0 ; j < leftObjectList.size(); j++){
            if (j >= rightObjectList.size())
                ObjectLinkToShow.add(new objectPair(leftObjectList.get(j), new objectLink()));
            else
                ObjectLinkToShow.add(new objectPair(leftObjectList.get(j), rightObjectList.get(j)));                           
        }
    }
    
    @TestVisible
    private void setupObj(){
        /*if(getpathprefix().contains('Services')){
            allObjectLink.add(new objectLink('Accounts', Site.getpathprefix() + '/001/o', '/img/icon/accounts24.png'));
            allObjectLink.add(new objectLink('Assets', Site.getpathprefix() + '/02i/o', '/img/icon/products24.png'));
            allObjectLink.add(new objectLink('Campaigns', Site.getpathprefix() + '/701/o', '/img/icon/campaigns24.png', 'slds-icon-standard-campaign', 'assets/icons/standard-sprite/svg/symbols.svg#campaign'));
            allObjectLink.add(new objectLink('Cases', Site.getpathprefix() + '/500/o', '/img/icon/cases24.png'));
            allObjectLink.add(new objectLink('Chatter', Site.getpathprefix() + '/_ui/core/chatter/ui/ChatterPage', '/img/icon/chatterC24.png'));
            allObjectLink.add(new objectLink('Contacts', Site.getpathprefix() + '/003/o', '/img/icon/contacts24.png'));
            allObjectLink.add(new objectLink('Contracts', Site.getpathprefix() + '/800/o', '/img/icon/contracts24.png', 'slds-icon-standard-contract', 'assets/icons/standard-sprite/svg/symbols.svg#contract'));
            allObjectLink.add(new objectLink('Custom Links', Site.getpathprefix() + '/apex/Customlinks_Salesforce1displaypage?sfdc.tabName=01r0W00000112G0', '/img/icon/plane24.png', 'slds-icon-custom-custom20', 'assets/icons/custom-sprite/svg/symbols.svg#custom20'));
            allObjectLink.add(new objectLink('Dashboard', Site.getpathprefix() + '/01Z/o', '/img/icon/dashboards24.png'));
            allObjectLink.add(new objectLink('Documents', Site.getpathprefix() + '/015/o', '/img/icon/documents24.png'));
            allObjectLink.add(new objectLink('Files', Site.getpathprefix() + '/_ui/core/chatter/files/FileTabPage', '/img/icon/files24.png'));
            allObjectLink.add(new objectLink('Getting Started', Site.getpathprefix() + '/servlet/servlet.Integration?lid=01rd0000000YfDx&amp;ic=1&amp;linkToken=VmpFPSxNakF4T0Mwd01pMHdORlF5TWpveU16b3pOaTQyTXpkYSxudkZvbmJWSUZHZmxfai1jTkJSRGR5LFlXWmtNR0po', '/img/icon/custom51_100/tvCTR24.png'));
            allObjectLink.add(new objectLink('Groups', Site.getpathprefix() + '/_ui/core/chatter/groups/GroupListPage', '/img/icon/groups24.png'));
            allObjectLink.add(new objectLink('Home', Site.getpathprefix() + '/home/home.jsp', '/img/icon/home24.png'));
            allObjectLink.add(new objectLink('Ideas', Site.getpathprefix() + '/ideas/ideaList.apexp', '/img/icon/ideabubble24.png'));
            allObjectLink.add(new objectLink('Map Plotter', Site.getpathprefix() + '/apex/Extentia_SIM__MapPlotter?sfdc.tabName=01rd0000001UP9i', '/img/icon/custom51_100/buildingBlock24.png', 'slds-icon-custom-custom78', 'assets/icons/custom-sprite/svg/symbols.svg#custom78'));
            allObjectLink.add(new objectLink('People', Site.getpathprefix() + '/_ui/core/chatter/people/PeopleListPage', '/img/icon/alohaProfile24.png'));
            allObjectLink.add(new objectLink('Price Books', Site.getpathprefix() + '/01s/o', '/img/icon/pricebooks24.png'));
            allObjectLink.add(new objectLink('Products', Site.getpathprefix() + '/01t/o', '/img/icon/products24.png')); 
            allObjectLink.add(new objectLink('Profile', Site.getpathprefix() + '/_ui/core/userprofile/UserProfilePage', '/img/icon/alohaProfile24.png', 'slds-icon-standard-people', 'assets/icons/standard-sprite/svg/symbols.svg#people'));
            allObjectLink.add(new objectLink('Profile Feed', Site.getpathprefix() + '/_ui/core/userprofile/UserProfilePage?tab=sfdc.ProfilePlatformFeed', '/img/icon/alohaProfile24.png'));
            allObjectLink.add(new objectLink('Profile Overview', Site.getpathprefix() + '/_ui/core/userprofile/UserProfilePage?tab=sfdc.ProfilePlatformOverview', '/img/icon/alohaProfile24.png'));
            allObjectLink.add(new objectLink('Reports', Site.getpathprefix() + '/00O/o', '/img/icon/reports24.png'));      
            allObjectLink.add(new objectLink('Roles', Site.getpathprefix() + '/a0N/o', '/img/icon/custom51_100/presenter16.png', 'slds-icon-custom-custom84', 'assets/icons/custom-sprite/svg/symbols.svg#custom84'));
            allObjectLink.add(new objectLink('Solutions', Site.getpathprefix() + '/501/o', '/img/icon/solutions24.png'));  
        }*/
        
       // if(getpathprefix().contains('TWS')){
            allObjectLink.add(new objectLink('Accounts', Site.getpathprefix() + '/001/o', '/img/icon/accounts24.png', 'slds-icon-standard-account', 'assets/icons/standard-sprite/svg/symbols.svg#account'));
            allObjectLink.add(new objectLink('Approver Configurations', Site.getpathprefix() + '/a0Y/o', '/img/icon/lightning24.png', 'slds-icon-custom-custom9', 'assets/icons/custom-sprite/svg/symbols.svg#custom9'));
            allObjectLink.add(new objectLink('Campaigns', Site.getpathprefix() + '/701/o', '/img/icon/campaigns24.png', 'slds-icon-standard-campaign', 'assets/icons/standard-sprite/svg/symbols.svg#campaign'));
            allObjectLink.add(new objectLink('Cases', Site.getpathprefix() + '/500/o', '/img/icon/cases24.png', 'slds-icon-standard-case', 'assets/icons/standard-sprite/svg/symbols.svg#case'));
            allObjectLink.add(new objectLink('Chatter', Site.getpathprefix() + '/_ui/core/chatter/ui/ChatterPage', '/img/icon/chatterC24.png', 'slds-icon-standard-feed', 'assets/icons/standard-sprite/svg/symbols.svg#feed'));
            allObjectLink.add(new objectLink('Contacts', Site.getpathprefix() + '/003/o', '/img/icon/contacts24.png', 'slds-icon-standard-contact', 'assets/icons/standard-sprite/svg/symbols.svg#contact'));
            allObjectLink.add(new objectLink('Contracts', Site.getpathprefix() + '/800/o', '/img/icon/contracts24.png', 'slds-icon-standard-contract', 'assets/icons/standard-sprite/svg/symbols.svg#contract'));
            allObjectLink.add(new objectLink('Custom Links', Site.getpathprefix() + '/apex/Customlinks_Salesforce1displaypage?sfdc.tabName=01r0W00000112G0', '/img/icon/plane24.png', 'slds-icon-custom-custom20', 'assets/icons/custom-sprite/svg/symbols.svg#custom20'));
            allObjectLink.add(new objectLink('Dashboard', Site.getpathprefix() + '/01Z/o', '/img/icon/dashboards24.png'));
            allObjectLink.add(new objectLink('Documents', Site.getpathprefix() + '/015/o', '/img/icon/documents24.png'));
            allObjectLink.add(new objectLink('Files', Site.getpathprefix() + '/_ui/core/chatter/files/FileTabPage', '/img/icon/files24.png'));
            allObjectLink.add(new objectLink('Forecasts', Site.getpathprefix() + '/p/fct/RevenueForecastIntro', '/img/icon/forecasts24.png'));
            allObjectLink.add(new objectLink('Getting Started', Site.getpathprefix() + '/servlet/servlet.Integration?lid=01rd0000000YfDx&amp;ic=1&amp;linkToken=VmpFPSxNakF4T0Mwd01pMHdORlF5TWpveU16b3pOaTQyTXpkYSxudkZvbmJWSUZHZmxfai1jTkJSRGR5LFlXWmtNR0po', '/img/icon/custom51_100/tvCTR24.png'));
            allObjectLink.add(new objectLink('Groups', Site.getpathprefix() + '/_ui/core/chatter/groups/GroupListPage', '/img/icon/groups24.png', 'slds-icon-standard-groups', 'assets/icons/standard-sprite/svg/symbols.svg#groups'));
            allObjectLink.add(new objectLink('Home', Site.getpathprefix() + '/home/home.jsp', '/img/icon/home24.png'));
            allObjectLink.add(new objectLink('Ideas', Site.getpathprefix() + '/ideas/ideaList.apexp', '/img/icon/ideabubble24.png'));
            allObjectLink.add(new objectLink('Leads', Site.getpathprefix() + '/00Q/o', '/img/icon/leads24.png', 'slds-icon-standard-lead', 'assets/icons/standard-sprite/svg/symbols.svg#lead'));
            allObjectLink.add(new objectLink('Map Plotter', Site.getpathprefix() + '/apex/Extentia_SIM__MapPlotter?sfdc.tabName=01rd0000001UP9i', '/img/icon/custom51_100/buildingBlock24.png'));
            allObjectLink.add(new objectLink('Next TC Meeting', Site.getpathprefix() + '/servlet/servlet.Integration?lid=01rd0000001UP9d&amp;ic=1&amp;linkToken=VmpFPSxNakF4T0Mwd01pMHdORlF5TWpveU16b3pOaTQyTXpkYSxudkZvbmJWSUZHZmxfai1jTkJSRGR5LFlXWmtNR0po', '/img/icon/custom51_100/highwaySign24.png'));
            allObjectLink.add(new objectLink('Opportunities', Site.getpathprefix() + '/006/o', '/img/icon/opportunities24.png'));
            allObjectLink.add(new objectLink('Orders', Site.getpathprefix() + '/801/o', '/img/icon/orderBell24.png', 'slds-icon-standard-orders', 'assets/icons/standard-sprite/svg/symbols.svg#orders'));
            allObjectLink.add(new objectLink('People', Site.getpathprefix() + '/_ui/core/chatter/people/PeopleListPage', '/img/icon/alohaProfile24.png', 'slds-icon-standard-people', 'assets/icons/standard-sprite/svg/symbols.svg#people'));
            allObjectLink.add(new objectLink('Price Books', Site.getpathprefix() + '/01s/o', '/img/icon/pricebooks24.png'));
            allObjectLink.add(new objectLink('Products', Site.getpathprefix() + '/01t/o', '/img/icon/products24.png')); 
            allObjectLink.add(new objectLink('Profile', Site.getpathprefix() + '/_ui/core/userprofile/UserProfilePage', '/img/icon/alohaProfile24.png'));
            allObjectLink.add(new objectLink('Profile Feed', Site.getpathprefix() + '/_ui/core/userprofile/UserProfilePage?tab=sfdc.ProfilePlatformFeed', '/img/icon/alohaProfile24.png'));
            allObjectLink.add(new objectLink('Profile Overview', Site.getpathprefix() + '/_ui/core/userprofile/UserProfilePage?tab=sfdc.ProfilePlatformOverview', '/img/icon/alohaProfile24.png'));
            allObjectLink.add(new objectLink('Quotes', Site.getpathprefix() + '/0Q0/o', '/img/icon/quotes24.png', 'slds-icon-standard-quotes', 'assets/icons/standard-sprite/svg/symbols.svg#quotes'));       
            allObjectLink.add(new objectLink('Reports', Site.getpathprefix() + '/00O/o', '/img/icon/reports24.png'));            
            allObjectLink.add(new objectLink('Sales Contracts', Site.getpathprefix() + '/a12/o', '/img/icon/form24.png')); 
            allObjectLink.add(new objectLink('Solutions', Site.getpathprefix() + '/501/o', '/img/icon/solutions24.png'));  
            allObjectLink.add(new objectLink('TC Meetings', Site.getpathprefix() + '/a13/o', '/img/icon/knight24.png'));
        //}
    }
    
    
    //for testing
   /* private String getPathPrefix() {
        return Test.isRunningTest() ? 'EmployeeServicesTWStws' : Site.getPathPrefix();
    }*/
    
    public class objectPair{
        @TestVisible objectLink leftObj;
        @TestVisible objectLink rightObj;
        public objectPair(objectLink leftObj, objectLink rightObj){
            this.leftObj = leftObj;
            this.rightObj = rightObj;
        }
        
        public objectLink getleftObj(){
            return leftObj;
        }
        
        public objectLink getrightObj(){
            return rightObj;
        }
    }
    
    public class objectLink{
        @TestVisible String objectName;
        @TestVisible String Url;
        @TestVisible String ImgUrl; 
        @TestVisible boolean mobile;
        @TestVisible String iconClass;
        @TestVisible String iconUrl;
        
        public objectLink(){
            this.objectName = '';
            this.Url = '';
            this.ImgUrl = '';
        }
        
        public objectLink(String objectName, String url, String ImgURL, String iconClass, String iconUrl){
            this.objectName = objectName;
            this.Url = url;
            this.ImgUrl = ImgURL;
            this.iconClass = iconClass;
            this.iconUrl = iconUrl;
            this.mobile = true;
            
        }
        
        public objectLink(String objectName, String url, String ImgURL){
            this.objectName = objectName;
            this.Url = url;
            this.ImgUrl = ImgURL;
            this.iconClass = '';
            this.iconUrl = '';
            this.mobile = false;
            
        }
        
        public String getObjectName(){
            return objectName;
        }
        
        public String getUrl(){
            return Url;
        }

        public  String getImgUrl(){
            return ImgUrl;
        }
        
        public  String geticonClass(){
            return iconClass;
        }
        
        public  String geticonUrl(){
            return iconUrl;
        }
              
        public  Boolean getmobile(){
            return mobile;
        }
    }
}