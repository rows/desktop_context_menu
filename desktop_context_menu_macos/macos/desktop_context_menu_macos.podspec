#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint desktop_context_menu_macos.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'desktop_context_menu_macos'
  s.version          = '0.1.0'
  s.summary          = 'Flutter MacOS implementation of context menu.'
  s.description      = <<-DESC
A MacOS implementation of the desktop_context_menu plugin.
                       DESC
  s.homepage         = 'https://github.com/rows/desktop_context_menu'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Rows' => 'opensource@rows.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
