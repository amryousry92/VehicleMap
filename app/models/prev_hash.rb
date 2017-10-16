require 'singleton'

class PrevHash < Hash
  include Singleton

  def initialize
    super([])
  end

  def add key,value
    self[key]=value
  end

  def value key
    return self[key]
  end
end
