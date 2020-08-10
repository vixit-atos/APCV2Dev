public with sharing class OutgoingResidualInfoControllerExtension {

	public Outgoing_Residuals_Info__c outgoingResidual{ get; set; }

	public String rvCommitField { get; set; }
	public String rtrmField { get; set; }
	public String rName {get;set;}

	public  OutgoingResidualInfoControllerExtension(ApexPages.StandardController stdController) {
		this.outgoingResidual = (Outgoing_Residuals_Info__c)stdController.getRecord();


		String pricingProposalId = ApexPages.currentPage().getParameters().get('pricingProposal');

		if(pricingProposalId!=null && pricingProposalId!=''){
			outgoingResidual.Pricing_Proposal__c = pricingProposalId;
			populateValues();

		}
		String opportunityId = ApexPages.currentPage().getParameters().get('opportunity');

		if(opportunityId !=null && opportunityId !=''){
				outgoingResidual.Opportunity__c =opportunityId;


		}

	}

	public PageReference save() {

		this.outgoingResidual.Name = rName;

		if (rtrmField != null){
				rtrmField = rtrmField.leftPad(3).replace(' ','0');
		}

		System.debug('#rtrmField# '+rtrmField);

		TWSOutgointResidualInfoImport outgoingResInfoImport = new TWSOutgointResidualInfoImport(this.outgoingResidual, rvCommitField, rtrmField);
		outgoingResInfoImport.ImportSpecs();

		System.debug('#outgoingResInfoImport '+outgoingResInfoImport);

		if (outgoingResInfoImport.error){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'No Residual found. Please check the Residual Commit #'));
			return null;
		}

		update new PricingProposal__c(
			Id = outgoingResidual.Pricing_Proposal__c,
			RV_COMMIT_GRP_CD__c = rvCommitField,
			RTRM__c = rtrmField
		);
		return new ApexPages.StandardController(outgoingResidual).view();

	}

	public void populateValues() {
		Id proposalId = this.outgoingResidual.Pricing_Proposal__c;

		if (null == proposalId) {
		return;
		}

		PricingProposal__c pricingProposal = [
			SELECT
				RV_COMMIT_GRP_CD__c,
				RTRM__c,
				Name
				//CurrencyISOCode
			FROM
				PricingProposal__c
			WHERE
				Id = :proposalId
		];

		//outgoingResidual.CurrencyISOCode = pricingProposal.CurrencyISOCode;
		rvCommitField = pricingProposal.RV_COMMIT_GRP_CD__c;
		rtrmField = pricingProposal.RTRM__c;
		rName  = pricingProposal.Name;

	}

}