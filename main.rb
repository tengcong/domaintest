require 'sinatra'
require 'whois'

class Domains < Sinatra::Base

  # SURFIX = ['.com', '.net']
  SURFIX = ['.com']
  # SURFIX = ['.cc', '.me', '.info']

  def initialize
    super
    @limit = Time.now + 60*60*24*7

    @available = []
    @errorz = []
    @recent = []
    run()
  end

  def test domain_name
    begin
      if Whois.whois(domain_name).available?
        @available.push domain_name
      else
        expire = Whois.whois(domain_name).expires_on
        if expire < @limit
          @recent.push({ domain_name => expire.day })
        end
      end
    rescue
      @errorz.push domain_name
    end
  end

  def run
    puts '....start ....'
    numbers = (1 ... 999).to_a
    letters = ('a' .. 'z').to_a
    digitals = (0 .. 9).to_a
    SURFIX.each do |surfix|

      # Thread.new do
      #   digitals.each do |a|
      #     digitals.each do |b|
      #       digitals.each do |c|
      #         domain_name = "#{a}#{b}#{c}#{surfix}"
      #         test domain_name
      #       end
      #     end
      #   end
      # end

      Thread.new do
        letters.each do |a|
          letters.each do |b|
            letters.each do |c|
              letters.each do |d|
                letters.each do |e|
                  letters.each do |f|
                    domain_name = "#{a}#{b}#{c}#{d}#{e}#{f}#{surfix}"
                    test domain_name
                  end
                end
              end
            end
          end
        end
      end

      Thread.new do
        letters.each do |a|
          letters.each do |b|
            letters.each do |c|
              letters.each do |d|
                letters.each do |e|
                    domain_name = "#{a}#{b}#{c}#{d}#{e}#{surfix}"
                  test domain_name
                end
              end
            end
          end
        end
      end
    end
  end


  get '/' do
    "<a href='/availables'>availables</a><br>
    <a href='/recent'>recent</a><br>
    <a href='/errors'>errors</a><br>"
  end

  get '/availables' do
    str = '<ul>'
    @available.each do |domain|
      str << "<li style='float: left; margin-right: 15px'><a href='https://www.name.com/domain/search/#{domain}'>#{domain}</li>"
    end
    str << "</ul>"
    str
  end

  get '/recent' do
    str = '<ul>'
    @recent.each do |domain|
      str << "<li style='float: left; margin-right: 15px'>#{domain}</li>"
    end
    str << "</ul>"
    str
  end

  get '/errors' do
    str = '<ul>'
    @errorz.each do |domain|
      str << "<li style='float: left; margin-right: 15px'>#{domain}</li>"
    end
    str << "</ul>"
    str
  end

end
