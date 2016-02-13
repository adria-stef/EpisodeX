require './test/test_helper'

class UserTest < MiniTest::Unit::TestCase
 include WithRollback

  def test_user_exists
    count = User.count # guard clause
    temporarily do
      new_password = BCrypt::Password.create('pass')
      User.create(:email => 'some_email', :hashed_password => new_password)

      assert_equal count + 1, User.count
      assert_equal 1, User.where(:email => 'some_email').size

      fail ActiveRecord::Rollback
    end
    assert_equal count, User.count
  end

  def test_user_delete
    count = User.count # guard clause
    temporarily do
      new_password = BCrypt::Password.create('pass')
      User.create(:email => 'some_email', :hashed_password => new_password)

      assert_equal count + 1, User.count
      assert_equal 1, User.where(:email => 'some_email').size

      User.where(:email => 'some_email').first.delete
      assert_equal count, User.count

      fail ActiveRecord::Rollback
    end
    assert_equal count, User.count
  end

end
