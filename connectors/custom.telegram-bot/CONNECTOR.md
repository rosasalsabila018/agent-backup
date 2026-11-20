# Telegram Bot

- `custom.telegram-bot` connects Muse to the Telegram Bot API. It authenticates with the registered `api_key` credential and calls only `api.telegram.org`.

- Helpers live in `~/workspace/custom-connectors/custom.telegram-bot/bin/`. `telegram.py` wraps the Bot API with `getme`, `sendmessage --chat-id --text` and `getupdates [--offset] [--timeout]`.

## Connect

- The connection was registered with `credentials.request_api_access` and these details. Reuse them to reconnect. The placement cannot be read back later, and no key or token is recorded here:

```json
{
  "provider": "telegram-bot",
  "auth_scheme": "api_key",
  "placement": "url_path_segment:/bot{}/",
  "api_hosts": ["api.telegram.org"]
}
```

- Before the first change in a conversation, prove access with a harmless read:

```text
python3 ~/workspace/custom-connectors/custom.telegram-bot/bin/telegram.py getme
```

- Status 2026-11-18: the stored credential was verified as present (surrogate issued, placement `url_path_segment: /bot{}/`), but `getMe` returned HTTP 404 Not Found from Telegram, which means Telegram does not recognise the stored token. The token needs to be re-entered cleanly from @BotFather (`/mybots`, pick the bot, API Token, copy the full token) with `reconnect: true`.

## Credentials

- The registered connection holds the credential. Helpers import `/opt/muse/skills/custom-connector-setup/bin/dynamic_credentials.py`, which returns an `hsurr:` surrogate and places it where the provider reads the key. Muse swaps in the real credential only on an approved request to a registered host.

- Never put a key, token, password or cookie in this doc, a helper, a command argument, an environment variable or a log. Never ask the user to paste one in chat.

- Keep redirects disabled on authenticated requests.

- On a 401 or 403, check the request first. Confirm that the helper attached the credential, that the host is registered and that the placement and scopes match.

- Only when a request that carried the credential is still rejected, call `credentials.request_api_access` with the details above and `"reconnect": true`.

## Verify the bot

- `getme` verifies the token and returns the bot identity. Read `result.id`, `result.username` and `result.first_name` from the response.

```text
python3 ~/workspace/custom-connectors/custom.telegram-bot/bin/telegram.py getme
```

- Untested: `sendmessage` and `getupdates`. Both go through the same surrogate path, but neither has been run against a verified token yet.

## Recover from errors

- HTTP 404 from `getMe` means Telegram does not recognise the token. Re-enter the token from @BotFather with `reconnect: true`, copying the full token without extra spaces.

- HTTP 401 or 403 means the credential was rejected. Check that the helper attached the credential, that the host is registered and that the placement matches, then reconnect only if a request that carried the credential is still rejected.

- After a failed or timed-out change, check the current state with a read before trying again, because the first request may have completed.

## Limits

- The connector can call the Telegram Bot API, but it cannot configure the Hermes gateway. The gateway reads its own token from `~/.hermes/.env` (`TELEGRAM_BOT_TOKEN`), which the vault cannot write, so the token has to be placed there separately.

- The gateway also needs access control in `~/.hermes/.env`. James wants the bot open to everyone, so set `TELEGRAM_ALLOW_ALL_USERS=true` and do not set `TELEGRAM_ALLOWED_USERS` (the gateway denies by default). To restrict it to one user instead, set `TELEGRAM_ALLOWED_USERS` to a comma-separated list of numeric user IDs.

## Related skills

- Use `muse.skill_search` to find other skills and `muse.connector_search` to find other connectors.
