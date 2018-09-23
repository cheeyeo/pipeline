
def compose(*fns)
  pipe(*fns.reverse)
end

 # Performs left-to-right function composition. The leftmost function may
# have any arity; the remaining functions must be unary.
def pipe(*fns)
 ->(*args) do
    fns[1..-1].reduce(fns[0].call(*args)) { |memo, fn|
      puts "MEMO: #{memo.inspect}"
      puts "FN: #{fn.inspect}"
      fn.call(memo)
    }
  end
end

def map_reducer(&fn)
  -> result, input {
    puts "RESULT: #{result.inspect} INPUT: #{input.inspect}"
    result.push(fn.call(input))
  }
end

# Takes only 1 argument since the operations are reversed and runs from right to left
select_test = -> list {
  list.select {|x| x > 3}
}

op = compose(
  #select_test,
  map_reducer { |x| x+1 }
)

puts [1,2,3].reduce([], &op).inspect
