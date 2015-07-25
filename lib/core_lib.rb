module Lasp
  CORE_LIB = {
    :+   => -> (_, *args) { args.reduce(:+) },
    :-   => -> (_, *args) { args.reduce(:-) },
    :*   => -> (_, *args) { args.reduce(:*) },
    :/   => -> (_, *args) { args.reduce(:/) },
    :"=" => -> (_, *args) { args.uniq.count == 1 },
    :def => -> (env, key, value) { env[key] = value },
  }
end
