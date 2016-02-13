require './test/test_helper'

class TvShowsTest < MiniTest::Unit::TestCase
 include WithRollback

  def test_tv_show_exists
    count = TvShows.count # guard clause
    temporarily do
      TvShows.create(:user => 'username', :name => 'name', :db_id => '111', :season => '1', :episode => '1', :next_episodes => '4', :pic => 'poster_path')

      assert_equal count + 1, TvShows.count
      assert_equal 1, TvShows.where(:user => 'username').size
      assert_equal 1, TvShows.where(:name => 'name').size
      assert_equal 1, TvShows.where(:db_id => '111').size
      assert_equal 1, TvShows.where(:pic => 'poster_path').size
      fail ActiveRecord::Rollback
    end
    assert_equal count, TvShows.count
  end

  def test_tv_show_delete
    count = TvShows.count # guard clause
    temporarily do
      TvShows.create(:user => 'username', :name => 'name', :db_id => '111', :season => '1', :episode => '1', :next_episodes => '4', :pic => 'poster_path')

      assert_equal count + 1, TvShows.count
      assert_equal 1, TvShows.where(:user => 'username').size
      assert_equal 1, TvShows.where(:name => 'name').size
      assert_equal 1, TvShows.where(:db_id => '111').size
      assert_equal 1, TvShows.where(:pic => 'poster_path').size

      TvShows.where(:user => 'username').first.delete
      assert_equal count, TvShows.count

      fail ActiveRecord::Rollback
    end
    assert_equal count, TvShows.count
  end

end
