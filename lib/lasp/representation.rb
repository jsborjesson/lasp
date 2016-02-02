class Array
  def inspect
    "(#{ map(&:inspect).join(" ") })"
  end
end

class Symbol
  def inspect
    to_s
  end
end
