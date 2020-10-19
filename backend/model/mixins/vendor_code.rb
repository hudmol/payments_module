module VendorCode

  def self.included(base)
  end

  def validate
    super
    validates_unique(:vendor_code, :message => "Vendor Code already in use")

    # we need to enforce uniqueness across the different agent models
    if self.vendor_code.strip
      [AgentPerson, AgentCorporateEntity, AgentFamily, AgentSoftware].each do |model|
        next if model == self.class

        unless model.filter(:vendor_code => self.vendor_code).empty?
          errors.add(:vendor_code, "Vendor Code already in use")
          break
        end
      end
    end
  end
end
