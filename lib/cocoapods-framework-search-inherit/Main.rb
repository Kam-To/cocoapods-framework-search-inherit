# encoding: UTF-8
require 'objspace'

$targetNameChain

module Pod
    class Podfile
        module DSL
            def framework_search_path_inherit_chain(*targetNameChain)
                $targetNameChain = targetNameChain
                Pod::UI.puts "Read chain #{targetNameChain}"
            end
        end
    end
end

module CocoapodsFrameworkSearchInherit

    class FrameworskSearchPathInfo
        attr_accessor :configNameMapAppend, :target
        def initialize(target)
            @target = target
            @configNameMapAppend = {}
        end
    end
    
    Pod::HooksManager.register('cocoapods-framework-search-inherit', :post_install) do |post_context|
        Pod::UI.puts "Read chain #{$targetNameChain}"

        # get current installer
        thisInstaller = nil;
        include ObjectSpace
        ObjectSpace.each_object(Pod::Installer) { |installer|
            thisInstaller = installer;
        }

        targetNameMapSearchPathInfo = Hash.new
        podTargetNameChain = Array.new

        # get actual name from aggregate_targets
        $targetNameChain.each { | name | 
            thisInstaller.aggregate_targets.each { |target|
                if target.name.end_with?(name) then
                    podTargetNameChain << target.name
                    info = FrameworskSearchPathInfo.new(target)
                    targetNameMapSearchPathInfo[target.name] = info
                    break
                end
            }
        }
 
        FrameworkSearchPathKey = 'FRAMEWORK_SEARCH_PATHS'

        thisInstaller.aggregate_targets.each { |target|
            puts "targets  : #{target}"
            if targetNameMapSearchPathInfo[target.name] then
                info = targetNameMapSearchPathInfo[target.name]
                target.xcconfigs.each { |config_name, config_file|
                    puts "|___ config #{config_name}"

                    # remove '$(inherited) '
                    appened = config_file.attributes[FrameworkSearchPathKey].dup.gsub! '$(inherited) ', ''
                    info.configNameMapAppend[config_name] = appened
                    puts "   |___ framework search paths: #{appened}"
                    puts ""
                }
            end            
        }

        puts ""
        puts "Ready to override framework search paths!"


        podTargetNameChain.each_with_index { | podTargetName, idx | 
            # there is no need to modify the first target config
            if idx == 0 then 
                next
            end
        
            info = targetNameMapSearchPathInfo[podTargetName]
            puts "targets  : #{info.target}"

            info.target.xcconfigs.each { |config_name, config_file| 

                origin = config_file.attributes[FrameworkSearchPathKey].dup
                puts "|___#{config_name}    origin: #{origin}"

                appened = ""
                for i in 0..(idx-1)
                    infoToAppend = targetNameMapSearchPathInfo[podTargetNameChain[i]]
                    appened << " " << infoToAppend.configNameMapAppend[config_name]
                end

                replacement = origin << appened
                config_file.attributes[FrameworkSearchPathKey] = replacement
                puts "|___#{config_name}  appended: #{replacement}"

                xcconfig_path = info.target.xcconfig_path(config_name)
                config_file.save_as(xcconfig_path)
            }

            puts "Finishing appending #{podTargetName}"
            puts ""
        }
    end
end