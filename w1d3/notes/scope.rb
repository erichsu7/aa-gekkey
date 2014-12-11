$blue = 'blue'  # => "blue"
class Cat
  def self.brown
    'brown'
  end

  def say_hi
    @green = 'green'
    red = 'red'

    ['yellow', 'soemthign'].each do |yellow|
      # puts 'Inside each do...'
      # puts $blue
      # puts @green
      # puts red
      # puts yellow
    end

    puts 'Inside say_hi'
    puts $blue
    puts @green
    puts red
    puts self.class.brown
    puts yellow
  end
end

class Tiger < Cat
  def self.brown
    'Orange'
  end
end

gizmo = Tiger.new
puts gizmo.methods.sort # => nil

# >> !
# >> !=
# >> !~
# >> <=>
# >> ==
# >> ===
# >> =~
# >> __id__
# >> __send__
# >> class
# >> clone
# >> define_singleton_method
# >> display
# >> dup
# >> enum_for
# >> eql?
# >> equal?
# >> extend
# >> freeze
# >> frozen?
# >> hash
# >> inspect
# >> instance_eval
# >> instance_exec
# >> instance_of?
# >> instance_variable_defined?
# >> instance_variable_get
# >> instance_variable_set
# >> instance_variables
# >> is_a?
# >> kind_of?
# >> method
# >> methods
# >> nil?
# >> object_id
# >> private_methods
# >> protected_methods
# >> public_method
# >> public_methods
# >> public_send
# >> remove_instance_variable
# >> respond_to?
# >> say_hi
# >> send
# >> singleton_class
# >> singleton_method
# >> singleton_methods
# >> taint
# >> tainted?
# >> tap
# >> to_enum
# >> to_json
# >> to_s
# >> trust
# >> untaint
# >> untrust
# >> untrusted?
