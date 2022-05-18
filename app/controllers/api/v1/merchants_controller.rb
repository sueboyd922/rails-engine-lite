class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.format_merchants(Merchant.all)
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.one_merchant(merchant)
  end

  def find
    merchant = Merchant.find_by_name(params[:name])
  end
end
