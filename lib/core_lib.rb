CORE_LIB = {
  :+ =>   -> (*args) { args.reduce(:+) },
  :- =>   -> (*args) { args.reduce(:-) },
  :* =>   -> (*args) { args.reduce(:*) },
  :/ =>   -> (*args) { args.reduce(:/) },
  :"=" => -> (*args) { args.uniq.count == 1 },
}
