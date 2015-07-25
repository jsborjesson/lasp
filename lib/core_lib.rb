module Lasp
  CORE_LIB = {
    :+   => -> (_, *args) { args.reduce(:+) },
    :-   => -> (_, *args) { args.reduce(:-) },
    :*   => -> (_, *args) { args.reduce(:*) },
    :/   => -> (_, *args) { args.reduce(:/) },
    :"=" => -> (_, *args) { args.uniq.count == 1 },
    :list => -> (_, *items) { items },
    :head => -> (_, list) { list.first },
    :tail => -> (_, list) { list.drop(1) },
    :cons => -> (_, item, list) { [item] + list },
  }
end
