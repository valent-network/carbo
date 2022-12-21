# frozen_string_literal: true
class AlphabetSort
  ALPHABETS = {
    uk: %w[
      а б в г ґ д е є ж з и
      і ї й к л м н о п р с
      т у ф х ц ч ш щ ь ю я
    ],
  }
  def self.call(array, language = :uk)
    alphabet = ALPHABETS[language]

    unless alphabet
      return array.sort
    end

    array.sort do |a, b|
      a_chars = a.chars.map(&:downcase).reject(&:blank?).reject { |c| alphabet.exclude?(c) }
      b_chars = b.chars.map(&:downcase).reject(&:blank?).reject { |c| alphabet.exclude?(c) }

      while a_chars.first == b_chars.first
        break if a_chars.first.nil? || b_chars.first.nil?

        a_chars.shift
        b_chars.shift
      end

      a_char = a_chars.first.present? ? alphabet.index(a_chars.first) : Float::INFINITY
      b_char = b_chars.first.present? ? alphabet.index(b_chars.first) : Float::INFINITY

      if a_char < b_char
        -1
      elsif a_char > b_char
        1
      else
        0
      end
    end
  end
end
