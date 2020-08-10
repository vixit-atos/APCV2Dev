/*------------------------------------------------------------------------------------------------
 * Extension controller - TWS_OptyItemApproval.vfp 
 * ----------------------------------------------------------------------------------------------
 * @author         Rahul Aggarwal   
 * @modifiedBy          
 * @version        1.0
 * @created        06-25-2018
 * @modified       MM-DD-YYYY
 * ---------------------------------------------------------------------------------------------*/
public with sharing class TWS_OptyApprovalextensioncontroller {

    private Opportunity opty;
    Public String Comments {
        get;
        set;
    }
    Public Id OptyId {
        get;
        set;
    }
    Public Id itemid {
        get;
        set;
    }

    public TWS_OptyApprovalextensioncontroller(ApexPages.StandardController stdController) {
        this.opty = (Opportunity) stdController.getRecord();
        if (Test.isRunningTest() == false) {
            itemid = apexpages.currentpage().getparameters().get('workitemid');
        }
    }

    Public Pagereference Reject() {
        Boolean reject_result = ApproverAction('Reject');
        if (reject_result) {
            return homePageredirect();
        } else {
            Add_Unexpectederror();
            return null;
        }
    }

    Public Pagereference Approve() {

        Boolean approv_result = ApproverAction('Approve');
        if (approv_result) {
            return homePageredirect();
        } else {
            Add_Unexpectederror();
            return null;
        }


    }

    Public Pagereference Cancel() {
        return homePageredirect();
    }

    Public Pagereference homePageredirect() {
        return new pagereference('/home/home.jsp').setRedirect(true);
    }
    Public void Add_Unexpectederror() {
        ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An unexpected error has occurred.  Please contact your system Administrator.'));

    }

    Public Boolean ApproverAction(String sAction) {
        try {
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments(Comments);
            req.setAction(sAction);
            req.setNextApproverIds(new Id[] {
                UserInfo.getUserId()
            });
            req.setWorkitemId(itemId);
            Approval.ProcessResult result = Approval.process(req);
            return result.isSuccess();
        } catch (Exception e) {
            return false;
        }
    }

}