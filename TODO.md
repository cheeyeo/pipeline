# Refactor Builder#build_operation_chain(stack)

  we're currently using an internal array to store operation classes

  maybe break function down into another function ?(pipe) which uses reduce
  to call each function in chain without storing it in an array

  ```
  def pipe(*fns)
   ->(*args) { fns.reduce(args) { |memo, fn| [fn.call(*memo)] }.first }
  end

  def compose(*fns)
    pipe(*fns.reverse)
  end
  ```


  Example:
  https://github.com/lazebny/ramda-ruby/commit/ad3539d1abd05ff6abcbee993ad5b6c8e32c53be
