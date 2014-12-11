def super_print(string, options = {})
  defaults = {
    times: 1,
    upcase: false,
    reverse: false
  }

  options = defaults.merge(options)

  string = string.upcase if options[:upcase]
  string = string.reverse if options[:reverse]

  options[:times].times do
    puts string
  end

  nil
end

super_print("Ruby is awesome!") # => nil


# >>
