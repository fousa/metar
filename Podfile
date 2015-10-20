platform :ios, "8.0"

inhibit_all_warnings!
use_frameworks!

pod 'Ono', '~> 1.2'

def test_pods
    pod 'Mockingjay', '~> 1.1'
    pod 'Nimble',     '~> 2.0'
    pod 'Quick',      '~> 0.7'
end

target 'MetarTests', exclusive: true do
    test_pods
end

target 'MetarUITests', exclusive: true do
    test_pods
end
