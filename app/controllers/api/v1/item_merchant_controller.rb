class Api::V1::ItemMerchantController < ApplicationController
  def show
    if Item.exists?(params[:id])
      item = Item.find(params[:id])
      merchant = Merchant.find(item.merchant_id)
      render json: MerchantSerializer.one_merchant(merchant)
    else
      render status: 404
    end
  end
end
