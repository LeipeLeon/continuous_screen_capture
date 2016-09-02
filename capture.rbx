#!/usr/bin/env ruby -w
require 'rubygems'
require 'RMagick'
include Magick

# http://code.google.com/p/blacktree-nocturne/downloads

i = 0
prev = i
screen = 1
prev_img = ImageList.new("capture_dummy.png")

while true do
  i = Time.now.to_i
  `screencapture -o -T 1 "capture_folder/capture_#{i}-0.png" "capture_folder/capture_#{i}-1.png" "capture_folder/capture_#{i}-2.png"`
  current_img = ImageList.new("capture_folder/capture_#{i}-#{screen}.png")
  diff_img, threshold = current_img.compare_channel(prev_img, MeanSquaredErrorMetric)
  puts threshold
  if threshold > 0.0
    diff_img.write("capture_folder/diff/capture_diff_#{i}-#{screen}.png")
    puts "Upload current_img capture_folder/capture_#{i}-#{screen}.png to API in a bg job"
  end
  prev_img = current_img
  prev = i
  if i.divmod(10)[1] == 0
    puts "Cleanup GC!"
    GC.start
  end
end
