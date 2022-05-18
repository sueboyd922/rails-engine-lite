class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.format_items(Item.all)
  end

  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.one_item(item)
  end

  def create
    item = Item.new(item_params)
     if item.save
       render json: ItemSerializer.one_item(item), status: :created
     else
       render json: ItemSerializer.one_item(item), status: 400
     end
  end

  private
    def item_params
      params.require(:item).permit(:name, :description, :merchant_id, :unit_price)
    end
end
