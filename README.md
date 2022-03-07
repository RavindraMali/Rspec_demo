Rspec Testing Framework



References : 
https://www.tutorialspoint.com/rspec/index.htm

https://github.com/rspec/rspec-rails

https://www.youtube.com/watch?v=71eKcNxwxVY


Create fresh application of rails using below command

$ rails new RspecDemo -T

-T : will create app without default testing packages 


Now add a gem to your fresh application gemfile

# Run against this stable release
group :development, :test do
  gem 'rspec-rails', '~> 5.0.0'
end

Remember to add gem into the development test

Execute following command to start working with Rspec test framework.

 rails generate rspec:install
      create  .rspec
      create  spec
      create  spec/spec_helper.rb
      create  spec/rails_helper.rb

To see available feature 
pcs200@pcs200-desktop:~/RspecDemo$ rails generate --help | grep rspec
  rspec:channel
  rspec:controller
  rspec:feature
  rspec:generator
  rspec:helper
  rspec:install
  rspec:integration
  rspec:job
  rspec:mailbox
  rspec:mailer
  rspec:model
  rspec:request
  rspec:scaffold
  rspec:system
  rspec:view

Create one model to test 
pcs200@pcs200-desktop:~/RspecDemo$ rails generate model User first_name:string last_name:string email:string active:boolean
      invoke  active_record
      create    db/migrate/20220307124741_create_users.rb
      create    app/models/user.rb
      invoke    rspec
      create      spec/models/user_spec.rb

Observe the highlighted blue line this is not a default rails test it’s Rspec specific file.
This happened because we have created the rails app without the testing package and after installing rspec-rails package this file is getting generated
 Remember, create command was $ rails new RspecDemo -T

Execute this migration file with  db:migrate command
pcs200@pcs200-desktop:~/RspecDemo$ rails db:migrate
== 20220307124741 CreateUsers: migrating ======================================
-- create_table(:users)
   -> 0.0021s
== 20220307124741 CreateUsers: migrated (0.0022s) =============================

Create rspec model
pcs200@pcs200-desktop:~/RspecDemo$ rails generate rspec:model user
   identical  spec/models/user_spec.rb
Files with content


 app/models/user.rb

class User < ApplicationRecord
end

 spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
 end

Now add some English word or statement to test the User model like below using 
“It” helper
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
 end


Now we are all set to start our Rspec testing 
Open terminal into application’s root directory 
Run the rspec command to start testing
pcs200@pcs200-desktop:~/RspecDemo$ rspec
FFF.

Failures:

  1) User ensures first name presences
     Failure/Error: expect(user).to eq(false)
     
       expected: false
            got: true
     
       (compared using ==)
     
       Diff:
       @@ -1 +1 @@
       -false
       +true
       
     # ./spec/models/user_spec.rb:6:in `block (2 levels) in <top (required)>'

  2) User ensures last name presences
     Failure/Error: expect(user).to eq(false)
     
       expected: false
            got: true
     
       (compared using ==)
     
       Diff:
       @@ -1 +1 @@
       -false
       +true
       
     # ./spec/models/user_spec.rb:10:in `block (2 levels) in <top (required)>'

  3) User ensures email presences
     Failure/Error: expect(user).to eq(false)
     
       expected: false
            got: true
     
       (compared using ==)
     
       Diff:
       @@ -1 +1 @@
       -false
       +true
       
     # ./spec/models/user_spec.rb:14:in `block (2 levels) in <top (required)>'

Finished in 0.0554 seconds (files took 1.3 seconds to load)
4 examples, 3 failures

Failed examples:

rspec ./spec/models/user_spec.rb:4 # User ensures first name presences
rspec ./spec/models/user_spec.rb:8 # User ensures last name presences
rspec ./spec/models/user_spec.rb:12 # User ensures email presences


At the top of the Output we are getting FFF . which is confusing to understand to get a fully formatted acknowledgement make some changes into application

Find the .rspec file into the root of the application add below line into it

--require spec_helper
--format documentation

Now rerun the rspec command on terminal 

This tme we’ll get 
pcs200@pcs200-desktop:~/RspecDemo$ rspec

User
  ensures first name presences (FAILED - 1)
  ensures last name presences (FAILED - 2)
  ensures email presences (FAILED - 3)
  should save successfully

The rest of the lines will be the same.

Now let’s add some validations to  the User model

class User < ApplicationRecord
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true
end


Now rerun the RSpec on terminal

pcs200@pcs200-desktop:~/RspecDemo$ rspec

User
  ensures first name presences
  ensures last name presences
  ensures email presences
  should save successfully

Finished in 0.04748 seconds (files took 1.28 seconds to load)
4 examples, 0 failures


This shows the validation gets a successful pass.

Rollback the  user migration and make change to active field that default should true
pcs200@pcs200-desktop:~/RspecDemo$ rails db:rollback step=1
== 20220307124741 CreateUsers: reverting ======================================
-- drop_table(:users)
   -> 0.0022s
== 20220307124741 CreateUsers: reverted (0.0173s) ================


class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.boolean :active,  default: true

      t.timestamps
    end
  end
end

Migrate the migration file again

pcs200@pcs200-desktop:~/RspecDemo$ rails db:migrate
== 20220307124741 CreateUsers: migrating ======================================
-- create_table(:users)
   -> 0.0028s
== 20220307124741 CreateUsers: migrated (0.0029s) =============================

Let’s add two scopes tho the User model

class User < ApplicationRecord
    scope :active_users, -> { where(active: true)}
    scope :inactive_users, -> { where(active: false)}
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true
end


And add the following into the user_rspec.rb file, next to the context “validation tests”


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

Now rerun the rspec command on terminal
pcs200@pcs200-desktop:~/RspecDemo$ rspec

User
  validation tests
    ensures first name presences
    ensures last name presences
    ensures email presences
    should save successfully
  scope tests
    should return active users
    should return inactive users

Finished in 0.05941 seconds (files took 1.29 seconds to load)
6 examples, 0 failures


That means all test is going well.
