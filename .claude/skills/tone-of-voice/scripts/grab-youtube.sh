#!/bin/bash

# Grab YouTube Transcript — Tone of Voice Skill
# Two modes:
#   list:  ./grab-youtube.sh list "CHANNEL_URL" [count]  — list top videos by views
#   grab:  ./grab-youtube.sh grab "VIDEO_URL"             — extract transcript
#
# Output: transcript text or video list to stdout

if [ $# -lt 2 ]; then
    echo "Usage:"
    echo "  $0 list <channel-url> [count]    — list top videos by view count"
    echo "  $0 grab <video-url>              — extract transcript from video"
    exit 1
fi

MODE="$1"
URL="$2"

if ! command -v yt-dlp >/dev/null 2>&1; then
    echo "Error: yt-dlp is not installed — it's required for the YouTube ingestion path." >&2
    echo "Install it (https://github.com/yt-dlp/yt-dlp), or instead paste a blog URL or text." >&2
    exit 1
fi

case "$MODE" in
    list)
        COUNT="${3:-5}"
        echo "--- grab-youtube: listing top $COUNT videos from $URL ---" >&2

        # Get video list sorted by view count (most viewed first)
        yt-dlp --flat-playlist --print "%(view_count)s %(id)s %(title)s" \
            --playlist-end 50 \
            "$URL" 2>/dev/null | \
            sort -rn | \
            head -n "$COUNT" | \
            while read -r views id title; do
                echo "$id | $title | ${views} views"
            done

        echo "--- grab-youtube: list complete ---" >&2
        ;;

    grab)
        echo "--- grab-youtube: extracting transcript from $URL ---" >&2

        # Try auto-generated subtitles first, then manual
        TRANSCRIPT=$(yt-dlp --write-auto-sub --sub-lang en --skip-download \
            --print-to-file "%(subtitles.en.-1.ext)s" /dev/null \
            -o "/tmp/tone-of-voice-yt-%(id)s" \
            "$URL" 2>/dev/null && \
            cat /tmp/tone-of-voice-yt-*.vtt 2>/dev/null | \
            sed '/^$/d; /^[0-9]/d; /-->/d; /WEBVTT/d; /Kind:/d; /Language:/d' | \
            awk '!seen[$0]++')

        if [ -n "$TRANSCRIPT" ] && [ ${#TRANSCRIPT} -gt 100 ]; then
            echo "$TRANSCRIPT"
            echo "--- grab-youtube: success (${#TRANSCRIPT} chars) ---" >&2
            rm -f /tmp/tone-of-voice-yt-*.vtt 2>/dev/null
            exit 0
        fi

        # Fallback: try yt-dlp subtitle extraction in different format
        TRANSCRIPT=$(yt-dlp --write-sub --write-auto-sub --sub-lang en \
            --sub-format "srt" --skip-download \
            -o "/tmp/tone-of-voice-yt-%(id)s" \
            "$URL" 2>/dev/null && \
            cat /tmp/tone-of-voice-yt-*.srt 2>/dev/null | \
            sed '/^$/d; /^[0-9]*$/d; /-->/d' | \
            awk '!seen[$0]++')

        if [ -n "$TRANSCRIPT" ] && [ ${#TRANSCRIPT} -gt 100 ]; then
            echo "$TRANSCRIPT"
            echo "--- grab-youtube: success via srt fallback (${#TRANSCRIPT} chars) ---" >&2
            rm -f /tmp/tone-of-voice-yt-*.srt 2>/dev/null
            exit 0
        fi

        rm -f /tmp/tone-of-voice-yt-* 2>/dev/null
        echo "--- grab-youtube: no transcript available for $URL ---" >&2
        exit 1
        ;;

    *)
        echo "Unknown mode: $MODE. Use 'list' or 'grab'."
        exit 1
        ;;
esac
