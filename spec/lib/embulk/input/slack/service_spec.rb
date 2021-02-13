require 'embulk/input/slack/service'

RSpec.describe do

  describe '#compose_record' do
    it 'A record is correct hash' do
      service = Slack::Service.new("token")
      allow(service).to receive(:get_members).and_return({"A00AAA00" => "sample_user"})
      allow(service).to receive(:get_channel).and_return({"name" => "sample_channel"})
      allow(service).to receive(:get_messages).and_return([{
        'timestamp' => 111111.1111,
        'user_id' => "A00AAA00",
        'text' => "sample message"
      }]) 

      ex_record = {
          'id' => "channel_id-111111-A00AAA00",
          'post_at' => Time.at(111111),
          'slack_user_id' => "A00AAA00",
          'slack_username' => "sample_user",
          'slack_channel_name' => "sample_channel",
          'message_text' => "sample message"
      }
      
      service.compose_record("channel_id") do |record|
        expect(record).to eq ex_record
      end
    end
  end
end