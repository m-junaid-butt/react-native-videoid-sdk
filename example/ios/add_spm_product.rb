require 'xcodeproj'
project = Xcodeproj::Project.open('example.xcodeproj')
target = project.targets.find { |t| t.name == 'example' }

# Find the package reference
package_ref = project.root_object.package_references.find { |ref| ref.repositoryURL =~ /videoidskd-spm/ }

if package_ref
  puts 'Found VideoIDSDK package reference'
  puts "Package URL: #{package_ref.repositoryURL}"
  
  # Check if package product already exists
  existing = target.package_product_dependencies.find { |dep| dep.product_name == 'VideoIDSDK' }
  
  if existing
    puts 'VideoIDSDK package product already exists'
  else
    # Create package product dependency
    package_product = project.new(Xcodeproj::Project::Object::XCSwiftPackageProductDependency)
    package_product.package = package_ref
    package_product.product_name = 'VideoIDSDK'
    
    # Add to target
    target.package_product_dependencies << package_product
    
    puts 'Added VideoIDSDK package product to target'
  end
  
  project.save
  puts 'Project saved'
else
  puts 'VideoIDSDK package reference not found!'
end
