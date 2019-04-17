Pod::Spec.new do |s|

  s.name         = "STPostWebView"
  s.version      = "0.0.5"
  s.summary      = "A subclass of WKWebView that supports requested by POST."
  s.homepage     = "https://github.com/shien7654321/STPostWebView"
  s.author       = { "Suta" => "shien7654321@163.com" }
  s.source       = { :git => "https://github.com/shien7654321/STPostWebView.git", :tag => s.version.to_s }
  s.platform     = :ios, "8.0"
  s.requires_arc = true
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.frameworks   = "Foundation", "UIKit", "WebKit"
  s.source_files = "STPostWebView/*.{swift}"
  s.compiler_flags = "-fmodules"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }
  s.description    = <<-DESC
  STPostWebView is a subclass of WKWebView that supports requested by POST.
                       DESC

end
