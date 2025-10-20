class AddBooleanFiltersToMovies < ActiveRecord::Migration[8.0]
  def change
    add_column :movies, :watch_at_home, :boolean
    add_column :movies, :watch_in_cinemas, :boolean
    add_column :movies, :manequim_films, :boolean
    add_column :movies, :vitrine_session, :boolean
  end
end
