class StringUtility
  def is_binary_data?
    (self.count("^ -~", "^\r\n").fdiv(self.size) > 0.3 || self.index("\x00")) unless blank?
  end
end

