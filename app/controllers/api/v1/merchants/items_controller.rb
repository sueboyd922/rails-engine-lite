class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    merchant = Merchant.find(params[:id])
    render json: ItemSerializer.format_items(merchant.items)
  end
end
