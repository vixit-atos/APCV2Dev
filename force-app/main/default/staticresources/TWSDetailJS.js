var TWSDetail = {};

//TWSDetail properties
TWSDetail.opportunityId =  null;

TWSDetail.dealType = '';

TWSDetail.FEXRate = '';

TWSDetail.proposalListSize = 0;


TWSDetail.init = function(opptyId) {

  TWSDetail.opportunityId = opptyId;

  TWSDetail.getTWSDetailInfo();
};

TWSDetail.getTWSDetailInfo = function() {

    TWSController.getTWSDetailInfo(
        TWSDetail.opportunityId,
        TWSDetail.populateTWSDetailInfo
    );
};

TWSDetail.populateTWSDetailInfo = function(result, event) {

  if(result){

    console.log(result);

    TWSDetail.setContext(result);

    TWSDetail.populateTWSHeader(result.header);
    TWSDetail.populateDealSummaryAndEscalators(result);
    //TWSDetail.populateDynamicProposalLabels(result.dynamicProposalLineKeys);
    TWSPricingProposal.populatePricingProposals(TWSDetail.dealType, result);
    //TWSDetail.populateTWSPricingProposal(result.pricingProposalList, result.dynamicProposalLineKeys, result.dynamicProposalLineAmountMap);
    TWSDetail.populateTWSPriceWalk(result.pricingProposalList, result.dynamicProposalLineKeys, result.priceWalkLabels);
    //TWSDetail.populateTWSContributionCalculation(result, result.pricingProposalList, result.contributionCalcDynamicItemsKeySet);
    TWSContributionCalculation.populateContributionCalcColumns(TWSDetail.dealType, result);
    //TWSDetail.populateOutgoingResidualsInfo(result, result.pricingProposalList);
    TWSOutgoingResiduals.populateOutgoingResidualInfo(TWSDetail.dealType, result);
    TWSDetail.populateExtendedWarrantyInfo(result, result.pricingProposalList);
    //TWSDetail.populateEngineWarrantyInfo(result, result.pricingProposalList);
    TWSEngineWarranty.populateEngineWarrantyInfo(TWSDetail.dealType, result);
    //TWSDetail.populateIncomingUsedTruck(result);
    TWSIncomingUsedTruck.populateIncomingUsedTruckInfo(TWSDetail.dealType, result);
    TWSDetail.populateFooters(result);
    TWSDetail.adjustPosition(result.pricingProposalList);


    $(window).on('resize', function(){
      console.log('#resize');

      $(".tws_heightToAdjust").each(function( key, value ) {
        var elem = $(value);
        elem.css('height', 'initial');
      });

      TWSDetail.adjustPosition(result.pricingProposalList);
    });


    window.onorientationchange = function() {
      location.reload();
    }

  }
};

TWSDetail.setContext = function(twsDetail){

  TWSDetail.dealType = twsDetail.dealType;

  if (TWSDetail.dealType == 'Canadian'){
    TWSDetail.FEXRate = twsDetail.fexRate;
  }

  for (var i=0; i<twsDetail.pricingProposalList.length; i++){

    TWSDetail.proposalListSize +=1;

    if (twsDetail.pricingProposalList[i].pricingProposalReference){
      TWSDetail.proposalListSize +=1;
    }
  }
}

TWSDetail.populateTWSHeader = function(headerData){

  TWSHeader.populateHeader(TWSDetail.dealType, headerData);


  $('#tws_headerDOAInitials').html(TWSDetail_Formatting.getProperty(headerData, 'doaInitials'));
  $('#tws_headerOpptyName').html(TWSDetail_Formatting.getProperty(headerData, 'title'));
  $('#tws_headerDealNumber').html(TWSDetail_Formatting.getProperty(headerData, 'dealNumber'));
  $('#tws_headerCustomer').html(TWSDetail_Formatting.getProperty(headerData, 'customer'));
  $('#tws_headerModelYear').html(TWSDetail_Formatting.getProperty(headerData, 'modelYear'));
  $('#tws_headerSpecNumber').html(TWSDetail_Formatting.getProperty(headerData, 'specNumber'));
  $('#tws_headerTCDate').html(TWSDetail_Formatting.getProperty(headerData, 'TCDate'));
  $('#tws_headerDatePrepared').html(TWSDetail_Formatting.getProperty(headerData, 'datePrepared'));
  $('#tws_headerNewOrRevision').html(TWSDetail_Formatting.getProperty(headerData, 'newOrRevision'));
  $('#tws_headerRevisionDate').html(TWSDetail_Formatting.getProperty(headerData, 'revisionDate'));
  $('#tws_headerCustomerCityState').html(TWSDetail_Formatting.getProperty(headerData, 'customerCityState'));
  $('#tws_headerDealerCode').html(TWSDetail_Formatting.getProperty(headerData, 'dealerCode'));
  $('#tws_headerDistrictManager').html(TWSDetail_Formatting.getProperty(headerData, 'districtManager'));
  $('#tws_headerReqDeliveryFrom').html(TWSDetail_Formatting.getProperty(headerData, 'reqDeliveryFrom'));
  $('#tws_headerReqDeliveryTo').html(TWSDetail_Formatting.getProperty(headerData, 'reqDeliveryTo'));
  $('#tws_headerPriceProtect').html(TWSDetail_Formatting.getProperty(headerData, 'priceProtect'));
  $('#tws_headerOrderReceivedFrom').html(TWSDetail_Formatting.getProperty(headerData, 'orderReceivedFrom'));
  $('#tws_headerOrderReceivedTo').html(TWSDetail_Formatting.getProperty(headerData, 'orderReceivedTo'));
  $('#tws_headerCompetition').html(TWSDetail_Formatting.getProperty(headerData, 'competition'));
  $('#tws_headerCountry').html(TWSDetail_Formatting.getProperty(headerData, 'country'));

};

TWSDetail.populateDealSummaryAndEscalators = function(twsDetailInfo){
  var dealSummary = twsDetailInfo.dealSummary.replace(/\n/g, "<br/><br/>");
  var escalators = twsDetailInfo.escalators.replace(/\n/g, "<br/><br/>");
  $('#tws_dealSummaryValue').html(dealSummary);
  $('#tws_escalatorsValue').html(escalators);
}

/*
TWSDetail.populateTWSPricingProposal = function(pricingProposalList, dynamicProposalLineKeys, dynamicProposalLineAmountMap){

  for(i = 0; i < pricingProposalList.length; i++){
    $('#tws_pricingProposalContainer').append(TWSDetail.getProposalColumnHTML(pricingProposalList[i].pricingProposal, 'proposal', dynamicProposalLineKeys, dynamicProposalLineAmountMap));
    $('#tws_pricingProposalContainer').append(TWSDetail.getProposalColumnHTML(pricingProposalList[i].pricingProposalReference, 'reference', dynamicProposalLineKeys, dynamicProposalLineAmountMap));
  }

};*/

/*
TWSDetail.populateOutgoingResidualsInfo = function(twsDetail, pricingProposalList){

  if(TWSDetail.dealType != 'International'){

    for(i = 0; i < pricingProposalList.length; i++){
      $('#tws_OutgoingResInfoContainer').append(TWSDetail.getOutgoingResInfoColumnHTML(pricingProposalList[i].pricingProposal, 'proposal'));
      $('#tws_OutgoingResInfoContainer').append(TWSDetail.getOutgoingResInfoColumnHTML(pricingProposalList[i].pricingProposalReference, 'reference'));
    }

    if (twsDetail.dtrRequestedToQuoteResidual){
      $('#tws_OutgoingResidualsAnswer').text(twsDetail.dtrRequestedToQuoteResidual);
    }

    if (twsDetail.residualQuoteComments){
      var residualQuoteComments = twsDetail.residualQuoteComments.replace(/\n/g, "<br/><br/>");
      $('#tws_residualQuoteCommentsValue').html(residualQuoteComments);
    }

    $('#tws_OutgoingResInfoContainer').css('width', (TWSDetail.proposalListSize)*290+'px');
  }
}

TWSDetail.populateDynamicProposalLabels = function(keyLabelMap){

  dynamicProposalLabelsHTML = '';

  $.each(keyLabelMap, function( key, value ) {
    dynamicProposalLabelsHTML += '<div id="tws_dynamicLine_'+key+'" class="slds-col--padded slds-size--1-of-1 tws_borderBottomWhite tws_heightToAdjust" data-name="propDynamLine_'+value+'">'
                              +     value
                              +  '</div>'
  });

  $('#tws_dummyDynamicProposalLabel').replaceWith(dynamicProposalLabelsHTML);
}
*/
/*
TWSDetail.getProposalColumnHTML = function(proposal, type, dynamicProposalLineKeys, dynamicProposalLineAmountMap){

  headerCSSClass = '';

  if (type == 'proposal'){
    headerCSSClass = 'tws_proposalColumn';
  }
  else if (type == 'reference'){
    headerCSSClass = 'tws_referenceColumn';
  }

  var proposalColumnHTML = '';

  if (proposal){
     proposalColumnHTML = '<div class="slds-col--padded slds-text-heading--smal proposalColumnContainer">'
                        +   '<div class="slds-grid slds-wrap slds-grid--pull-padded tws_borderRightStrong">'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-heading--smal slds-p-top--small slds-text-align--center '+headerCSSClass+' tws_heightToAdjust" data-name="columnDescription">'
                        +           proposal.name
                        +       '</div>'
                        +       '<div class="tws_canadaSpecific slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +           'FEX Rate'
                        +       '</div>'
                        +       '<div class="tws_canadaSpecific tws_highlighted slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderBottom tws_1LineHeight">'
                        +           TWSDetail_Formatting.formatCurrencyValue(TWSDetail.FEXRate)
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
                        +       '<div class="tws_canadaSpecific tws_domesticSpecific tws_nationalSpecific slds-col--padded slds-size--1-of-2 tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          'Min/\t\t\t\t'+proposal.numberOfUnitsDealMin
                        +       '</div>'
                        +       '<div class="tws_domesticSalesProposalSpecific tws_canadaSpecific tws_domesticSpecific tws_nationalSpecific slds-col--padded slds-size--1-of-2 tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          'Max/\t\t\t\t'+proposal.numberOfUnitsDealMax
                        +       '</div>'
                        +       '<div class="tws_domesticSalesProposalSpecific tws_canadaSpecific tws_domesticSpecific tws_nationalSpecific slds-col--padded slds-size--1-of-2 tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          'Resids:/\t\t'+proposal.dtrResiduals
                        +       '</div>'
                        +       '<div class="tws_domesticSalesProposalSpecific tws_canadaSpecific tws_domesticSpecific tws_nationalSpecific slds-col--padded slds-size--1-of-2 tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          'Trades:/\t\t'+proposal.dtrTrades
                        +       '</div>'
                        +       '<div class="tws_domesticSalesProposalSpecific tws_canadaSpecific tws_domesticSpecific tws_nationalSpecific slds-col--padded slds-size--1-of-1 slds-text-align--center tws_strongText tws_borderBottomStrong tws_2LineHeight">'
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
                        +       '<div class="tws_internationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.dealerNet)
                        +       '</div>'
                        +       '<div class="tws_internationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="tws_internationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatPercentValue(proposal.standardConcession)
                        +       '</div>'
                        +       '<div class="tws_internationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="tws_internationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatPercentValue(proposal.daimlerLatinaAdd)
                        +       '</div>'
                        +       '<div class="tws_internationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="tws_internationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatPercentValue(proposal.dtnaRSMAdd)
                        +       '</div>'
                        +       '<div class="tws_internationalSpecific slds-col--padded slds-size--1-of-2 tws_highlightedBlue slds-text-align--center tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          'Total Concession'
                        +       '</div>'
                        +       '<div class="tws_internationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatPercentValue(proposal.requestedAdd)
                        +       '</div>'
                        +       '<div class="tws_internationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatPercentValue(proposal.totalConcession)
                        +       '</div>'
                        +       '<div class="tws_nationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_borderTopStrong tws_highlightedGreen tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.totalRetail)
                        +       '</div>'
                        +       '<div class="tws_nationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderBottom tws_borderTopStrong tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="tws_nationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.baseModelRetail)
                        +       '</div>'
                        +       '<div class="tws_nationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderBottom tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="tws_nationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_highlightedGreen tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.totalDnet)
                        +       '</div>'
                        +       '<div class="tws_nationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderBottom tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="tws_nationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.baseModelDnet)
                        +       '</div>'
                        +       '<div class="tws_nationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderBottom tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="tws_nationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_highlightedGreen tws_borderBottom tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.baseModelDiscount)
                        +       '</div>'
                        +       '<div class="tws_nationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderBottom tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="tws_nationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottomStrong tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.baseModelNetPrice)
                        +       '</div>'
                        +       '<div class="tws_nationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--center tws_strongText tws_borderBottomStrong tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.baseModelNetPrice)
                        +       '</div>'
                        +       '<div class="tws_nationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight  tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.optionRetail)
                        +       '</div>'
                        +       '<div class="tws_nationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderBottom tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="tws_nationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_highlightedGreen tws_borderBottom tws_3LineHeight">'
                        +          TWSDetail_Formatting.formatPercentValue(proposal.optionDiscountAtRetail)
                        +       '</div>'
                        +       '<div class="tws_nationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderBottom tws_3LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="tws_nationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.optionDiscount)
                        +       '</div>'
                        +       '<div class="tws_nationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderBottom tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="tws_nationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottomStrong tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.optionDnet)
                        +       '</div>'
                        +       '<div class="tws_nationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderBottomStrong tws_strongText tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.optionDnet)
                        +       '</div>'
                        +       '<div class="tws_nationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.netPriceBeforeAdj)
                        +       '</div>'
                        +       '<div class="tws_nationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--center tws_strongText tws_borderBottom tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.netPriceBeforeAdj)
                        +       '</div>'
                        +       '<div class="tws_nationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatPercentValue(proposal.effectiveConc)
                        +       '</div>'
                        +       '<div class="tws_nationalSpecific slds-col--padded slds-size--1-of-2 slds-text-align--center tws_strongText tws_borderBottom tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="tws_domesticSalesProposalSpecific tws_domesticSpecific tws_canadaSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.dealerNet)
                        +       '</div>'
                        +       '<div class="tws_domesticSalesProposalSpecific tws_domesticSpecific tws_canadaSpecific slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          'Disc: '+TWSDetail_Formatting.formatPercentValue(proposal.dealerNetDisc)
                        +       '</div>'
                        +       '<div class="tws_domesticSalesProposalSpecific tws_domesticSpecific tws_canadaSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatPercentValue(proposal.concessionPercent)
                        +       '</div>'
                        +       '<div class="tws_domesticSalesProposalSpecific tws_domesticSpecific tws_canadaSpecific slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          'Disc Min: '+proposal.discMin
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_highlighted tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.concessionDollars)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderRight tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       TWSDetail.getDynamicProposalValues(proposal.id, dynamicProposalLineKeys, dynamicProposalLineAmountMap)
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.freight)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_1LineHeight">'
                        +         '<span class="tws_canadaSpecific"> '
                        +           'Price in USD	'
                        +         '</span>'
                        +         '<span class="tws_domesticSalesProposalSpecific tws_domesticSpecific"> '
                        +           '&nbsp;'
                        +         '</span>'
                        +       '</div>'
                        +       '<div class="tws_domesticSalesProposalSpecific tws_internationalSpecific tws_domesticSpecific tws_canadaSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_strongText tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.dealerCost)
                        +       '</div>'
                        +       '<div class="tws_domesticSalesProposalSpecific tws_internationalSpecific tws_domesticSpecific tws_canadaSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_1LineHeight">'
                        +          '<span class="tws_canadaSpecific"> '
                        +           TWSDetail_Formatting.formatCurrencyValue(proposal.dealerCost / TWSDetail.FEXRate)
                        +         '</span>'
                        +         '<span class="tws_domesticSalesProposalSpecific tws_domesticSalesProposalSpecific tws_internationalSpecific tws_domesticSpecific"> '
                        +           '&nbsp;'
                        +         '</span>'
                        +       '</div>'
                        +       '<div class="tws_domesticSalesProposalSpecific tws_domesticSpecific tws_canadaSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.dealerProfit)
                        +       '</div>'
                        +       '<div class="tws_domesticSalesProposalSpecific tws_domesticSpecific tws_canadaSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="tws_domesticSpecific slds-col--padded slds-size--1-of-1 slds-text-align--right tws_borderTopStrong tws_borderBottomStrong tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="tws_domesticSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.sellingPrice, 0)
                        +       '</div>'
                        +       '<div class="tws_domesticSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="tws_domesticSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.fetExempt, 0)
                        +       '</div>'
                        +       '<div class="tws_domesticSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="tws_domesticSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.fetBase, 0)
                        +       '</div>'
                        +       '<div class="tws_domesticSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="tws_domesticSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.fetBase12Percent, 0)
                        +       '</div>'
                        +       '<div class="tws_domesticSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="tws_domesticSalesProposalSpecific tws_domesticSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.lessTireCredit, 0)
                        +       '</div>'
                        +       '<div class="tws_domesticSalesProposalSpecific tws_domesticSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="tws_domesticSalesProposalSpecific tws_domesticSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +           TWSDetail_Formatting.formatCurrencyValue(proposal.fet, 0)
                        +       '</div>'
                        +       '<div class="tws_domesticSalesProposalSpecific tws_domesticSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="tws_canadaSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +           TWSDetail_Formatting.formatCurrencyValue(proposal.domicileFee, 0)
                        +       '</div>'
                        +       '<div class="tws_canadaSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="tws_canadaSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +           TWSDetail_Formatting.formatCurrencyValue(proposal.dealerPDI, 0)
                        +       '</div>'
                        +       '<div class="tws_canadaSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="tws_canadaSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.flooring, 0)
                        +       '</div>'
                        +       '<div class="tws_canadaSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="tws_canadaSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.otherCharges, 0)
                        +       '</div>'
                        +       '<div class="tws_canadaSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="tws_domesticSalesProposalSpecific tws_nationalSpecific tws_domesticSpecific tws_canadaSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.csdWarranty, 0)
                        +       '</div>'
                        +       '<div class="tws_domesticSalesProposalSpecific tws_nationalSpecific tws_domesticSpecific tws_canadaSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="tws_domesticSalesProposalSpecific tws_nationalSpecific tws_domesticSpecific tws_canadaSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.engineWarrantyVal, 0)
                        +       '</div>'
                        +       '<div class="tws_domesticSalesProposalSpecific tws_nationalSpecific tws_domesticSpecific tws_canadaSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="tws_canadaSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottomStrong tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.dealerOverAllowance, 0)
                        +       '</div>'
                        +       '<div class="tws_canadaSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottomStrong tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_strongText tws_borderRight tws_borderBottom tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(proposal.totalSellingPrice, 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +   '</div>'
                        +'</div>';
  }
  return proposalColumnHTML;
};
*/

/*
TWSDetail.getOutgoingResInfoColumnHTML = function(proposal, type){

  headerCSSClass = '';

  if (type == 'proposal'){
    headerCSSClass = 'tws_proposalColumn';
  }
  else if (type == 'reference'){
    headerCSSClass = 'tws_referenceColumn';
  }

  var outgoingResInfoColumnHTML = '';

  if (proposal){
    outgoingResInfoColumnHTML = '<div class="slds-col--padded slds-text-heading--smal tws_outgoingResInfoColumnContainer">'
                        +   '<div class="slds-grid slds-wrap slds-grid--pull-padded tws_borderRightStrong">'
                        +       '<div class="slds-col--padded slds-size--1-of-1 slds-text-heading--smal slds-p-top--small slds-text-align--center '+headerCSSClass+' tws_heightToAdjust" data-name="columnDescription">'
                        +           proposal.name
                        +       '</div>'
                        +       '<div class="tws_canadaSpecific slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +           'FEX Rate'
                        +       '</div>'
                        +       '<div class="tws_canadaSpecific tws_highlighted slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderBottom tws_strongText tws_1LineHeight">'
                        +           TWSDetail_Formatting.formatCurrencyValue(TWSDetail.FEXRate, 0)
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
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'hardAmount'), 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'generalReserve'), 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderBottom tws_borderRight tws_2LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'specificReserve'), 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_2LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_strongText tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'totalReserve'), 0)
                        +       '</div>'
                        +       '<div class="slds-col--padded slds-size--1-of-2 tws_borderRight tws_1LineHeight">'
                        +          '&nbsp;'
                        +       '</div>'
                        +       '<div class="tws_domesticSalesProposalSpecific tws_domesticSpecific slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderBottom tws_borderRight tws_1LineHeight">'
                        +          TWSDetail_Formatting.formatCurrencyValue(TWSDetail_Formatting.getProperty(proposal.outgoingResidualsInfo, 'pWVValue'), 0)
                        +       '</div>'
                        +       '<div class="tws_domesticSalesProposalSpecific tws_domesticSpecific  slds-col--padded slds-size--1-of-2 tws_borderBottom tws_borderRight tws_1LineHeight">'
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
*/

/*
TWSDetail.getDynamicProposalValues = function(proposalId, keyLabelMap, proposalIdKeyAmount){

  dynamicProposalValuesHTML = '';

  valueVar = '$0';

  $.each(keyLabelMap, function( key, value ) {

    valueVar = '$0';

    if (proposalIdKeyAmount[proposalId]){

      keyAmountMap = proposalIdKeyAmount[proposalId];

      if(keyAmountMap[key]){
        valueVar = keyAmountMap[key];
      }
    }

    dynamicProposalValuesHTML += '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--right tws_borderRight tws_borderBottom tws_heightToAdjust" data-name="propDynamLine_'+key+'">'
                              +       TWSDetail_Formatting.formatCurrencyValue(valueVar, 0)
                              +  '</div>'
                              +  '<div class="slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderRight tws_heightToAdjust" data-name="propDynamLine_'+key+'">'
                              +       '&nbsp;'
                              +  '</div>'
  });

  return dynamicProposalValuesHTML;
}
*/

TWSDetail.populateTWSPriceWalk = function(proposalList, keyLabelMap, priceWalkLabels){

  if (TWSDetail.dealType != 'International'){
    priceWalkHTML = '';

    for(i=0; i< proposalList.length; i++){

      if(proposalList[i].priceWalk){

        var previousName = '';
        if (proposalList[i].priceWalk.previousName){
          previousName = proposalList[i].priceWalk.previousName;
        }
        //previous
        priceWalkHTML += '<div class="slds-col--padded slds-text-heading--smal tws_walkPriceColumnContainer">'
                      +   '<div class="slds-grid slds-wrap slds-grid--pull-padded tws_borderRightStrong">'
                      +     '<div class="slds-size--1-of-2 slds-col--padded priceWalkColumn slds-text-align--left tws_heightToAdjust" data-name="previousCol">'
                      +         'Previous '+previousName
                      +     '</div>'
                      +     '<div class="tws_canadaSpecific slds-size--1-of-2 slds-col--padded priceWalkColumn slds-text-align--right tws_heightToAdjust" data-name="previousCol">'
                      +         TWSDetail_Formatting.formatCurrencyValue(proposalList[i].priceWalk.previous, 0)
                      +     '</div>'
                      +     '<div class="tws_nationalSpecific tws_domesticSpecific tws_domesticSalesProposalSpecific tws_internationalSpecific slds-size--1-of-2 slds-col--padded priceWalkColumn slds-text-align--right tws_heightToAdjust" data-name="previousCol">'
                      +         TWSDetail_Formatting.formatCurrencyValue(proposalList[i].priceWalk.previous, 0)
                      +     '</div>'
                      +   '</div>'
                      /*
                      +   '<div class="slds-grid slds-wrap slds-grid--pull-padded tws_borderRightStrong">'
                      +     '<div class="slds-size--1-of-2 slds-col--padded priceWalkColumn slds-text-align--left">'
                      +         'Specs'
                      +     '</div>'
                      +     '<div class="slds-size--1-of-2 slds-col--padded priceWalkColumn slds-text-align--right">'
                      +          TWSDetail_Formatting.formatCurrencyValue(proposalList[i].priceWalk.specs, 0)
                      +     '</div>'
                      +   '</div>'
                      +   '<div class="slds-grid slds-wrap slds-grid--pull-padded tws_borderRightStrong">'
                      +     '<div class="slds-size--1-of-2 slds-col--padded priceWalkColumn slds-text-align--left">'
                      +         'SPD Overrides'
                      +     '</div>'
                      +     '<div class="slds-size--1-of-2 slds-col--padded priceWalkColumn slds-text-align--right">'
                      +         TWSDetail_Formatting.formatCurrencyValue(proposalList[i].priceWalk.spdOverrides, 0)
                      +     '</div>'
                      +   '</div>'
                      */

        //dynamic lines diff
        if (proposalList[i].priceWalk.dynamicLineDiffMap){

          for (var j=0; j<priceWalkLabels.length;j++){

            var key = priceWalkLabels[j];
            var diffVal = 0;

            if (proposalList[i].priceWalk.dynamicLineDiffMap[key]){
              diffVal = proposalList[i].priceWalk.dynamicLineDiffMap[key];
            }

            priceWalkHTML += '<div class="slds-grid slds-wrap slds-grid--pull-padded tws_borderRightStrong">'
                          +     '<div class="slds-size--1-of-2 slds-col--padded priceWalkColumn slds-text-align--left">'
                          +         key
                          +     '</div>'
                          +     '<div class="slds-size--1-of-2 slds-col--padded priceWalkColumn slds-text-align--right">'
                          +         TWSDetail_Formatting.formatCurrencyValue(diffVal, 0)
                          +     '</div>'
                          +  '</div>';
          }
        }

        //total
        priceWalkHTML +=  '<div class="slds-grid slds-wrap slds-grid--pull-padded tws_borderRightStrong">'
                      +     '<div class="tws_domesticSalesProposalSpecific tws_domesticSpecific tws_nationalSpecific slds-size--1-of-2 slds-col--padded priceWalkColumn slds-text-align--left">'
                      +         'Total'
                      +     '</div>'
                      +     '<div class="tws_canadaSpecific slds-size--1-of-2 slds-col--padded priceWalkColumn slds-text-align--left">'
                      +         'USD Total'
                      +     '</div>'
                      +     '<div class="tws_domesticSalesProposalSpecific tws_domesticSpecific tws_nationalSpecific slds-size--1-of-2 slds-col--padded priceWalkColumn tws_borderTop slds-text-align--right">'
                      +         TWSDetail_Formatting.formatCurrencyValue(proposalList[i].priceWalk.total, 0)
                      +     '</div>'
                      +     '<div class="tws_canadaSpecific slds-size--1-of-2 slds-col--padded priceWalkColumn tws_borderTop slds-text-align--right">'
                      +         TWSDetail_Formatting.formatCurrencyValue(proposalList[i].priceWalk.total, 0)
                      +     '</div>'
                      +     '<div class="tws_canadaSpecific slds-size--1-of-2 slds-col--padded priceWalkColumn slds-text-align--left">'
                      +         'New FEX'
                      +     '</div>'
                      +     '<div class="tws_canadaSpecific slds-size--1-of-2 slds-col--padded priceWalkColumn tws_borderBottom slds-text-align--right">'
                      +         TWSDetail_Formatting.formatCurrencyValue(proposalList[i].pricingProposal.fexRate, 2)
                      +     '</div>'
                      +     '<div class="tws_canadaSpecific slds-size--1-of-2 slds-col--padded priceWalkColumn slds-text-align--left">'
                      +         'Total'
                      +     '</div>'
                      +     '<div class="tws_canadaSpecific slds-size--1-of-2 slds-col--padded priceWalkColumn slds-text-align--right">'
                      //+         TWSDetail_Formatting.formatCurrencyValue(proposalList[i].priceWalk.total * TWSDetail.FEXRate, 0)
                      +         TWSDetail_Formatting.formatCurrencyValue(proposalList[i].priceWalk.total*proposalList[i].pricingProposal.fexRate, 0)
                      +     '</div>'
                      +   '</div>'
                      + '</div>'

        //has reference proposal
        if (proposalList[i].pricingProposalReference){
          priceWalkHTML +=  '<div class="slds-col--padded slds-text-heading--smal tws_borderRightStrong tws_walkPriceColumnContainer tws_noContent">'
                        +     '<div class="slds-grid slds-wrap slds-grid--pull-padded ">'
                        +       '<div class="slds-size--1-of-1 slds-col--padded priceWalkColumn slds-text-align--left">'
                        +         '&nbsp;'
                        +       '</div>'
                        +     '</div>'
                        +   '</div>'
        }
      }
    }

    priceWalkHTML += '</div>';

    $('#tws_priceWalkContainer').append(priceWalkHTML);

    $('#tws_priceWalkContainer').css('width', (TWSDetail.proposalListSize)*290+'px');
  }
}

/*
TWSDetail.populateTWSContributionCalculation = function(twsDetail, proposalList, contributionCalcLabelSet){

  TWSDetail.addDynamicContributionCalculationLabels(contributionCalcLabelSet);

  for(i=0; i< proposalList.length; i++){

    if(proposalList[i].pricingProposal.contributionCalc){
      //TWSContributionCalculation.populateContributionCalcColumn('reference', proposalList[i].pricingProposalReference, contributionCalcLabelSet);
      TWSDetail.populateContributionCalcColumn('proposal', proposalList[i].pricingProposal, proposalList[i].pricingProposal.contributionCalc, contributionCalcLabelSet);
    }
    if(proposalList[i].pricingProposalReference && proposalList[i].pricingProposalReference.contributionCalc){
      //TWSContributionCalculation.populateContributionCalcColumn('reference', proposalList[i].pricingProposalReference, contributionCalcLabelSet);
      TWSDetail.populateContributionCalcColumn('reference', proposalList[i].pricingProposalReference, proposalList[i].pricingProposalReference.contributionCalc, contributionCalcLabelSet);
    }
  }

  $('#tws_ContributionCalcContainer').css('width', (TWSDetail.proposalListSize)*290+'px');

  if (twsDetail.contributionAndCostComments){
    $('#tws_ContributionAndCostCommentsValue').text(twsDetail.contributionAndCostComments);
  }

  if (twsDetail.commitmentOutsideSalesTerms){
    $('#tws_commitmentsValue').text(twsDetail.commitmentOutsideSalesTerms);
  }
}
*/

/*
TWSDetail.populateContributionCalcColumn = function(type, proposal, contributionCalc, contributionCalcLabelSet){

  headerCSSClass = '';

  if (type == 'proposal'){
  headerCSSClass = 'tws_proposalContribCalcColumn';
  }
  else if (type == 'reference'){
  headerCSSClass = 'tws_referenceContribCalcColumn';
  }

  contributionCalcColumnHTML = '<div class="slds-col--padded slds-text-heading--smal tws_ContributionCalcColumnContainer">'
                             +    '<div class="slds-grid slds-wrap slds-grid--pull-padded tws_borderRightStrong">'
                             +      '<div class="tws_domesticSalesProposalSpecific tws_domesticSpecific tws_nationalSpecific tws_canadaSpecific slds-size--1-of-2 slds-col--padded slds-text-align--center tws_strongText tws_borderRight tws_borderBottom tws_2LineHeight">'
                             +         'Formula'
                             +      '</div>'
                             +      '<div class="tws_domesticSalesProposalSpecific tws_domesticSpecific tws_nationalSpecific tws_canadaSpecific slds-size--1-of-2 slds-col--padded slds-text-align--center tws_strongText tws_borderRight tws_borderBottom tws_2LineHeight">'
                             +         TWSDetail_Formatting.getProperty(contributionCalc,'contribCalcMethod')
                             +      '</div>'
                             +      '<div class="tws_internationalSpecific slds-size--1-of-2 slds-col--padded slds-text-align--center tws_strongText tws_borderRight tws_borderBottom tws_2LineHeight">'
                             +         TWSDetail_Formatting.getProperty(contributionCalc,'contribCalcMethod')
                             +      '</div>'
                             +      '<div class="tws_internationalSpecific slds-size--1-of-2 slds-col--padded slds-text-align--center tws_strongText tws_borderRight tws_borderBottom tws_2LineHeight">'
                             +         '&nbsp;'
                             +      '</div>'
                             +      '<div class="tws_domesticSalesProposalSpecific tws_domesticSpecific tws_canadaSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                             +         '&nbsp;'
                             +      '</div>'
                             +      '<div class="tws_domesticSalesProposalSpecific tws_domesticSpecific tws_canadaSpecific slds-size--1-of-2 slds-col--padded slds-text-align--center tws_strongText tws_borderRight tws_borderBottom tws_1LineHeight">'
                             +         TWSDetail_Formatting.getProperty(contributionCalc,'source')
                             +      '</div>'
                             +      '<div class="tws_domesticSalesProposalSpecific tws_domesticSpecific tws_nationalSpecific tws_canadaSpecific slds-size--1-of-2 slds-col--padded '+headerCSSClass+' tws_borderRight tws_borderBottom tws_2LineHeight">'
                             +         '&nbsp'
                             +      '</div>'
                             +      '<div class="tws_domesticSalesProposalSpecific tws_domesticSpecific tws_nationalSpecific tws_canadaSpecific slds-size--1-of-2 slds-col--padded slds-text-align--center tws_strongText tws_borderRight tws_borderBottom tws_2LineHeight">'
                             +        TWSDetail_Formatting.getProperty(contributionCalc,'currentFormula')
                             +      '</div>'
                             +      '<div class="tws_internationalSpecific slds-size--1-of-2 slds-col--padded '+headerCSSClass+' tws_borderRight slds-text-align--center tws_borderBottom tws_darkHighlighted slds-text-align--center tws_2LineHeight">'
                             +        TWSDetail_Formatting.getProperty(contributionCalc,'currentFormula')
                             +      '</div>'
                             +      '<div class="tws_internationalSpecific tws_canadaSpecific slds-size--1-of-2 slds-col--padded slds-text-align--center tws_strongText tws_borderRight tws_borderBottom tws_2LineHeight">'
                             +        '&nbsp;'
                             +      '</div>'
                             +      '<div class="tws_domesticSalesProposalSpecific tws_internationalSpecific tws_nationalSpecific tws_domesticSpecific slds-size--1-of-2 slds-col--padded slds-text-align--center tws_borderRight tws_borderBottom tws_2LineHeight">'
                             +         'Blended Normal'
                             +      '</div>'
                             +      '<div class="tws_domesticSalesProposalSpecific tws_internationalSpecific tws_nationalSpecific tws_domesticSpecific tws_canadaSpecific slds-size--1-of-2 slds-col--padded slds-text-align--center tws_strongText tws_borderRight tws_borderBottom tws_2LineHeight">'
                             +        TWSDetail_Formatting.getProperty(contributionCalc,'methodofCalculation')
                             +      '</div>'
                             +      '<div class="tws_domesticSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_highlightedGreen tws_1LineHeight">'
                             +        TWSDetail_Formatting.formatCurrencyValue( contributionCalc.dealerNet, 0)
                             +      '</div>'
                             +      '<div class="tws_domesticSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_strongText tws_borderRight tws_controllingCell tws_1LineHeight">'
                             +        '&nbsp;'
                             +      '</div>'
                             +      '<div class="tws_domesticSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_highlightedGreen tws_2LineHeight">'
                             +         TWSDetail_Formatting.formatCurrencyValue(contributionCalc.baseModelDnet, 0)
                             +      '</div>'
                             +      '<div class="tws_domesticSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_strongText tws_borderRight tws_controllingCell tws_2LineHeight">'
                             +        '&nbsp;'
                             +      '</div>'
                             +      '<div class="tws_domesticSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_highlightedGreen tws_2LineHeight">'
                             +         TWSDetail_Formatting.formatCurrencyValue(contributionCalc.optionContent, 0)
                             +      '</div>'
                             +      '<div class="tws_domesticSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_strongText tws_borderRight tws_controllingCell tws_2LineHeight">'
                             +        '&nbsp;'
                             +      '</div>'
                             +      '<div class="tws_domesticSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_highlightedGreen tws_underlinedText tws_2LineHeight">'
                             +         TWSDetail_Formatting.formatCurrencyValue(contributionCalc.optionMargin, 0)
                             +      '</div>'
                             +      '<div class="tws_domesticSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_strongText tws_borderRight tws_controllingCell tws_2LineHeight">'
                             +        '&nbsp;'
                             +      '</div>'
                             +      '<div class="tws_domesticSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_highlightedGreen tws_2LineHeight">'
                             +         TWSDetail_Formatting.formatCurrencyValue(contributionCalc.optionContrib, 0)
                             +      '</div>'
                             +      '<div class="tws_domesticSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_strongText tws_borderRight tws_controllingCell tws_2LineHeight">'
                             +        '&nbsp;'
                             +      '</div>'
                             +      '<div class="tws_domesticSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_highlightedGreen tws_underlinedText tws_2LineHeight">'
                             +         TWSDetail_Formatting.formatCurrencyValue(contributionCalc.baseModelContrib, 0)
                             +      '</div>'
                             +      '<div class="tws_domesticSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_strongText tws_borderRight tws_controllingCell tws_2LineHeight">'
                             +        '&nbsp;'
                             +      '</div>'
                             +      '<div class="tws_domesticSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_borderBottom tws_highlightedGreen tws_2LineHeight">'
                             +         TWSDetail_Formatting.formatCurrencyValue(contributionCalc.grossContribution, 0)
                             +      '</div>'
                             +      '<div class="tws_domesticSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_strongText tws_borderRight tws_borderBottom tws_controllingCell tws_2LineHeight">'
                             +        '&nbsp;'
                             +      '</div>'
                             +      '<div class="tws_domesticSalesProposalSpecific tws_nationalSpecific tws_domesticSpecific tws_canadaSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_borderBottom tws_2LineHeight">'
                             +         TWSDetail_Formatting.formatCurrencyValue(contributionCalc.grossFormulaContrib, 0)
                             +      '</div>'
                             +      '<div class="tws_domesticSalesProposalSpecific tws_nationalSpecific tws_domesticSpecific tws_canadaSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_controllingCell tws_2LineHeight">'
                             +        '&nbsp;'
                             +      '</div>'
                             +      '<div class="tws_internationalSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_borderTop tws_1LineHeight">'
                             +         TWSDetail_Formatting.formatCurrencyValue(contributionCalc.dealerNet, 0)
                             +      '</div>'
                             +      '<div class="tws_internationalSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_borderTop tws_controllingCell tws_1LineHeight">'
                             +        '&nbsp;'
                             +      '</div>'
                             +      '<div class="tws_domesticSalesProposalSpecific tws_domesticSpecific tws_nationalSpecific tws_canadaSpecific tws_internationalSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                             +         TWSDetail_Formatting.formatCurrencyValue(contributionCalc.concessionAmount, 0)
                             +      '</div>'
                             +      '<div class="tws_domesticSalesProposalSpecific tws_domesticSpecific tws_nationalSpecific tws_canadaSpecific tws_internationalSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_controllingCell tws_1LineHeight">'
                             +        '&nbsp;'
                             +      '</div>'
                             +      '<div class="tws_internationalSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_borderTop tws_strongText tws_1LineHeight">'
                             +         TWSDetail_Formatting.formatCurrencyValue(contributionCalc.netPrice, 0)
                             +      '</div>'
                             +      '<div class="tws_internationalSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_controllingCell tws_1LineHeight">'
                             +        '&nbsp;'
                             +      '</div>'
                             +      '<div class="tws_internationalSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_borderBottom tws_2LineHeight">'
                             +         TWSDetail_Formatting.formatCurrencyValue(contributionCalc.sumOfAddRevenueImpact, 0)
                             +      '</div>'
                             +      '<div class="tws_internationalSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_controllingCell tws_2LineHeight">'
                             +        '&nbsp;'
                             +      '</div>'
                             +      '<div class="tws_internationalSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_borderTop tws_strongText tws_2LineHeight">'
                             +         TWSDetail_Formatting.formatCurrencyValue(contributionCalc.totalSellingPriceFOB, 0)
                             +      '</div>'
                             +      '<div class="tws_internationalSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_controllingCell tws_2LineHeight">'
                             +        '&nbsp;'
                             +      '</div>'
                             +      '<div class="tws_internationalSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_2LineHeight">'
                             +         TWSDetail_Formatting.formatCurrencyValue(contributionCalc.totalEstimatedCost, 0)
                             +      '</div>'
                             +      '<div class="tws_internationalSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_controllingCell tws_2LineHeight">'
                             +        '&nbsp;'
                             +      '</div>'
                             +      '<div class="tws_canadaSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_borderBottom tws_1LineHeight">'
                             +         TWSDetail_Formatting.formatCurrencyValue(contributionCalc.options, 0)
                             +      '</div>'
                             +      '<div class="tws_canadaSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_controllingCell tws_1LineHeight">'
                             +        '&nbsp;'
                             +      '</div>'
                             +      TWSDetail.addDynamicContributionCalculationRows(contributionCalc, contributionCalcLabelSet)
                             +      '<div class="tws_domesticSalesProposalSpecific tws_canadaSpecific tws_domesticSpecific tws_nationalSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_borderBottom tws_borderTopStrong tws_strongText tws_darkHighlighted tws_3LineHeight">'
                             +         '&nbsp;'
                             +      '</div>'
                             +      '<div class="tws_domesticSalesProposalSpecific tws_canadaSpecific tws_domesticSpecific tws_nationalSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_borderBottom tws_borderTopStrong tws_strongText tws_darkHighlighted tws_3LineHeight">'
                             +        TWSDetail_Formatting.formatCurrencyValue(contributionCalc.stdNetContribTruck, 0)
                             +      '</div>'
                             +      '<div class="tws_internationalSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_borderBottom tws_borderTopStrong tws_strongText tws_darkHighlighted tws_3LineHeight">'
                             +         TWSDetail_Formatting.formatCurrencyValue(contributionCalc.stdNetContribTruck, 0)
                             +      '</div>'
                             +      '<div class="tws_internationalSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_highlightedGreen tws_borderRight tws_borderBottom tws_borderTopStrong tws_strongText tws_darkHighlighted tws_3LineHeight">'
                             +        TWSDetail_Formatting.formatPercentValue(contributionCalc.stdNetContribTruckPer)
                             +      '</div>'
                             +      '<div class="tws_domesticSalesProposalSpecific tws_nationalSpecific tws_domesticSpecific tws_canadaSpecific slds-size--1-of-1 slds-col--padded slds-text-align--right tws_borderRight tws_strongText tws_borderTopStrong tws_borderBottomStrong tws_1LineHeight">'
                             +        '&nbsp;'
                             +      '</div>'
                             +      '<div class="tws_domesticSalesProposalSpecific tws_nationalSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_borderBottom tws_strongText tws_2LineHeight">'
                             +         '&nbsp;'
                             +      '</div>'
                             +      '<div class="tws_domesticSalesProposalSpecific tws_nationalSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_borderBottom tws_strongText tws_2LineHeight">'
                             +        TWSDetail_Formatting.formatCurrencyValue(contributionCalc.residualsGainLoss, 0)
                             +      '</div>'
                             +      '<div class="tws_domesticSalesProposalSpecific tws_nationalSpecific tws_canadaSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_borderBottom tws_strongText tws_2LineHeight">'
                             +         '&nbsp;'
                             +      '</div>'
                             +      '<div class="tws_domesticSalesProposalSpecific tws_nationalSpecific tws_canadaSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_borderBottom tws_strongText tws_2LineHeight">'
                             +        TWSDetail_Formatting.formatCurrencyValue(contributionCalc.csdContribution, 0)
                             +      '</div>'
                             +      '<div class="tws_domesticSalesProposalSpecific tws_domesticSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_borderBottom tws_strongText tws_3LineHeight">'
                             +         '&nbsp;'
                             +      '</div>'
                             +      '<div class="tws_domesticSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_borderBottom tws_3LineHeight">'
                             +        TWSDetail_Formatting.formatCurrencyValue(contributionCalc.chassisWarrantyCont, 0)
                             +      '</div>'
                             +      '<div class="tws_nationalSpecific tws_domesticSpecific tws_canadaSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_borderBottom tws_strongText tws_3LineHeight">'
                             +         '&nbsp;'
                             +      '</div>'
                             +      '<div class="tws_domesticSalesProposalSpecific tws_nationalSpecific tws_domesticSpecific tws_canadaSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_borderBottom tws_3LineHeight">'
                             +        TWSDetail_Formatting.formatCurrencyValue(contributionCalc.engineWarrantyCont, 0)
                             +      '</div>'
                             +      '<div class="tws_domesticSalesProposalSpecific tws_nationalSpecific tws_domesticSpecific tws_canadaSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_borderBottom tws_strongText slds-p-top--small tws_2LineHeight">'
                             +         '&nbsp;'
                             +      '</div>'
                             +      '<div class="tws_domesticSalesProposalSpecific tws_nationalSpecific tws_domesticSpecific tws_canadaSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_borderBottom slds-p-top--small tws_2LineHeight">'
                             +        TWSDetail_Formatting.formatCurrencyValue(contributionCalc.adjNetContribution, 0)
                             +      '</div>'
                             +    '</div>'
                             + '</div>';

   if (contributionCalc.controllingLineItems && TWSDetail.dealType != 'International'){
     contributionCalcColumnHTML = TWSDetail.setControllingValues(contributionCalc, contributionCalc.controllingLineItems, contributionCalcColumnHTML);
   }

   $('#tws_ContributionCalcContainer').append(contributionCalcColumnHTML);
}
*/

/*
TWSDetail.setControllingValues = function(contributionCalc, controllingValues, contributionCalcColumnHTML){

  var result = $(contributionCalcColumnHTML);

  if (TWSDetail.dealType == 'Canadian'){
    controllingSlots = result.find(".tws_controllingCell.tws_canadaSpecific");
    //controllingSlots = result.find(".tws_controllingCell").not(".tws_domesticSpecific").not(".tws_nationalSpecific").not(".tws_internationalSpecific").not(".tws_domesticSalesProposalSpecific");
  }
  else if(TWSDetail.dealType == 'Domestic'){
    controllingSlots = result.find(".tws_controllingCell.tws_domesticSpecific");
    //controllingSlots = result.find(".tws_controllingCell").not(".tws_canadaSpecific").not(".tws_nationalSpecific").not(".tws_internationalSpecific").not(".tws_domesticSalesProposalSpecific");
  }
  else if(TWSDetail.dealType == 'National'){
    controllingSlots = result.find(".tws_controllingCell.tws_nationalSpecific");
    //controllingSlots = result.find(".tws_controllingCell").not(".tws_domesticSpecific").not(".tws_canadaSpecific").not(".tws_internationalSpecific").not(".tws_domesticSalesProposalSpecific");
  }
  else if(TWSDetail.dealType == 'International'){
    controllingSlots = result.find(".tws_controllingCell.tws_internationalSpecific");
    //controllingSlots = result.find(".tws_controllingCell").not(".tws_domesticSpecific").not(".tws_canadaSpecific").not(".tws_nationalSpecific").not(".tws_domesticSalesProposalSpecific");
  }
  else if(TWSDetail.dealType == 'Sales Proposal'){
    controllingSlots = result.find(".tws_controllingCell.tws_domesticSalesProposalSpecific");
    //controllingSlots = result.find(".tws_controllingCell").not(".tws_domesticSpecific").not(".tws_canadaSpecific").not(".tws_nationalSpecific").not(".tws_internationalSpecific");
  }

  //set fixed values
  rowNumber = controllingSlots.eq(controllingSlots.length-1).data('rownumber');

  controllingCellHtml = '<div class="slds-size--1-of-4 slds-col--padded slds-text-align--right tws_borderBottom tws_controllingCell tws_menuRow" data-rownumber="'+rowNumber+'">'
                      +     'B/N CM'
                      + '</div>'
                      + '<div class="slds-size--1-of-4 slds-col--padded slds-text-align--right tws_borderRight tws_borderBottom tws_controllingCell tws_menuRow" data-rownumber="'+rowNumber+'">'
                      +     TWSDetail_Formatting.formatCurrencyValue(contributionCalc.bnCM, 0)
                      + '</div>'

  controllingSlots.eq(controllingSlots.length-1).replaceWith(controllingCellHtml);
  //
  rowNumber = controllingSlots.eq(controllingSlots.length-2).data('rownumber');

  controllingCellHtml = '<div class="slds-size--1-of-4 slds-col--padded slds-text-align--right tws_borderBottom tws_controllingCell tws_menuRow" data-rownumber="'+rowNumber+'">'
                      +     'B/N Adj'
                      + '</div>'
                      + '<div class="slds-size--1-of-4 slds-col--padded slds-text-align--right tws_borderRight tws_borderBottom tws_controllingCell tws_menuRow" data-rownumber="'+rowNumber+'">'
                      +     TWSDetail_Formatting.formatCurrencyValue(contributionCalc.bnAdj, 0)
                      + '</div>'

  controllingSlots.eq(controllingSlots.length-2).replaceWith(controllingCellHtml);
  //
  rowNumber = controllingSlots.eq(controllingSlots.length-3).data('rownumber');

  controllingCellHtml = '<div class="slds-size--1-of-4 slds-col--padded slds-text-align--right tws_borderBottom tws_controllingCell tws_menuRow" data-rownumber="'+rowNumber+'">'
                      +     'Adj CM'
                      + '</div>'
                      + '<div class="slds-size--1-of-4 slds-col--padded slds-text-align--right tws_borderRight tws_borderBottom tws_controllingCell tws_menuRow" data-rownumber="'+rowNumber+'">'
                      +     TWSDetail_Formatting.formatCurrencyValue(contributionCalc.adjCM, 0)
                      + '</div>'

  controllingSlots.eq(controllingSlots.length-3).replaceWith(controllingCellHtml)
  //

  var iter = 4;

  //set dynamic values
  for (var i=0; i<controllingValues.length && i<controllingSlots.length; i++){

    rowNumber = controllingSlots.eq(controllingSlots.length-iter).data('rownumber');

    controllingCellHtml = '<div class="slds-size--1-of-4 slds-col--padded slds-text-align--right tws_borderBottom tws_controllingCell tws_menuRow" data-rownumber="'+rowNumber+'">'
                        +     controllingValues[i].name
                        + '</div>'
                        + '<div class="slds-size--1-of-4 slds-col--padded slds-text-align--right tws_borderRight tws_borderBottom tws_controllingCell tws_menuRow" data-rownumber="'+rowNumber+'">'
                        +     TWSDetail_Formatting.formatCurrencyValue(controllingValues[i].amount, 0)
                        + '</div>'

    controllingSlots.eq(controllingSlots.length-iter).replaceWith(controllingCellHtml);
    iter++;
  }
  //
  rowNumber = controllingSlots.eq(controllingSlots.length-iter).data('rownumber');

  controllingCellHtml = '<div class="slds-size--1-of-4 slds-col--padded slds-text-align--right tws_borderBottom tws_controllingCell tws_menuRow" data-rownumber="'+rowNumber+'">'
                      +     'Std CM'
                      + '</div>'
                      + '<div class="slds-size--1-of-4 slds-col--padded slds-text-align--right tws_borderRight tws_borderBottom tws_controllingCell tws_menuRow" data-rownumber="'+rowNumber+'">'
                      +     TWSDetail_Formatting.formatCurrencyValue(contributionCalc.stdCM, 0)
                      + '</div>'

  controllingSlots.eq(controllingSlots.length-iter).replaceWith(controllingCellHtml);

  return result;
}
*/

/*
TWSDetail.addDynamicContributionCalculationLabels = function(labels){

  contributionCalcLabelsHTML ='';

  for (i=0; i<labels.length; i++){

    contributionCalcLabelsHTML += '<div class="slds-col--padded slds-size--1-of-1 tws_borderBottomWhite tws_heightToAdjust" data-name="contrCalcItem'+i+'">'
                                +   labels[i]
                                + '</div>'
  }

  $('#tws_dummyDynamicContributionLabel').replaceWith(contributionCalcLabelsHTML);
}
*/
/*
TWSDetail.addDynamicContributionCalculationRows = function(contributionCalc, labels){

  contributionRowsHTML = '';

  for (var j=0; j<labels.length; j++){

    value = 0;

    if (contributionCalc.dynamicLineItems){
      if (contributionCalc.dynamicLineItems[labels[j]]){
        value = contributionCalc.dynamicLineItems[labels[j]].amount;
      }
    }

    contributionRowsHTML += '<div class="tws_domesticSalesProposalSpecific tws_domesticSpecific tws_nationalSpecific tws_canadaSpecific tws_internationalSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_borderBottom tws_heightToAdjust" data-name="contrCalcItem'+j+'">'
                         +      TWSDetail_Formatting.formatCurrencyValue(value, 0)
                         +   '</div>'
                         +   '<div class="tws_domesticSalesProposalSpecific tws_domesticSpecific tws_nationalSpecific tws_canadaSpecific tws_internationalSpecific slds-size--1-of-2 slds-col--padded slds-text-align--right tws_borderRight tws_borderBottom tws_controllingCell tws_heightToAdjust" data-name="contrCalcItem'+j+'">'
                         +      '&nbsp;'
                         +   '</div>'
  }

  return contributionRowsHTML;
}
*/

TWSDetail.populateExtendedWarrantyInfo = function(result, pricingProposalList){

  if(TWSDetail.dealType != 'International'){

    TWSDetail.populateChassisWarrantyLabels(result.chassisWarrantyElementsKeyMap);

    $('#tws_chassisWarrantyQuoteNumberValue').text(result.chassisWarrantyQuoteNumber);

    for (var i=0; i<pricingProposalList.length; i++){

      TWSDetail.populateChassisWarrantyRow('proposal', pricingProposalList[i].pricingProposal.name, pricingProposalList[i].pricingProposal.chassisWarranty, result.chassisWarrantyElementsKeyMap);
      if(pricingProposalList[i].pricingProposalReference){
        TWSDetail.populateChassisWarrantyRow('reference', pricingProposalList[i].pricingProposalReference.name, pricingProposalList[i].pricingProposalReference.chassisWarranty, result.chassisWarrantyElementsKeyMap);
      }
    }

    if (result.chassisExtendedWarrantyComments){
      var chassisExtendedWarrantyComments = result.chassisExtendedWarrantyComments.replace(/\n/g, "<br/><br/>");
      $('#tws_chassisWarrantyCommentsValue').html(chassisExtendedWarrantyComments);
    }
  }
}

TWSDetail.populateChassisWarrantyLabels = function(keyLabelMap){

  chassisWarrantyLabelsHTML = '';

  $.each(keyLabelMap, function( key, value ) {

    chassisWarrantyLabelsHTML += '<div class="slds-col--padded slds-size--4-of-12 tws_borderLeftStrong tws_borderRight tws_borderBottom tws_heightToAdjust" data-name="chassisWarrRow'+key+'">'
                               +    key
                               + '</div>'
                               +'<div class="slds-col--padded slds-size--8-of-12 tws_borderRight tws_borderBottom tws_heightToAdjust" data-name="chassisWarrRow'+key+'">'
                               +    value
                               + '</div>'

  });

  chassisWarrantyLabelsHTML += '<div class="slds-size--4-of-12 slds-col--padded slds-text-align--left tws_borderRight tws_borderTopStrong">'
                            +     '&nbsp;'
                            + '</div>'
                            + '<div class="slds-size--8-of-12 slds-col--padded slds-text-align--left tws_borderRight tws_borderBottom tws_borderTopStrong tws_2LineHeight">'
                            +     'Total EWC Quoted Price'
                            + '</div>'
                            + '<div class="tws_canadaSpecific slds-size--4-of-12 slds-col--padded slds-text-align--left tws_borderRight">'
                            +     '&nbsp;'
                            + '</div>'
                            + '<div class="tws_canadaSpecific slds-size--8-of-12 slds-col--padded slds-text-align--left tws_borderRight tws_borderBottom tws_1LineHeight">'
                            +     'Warranty Reserve'
                            + '</div>'
                            + '<div class="slds-size--12-of-12 slds-col--padded slds-text-align--left tws_2LineHeight">'
                            +     'Expected Extended Chassis Warranty Cost'
                            + '</div>'
                            + '<div class="slds-size--12-of-12 slds-col--padded slds-text-align--left tws_borderTopWhiteStrong tws_strongText tws_3LineHeight">'
                            +     'Projected Extended Chassis Warranty Margin'
                            + '</div>'

  $('#tws_extendedWarrantyRowDescriptionContainer').append(chassisWarrantyLabelsHTML);
}

TWSDetail.populateChassisWarrantyRow = function(proposalType, proposalName, chassisWarranty, keyMap){

  headerCSSClass = '';

  if (proposalType == 'proposal'){
    headerCSSClass = 'tws_proposalChassisWarrantyColumn';
  }
  else if (proposalType == 'reference'){
    headerCSSClass = 'tws_referenceChassisWarrantyColumn';
  }

  chassisWarrantyColumnHTML = '<div class="slds-col--padded tws_borderTopStrong tws_extendedWarrantyColumn">'
                            +   '<div class="slds-grid slds-wrap slds-grid--pull-padded ">'
                            +     '<div class="slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderLeftStrong tws_borderRightStrong tws_borderBottomStrong tws_heightToAdjust" data-name="columnDescription">'
                            +       proposalName
                            +     '</div>'
                            +     '<div class="tws_domesticSalesProposalSpecific tws_domesticSpecific slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderLeftStrong tws_borderBottomStrong '+headerCSSClass+' tws_heightToAdjust" data-name="chassisWarrHeader">'
                            +       'EWC  Quoted Price'
                            +     '</div>'
                            +     '<div class="tws_domesticSalesProposalSpecific tws_domesticSpecific slds-col--padded slds-size--1-of-2 slds-text-align--center tws_borderLeftStrong tws_borderBottomStrong tws_borderRightStrong slds-align--absolute-center '+headerCSSClass+' tws_heightToAdjust" data-name="chassisWarrHeader">'
                            +       'SPP?'
                            +     '</div>'
                            +     '<div class="tws_canadaSpecific tws_nationalSpecific slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderLeftStrong tws_borderBottomStrong tws_borderRightStrong '+headerCSSClass+' tws_heightToAdjust" data-name="chassisWarrHeader">'
                            +       'EWC  Quoted Price'
                            +     '</div>'
                            +     TWSDetail.populateChassisWarrantyValues(chassisWarranty, keyMap)
                            +   '</div>'
                            +'</div>'

  $('#tws_extendedWarrantyColumnContainer').append(chassisWarrantyColumnHTML);
}

TWSDetail.populateChassisWarrantyValues = function(chassisWarranty, keyMap){

  chassisWarrantyValuesHTML = '';

  $.each(keyMap, function( key, value ) {

    eWCQuotedPriceValue = '';
    eWCQuotedPriceValueCAD = '';
    sppValue = '';

    if (chassisWarranty.dynamicLineItemMap){
      if (chassisWarranty.dynamicLineItemMap[key]){
        eWCQuotedPriceValue = chassisWarranty.dynamicLineItemMap[key].eWCQuotedPrice;
        eWCQuotedPriceValueCAD = chassisWarranty.dynamicLineItemMap[key].eWCQuotedPriceCAD;
        sppValue = chassisWarranty.dynamicLineItemMap[key].spp;
      }
    }

    chassisWarrantyValuesHTML += '<div class="tws_domesticSalesProposalSpecific tws_domesticSpecific slds-col--padded slds-size--6-of-12 tws_borderLeftStrong slds-text-align--center tws_borderLeftStrong tws_borderBottom tws_heightToAdjust" data-name="chassisWarrRow'+key+'">'
                               +    TWSDetail_Formatting.formatCurrencyValue(eWCQuotedPriceValue, 0)
                               + '</div>'
                               + '<div class="tws_canadaSpecific slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderRightStrong tws_borderLeftStrong tws_borderBottom tws_heightToAdjust" data-name="chassisWarrRow'+key+'">'
                               +    TWSDetail_Formatting.formatCurrencyValue(eWCQuotedPriceValueCAD, 0)
                               + '</div>'
                               +'<div class="tws_domesticSalesProposalSpecific tws_domesticSpecific slds-col--padded slds-size--6-of-12 slds-text-align--center tws_borderLeftStrong tws_borderRightStrong tws_borderBottom tws_heightToAdjust" data-name="chassisWarrRow'+key+'">'
                               +    sppValue
                               + '</div>'
                               +'<div class="tws_nationalSpecific slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderLeftStrong tws_borderRightStrong tws_borderBottom tws_heightToAdjust" data-name="chassisWarrRow'+key+'">'
                               +    TWSDetail_Formatting.formatCurrencyValue(eWCQuotedPriceValue, 0)
                               + '</div>'
  });

  chassisWarrantyValuesHTML += '<div class="tws_nationalSpecific tws_internationalSpecific tws_domesticSalesProposalSpecific tws_domesticSpecific slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderLeftStrong tws_borderRightStrong tws_borderTopStrong tws_borderBottom tws_2LineHeight">'
                             +    TWSDetail_Formatting.formatCurrencyValue(chassisWarranty.totalEWCQuotedPrice, 0)
                             + '</div>'
                             + '<div class="tws_canadaSpecific slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderLeftStrong tws_borderRightStrong tws_borderBottom tws_1LineHeight">'
                             +    TWSDetail_Formatting.formatCurrencyValue(chassisWarranty.totalEWCQuotedPriceCAD, 0)
                             + '</div>'
                             + '<div class="tws_canadaSpecific slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderLeftStrong tws_borderRightStrong tws_borderBottom tws_1LineHeight">'
                             +    TWSDetail_Formatting.formatCurrencyValue(chassisWarranty.warrantyReserveCAD, 0)
                             + '</div>'
                             + '<div class="tws_nationalSpecific tws_internationalSpecific tws_domesticSalesProposalSpecific tws_domesticSpecific slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderLeftStrong tws_borderRightStrong tws_borderBottomStrong tws_2LineHeight">'
                             +    TWSDetail_Formatting.formatCurrencyValue(chassisWarranty.expectedExtendedCost, 0)
                             + '</div>'
                             + '<div class="tws_canadaSpecific slds-col--padded slds-size--1-of-1 slds-text-align--center tws_borderLeftStrong tws_borderRightStrong tws_borderBottomStrong tws_2LineHeight">'
                             +    TWSDetail_Formatting.formatCurrencyValue(chassisWarranty.expectedExtendedCostCAD, 0)
                             + '</div>'
                             + '<div class="tws_nationalSpecific tws_internationalSpecific tws_domesticSalesProposalSpecific tws_domesticSpecific slds-col--padded slds-size--1-of-1 slds-text-align--center tws_strongText tws_3LineHeight">'
                             +    TWSDetail_Formatting.formatCurrencyValue(chassisWarranty.projectedExtendedMarg, 0)
                             + '</div>'
                             + '<div class="tws_canadaSpecific slds-col--padded slds-size--1-of-1 slds-text-align--center tws_strongText tws_3LineHeight">'
                             +    TWSDetail_Formatting.formatCurrencyValue(chassisWarranty.projectedExtendedMargCAD, 0)
                             + '</div>'

  return chassisWarrantyValuesHTML;
}

/*
TWSDetail.populateEngineWarrantyInfo = function(result, pricingProposalList){

  if(TWSDetail.dealType != 'International'){

    $('#tws_engineWarrantyQuoteNumberValue').text(result.engineWarrantyQuoteNumber);

    for (var i=0; i<pricingProposalList.length; i++){

      TWSDetail.populateEngineWarrantyRow('proposal', pricingProposalList[i].pricingProposal.name, pricingProposalList[i].pricingProposal.engineWarranty);
      if (pricingProposalList[i].pricingProposalReference){
        TWSDetail.populateEngineWarrantyRow('reference', pricingProposalList[i].pricingProposalReference.name, pricingProposalList[i].pricingProposalReference.engineWarranty);
      }
    }

    $('#tws_engineWarrantyCommentsValue').text(result.engineExtendedWarrantyComments);
  }
}
*/

/*
TWSDetail.populateEngineWarrantyRow = function(proposalType, proposalName, engineWrranty){

  rowCSSClass = '';

  if (proposalType == 'proposal'){
    rowCSSClass = 'tws_engineWarrantyProposalRow';
  }
  else if (proposalType == 'reference'){
    rowCSSClass = 'tws_engineWarrantyProposalReferenceRow';
  }

  var engineWarrantyRowHTML ='';

  if (engineWrranty != undefined && engineWrranty.id != undefined){

    engineWarrantyRowHTML +=  '<div class="slds-col--padded slds-text-align--center tws_engineWarrantyLargeColumn '+rowCSSClass+' tws_menuRow" data-rownumber="engWarRow">'
                          +      TWSDetail_Formatting.getProperty(engineWrranty, 'quoteNumber')
                          +    '</div>'
                          +    '<div class="slds-col--padded slds-text-align--center tws_engineWarrantyLargeColumn '+rowCSSClass+' tws_menuRow" data-rownumber="engWarRow">'
                          +      TWSDetail_Formatting.getProperty(engineWrranty, 'coverageDescription')
                          +    '</div>'
                          +    '<div class="slds-col--padded slds-text-align--center tws_engineWarrantySmallColumn '+rowCSSClass+' tws_menuRow" data-rownumber="engWarRow">'
                          +      TWSDetail_Formatting.getProperty(engineWrranty, 'timeMileage')
                          +    '</div>'
                          +    '<div class="slds-col--padded slds-text-align--center tws_engineWarrantySmallColumn '+rowCSSClass+' tws_menuRow" data-rownumber="engWarRow">'
                          +      TWSDetail_Formatting.formatCurrencyValue(engineWrranty.deduct, 0)
                          +    '</div>'
                          +    '<div class="slds-col--padded slds-text-align--center tws_engineWarrantyMediumColumn '+rowCSSClass+' tws_menuRow" data-rownumber="engWarRow">'
                          +      TWSDetail_Formatting.getProperty(engineWrranty, 'highwayOrVocation')
                          +    '</div>'
                          +    '<div class="slds-col--padded slds-text-align--center tws_engineWarrantySmallColumn '+rowCSSClass+' tws_menuRow" data-rownumber="engWarRow">'
                          +      TWSDetail_Formatting.getProperty(engineWrranty, 'highTorque')
                          +    '</div>'
                          +    '<div class="slds-col--padded slds-text-align--center tws_engineWarrantySmallColumn '+rowCSSClass+' tws_menuRow" data-rownumber="engWarRow">'
                          +      TWSDetail_Formatting.formatCurrencyValue(engineWrranty.fmvDeferredRevenue, 0)
                          +    '</div>'
                          +    '<div class="slds-col--padded slds-text-align--center tws_engineWarrantySmallColumn '+rowCSSClass+' tws_menuRow" data-rownumber="engWarRow">'
                          +      TWSDetail_Formatting.formatCurrencyValue(engineWrranty.ewCost, 0)
                          +    '</div>'
                          +    '<div class="slds-col--padded slds-text-align--center tws_engineWarrantySmallColumn '+rowCSSClass+' tws_menuRow" data-rownumber="engWarRow">'
                          +      TWSDetail_Formatting.formatCurrencyValue(engineWrranty.csdEwMargin, 0)
                          +    '</div>'
                          +    '<div class="slds-col--padded slds-text-align--center tws_engineWarrantySmallColumn '+rowCSSClass+' tws_menuRow" data-rownumber="engWarRow">'
                          +      TWSDetail_Formatting.getProperty(engineWrranty, 'pCodeValue')
                          +    '</div>'
                          +    '<div class="slds-col--padded slds-text-align--center tws_engineWarrantySmallColumn '+rowCSSClass+' tws_menuRow" data-rownumber="engWarRow">'
                          +      TWSDetail_Formatting.formatCurrencyValue(engineWrranty.xFerCostAdj, 0)
                          +    '</div>'
                          +    '<div class="slds-col--padded slds-text-align--center tws_engineWarrantySmallColumn '+rowCSSClass+' tws_menuRow" data-rownumber="engWarRow">'
                          +      TWSDetail_Formatting.formatCurrencyValue(engineWrranty.netImpact, 0)
                          +    '</div>'
                          +    '<div class="slds-col--padded slds-text-align--center tws_engineWarrantySmallColumn '+rowCSSClass+' tws_menuRow" data-rownumber="engWarRow">'
                          +      TWSDetail_Formatting.formatCurrencyValue(engineWrranty.dtnaMargin, 0)
                          +    '</div>'
                          +    '<div class="slds-col--padded slds-text-align--center tws_engineWarrantySmallColumn '+rowCSSClass+' tws_menuRow" data-rownumber="engWarRow">'
                          +      TWSDetail_Formatting.formatCurrencyValue(engineWrranty.customerPrice, 0)
                          +    '</div>'
                          +    '<div class="tws_domesticSalesProposalSpecific tws_domesticSpecific slds-col--padded slds-text-align--center tws_engineWarrantySmallColumn '+rowCSSClass+' tws_menuRow" data-rownumber="engWarRow">'
                          +      TWSDetail_Formatting.getProperty(engineWrranty, 'engine')
                          +    '</div>'
                          +    '<div class="tws_domesticSalesProposalSpecific tws_domesticSpecific slds-col--padded slds-text-align--center tws_engineWarrantySmallColumn '+rowCSSClass+' tws_menuRow" data-rownumber="engWarRow">'
                          +      TWSDetail_Formatting.getProperty(engineWrranty, 'spp')
                          +    '</div>'
                          +    '<div class="slds-col--padded slds-text-align--center tws_engineWarrantyLargeColumn '+rowCSSClass+' tws_menuRow" data-rownumber="engWarRow">'
                          +      proposalName
                          +    '</div>'
                          +    '<div class="tws_nationalSpecific tws_canadaSpecific slds-col--padded slds-text-align--center tws_engineWarrantyLargeColumn '+rowCSSClass+' tws_menuRow" data-rownumber="engWarRow" style="width:130px;">'
                          +      '&nbsp;'
                          +    '</div>';
  }

  $('#tws_engineWarrantyRowsContainer').append(engineWarrantyRowHTML);
}
*/

TWSDetail.adjustPosition = function(pricingProposalList){

  $('#tws_pricingProposalContainer').css('width', (TWSDetail.proposalListSize)*290+'px');
  $('#tws_extendedWarrantyColumnContainer').css('width', (TWSDetail.proposalListSize)*164+'px');
  $('#tws_extendedWarrantyRowValuesContainer').css('width', (TWSDetail.proposalListSize*2)*82+'px');

  TWSDetail.adjustColumnsHeight();

  //contribution calculation
  if (TWSDetail.dealType == 'Canadian'){
    marginTopValue = $('#tws_escalatorsContainer').outerHeight(true)+ $('#tws_dealSummaryContainer').outerHeight(true) + $('#tws_contributionCalcTitleContainer').outerHeight(true);
    $('#tws_ContributionCalcContainer').css('margin-top', marginTopValue+14);
  }
  else if (TWSDetail.dealType == 'National'){
    marginTopValue = $('#tws_escalatorsContainer').outerHeight(true)+ $('#tws_dealSummaryContainer').outerHeight(true) + $('#tws_contributionCalcTitleContainer').outerHeight(true);
    $('#tws_ContributionCalcContainer').css('margin-top', marginTopValue+11);
  }
  else if (TWSDetail.dealType == 'International'){
    marginTopValue = $('#tws_escalatorsContainer').outerHeight(true)+ $('#tws_dealSummaryContainer').outerHeight(true) + $('#tws_contributionCalcTitleContainer').outerHeight(true);
    $('#tws_ContributionCalcContainer').css('margin-top', marginTopValue+10);
  }
  else{
    marginTopValue = $('#tws_escalatorsContainer').outerHeight(true)+ $('#tws_dealSummaryContainer').outerHeight(true) + $('#tws_contributionCalcTitleContainer').outerHeight(true);
    $('#tws_ContributionCalcContainer').css('margin-top', marginTopValue+15);
  }

  //outgoing residuals info
  if (TWSDetail.dealType == 'Canadian' || TWSDetail.dealType == 'National' || TWSDetail.dealType == 'Sales Proposal'){
    marginTopValue = $('#tws_ContributionAndCostCommentsContainer').outerHeight(true)+ $('#tws_commitmentsContainer').outerHeight(true)+ $('#tws_OutgoingResidualsTitleContainer').outerHeight(true) + $('#tws_OutgoingResidualsQuestionContainer').outerHeight(true);
    $('#tws_OutgoingResInfoContainer').css('margin-top', marginTopValue-10);
  }
  else{
    marginTopValue = $('#tws_ContributionAndCostCommentsContainer').outerHeight(true)+ $('#tws_OutgoingResidualsTitleContainer').outerHeight(true) + $('#tws_OutgoingResidualsQuestionContainer').outerHeight(true)-10;
    $('#tws_OutgoingResInfoContainer').css('margin-top', marginTopValue-5);
  }
}

/*
TWSDetail.populateIncomingUsedTruck = function(twsDetail){

  if(twsDetail.incomingUsedTruckList.length >0){

    for (var i=0; i< twsDetail.incomingUsedTruckList.length; i++){

      var usedTruckInfo = twsDetail.incomingUsedTruckList[i];

      var incomingUsedTruckRowHTML = '';

      var dealType = 'Current';
      if (usedTruckInfo.previousDeal){
        dealType = 'Previous';
      }

      incomingUsedTruckRowHTML += '<div class="slds-grid slds-wrap slds-grid--pull-padded">'
                                +   '<div class="tws_incomingUsedTruckInfoTitle slds-col--padded slds-size--1-of-1 slds-text-body--regular slds-m-top--xx-small tws_borderBottom">'
                                +     'Incoming Used Truck Information '//+ usedTruckInfo.name
                                +     '<span style="display:none" class="tws_canadaSpecific">'
                                +       '(<span class="tws_canadianNote">NOTE: ALL USED TRUCK VALUES ARE IN CANADIAN DOLLARS</span>)'
                                +     '</span>'
                                +   '</div>'
                                +   '<div class="slds-col--padded slds-size--1-of-1 slds-scrollable--x">'
                                +     '<div class="slds-grid slds-wrap slds-grid--pull-padded" style="width:1390px">'
                                +       '<div class="slds-col--padded" style="width:1390px">'
                                +         '<div class="slds-grid slds-wrap slds-grid--pull-padded">'
                                +           '<div class="slds-col--padded tws_strongText" style="width:200px">'
                                +             dealType+' Deal Summary'
                                +           '</div>'
                                +           '<div class="slds-col--padded tws_strongText" style="width:200px">'
                                +             'Did DTR Participate? <span class="tws_incomingUsedTruckHeaderValue">'+TWSDetail_Formatting.getProperty(usedTruckInfo, 'dtrParticipation')+'</span>'
                                +           '</div>'
                                +           '<div class="slds-col--padded tws_strongText" style="width:200px">'
                                +             'DTR# <span class="tws_incomingUsedTruckHeaderValue">'+TWSDetail_Formatting.getProperty(usedTruckInfo, 'dtrNumber')+'</span>'
                                +             'DLR# <span class="tws_incomingUsedTruckHeaderValue">'+TWSDetail_Formatting.getProperty(usedTruckInfo, 'dlrNumber')+'</span>'
                                +           '</div>'
                                +           '<div class="slds-col--padded tws_strongText" style="width:200px">'
                                +             'Total Trades = <span class="tws_incomingUsedTruckHeaderValue">'+TWSDetail_Formatting.getProperty(usedTruckInfo, 'totalTrades')+'</span>'
                                +           '</div>'
                                +         '</div>'
                                +       '</div>'
                                +       '<div class="slds-col--padded slds-size--1-of-1 ">'
                                +         '<div class="slds-grid slds-wrap slds-grid--pull-padded tws_incomingUsedTruckHeader tws_borderTopStrong tws_borderBottomStrong">'
                                +           '<div class="slds-col--padded tws_incomingUsedTrackSmallColumn">'
                                +             'TR / GR'
                                +           '</div>'
                                +           '<div class="slds-col--padded tws_incomingUsedTrackLargeColumn">'
                                +             'Agreement Number'
                                +           '</div>'
                                +           '<div class="slds-col--padded tws_incomingUsedTrackSmallColumn">'
                                +             'QTY'
                                +           '</div>'
                                +           '<div class="slds-col--padded tws_incomingUsedTrackLargeColumn">'
                                +             'Year/Make'
                                +           '</div>'
                                +           '<div class="slds-col--padded tws_incomingUsedTrackLargeColumn">'
                                +             'Model / Sleeper / Engine'
                                +           '</div>'
                                +           '<div class="slds-col--padded tws_incomingUsedTrackLargeColumn">'
                                +             'Show Dollars'
                                +           '</div>'
                                +           '<div class="slds-col--padded tws_incomingUsedTrackLargeColumn">'
                                +             'Hard Dollars'
                                +           '</div>'
                                +           '<div class="slds-col--padded tws_incomingUsedTrackLargeColumn">'
                                +             'Per Unit OA'
                                +           '</div>'
                                +           '<div class="slds-col--padded tws_incomingUsedTrackLargeColumn">'
                                +             'Total DTNA OA Required'
                                +           '</div>'
                                +         '</div>'
                                +         '<div class="slds-grid slds-wrap slds-grid--pull-padded">'
                                +           TWSDetail.getIncomingUsedTruckRows(usedTruckInfo)
                                +           TWSDetail.getIncomingUsedTruckSummaryRows(usedTruckInfo)
                                +         '</div>'
                                +       '</div>'
                                +     '</div>'
                                +   '</div>'
                                +   '<div class="slds-col--padded slds-size--1-of-1 tws_incomingUsedTruckCommentsContainer">'
                                +     '<div class="tws_incomingUsedTruckCommentsTitle">'
                                +       dealType+' Deal Comments'
                                +     '</div>'
                                +     '<div class="tws_incomingUsedTruckCommentsValue">'
                                +       TWSDetail.getIncomingUsedTruckComments(usedTruckInfo)
                                +     '</div>'
                                +   '</div>'
                                + '</div>'

      $('#tws_incomingUsedTruckInfoContainer').append(incomingUsedTruckRowHTML);
    }
  }
}

TWSDetail.getIncomingUsedTruckRows = function(incomingUsedTruckInfo){

  var incomingUsedTruckRowHTML = ''
  if (incomingUsedTruckInfo.incomingUsedTruckItems.length > 0){

    for (var i=0; i<incomingUsedTruckInfo.incomingUsedTruckItems.length; i++){

        var incomingUsedTruckItem = incomingUsedTruckInfo.incomingUsedTruckItems[i];

        incomingUsedTruckRowHTML+=  '<div class="slds-col--padded tws_incomingUsedTruckRow">'
                                +     '<div class="slds-grid slds-wrap slds-grid--pull-padded">'
                                +       '<div class="slds-col--padded tws_incomingUsedTrackSmallColumn tws_borderBottom">'
                                +         TWSDetail_Formatting.getProperty(incomingUsedTruckItem, 'trGR')
                                +       '</div>'
                                +       '<div class="slds-col--padded tws_incomingUsedTrackLargeColumn tws_borderBottom">'
                                +         TWSDetail_Formatting.getProperty(incomingUsedTruckItem, 'agreementNumber')
                                +       '</div>'
                                +       '<div class="slds-col--padded tws_incomingUsedTrackSmallColumn tws_borderBottom">'
                                +         incomingUsedTruckItem.qty
                                +       '</div>'
                                +       '<div class="slds-col--padded tws_incomingUsedTrackLargeColumn tws_borderBottom">'
                                +         TWSDetail_Formatting.getProperty(incomingUsedTruckItem, 'yearMake')
                                +       '</div>'
                                +       '<div class="slds-col--padded tws_incomingUsedTrackLargeColumn tws_borderBottom">'
                                +         TWSDetail_Formatting.getProperty(incomingUsedTruckItem, 'modelSleeperEngine')
                                +       '</div>'
                                +       '<div class="slds-col--padded tws_incomingUsedTrackLargeColumn tws_borderBottom">'
                                +         TWSDetail_Formatting.formatCurrencyValue(incomingUsedTruckItem.showDollars)
                                +       '</div>'
                                +       '<div class="slds-col--padded tws_incomingUsedTrackLargeColumn tws_borderBottom">'
                                +         TWSDetail_Formatting.formatCurrencyValue(incomingUsedTruckItem.hardDollars)
                                +       '</div>'
                                +       '<div class="slds-col--padded tws_incomingUsedTrackLargeColumn tws_borderBottom">'
                                +         TWSDetail_Formatting.formatCurrencyValue(incomingUsedTruckItem.perUnitOA)
                                +       '</div>'
                                +       '<div class="slds-col--padded tws_incomingUsedTrackLargeColumn tws_borderBottom">'
                                +         TWSDetail_Formatting.formatCurrencyValue(incomingUsedTruckItem.totalDTNAOARequired)
                                +       '</div>'
                                +     '</div>'
                                +   '</div>'

    }
  }

  return incomingUsedTruckRowHTML;
}

TWSDetail.getIncomingUsedTruckSummaryRows = function(incomingUsedTruckInfo){

  var summaryRowsHTML = '';

  summaryRowsHTML +=  '<div class="slds-col--padded tws_incomingUsedTruckRow">'
                  +     '<div class="slds-grid slds-wrap slds-grid--pull-padded">'
                  +       '<div class="slds-col--padded tws_incomingUsedTrackSmallColumn">'
                  +         '&nbsp;'
                  +       '</div>'
                  +       '<div class="slds-col--padded tws_incomingUsedTrackLargeColumn">'
                  +         '&nbsp;'
                  +       '</div>'
                  +       '<div class="slds-col--padded tws_incomingUsedTrackSmallColumn">'
                  +         '&nbsp;'
                  +       '</div>'
                  +       '<div class="slds-col--padded tws_incomingUsedTrackLargeColumn">'
                  +         '&nbsp;'
                  +       '</div>'
                  +       '<div class="slds-col--padded tws_incomingUsedTrackLargeColumn">'
                  +         '&nbsp;'
                  +       '</div>'
                  +       '<div class="slds-col--padded tws_incomingUsedTrackLargeColumn">'
                  +         '&nbsp;'
                  +       '</div>'
                  +       '<div class="slds-col--padded tws_incomingUsedTrackSummaryColumn">'
                  +         'Total DTNA OA Required'
                  +       '</div>'
                  +       '<div class="slds-col--padded tws_incomingUsedTrackLargeColumn tws_borderLeft tws_borderRight tws_borderBottom">'
                  +         TWSDetail_Formatting.formatCurrencyValue(incomingUsedTruckInfo.totalDTNAOARequired)
                  +       '</div>'
                  +     '</div>'
                  +   '</div>'
                  +   '<div class="slds-col--padded tws_incomingUsedTruckRow">'
                  +     '<div class="slds-grid slds-wrap slds-grid--pull-padded">'
                  +       '<div class="slds-col--padded tws_incomingUsedTrackSmallColumn">'
                  +         '&nbsp;'
                  +       '</div>'
                  +       '<div class="slds-col--padded tws_incomingUsedTrackLargeColumn">'
                  +         '&nbsp;'
                  +       '</div>'
                  +       '<div class="slds-col--padded tws_incomingUsedTrackSmallColumn">'
                  +         '&nbsp;'
                  +       '</div>'
                  +       '<div class="slds-col--padded tws_incomingUsedTrackSummaryColumn">'
                  +         'Mileage'
                  +       '</div>'
                  +       '<div class="slds-col--padded tws_incomingUsedTrackLargeColumn tws_borderBottom">'
                  +         incomingUsedTruckInfo.mileage
                  +       '</div>'
                  +       '<div class="slds-col--padded tws_incomingUsedTrackSummaryColumn">'
                  +         'Total Count of New'
                  +       '</div>'
                  +       '<div class="slds-col--padded tws_incomingUsedTrackLargeColumn tws_borderLeft tws_borderRight tws_borderBottom">'
                  +         TWSDetail_Formatting.getProperty(incomingUsedTruckInfo, 'totalCountOfNew')
                  +       '</div>'
                  +     '</div>'
                  +   '</div>'
                  +   '<div class="slds-col--padded tws_incomingUsedTruckRow">'
                  +     '<div class="slds-grid slds-wrap slds-grid--pull-padded">'
                  +       '<div class="slds-col--padded tws_incomingUsedTrackSmallColumn">'
                  +         '&nbsp;'
                  +       '</div>'
                  +       '<div class="slds-col--padded tws_incomingUsedTrackLargeColumn">'
                  +         '&nbsp;'
                  +       '</div>'
                  +       '<div class="slds-col--padded tws_incomingUsedTrackSmallColumn">'
                  +         '&nbsp;'
                  +       '</div>'
                  +       '<div class="slds-col--padded tws_incomingUsedTrackSummaryColumn">'
                  +         'Rollout'
                  +       '</div>'
                  +       '<div class="slds-col--padded tws_incomingUsedTrackLargeColumn tws_borderBottom">'
                  +         TWSDetail_Formatting.formatCurrencyValue(incomingUsedTruckInfo.rollout, 0)
                  +       '</div>'
                  +       '<div class="slds-col--padded tws_incomingUsedTrackSummaryColumn">'
                  +         'O/A Required Per New'
                  +       '</div>'
                  +       '<div class="slds-col--padded tws_incomingUsedTrackLargeColumn tws_borderLeft tws_borderRight tws_borderBottom">'
                  +         TWSDetail_Formatting.formatCurrencyValue(incomingUsedTruckInfo.oaRequiredPerNew, 0)
                  +       '</div>'
                  +     '</div>'
                  +   '</div>'
                  +   '<div class="slds-col--padded tws_incomingUsedTruckRow">'
                  +     '<div class="slds-grid slds-wrap slds-grid--pull-padded">'
                  +       '<div class="slds-col--padded tws_incomingUsedTrackSmallColumn">'
                  +         '&nbsp;'
                  +       '</div>'
                  +       '<div class="slds-col--padded tws_incomingUsedTrackLargeColumn">'
                  +         '&nbsp;'
                  +       '</div>'
                  +       '<div class="slds-col--padded tws_incomingUsedTrackSmallColumn">'
                  +         '&nbsp;'
                  +       '</div>'
                  +       '<div class="slds-col--padded tws_incomingUsedTrackSummaryColumn">'
                  +         'Mileage Penalty'
                  +       '</div>'
                  +       '<div class="slds-col--padded tws_incomingUsedTrackLargeColumn tws_borderBottom">'
                  +         TWSDetail_Formatting.formatCurrencyValue(incomingUsedTruckInfo.mileagePenalty, 4)
                  +       '</div>'
                  +       '<div class="slds-col--padded tws_incomingUsedTrackSummaryColumn">'
                  +         '&nbsp;'
                  +       '</div>'
                  +       '<div class="slds-col--padded tws_incomingUsedTrackLargeColumn">'
                  +         '&nbsp;'
                  +       '</div>'
                  +     '</div>'
                  +   '</div>'

  return summaryRowsHTML;
}

TWSDetail.getIncomingUsedTruckComments = function(incomingUsedTruckInfo){

  var comments = '';

  if (incomingUsedTruckInfo.comments.length > 0){
    var comments = incomingUsedTruckInfo.comments.replace(/\n/g, "<br/><br/>");
    //comments = incomingUsedTruckInfo.comments;
  }

  return comments;
}
*/

TWSDetail.populateFooters = function(twsDetail){

  for (var i=0; i< twsDetail.footerList.length; i++){

    var footer = twsDetail.footerList[i];

    if (footer.type == 'Generic'){
      TWSDetail.populateGenericFooter(footer);
    }
    else if (footer.type == 'Raw Material Surcharge'){
      TWSDetail.populateRMSFooter(footer);
    }
    else if (footer.type == 'Price Evolution'){
      TWSDetail.populatePriceEvolutionFooter(footer);
    }
    else if (footer.type == 'Approvals'){
      TWSDetail.populateApprovalsFooter(footer);
    }
    else if (footer.type == 'Major Component and Surcharge Clauses'){
      TWSDetail.populateMajorComponentFooter(footer);
    }
    else if (footer.type == 'Comparison to OP'){
      TWSDetail.populateComparisonToOPFooter(footer);
    }
  }
}

TWSDetail.populateGenericFooter = function(footer){

  var footerHTML =  '<div class="slds-col--padded slds-size--1-of-1 tws_borderTop slds-m-top--medium">'
                 +    '<div class="tws_footerTitle">'
                 +      TWSDetail_Formatting.getProperty(footer, 'title')
                 +    '</div>'
                 +    '<div class="tws_footerBody">'
                 +      TWSDetail_Formatting.getProperty(footer, 'body')
                 +    '</div>'
                 +  '</div>';

  $('#tws_footerContainer').append(footerHTML);
}

TWSDetail.populateRMSFooter = function(footer){

  var footerHTML =  '<div class="slds-col--padded slds-size--1-of-1 tws_borderTop slds-m-top--medium">'
                 +    '<div class="tws_footerTitle tws_rmsFooterTitle">'
                 +       TWSDetail_Formatting.getProperty(footer, 'title')
                 +    '</div>'
                 +    '<div class="tws_footerHeaderLabel">'
                 +      'RMS Base Period'
                 +      '<span class="slds-text-align--center tws_footerHeaderValue">'
                 +        TWSDetail_Formatting.getProperty(footer, 'rmsBasePeriod')
                 +      '</span>'
                 +    '</div>'
                 +    '<div class="tws_footerHeaderLabel">'
                 +      'RMS Effective Date'
                 +      '<span class="slds-text-align--center tws_footerHeaderValue">'
                 +        TWSDetail_Formatting.getProperty(footer, 'rmsEffectiveDate')
                 +      '</span>'
                 +    '</div>'
                 +    '<div class="tws_footerBody">'
                 +      TWSDetail_Formatting.getProperty(footer, 'body')
                 +    '</div>'
                 +  '</div>';

  $('#tws_footerContainer').append(footerHTML);
}

TWSDetail.populateMajorComponentFooter = function(footer){

  var footerHTML =  '<div class="slds-col--padded slds-size--1-of-1 tws_borderTop slds-m-top--medium">'
                 +    '<div class="tws_footerTitle tws_rmsFooterTitle">'
                 +       TWSDetail_Formatting.getProperty(footer, 'title')
                 +    '</div>'
                 +    '<div class="tws_footerHeaderLabel">'
                 +      'RMS Effective Date'
                 +      '<span class="slds-text-align--center tws_footerHeaderValue">'
                 +        TWSDetail_Formatting.getProperty(footer, 'rmsEffectiveDate')
                 +      '</span>'
                 +    '</div>'
                 +    '<div class="tws_footerBody">'
                 +      TWSDetail_Formatting.getProperty(footer, 'body')
                 +    '</div>'
                 +  '</div>';

  $('#tws_footerContainer').append(footerHTML);
}

TWSDetail.populatePriceEvolutionFooter = function(footer){

  var footerHTML =  '<div class="slds-col--padded slds-size--1-of-1 tws_borderTop slds-m-top--medium">'
                 +    '<div class="tws_footerTitle">'
                 +       TWSDetail_Formatting.getProperty(footer, 'title')
                 +    '</div>'
                 +    '<div class="tws_priceEvolutionData">'
                 +      TWSDetail.populatePriceEvolutionFooterColumns(footer)
                 +    '</div>'
                 +  '</div>';

  $('#tws_footerContainer').append(footerHTML);
}

TWSDetail.populatePriceEvolutionFooterColumns = function(footer){

  var columnsHTML = '';

  var rowCount = 0;

  for (var i=0; i< footer.lineItemKeySet.length; i++){

    if (footer.lineItemKeySet[i].length > rowCount){
      rowCount = footer.lineItemKeySet[i].length;
    }
  }

  var column1Labels = footer.lineItemKeySet[1];
  var column2Labels = footer.lineItemKeySet[2];
  var targetValueMap = footer.valuesPerType['Target'];
  var customerValueMap = footer.valuesPerType['Customer'];

  columnsHTML = '<table class="tws_priceEvolutionColumn">'
              +   '<tr>'
              +     '<td></td>'
              +     '<td class="tws_priceEvolutionColumnHeader">Target</td>'
              +     '<td class="tws_priceEvolutionColumnHeader">Customer</td>'
              +   '</tr>'

  //column 1
  if (column1Labels){
    for (var i=0; i<column1Labels.length; i++){

      var label = column1Labels[i];

      columnsHTML +=  '<tr>'
                   +    '<td class="tws_priceEvolutionColumnLabel">'+label+'</td>'
                   +    '<td class="tws_priceEvolutionColumnValue">'+TWSDetail_Formatting.formatCurrencyValue(targetValueMap[label])+'</td>'
                   +    '<td class="tws_priceEvolutionColumnValue">'+TWSDetail_Formatting.formatCurrencyValue(customerValueMap[label])+'</td>'
                   +  '</tr>'
    }
  }

  columnsHTML +=    '<tr>'
               +      '<td class="tws_priceEvolutionColumnSubTotalLabel">Total</td>'
               +      '<td class="tws_priceEvolutionColumnSubTotalValue">'+TWSDetail_Formatting.formatCurrencyValue(footer.peSubTotalTarget1)+'</td>'
               +      '<td class="tws_priceEvolutionColumnSubTotalValue">'+TWSDetail_Formatting.formatCurrencyValue(footer.peSubTotalCustomer1)+'</td>'
               +    '</tr>'
               +  '</table>';

  columnsHTML += '<table class="tws_priceEvolutionColumn">'
              +   '<tr>'
              +     '<td></td>'
              +     '<td class="tws_priceEvolutionColumnHeader">Target</td>'
              +     '<td class="tws_priceEvolutionColumnHeader">Customer</td>'
              +   '</tr>'

  //column 2
  if (column2Labels){
    for (var i=0; i<column2Labels.length; i++){

      var label = column2Labels[i];

      columnsHTML +=  '<tr>'
                   +    '<td class="tws_priceEvolutionColumnLabel">'+label+'</td>'
                   +    '<td class="tws_priceEvolutionColumnValue">'+TWSDetail_Formatting.formatCurrencyValue(targetValueMap[label])+'</td>'
                   +    '<td class="tws_priceEvolutionColumnValue">'+TWSDetail_Formatting.formatCurrencyValue(customerValueMap[label])+'</td>'
                   +  '</tr>'
    }
  }

  columnsHTML +=    '<tr>'
               +      '<td class="tws_priceEvolutionColumnSubTotalLabel">Total</td>'
               +      '<td class="tws_priceEvolutionColumnSubTotalValue">'+TWSDetail_Formatting.formatCurrencyValue(footer.peSubTotalTarget2)+'</td>'
               +      '<td class="tws_priceEvolutionColumnSubTotalValue">'+TWSDetail_Formatting.formatCurrencyValue(footer.peSubTotalCustomer2)+'</td>'
               +    '</tr>'
               +  '</table>';


  //totals
  columnsHTML +=  '<table class="tws_priceEvolutionColumn">'
               +    '<tr>'
               +      '<td class="tws_priceEvolutionTotalLabel">Target Total</td>'
               +      '<td class="tws_priceEvolutionTotalValue">'+TWSDetail_Formatting.formatCurrencyValue(footer.peTotalTarget)+'</td>'
               +    '</tr>'
               +    '<tr>'
               +      '<td class="tws_priceEvolutionTotalLabel">Customer Total</td>'
               +      '<td class="tws_priceEvolutionTotalValue">'+TWSDetail_Formatting.formatCurrencyValue(footer.peTotalCustomer)+'</td>'
               +    '</tr>'
               +    '<tr>'
               +      '<td class="tws_priceEvolutionRatioLabel">Ratio</td>'
               +      '<td class="tws_priceEvolutionRatioValue">'+TWSDetail_Formatting.formatPercentValue(footer.peRatio)+'</td>'
               +    '</tr>'
               +  '</table>';

  return columnsHTML;
}

TWSDetail.populateApprovalsFooter = function(footer){

  var footerHTML =  '<div class="slds-col--padded slds-size--1-of-1 tws_borderTop slds-m-top--medium">'
                 +    '<div class="tws_footerTitle">'
                 +       TWSDetail_Formatting.getProperty(footer, 'title')
                 +    '</div>'
                 +    '<div class="tws_approvalsData">'
                 +      TWSDetail.populateApprovalsColumns(footer)
                 +    '</div>'
                 +  '</div>';

  $('#tws_footerContainer').append(footerHTML);
}

TWSDetail.populateApprovalsColumns = function(footer){

  var labels = footer.lineItemKeySet[0];
  var valueMap = footer.valuesPerType['default'];

  columnsHTML = '<div class="tws_approvalsColumn">'

  for (var i=0; labels && i<labels.length; i++){

    var label = labels[i];

    columnsHTML +=  '<div style="width:500px;float:left;margin: 30px;">'
                +     '<div style="width:500px;border-bottom:1px solid #10274a;">'
                +       '&nbsp;'
                +     '</div>'
                +     '<div style="width:250px;float:left;">'
                +       label
                +     '</div>'
                +     '<div style="width:250px;float:left;text-align:right">'
                +       'date'
                +     '</div>'
                +   '</div>'
  }

  columnsHTML +=  '</div>';

  return columnsHTML;
}

TWSDetail.populateComparisonToOPFooter = function(footer){

  var footerHTML =  '<div class="slds-col--padded slds-size--1-of-1 tws_borderTop slds-m-top--medium">'
                 +    '<div class="tws_footerTitle">'
                 +       TWSDetail_Formatting.getProperty(footer, 'title')
                 +    '</div>'
                 +    '<div class="tws_priceEvolutionData">'
                 +      TWSDetail.populateComparisonToOpTable(footer)
                 +    '</div>'
                 +  '</div>';

  $('#tws_footerContainer').append(footerHTML);
}

TWSDetail.populateComparisonToOpTable = function(footer){

  var columnsHTML = '';

  var rowCount = 0;

  for (var i=0; i< footer.lineItemKeySet.length; i++){

    if (footer.lineItemKeySet[i].length > rowCount){
      rowCount = footer.lineItemKeySet[i].length;
    }
  }

  var tableLabels = footer.lineItemKeySet[1];
  var netPriceIncreaseValueMap = footer.valuesPerType['Net Price Increase'];
  var dealVolumeValueMap = footer.valuesPerType['Deal Volume'];

  columnsHTML = '<table class="tws_comparisonTOOpColumn">'
              +   '<tr>'
              +     '<td></td>'
              +     '<td class="tws_priceEvolutionColumnHeader">Net Price Increase</td>'
              +     '<td class="tws_priceEvolutionColumnHeader">Deal Volume</td>'
              +   '</tr>'

  if (tableLabels){
    for (var i=0; i<tableLabels.length; i++){

      var label = tableLabels[i];

      columnsHTML +=  '<tr>'
                   +    '<td class="tws_priceEvolutionColumnLabel">'+label+'</td>'
                   +    '<td class="tws_priceEvolutionColumnValue">'+TWSDetail_Formatting.formatCurrencyValue(netPriceIncreaseValueMap[label])+'</td>'
                   +    '<td class="tws_priceEvolutionColumnValue">'+TWSDetail_Formatting.formatCurrencyValue(dealVolumeValueMap[label])+'</td>'
                   +  '</tr>'
    }
  }

  return columnsHTML;
}

TWSDetail.adjustColumnsHeight = function(){

  if (TWSDetail.dealType == 'Canadian'){
    $('.tws_canadaSpecific').show();
  }
  else if(TWSDetail.dealType == 'Domestic'){
    $('.tws_domesticSpecific').show();
  }
  else if(TWSDetail.dealType == 'National'){
    $('.tws_nationalSpecific').show();
  }
  else if(TWSDetail.dealType == 'International'){
    $('.tws_internationalSpecific').show();
    $('#tws_priceWalkContainer').hide();
    $('#tws_OutgoingResInfoContainer').hide();
  }
  else if(TWSDetail.dealType == 'Sales Proposal'){
    $('.tws_domesticSalesProposalSpecific').show();
  }

  columnsPerRow = {};

  //$.each( $(".tws_menuRow"), function( key, value ) {
  $(".tws_heightToAdjust").each(function( key, value ) {
    var elem = $(value);
    rowNumber = elem.data("name");
    height = elem.height();

    if (columnsPerRow[rowNumber]){
      if (height > columnsPerRow[rowNumber]) {
        columnsPerRow[rowNumber] = height;
      }
    }
    else{
      columnsPerRow[rowNumber] = height;
    }
  });

  $.each( $(".tws_heightToAdjust"), function( key, value ) {

    rowNumber = $(value).data("name");
    height = columnsPerRow[rowNumber];

    $(value).height(height) ;

  });
}
