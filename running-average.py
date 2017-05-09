#!/usr/bin/env python3

from parse import entries

for entry in entries:
    print('{}\t{}'.format(entry.capture_end_timestamp, entry.mood))
