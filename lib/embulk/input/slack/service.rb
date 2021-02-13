require_relative 'client'
module Slack
    class Service
        attr_reader :token
        
        def initialize(token)
            @token = token
            @client = Client.new(@token)
        end

        def compose_record(channel_id, &block)
            """
            Compose embulk insert record.
            
            params:
                slack public channel id (string)
                embulk insert method (block)
            """
            members = get_members
            channel = get_channel(channel_id)
            messages = get_messages(channel_id)

            messages.each do |message|
                record = {
                    'id' => "#{channel_id}-#{message['timestamp'].to_i}-#{message['user_id']}",
                    'post_at' => Time.at(message['timestamp'].to_i),
                    'slack_user_id' => message['user_id'],
                    'slack_username' => members[message['user_id']],
                    'slack_channel_name' => channel['name'],
                    'message_text' => message['text']
                }
                block.call(record)
            end
        end

        def get_members
            @client.members
        end

        def get_channel(channel_id)
            @client.channel_by_id!(channel_id)
        end

        def get_messages(channel_id)
            @client.ch_messages(channel_id)
        end

        def check_token
            raise 'Error token is invalid' unless @client.auth_check
        end

        def check_channels(channel_ids)
            channel_ids.each do |ch_id|
                @client.channel_by_id!(ch_id)
            end
        end
    end
end