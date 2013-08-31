module Spree
  module Admin
    class AddressesController < BaseController

      def search
        @addresses = Spree::Address.find_by_order_email(params[:q])
        if not @addresses or @addresses.size == 0
          @user = Spree::User.find_by_email(params[:q])
          @addresses = @user.addresses
        end
        render layout: !request.xhr?
      end

      def destroy
        @address = Spree::Address.find(params[:id])
        @address.destroy

        flash[:success] = "Address removed"
        redirect_to admin_orders_url
      end
    end
  end
end
