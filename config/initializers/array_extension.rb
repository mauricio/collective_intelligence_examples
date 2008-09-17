

class Array

  def to_select_options
    self.map { |i| [ i.to_s, i.id ] }
  end

end