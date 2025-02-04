class AddBreadcrumbSourceToSpreeVariants < ActiveRecord::Migration[7.1]
  def change
    add_reference :spree_products, :breadcrumb_source, foreign_key: { to_table: :spree_taxons }, index: true
  end
end
