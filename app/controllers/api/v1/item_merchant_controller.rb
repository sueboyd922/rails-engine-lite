class Api::V1::ItemMerchantController < ApplicationController
  def show
    item = Item.find(params[:id])
    merchant = Merchant.find(item.merchant_id)
    render json: MerchantSerializer.one_merchant(merchant)
  end
end
