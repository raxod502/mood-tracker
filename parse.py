#!/usr/bin/env python3

import datetime as dt
import os
import re

DIRECTORY = os.path.split(os.path.realpath(__file__))[0]
LOG_FILE = os.path.join(DIRECTORY, "moods.log")

class Entry:
    def __init__(self, format_version, mood, comment, notification_timestamp,
                 capture_start_timestamp, capture_end_timestamp):
        self.format_version = format_version
        self.mood = mood
        self.comment = comment
        self.notification_timestamp = notification_timestamp
        self.capture_start_timestamp = capture_start_timestamp
        self.capture_end_timestamp = capture_end_timestamp

def parse_timestamp(timestamp):
    return dt.datetime.fromtimestamp(int(timestamp)) if timestamp else None

entries = []
with open(LOG_FILE) as f:
    for line in f:
        fields = line.split(":")[1:-1]
        format_version, mood = fields[:2]
        merged_comment = ":".join(fields[2:-3])
        comment = re.sub(r"\\([:\\])", lambda match: match.group(1), merged_comment)
        notification_timestamp, capture_start_timestamp, capture_end_timestamp = fields[-3:]
        entries.append(Entry(
            int(format_version),
            int(mood),
            comment,
            parse_timestamp(notification_timestamp),
            parse_timestamp(capture_start_timestamp),
            parse_timestamp(capture_end_timestamp)
        ))
