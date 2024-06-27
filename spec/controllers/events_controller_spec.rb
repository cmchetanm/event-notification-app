require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:user) { create(:user, email: 'test@example.com') }
  let(:event_a_payload) do
    {
      email: user.email,
      userId: user.id,
      eventName: 'EventA',
      id: '8dcd0a1a-0ed2-4683-ba94-c8f5d9357ec1',
      createdAt: Time.now.to_i,
      dataFields: {},
      campaignId: 0,
      templateId: 0,
      createNewFields: true
    }
  end

  let(:event_b_payload) do
    {
      email: user.email,
      userId: user.id,
      eventName: 'EventB',
      id: '8dcd0a1a-0ed2-4683-ba94-c8f5d9357ec1',
      createdAt: Time.now.to_i,
      dataFields: {},
      campaignId: 0,
      templateId: 0,
      createNewFields: true
    }
  end

  let(:email_body) do
    {
      campaignId: 0,
      recipientEmail: user.email,
      recipientUserId: user.id,
      dataFields: {},
      sendAt: Time.now.to_i,
      allowRepeatMarketingSends: true,
      metadata: {}
    }
  end

  let(:headers) do
    {
      'Accept'=>'*/*',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Content-Type'=>'application/json',
      'Host'=>'api.iterable.com',
      'User-Agent'=>'Ruby'
    }
  end

  before do
    sign_in user
  end

  describe 'GET #index' do
    before do
      stub_request(:get, "https://api.iterable.com/api/events/test@example.com")
        .with(
          headers: headers)
        .to_return(status: 200, body: '[]', headers: {})
    end

    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'POST #create_event' do
    context 'when event type is EventA' do
      before do
        stub_request(:post, "https://api.iterable.com/api/events/track")
          .with(body: event_a_payload.to_json,
                headers: headers)
          .to_return(status: 200, body: '{"msg": "Event created"}', headers: {})
      end

      it 'creates EventA successfully' do
        post :create, params: { event_type: 'EventA' }

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('EventA created successfully.')
      end
    end

    context 'when event type is EventB' do
      before do
        stub_request(:post, "https://api.iterable.com/api/events/track")
          .with(body: event_b_payload.to_json,
                headers: headers)
          .to_return(status: 200, body: '{"msg": "Event created"}', headers: {})

        stub_request(:post, "https://api.iterable.com/api/email/target")
          .with(body: email_body.to_json,
                headers: headers)
          .to_return(status: 200, body: '{"msg": "Email sent"}', headers: {})
      end

      it 'creates EventB and sends email successfully' do
        post :create, params: { event_type: 'EventB' }

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('EventB created successfully. Email sent.')
      end
    end
  end
end
