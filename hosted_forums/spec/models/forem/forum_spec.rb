require 'spec_helper'
require 'subscribem/testing_support/factories/account_factory'
require 'forem/testing_support/factories/categories'
require 'forem/testing_support/factories/forums'

describe Forem::Forum do
  context "an account on the 'Starter' plan" do
    before do
      account = FactoryGirl.create(:account_with_schema)
      account.plan = Subscribem::Plan.create(:name => 'Starter')
      account.save
      Apartment::Database.switch(account.subdomain)
      5.times do |i|
        FactoryGirl.create(:forum)
      end
    end

    it "is limited to 5 forums" do
      forum = FactoryGirl.build(:forum)
      forum.save
      message = "You are not allowed to create more" +
                " than 5 forums on your current plan."
      forum.errors[:base].should include(message)
    end
  end
end
