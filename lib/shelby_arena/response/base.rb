module ShelbyArena
  module Response
    class Base
      attr_reader :data

      def self.format(data)
        new(data).format
      end

      def self.format_list(data)
        new(data).format_list
      end

      def initialize(data)
        @data = data
      end

      def format_list
        res = format

        return [] if res.nil?
        return [res] if res.is_a?(Hash)

        res
      end

      def format
        return nil if data.nil?

        if data.is_a?(Array)
          data.map { |item| format_single(item) }
        else
          format_single(data)
        end
      end

      def to_h(dict, data)
        return {} if data.nil?

        dict.each_with_object({}) do |(l, r), object|
          object[l] = data[r]
        end
      end

      def to_boolean(string)
        string&.downcase == 'true'
      end

      def date_parse(string)
        return DateTime.parse(string) if string

        nil
      end
    end
  end
end
