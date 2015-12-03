Spree.user_class.class_eval do
  has_many :addresses, :conditions => {:deleted_at => nil}, :class_name => 'Spree::Address'

  def address_search(params)
    if params[:a].present?
      search_string = ""
      search_parameters = [id]

      if params[:a].present?
        search_string = "and (concat_ws(' '::text, a.firstname, a.lastname) ilike ? or a.lastname ilike ? or a.address1 ilike ? or a.address2 ilike ? or a.company ilike ? or a.city ilike ? or a.zipcode ilike ?) "
        1.upto(7) do |n|
          search_parameters.push("#{params[:a]}%")
        end
      end

      addresses.find_by_sql(["select a.* from spree_addresses a, spree_users u where u.id = a.user_id and u.id = ? #{search_string}", *search_parameters])
    else
      addresses
    end
  end
end
