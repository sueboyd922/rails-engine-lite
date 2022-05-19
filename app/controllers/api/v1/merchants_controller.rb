class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.format_merchants(Merchant.all)
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.one_merchant(merchant)
  end

  def find
    if params[:name].nil? || params[:name].empty?
      render status: 400
    else
      merchant = Merchant.find_by_name(params[:name]).first
      if !merchant.nil?
        render json: MerchantSerializer.one_merchant(merchant)
      else
        render json: MerchantSerializer.no_merchant
      end
    end
  end
end
