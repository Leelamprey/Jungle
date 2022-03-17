require 'rails_helper'
RSpec.describe User, type: :model do
  subject {
    described_class.new(
      first_name: "Berk", 
      last_name: "Ozer", 
      email: "berk@gmail.com", 
      password: "secret", 
      password_confirmation: "secret"
    )
  }
  describe "Validations" do
    it "validates with valid attributes" do
      expect(subject).to be_valid
      expect(subject.errors.full_messages).to be_empty
    end
    it "fails without first name" do
      subject.first_name = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include ("First name can't be blank")
    end
    it "fails without last name" do
      subject.last_name = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include ("Last name can't be blank")
    end
    it "fails without an email" do
      subject.email = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include ("Email can't be blank")
    end
    it "fails without pasword" do
      subject.password = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include ("Password can't be blank")
    end
    it "fails without pasword confirmation" do
      subject.password_confirmation = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include ("Password confirmation can't be blank")
    end
    it "fails when password and password_confirmation don't match" do
      subject.password_confirmation = "notsecret"
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include ("Password confirmation doesn't match Password")
    end
    it "fails when email isn't unique (case insensitive)" do
      same_as_subject = User.create(
        first_name: "Test", 
        last_name: "Person", 
        email: "BERK@gmail.com", 
        password: "secret", 
        password_confirmation: "secret"
      )
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include ("Email has already been taken")
    end
    it "fails when password is shorter than 5 characters" do
      subject.password = "abcd"
      subject.password_confirmation = "abcd"
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include ("Password is too short (minimum is 5 characters)")
    end
    it "validates when password is exactly 5 characters" do
      subject.password = "abcde"
      subject.password_confirmation = "abcde"
      expect(subject).to be_valid
      expect(subject.errors.full_messages).to be_empty
    end
  end
  describe '.authenticate_with_credentials' do
    it "authenticates when email is correct" do
      subject.save!
      auth = User.authenticate_with_credentials(subject.email, subject.password)
      expect(auth).to eq subject
    end
    it "fails when email incorrect" do
      subject.save!
      auth = User.authenticate_with_credentials("other@gmail.com", subject.password)
      expect(auth).to eq nil
    end
    it "fails when password incorrect" do
      subject.save!
      auth = User.authenticate_with_credentials(subject.email, "forgot")
      expect(auth).to eq nil
    end

    it "authenticates when email correct but has whitespace" do
      subject.save!
      auth = User.authenticate_with_credentials("   " + subject.email + "  ", subject.password)
      expect(auth).to eq subject
    end

    it "authenticate when email correct but wrong case" do
      subject.save!
      auth = User.authenticate_with_credentials("bErK@GMail.cOM", subject.password)
      expect(auth).to eq subject
    end
  end
end