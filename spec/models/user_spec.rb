require 'rails_helper'
require 'spec_helper'

RSpec.describe User, type: :model do
  # subject(:user) { FactoryGirl.build(:user) }
  subject(:user) { User.new(username: "Luke Skywalker", password: "stardust")}

  describe 'validations' do
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_presence_of(:password_digest) }
    it { should validate_presence_of(:session_token) }
    it { should validate_length_of(:password).is_at_least(6)}
  end

  describe "password encryption" do
    it "does not save the password to the database" do
      User.create!(username: "Han Solo", password: "falcon")
      user = User.find_by_username("Han Solo")
      expect(user.password).not_to be_truthy
    end

    it "uses BCrypt to encrypt the password" do
      expect(BCrypt::Password).to receive(:create)
      User.new(username: "Han Solo", password: "falcon")
    end
  end

  describe 'class-scope methods' do

    describe '::find_by_credentials' do
      before {user.save!}

      context 'when the user exists in the database' do
        it 'should return the user with the matching username and password' do
          expect(User.find_by_credentials("Luke Skywalker", "stardust")).to eq(user)
        end

        it 'returns nil if the password is incorrect' do
          expect(User.find_by_credentials("Luke Skywalker", "tatooine")).to be_nil
        end
      end

      context 'when the user does not exist in the database' do
        it 'returns nil' do
          expect(User.find_by_credentials("James T. Kirk", 'enterprise')).to be_nil
        end
      end
    end
  end

  describe 'instance methods' do
    describe '#password=(password)' do
      it "creates a password_digest when a password is given" do
        expect(user.password_digest).to_not be_nil
      end
    end

    describe '#reset_session_token!' do
      it "generates a new session token" do
        old_token = user.session_token
        user.reset_session_token!
        expect(user.session_token).to_not eq(old_token)
      end

      it "returns the new session token" do
        expect(user.reset_session_token!).to eq(user.session_token)
      end
    end

    describe 'is_password?(password)' do
      it "returns true if the password is correct" do
        expect(user.is_password?('stardust')).to be true
      end
    end
  end

  describe 'associations' do

  end

end
