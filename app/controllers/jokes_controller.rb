class JokesController < ApplicationController
  SAMPLE_XML = <<~XML.freeze
    <root>
      <workshops>
        <workshop>Docker Workshop</workshops>
      </workshops>
    </root>
  XML

  def index
    json = { joke: joke, workshop: workshop_name, info: os_information }
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
end
