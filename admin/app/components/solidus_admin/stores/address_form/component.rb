class SolidusAdmin::Stores::AddressForm::Component < SolidusAdmin::BaseComponent

	def initialize(store:)
		@name = "store"
		@store = store
	end

  def state_options
    return [] unless @store.country
    @store.country.states.map { |s| [s.name, s.id] }
  end
end
