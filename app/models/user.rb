class User < ActiveRecord::Base
  acts_as_authentic
  easy_roles :roles

  has_one :dashboard
end
