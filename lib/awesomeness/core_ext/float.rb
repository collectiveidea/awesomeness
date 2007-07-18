class Float
  def round(round_to = 1.0)
    mod = self % round_to
    rounded = self - mod + (mod >= round_to/2.0 ? round_to : 0)
    rounded % 1 == 0 ? rounded.to_i : rounded
  end
end
