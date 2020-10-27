module VendorCode

  def self.included(base)
  end

  def validate
    super

    if self.vendor_code != self.class.filter(:id => self.id).get(:vendor_code)
      current_user = User[:username => RequestContext.get(:current_username)]
      unless current_user.can?(:administer_system)
        errors.add(:vendor_code, "Vendor code can only be changed by Administrators")
      end
    end

    validates_unique(:vendor_code, :message => "Vendor Code already in use")

    # we need to enforce uniqueness across the different agent models
    unless self.vendor_code.to_s.strip.empty?
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
