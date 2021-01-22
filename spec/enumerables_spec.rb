require_relative '../bin/enumerables.rb'

describe Enumerable do
  let(:arr) { %w[a b c] }
  let(:arr_1) { [1, 2, 3, '4', false, nil, '2'] }
  let(:range) { (1...10) }
  let(:hash) { { a: '1', b: '2' } }
  let(:arr_2) { [5, 1, 2, 5] }

  describe '#my_each' do
    it 'should return the same array' do
      expect(arr.my_each { |a| a }).to eq(%w[a b c])
    end

    it 'should return the same range' do
      expect(range.my_each { |a| a }).to eql(1...10)
    end

    it 'should return the same hash' do
      expect(hash.my_each { |a| a }).to eql({ a: '1', b: '2' })
    end

    it 'should return the same array' do
      expect(arr_2.my_each { |a| a }).to eql([5, 1, 2, 5])
    end

    context 'when given no block' do
      it 'should return an enumerator' do
        expect(arr.my_each).to be_an(Enumerator)
      end
    end
  end

  describe '#my_each_with_index' do
    it 'returns the same array' do
      expect(arr_2.my_each_with_index { |a| a }).to eql([5, 1, 2, 5])
    end

    it 'should return the same range' do
      expect(range.my_each_with_index { |a| a }).to eql(1...10)
    end

    it 'should return the same array' do
      expect(arr_2.my_each_with_index { |a| a }).to eql([5, 1, 2, 5])
    end

    context 'when given no block' do
      it 'should return an enumerator' do
        expect(arr.my_each_with_index).to be_an(Enumerator)
      end
    end
  end

  describe '#my_select' do
    it 'returns the selected items' do
      expect(arr.my_select { |item| item == 'c' }).to eql(['c'])
    end

    it 'return the selected numbers in a range' do
      expect(range.my_select { |item| item > 3 }).to eql([4, 5, 6, 7, 8, 9])
    end

    it 'returns the select items in a hash' do
      expect(hash.my_select { |_item, key| key == '2' }).to eql([[:b, '2']])
    end

    it 'returns error if no block given' do
      expect(arr.my_select).to be_an(Enumerator)
    end
  end

  describe '#my_all?' do
    it 'returns a boolean' do
      expect(arr_1.my_all? { |a| a.is_a?(Integer) }).to be false
    end

    it 'returns a boolean' do
      expect(arr_1.my_all? { |a| a.is_a?(String) }).to be false
    end

    it 'returns a boolean' do
      expect(hash.my_all? { |item, _key| item == :a }).to be false
    end

    it 'returns a boolean' do
      expect(arr.my_all?(/o/)).to be false
    end
  end

  describe '#my_any?' do
    it 'returns a boolean' do
      expect(arr.my_any? { |item| item.is_a?(String) }).to eql(true)
    end

    it 'returns a boolean' do
      expect(range.my_any? { |item| item < 0 }).to be false
    end

    it 'returns a boolean' do
      expect(hash.my_any? { |_item, key| key == '2' }).to be true
    end

    it 'returns a boolean' do
      expect(arr.my_any?(/o/)).to be false
    end
  end

  describe '#my_none?' do
    it 'returns a boolean' do
      expect(arr_2.my_none? { |item| item.is_a?(String) }).to be true
    end

    it 'returns a boolean' do
      expect(hash.my_none? { |_item, key| key == 2 }).to be true
    end

    it 'returns a boolean' do
      expect(arr_1.my_none? { |item| item == false }).to be false
    end

    it 'returns a boolean' do
      expect(arr.my_none?(/o/)).to be true
    end
  end

  describe '#my_count' do
    it 'returns count of specific items' do
      expect(arr_2.my_count(2)).to eql(1)
    end

    it 'returns count of all' do
      expect(arr_2.my_count { |item| item }).to eql(4)
    end
  end

  describe '#my_map' do
    it 'should ' do
      expect(arr_2.my_map { |item| item**2 }).to eq([25, 1, 4, 25])
    end
  end

  describe '#my_inject' do
    it 'iterates through an array to build a new object' do
      ans = arr_2.my_inject { |sum, num| sum + num }
      expect(ans).to eq(13)
    end
  end
end
