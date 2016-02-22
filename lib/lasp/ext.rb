class Array
  def to_s
    "(#{ map(&:inspect).join(" ") })"
  end

  def inspect
    to_s
  end

  def call(index)
    self[index]
  end

  # Ruby 2.0 shim
  unless Array.method_defined?(:to_h)
    def to_h
      Hash[self]
    end
  end
end

class Hash
  def to_s
    "{#{ map { |pair| pair.map(&:inspect).join(" ") }.join(", ") }}"
  end

  def inspect
    to_s
  end

  def call(index)
    self[index]
  end
end

class Symbol
  def inspect
    to_s
  end
end
