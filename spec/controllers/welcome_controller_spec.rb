# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  describe 'GET #home' do
    subject { get :home }

    context 'when there is current user session' do
      let(:user) { create(:user) }

      before do
        session[:current_user] = user
      end

      it 'is successful' do
        expect(subject).to be_successful
      end
    end

    context 'when there is no current user session' do
      it 'redirects to root_path' do
        expect(subject).to redirect_to(root_path)
      end
    end
  end
end
