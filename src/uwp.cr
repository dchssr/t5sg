require "./dice"
require "./ehex"

class UWP
  getter port          : Char,
         size          : UInt8,
         atmosphere    : UInt8,
         hydrographics : UInt8,
         population    : UInt8,
         government    : UInt8,
         law_level     : UInt8,
         tech_level    : UInt8

  def initialize
    @port          = roll_starport
    @size          = roll_size
    @atmosphere    = roll_atmosphere
    @hydrographics = roll_hydrographics
    @population    = roll_population
    @government    = roll_government
    @law_level     = roll_law_level
    @tech_level    = roll_tech_level
  end

  def initialize(@port,       @size,       @atmosphere, @hydrographics,
                 @population, @government, @law_level,  @tech_level)
  end

  def self.blank
    self.new 'X', 0, 0, 0, 0, 0, 0, 0
  end

  def to_s(io : IO) #to_s via IO is preferred over #to_s directly to String
    io << "%c%X%X%X%X%X%c-%c" % [@port, @size, @atmosphere, @hydrographics,
                                 @population, @government, EHex.encode(@law_level),
                                 @tech_level]
  end

  private def roll_starport : Char
    case Dice.roll 2
    when    ..4 then 'A' # Excellent
    when   5, 6 then 'B' # Good
    when   7, 8 then 'C' # Routine
    when      9 then 'D' # Poor
    when 10, 11 then 'E' # Frontier
    else             'X' # None
    end
  end

  private def roll_size : UInt8
    size = Dice.roll(2) - 2

    (size == 10 ? (Dice.roll + 9) : size).clamp(0, 0xF).to_u8
  end

  private def roll_atmosphere(size = @size) : UInt8
    return 0_u8 if size.zero?

    (Dice.flux + size).clamp(0, 0xF).to_u8
  end

  private def roll_hydrographics(size = @size, atmosphere = @atmosphere) : UInt8
    return 0_u8 if size < 2

    adjustment = (3..8).includes?(atmosphere) ? 0 : -4

    (Dice.flux + atmosphere + adjustment).clamp(0, 0xA).to_u8
  end

  private def roll_population : UInt8
    population = Dice.roll(2) - 2

    (population == 10 ? (Dice.roll(2) + 3) : population).clamp(0, 0xF).to_u8
  end

  private def roll_government(population = @population) : UInt8
    (Dice.flux + population).clamp(0, 0xF).to_u8
  end

  # This one will be a doozy since it goes beyond 15.
  # This will be encoded in eHex when rendered as a String.
  private def roll_law_level(government = @government) : UInt8
    (Dice.flux + government).clamp(0, 18).to_u8
  end

  private def tech_level_adjustment_port(port = @port)
    case port
    when 'A' then +6
    when 'B' then +4
    when 'C' then +2
    when 'F' then +1 # Spaceport
    when 'X' then -4
    else 0
    end
  end

  private def tech_level_adjustment_size(size = @size)
    case size
    when 0, 1 then +2
    when 2..4 then +1
    else 0
    end
  end

  private def tech_level_adjustment_atmosphere(atmosphere = @atmosphere)
    (4..9).includes?(atmosphere) ? 0 : +1
  end

  private def tech_level_adjustment_hydrographics(hydrographics = @hydrographics)
    case hydrographics
    when   9 then +1
    when 0xA then +2
    else 0
    end
  end

  private def tech_level_adjustment_population(population = @population)
    case population
    when     ..3 then +1
    when       9 then +2
    when (0xA..) then +4
    else 0
    end
  end

  private def tech_level_adjustment_government(government = @government)
    case government
    when 0,  5 then +1
    when   0xD then -2
    else 0
    end
  end

  private def tech_level_adjustment
    tech_level_adjustment_port
    + tech_level_adjustment_size
    + tech_level_adjustment_atmosphere
    + tech_level_adjustment_hydrographics
    + tech_level_adjustment_population
    + tech_level_adjustment_government
  end

  private def roll_tech_level : UInt8
    (Dice.roll + tech_level_adjustment).clamp(0, EHex.decode 'Z').to_u8
  end
end
