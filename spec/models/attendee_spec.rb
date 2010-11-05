require 'spec_helper'

describe Attendee do
  
  before(:each) do
    @user = Factory.create(:user)
    @user_friend = Factory.create(:user, :email => "friend_of_user@user.com")
    @pairing_session = Factory.create(:pairing_session, :owner => @user)    
  end
  
  it "Associates a user with a pairing session" do
    @pairing_session.add_attendee @user_friend
    @pairing_session.attendees.should have(1).item
  end
  
  it "Doesn't add the owner of a pairing session as an attendee" do
    @pairing_session.add_attendee @user
    @pairing_session.attendees.should be_empty
  end
  
  it "Won't add the same user as an attendee twice" do
    @pairing_session.add_attendee @user_friend
    @pairing_session.add_attendee @user_friend
    @pairing_session.attendees.should have(1).item
  end
  
  it "Doesn't delete the user when deleted" do
    attendee = Attendee.create( {:user_id => @user.id, :pairing_session_id => @pairing_session.id} )
    lambda {
      attendee.destroy
    }.should_not change(User, :count)
  end
  
  it "Doesn't delete the pairing session when deleted" do
    attendee = Attendee.create( {:user_id => @user.id, :pairing_session_id => @pairing_session.id} )
    lambda {
      attendee.destroy
    }.should_not change(PairingSession, :count)    
  end
  
  it "Is deleted if the user is deleted" do
    @pairing_session.add_attendee @user_friend
    lambda {
      @user_friend.destroy
    }.should change(Attendee, :count).by(-1)
  end

  it "Is deleted if the pairing session is deleted" do
    @pairing_session.add_attendee @user_friend
    lambda {
      @pairing_session.destroy
    }.should change(Attendee, :count).by(-1)
  end
  
end
