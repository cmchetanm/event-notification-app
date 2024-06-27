require 'net/http'
require 'json'
class IterableService
  BASE_URL = "https://api.iterable.com/api"
  attr_reader :api_key, :user, :campaign_id

  def initialize(user_id)
    @api_key = Rails.application.credentials.iterable[:api_key]
  	@user = User.find_by(id: user_id)
    @campaign_id = 0
  end

  def get_user_events
	  get_request("events/#{user.email}")
  end

  def create_user_event(event_type)
    payload = {
      email: user.email,
      userId: user.id,
      eventName: event_type,
      id: '8dcd0a1a-0ed2-4683-ba94-c8f5d9357ec1',
      createdAt: Time.now.to_i,
      dataFields: {},
      campaignId: campaign_id,
      templateId: 0,
      createNewFields: true
    }
    post_request("events/track", payload)
  end

  def send_email_notification
  	payload = {
      campaignId: campaign_id,
      recipientEmail: user.email,
      recipientUserId: user.id,
      dataFields: {},
      sendAt: Time.now.to_i,
      allowRepeatMarketingSends: true,
      metadata: {}
    }
    post_request("email/target", payload)
  end

  def get_request(path, params = {})
    uri = create_uri(path, params)
    make_request(Net::HTTP::Get, uri)
  end

  def post_request(path, payload = {})
    uri = create_uri(path)
    make_request(Net::HTTP::Post, uri, payload)
  end

  private

  def create_uri(path, params = {})
    uri = URI.parse("#{BASE_URL}/#{path}")
    uri.query = URI.encode_www_form(params) unless params.empty?
    uri
  end

  def make_request(request_type, uri, data = nil)
    http = Net::HTTP.new(uri.hostname, uri.port)
    http.use_ssl = true
    request = request_type.new(uri)
    request.content_type = 'application/json'
    request["Api-Key"] = api_key
    request.body = data.to_json if data
    response = http.request(request)
    handle_response(response)
  end

  def handle_response(response)
    case response
    when Net::HTTPSuccess
      JSON.parse response.body
    else
      puts 'failed'
    end
  end
end
