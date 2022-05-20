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

  def destroy
    if Item.exists?(params[:id])
      item = Item.find(params[:id])
      item.solo_invoices.each {|invoice| invoice.destroy }
      item.destroy
    else
      render status: 404
    end
  end

  def find
    keys = params.keys
    if keys.count == 2 || params.values.include?("")
      render status: 400
    elsif (keys.count == 5) || (keys.count == 4 && keys.include?(:name))
      render status: 400
    elsif keys.count == 4 && !keys.include?(:name)
      #find in range
    elsif keys.count == 3
      if params[:name]
        item = Item.find_all_by_name(params[:name]).first
      elsif params[:min_price]
        item = Item.find_all_by_price("min", params[:min_price]).first
      elsif params[:max_price]
        item = Item.find_all_by_price("max", params[:max_price]).first
      end
      render json: ItemSerializer.one_item(item)
    end
  end

  def find_all
    keys = params.keys
    if keys.count == 2 || params.values.include?("")
      render status: 400
    elsif (keys.count == 5) || (keys.count == 4 && keys.include?(:name))
      render status: 400
    elsif keys.count == 4 && !keys.include?(:name)
      #find in range
    elsif keys.count == 3
      if params[:name]
        items = Item.find_all_by_name(params[:name])
      elsif params[:min_price]
        items = Item.find_all_by_price("min", params[:min_price])
      elsif params[:max_price]
        items = Item.find_all_by_price("max", params[:max_price])
      end
      render json: ItemSerializer.format_items(items)
    end
  end

  private
    def item_params
      params.require(:item).permit(:name, :description, :merchant_id, :unit_price)
    end
end
