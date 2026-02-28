#!/usr/bin/ruby
touchpad_id = `xinput list`.split("\n").select { |line| line.include?('Touchpad') }[0].split("\t")[1][/\d+/]
puts "Touchpad id is #{touchpad_id}"
puts `xinput set-prop #{touchpad_id} 'libinput Scrolling Pixel Distance' 40`
