# frozen_string_literal: true
class RefcodeGenerator
  SYMBOLS = %w[
    A B C D E
    F H K L M
    N O P Q R
    S T X Y Z
  ]
  def call
    SYMBOLS.sample(5).join
  end
end
