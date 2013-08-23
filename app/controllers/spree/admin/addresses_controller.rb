module Spree
  module Admin
    class AddressesController < BaseController

      def search
        @addresses = Spree::Address.find_by_order_email(params[:q])
        render layout: !request.xhr?
      end

    end
  end
end
