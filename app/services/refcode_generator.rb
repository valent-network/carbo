# frozen_string_literal: true
class RefcodeGenerator
  # rubocop:disable Layout/MultilineArrayLineBreaks
  SYMBOLS = %w[
    A B C D E
    F H K L M
    N O P Q R
    S T X Y Z
  ]
  # rubocop:enable Layout/MultilineArrayLineBreaks
  def call
    SYMBOLS.sample(5).join
  end
end
