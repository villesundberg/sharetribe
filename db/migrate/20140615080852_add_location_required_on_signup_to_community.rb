class AddLocationRequiredOnSignupToCommunity < ActiveRecord::Migration
  def change
    add_column :communities, :location_required_on_signup, :boolean, default: false
  end
end
