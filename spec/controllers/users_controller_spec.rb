# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #index' do
    subject { get :index }

    context 'when there is current user session' do
      let(:user) { create(:user) }

      before do
        session[:current_user] = user
      end

      it 'is redirect to home_path' do
        expect(subject).to redirect_to(home_path)
      end
    end

    context 'when there is no current user session' do
      it 'is successful' do
        expect(subject).to be_successful
      end
    end
  end

  describe 'POST #login' do
    subject { post :login, params: params }

    context 'when there is session' do
      let(:user) { create(:user) }
      let(:params) { { username: user.username, password: user.password } }

      before do
        session[:current_user] = user
      end

      it 'returns 204' do
        expect(subject.response_code).to eq(204)
      end
    end

    context 'when there is no session' do
      context 'when there is a user to find' do
        context 'when params are valid' do
          let(:user) { create(:user) }

          context 'when username or password is not present' do
            let(:params) { { username: nil, password: user.password } }

            it 'is redirect to root_path' do
              expect(subject).to redirect_to(root_path)
            end
          end

          context 'credentials are valid' do
            context 'when user is blocked' do
              let(:user) { create(:user, :blocked) }
              let(:params) { { username: user.username, password: user.password } }

              it 'is redirect to root_path' do
                expect(subject).to redirect_to(root_path)
              end
            end

            context 'when user is active' do
              let(:user) { create(:user) }
              let(:params) { { username: user.username, password: '12345678' } }

              it 'resets login attempts' do
                subject
                expect(user.login_attempts).to eq(0)
              end

              it 'creates a session' do
                subject
                expect(session[:current_user]).to eq(user)
              end

              it 'is redirect to home_path' do
                expect(subject).to redirect_to(home_path)
              end
            end
          end

          context 'credentials are not valid' do
            let(:user) { create(:user) }
            let(:params) { { username: user.username, password: '11111111' } }

            it 'updates login attempts by 1' do
              subject
              expect(user.reload.login_attempts).to eq(1)
            end

            it 'is redirect to root_path' do
              expect(subject).to redirect_to(root_path)
            end
          end
        end
      end

      context 'when an user needs to be created' do
        context 'when params are valid' do
          let(:params) { { username: 'username', password: 'password' } }

          it 'creates a user with params' do
            subject
            expect(User.count).to eq(1)
          end

          it 'is redirect to home_path' do
            expect(subject).to redirect_to(home_path)
          end
        end

        context 'when params are not valid' do
          let(:params) { { username: 'user', password: '1234' } }

          it 'does not create a user' do
            subject
            expect(User.count).to eq(0)
          end

          it 'is redirect to root_path' do
            expect(subject).to redirect_to(root_path)
          end
        end
      end
    end
  end

  describe 'DELETE #logout' do
    subject { delete :logout }

    it 'sets session to nil' do
      subject
      expect(session[:current_user]).to eq(nil)
    end

    it 'redirects to root_path' do
      expect(subject).to redirect_to(root_path)
    end
  end
end
