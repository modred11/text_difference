
class Diff
  def self.strings(a, b)
    a, b = a.split("\n"), b.split("\n")

    [a, b].each do |a_or_b|
      a_or_b.map!.with_index do |str, number|
        Diff.make_line(str, number)
      end
    end

    self.diff(a, b)
  end

  def self.files(a, b)
    a, b = [a, b].map do |a_or_b|
      lines = []

      File.open(a_or_b) do |file|
        until file.eof?
          lines << Diff.make_line(file.gets.chomp, lines.length)
        end
      end

      lines
    end

    self.diff(a, b)
  end

  module Line
    attr_accessor :line_number

    def diff_format
      [self.line_number, self]
    end
  end

  def self.make_line(str, line_number)
    str.extend(Line)
    str.line_number = line_number
    str
  end

  protected

  def self.possibilities(a, b)
    prospects = Array.new([a.length, b.length].max) { [] }

    a.each.with_index do |a_line, i|
      ad, bd = a.dup, b.dup

      equivalencies = (a + [:added]).product(b + [:removed])

      equivalencies.each do |e|
        prospects <<
      end
    end

    prospects
  end

  def self.diff(a, b)
    removed = []
    unchanged = []

    return Diff.possibilities(a, b)

    # possible_equivalences.sort do |(a_line, b_line))|
    #   a_line == b_line
    # end

    return possible_equivalences

    # a.each do |a_line|
    #   b.find.with_index do |b_line, i|
    #     if a_line == b_line
    #       unchanged << a_line
    #       b.delete_at(i)
    #       next b_line
    #     end
    #
    #     false
    #   end
    # end

    a.each do |a_line|
      if unchanged.select { |line| line.diff_format == a_line.diff_format }.empty?
        removed << a_line
      end
    end

    {added: b.map(&:diff_format).sort, removed: removed.map(&:diff_format).sort}
  end
end
