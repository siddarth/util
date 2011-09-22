require 'rubygems'
require 'mechanize'
require 'yaml'

class Carmen
  CONFIG_PATH = 'carmen.conf'

  def initialize(country, name, email)

    @country, @name, @email = country, name, email

    # load config
    @@config = YAML.load_file(CONFIG_PATH)

    # initialize agent
    @agent = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }
  end

  def is_response_success(body)
    body.include? 'Your response has been recorded.'
  end

  def submit_form()
    puts "Making request..."
    @agent.get(@@config['url']) do |page|
      form = page.forms.first
      form['entry.0.single'] = @country
      form['entry.1.single'] = @name
      form['entry.2.single'] = @email
      form['submit'] = 'Submit'
      result = form.submit
      raise 'Failure. :-(' unless is_response_success(result.body)
      puts 'Success.'
    end
  end

end