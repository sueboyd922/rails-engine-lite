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
    find_alls = params.except(:controller, :action)
    if find_alls.empty? || find_alls.values.include?("")
      render status: 400
    elsif find_alls.keys.count == 3
      render status: 400
    elsif find_alls.keys.count == 2
      if find_alls.keys.include?(:name)
        render status: 400
      else
        # find both min and max
      end
    elsif find_alls.keys.count == 1
      if params[:name]
        items = Item.find_all_by_name(params[:name])
        render json: ItemSerializer.format_items(items)
      elsif params[:min_price]
        items = Item.find_all_by_price("min", params[:min_price])
        render json: ItemSerializer.format_items(items)
      elsif params[:max_price]
          #serializer for max
      end
    end

    # if params.keys.count == 2
    #   render status: 400
    # elsif params[:name].empty?
    #   render status: 400
    # elsif params[:name]
    #   items = Item.find_all_by_name(params[:name])
    #   render json: ItemSerializer.format_items(items)
    # elsif params[:min_price]
    # end
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

  private
    def item_params
      params.require(:item).permit(:name, :description, :merchant_id, :unit_price)
    end
end
