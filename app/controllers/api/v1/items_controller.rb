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
       render status: 400
     end
  end

  def update
    item = Item.update(params[:id], item_params)
    if item.save
      render json: ItemSerializer.one_item(item)
    else
      render status: 404
    end
  end

  def find_all
    if params[:name].empty?
      render status: 400
    else
      items = Item.find_all_by_name(params[:name])
      render json: ItemSerializer.format_items(items)
    end
  end

  private
    def item_params
      params.require(:item).permit(:name, :description, :merchant_id, :unit_price)
    end
end
