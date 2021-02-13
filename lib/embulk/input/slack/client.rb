require 'net/http'
require 'uri'
require 'json'

module Slack
    class Client
      attr_reader :token
  
      def initialize(token)
        @token = token
      end
  
      def ch_messages(channel_id)
        """
        Get all channel messages by channel_id using conversations.history api.
        This API can only retrieve up to 1000 at a time, so we use 'next_cusor' to retrieve them recursively.

        conversations.history api
        https://api.slack.com/methods/conversations.history

        params: slack public channel id (string)
        return: all channel messages with datetime and user id (Array[Array])
        """
        messages = []
        cursor = nil
        begin
            res = JSON.parse(get('conversations.history', {channel: channel_id, limit: 1000, cursor: cursor}))
            
            messages += res['messages'].select{ |message| message['type'] == 'message' }.map do |message|
                {
                    'timestamp' => message['ts'],
                    'user_id' => message['user'],
                    'text' => message['text']
                }
            end
            
            cursor = res['response_metadata']&.[]('next_cursor') || ''
        end until cursor == ''
        messages
      end
  
      def members
        """
        Get all members using users.list api.
        This API is limited at a time, so we use 'next_cusor' to retrieve them recursively.

        users.list api
        https://api.slack.com/methods/users.list

        return: all user id(key) and name(value) store (Hash)
        """
        members = {}
        cursor = nil
        begin
            res = JSON.parse(get('users.list', {limit: 1000, cursor: cursor}))
            raise "Error '#{res['error']}'" unless res['ok']
            
            res['members'].each do |member|
                members[member['id']] = member['profile']['display_name']
            end
            
            cursor = res['response_metadata']&.[]('next_cursor') || ''
        end until cursor == ''
        members
      end
  
      def channel_by_id!(ch_id)
        """
        Get channel information by channel_id using conversations.info api.

        conversations.info api
        https://api.slack.com/methods/conversations.info

        params: slack public channel id (string)
        return: channel object (hash) 
        """
        res = JSON.parse(get('conversations.info', {channel: ch_id}))
        raise "Error #{res['error']} channel id = #{ch_id}" unless res['ok']
        res['channel']
      end

      def channel_by_id(ch_id)
        res = JSON.parse(get('conversations.info', {channel: ch_id}))
        return nil unless res['ok']
        res['channel']
      end

      def auth_check
        """
        Do auth check test using auth.test api.

        auth.test api
        https://api.slack.com/methods/auth.test

        return: is successed to api request with @token auth (bool)
        """
        res = JSON.parse(post('auth.test'))
        raise 'Slack API Server Error' unless res.has_key?("ok")
        res["ok"]
      end

      private
      def slack_uri(api, params=nil)
        uri = URI.parse("https://slack.com/api/#{api}")
        uri.query = URI.encode_www_form(params) if params
        uri
      end

      def get(api, options = {})
        Net::HTTP.get(slack_uri(api, options.merge(token: token)))
      end

      def post(api, options = {})
        Net::HTTP.post_form(slack_uri(api), options.merge(token: token)).body
      end
    end
end
  