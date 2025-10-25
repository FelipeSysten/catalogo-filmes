class AddDescriptionToMovies < ActiveRecord::Migration[8.0]
  def change
    add_column :movies, :description, :text
  end
end
