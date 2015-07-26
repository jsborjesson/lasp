module Lasp
  CORELIB = {
    :+       => -> (_, *args)      { args.reduce(:+)      },
    :-       => -> (_, *args)      { args.reduce(:-)      },
    :*       => -> (_, *args)      { args.reduce(:*)      },
    :/       => -> (_, *args)      { args.reduce(:/)      },
    :"="     => -> (_, *args)      { args.uniq.count == 1 },
    :list    => -> (_, *args)      { args                 },
    :head    => -> (_, list)       { list.first           },
    :tail    => -> (_, list)       { list.drop(1)         },
    :cons    => -> (_, item, list) { [item] + list        },
    :not     => -> (_, arg)        { !arg                 },
    :println => -> (_, output)     { puts output          },
  }
end
