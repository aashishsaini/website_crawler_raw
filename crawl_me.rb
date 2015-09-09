require 'open-uri'

INPUT = /<input/
class CrawlMe

  def initialize(url)
    @url = url
  end

  def count_input
    calc_result = {}
    
    inputs_level_1 = 0
    children(@url).each do |level_1|
      inputs_level_2 = 0
      children(level_1).each do |level_2|
        inputs_level_3 = 0
        children(level_2).each do |level_3|
          input_count = input_count(content(level_3))
          calc_result[level_3] = input_count
          inputs_level_3 += input_count
        end

        input_count = inputs_level_3 + input_count(content(level_2))
        calc_result[level_2] = input_count
        inputs_level_2 += input_count
      end

      input_count = inputs_level_2 + input_count(content(level_1))
      calc_result[level_1] = input_count
      inputs_level_1 += input_count
    end

  calc_result[@url] = inputs_level_1 + input_count(content(@url))
  reform_result(calc_result)
end

private
  def content(url)
    open(url).read
  end

  def children(url)
    URI.extract(content(url), %w{http https})
  end

  def input_count(content)
    content.scan(INPUT).size
  end

  def reform_result(calc_result)
    calc_result.each do |url, count|
      puts "#{url} - #{count} input#{'s' if count > 1}"
    end
  end
end