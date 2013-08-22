//= require store/spree_core

var previousVal;
var pollInterval = setInterval(function() {

    var val = $('#order_email').val();

    if (val != '' && val !== previousVal) {
      $('#address-loader').load('/addresses/search', {'q': $("#order_email").val() }).fadeIn(1000); 
    }

    previousVal = val;

}, 2000);
