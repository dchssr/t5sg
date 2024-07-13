module Dice
  extend self

  def roll(amount : UInt32 = 1) : Int32
    amount.times.sum { rand(6).succ }
  end

  def flux : Int32
    roll - roll
  end
end
