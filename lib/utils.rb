require 'ostruct'
require 'net/http'
require 'uri'

def to_recursive_ostruct(hash)
  OpenStruct.new(hash.each_with_object({}) do |(key, val), memo|
        memo[key] = val.is_a?(Hash) ? to_recursive_ostruct(val) : val
          end)
end
