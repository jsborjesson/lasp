CORE_LIB = {
  :+ =>   -> (*args) { args.reduce(:+) },
  :- =>   -> (*args) { args.reduce(:-) },
  :* =>   -> (*args) { args.reduce(:*) },
  :/ =>   -> (*args) { args.reduce(:/) },
  :"=" => -> (*args) { args.all? { |a| a == args.first } },
}
