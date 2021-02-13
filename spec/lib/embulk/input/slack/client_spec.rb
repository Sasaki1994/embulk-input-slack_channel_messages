require 'embulk/input/slack/client'
require_relative 'config'

RSpec.describe do

  let!(:client) {Slack::Client.new(config[:token])}

  describe '#ch_messages' do
    let(:messages) {client.ch_messages(config[:channel])}

    it 'is hash of array' do
      expect(messages).to be_an_instance_of(Array)
      expect(messages[0]).to be_an_instance_of(Hash)
    end

    it 'has expected keys' do
      expect(messages[0].keys).to include("timestamp", "user_id", "text")
    end
  end

  describe '#members' do
    let(:members) {client.members}

    it 'is hash' do
      expect(members).to be_an_instance_of(Hash)
    end
  end

  describe '#channel_by_id!' do
    let(:channel) {client.channel_by_id!(config[:channel])}

    it 'is hash' do
      expect(channel).to be_an_instance_of(Hash)
    end

    it 'has "name" key' do
      expect(channel.keys).to include("name")
    end

    context 'not found channel id' do
      it 'occurs error' do
        expect{client.channel_by_id!('no_id')}.to raise_error('Error channel_not_found channel id = no_id')
      end
    end
  end

  describe '#channel_by_id' do
    let(:channel) {client.channel_by_id(config[:channel])}

    it 'is hash' do
      expect(channel).to be_an_instance_of(Hash)
    end

    it 'has "name" key' do
      expect(channel.keys).to include("name")
    end

    context 'not found channel id' do
      it 'returns nil' do
        expect(client.channel_by_id('no_id')).to eq nil
      end
    end
  end

  describe '#auth_check' do
    it 'returns true' do
      expect(client.auth_check).to eq true
    end

    context 'token is invalid' do
      it 'returns false' do
        client = Slack::Client.new("invalid token")
        expect(client.auth_check).to eq false
      end
    end
  end
end
