require 'sinatra'
require 'whois'

SURFIX = ['.com', '.net']

numbers = (1 ... 999).to_a
letters = ('a' .. 'z').to_a
digitals = (0 .. 9).to_a

limit = Time.now + 60*60*24*7

available = []
errorz = []
recent = []

def test domain_name, available, errorz
  begin
    if Whois.whois(domain_name).available?
      available.push domain_name
    else
      expire = Whois.whois(domain_name).expires_on
      if expire < limit
        recent.push({ domain_name => expire.day })
      end
    end
  rescue
    errorz.push domain_name
  end
end

SURFIX.each do |surfix|

  Thread.new do
    letters.each do |a|
      letters.each do |b|
        letters.each do |c|
          domain_name = "#{a}#{b}#{c}#{surfix}"
          # puts "test: #{domain_name} ..."
          test domain_name, available, errorz
        end
      end
    end
  end

  Thread.new do
    digitals.each do |d|
      letters.each do |a|
        letters.each do |b|
          domain_name = "#{a}#{b}#{d}#{surfix}"
          logger.info "test: #{domain_name} ..."
          test domain_name, available, errorz

          domain_name = "#{b}#{a}#{d}#{surfix}"
          logger.info "test: #{domain_name} ..."
          test domain_name, available, errorz

          domain_name = "#{b}#{d}#{a}#{surfix}"
          logger.info "test: #{domain_name} ..."
          test domain_name, available, errorz

          domain_name = "#{a}#{d}#{b}#{surfix}"
          logger.info "test: #{domain_name} ..."
          test domain_name, available, errorz

          domain_name = "#{d}#{a}#{b}#{surfix}"
          logger.info "test: #{domain_name} ..."
          test domain_name, available, errorz

          domain_name = "#{d}#{b}#{a}#{surfix}"
          logger.info "test: #{domain_name} ..."
          test domain_name, available, errorz

        end
      end
    end
  end

  Thread.new do
    digitals.each do |a|
      digitals.each do |b|
        letters.each do |d|
          domain_name = "#{a}#{b}#{d}#{surfix}"
          logger.info "test: #{domain_name} ..."
          test domain_name, available, errorz

          domain_name = "#{b}#{a}#{d}#{surfix}"
          logger.info "test: #{domain_name} ..."
          test domain_name, available, errorz

          domain_name = "#{b}#{d}#{a}#{surfix}"
          logger.info "test: #{domain_name} ..."
          test domain_name, available, errorz

          domain_name = "#{a}#{d}#{b}#{surfix}"
          logger.info "test: #{domain_name} ..."
          test domain_name, available, errorz

          domain_name = "#{d}#{a}#{b}#{surfix}"
          logger.info "test: #{domain_name} ..."
          test domain_name, available, errorz

          domain_name = "#{d}#{b}#{a}#{surfix}"
          logger.info "test: #{domain_name} ..."
          test domain_name, available, errorz
        end
      end
    end
  end

  Thread.new do
    digitals.each do |a|
      digitals.each do |b|
        digitals.each do |c|
          domain_name = "#{a}#{b}#{c}x#{surfix}"
          # puts "test: #{domain_name} ..."
          test domain_name, available, errorz
        end
      end
    end
  end

  Thread.new do
    digitals.each do |a|
      digitals.each do |b|
        digitals.each do |c|
          digitals.each do |d|
            domain_name = "#{a}#{b}#{c}#{d}#{surfix}"
            # puts "test: #{domain_name} ..."
            test domain_name, available, errorz
          end
        end
      end
    end
  end

  Thread.new do
    digitals.each do |a|
      digitals.each do |b|
        digitals.each do |c|
          digitals.each do |d|
            digitals.each do |e|
              domain_name = "#{a}#{b}#{c}#{d}#{e}#{surfix}"
              # puts "test: #{domain_name} ..."
              test domain_name, available, errorz
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
  available.each do |domain|
    str << "<li>#{domain}</li>"
  end
  str << "</ul>"
  str
end

get '/recent' do
  str = '<ul>'
  recent.each do |domain|
    str << "<li>#{domain}</li>"
  end
  str << "</ul>"
  str
end

get '/errors' do
  str = '<ul>'
  errorz.each do |domain|
    str << "<li>#{domain}</li>"
  end
  str << "</ul>"
  str
end
