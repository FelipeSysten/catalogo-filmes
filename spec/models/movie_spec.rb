require 'rails_helper'

RSpec.describe Movie, type: :model do
  subject { FactoryBot.build(:movie) }

  describe 'Validações' do
    it { is_expected.to belong_to(:user).optional(false) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:movie_genres).dependent(:destroy) }
    it { is_expected.to have_many(:genres).through(:movie_genres) }
    it { is_expected.to validate_presence_of(:director) }
    it { is_expected.to validate_numericality_of(:duration).only_integer.is_greater_than(0) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_least(2) }
    it { is_expected.to validate_presence_of(:synopsis) }
    it { is_expected.to validate_length_of(:synopsis).is_at_least(10) }
    it { is_expected.to validate_presence_of(:release_year) }
    it { is_expected.to validate_numericality_of(:release_year).only_integer }
  end

  describe '.search_movies' do
    let!(:movie1) { FactoryBot.create(:movie, title: 'Inception', director: 'Christopher Nolan', cast: 'Leonardo DiCaprio') }
    let!(:movie2) { FactoryBot.create(:movie, title: 'The Dark Knight', director: 'Christopher Nolan', cast: 'Christian Bale') }
    let!(:movie3) { FactoryBot.create(:movie, title: 'Interstellar', director: 'Christopher Nolan', cast: 'Matthew McConaughey') }

    it 'returns movies matching the title' do
      results = Movie.search_movies('Inception')
      expect(results).to include(movie1)
      expect(results).not_to include(movie2, movie3)
    end

    it 'returns movies matching the director' do
      results = Movie.search_movies('Christopher Nolan')
      expect(results).to include(movie1, movie2, movie3)
    end

    it 'returns movies matching the cast' do
      results = Movie.search_movies('Christian Bale')
      expect(results).to include(movie2)
      expect(results).not_to include(movie1, movie3)
    end
  end

  describe 'Scopes' do
    let!(:genre_action) { FactoryBot.create(:genre, name: 'Action') }
    let!(:genre_drama) { FactoryBot.create(:genre, name: 'Drama') }
    let!(:movie1) { FactoryBot.create(:movie, release_year: 2020) }
    let!(:movie2) { FactoryBot.create(:movie, release_year: 2021) }
    let!(:movie3) { FactoryBot.create(:movie, release_year: 2020) }

    before do
      movie1.genres << genre_action
      movie2.genres << genre_drama
      movie3.genres << genre_action
    end

    describe '.by_genre' do
      it 'returns movies of the specified genre' do
        results = Movie.by_genre('Action')
        expect(results).to include(movie1, movie3)
        expect(results).not_to include(movie2)
      end

      it 'returns all movies when genre is not specified' do
        results = Movie.by_genre(nil)
        expect(results).to include(movie1, movie2, movie3)
      end
    end

    describe '.by_release_year' do
      it 'returns movies of the specified release year' do
        results = Movie.by_release_year(2020)
        expect(results).to include(movie1, movie3)
        expect(results).not_to include(movie2)
      end

      it 'returns all movies when release year is not specified' do
        results = Movie.by_release_year(nil)
        expect(results).to include(movie1, movie2, movie3)
      end
    end
  end
end