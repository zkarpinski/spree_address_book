Spree::Address.class_eval do
  belongs_to :user, :class_name => Spree.user_class.to_s

  attr_accessible :user_id, :deleted_at


  def self.required_fields
    validator = Spree::Address.validators.find{|v| v.kind_of?(ActiveModel::Validations::PresenceValidator)}
    validator.attributes.push(:phone)
    validator ? validator.attributes : []
  end

  # TODO: look into if this is actually needed. I don't want to override methods unless it is really needed
  # can modify an address if it's not been used in an order
  def same_as?(other)
    return false if other.nil?
    attributes.except('id', 'updated_at', 'created_at', 'user_id') == other.attributes.except('id', 'updated_at', 'created_at', 'user_id')
  end

  # can modify an address if it's not been used in an completed order
  def editable?
    new_record? || (shipments.empty? && Spree::Order.complete.where("bill_address_id = ? OR ship_address_id = ?", self.id, self.id).count == 0)
  end

  def can_be_deleted?
    shipments.empty? && Spree::Order.where("bill_address_id = ? OR ship_address_id = ?", self.id, self.id).count == 0
  end

  def to_s
    [
      "#{firstname} #{lastname}",
      "#{address1}",
      "#{address2}",
      "#{city}, #{state.abbr || state_name} #{zipcode}",
      "#{country.iso3}"
    ].reject(&:empty?).join("<br/>").html_safe
  end

  def to_select
    to_s.gsub(/<br\/>/, " ")
  end

  # UPGRADE_CHECK if future versions of spree have a custom destroy function, this will break
  def destroy
    if can_be_deleted?
      super
    else
      update_column :deleted_at, Time.now
    end
  end

  def self.find_by_order_email(email)
    addresses = Array.new
    picked = Hash.new

    find_by_sql(["select a.* from spree_addresses a, spree_orders o where a.deleted_at is null and (a.id = o.ship_address_id or a.id = o.bill_address_id) and o.email = ?", email]).each do |a|
      unless picked[a.to_s]
        addresses.push(a)
        picked[a.to_s] = true
      end
    end

    return addresses
  end
end
