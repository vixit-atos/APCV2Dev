public with sharing class TWSOutgointResidualInfoImport implements TWSImportable {

 	Map<string, Map<string, List<string>>> importMap;
	Outgoing_Residuals_Info__c outgoingResidual;

	private String rvCommitNo;
	private String rvCommitGrpCd;
	private String rTRM;

  public Boolean error {get;set;}
  public String errorMessage {get;set;}

    public TWSOutgointResidualInfoImport(Outgoing_Residuals_Info__c outgoingResidual) {
    	this.outgoingResidual = outgoingResidual;
  		rvCommitNo= outgoingResidual.Residual_Commit_Number__c;
  		rvCommitGrpCd = outgoingResidual.Pricing_Proposal__r.RV_COMMIT_GRP_CD__c;
  		rTRM = outgoingResidual.Pricing_Proposal__r.RTRM__c;
  		importMap = new Map<string, Map<string, List<string>>>();
      this.error = false;
	}

    public TWSOutgointResidualInfoImport(Outgoing_Residuals_Info__c outgoingResidual, String  rvCommitGrpCd, String rTRM) {
    	this.outgoingResidual = outgoingResidual;
  		this.rvCommitGrpCd = rvCommitGrpCd;
  		this.rTRM = rTRM;
  		rvCommitNo= outgoingResidual.Residual_Commit_Number__c;
  		importMap = new Map<string, Map<string, List<string>>>();
      this.error = false;
	}


    public void ImportSpecs(){

    	Map<string, List<string>> currMap = new Map<string, List<string>>();

			Map<string, Map<string, List<string>>> tempMap = new Map<string, Map<string, List<string>>>();

			String base = TWS_OData_URLs__c.getInstance('url_base').URL__c;

			String url = base + TWS_OData_URLs__c.getInstance('RVQTEGRPs').URL__c;
			//RV_COMMIT_GRP_TYPE
 			//RESV_NO
 			//RV_COMMIT_GRP_CD

 			rvCommitGrpCd = rvCommitGrpCd.capitalize();

			url = url.Replace('{{comm_no}}', rvCommitNo);
			url = url.replace('{{grp_cd}}', rvCommitGrpCd);

			System.debug(LoggingLevel.DEBUG,'>>>>>>>>>>>>>>>>> RVQTEGRPs url: '+url);
			importMap.put('RVQTEGRPs', currMap);

			//ODataUtils.fillMap(ODataUtils.getOdata(url), new String [] {'RV_COMMIT_GRP_TYPE', 'RESV_NO', 'RV_COMMIT_GRP_CD'}, currMap, true);
			//ODataUtils.printMap(currMap);

			ODataUtils.fillMap(ODataUtils.getOdata(url), tempMap, new String [] {'RV_COMMIT_GRP_TYPE', 'RESV_NO', 'RV_COMMIT_GRP_CD'});

			String resvNo = null;

			if(tempMap.keySet().size()>0){
				String key = (new List<String>(tempMap.keySet())).get(0);
				importMap.put('RVQTEGRPs', tempMap.get(key));
				resvNo =tempMap.get(key).get('RESV_NO').get(1);
			}else{
				System.debug(LoggingLevel.DEBUG, 'No data recived form resource RVQTEGRPs');
			}


			url = base + TWS_OData_URLs__c.getInstance('RVQTETRMs').URL__c;
			//RTRM
			//ODOM_MEAS_MAX
 			//SHOW_PRICE
 			//MKT_PRICE
 			//PNLTY_PER_MO
 			//PNTLY_ODOM_OVR_MAX

			url = url.Replace('{{comm_no}}', rvCommitNo);
			url = url.replace('{{grp_cd}}', rvCommitGrpCd);
			url = url.replace('{{rtrm}}', rTRM);

			System.debug(LoggingLevel.DEBUG,'>>>>>>>>>>>>>>>>> RVQTETRMs url: '+url);

			//ODataUtils.fillMap(ODataUtils.getOdata(url), new String [] {'RV_COMMIT_NO','RTRM', 'ODOM_MEAS_MAX', 'SHOW_PRICE', 'MKT_PRICE', 'PNLTY_PER_MO', 'PNLTY_ODOM_OVR_MAX'}, currMap, false);
			//ODataUtils.printMap(currMap);

			tempMap = new Map<string, Map<string, List<string>>>();
			ODataUtils.fillMap(ODataUtils.getOdata(url), tempMap, new String [] {'RV_COMMIT_NO','RTRM', 'ODOM_MEAS_MAX', 'SHOW_PRICE', 'MKT_PRICE', 'PNLTY_PER_MO', 'PNLTY_ODOM_OVR_MAX'});

			if(tempMap.keySet().size()>0){
				String key = (new List<String>(tempMap.keySet())).get(0);
				importMap.put('RVQTETRMs', tempMap.get(key));
			}else{
				System.debug(LoggingLevel.DEBUG, 'No data recived form resource RVQTETRMs');
			}


			if(resvNo !=null){
				url = base + TWS_OData_URLs__c.getInstance('VWCONRVQTGs').URL__c;

				url = url.Replace('{{resv_no}}', resvNo);
				//RESV_AMT
	 			//ADJ_RESV_AMT

				System.debug(LoggingLevel.DEBUG,'>>>>>>>>>>>>>>>>> VWCONRVQTGs url'+url);

				//ODataUtils.fillMap(ODataUtils.getOdata(url), new String [] {'RESV_AMT', 'ADJ_RESV_AMT'}, currMap, false);
				//ODataUtils.printMap(currMap);

				tempMap = new Map<string, Map<string, List<string>>>();
				ODataUtils.fillMap(ODataUtils.getOdata(url), tempMap, new String [] {'RESV_AMT', 'ADJ_RESV_AMT'});

				if(tempMap.keySet().size()>0){
						String key = (new List<String>(tempMap.keySet())).get(0);
						importMap.put('VWCONRVQTGs', tempMap.get(key));
				}
				else{
					System.debug(LoggingLevel.DEBUG, 'No data recived form resource VWCONRVQTGs');
				}

			}
			else{
					System.debug(LoggingLevel.DEBUG, 'Missing resvNo for VWCONRVQTGs resource - could not query for data');
          this.error = true;
          this.errorMessage = 'Could not query for data';
          return;
			}

			updateOutgointRequest();

			// decode the residual type

			if (importMap.containsKey('RVQTEGRPs')) {
				Map<string, List<string>> mm = importMap.get('RVQTEGRPs');
				if (mm.containsKey('RV_COMMIT_GRP_TYPE')) {
					TWS_RVGRPTYP_Map__c mcs= TWS_RVGRPTYP_Map__c.getInstance(mm.get('RV_COMMIT_GRP_TYPE')[1]);
					if (mcs !=  null) outgoingResidual.Residual_Type__c = mcs.Value__c;
				}


			}

			outgoingResidual.General_Reserve__c *=  -1;
			outgoingResidual.Specific_Reserve__c *= -1;

			upsert outgoingResidual;


    }

    public void ImportSpecsTest(){

     		rvCommitNo = '201600107';
			rvCommitGrpCd = 'A';
			rTRM = '024';

			ImportSpecs();

    }

    void updateOutgointRequest() {
     	outgoingResidual = (Outgoing_Residuals_Info__c) ODataUtils.updateSObject('Outgoing_Residuals_Info__c', outgoingResidual, importMap);
    }



}