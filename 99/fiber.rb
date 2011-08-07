f1 = Fiber.new do |i|
  puts i
  Fiber.yield 2
  5
end

f2 = Fiber.new do
  puts 3
  j = Fiber.yield 4
  puts j
  7
end

i = f1.resume 1
puts i
j = f2.resume
puts j
i = f1.resume
puts i
j = f2.resume 6
puts j
