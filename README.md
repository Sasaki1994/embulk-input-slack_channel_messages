# Slack Channel Messages input plugin for Embulk

input all messages from slack public channels

## Overview

**Plugin type**: input

## Configuration

| name        | type   | requirement | default | description              |
| ----------- | ------ | ----------- | ------- | ------------------------ |
| token       | string | 　 required |         | slack api token          |
| channel_ids | array  | required    |         | slack public channel ids |

using slack apis below

- auth.test
- users.list
- conversations.history
- conversations.info

**We must add an OAuth scopes for using these apis.**

## Example

```yaml
in:
  type: slack_channel_messages
  token: <slack api token>
  channel_ids:
    - <public channel id 1>
    - <public channel id 2>
```

## Build

```
$ rake
```
