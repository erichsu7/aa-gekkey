course_load = Hash.new { |h, k| h[k] = [] }

courses = [
  ['CS', 'CS 101', 3],
  ['MATH', 'Calc', 4],
  ['CS', 'CS 102',  4]
]

courses.each do |course|
  dept, name, credits = course
  course_load[dept] << name
end

course_load['CS'] # => ["CS 101", "CS 102"]
course_load['XYZ'] # => []
course_load # => {"CS"=>["CS 101", "CS 102"], "MATH"=>["Calc"], "XYZ"=>[]}
