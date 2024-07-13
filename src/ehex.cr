module EHex
  extend self

  ALPHABET = "0123456789ABCDEFGHJKLMNPQRSTUVWXYZ"

  def encode(number) : Char
    ALPHABET[number]
  end

  # Returns `nil` if the digit cannot be decoded into eHex.
  def decode(digit : Char) : Int32?
    ALPHABET.index digit.upcase
  end
end
