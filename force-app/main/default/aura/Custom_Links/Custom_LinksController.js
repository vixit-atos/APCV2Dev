({
	hideComponents : function(cmp, event, helper){
        var action = cmp.get("c.getUserProfile");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
               // set current user information on userInfo attribute
                cmp.set("v.userProfile", storeResponse);
            }
        });
        $A.enqueueAction(action);
        
    },
    concessionInquiry : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to Concession Inquiry
        sObjectEvent.setParams({
            "url": '/lightning/n/Concession_Inquiry'
        })
        sObjectEvent.fire();
    },
    dntaArc : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to the DTNA Arc
        sObjectEvent.setParams({
            "url": 'http://dtnaarc.logicbay.com/daimler/PerfCtr'
        })
        sObjectEvent.fire();
    },
    dtnaConnect : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to DTNA Connect
        sObjectEvent.setParams({
            "url": 'https://secure.freightliner.com/wps/myportal/dtnaconnect/DTNAConnectHome'
        })
        sObjectEvent.fire();
    },
    dtnaDash : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to DTNA Dash
        sObjectEvent.setParams({
            "url": 'http://dtnadash.com/'
        })
        sObjectEvent.fire();
    },
    dtnaSyncronize : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to the DTNA Syncronize
        sObjectEvent.setParams({
            "url": 'https://dtnasynchronize.daimler.com/login.jspa?referer=%252Fwelcome&hint='
        })
        sObjectEvent.fire();
    },
    fieldServiceReporting : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to the Field Service Reporting
        sObjectEvent.setParams({
            "url": 'https://remedy-dtna-test.app.corpintra.net/cacarsys/shared/login.jsp?/cacarsys/forms/remcactest/CAC-FS:PR-ControlPanel_D/WebDisplay/'
        })
        sObjectEvent.fire();
    },
    newTruckInvoice : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to newTruckInvoice
        sObjectEvent.setParams({
            "url": 'https://newvehicleinvoices-dtna.e.corpintra.net/NewVehicleInvoices/View/WebInvoiceLookup.aspx'
        })
        sObjectEvent.fire();
    },
    newTruckTools : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to New Truck Tools
        sObjectEvent.setParams({
            "url": 'http://stnaicvdw005.us164.corpintra.net:8080/bidtna/cgi-bin/cognosisapi.dll?b_action=xts.run&m=portal/cc.xts&m_folder=i95C03E50E87F49BC9C45116D7EECB9B8'
        })
        sObjectEvent.fire();
    },
    oeConnect : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to the OE Connect
        sObjectEvent.setParams({
            "url": 'http://portal.oeconnection.com/login.aspx?ReturnUrl=%2fDefault.aspx',
            "isredirect" :true
        })
        sObjectEvent.fire();
    },
    repairTrackerCustomer : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to Repair Tracker Customer
        sObjectEvent.setParams({
            "url": 'https://utpbireports-dtna.prd.freightliner.com/BOE/OpenDocument/opendoc/openDocument.jsp?sDocName=Customer_Repair_Tracker&sRefresh=Y'
        })
        sObjectEvent.fire();
    },
    
    repairTrackerDealer : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to Repair Tracker Dealer
        sObjectEvent.setParams({
            "url": 'https://utpbireports-dtna.prd.freightliner.com/BOE/OpenDocument/opendoc/openDocument.jsp?sDocName=Dealer_Repair_Tracker&sRefresh=Y'
        })
        sObjectEvent.fire();
    },
    safer : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to SAFER
        sObjectEvent.setParams({
            "url": 'https://safer.fmcsa.dot.gov/CompanySnapshot.aspx'
        })
        sObjectEvent.fire();
    },
    salesMarketingSharePoint : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to the Sales Marketing Sharepoint
        sObjectEvent.setParams({
            "url": 'https://team.nafta.sp.wp.corpintra.net/sites/03513/drp/DM%20Tools/default.aspx'
        })
        sObjectEvent.fire();
    },
    ssiPortal : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to the SSI Portal
        sObjectEvent.setParams({
            "url": 'https://extranet-ddc.freightliner.com/servexc/SSI_SearchDealers.aspx',
            "isredirect" :true
        })
        sObjectEvent.fire();
    },
    uptimeService : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to Uptime Service
        sObjectEvent.setParams({
            "url": 'https://utpbireports-dtna.prd.freightliner.com/BOE/OpenDocument/opendoc/openDocument.jsp?sDocName=Uptime_Performance&sRefresh=Y'
        })
        sObjectEvent.fire();
    },
    quoteActivity : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to Quote Activity
        sObjectEvent.setParams({
            "url": '/apex/dtnaquoteactivity'
        })
        sObjectEvent.fire();
    },
    viewCad : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to view CAD
        sObjectEvent.setParams({
            "url": 'http://viewcad2010/Drawing.aspx'
        })
        sObjectEvent.fire();
    },
    dtnaSalesContracts : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to DTNA Sales Contracts
        sObjectEvent.setParams({
            "url": 'https://team.nafta.sp.wp.corpintra.net/sites/05184/SalesContractSignOff/SitePages/DaimlerHome.aspx'
        })
        sObjectEvent.fire();
    },
    dtnaSalesProposal : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to DTNA Sales Proposal
        sObjectEvent.setParams({
            "url": 'https://team.nafta.sp.wp.corpintra.net/sites/05184/TCMDOA/SitePages/DaimlerHome.aspx'
        })
        sObjectEvent.fire();
    }, 
    dtnaTransactionCouncil : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to DTNA Transaction Council
        sObjectEvent.setParams({
            "url": 'https://team.nafta.sp.wp.corpintra.net/sites/05184/TCM/SitePages/DaimlerHome.aspx'
        })
        sObjectEvent.fire();
    },
    dtnaTwsPreparation : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to DTNA TWS Preparation
        sObjectEvent.setParams({
            "url": 'https://team.nafta.sp.wp.corpintra.net/sites/05184/twsPrepApp/SitePages/DaimlerHome.aspx'
        })
        sObjectEvent.fire();
    },
    fieldServiceSharepoint : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to the Field Service Sharepoint
        sObjectEvent.setParams({
            "url": 'https://team.nafta.sp.wp.corpintra.net/sites/03524/dtnadsm/default.aspx'
        })
        sObjectEvent.fire();
    },
    aftermarketServiceProducts : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to the Aftermarket Service Products
        sObjectEvent.setParams({
            "url": 'https://aftermarketserviceproducts.com/'
        })
        sObjectEvent.fire();
    },
    uptimeServicePerformance : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to Uptime Service Performance
        sObjectEvent.setParams({
            "url": 'https://utpbireports-dtna.prd.freightliner.com/BOE/OpenDocument/opendoc/openDocument.jsp?sDocName=Uptime_Performance&sRefresh=Y'
        })
        sObjectEvent.fire();
    },
    westPartsMasterCalendar : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:createRecord");//Creates a redirect event pointing to dtnaConnect
        sObjectEvent.setParams({
            "url": '/apex/calendar_salesforce1?Cal=West Parts Master Calendar&CalId=0230W000004Sc28'
        })
        sObjectEvent.fire();
    },
    dtnaMacKayReports : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to dtnaConnect
        sObjectEvent.setParams({
            "url": 'http://dtna.mymackay.com/(S(se50deua5lrxfk45sp4yx145))/default.aspx'
        })
        sObjectEvent.fire();
    },
    itAccessForm : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to dtnaConnect
        sObjectEvent.setParams({
            "url": 'http://intra.corpintra.net/intra-dtna/it_forms'
        })
        sObjectEvent.fire();
    },
    otcLumiraReporting : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to the SSI Portal
        sObjectEvent.setParams({
            "url": 'https://otc-dtna.prd.freightliner.com/DTNA_PRD/Aftermarket/OTC/Apps/SalesManageTool/webapp/index.html'
        })
        sObjectEvent.fire();
    },
    pView : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to the SSI Portal
        sObjectEvent.setParams({
            "url": 'https://dtna-bi.us164.corpintra.net:48473/cognosdtna/cgi-bin/cognosisapi.dll?b_action=cognosViewer&ui.action=run&ui.object=%2fcontent%2fpackage%5b%40name%3d%27Fleet%27%5d%2freport%5b%40name%3d%27PView%20Main%20Report%27%5d&ui.name=PView%20Main%20Report&run.outputFormat=&run.prompt=' + 'block' + '&ui.backURL=%2fcognosdtna%2fcgi-bin%2fcognosisapi.dll%3fb_action%3dxts.run%26m%3dportal%2fcc.xts%26m_folder%3di0D73F359A8904B15A331A40B29C3FF99'
        })
        sObjectEvent.fire();
    },
    
    paragonSapMainPage : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to the SSI Portal
        sObjectEvent.setParams({
            "url": 'https://paragon-dtna.prd.freightliner.com/sap/bc/gui/sap/its/y_dealer_gui?sap-system-login-basic_auth=X&sap-client=010&sap-language=EN'
        })
        sObjectEvent.fire();
    },
    
    paragonSapPartInquiry : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to the SSI Portal
        sObjectEvent.setParams({
            "url": 'https://paragon-dtna.prd.freightliner.com/sap/bc/gui/sap/its/y_dealer_gui?sap-system-login-basic_auth=X&sap-client=010&sap-language=EN&~transaction=YAVAILN'
        })
        sObjectEvent.fire();
    },
    
    paragonSapQuoteInquiry : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to the SSI Portal
        sObjectEvent.setParams({
            "url": 'https://paragon-dtna.prd.freightliner.com/sap/bc/gui/sap/its/y_dealer_gui?sap-system-login-basic_auth=X&sap-client=010&sap-language=EN&~transaction=VA23'
        })
        sObjectEvent.fire();
    },
    
    paragonSapPartOrderStatus : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to the SSI Portal
        sObjectEvent.setParams({
            "url": 'https://paragon-dtna.prd.freightliner.com/sap/bc/gui/sap/its/y_dealer_gui?sap-system-login-basic_auth=X&sap-client=010&sap-language=EN&~transaction=VA03'
        })
        sObjectEvent.fire();
    },
    
    paragonManagementSummary : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to the SSI Portal
        sObjectEvent.setParams({
            "url": 'https://app-dtna-bi-prd-vip.us164.corpintra.net/cognosdtna/cgi-bin/cognosisapi.dll?b_action=xts.run&m=portal/cc.xts&m_folder=iCE6E81F1ECAB4DA88E3F7D1EBA2A310A'
        })
        sObjectEvent.fire();
    },
    
    partsPro : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to the SSI Portal
        sObjectEvent.setParams({
            "url": 'https://secure.freightliner.com/wps/myportal/PartsPro/partsProHome/!ut/p/a1/04_Sj9CPykssy0xPLMnMz0vMAfGjzOKN3J1NDL38DbwsPD0tDTzDnAL8vU0tDA0MzIAKIoEKDHAARwNC-sP1o8BK8JhQkBthkO6oqAgAQxDJ1w!!/dl5/d5/L2dBISEvZ0FBIS9nQSEh/'
        })
        sObjectEvent.fire();
    },
    
    pinnacleTruckParts : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to the SSI Portal
        sObjectEvent.setParams({
            "url": 'https://pinnacletruckparts.com/sap(bD1lbiZjPTAxMA==)/bc/bsp/sap/ysimp_e_parts/main.do'
        })
        sObjectEvent.fire();
    },
    
    servicePro : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to the SSI Portal
        sObjectEvent.setParams({
            "url": 'https://secure.freightliner.com/servicepro/'
        })
        sObjectEvent.fire();
    },
    
    tableauSalesReporting : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to the SSI Portal
        sObjectEvent.setParams({
            "url": 'http://stnaicvdw001.us164.corpintra.net/#/signin?redirect=%2Fprojects%2F68%2Fworkbooks&error=42&disableAutoSignin=' + 'block'
        })
        sObjectEvent.fire();
    },
    
    warrantyLit : function(component, event, helper) {
        var sObjectEvent = $A.get("e.force:navigateToURL");//Creates a redirect event pointing to the SSI Portal
        sObjectEvent.setParams({
            "url": 'https://cmspublish-dtna.prd.freightliner.com/content/dtna-warrantylit-and-recalls/warranty-letters.html'
        })
        sObjectEvent.fire();
    },
})