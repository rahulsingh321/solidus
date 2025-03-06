# frozen_string_literal: true

module SolidusAdmin
  class StoresController < SolidusAdmin::ResourcesController
    include SolidusAdmin::ControllerHelpers::Search

    def index
      stores = apply_search_to(
        Spree::Store.order(id: :desc),
        param: :q
      )

      set_page_and_extract_portion_from(stores)

      respond_to do |format|
        format.html { render component('stores/index').new(page: @page) }
      end
    end

    def new
      @store ||= Spree::Store.new

      respond_to do |format|
        format.html {
          render component("stores/new").new(@store)
        }
      end
    end

    def edit
      @store = Spree::Store.find_by(id: params[:id])

      respond_to do |format|
        format.html { render component('stores/edit').new(@store) }
      end
    end

    def destroy
      @stores = Spree::Store.where(id: params[:id])

      Spree::Store.transaction { @stores.destroy_all }

      flash[:notice] = t('.success')
      redirect_back_or_to stores_path, status: :see_other
    end

    private

    def resource_class
      Spree::Store
    end

    def permitted_resource_params
      permitted_keys = Spree::Store.column_names.without("id", "created_at", "updated_at")
      params.require(:store).permit(*permitted_keys, :favicon)
    end
  end
end
