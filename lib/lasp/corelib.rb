module Lasp
  CORELIB = {
    :+          => -> (*args)         { args.reduce(:+)                 },
    :-          => -> (*args)         { args.reduce(:-)                 },
    :*          => -> (*args)         { args.reduce(:*)                 },
    :/          => -> (*args)         { args.reduce(:/)                 },
    :<          => -> (*args)         { args.sort == args               },
    :>          => -> (*args)         { args.sort.reverse == args       },
    :"="        => -> (*args)         { args.uniq.count == 1            },
    :list       => -> (*args)         { args                            },
    :head       => -> (list)          { list.first                      },
    :tail       => -> (list)          { list.drop(1)                    },
    :cons       => -> (item, list)    { [item] + list                   },
    :"hash-map" => -> (*args)         { Hash[*args]                     },
    :get        => -> (key, a)        { a[key]                          },
    :assoc      => -> (a, key, val)   { a.dup.tap { |a| a[key] = val  } },
    :dissoc     => -> (a, key)        { a.dup.tap { |a| a.delete(key) } },
    :not        => -> (arg)           { !arg                            },
    :println    => -> (output)        { puts output                     },
    :"."        => -> (obj, m, *args) { obj.send(m, *args)              },
  }
end
