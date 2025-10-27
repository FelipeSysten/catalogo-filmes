require 'rails_helper'

RSpec.describe Genre, type: :model do
  subject { FactoryBot.build(:genre) }

  describe 'Associações' do
    it { is_expected.to have_many(:movie_genres).dependent(:destroy) }
    it { is_expected.to have_many(:movies).through(:movie_genres) }
  end
end
