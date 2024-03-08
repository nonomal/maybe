class Money::Currency
    CURRENCIES_FILE_PATH = Rails.root.join("config", "currencies.yml")

    class << self
        def all
            @all ||= YAML.load_file(CURRENCIES_FILE_PATH)
        end

        def popular
            all.values.sort_by { |currency| currency["priority"] }.first(12)
        end

        def find(iso_code)
            all[iso_code.to_s.downcase]
        end
    end

    attr_reader :name, :priority, :iso_code, :iso_numeric, :html_code,
                :symbol, :minor_unit, :minor_unit_conversion, :smallest_denomination,
                :separator, :delimiter, :default_format, :default_precision

    def initialize(object)
        iso_code = case object
        when String, Symbol
          object.to_s.downcase
        when Money::Currency
          object.iso_code.downcase
        else
          raise ArgumentError, "Invalid argument type"
        end

        currency_data = self.class.find(iso_code)

        raise ArgumentError, "Currency not found" if currency_data.nil?

        @name = currency_data["name"]
        @priority = currency_data["priority"]
        @iso_code = currency_data["iso_code"]
        @iso_numeric = currency_data["iso_numeric"]
        @html_code = currency_data["html_code"]
        @symbol = currency_data["symbol"]
        @minor_unit = currency_data["minor_unit"]
        @minor_unit_conversion = currency_data["minor_unit_conversion"]
        @smallest_denomination = currency_data["smallest_denomination"]
        @separator = currency_data["separator"]
        @delimiter = currency_data["delimiter"]
        @default_format = currency_data["default_format"]
        @default_precision = currency_data["default_precision"]
    end

    def ==(other)
        other.is_a?(Money::Currency) && iso_code == other.iso_code
    end
end
