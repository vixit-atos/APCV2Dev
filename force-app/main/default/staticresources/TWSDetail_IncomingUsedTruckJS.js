var TWSIncomingUsedTruck = {};

TWSIncomingUsedTruck.populateIncomingUsedTruckInfo = function(dealType, data){

  if(data.incomingUsedTruckList.length >0){

    for (var i=0; i< data.incomingUsedTruckList.length; i++){

      var usedTruckInfo = data.incomingUsedTruckList[i];

      TWSIncomingUsedTruck.populateIncomingUsedTruckTable(usedTruckInfo);
    }
  }
  else{
    TWSIncomingUsedTruck.populateIncomingUsedTruckInfoEmptyTables(dealType);
  }
}

TWSIncomingUsedTruck.populateIncomingUsedTruckTable = function(usedTruckInfo){

  var type = 'Current';
  if (usedTruckInfo.previousDeal){
    type = 'Previous';
  }

  var incomingUsedTruckHTML = '';

  incomingUsedTruckHTML += '<div class="slds-grid slds-wrap slds-grid--pull-padded">'
                         +   '<div class="tws_incomingUsedTruckInfoTitle slds-col--padded slds-size--1-of-1 slds-text-body--regular slds-m-top--xx-small tws_borderBottom">'
                         +     'Incoming Used Truck Information '
                         +     '<span style="display:none" class="tws_canadaSpecific">'
                         +       '(<span class="tws_canadianNote">NOTE: ALL USED TRUCK VALUES ARE IN CANADIAN DOLLARS</span>)'
                         +     '</span>'
                         +   '</div>'
                         +   '<div class="slds-col--padded slds-size--1-of-1 slds-scrollable--x">'
                         +     '<div class="slds-grid slds-wrap slds-grid--pull-padded" style="width:1390px">'
                         +       '<div class="slds-col--padded" style="width:1390px">'
                         +         '<div class="slds-grid slds-wrap slds-grid--pull-padded">'
                         +           '<div class="slds-col--padded tws_strongText" style="width:200px">'
                         +             type+' Deal Summary'
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
                         +          TWSIncomingUsedTruck.getIncomingUsedTruckTable(usedTruckInfo)
                         +       '</div>'
                         +     '</div>'
                         +   '</div>'
                         +   '<div class="slds-col--padded slds-size--1-of-1 tws_incomingUsedTruckCommentsContainer">'
                         +     '<div class="tws_incomingUsedTruckCommentsTitle">'
                         +       type+' Deal Comments'
                         +     '</div>'
                         +     '<div class="tws_incomingUsedTruckCommentsValue">'
                         +       TWSIncomingUsedTruck.getIncomingUsedTruckComments(usedTruckInfo)
                         +     '</div>'
                         +   '</div>'
                         + '</div>'


  $('#tws_incomingUsedTruckInfoContainer').append(incomingUsedTruckHTML);
}

TWSIncomingUsedTruck.getIncomingUsedTruckTable = function(usedTruckInfo){

  var incomingUsedTruckTableHTML = '';

  incomingUsedTruckTableHTML += '<table class="tws_incomingUsedTruckTable">'
                              +   '<tr class="tws_borderBottomStrong tws_borderTopStrong tws_incomingUsedTruckLabel">'
                              +      '<th>'
                              +         'Agreement Number'
                              +      '</th>'
                              +      '<th>'
                              +         'QTY'
                              +      '</th>'
                              +      '<th>'
                              +         'Year/Make'
                              +      '</th>'
                              +      '<th>'
                              +         'Model / Sleeper / Engine'
                              +      '</th>'
                              +      '<th>'
                              +         'Mileage Band'
                              +      '</th>'
                              +      '<th>'
                              +         'Quarter Turn In'
                              +      '</th>'
                              +      '<th>'
                              +         'Show Dollars'
                              +      '</th>'
                              +      '<th>'
                              +         'Hard Dollars'
                              +      '</th>'
                              +      '<th>'
                              +         'Per Unit OA'
                              +      '</th>'
                              +      '<th>'
                              +         'Total DTNA OA Required'
                              +      '</th>'
                              +   '</tr>'
                              +   TWSIncomingUsedTruck.getIncomingUsedTruckRows(usedTruckInfo)
                              +   TWSIncomingUsedTruck.getIncomingUsedTruckSummaryRows(usedTruckInfo)
                              + '</table>'

  return incomingUsedTruckTableHTML;
}

TWSIncomingUsedTruck.getIncomingUsedTruckRows = function(usedTruckInfo){

  var incomingUsedTruckRowHTML = ''
  if (usedTruckInfo.incomingUsedTruckItems.length > 0){

    for (var i=0; i<usedTruckInfo.incomingUsedTruckItems.length; i++){

        var incomingUsedTruckItem = usedTruckInfo.incomingUsedTruckItems[i];

        incomingUsedTruckRowHTML+=  '<tr class="tws_borderBottom">'
                                +       '<td>'
                                +         TWSDetail_Formatting.getProperty(incomingUsedTruckItem, 'agreementNumber')
                                +       '</td>'
                                +       '<td>'
                                +         incomingUsedTruckItem.qty
                                +       '</td>'
                                +       '<td >'
                                +         TWSDetail_Formatting.getProperty(incomingUsedTruckItem, 'yearMake')
                                +       '</td>'
                                +       '<td >'
                                +         TWSDetail_Formatting.getProperty(incomingUsedTruckItem, 'modelSleeperEngine')
                                +       '</td>'
                                +       '<td >'
                                +         TWSDetail_Formatting.getProperty(incomingUsedTruckItem, 'mileageBand')
                                +       '</td>'
                                +       '<td >'
                                +         TWSDetail_Formatting.getProperty(incomingUsedTruckItem, 'quarterTurnIn')
                                +       '</td>'
                                +       '<td class="tws_domesticSalesProposalSpecific tws_domesticSpecific tws_nationalSpecific tws_internationalSpecific">'
                                +         TWSDetail_Formatting.formatCurrencyValue(incomingUsedTruckItem.showDollars)
                                +       '</td>'
                                +       '<td class="tws_canadaSpecific">'
                                +         TWSDetail_Formatting.formatCurrencyValue(incomingUsedTruckItem.showDollarsCAD)
                                +       '</td>'
                                +       '<td class="tws_domesticSalesProposalSpecific tws_domesticSpecific tws_nationalSpecific tws_internationalSpecific">'
                                +         TWSDetail_Formatting.formatCurrencyValue(incomingUsedTruckItem.hardDollars)
                                +       '</td>'
                                +       '<td class="tws_canadaSpecific">'
                                +         TWSDetail_Formatting.formatCurrencyValue(incomingUsedTruckItem.hardDollarsCAD)
                                +       '</td>'
                                +       '<td>'
                                +         TWSDetail_Formatting.formatCurrencyValue(incomingUsedTruckItem.perUnitOA)
                                +       '</td>'
                                +       '<td>'
                                +         TWSDetail_Formatting.formatCurrencyValue(incomingUsedTruckItem.totalDTNAOARequired)
                                +       '</td>'
                                +   '</tr>'
    }
  }

  return incomingUsedTruckRowHTML;
}

TWSIncomingUsedTruck.getIncomingUsedTruckSummaryRows = function(incomingUsedTruckInfo){

  var summaryRowsHTML = '';

  if (incomingUsedTruckInfo){
    summaryRowsHTML +=  '<tr class="tws_incomingTruckSummaryRow">'
                     +    '<td colspan="7">'
                     +    '</td>'
                     +    '<td colspan="2" style="text-align:right;padding-right: 15px;">'
                     +      'Total DTNA OA Required'
                     +    '</td>'
                     +    '<td style="text-align:center;" class="tws_borderBottom">'
                     +      TWSDetail_Formatting.formatCurrencyValue(incomingUsedTruckInfo.totalDTNAOARequired)
                     +    '</td>'
                     +  '</tr>'
                     +  '<tr class="tws_incomingTruckSummaryRow">'
                     +    '<td colspan="5">'
                     +    '</td>'
                     +    '<td>'
                     +      'Mileage'
                     +    '</td>'
                     +    '<td style="text-align:center;" class="tws_borderBottom">'
                     +      incomingUsedTruckInfo.mileage
                     +    '</td>'
                     +    '<td colspan="2" style="text-align:right;padding-right: 15px;">'
                     +      'Total Count of New'
                     +    '</td>'
                     +    '<td style="text-align:center;" class="tws_borderBottom">'
                     +      TWSDetail_Formatting.getProperty(incomingUsedTruckInfo, 'totalCountOfNew')
                     +    '</td>'
                     +  '</tr>'
                     +  '<tr class="tws_incomingTruckSummaryRow">'
                     +    '<td colspan="5">'
                     +    '</td>'
                     +    '<td>'
                     +      'Rollout'
                     +    '</td>'
                     +    '<td style="text-align:center;" class="tws_borderBottom tws_domesticSalesProposalSpecific tws_domesticSpecific tws_nationalSpecific tws_internationalSpecific">'
                     +      TWSDetail_Formatting.formatCurrencyValue(incomingUsedTruckInfo.rollout, 0)
                     +    '</td>'
                     +    '<td style="text-align:center;" class="tws_borderBottom tws_canadaSpecific">'
                     +      TWSDetail_Formatting.formatCurrencyValue(incomingUsedTruckInfo.rolloutCAD, 0)
                     +    '</td>'
                     +    '<td colspan="2" style="text-align:right;padding-right: 15px;">'
                     +      'O/A Required Per New'
                     +    '</td>'
                     +    '<td style="text-align:center;" class="tws_borderBottom tws_domesticSalesProposalSpecific tws_domesticSpecific tws_nationalSpecific tws_internationalSpecific">'
                     +      TWSDetail_Formatting.formatCurrencyValue(incomingUsedTruckInfo.oaRequiredPerNew, 0)
                     +    '</td>'
                     +    '<td style="text-align:center;" class="tws_borderBottom tws_canadaSpecific">'
                     +      TWSDetail_Formatting.formatCurrencyValue(incomingUsedTruckInfo.oaRequiredPerNewCAD, 0)
                     +    '</td>'
                     +  '</tr>'
                     +  '<tr class="tws_incomingTruckSummaryRow">'
                     +    '<td colspan="5">'
                     +    '</td>'
                     +    '<td>'
                     +      'Mileage Penalty'
                     +    '</td>'
                     +    '<td style="text-align:center;" class="tws_borderBottom tws_domesticSalesProposalSpecific tws_domesticSpecific tws_nationalSpecific tws_internationalSpecific">'
                     +      TWSDetail_Formatting.formatCurrencyValue(incomingUsedTruckInfo.mileagePenalty, 4)
                     +    '</td>'
                     +    '<td style="text-align:center;" class="tws_borderBottom tws_canadaSpecific">'
                     +      TWSDetail_Formatting.formatCurrencyValue(incomingUsedTruckInfo.mileagePenaltyCAD, 4)
                     +    '</td>'
                     +    '<td colspan="3">'
                     +    '</td>'
                     +  '</tr>'
  }

  return summaryRowsHTML;
}

TWSIncomingUsedTruck.getIncomingUsedTruckComments = function(incomingUsedTruckInfo){

  var comments = '';

  if (incomingUsedTruckInfo.comments.length > 0){
    var comments = incomingUsedTruckInfo.comments.replace(/\n/g, "<br/><br/>");
  }

  return comments;
}

TWSIncomingUsedTruck.populateIncomingUsedTruckInfoEmptyTables = function(dealType){

  var incomingUsedTruckPrevious = {};
  var incomingUsedTruckCurrent = {};

  incomingUsedTruckPrevious.previousDeal = true;
  incomingUsedTruckPrevious.incomingUsedTruckItems = [];

  incomingUsedTruckCurrent.previousDeal = false;
  incomingUsedTruckCurrent.incomingUsedTruckItems = [];

  for(var i=0; i < 5; i++){

    var incomingUsedTruckItem = {}

    incomingUsedTruckPrevious.incomingUsedTruckItems.push(incomingUsedTruckItem);
    incomingUsedTruckCurrent.incomingUsedTruckItems.push(incomingUsedTruckItem);
  }

  console.log(incomingUsedTruckPrevious);

  //TWSIncomingUsedTruck.populateIncomingUsedTruckTable(IncomingUsedTruckPrevious);
  //TWSIncomingUsedTruck.populateIncomingUsedTruckTable(IncomingUsedTruckCurrent);
}
