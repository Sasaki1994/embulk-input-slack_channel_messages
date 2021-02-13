# Slack Channel Messages input plugin for Embulk

input all messages of slack public channels

## Overview

- **Plugin type**: input
- **Resume supported**: yes
- **Cleanup supported**: yes
- **Guess supported**: no

## Configuration

- **token**: slack api token (string, required)
- **channel_ids**: array of slack public channel ids (array, required)

using slack apis below

- auth.test
- users.list
- conversations.history
- conversations.info

We must add an OAuth scopes for using these apis.

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
