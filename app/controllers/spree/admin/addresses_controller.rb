module Spree
  module Admin
    class AddressesController < BaseController

      def search
        @addresses = Spree::Address.find_by_order_email(params)
        if not @addresses or @addresses.size == 0
          @user = Spree::User.where("email ilike ?", "#{params[:q]}%").first

          if @user.present?
            @addresses = @user.address_search(params)
          end
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
