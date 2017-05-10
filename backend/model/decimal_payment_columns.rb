class DecimalPaymentColumns

  def self.convert_for_save(json, opts, decimal_columns)
    decimal_columns.each do |column|
      if json[column]
        opts[column] = BigDecimal.new(json[column])
      end
    end

    opts
  end

  def self.convert_for_jsonmodel(objs, jsons, decimal_columns)
    jsons.zip(objs).each do |json, obj|
      # These columns come out of the DB as BigDecimal objects.  Format them as
      # NNN.DD.
      decimal_columns.each do |column|
        if obj[:"#{column}"]
          value = obj[:"#{column}"].to_s('F')

          # If the value is 500.0, just render as 500
          value = value.gsub(/\.0$/, '')

          # If the value is 500.4, show 500.40
          if value =~ /\.[0-9]$/
            value += '0'
          end

          json[column] = value
        end
      end
    end

    jsons
  end

  def self.errors_for_columns(hash, decimal_columns)
    errors = []

    decimal_columns.each do |column|
      if hash[column] && !decimal_ok?(hash[column])
        errors << [column, "must be a number with no more than 2 decimal places"]
      end
    end

    errors
  end

  def self.decimal_ok?(value)
    value =~ /\A[0-9]+\z/ || value =~ /\A[0-9]+\.[0-9]{1,2}\z/
  end

end
