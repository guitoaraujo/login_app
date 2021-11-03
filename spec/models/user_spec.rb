# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  shared_examples 'is not a valid user' do
    it { expect(subject).to_not be_valid }
  end

  subject { described_class.create(user_params) }

  context 'with valid attributes' do
    let(:user_params) { { username: 'username', password: '12345678', login_attempts: 0, status: 0 } }

    it 'is a valid user' do
      expect(subject).to be_valid
    end
  end

  context 'with invalid attributes' do
    context 'without one or more attributes' do
      let(:user_params) { { username: nil, password: '12345678', login_attempts: 0, status: 0 } }

      it_behaves_like 'is not a valid user'
    end

    context 'when username is not uniq' do
      let!(:user) { create(:user) }
      let(:user_params) { { username: 'username', password: '87654321', login_attempts: 0, status: 0 } }

      it_behaves_like 'is not a valid user'
    end

    context 'when username or password length is lesser than 6' do
      let(:user1) { build(:user, username: 'user') }
      let(:user2) { build(:user, password: '1234') }

      it 'is not a valid user' do
        expect(user1).to_not be_valid
      end

      it 'is not a valid user' do
        expect(user2).to_not be_valid
      end
    end
  end

  context '.encrypt_password' do
    let(:user) { create(:user) }
    let(:encrypted_password) { Digest::MD5.hexdigest('12345678') }

    it 'encrypt the user password properly' do
      expect(encrypted_password).to eq(user.password)
    end
  end
end
