# frozen_string_literal: true

module Simpal
  # Represents an API resource.
  #
  class PayPalObject
    # Create a new object representing the provided resource.
    #
    # @param resource [Hash] The resource to represent.
    #
    def initialize(resource = {})
      transform = proc do |key, value|
        case value
        when Array then value.map { |v| transform.call(nil, v) }
        when Hash  then PayPalObject.new(value)
        else
          if key && (key.end_with?('date') || key.end_with?('time'))
            Time.parse(value)
          else
            value
          end
        end
      end

      @values = resource.each_with_object({}) do |(key, value), values|
        values[key.to_s] = transform.call(key.to_s, value)
        add_reader(key)
      end
    end

    # @return [Hash] A hash representation of the PayPal object.
    #
    def to_hash
      transform = proc do |value|
        case value
        when Array        then value.map { |v| transform.call(v) }
        when PayPalObject then value.to_hash
        else                   value.is_a?(Time) ? value.iso8601 : value
        end
      end

      @values.transform_values(&transform)
    end

    # @see Simpal::PayPalObject#to_hash
    #
    alias to_h to_hash

    # @return [String] A JSON string representation of the PayPal object.
    #
    def inspect
      paypal_id = respond_to?(:id) && id ? " id=#{id}" : ''
      json = JSON.pretty_generate(@values)
      "#<#{self.class}:0x#{object_id.to_s(16)}#{paypal_id}> JSON: #{json}"
    end

    # @return [Boolean] `true` to indicate that all methods can be responded to.
    #
    def respond_to_missing?(_name, _include_all)
      true
    end

    # @return [NilClass] `nil` instead of raising an exception.
    #
    def method_missing(_name, *args); end

    private

    # Add a read-only attribute for the specified value.
    #
    # @param name [String, Symbol] The name of the attribute to define.
    #
    def add_reader(name)
      metaclass.instance_eval do
        name = name.to_s
        if name.to_sym == :method
          define_method(name.to_sym) { |*args| args.empty? ? @values[name] : super(*args) }
        else
          define_method(name.to_sym) { @values[name] }
        end
      end
    end

    # @return [Class] The metaclass which can be used to define methods on this instance only.
    #
    def metaclass
      class << self
        self
      end
    end
  end
end
