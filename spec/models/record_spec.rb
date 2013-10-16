require "spec_helper"

describe Record do

  before :each do
    @user = User.create email: "user@temp.com", password: "11111111"
    @valid_name      = { name: "foo" }
    @no_name         = {}
    @valid_diagnosis = { diagnosis: "foo" }
    @no_diagnosis    = {}
  end

  it "has a name" do
    expect(Record.new @valid_name.merge(@valid_diagnosis)).to be_valid
    expect(Record.new @no_name.merge(@valid_diagnosis)).not_to be_valid
  end

  it "has a diagnosis" do
    expect(Record.new @valid_diagnosis.merge(@valid_name)).to be_valid
    expect(Record.new @no_diagnosis.merge(@valid_name)).not_to be_valid
  end

  it "does not destroy records created by a user if the user is destroyed" do
    Record.create({ name: "foo", diagnosis: "bar", created_by: @user.email })
    expect(Record.all).to have(1).record
    @user.destroy
    expect(Record.all).to have(1).record
  end

end
