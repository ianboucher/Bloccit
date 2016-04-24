module RandomData

  def self.random_paragraph
    sentences = []
    # Create 4 - 6 random sentences
    rand(4..6).times do
      sentences << random_sentence
    end
    # Use join to combine sentences into paragraphs.
    sentences.join(" ")
  end

  def self.random_sentence
    strings = []
    rand(3..8).times do
      strings << random_word
    end

    sentence = strings.join(" ")
    sentence.capitalize << "."
  end

  def self.random_word
    letters = ('a'..'z').to_a
    letters.shuffle!
    # Join 0th - nth item in letters. nth is the result of rand(3..8)
    letters[0, rand(3..8)].join
  end
end
