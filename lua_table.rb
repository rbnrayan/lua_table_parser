require_relative 'parser'

class LuaTable
  attr_reader :table
  
  def initialize(source)
    @table = Parser.new(source).parse
  end

  def add(entry)
    if entry.is_a?(Hash)
      table_entries = table.shift
      entry.merge!(table_entries)
      table.unshift(entry)
    else
      table.push(entry)
    end
  end
end
