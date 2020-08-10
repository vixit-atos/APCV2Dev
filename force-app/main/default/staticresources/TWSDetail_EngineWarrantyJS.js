var TWSEngineWarranty= {};

TWSEngineWarranty.populateEngineWarrantyInfo = function(dealType, data){

  if (data){

    switch(dealType) {

      case 'National':
        TWSEngineWarranty.populateEngineWarrantyTable(data, TWSEngineWarranty.populateNationalEngineWarrantyRow, TWSEngineWarranty.populateNationalEngineWarrantyHeaders);
        break;
      case 'International':
        break;
      case 'Canadian':
        TWSEngineWarranty.populateEngineWarrantyTable(data, TWSEngineWarranty.populateCanadianEngineWarrantyRow, TWSEngineWarranty.populateCanadianEngineWarrantyHeaders);
        break;
      case 'Domestic':
        TWSEngineWarranty.populateEngineWarrantyTable(data, TWSEngineWarranty.populateDomesticEngineWarrantyRow, TWSEngineWarranty.populateDomesticEngineWarrantyHeaders);
        break;
      case 'Sales Proposal':
        TWSEngineWarranty.populateEngineWarrantyTable(data, TWSEngineWarranty.populateSalesProposalEngineWarrantyRow, TWSEngineWarranty.populateSalesProposalEngineWarrantyHeaders);
        break;
    }
  }
}

TWSEngineWarranty.populateEngineWarrantyTable = function(data, dealSpecificFunction, dealSpecificHeaderFunction){

  dealSpecificHeaderFunction();

  $('#tws_engineWarrantyQuoteNumberValue').text(data.engineWarrantyQuoteNumber);

  for (var i=0; i<data.engineWarrantyList.length; i++){

    dealSpecificFunction(data.engineWarrantyList[i]);
  }

  var engineExtendedWarrantyComments = data.engineExtendedWarrantyComments.replace(/\n/g, "<br/><br/>");
  $('#tws_engineWarrantyCommentsValue').html(engineExtendedWarrantyComments);

}

TWSEngineWarranty.populateNationalEngineWarrantyRow = function(engineWrranty){

  var engineWarrantyRowHTML ='';

  if (engineWrranty != undefined && engineWrranty.id != undefined){

    engineWarrantyRowHTML += '<tr class="tws_borderBottom">'
                          +     '<td>'
                          +         TWSDetail_Formatting.getProperty(engineWrranty, 'quoteNumber')
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.getProperty(engineWrranty, 'coverageDescription')
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.getProperty(engineWrranty, 'timeMileage')
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.formatCurrencyValue(engineWrranty.deduct, 0)
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.getProperty(engineWrranty, 'highwayOrVocation')
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.getProperty(engineWrranty, 'highTorque')
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.formatCurrencyValue(engineWrranty.fmvDeferredRevenue, 0)
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.formatCurrencyValue(engineWrranty.ewCost, 0)
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.formatCurrencyValue(engineWrranty.csdEwMargin, 0)
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.getProperty(engineWrranty, 'pCodeValue')
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.formatCurrencyValue(engineWrranty.xFerCostAdj, 0)
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.formatCurrencyValue(engineWrranty.netImpact, 0)
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.formatCurrencyValue(engineWrranty.dtnaMargin, 0)
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.formatCurrencyValue(engineWrranty.customerPrice, 0)
                          +     '</td>'
                          +     '<td>'
                          +         engineWrranty.pricingProposalName
                          +     '</td>'
                          +  '</tr>'
  }

  $('#tws_engineWarrantyTable').append(engineWarrantyRowHTML);
}

TWSEngineWarranty.populateCanadianEngineWarrantyRow = function(engineWrranty){

  var engineWarrantyRowHTML ='';

  if (engineWrranty != undefined && engineWrranty.id != undefined){

    engineWarrantyRowHTML += '<tr class="tws_borderBottom">'
                          +     '<td>'
                          +         TWSDetail_Formatting.getProperty(engineWrranty, 'quoteNumber')
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.getProperty(engineWrranty, 'coverageDescription')
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.getProperty(engineWrranty, 'timeMileage')
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.formatCurrencyValue(engineWrranty.deductCAD, 0)
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.getProperty(engineWrranty, 'highwayOrVocation')
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.getProperty(engineWrranty, 'highTorque')
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.formatCurrencyValue(engineWrranty.fmvDeferredRevenueCAD, 0)
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.formatCurrencyValue(engineWrranty.ewCostCAD, 0)
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.formatCurrencyValue(engineWrranty.csdEwMarginCAD, 0)
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.getProperty(engineWrranty, 'pCodeValueCAD')
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.formatCurrencyValue(engineWrranty.xFerCostAdjCAD, 0)
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.formatCurrencyValue(engineWrranty.netImpactCAD, 0)
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.formatCurrencyValue(engineWrranty.dtnaMarginCAD, 0)
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.formatCurrencyValue(engineWrranty.customerPriceCAD, 0)
                          +     '</td>'
                          +     '<td>'
                          +         engineWrranty.pricingProposalName
                          +     '</td>'
                          +  '</tr>'
  }

  $('#tws_engineWarrantyTable').append(engineWarrantyRowHTML);
}

TWSEngineWarranty.populateDomesticEngineWarrantyRow = function(engineWrranty){

  var engineWarrantyRowHTML ='';

  if (engineWrranty != undefined && engineWrranty.id != undefined){

    engineWarrantyRowHTML += '<tr class="tws_borderBottom">'
                          +     '<td>'
                          +         TWSDetail_Formatting.getProperty(engineWrranty, 'quoteNumber')
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.getProperty(engineWrranty, 'coverageDescription')
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.getProperty(engineWrranty, 'timeMileage')
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.formatCurrencyValue(engineWrranty.deduct, 0)
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.getProperty(engineWrranty, 'highwayOrVocation')
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.getProperty(engineWrranty, 'highTorque')
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.formatCurrencyValue(engineWrranty.fmvDeferredRevenue, 0)
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.formatCurrencyValue(engineWrranty.ewCost, 0)
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.formatCurrencyValue(engineWrranty.csdEwMargin, 0)
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.getProperty(engineWrranty, 'pCodeValue')
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.formatCurrencyValue(engineWrranty.xFerCostAdj, 0)
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.formatCurrencyValue(engineWrranty.netImpact, 0)
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.formatCurrencyValue(engineWrranty.dtnaMargin, 0)
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.formatCurrencyValue(engineWrranty.customerPrice, 0)
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.getProperty(engineWrranty, 'engine')
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.getProperty(engineWrranty, 'spp')
                          +     '</td>'
                          +     '<td>'
                          +         engineWrranty.pricingProposalName
                          +     '</td>'
                          +  '</tr>'
  }

  $('#tws_engineWarrantyTable').append(engineWarrantyRowHTML);
}

TWSEngineWarranty.populateSalesProposalEngineWarrantyRow = function(engineWrranty){

  var engineWarrantyRowHTML ='';

  if (engineWrranty != undefined && engineWrranty.id != undefined){

    engineWarrantyRowHTML += '<tr class="tws_borderBottom">'
                          +     '<td>'
                          +         TWSDetail_Formatting.getProperty(engineWrranty, 'quoteNumber')
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.getProperty(engineWrranty, 'coverageDescription')
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.getProperty(engineWrranty, 'timeMileage')
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.formatCurrencyValue(engineWrranty.deduct, 0)
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.getProperty(engineWrranty, 'highwayOrVocation')
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.getProperty(engineWrranty, 'highTorque')
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.formatCurrencyValue(engineWrranty.fmvDeferredRevenue, 0)
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.formatCurrencyValue(engineWrranty.ewCost, 0)
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.formatCurrencyValue(engineWrranty.csdEwMargin, 0)
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.getProperty(engineWrranty, 'pCodeValue')
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.formatCurrencyValue(engineWrranty.xFerCostAdj, 0)
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.formatCurrencyValue(engineWrranty.netImpact, 0)
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.formatCurrencyValue(engineWrranty.dtnaMargin, 0)
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.formatCurrencyValue(engineWrranty.customerPrice, 0)
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.getProperty(engineWrranty, 'engine')
                          +     '</td>'
                          +     '<td>'
                          +         TWSDetail_Formatting.getProperty(engineWrranty, 'spp')
                          +     '</td>'
                          +     '<td>'
                          +         engineWrranty.pricingProposalName
                          +     '</td>'
                          +  '</tr>'
  }

  $('#tws_engineWarrantyTable').append(engineWarrantyRowHTML);
}

TWSEngineWarranty.populateNationalEngineWarrantyHeaders = function(){

    var engineWarrantyTableHeadersHTML = '';

    engineWarrantyTableHeadersHTML += '<tr class="tws_borderBottomStrong tws_borderTopStrong tws_engineWarrantyLabel">'
                                   +    '<th>'
                                   +      'Databook Code/Quote #'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'Coverage Description'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'Time / Mileage'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'Deduct.'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'Highway or Vocation'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'High Torque'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'FMV - Deferred Revenue'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'EW Cost'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'CSD EW Margin (1-2)'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'P-Code Value'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'X-Fer Cost Adj.'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'Net Impact (4+5)'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'DTNA Margin (3+6)'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'Customer Price (1-4)'
                                   +    '</th>'
                                   +    '<th>'
                                   +      '&nbsp;'
                                   +    '</th>'
                                   +  '</tr>'

   $('#tws_engineWarrantyTable').append(engineWarrantyTableHeadersHTML);
}

TWSEngineWarranty.populateCanadianEngineWarrantyHeaders = function(){

    var engineWarrantyTableHeadersHTML = '';

    engineWarrantyTableHeadersHTML += '<tr class="tws_borderBottomStrong tws_borderTopStrong tws_engineWarrantyLabel">'
                                   +    '<th>'
                                   +      'Databook Code/Quote #'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'Coverage Description'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'Time / Mileage'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'Deduct.'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'Highway or Vocation'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'High Torque'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'FMV - Deferred Revenue'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'EW Cost'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'CSD EW Margin (1-2)'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'P-Code Value'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'X-Fer Cost Adj.'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'Net Impact (4+5)'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'DTNA Margin (3+6)'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'Customer Price (1-4)'
                                   +    '</th>'
                                   +    '<th>'
                                   +      '&nbsp;'
                                   +    '</th>'
                                   +  '</tr>'

   $('#tws_engineWarrantyTable').append(engineWarrantyTableHeadersHTML);
}

TWSEngineWarranty.populateDomesticEngineWarrantyHeaders = function(){

    var engineWarrantyTableHeadersHTML = '';

    engineWarrantyTableHeadersHTML += '<tr class="tws_borderBottomStrong tws_borderTopStrong tws_engineWarrantyLabel">'
                                   +    '<th>'
                                   +      'Databook Code/Quote #'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'Coverage Description'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'Time / Mileage'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'Deduct.'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'Highway or Vocation'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'High Torque'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'FMV - Deferred Revenue'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'EW Cost'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'CSD EW Margin (1-2)'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'P-Code Value'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'X-Fer Cost Adj.'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'Net Impact (4+5)'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'DTNA Margin (3+6)'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'Customer Price (1-4)'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'Engine'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'SPP? Y / N'
                                   +    '</th>'
                                   +    '<th>'
                                   +      '&nbsp;'
                                   +    '</th>'
                                   +  '</tr>'

   $('#tws_engineWarrantyTable').append(engineWarrantyTableHeadersHTML);
}

TWSEngineWarranty.populateSalesProposalEngineWarrantyHeaders = function(){

    var engineWarrantyTableHeadersHTML = '';

    engineWarrantyTableHeadersHTML += '<tr class="tws_borderBottomStrong tws_borderTopStrong tws_engineWarrantyLabel">'
                                   +    '<th>'
                                   +      'Databook Code/Quote #'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'Coverage Description'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'Time / Mileage'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'Deduct.'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'Highway or Vocation'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'High Torque'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'FMV - Deferred Revenue'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'EW Cost'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'CSD EW Margin (1-2)'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'P-Code Value'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'X-Fer Cost Adj.'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'Net Impact (4+5)'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'DTNA Margin (3+6)'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'Customer Price (1-4)'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'Engine'
                                   +    '</th>'
                                   +    '<th>'
                                   +      'SPP? Y / N'
                                   +    '</th>'
                                   +    '<th>'
                                   +      '&nbsp;'
                                   +    '</th>'
                                   +  '</tr>'

   $('#tws_engineWarrantyTable').append(engineWarrantyTableHeadersHTML);
}
