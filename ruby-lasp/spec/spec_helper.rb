require "tempfile"

def product_root
  File.expand_path("../", __dir__)
end

def with_tempfile(content)
  Tempfile.open(["lasp-test", ".lasp"]) do |file|
    file.write(content)
    file.rewind

    yield(file)
  end
end
