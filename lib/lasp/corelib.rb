module Lasp
  CORELIB = {
    :+          => -> (*args)         { args.reduce(:+)                          },
    :-          => -> (*args)         { args.reduce(:-)                          },
    :*          => -> (*args)         { args.reduce(:*)                          },
    :/          => -> (*args)         { args.reduce(:/)                          },
    :<          => -> (*args)         { args.each_cons(2).all? { |a, b| a < b }  },
    :>          => -> (*args)         { args.each_cons(2).all? { |a, b| a > b }  },
    :<=         => -> (*args)         { args.each_cons(2).all? { |a, b| a <= b } },
    :>=         => -> (*args)         { args.each_cons(2).all? { |a, b| a >= b } },
    :"="        => -> (*args)         { args.uniq.count == 1                     },
    :list       => -> (*args)         { args                                     },
    :head       => -> (list)          { list.first                               },
    :tail       => -> (list)          { list.drop(1)                             },
    :cons       => -> (item, list)    { [item] + list                            },
    :"hash-map" => -> (*args)         { Hash[*args]                              },
    :get        => -> (key, a)        { a[key]                                   },
    :assoc      => -> (a, key, val)   { a.dup.tap { |a| a[key] = val  }          },
    :dissoc     => -> (a, key)        { a.dup.tap { |a| a.delete(key) }          },
    :not        => -> (arg)           { !arg                                     },
    :println    => -> (output)        { puts output                              },
    :"."        => -> (obj, m, *args) { obj.send(m, *args)                       },
  }
end
