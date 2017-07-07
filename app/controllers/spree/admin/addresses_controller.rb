module Spree
  module Admin
    class AddressesController < BaseController
      def search
        query = params[:q].strip
        @query_by_id = (query =~ /\D/ ? false : true)

        if @query_by_id
          @customer_email = Spree::CustomerEmail.where(number: query.to_i).first
          @user = @customer_email.user
          params[:q] = @customer_email.email
        else
          @user = Spree::User.where('email ilike ?', "%#{query}%").first
          @customer_email = @user.customer_email
        end

        @addresses = Spree::Address.find_by_order_email(params)

        if !@addresses || @addresses.empty?
          @addresses = @user.address_search(params) if @user.present?
        end
        render layout: !request.xhr?
      end

      def destroy
        @address = Spree::Address.find(params[:id])
        @address.destroy

        flash[:success] = 'Address removed'
        redirect_to admin_orders_url
      end
    end
  end
end
