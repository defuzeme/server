class Array
  def to_select
    inject([]) do |out, elem|
      out << [elem, out.size]
      out
    end
  end
end
