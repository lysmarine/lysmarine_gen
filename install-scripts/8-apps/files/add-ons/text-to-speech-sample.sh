#!/bin/bash -e

pico2wave -l  en-US -w /tmp/pico2wave.wav "Passenger Announcement... \
 Follow these few rules, to make your trip enjoyable for everyone on board. \
 Move around the boat on its high side. \
 Always hold on to something steady, and that does not move: shrouds, grab rails, when you are outside of the cockpit. \
 If you can not swim, wear a life jacket, if you move outside of the cockpit. \
 Watch your head and listen to the crew warnings when you are around the boom. \
 The boom can swing fast, if the wind changes. \
 In case if someone falls overboard, throw anything, that floats to the victim and \
 shout: Man overboard! pointing at the victim. \
 Do not put into a marine toilet anything, which you have not eaten or drunk first. \
 Do not throw plastic overboard. \
 Watch the horizon. If you feel sea sick, try to stay active outside of the cabin." && play -qV0 /tmp/pico2wave.wav treble 24  gain -l 6

