require 'xcodeproj'

# Open the project
project_path = '/Users/apple/Downloads/react-native-videoid-sdk/example/ios/example.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# Find the example target
target = project.targets.find { |t| t.name == 'example' }

# Find the example group (folder)
example_group = project.main_group.groups.find { |g| g.name == 'example' || g.path == 'example' }

unless example_group
  puts "Creating example group..."
  example_group = project.main_group.new_group('example', 'example')
end

# Add VideoIDModule.m
m_file_ref = example_group.new_file('VideoIDModule.m')
target.add_file_references([m_file_ref])

# Add VideoIDModule.h  
h_file_ref = example_group.new_file('VideoIDModule.h')
# Headers don't need to be added to compile sources, just the file reference

puts "Added VideoIDModule.m and VideoIDModule.h to #{target.name} target"

# Save the project
project.save

puts "Project saved successfully!"
