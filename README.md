# cocoapods-framework-search-inherit

This plugin is used to resolve the problem that, the frameworks search path do not inherit in multiple targets project. For example, in a project looks like this below:

	MainApp.xcworkspace
		|__ MainApp.xcodeproj
		|__ DynamicFramework.xcodeproj
		|__ Pods.xcodeproj
		
the MainApp target embed the DyanmicFramework. And because iOS 8 limit the binary's TEXT section size in 60MB, we let all the pod we need defined in Podfile targeting at DynamicFramework, to build only single dynamic library as possible. That reduces the size of MainApp and the dyld loading time.

But there is a little problem here, where the pod targeting to DyanmicFramework only provide a framework object, eg FooFramework, that means MainApp could not found or import FooFramework's header, and the DynamicFramewokr could.

Use this plugin can append DynamicFramework's framework search path to MainApp's.
		
## Installation

⚠️ NOTE: This gem is NOT published yet!

## Usage

In Podfile:

	# to load the plugin
	plugin 'cocoapods-framework-search-inherit'
	
	# declare target dependency
	framework_search_path_inherit_chain('DynamicFramework', 'MainApp')

## License

MIT
