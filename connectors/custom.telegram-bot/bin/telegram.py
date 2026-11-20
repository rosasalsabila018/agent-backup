#!/usr/bin/env python3
"""Telegram Bot API helper for the custom.telegram-bot connector.

The bot token lives in the registered connection custom.telegram-bot and is
never present in this file. Requests go through dynamic_credentials, which
places an hsurr: surrogate in the URL path; authd swaps in the real token
only on approved egress to api.telegram.org. Never print the request URL.
"""

import argparse
import json
import sys
import urllib.request

sys.path.insert(0, "/opt/muse/skills/custom-connector-setup/bin")
from dynamic_credentials import (
    read_json_response,
    url_with_surrogate_path_segment,
)

CREDENTIAL = "custom.telegram-bot"
HOSTS = ["api.telegram.org"]
BASE = "https://api.telegram.org/bot{}/"


class NoRedirect(urllib.request.HTTPRedirectHandler):
    def redirect_request(self, *args):
        raise RuntimeError("redirect refused, verify the endpoint")


def call(method, data=None):
    url = url_with_surrogate_path_segment(
        BASE + method, CREDENTIAL, allowed_hosts=HOSTS
    )
    body = None
    headers = {}
    if data is not None:
        body = json.dumps(data).encode("utf-8")
        headers["Content-Type"] = "application/json"
    request = urllib.request.Request(url, data=body, headers=headers, method="POST")
    with urllib.request.build_opener(NoRedirect()).open(request, timeout=30) as response:
        return read_json_response(response)


def main():
    parser = argparse.ArgumentParser(description="Telegram Bot API helper")
    sub = parser.add_subparsers(dest="command", required=True)

    sub.add_parser("getme", help="Verify the token and show the bot identity")

    send = sub.add_parser("sendmessage", help="Send a text message to a chat")
    send.add_argument("--chat-id", required=True)
    send.add_argument("--text", required=True)

    updates = sub.add_parser("getupdates", help="Poll pending updates")
    updates.add_argument("--offset", type=int, default=None)
    updates.add_argument("--timeout", type=int, default=0)

    args = parser.parse_args()
    if args.command == "getme":
        print(json.dumps(call("getMe")))
    elif args.command == "sendmessage":
        print(json.dumps(call("sendMessage", {"chat_id": args.chat_id, "text": args.text})))
    elif args.command == "getupdates":
        payload = {}
        if args.offset is not None:
            payload["offset"] = args.offset
        if args.timeout:
            payload["timeout"] = args.timeout
        print(json.dumps(call("getUpdates", payload)))


if __name__ == "__main__":
    main()
