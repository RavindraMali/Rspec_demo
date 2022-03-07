require 'rails_helper'

RSpec.describe User, type: :model do
  
  context "validation tests" do
    it "ensures first name presences" do
      user = User.new(last_name: 'mali', email:"ravindra@mail.com").save
      expect(user).to eq(false)
    end
    it "ensures last name presences" do
      user = User.new(first_name: 'ravindra', email:"ravindra@mail.com").save
      expect(user).to eq(false)
    end
    it "ensures email presences" do
      user = User.new(first_name: 'ravindra', last_name:"mali").save
      expect(user).to eq(false)
    end

    it "should save successfully" do
      user = User.new(first_name: 'ravindra', last_name:"mali", email: "ravindra@mail.com").save
      expect(user).to eq(true)
    end
  end

  context "scope tests" do
    let (:params) { {first_name: 'ravindra', last_name:"mali", email: "ravindra@mail.com"} }
    before(:each) do
        User.new(params).save
        User.new(params).save
        User.new(params).save
        User.new(params.merge(active: false)).save
        User.new(params.merge(active: false)).save
        User.new(params.merge(active: true)).save
    end

    it 'should return active users' do
      expect(User.active_users.size).to eq(4)
    end

    it 'should return inactive users' do
      expect(User.inactive_users.size).to eq(2)
    end
  end

end


