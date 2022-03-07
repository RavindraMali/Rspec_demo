# t.string :first_name
# t.string :last_name
# t.string :email
# t.boolean :active

class User < ApplicationRecord
    scope :active_users, -> { where(active: true)}
    scope :inactive_users, -> { where(active: false)}
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true
end
