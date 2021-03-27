#!/usr/bin/env python3
import datetime
import json
import sys
import isodate
from humanfriendly import parse_timespan

TIME_FORMAT = "%Y%m%dT%H%M%SZ"
UDA_REMAIN = "budget"
UDA_TOTAL = "elapsed"


def to_rounded_delta(delta, now=None):
    if isinstance(delta, isodate.Duration):
        return datetime.timedelta(seconds=int(delta.totimedelta(now).total_seconds()))
    else:
        return datetime.timedelta(seconds=int(delta.total_seconds()))


# Convert duration string into a timedelta object.
# Valid formats for duration_str include
# - int (in seconds)
# - string ending in seconds e.g "123seconds"
# - ISO-8601: e.g. "PT1H10M31S"
def duration_str_to_time_delta(duration_str):
    if duration_str.startswith("P"):
        match = isodate.parse_duration(duration_str)
        now = datetime.datetime.utcnow()
        if isinstance(match, isodate.Duration):
            return to_rounded_delta(match, now)
        else:  # isinstance(match, datetime.timedelta):
            return to_rounded_delta(match)
    return datetime.timedelta(seconds=int(parse_timespan(str(duration_str))))


def human_iso(date):
    f = isodate.duration_isoformat(date).lower()
    # print("date is %s, f is %s" % (date, f))
    if f.find("%p") != -1:
        return date

    if f.startswith("p"):
        f = f.lstrip("p")
        if f.find("d") != -1:
            days, f = f.split("d")
        else:
            days = 0
    else:
        days = 0
    if f.startswith("t"):
        f = f.lstrip("t")
        if f.find("h") != -1:
            hours, f = f.split("h")
        else:
            hours = 0
    else:
        hours = 0

    days = int(days) * 24
    hours = int(hours) + days
    return "%sh%s" % (hours, f)


def main():
    try:
        input_stream = sys.stdin.buffer
    except AttributeError:
        input_stream = sys.stdin

    original = json.loads(input_stream.readline().decode("utf-8", errors="replace"))
    modified = json.loads(input_stream.readline().decode("utf-8", errors="replace"))

    # An active task has just been stopped.
    if "start" in original and "start" not in modified:
        # Let's see how much time has elapsed
        start = datetime.datetime.strptime(original["start"], TIME_FORMAT)
        end = datetime.datetime.utcnow()

        if UDA_TOTAL not in modified:
            modified[UDA_TOTAL] = "0s"

        this_duration = to_rounded_delta(end - start)
        total_duration = this_duration + to_rounded_delta(
            duration_str_to_time_delta("PT" + human_iso(modified[UDA_TOTAL]).upper())
        )
        total_duration = human_iso(total_duration)
        print(
            "Time Tracked: %s (%s total)"
            % (
                human_iso(this_duration),
                total_duration,
            )
        )
        modified[UDA_TOTAL] = total_duration
        if UDA_REMAIN in modified:
            remain_duration = (
                to_rounded_delta(
                    duration_str_to_time_delta(
                        "PT" + human_iso(modified[UDA_REMAIN]).upper()
                    )
                )
                - this_duration
            )

            remain_duration = human_iso(remain_duration)
            print(
                "              %s (%s remaining)"
                % (
                    " " * len(str(human_iso(this_duration))),
                    remain_duration,
                )
            )
            modified[UDA_REMAIN] = remain_duration

    return json.dumps(modified)


def cmdline():
    sys.stdout.write(main())


if __name__ == "__main__":
    cmdline()
