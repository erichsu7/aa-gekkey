def super_print(str, args = {})
  args = {:times => 1}.merge(args)

  args.each do |func|
    str = str.send(func[0]) unless func[0] == :times
  end

  args[:times].times do
    puts str
  end
end

# super_print("Hello")                                    #=> "Hello"
# super_print("Hello", :times => 3)                       #=> "Hello" 3x
# super_print("Hello", :upcase => true)                   #=> "HELLO"
# super_print("Hello", :upcase => true, :reverse => true) #=> "OLLEH"
#
# options = {}
# super_print("hello", options)
