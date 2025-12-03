require 'test_helper'

class BookingPolicyTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @other_user = users(:two)
    @club = clubs(:one)
    @other_club = clubs(:two)
    @player = players(:one) # Belongs to club one
    @other_player = players(:two) # Belongs to club two
    
    # Valid booking: User's club buying from other club
    @booking = Booking.new(
      club: @club,
      player: @other_player,
      start_date: Date.today,
      end_date: Date.today + 1.week,
      total_price: 1000,
      status: :pending
    )
  end

  def test_index
    # User with club can access index
    assert_permit @user, Booking, :index?
    
    # User without club cannot access index
    @user.club = nil
    refute_permit @user, Booking, :index?
  end

  def test_show
    # Buyer can see the booking
    assert_permit @user, @booking, :show?

    # Seller can see the booking
    # @other_player belongs to @other_club. @other_user belongs to @other_club.
    assert_permit @other_user, @booking, :show?

    # Unrelated user cannot see the booking
    unrelated_user = User.new(club: Club.new)
    refute_permit unrelated_user, @booking, :show?
  end

  def test_create
    # Valid creation: Buying from another club
    assert_permit @user, @booking, :create?

    # Invalid: Buying from own club
    self_deal_booking = Booking.new(club: @club, player: @player)
    refute_permit @user, self_deal_booking, :create?

    # Invalid: User not belonging to the buying club
    refute_permit @other_user, @booking, :create?
  end

  def test_update
    # Seller can update (e.g. accept/reject)
    assert_permit @other_user, @booking, :update?

    # Buyer cannot update
    refute_permit @user, @booking, :update?
  end

  def test_destroy
    refute_permit @user, @booking, :destroy?
    refute_permit @other_user, @booking, :destroy?
  end

  def test_scope
    # Save the booking so it appears in scope
    @booking.save!
    
    # Create another booking where user is the seller
    # Buyer: Club 2, Seller: Club 1 (Player 1)
    sales_booking = Booking.create!(
      club: @other_club,
      player: @player,
      start_date: Date.today,
      end_date: Date.today + 1.week,
      total_price: 1000,
      status: :pending
    )

    # Create unrelated booking
    # Buyer: Club 2, Seller: Club 2 (Self deal, technically invalid but good for scope test isolation)
    # Or better, create a 3rd club if possible, but we only have 2 fixtures.
    # Let's just use the fact that @booking is visible to User 1 (buyer) and User 2 (seller)
    
    scope = BookingPolicy::Scope.new(@user, Booking).resolve
    assert_includes scope, @booking
    assert_includes scope, sales_booking

    scope = BookingPolicy::Scope.new(@other_user, Booking).resolve
    assert_includes scope, @booking
    assert_includes scope, sales_booking
    
    # User without club sees nothing
    @user.club = nil
    scope = BookingPolicy::Scope.new(@user, Booking).resolve
    assert_empty scope
  end
end
