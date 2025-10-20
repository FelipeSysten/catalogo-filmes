class AddGenreNameToMovies < ActiveRecord::Migration[8.0]
  def change
    add_column :movies, :genre_name, :string
  end
end
