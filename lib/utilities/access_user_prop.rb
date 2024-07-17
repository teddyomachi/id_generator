class AccessUserProp < Object
  attr_accessor :page_name, :user_age, :user_nationality, :user_sex, :user_email, :user_uid

  def initialize(**params)
    params.each {|k, v| self.send("#{k}=", v) if self.methods.include?(k)}
    pp params
  end
end
