platform :ios, '11.2'

workspace 'Miramax Fillms.xcworkspace'
project 'Miramax Fillms.xcodeproj'

use_frameworks!

target 'Domain' do
  project 'Domain/Domain.project'

  pod 'RxSwift', '~> 6.1.0'
end

target 'Data' do
  project 'Data/Data.project'

  pod 'RxSwift', '~> 6.1.0'
  pod 'Moya/RxSwift', '~> 15.0'
  pod "RxRealm", '~> 5.0.4'
  pod 'ObjectMapper', '~> 4.2.0'
end

target 'Miramax Fillms' do
  # rx
  pod 'RxSwift', '~> 6.1.0'
  pod 'RxCocoa', '~> 6.1.0'
  pod 'RxDataSources', '~> 5.0.0'
  pod 'RxSwiftExt', '~> 6.0.1'
  pod "RxRealm", '~> 5.0.4'
  pod 'Action', '~> 5.0.0'

  # XCoordinator
  pod 'XCoordinator', '~> 2.2.0'
  pod 'XCoordinator/RxSwift', '~> 2.2.0'
  
  # SwifterSwift
  pod 'SwifterSwift/UIKit'
  
  # others
  pod 'SnapKit', '~> 5.0.0'
  pod 'Kingfisher'
  pod 'MKProgress'
  pod 'ObjectMapper', '~> 4.2.0'
  pod 'Moya/RxSwift', '~> 15.0'
  pod 'Swinject', '~> 2.8.2'
  pod 'RealmSwift', '~>10'
  pod 'TagListView', '~> 1.0'

  
end
