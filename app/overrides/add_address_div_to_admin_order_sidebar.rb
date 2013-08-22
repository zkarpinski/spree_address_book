Deface::Override.new(
  :virtual_path => "spree/layouts/admin",
  :name => "add_address_div_to_admin_order_sidebar",
  :insert_bottom => "aside#sidebar",
  :text => "<div id='address-loader'></div>",
  :disabled => false
)


