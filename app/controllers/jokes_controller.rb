class JokesController < ApplicationController
  SAMPLE_XML = <<~XML.freeze
    <root>
      <workshops>
        <workshop>Docker Workshop</workshops>
      </workshops>
    </root>
  XML

  def index
    json = {
      joke: joke,
      server: server_identifier,
      redis_id: redis_id,
      workshop: workshop_name,
      info: os_information,
      version: ENV['APP_VERSION'] || 'No env var with version'
    }
    render json: json
  end

  private

  def joke
    ChuckNorris::JokeFinder.get_joke(category: 'nerdy').joke
  end

  def os_information
    Gem::Platform.local
  end

  def workshop_name
    xml_doc  = Nokogiri::XML(SAMPLE_XML)
    xml_doc.at('.//workshops/workshop').text
  rescue
    'Ops Nokogiri is not working!'
  end

  def server_identifier
    if File.exists?(server_id_path)
      File.read(server_id_path)
    else
      name = server_id
      File.open(server_id_path, 'w') { |f| f.write(name) }
      name
    end
  end

  def server_id
    "#{Faker::StarWars.planet}-#{Faker::StarWars.specie}-" \
    "#{SecureRandom.hex(4)}".parameterize
  end

  def server_id_path
    "#{Rails.root}/tmp/pids/server_id"
  end

  def redis_id
    redis.info['run_id']
  rescue Exception => e
    e.message
  end

  def redis
    @redis ||= redis = Redis.new(url: redis_url)
  end

  def redis_url
    ENV['REDIS_URL'] || 'redis://localhost:6379'
  end
end
