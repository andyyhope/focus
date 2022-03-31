# Bazel Experiement
I'm having troubles with `rules_ios` and `xcodeproj` when it comes to debugging external Swift symbols (contained within separate Swift modules) from Objective-C. 
However, I can debug external ObjC symbols (contained in separate ObjC modules) from ObjC tho.

### Note:
- Auto-complete, syntax highlighting, code jumping all still work
- Code jumping from the `import` statement doesn't work. This could be a clue?

## Bazel build config
```
# General Build options
build --subcommands
build --announce_rc
build --copt="-v"
build --swiftcopt="-v
build --experimental_generate_json_trace_profile
build --experimental_show_artifacts

# Debug Flags
# Note: These is also required for lldb debugging. Without these, debugging fails completely
build --compilation_mode=dbg # shorthand: -c dbg
build --features=oso_prefix_is_pwd
```
## Instructions
1. Check out the commit
2. `$ cd` to the same folder as the `WORKSPACE` file from the repo
3. `$ bazel build //raven:RavenApp`
4. `$ bazel run //raven:Xcode`
5. `$ open raven/Raven.xcodeproj`
6. Set a breakpoint on `AppDelegate.m:33`
7. Build and Run
8. When breakpoint hits: 
	- `po ObjcA.number`: Prints the value of `number` just fine
	- `po SwiftA.number`: Cannot see the `SwiftA` module
	- `expr -l swift -- SwiftA.number`: Complains `SwiftA` isn't within scope
	- `expr -l swift -- import SwiftA`: Adds the `SwiftA` module
	- `expr -l swift -- SwiftA.number`: Complains it can't find the `number` property from `SwiftA`


## Error messages
**Breakpoint**: [AppDelegate.m : 33](https://github.com/andyyhope/raven-rulesios/blob/main/raven/Base/AppDelegate.m#L33)
```
(lldb) po SwiftA.number 
error: No module map file in bazel-out/ios-x86_64-min12.0-applebin_ios-ios_x86_64-dbg-ST-cf54f5184a23/bin/raven/ObjcA/ObjcA.framework

error: <user expression 0>:1:1: use of undeclared identifier 'SwiftA'
SwiftA.number 
^
```
**Simple `po`**
```
(lldb) po SwiftA.number 
error: No module map file in bazel-out/ios-x86_64-min12.0-applebin_ios-ios_x86_64-dbg-ST-cf54f5184a23/bin/raven/ObjcA/ObjcA.framework

error: <user expression 0>:1:1: use of undeclared identifier 'SwiftA'
SwiftA.number 
^
```
**Using `expression`**
```
(lldb) expr -l swift -- import SwiftA
(lldb) expr -l swift -- SwiftA.number 
error: <EXPR>:3:8: error: type 'SwiftA' has no member 'number'
SwiftA.number 
~~~~~~ ^~~~~~
```

## Things I've tried
Adding the paths to the `/../*.framework/Modules/` directly to `.lldbinit` setting: `target.clang-module-search-paths` and `target.swift-module-search-paths`:
```
settings set -- target.clang-module-search-paths /Users/ahope/raven-rulesios/bazel-out/ios-x86_64-min12.0-applebin_ios-ios_x86_64-dbg-ST-84e06abcb3f0/bin/raven/Base/Base.framework/Modules /Users/ahope/raven-rulesios/bazel-out/ios-x86_64-min12.0-applebin_ios-ios_x86_64-dbg-ST-84e06abcb3f0/bin/raven/SwiftA/SwiftA.framework/Modules /Users/ahope/raven-rulesios/bazel-out/ios-x86_64-min12.0-applebin_ios-ios_x86_64-dbg-ST-84e06abcb3f0/bin/raven/ObjcB/ObjcB.framework/Modules /Users/ahope/raven-rulesios/bazel-out/ios-x86_64-min12.0-applebin_ios-ios_x86_64-dbg-ST-84e06abcb3f0/bin/raven/SwiftB/SwiftB.framework/Modules /Users/ahope/raven-rulesios/bazel-out/ios-x86_64-min12.0-applebin_ios-ios_x86_64-dbg-ST-84e06abcb3f0/bin/raven/MixedA/MixedA.framework/Modules /Users/ahope/raven-rulesios/bazel-out/ios-x86_64-min12.0-applebin_ios-ios_x86_64-dbg-ST-84e06abcb3f0/bin/raven/ObjcA/ObjcA.framework/Modules /Users/ahope/raven-rulesios/bazel-out/ios-x86_64-min12.0-applebin_ios-ios_x86_64-dbg-ST-84e06abcb3f0/bin/raven/MixedB/MixedB.framework/Modules
```

Adding the paths to the `bin/raven/` folder which contains all of the `*.swiftmodule` files
```
settings set -- target.swift-module-search-paths /Users/ahope/raven-rulesios/bazel-out/ios-x86_64-min12.0-applebin_ios-ios_x86_64-dbg-ST-84e06abcb3f0/bin/raven/
```