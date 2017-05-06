#!/usr/bin/env python3

import datetime as dt
import fileinput
import re

def parse_timestamp(timestamp):
    return str(dt.datetime.fromtimestamp(int(timestamp.group(0))))

for line in fileinput.input():
    print(re.sub(r"\d{10}", parse_timestamp, line), end="")
