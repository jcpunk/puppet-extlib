# frozen_string_literal: true

# @summary
#   Recursively sorts a hash by keys to ensure deterministic ordering.
#
# @param input [Hash]
#   The hash to sort. Nested hashes are sorted recursively.
#
# @return [Hash]
#   A new hash with all keys sorted lexicographically at every level.
#
# @example Basic usage
#   extlib::sort_hash_deep({'b' => 1, 'a' => 2})
#   # => {'a' => 2, 'b' => 1}
#
# @example Nested structures
#   extlib::sort_hash_deep({'z' => {'b' => 2, 'a' => 1}})
#   # => {'z' => {'a' => 1, 'b' => 2}}
#
Puppet::Functions.create_function(:'extlib::sort_hash_deep') do
  dispatch :sort_hash_deep do
    param 'Hash', :input
    return_type 'Hash'
  end

  def sort_hash_deep(input)
    input.keys.sort.each_with_object({}) do |k, memo|
      v = input[k]

      memo[k] =
        case v
        when Hash
          sort_hash_deep(v)
        when Array
          v.map do |item|
            item.is_a?(Hash) ? sort_hash_deep(item) : item
          end
        else
          v
        end
    end
  end
end
