var TWSPricingProposal= {};

TWSPricingProposal.populatePricingProposals = function(dealType, data){

  if (data){

    switch(dealType) {

      case 'National':
        TWSPricingProposal.populateProposals(data, TWSPricingProposal.populateNationalProposal);
        break;
      case 'International':
        TWSPricingProposal.populateProposals(data, TWSPricingProposal.populateInternationalProposal);
        break;
      case 'Canadian':
        TWSPricingProposal.populateProposals(data, TWSPricingProposal.populateCanadianProposal);
        break;
      case 'Domestic':
        TWSPricingProposal.populateProposals(data, TWSPricingProposal.populateDomesticProposal);
        break;
      case 'Sales Proposal':
        TWSPricingProposal.populateProposals(data, TWSPricingProposal.populateSalesProposal);
        break;
    }
  }
}

TWSPricingProposal.populateProposals = function(data, dealSpecificFunction){

  TWSPricingProposal.populateDynamicProposalLabels(data.dynamicProposalLineKeys)

  for(i = 0; i < data.pricingProposalList.length; i++){

      var proposal = data.pricingProposalList[i].pricingProposal;
      var actual = data.pricingProposalList[i].pricingProposalReference;

      dealSpecificFunction(proposal, 'tws_proposalColumn', data.dynamicProposalLineKeys, data.dynamicProposalLineDoubleAmountMap);
      dealSpecificFunction(actual, 'tws_referenceColumn', data.dynamicProposalLineKeys, data.dynamicProposalLineDoubleAmountMap);
  }

}

TWSPricingProposal.populateNationalProposal = function(proposal, cssHeaderClass, dynamicProposalLineKeys, dynamicProposalLineDoubleAmountMap){

  var proposalColumnHTML = '';

  if (proposal){
     proposalColumnHTML = '<div class="slds-col--padded slds-text-heading--smal proposalColumnContainer">'
                        +   '<div class="slds-grid slds-wrap slds-grid--pull-padded tws_borderRightStrong">'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-heading--smal slds-p-top--small slds-text-align--center '+cssHeaderClass+' tws_heightToAdjust" data-name="columnDescription">'
                        +           proposal.name
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom  tws_heightToAdjust" data-name="baseModel">'
                        +           proposal.baseModel
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_heightToAdjust" data-name="concessionNumber">'
                        +           proposal.concessionNumber
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Min/\t\t\t\t'+proposal.numberOfUnitsColMin
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Max/\t\t\t\t'+proposal.numberOfUnitsColMax
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          'Min/\t\t\t\t'+proposal.numberOfUnitsDealMin
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          'Max/\t\t\t\t'+proposal.numberOfUnitsDealMax
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          'Resids:/\t\t'+proposal.dtrResiduals
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          'Trades:/\t\t'+proposal.dtrTrades
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_strongText tws_borderBottomStrong tws_2LineHeight">'
                        +          proposal.referenceSerialNumber
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_heightToAdjust" data-name="sleeperType">'
                        +          proposal.sleeperType
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_heightToAdjust" data-name="engineMakeHP">'
                        +          proposal.engineMakeHP
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom  tws_heightToAdjust" data-name="transmission">'
                        +          proposal.transmission
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_heightToAdjust" data-name="axleMakeConfig">'
                        +          proposal.axleMakeConfig
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_1LineHeight">'
                        +          proposal.priceLevel
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_borderTopStrong tws_highlightedGreen tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.totalRetail)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderBottom tws_darkHighlighted tws_borderTopStrong tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.baseModelRetail)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--center tws_darkHighlighted tws_borderBottom tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_highlightedGreen tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.totalDnet)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--center tws_darkHighlighted tws_borderBottom tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.baseModelDnet)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--center tws_darkHighlighted tws_borderBottom tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_highlightedGreen tws_borderBottom tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.baseModelDiscount)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--center tws_darkHighlighted tws_borderBottom tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottomStrong tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.baseModelNetPrice)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--center tws_strongText tws_borderBottomStrong tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.baseModelNetPrice)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight  tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.optionRetail)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--center tws_darkHighlighted tws_borderBottom tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_highlightedGreen tws_borderBottom tws_3LineHeight">'
                        +          TWSDetail_Formatting.formatPercentValue(proposal.optionDiscountAtRetail)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--center tws_darkHighlighted tws_borderBottom tws_3LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.netOptionDiscount)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--center tws_darkHighlighted tws_borderBottom tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottomStrong tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.optionDnet)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderBottomStrong tws_strongText tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.optionDnet)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.netPriceBeforeAdj)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--center tws_strongText tws_borderBottom tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.netPriceBeforeAdj)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatPercentValue(proposal.effectiveConc)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--center tws_strongText tws_darkHighlighted tws_borderBottom tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_highlighted tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.concessionDollars)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--center tws_darkHighlighted tws_borderRight tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       TWSPricingProposal.getDynamicProposalValues(proposal, dynamicProposalLineKeys, dynamicProposalLineDoubleAmountMap)
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.freight)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--center tws_darkHighlighted tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.csdWarranty, 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.engineWarrantyVal, 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_strongText tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.totalSellingPrice, 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +   '</div>'
                        +'</div>';
  }

  $('#tws_pricingProposalContainer').append(proposalColumnHTML);
}

TWSPricingProposal.populateInternationalProposal = function(proposal, cssHeaderClass, dynamicProposalLineKeys, dynamicProposalLineDoubleAmountMap){

  var proposalColumnHTML = '';

  if (proposal){
     proposalColumnHTML = '<div class="slds-col--padded slds-text-heading--smal proposalColumnContainer">'
                        +   '<div class="slds-grid slds-wrap slds-grid--pull-padded tws_borderRightStrong">'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-heading--smal slds-p-top--small slds-text-align--center '+cssHeaderClass+' tws_heightToAdjust" data-name="columnDescription">'
                        +           TWSDetail_Formatting.getProperty(proposal, 'name')
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom  tws_heightToAdjust" data-name="baseModel">'
                        +           TWSDetail_Formatting.getProperty(proposal, 'baseModel')
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Min/\t\t\t\t'+TWSDetail_Formatting.getProperty(proposal, 'numberOfUnitsColMin')
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Max/\t\t\t\t'+TWSDetail_Formatting.getProperty(proposal, 'numberOfUnitsColMax')
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_heightToAdjust" data-name="concessionNumber">'
                        +           TWSDetail_Formatting.getProperty(proposal, 'concessionNumber')
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_heightToAdjust" data-name="sleeperType">'
                        +          TWSDetail_Formatting.getProperty(proposal, 'sleeperType')
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_heightToAdjust" data-name="engineMakeHP">'
                        +          TWSDetail_Formatting.getProperty(proposal, 'engineMakeHP')
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom  tws_heightToAdjust" data-name="transmission">'
                        +          TWSDetail_Formatting.getProperty(proposal, 'transmission')
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_heightToAdjust" data-name="axleMakeConfig">'
                        +          TWSDetail_Formatting.getProperty(proposal, 'axleMakeConfig')
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.getProperty(proposal, 'priceLevel')
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.dealerNet)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--center tws_darkHighlighted tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatPercentValue(proposal.standardConcession)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--center tws_darkHighlighted tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatPercentValue(proposal.daimlerLatinaAdd)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--center tws_darkHighlighted tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatPercentValue(proposal.dtnaRSMAdd)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_highlightedBlue slds-text-align--center tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          'Total Concession'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatPercentValue(proposal.requestedAdd)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatPercentValue(proposal.totalConcession)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_highlighted tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.concessionDollars)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--center tws_darkHighlighted tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       TWSPricingProposal.getDynamicProposalValues(proposal, dynamicProposalLineKeys, dynamicProposalLineDoubleAmountMap)
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.freight, 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_1LineHeight">'
                        +           '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_strongText tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.dealerCost, 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_1LineHeight">'
                        +           '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_strongText tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.totalSellingPrice, 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +   '</div>'
                        +'</div>';
  }

  $('#tws_pricingProposalContainer').append(proposalColumnHTML);
}

TWSPricingProposal.populateCanadianProposal = function(proposal, cssHeaderClass, dynamicProposalLineKeys, dynamicProposalLineDoubleAmountMap){

  var proposalColumnHTML = '';

  if (proposal){
     proposalColumnHTML = '<div class="slds-col--padded slds-text-heading--smal proposalColumnContainer">'
                        +   '<div class="slds-grid slds-wrap slds-grid--pull-padded tws_borderRightStrong">'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-heading--smal slds-p-top--small slds-text-align--center '+cssHeaderClass+' tws_heightToAdjust" data-name="columnDescription">'
                        +           proposal.name
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +           'FEX Rate'
                        +       '</div>'
                        +       '<div class="tws_highlighted slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderBottom tws_1LineHeight">'
                        +           TWSDetail_Formatting.formatCurrencyValue(proposal.fexRate, 2)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom  tws_heightToAdjust" data-name="baseModel">'
                        +           proposal.baseModel
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_heightToAdjust" data-name="concessionNumber">'
                        +           proposal.concessionNumber
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Min/\t\t\t\t'+proposal.numberOfUnitsColMin
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Max/\t\t\t\t'+proposal.numberOfUnitsColMax
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          'Min/\t\t\t\t'+proposal.numberOfUnitsDealMin
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          'Max/\t\t\t\t'+proposal.numberOfUnitsDealMax
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          'Resids:/\t\t'+proposal.dtrResiduals
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          'Trades:/\t\t'+proposal.dtrTrades
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_strongText tws_borderBottomStrong tws_2LineHeight">'
                        +          proposal.referenceSerialNumber
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_heightToAdjust" data-name="sleeperType">'
                        +          proposal.sleeperType
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_heightToAdjust" data-name="engineMakeHP">'
                        +          proposal.engineMakeHP
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom  tws_heightToAdjust" data-name="transmission">'
                        +          proposal.transmission
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_heightToAdjust" data-name="axleMakeConfig">'
                        +          proposal.axleMakeConfig
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_1LineHeight">'
                        +          proposal.priceLevel
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.dealerNetCAD)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          'Disc: '+TWSDetail_Formatting.formatPercentValue(proposal.dealerNetDisc)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatPercentValue(proposal.concessionPercent)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          'Disc Min: '+proposal.discMin
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_highlighted tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.concessionDollarsCAD)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--center tws_darkHighlighted tws_borderRight tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       TWSPricingProposal.getDynamicProposalValues(proposal, dynamicProposalLineKeys, dynamicProposalLineDoubleAmountMap)
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.freightCAD)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_1LineHeight">'
                        +         '<span> '
                        +           'Price in USD	'
                        +         '</span>'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_strongText tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.dealerCostCAD)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_1LineHeight">'
                        +          '<span> '
                        +           TWSDetail_Formatting.formatCurrencyValue(proposal.dealerCost)
                        +         '</span>'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.dealerProfitCAD)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        /*
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +           TWSDetail_Formatting.formatCurrencyValue(proposal.domicileFee, 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +           TWSDetail_Formatting.formatCurrencyValue(proposal.dealerPDI, 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.flooring, 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.otherCharges, 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        */
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.csdWarrantyCAD, 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.engineWarrantyValCAD, 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottomStrong tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.dealerOverAllowanceCAD, 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_borderBottomStrong tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_strongText tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.totalSellingPriceCAD, 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +   '</div>'
                        +'</div>';
  }

  $('#tws_pricingProposalContainer').append(proposalColumnHTML);
}

TWSPricingProposal.populateDomesticProposal = function(proposal, cssHeaderClass, dynamicProposalLineKeys, dynamicProposalLineDoubleAmountMap){

  var proposalColumnHTML = '';

  if (proposal){
     proposalColumnHTML = '<div class="slds-col--padded slds-text-heading--smal proposalColumnContainer">'
                        +   '<div class="slds-grid slds-wrap slds-grid--pull-padded tws_borderRightStrong">'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-heading--smal slds-p-top--small slds-text-align--center '+cssHeaderClass+' tws_heightToAdjust" data-name="columnDescription">'
                        +           proposal.name
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom  tws_heightToAdjust" data-name="baseModel">'
                        +           proposal.baseModel
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_heightToAdjust" data-name="concessionNumber">'
                        +           proposal.concessionNumber
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Min/\t\t\t\t'+proposal.numberOfUnitsColMin
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Max/\t\t\t\t'+proposal.numberOfUnitsColMax
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          'Min/\t\t\t\t'+proposal.numberOfUnitsDealMin
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          'Max/\t\t\t\t'+proposal.numberOfUnitsDealMax
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          'Resids:/\t\t'+proposal.dtrResiduals
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          'Trades:/\t\t'+proposal.dtrTrades
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_strongText tws_borderBottomStrong tws_2LineHeight">'
                        +          proposal.referenceSerialNumber
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_heightToAdjust" data-name="sleeperType">'
                        +          proposal.sleeperType
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_heightToAdjust" data-name="engineMakeHP">'
                        +          proposal.engineMakeHP
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom  tws_heightToAdjust" data-name="transmission">'
                        +          proposal.transmission
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_heightToAdjust" data-name="axleMakeConfig">'
                        +          proposal.axleMakeConfig
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_1LineHeight">'
                        +          proposal.priceLevel
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.dealerNet)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          'Disc: '+TWSDetail_Formatting.formatPercentValue(proposal.dealerNetDisc)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatPercentValue(proposal.concessionPercent)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          'Disc Min: '+proposal.discMin
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_highlighted tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.concessionDollars)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--center tws_darkHighlighted tws_borderRight tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       TWSPricingProposal.getDynamicProposalValues(proposal, dynamicProposalLineKeys, dynamicProposalLineDoubleAmountMap)
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.freight)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_1LineHeight">'
                        +         '<span> '
                        +           '&nbsp;'
                        +         '</span>'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_strongText tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.dealerCost)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_darkHighlighted tws_1LineHeight">'
                        +         '<span> '
                        +           '&nbsp;'
                        +         '</span>'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.dealerProfit)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--right tws_darkHighlighted tws_borderTopStrong tws_borderBottomStrong tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.sellingPrice, 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.fetExempt, 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.fetBase, 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.fetBase12Percent, 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.lessTireCredit, 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +           TWSDetail_Formatting.formatCurrencyValue(proposal.fet, 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.csdWarranty, 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.engineWarrantyVal, 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_strongText tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.totalSellingPrice, 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +   '</div>'
                        +'</div>';
  }

  $('#tws_pricingProposalContainer').append(proposalColumnHTML);
}

TWSPricingProposal.populateSalesProposal = function(proposal, cssHeaderClass, dynamicProposalLineKeys, dynamicProposalLineDoubleAmountMap){

  var proposalColumnHTML = '';

  if (proposal){
     proposalColumnHTML = '<div class="slds-col--padded slds-text-heading--smal proposalColumnContainer">'
                        +   '<div class="slds-grid slds-wrap slds-grid--pull-padded tws_borderRightStrong">'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-heading--smal slds-p-top--small slds-text-align--center '+cssHeaderClass+' tws_heightToAdjust" data-name="columnDescription">'
                        +           proposal.name
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom  tws_heightToAdjust" data-name="baseModel">'
                        +           proposal.baseModel
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_heightToAdjust" data-name="concessionNumber">'
                        +           proposal.concessionNumber
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Min/\t\t\t\t'+proposal.numberOfUnitsColMin
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Max/\t\t\t\t'+proposal.numberOfUnitsColMax
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          'Min/\t\t\t\t'+proposal.numberOfUnitsDealMin
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          'Max/\t\t\t\t'+proposal.numberOfUnitsDealMax
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          'Resids:/\t\t'+proposal.dtrResiduals
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          'Trades:/\t\t'+proposal.dtrTrades
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_strongText tws_borderBottomStrong tws_2LineHeight">'
                        +          proposal.referenceSerialNumber
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_heightToAdjust" data-name="sleeperType">'
                        +          proposal.sleeperType
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_heightToAdjust" data-name="engineMakeHP">'
                        +          proposal.engineMakeHP
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom  tws_heightToAdjust" data-name="transmission">'
                        +          proposal.transmission
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_heightToAdjust" data-name="axleMakeConfig">'
                        +          proposal.axleMakeConfig
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_1LineHeight">'
                        +          proposal.priceLevel
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.dealerNet)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          'Disc: '+TWSDetail_Formatting.formatPercentValue(proposal.dealerNetDisc)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatPercentValue(proposal.concessionPercent)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          'Disc Min: '+proposal.discMin
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_highlighted tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.concessionDollars)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--center tws_darkHighlighted tws_borderRight tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       TWSPricingProposal.getDynamicProposalValues(proposal, dynamicProposalLineKeys, dynamicProposalLineDoubleAmountMap)
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.freight)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_1LineHeight">'
                        +           '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_strongText tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.dealerCost)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_1LineHeight">'
                        +           '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.dealerProfit)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.lessTireCredit, 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +           TWSDetail_Formatting.formatCurrencyValue(proposal.fet, 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.csdWarranty, 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.engineWarrantyVal, 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_strongText tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.totalSellingPrice, 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_darkHighlighted tws_borderRight tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +   '</div>'
                        +'</div>';
  }

  $('#tws_pricingProposalContainer').append(proposalColumnHTML);
}

TWSPricingProposal.getDynamicProposalValues = function(proposal, dynamicProposalLineKeys, dynamicProposalLineDoubleAmountMap){

  var dynamicProposalValuesHTML = '';

  var valueVar = '0';

  $.each(dynamicProposalLineKeys, function( key, label ) {

    valueVar = '0';

    if (dynamicProposalLineDoubleAmountMap[proposal.id]){

      keyAmountMap = dynamicProposalLineDoubleAmountMap[proposal.id];

      if(keyAmountMap[label]){
        valueVar = keyAmountMap[label];
      }
    }

    dynamicProposalValuesHTML += '<div class="tws_nationalSpecific tws_domesticSpecific tws_domesticSalesProposalSpecific tws_internationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_heightToAdjust" data-name="propDynamLine_'+label+'">'
                              +       TWSDetail_Formatting.formatCurrencyValue(valueVar, 0)
                              +  '</div>'
                              +  '<div class="tws_canadaSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_heightToAdjust" data-name="propDynamLine_'+label+'">'
                              +       TWSDetail_Formatting.formatCurrencyValue(valueVar*proposal.fexRate, 0)
                              +  '</div>'
                              +  '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--center tws_darkHighlighted tws_borderRight tws_heightToAdjust" data-name="propDynamLine_'+label+'">'
                              +       '&nbsp;'
                              +  '</div>'
  });

  return dynamicProposalValuesHTML;
}

TWSPricingProposal.populateDynamicProposalLabels = function(keyLabelMap){

  dynamicProposalLabelsHTML = '';

  $.each(keyLabelMap, function( key, value ) {
    dynamicProposalLabelsHTML += '<div id="tws_dynamicLine_'+key+'" class="slds-col--padded slds-size--1-of-1 tws_borderBottomWhite tws_heightToAdjust" data-name="propDynamLine_'+value+'">'
                              +     value
                              +  '</div>'
  });

  $('#tws_dummyDynamicProposalLabel').replaceWith(dynamicProposalLabelsHTML);
}
