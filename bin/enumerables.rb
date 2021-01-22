# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity
# rubocop:disable Metrics/ModuleLength
# rubocop:disable Metrics/MethodLength

module Enumerable
  def my_each
    return to_enum unless block_given?

    arr = to_a
    arr.length.times { |e| yield(arr[e]) }
    self
  end

  def my_each_with_index
    return to_enum unless block_given?

    arr = to_a
    arr.my_each { |index| yield(arr[index], index) }
    self
  end

  def my_select
    if block_given?
      arr = []
      my_each { |element| arr.push(element) if yield(element) }
      arr
    else
      to_enum(:my_select)
    end
  end

  def my_all?(argm = nil)
    if block_given?
      my_each { |element| return false if yield(element) == false }
      true
    elsif argm.nil?
      my_each { |n| return false if n.nil? || n == false }
    elsif !argm.nil? && (argm.is_a? Class)
      my_each { |n| return false if n.is_a?(argm) == false }
    elsif !argm.nil? && argm.class == Regexp
      my_each { |n| return false unless argm.match(n) }
    else
      my_each { |n| return false if n != argm }
    end
    true
  end

  def my_any?(arg = nil)
    if block_given?
      my_each { |item| return true if yield(item) }
      false
    elsif arg.nil?
      my_each { |n| return true if n }
    elsif !arg.nil? && (arg.is_a? Class)
      my_each { |n| return true if n.is_a?(arg) == true }
    elsif !arg.nil? && arg.class == Regexp
      my_each { |n| return true if arg.match(n) }
    else
      my_each { |n| return true if n == arg }
    end
    false
  end

  def my_none?(arg = nil)
    if !block_given? && arg.nil?
      my_each { |n| return false if n }
      return true
    end

    if !block_given? && !arg.nil?

      if arg.is_a?(Class)
        my_each { |n| return false if n.class == arg }
        return true
      end

      if arg.class == Regexp
        my_each { |n| return false if arg.match(n) }
        return true
      end

      my_each { |n| return false if n == arg }
      return true
    end

    my_any? { |item| return false if yield(item) }
    true
  end

  def my_count(arg = nil)
    count = 0
    if block_given?
      my_each { |i| count += 1 if yield(i) }
    elsif !arg.nil?
      my_each { |i| count += 1 if i == arg }
    else
      my_each { |i| count += 1 if i }
    end
    count
  end

  def my_map(proc = nil)
    return to_enum(:my_map) unless block_given?

    result = []
    my_each { |element| result << proc.call(element) } if block_given? && proc
    my_each { |element| result << yield(element) } if proc.nil?
    result
  end

  def my_inject(number = nil, symbol = nil)
    if !block_given? && number.nil? && symbol.nil?
      return raise LocalJumpError, 'no block given'
    end

    if block_given?
      accum = number
      my_each do |item|
        accum = accum.nil? ? item : yield(accum, item)
      end
      accum
    elsif !number.nil? && (number.is_a?(Symbol) || number.is_a?(String))
      accum = nil
      my_each do |item|
        accum = accum.nil? ? item : accum.send(number, item)
      end
      accum
    elsif !symbol.nil? && (symbol.is_a?(Symbol) || symbol.is_a?(String))
      accum = number
      my_each do |item|
        accum = accum.nil? ? item : accum.send(symbol, item)
      end
      accum
    end
  end

  p [2, 2, 3, 2].my_inject(:+)
  def my_map_proc
    arr = []
    if block_given?
      my_each do |x|
        arr.push(yield(x))
      end
    else
      to_enum(:my_map_proc)
    end
    arr
  end
end

def multiply_els(arr)
  arr.my_inject { |multiply, element| multiply * element }
end

# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity
# rubocop:enable Metrics/ModuleLength
# rubocop:enable Metrics/MethodLength
