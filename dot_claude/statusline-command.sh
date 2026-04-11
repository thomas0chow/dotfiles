#!/usr/bin/env bash
# Claude Code status line — model, context usage, session tokens, plan usage, time

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
total_in=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
total_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // empty')
now=$(date +%H:%M:%S)

# Model part
model_part=""
[ -n "$model" ] && model_part="$model"

# Context usage indicator
ctx_part=""
if [ -n "$used_pct" ]; then
  ctx_part=" | ctx:$(printf '%.0f' "$used_pct")%"
fi

# Session token usage (total input + output tokens this session, shown in thousands)
sess_part=""
if [ -n "$total_in" ] && [ -n "$total_out" ]; then
  sess_total=$(( total_in + total_out ))
  sess_k=$(awk "BEGIN { printf \"%.1f\", $sess_total / 1000 }")
  sess_part=" | sess:${sess_k}k"
fi

# Plan/rate limit usage (5-hour and 7-day)
rate_part=""
five=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
if [ -n "$five" ] || [ -n "$week" ]; then
  rate_part=" |"
  [ -n "$five" ] && rate_part="$rate_part 5h:$(printf '%.0f' "$five")%"
  [ -n "$week" ] && rate_part="$rate_part 7d:$(printf '%.0f' "$week")%"
fi

printf "\033[0;33m%s\033[0m%s%s%s | \033[0;36m%s\033[0m" \
  "$model_part" "$ctx_part" "$sess_part" "$rate_part" "$now"
