require_relative 'slack/service'

module Embulk
  module Input

    class SlackChannelMessages < InputPlugin
      Plugin.register_input("slack_channel_messages", self)
      
      @@columns = [
        ["id", :string],
        ["post_at", :timestamp],
        ["slack_user_id", :string],
        ["slack_username", :string],
        ["slack_channel_name", :string],
        ["message_text", :string],
      ]

      def self.transaction(config, &control)
        # configuration code:
        task = {
          "token" => config.param("token", :string),
          "channel_ids" => config.param("channel_ids", :array),
        }

        columns = @@columns.map.with_index{ |column, index| Column.new(index, *column) }

        resume(task, columns, 1, &control)
      end

      def self.resume(task, columns, count, &control)
        task_reports = yield(task, columns, count)

        next_config_diff = {}
        return next_config_diff
      end

      # TODO
      # def self.guess(config)
      #   sample_records = [
      #     {"example"=>"a", "column"=>1, "value"=>0.1},
      #     {"example"=>"a", "column"=>2, "value"=>0.2},
      #   ]
      #   columns = Guess::SchemaGuess.from_hash_records(sample_records)
      #   return {"columns" => columns}
      # end

      def init
        @token = task["token"]
        @channel_ids = task["channel_ids"]
        @service = Slack::Service.new(@token)
      end

      def run
        @service.check_token
        @service.check_channels(@channel_ids)
        @channel_ids.each do |channel_id|
          @service.compose_record(channel_id) do |record|
            # ex) page_builder.add([<col1>, <col2>, <col3> ...])
            page_builder.add(@@columns.map{|col| record[col[0]]})
          end
        end
        page_builder.finish

        task_report = {}
        return task_report
      end
    end

  end
end
