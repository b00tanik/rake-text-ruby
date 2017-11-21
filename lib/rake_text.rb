require 'lingua/stemmer'

class RakeText

  def initialize
  end

  def analyse(text, stoplist, verbose=false)
    pattern = build_stopword_regex_pattern(stoplist)
    sentences = text.split(/[.!?,;:\t\\\"\(\)\'\u2019\u2013\n\-\—•«»]/u)
    phrases = generate_candidate_keywords(sentences, pattern)
    wordscores = calculate_word_scores(phrases)
    candidates = generate_candidate_keyword_scores(phrases, wordscores)

    if verbose
      result = candidates.sort_by { |k, v| v }.reverse
      result.each do |word, score|
        puts sprintf('%.2f - %s', score, word)
      end
    end

    candidates
  end

  private

  # create stopword pattern
  # 1
  def build_stopword_regex_pattern words
    pattern = Array.new
    words.each do |word|
      pattern.push('\\b'+word+'\\b')
    end

    Regexp.new(pattern.join("|"), Regexp::IGNORECASE)
  end

  # generate candidate keywords
  # 2
  def generate_candidate_keywords sentences, pattern
    phrases = Array.new

    sentences.each do |sentence|
      sentence = sentence.strip

      tmp = sentence.gsub pattern, "|"

      tmp.split("|").each do |part|
        part = part.strip.downcase
        unless part.empty?
          phrases.push(part)
        end
      end
    end

    phrases
  end

  # calculate individual word scores
  # 3
  def calculate_word_scores(phrases)
    word_freq = Hash.new 0
    word_degree = Hash.new 0
    word_score = Hash.new 0

    phrases.each do |phrase|
      words = separate_words(phrase)

      length = words.length
      degree = length-1

      words.each do |word|
        word_freq[word] += 1
        word_degree[word] += degree
      end
    end

    word_freq.each do |word, counter|
      word_degree[word] = word_degree[word] + word_freq[word]
    end

    word_freq.each do |word, counter|
      word_score[word] = word_degree[word]/(word_freq[word] * 1.0)
    end

    word_score
  end

  # generate candidate keyword scores
  # 4
  def generate_candidate_keyword_scores(phrases, scores)
    candidates = Hash.new(0)

    phrases.each do |phrase|
      words = separate_words(phrase)
      score = 0
      words.each do |word|
        score += scores[word]
      end
      candidates[phrase] = score
    end

    candidates
  end

  def separate_words text
    words = Array.new

    text.split(/[^a-zA-Zа-яА-Я0-9_«»]/).each do |word|
      word = word.strip.downcase
      if !word.empty? && !(true if Float(word) rescue false)
        words.push(Lingua.stemmer(word, :language => "ru" ))
      end
    end

    # puts words.inspect

    words
  end

end