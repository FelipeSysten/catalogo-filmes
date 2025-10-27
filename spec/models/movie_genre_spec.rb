require 'rails_helper'

RSpec.describe MovieGenre, type: :model do
  subject { FactoryBot.build(:movie_genre) }

  describe 'Associações' do
    it { is_expected.to belong_to(:movie).optional(false) }

    it { is_expected.to belong_to(:genre).optional(false) }
  end
end
