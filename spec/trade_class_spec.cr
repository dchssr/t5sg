require "./spec_helper"

describe T5SG do
  describe TradeClass do
    it "classifies the example" do
      # Regina, Spinward Marches. Example given from the book.
      regina = World.new "A788899-C"

      TradeClass["Ri"].applies_to?(regina).should be_true
      TradeClass["Pa"].applies_to?(regina).should be_true
      TradeClass["Ph"].applies_to?(regina).should be_true
      TradeClass["Va"].applies_to?(regina).should be_false
      # Cp (Capital) and An (Ancients' site) are setting/fiction
      # and don't count as something we *can* generate.
    end
  end
end
