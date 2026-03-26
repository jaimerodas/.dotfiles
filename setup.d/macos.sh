#!/bin/bash
# macOS preferences

# --- Hot Corners ---
# 2=Mission Control, 3=App Windows, 4=Desktop, 13=Lock Screen
CORNERS="tl:2 tr:4 bl:3 br:13"
needs_update=false

for entry in $CORNERS; do
	pos="${entry%%:*}"; val="${entry##*:}"
	[[ "$(defaults read com.apple.dock "wvous-${pos}-corner" 2>/dev/null)" != "$val" ]] && needs_update=true
done

if $needs_update; then
	bold "Configuring hot corners..."
	for entry in $CORNERS; do
		pos="${entry%%:*}"; val="${entry##*:}"
		defaults write com.apple.dock "wvous-${pos}-corner" -int "$val"
		defaults write com.apple.dock "wvous-${pos}-modifier" -int 0
	done
	killall Dock
	bold "Hot corners configured!"
else
	warn "Hot corners already configured"
fi
