class AddSlugToSpreeVariants < ActiveRecord::Migration[7.1]
  def change
    add_column :spree_variants, :slug, :string
  end
end
