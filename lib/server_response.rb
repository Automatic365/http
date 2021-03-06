require_relative "request_parser"
require_relative "word_search"

 class ServerResponse

  def format_response(request_lines)
    parser = RequestParser.new(request_lines)
    parser.voltron
    @request = parser.request
    path_check
  end


  def path_check
    if datetime_check
      date
    elsif word_search_check
      word_search
    else
      response_body_formatter
    end
  end

  def datetime_check
    @request["Path:"] == "/datetime"
  end

  def word_search_check
    @request["Path:"].include?("/word_search")
  end

  def date
    Time.now.strftime('%l:%M%p on %A, %B %e, %Y')
  end

  def response_body_formatter
    @request.to_a.map{|line|"\n#{line.first} #{line.last}"}.join
  end

  def word_search
    searcher = WordSearch.new
    word = @request["Path:"].split("=").last
    searcher.word_validation(word)
  end

end
