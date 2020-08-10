var TWSDetail_Formatting = {};

TWSDetail_Formatting.formatCurrencyValue = function(value, decimalPlaces){

  formattedValue = '';

  if (value === undefined || isNaN(value)){
    formattedValue = '&nbsp;';
  }
  else if (value >= 0){
    value = Number(value).toFixed(decimalPlaces);
    formattedValue = '$'+value;
  }
  else{
    value = Number(value).toFixed(decimalPlaces);
    formattedValue = '<span class="tws_redText">$('+(value*-1)+')</span>';
  }

  return formattedValue;
}

TWSDetail_Formatting.formatPercentValue = function(value){

  formattedValue = '';

  if (value === undefined || isNaN(value)){
    formattedValue = '&nbsp;';
  }
  else if (value >= 0){
    formattedValue = value+'%';
  }
  else{
    value = parseFloat(Math.round(value * 100) / 100).toFixed(2);
    formattedValue = '<span class="tws_redText">('+(value*-1)+')%</span>';
  }

  return formattedValue;
}

TWSDetail_Formatting.getRatio = function(a, b){

  if (isNaN(a) || isNaN(b)){
    return '&nbsp;'
  }
  else {
    return a/b;
  }
}

TWSDetail_Formatting.getProperty = function(object, property){

  if (object === undefined || object[property] === undefined || object[property] == ''){
    return '&nbsp;';
  }
  else{
    return object[property];
  }
}
