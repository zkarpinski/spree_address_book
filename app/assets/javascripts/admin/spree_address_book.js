//= require store/spree_core

var admin_edit_cust_details_reg = /\/admin\/orders\/([^\/]+)\/customer/

// Only poll if we're on the right page
if (admin_edit_cust_details_reg.test(window.location.pathname))
{
  $(window).focus(function() { previousVal = ""; });
  var previousVal;
  var pollInterval = setInterval(function() {

      var val = $('#order_email').val();

      if (val != '' && val !== previousVal) {
        $('#address-loader').load('/admin/addresses/search', {'q': $("#order_email").val() }).fadeIn(1000); 
      }

      previousVal = val;

  }, 2000);

  function expand_address_loader() {
    $('#order_tab_summary').slideUp(1000);
    $('aside nav.menu').slideUp(1000);
    $('#address-loader').css('max-height', '2000px');
    $('#address-loader').css('height', 'auto');
    return false;
  }
}

