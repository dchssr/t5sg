class TradeClass
  alias Condition = World -> Bool

  getter condition : Condition

  @@classes = Hash(String, TradeClass).new

  def initialize(code : String, &condition : Condition)
    @condition = condition
    @@classes[code] = self
  end

  def applies_to?(world : World) : Bool
    @condition.call world
  end

  def self.[](code : String) : TradeClass
    @@classes[code]
  end

  def self.for(world : World) : Array(String)
    @@classes.select {|code, trade_class|
      code if trade_class.applies_to? world
    }.keys.to_a
  end
end


# Base Trade Classes #

## Primary
### Asteroid belt
TradeClass.new "As" do |w|
  w.size.zero? && w.atmosphere.zero? &&
    w.hydrographics.zero?
end

### Desert
TradeClass.new "De" do |w|
  (2..9).includes?(w.atmosphere) &&
    w.hydrographics.zero?
end

### Fluid oceans
TradeClass.new "Fl" do |w|
  (0xA..0xC).includes?(w.atmosphere) &&
    w.hydrographics > 0
end

### Garden world
TradeClass.new "Ga" do |w|
  (6..8).includes?(w.size) &&
    [5, 6, 8].includes?(w.atmosphere) &&
    (5..7).includes?(w.hydrographics)
end

### Ice-capped
TradeClass.new "Ic" do |w|
  [0, 1].includes?(w.atmosphere) &&
    (w.hydrographics > 0)
end

### Ocean world
TradeClass.new "Oc" do |w|
  (w.size > 0xA)                                      &&
    ![0, 1, 2, 0xA, 0xB, 0xC].includes?(w.atmosphere) &&
    (w.hydrographics == 0xA)
end

### Vaccuum
TradeClass.new "Va" do |w|
  w.atmosphere.zero?
end

### Water world
TradeClass.new "Wa" do |w|
  (3..9).includes?(w.size)                            &&
    ![0, 1, 2, 0xA, 0xB, 0xC].includes?(w.atmosphere) &&
    (w.hydrographics == 0xA)
end

### TOOD: Satellite/Locked


## Population

### Dieback
TradeClass.new "Di" do |w|
  w.population.zero?   &&
    w.government.zero? &&
    w.law_level.zero?  &&
    (w.tech_level > 0)
end

### Barren (like Dieback but nothing ever was there; often amber advisory)
TradeClass.new "Ba" do |w|
  w.population.zero? &&
    w.government.zero? &&
    w.law_level.zero? &&
    w.tech_level.zero?
end

### Low population
TradeClass.new "Lo" do |w|
  (1..3).includes? w.population
end

### Nonindustrial
TradeClass.new "Ni" do |w|
  (4..6).includes? w.population
end

### Prehigh
TradeClass.new "Ph" do |w|
  w.population == 8
end

### High population
TradeClass.new "Hi" do |w|
  (9..).includes? w.population
end


## Economic

### Preägricultural
TradeClass.new "Pa" do |w|
  (4..9).includes?(w.atmosphere)      &&
    (4..8).includes?(w.hydrographics) &&
    [4, 8].includes?(w.population)
end

### Agricultural
TradeClass.new "Ag" do |w|
  (4..9).includes?(w.atmosphere)      &&
    (4..8).includes?(w.hydrographics) &&
    (5..7).includes?(w.population)
end

### Nonagricultural
TradeClass.new "Na" do |w|
  (0..3).includes?(w.atmosphere)      &&
    (0..3).includes?(w.hydrographics) &&
    (w.population > 5)
end

### Prison/Exile camp
TradeClass.new "Px" do |w|
  [2, 3, 0xA, 0xB].includes?(w.atmosphere) &&
    (1..5).includes?(w.hydrographics)      &&
    (3..6).includes?(w.population)         &&
    (6..9).includes?(w.law_level) #        &&
  # w.mainworld?
end

### Preïndustrial
TradeClass.new "Pi" do |w|
  [0, 1, 2, 4, 7, 9].includes?(w.atmosphere) &&
    [7, 8].includes?(w.population)
end

### Industrial
TradeClass.new "In" do |w|
  [0, 1, 2, 4, 7, 9, 0xA, 0xB, 0xC].includes?(w.atmosphere) &&
    (w.population > 8)
end

### Poor
TradeClass.new "Po" do |w|
  (2..5).includes?(w.atmosphere) &&
    (0..3).includes?(w.hydrographics)
end

### Prerich
TradeClass.new "Pr" do |w|
  [6, 8].includes?(w.atmosphere) &&
    [5, 9].includes?(w.population)
end

### Rich
TradeClass.new "Ri" do |w|
    [6, 8].includes?(w.atmosphere) &&
      (6..8).includes?(w.population)
end

# Political and Special trade classes are beyond the scope of this
# generator as they *will* depend on the referee's tone for the setting.
