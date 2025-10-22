class AddCastToMovies < ActiveRecord::Migration[8.0]
  def change
    add_column :movies, :cast, :text
  end
end
