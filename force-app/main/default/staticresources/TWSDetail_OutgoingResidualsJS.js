var TWSOutgoingResiduals = {};

TWSOutgoingResiduals.populateOutgoingResidualInfo = function(dealType, data){

  if (data){

    switch(dealType) {

      case 'National':
        TWSOutgoingResiduals.populateOutgoingResidualColumns(data, TWSOutgoingResiduals.getNationalOutgoingResInfoColumnHTML);
        break;
      case 'International':
        break;
      case 'Canadian':
        TWSOutgoingResiduals.populateOutgoingResidualColumns(data, TWSOutgoingResiduals.getCanadianOutgoingResInfoColumnHTML);
        break;
      case 'Domestic':
        TWSOutgoingResiduals.populateOutgoingResidualColumns(data, TWSOutgoingResiduals.getDomesticOutgoingResInfoColumnHTML);
        break;
      case 'Sales Proposal':
        TWSOutgoingResiduals.populateOutgoingResidualColumns(data, TWSOutgoingResiduals.getDomesticSalesProposalOutgoingResInfoColumnHTML);
        break;
    }
  }
}

TWSOutgoingResiduals.populateOutgoingResidualColumns = function(data, dealSpecificFunction){

  for(i = 0; i < data.pricingProposalList.length; i++){
    $('#tws_OutgoingResInfoContainer').append(dealSpecificFunction(data.pricingProposalList[i].pricingProposal, 'tws_proposalColumn'));
    $('#tws_OutgoingResInfoContainer').append(dealSpecificFunction(data.pricingProposalList[i].pricingProposalReference, 'tws_referenceColumn'));
  }

  if (data.dtrRequestedToQuoteResidual){
    $('#tws_OutgoingResidualsAnswer').text(data.dtrRequestedToQuoteResidual);
  }

  if (data.residualQuoteComments){
    var residualQuoteComments = data.residualQuoteComments.replace(/\n/g, "<br/><br/>");
    $('#tws_residualQuoteCommentsValue').html(residualQuoteComments);
  }

  $('#tws_OutgoingResInfoContainer').css('width', (TWSDetail.proposalListSize)*290+'px');
}

TWSOutgoingResiduals.getNationalOutgoingResInfoColumnHTML = function(proposal, headerCSSClass){

  var outgoingResInfoColumnHTML = '';

  if (proposal){
    outgoingResInfoColumnHTML = '<div class="slds-col--padded slds-text-heading--smal tws_outgoingResInfoColumnContainer">'
                        +   '<div class="slds-grid slds-wrap slds-grid--pull-padded tws_borderRightStrong">'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-heading--smal slds-p-top--small slds-text-align--center '+headerCSSClass+' tws_heightToAdjust" data-name="columnDescription">'
                        +           proposal.name
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_heightToAdjust" data-name="baseModel"">'
                        +           proposal.baseModel
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_1LineHeight">'
                        +           proposal.concessionNumber
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Min/\t\t\t\t'+proposal.numberOfUnitsColMin
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Max/\t\t\t\t'+proposal.numberOfUnitsColMax
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'DTR/\t\t\t\t'+TWSDetail_Formatting.formatPercentValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'dtrSplit'))
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Dealer/\t\t\t\t'+TWSDetail_Formatting.formatPercentValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo,'dealerSplit'))
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'residualType')
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'residualCommitNumber')
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-4 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'termMonths')
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-4 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Months'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-4 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'termMileage')
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-4 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Miles'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'showAmount'), 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_darkHighlighted tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'hardAmount'), 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_darkHighlighted tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'generalReserve'), 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_darkHighlighted  tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'specificReserve'), 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_darkHighlighted tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_strongText tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'totalReserve'), 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_darkHighlighted tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-4 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo,'rolloutPenalty'), 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-4 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Month'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-4 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo,'mileagePenalty'), 4)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-4 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Mile'
                        +       '</div>'
                        +   '</div>'
                        + '</div>'
  }

  return outgoingResInfoColumnHTML;
}

TWSOutgoingResiduals.getCanadianOutgoingResInfoColumnHTML = function(proposal, headerCSSClass){

  var outgoingResInfoColumnHTML = '';

  if (proposal){
    outgoingResInfoColumnHTML = '<div class="slds-col--padded slds-text-heading--smal tws_outgoingResInfoColumnContainer">'
                        +   '<div class="slds-grid slds-wrap slds-grid--pull-padded tws_borderRightStrong">'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-heading--smal slds-p-top--small slds-text-align--center '+headerCSSClass+' tws_heightToAdjust" data-name="columnDescription">'
                        +           proposal.name
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +           'FEX Rate'
                        +       '</div>'
                        +       '<div class="tws_highlighted slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderBottom tws_strongText tws_1LineHeight">'
                        +           TWSDetail_Formatting.getProperty(proposal, 'fexRate')
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_heightToAdjust" data-name="baseModel"">'
                        +           proposal.baseModel
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_1LineHeight">'
                        +           proposal.concessionNumber
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Min/\t\t\t\t'+proposal.numberOfUnitsColMin
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Max/\t\t\t\t'+proposal.numberOfUnitsColMax
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'DTR/\t\t\t\t'+TWSDetail_Formatting.formatPercentValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'dtrSplit'))
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Dealer/\t\t\t\t'+TWSDetail_Formatting.formatPercentValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo,'dealerSplit'))
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'residualType')
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'residualCommitNumber')
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-4 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'termMonths')
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-4 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Months'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-4 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'termMileage')
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-4 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Miles'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'showAmountCAD'), 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_darkHighlighted tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'hardAmountCAD'), 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_darkHighlighted tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'generalReserveCAD'), 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_darkHighlighted tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'specificReserveCAD'), 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_darkHighlighted tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_strongText tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'totalReserve'), 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_darkHighlighted tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-4 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo,'rolloutPenaltyCAD'), 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-4 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Month'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-4 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo,'mileagePenaltyCAD'), 4)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-4 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Mile'
                        +       '</div>'
                        +   '</div>'
                        + '</div>'
  }

  return outgoingResInfoColumnHTML;
}

TWSOutgoingResiduals.getDomesticOutgoingResInfoColumnHTML = function(proposal, headerCSSClass){

  var outgoingResInfoColumnHTML = '';

  if (proposal){
    outgoingResInfoColumnHTML = '<div class="slds-col--padded slds-text-heading--smal tws_outgoingResInfoColumnContainer">'
                        +   '<div class="slds-grid slds-wrap slds-grid--pull-padded tws_borderRightStrong">'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-heading--smal slds-p-top--small slds-text-align--center '+headerCSSClass+' tws_heightToAdjust" data-name="columnDescription">'
                        +           proposal.name
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_heightToAdjust" data-name="baseModel"">'
                        +           proposal.baseModel
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_1LineHeight">'
                        +           proposal.concessionNumber
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Min/\t\t\t\t'+proposal.numberOfUnitsColMin
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Max/\t\t\t\t'+proposal.numberOfUnitsColMax
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'DTR/\t\t\t\t'+TWSDetail_Formatting.formatPercentValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'dtrSplit'))
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Dealer/\t\t\t\t'+TWSDetail_Formatting.formatPercentValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo,'dealerSplit'))
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'residualType')
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'residualCommitNumber')
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-4 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'termMonths')
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-4 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Months'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-4 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'termMileage')
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-4 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Miles'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'showAmount'), 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_darkHighlighted tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'hardAmount'), 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_darkHighlighted tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'generalReserve'), 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_darkHighlighted tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'specificReserve'), 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_darkHighlighted tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_strongText tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'totalReserve'), 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_darkHighlighted tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'pWVValue'), 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-4 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo,'rolloutPenalty'), 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-4 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Month'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-4 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo,'mileagePenalty'), 4)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-4 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Mile'
                        +       '</div>'
                        +   '</div>'
                        + '</div>'
  }

  return outgoingResInfoColumnHTML;
}

TWSOutgoingResiduals.getDomesticSalesProposalOutgoingResInfoColumnHTML = function(proposal, headerCSSClass){

  var outgoingResInfoColumnHTML = '';

  if (proposal){
    outgoingResInfoColumnHTML = '<div class="slds-col--padded slds-text-heading--smal tws_outgoingResInfoColumnContainer">'
                        +   '<div class="slds-grid slds-wrap slds-grid--pull-padded tws_borderRightStrong">'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-heading--smal slds-p-top--small slds-text-align--center '+headerCSSClass+' tws_heightToAdjust" data-name="columnDescription">'
                        +           proposal.name
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_heightToAdjust" data-name="baseModel"">'
                        +           proposal.baseModel
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_1LineHeight">'
                        +           proposal.concessionNumber
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Min/\t\t\t\t'+proposal.numberOfUnitsColMin
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Max/\t\t\t\t'+proposal.numberOfUnitsColMax
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'DTR/\t\t\t\t'+TWSDetail_Formatting.formatPercentValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'dtrSplit'))
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Dealer/\t\t\t\t'+TWSDetail_Formatting.formatPercentValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo,'dealerSplit'))
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'residualType')
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'residualCommitNumber')
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-4 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'termMonths')
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-4 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Months'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-4 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'termMileage')
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-4 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Miles'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'showAmount'), 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_darkHighlighted tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'hardAmount'), 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_darkHighlighted tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'generalReserve'), 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_darkHighlighted tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'specificReserve'), 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_darkHighlighted tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_strongText tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'totalReserve'), 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_darkHighlighted tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'pWVValue'), 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-4 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo,'rolloutPenalty'), 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-4 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Month'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-4 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo,'mileagePenalty'), 4)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-4 tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          'Mile'
                        +       '</div>'
                        +   '</div>'
                        + '</div>'
  }

  return outgoingResInfoColumnHTML;
}
