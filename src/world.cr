require "./uwp"
require "./trade_class"

class World
  def initialize
    @uwp = UWP.new
  end

  def initialize(port, size, atmosphere, hydrographics,
                 population, government, law_level, tech_level)
    @uwp = UWP.new port, size, atmosphere, hydrographics,\
                   population, government, law_level, tech_level
  end

  def initialize(profile : String)
    @uwp = UWP.new profile
  end

  delegate port,          to: @uwp
  delegate size,          to: @uwp
  delegate atmosphere,    to: @uwp
  delegate hydrographics, to: @uwp
  delegate population,    to: @uwp
  delegate government,    to: @uwp
  delegate law_level,     to: @uwp
  delegate tech_level,    to: @uwp

  # TODO: figure out a table thingy to *properly* print the sector.
  def to_s(io : IO)
    io << @uwp
    io << " "
    io << trade_classes.join(" ")
  end

  def trade_classes : Array(String)
    TradeClass.for self
  end
end
