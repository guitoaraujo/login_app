FactoryBot.define do
  factory :user do
    username { 'username' }
    password { '12345678' }
    login_attempts { 0 }
    status { 0 }
    created_at { 'Thu, 21 Oct 2021 09:43:48.242767000 UTC +00:00' }
    updated_at { 'Thu, 21 Oct 2021 09:43:48.242767000 UTC +00:00' }
  end

  trait :blocked do
    status { 1 } 
  end
end
