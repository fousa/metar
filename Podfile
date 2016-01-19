platform :ios, "8.0"

inhibit_all_warnings!
use_frameworks!

pod 'Ono',               '~> 1.2'
pod 'AERecord',          '~> 2.0'
pod 'JTMaterialSpinner', '~> 1.0'

def test_pods
    pod 'Mockingjay', '~> 1.1'
    pod 'Nimble',     '~> 3.0'
    pod 'Quick',      '~> 0.8'
end

target 'MetarTests', exclusive: true do
    test_pods
end

target 'MetarUITests', exclusive: true do
    test_pods
end
