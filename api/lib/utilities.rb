module Utilities
  def is_integer?(string)
    true if Integer(string) rescue false
  end
end