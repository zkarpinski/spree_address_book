//$(window).focus(function() { previousVal = ""; previousAddressSearch = ""; });


$(document).ready(function() {
  var admin_edit_cust_details_reg = /\/admin\/orders\/([^\/]+)\/customer/;
  // Only poll if we're on the right page
  if (admin_edit_cust_details_reg.test(window.location.pathname))
  {
    var previousVal = "";
    var email_timerid;

    var address_timerid;
    var previousAddressSearch = "";
    var form = this;

    $('#order_email').keyup(function() {
      clearTimeout(email_timerid);

      email_timerid = setTimeout(function() {
        var val = $('#order_email').val();

        if (val !== "" && val !== previousVal) {
          $('#address-loader').load('/admin/addresses/search', {'q': $("#order_email").val(), 'a': $('#order_address_search').val() }).fadeIn(1000);
          previousVal = val;
        }
      }, 2000);
    });


    $('#address-loader').on('keyup', '#order_address_search', function() {
      clearTimeout(address_timerid);

      address_timerid = setTimeout(function() {
        var addressSearch = $('#order_address_search').val();

        if (addressSearch !== previousAddressSearch) {
          $('#address-loader').load('/admin/addresses/search', {'q': $("#order_email").val(), 'a': $('#order_address_search').val() }).fadeIn(1000);
          previousAddressSearch = addressSearch;
        }
      }, 2000);
    });

    function expand_address_loader() {
      $('#order_tab_summary').slideUp(1000);
      $('aside nav.menu').slideUp(1000);
      $('#address-loader').css('max-height', '2000px');
      $('#address-loader').css('height', 'auto');
      return false;
    }
    if($('#order_email').val() !== "") {
      $('#address-loader').load('/admin/addresses/search', {'q': $("#order_email").val() }).fadeIn(1000);
    }
  }
});


