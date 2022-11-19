# frozen_string_literal: true

module Simpal
  # Represents an API resource.
  #
  class PayPalObject
    # @return [Regexp] A simple regular expression that matches the syntax of an ISO8601 date and time.
    #
    TIME_REGEXP = /\A[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}(Z|\+[0-9]{2}:[0-9]{2}(\.[0-9]+)?)\z/.freeze

    # Create an object representing a resource from the PayPal API.
    #
    # @param resource [Hash] The resource retrieved from the PayPal API.
    #
    def initialize(resource = {})
      transform = proc do |value|
        case value
        when Array       then value.map { |v| transform.call(v) }
        when Hash        then PayPalObject.new(value)
        when TIME_REGEXP then Time.parse(value)
        else                  value
        end
      end

      @resource = resource.each_with_object({}) do |(key, value), hash|
        hash[key.to_s] = transform.call(value)
      end

      @resource.each_key do |key|
        define_singleton_method(key.to_sym) do |*args, &block|
          return @resource[key] if args.empty?
          return super(*args, &block) if defined?(super)

          raise NoMethodError, "method '#{key}' doesn't support arguments in #{self}"
        end
      end
    end

    # @return [Hash] A hash representation of the PayPal object.
    #
    def to_hash
      transform = proc do |value|
        case value
        when Array        then value.map { |v| transform.call(v) }
        when PayPalObject then value.to_hash
        when Time         then value.iso8601
        else                   value
        end
      end

      @resource.transform_values(&transform)
    end

    # @return [String] A JSON representation of the PayPal object.
    #
    def inspect
      resource_id = respond_to?(:id) && id ? " id=#{id}" : ''
      json = JSON.pretty_generate(@resource)
      "#<#{self.class}:0x#{object_id.to_s(16)}#{resource_id}> JSON: #{json}"
    end

    # Determines whether the object can respond to the specified method name.
    #
    # @param  name        [Symbol]  The name of the method to determine responsiveness of.
    # @param  include_all [Boolean] `true` to search private and protected methods, `false` to search public only.
    # @return             [Boolean] `true` if the method can be responded to, `false` otherwise.
    #
    def respond_to_missing?(name, _include_all)
      @resource.key?(name.to_s)
    end

    # Returns `nil` when the method is missing instead of raising a `NoMethodError` exception.
    #
    # @param  name [Symbol]   The name of the invoked method.
    # @param  args [Splat]    The arguments passed into the invoked method.
    # @return      [NilClass]
    #
    def method_missing(_name, *_args)
      nil
    end

    # @see Simpal::PayPalObject#to_hash
    #
    alias to_h to_hash
  end
end
