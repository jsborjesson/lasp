class Array
  def to_s
    "(#{ map(&:inspect).join(" ") })"
  end

  def inspect
    to_s
  end
end

class Hash
  def to_s
    "{#{ map { |pair| pair.map(&:inspect).join(" ")}.join(", ") }}"
  end

  def inspect
    to_s
  end
end

class Symbol
  def inspect
    to_s
  end
end
