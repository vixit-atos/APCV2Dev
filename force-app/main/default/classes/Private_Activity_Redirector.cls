public with sharing class Private_Activity_Redirector {

    // an instance variable for the standard controller
    private ApexPages.StandardController controller {get; set;}
    private ApexPages.StandardSetController setcontroller {get; set;}
    // the object being referenced via url
    private sObject pa {get; set;}
    private sObject account {get; set;}
    private String retID;


    public Private_Activity_Redirector(ApexPages.StandardController controller) {
        System.debug('In the constructor');
        //initialize the stanrdard controller
        this.controller = controller;
        // load the current record

        sObject so = controller.getRecord();

        if (so.getSobjectType() == Schema.Account.SObjectType) {
            this.account = so;
            retID = so.id;

        } else {
            this.pa = so;
        }
        //this.retID = System.ApexPages.currentPage().getParameters().get('id');
        //Private_Activity__c mpa = getMyPA();

        // System.debug('PA ID:' + this.pa.ID);

    }
    public Private_Activity_Redirector(ApexPages.StandardSetController controller) {
        System.debug('In the set constructor');
        //initialize the stanrdard controller
        this.setcontroller = controller;

        //get the account id
        this.retID = System.ApexPages.currentPage().getParameters().get('id');

    }
   /** public PageReference logACall() {
        return logACallInt(true);
    }

    public PageReference logContactCall() {
        return logACallInt(false);
    }

    public PageReference logACallInt(Boolean isAccount) {


        


        //create a container
        if (isAccount) {
            this.pa = new Private_Activity__c(Name = 'PGA',Account__c = retID);
        } else {
            this.pa = new Private_Activity__c(Name = 'PGA',Contact__c = retID);
        }
        insert this.pa;

        
        Private_Activity__c mpa = [select Activity_ID__c, Task__c, Account__c, Contact__c from Private_Activity__c where id = :pa.id];
        System.debug('mpa: ' + mpa.Activity_ID__c + 'account' + mpa.Account__c);

       
        PageReference newPage = new PageReference('/00T/e');

        String retURL = isAccount ? mpa.Account__c : mpa.Contact__c;

        Map<String, String> pMap = newPage.getParameters();

        pMap.put('retURL', '/' + retURL);
        pMap.put('what_id', mpa.id);
        pMap.put('tsk12', 'Completed');
        pMap.put('tsk5', 'Call');

        if (!isAccount) {
            pMap.put('who_id', retID);
        }

        return newPage;

    } */

    private List<Private_Activity__c> getMyPA() {

        return [select Activity_ID__c, Task__c, Account__c, Contact__c from Private_Activity__c where id = :pa.id];
    }

    public PageReference redirectToAccount() {


        List<Private_Activity__c> mpal = getMyPA();

        PageReference redirectPage;

        if (mpal.size() > 0) {
            if (mpal.get(0).Account__c != null) {
                redirectPage = new PageReference('/' + mpal.get(0).Account__c);
            } else {
                redirectPage = new PageReference('/' + mpal.get(0).Contact__c);
            }
        } else {
            redirectPage = new PageReference('/001');
        }
        System.debug('IN Private Activity Redirecting to: ' + redirectPage.getUrl() );
        return redirectPage;

    }

  /*  private PageReference createEmailEditorPage() {
        PageReference emailPage = new PageReference('/_ui/core/email/author/EmailAuthor');

        //associate the email with the container
        emailPage.getParameters().put('p3_lkid', this.pa.Id);

        //and return to the account if user hits cancel
        //return to account when user sends email is handled by
        //redirectToAccount which is called by privateactivity
        //detail view page

        emailPage.getParameters().put('retURL', this.retID);

        return emailPage;
    }

    public PageReference redirectToEmailEditor() {




        //create a container
        this.pa = new Private_Activity__c(Name = 'PGA',Account__c = retID);
        insert this.pa;


        return createEmailEditorPage();
    }

    public PageReference redirectToContactEmailEditor() {




        //create a container
        this.pa = new Private_Activity__c(Name = 'PGA',Contact__c = retID);
        insert this.pa;
        PageReference pr = createEmailEditorPage();
        pr.getParameters().put('p2_lkid', retID);
        return pr;
    } */

    public PageReference redirect() {




        Private_Activity__c mpa = [select Activity_ID__c, Task__c, Account__c from Private_Activity__c where id = :pa.id];

        ApexPages.StandardController sc;
        
        System.debug('Task' + mpa.Task__c + 'Account' +  mpa.Account__c + 'mpa' + mpa.id);
        
        if (mpa.Task__c) {
            Task t = [select id from Task where id = :mpa.Activity_ID__c AND IsDeleted = false All ROWS];
            sc = new ApexPages.StandardController(t);
        } else {
            Event e = [select id from Event where id = :mpa.Activity_ID__c AND IsDeleted = false All ROWS];
            sc = new ApexPages.StandardController(e);
        }


        PageReference editPage = sc.edit();
        editPage.getParameters().put('retURL', mpa.Account__c);
        editPage.setRedirect(true);
        return editPage;
    }
}