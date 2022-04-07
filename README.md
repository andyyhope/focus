# Xcode Focus with `xcodeproj()`
## Goal
I want to generate an Xcode project using Bazel and `rules_ios`'s `xcodeproj()` rule which only imports a subset of the build graph, which is commonly known as "focusing" or a "focused project".

I'm still quite noob when it comes to build systems, compilers, etc but my thinking is that if we used compiled dynamic frameworks for the unfocused targets, we can improve build times and prevent unnecessary cascading builds.

## Methodology
- Create a macro, `focused_apple_framework()`, which is a wrapper around `apple_framework()` and `apple_dynamic_framework_import`.
- In the implementation of that macro, we create the intended `apple_framework` as well as a `apple_dynamic_framework_import` with the same name but suffixed with `*__unfocused`.
	- To create the appropriate framework files for this target, I have a genrule that takes the output of the original framework and packages them in an acceptable `*.framework` folder to be consumed. This genrule's name is `*__unfocused_builder`
- To link the unfocused targets, each dep in the build graph checks against a memo to see if it should append the `*__unfocused` target.

## Examples
### Build
```
$ bazel build //focus:FocusApp
```

### Generate Xcode project
```
$ bazel run //focus:Xcode
$ open focus/Focus.xcodeproj
```

### Update focused targets
Update [`FOCUSED_FRAMEWORKS_MAP`](https://github.com/andyyhope/focus/blob/main/macros/focused_frameworks.bzl#L3)

### Toggle focusing
Update [`IS_FOCUS_ENABLED`](https://github.com/andyyhope/focus/blob/main/macros/focused_frameworks.bzl#L1) 

## Issues
### Broken links
The problem now is that the unfocused targets aren’t being treated the same as focused targets when it comes to generating the `xcodeproj()` rule.
- If a target is declared as focused, but there isn’t a direct link of *focused* modules in the build graph from root module (`:Base`) to it then Xcode doesn’t generate references to the module’s files during project generation.
- It will also cause a runtime crash because the necessary files aren’t being copied into the `DerivedData/` folder. 
#### Example
- **Good**: Focusing on `SwiftA` and `ObjcB`, will run without crashing and both modules will have their files generated and displayed in the Xcode project
- **Bad**: Focusing on `ZZZ` but not on `ObjcA`, will cause a runtime crash and `ZZZ` files won't appear in the generated Xcode project

##### Build graph
- `Base`
	- `SwiftA` (focused)
		- `ObjcB` (focused)
	- `ObjcA`
		- `ZZZ` (focused) 
	
