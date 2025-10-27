require 'rails_helper'
RSpec.describe Comment, type: :model do
  subject { FactoryBot.build(:comment) }

  describe 'Associações' do
    it { is_expected.to belong_to(:user).optional(true) }
    it { is_expected.to belong_to(:movie).optional(false) }
  end

  describe 'Validações' do
    it { is_expected.to validate_presence_of(:content) }

    context 'quando o comentário é feito por um usuário logado' do
      before { subject.user = FactoryBot.create(:user) }

      it 'valida a presença do nome' do
        subject.name = nil
        expect(subject).not_to be_valid
      end
    end

    context 'quando o comentário é anônimo' do
      before { subject.user = nil }

      it 'não valida a presença do nome' do
        subject.name = nil
        expect(subject).to be_valid
      end
    end
  end
end
