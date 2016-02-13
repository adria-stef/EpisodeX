require 'yaml/store'

# DB configuration
class DBConfig
  class UnconfiguredEnvironment < StandardError; end

  attr_reader :file, :environment
  def initialize(environment, file = './config/database.yml')
    @environment = environment
    @file = file
  end

  def options
    read_only = true
    result = store.transaction(read_only) do
      store[environment]
    end
    unless result
      error = "No environment '#{environment}' configured in #{file}"
      fail UnconfiguredEnvironment.new(error)
    end
    result
  end

  private
  
  def store
    @store ||= YAML::Store.new(file)
  end
end
