class Array
  def inspect
    "(#{ map(&:inspect).join(" ") })"
  end

  def to_s
    inspect
  end
end

class Symbol
  def inspect
    to_s
  end
end

class Hash
  def inspect
    "{#{ map { |pair| pair.map(&:inspect).join(" ")}.join(", ") }}"
  end

  def to_s
    inspect
  end
end
