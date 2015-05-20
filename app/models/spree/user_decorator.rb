Spree.user_class.class_eval do
  has_many :addresses, :conditions => {:deleted_at => nil}, :class_name => 'Spree::Address'
end
