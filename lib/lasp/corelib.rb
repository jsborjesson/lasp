module Lasp
  CORELIB = {
    :+          => -> (_, *args)         { args.reduce(:+)                 },
    :-          => -> (_, *args)         { args.reduce(:-)                 },
    :*          => -> (_, *args)         { args.reduce(:*)                 },
    :/          => -> (_, *args)         { args.reduce(:/)                 },
    :<          => -> (_, *args)         { args.sort == args               },
    :>          => -> (_, *args)         { args.sort.reverse == args       },
    :"="        => -> (_, *args)         { args.uniq.count == 1            },
    :list       => -> (_, *args)         { args                            },
    :head       => -> (_, list)          { list.first                      },
    :tail       => -> (_, list)          { list.drop(1)                    },
    :cons       => -> (_, item, list)    { [item] + list                   },
    :"hash-map" => -> (_, *args)         { Hash[*args]                     },
    :get        => -> (_, key, a)        { a[key]                          },
    :assoc      => -> (_, a, key, val)   { a.dup.tap { |a| a[key]=val    } },
    :dissoc     => -> (_, a, key)        { a.dup.tap { |a| a.delete(key) } },
    :not        => -> (_, arg)           { !arg                            },
    :println    => -> (_, output)        { puts output                     },
    :"."        => -> (_, obj, m, *args) { obj.send(m, *args)              },
  }
end
