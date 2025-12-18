require 'xcodeproj'
project = Xcodeproj::Project.open('example.xcodeproj')
target = project.targets.find { |t| t.name == 'example' }

# Find and fix VideoIDSDKSwiftBridge file reference
target.source_build_phase.files.each do |build_file|
  if build_file.file_ref && build_file.file_ref.path && build_file.file_ref.path.include?('VideoIDSDKSwiftBridge')
    puts "Before: path=#{build_file.file_ref.path}, name=#{build_file.file_ref.name}"
    # Change path to just the filename since it's already in the example group
    build_file.file_ref.path = 'VideoIDSDKSwiftBridge.swift'
    puts "After: path=#{build_file.file_ref.path}, name=#{build_file.file_ref.name}"
    puts "Real Path: #{build_file.file_ref.real_path}"
  end
end

project.save
puts 'Project saved'
