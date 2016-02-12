require './test/test_helper'

class DBConfigTest < MiniTest::Unit::TestCase
  def test_default_file
    file = './config/database.yml'
    assert_equal file, DBConfig.new('env').file
  end

  def test_override_file
    file = './test/fixtures/database.yml'
    assert_equal file, DBConfig.new('env', file).file
  end

  def test_read_environment_specific_values
    config = DBConfig.new('fake', './test/fixtures/database.yml')
    options = {
      'adapter' => 'sqlite3',
      'database' => 'db/episodex_test'
    }
    assert_equal options, config.options
  end

  def test_blow_up_for_unknown_environment
    config = DBConfig.new('real', './test/fixtures/database.yml')
    assert_raises DBConfig::UnconfiguredEnvironment do
      config.options
    end
  end
end
