load("@build_bazel_rules_ios//rules:framework.bzl", "apple_framework",)
load("@build_bazel_rules_ios//rules:apple_patched.bzl", "apple_dynamic_framework_import",)

PUBLIC_VISIBILITY = ["//visibility:public"]
IOS_MIN = "12.0"

def focused_apple_framework(name, **kwargs):
    """Builds and packages an Apple framework.
    Args:
        name: The name of the framework.
        apple_library: The macro used to package sources into a library.
        **kwargs: Arguments passed to the apple_library and apple_framework_packaging rules as appropriate.
    """
    apple_framework(
        name = name,
        srcs = kwargs["srcs"],
        private_headers = kwargs["private_headers"],
        sdk_frameworks = kwargs.get("sdk_frameworks", ["Foundation"]),
        platforms = kwargs["platforms"],
        visibility = kwargs["visibility"],
        swift_version = kwargs.get("swift_version", ""),
        link_dynamic = True,
        bundle_id = "com.andyyhope.frameworks." + name,
        infoplists = [name + "/__resources__/Info.plist"],
        deps = kwargs.get("deps", []),
    )

    name_unfocused = name + "__unfocused"
    name_unfocused_builder = name_unfocused + "_builder"
    unfocused_framework = name + ".framework/"

    output_binary_file = unfocused_framework + name
    output_info_plist_file = unfocused_framework + "Info.plist"
    output_umbrella_header_file = unfocused_framework + "Headers/" + name + "-umbrella.h"
    output_module_header_file = unfocused_framework + "Headers/" + name + ".h"
    output_module_map_file = unfocused_framework + "Modules/module.modulemap"
    


    print(output_info_plist_file)

    command=[
    	"$(location //binaries:framework_builder)",
    	"--module {}".format(name),
    	"--inputs $(locations :{})".format(name),
    	"--output-binary $(location {})".format(output_binary_file),
    	"--output-info-plist $(location {})".format(output_info_plist_file),
    	"--output-umbrella-header $(location {})".format(output_umbrella_header_file),
    	"--output-module-header $(location {})".format(output_module_header_file),
    	"--output-module-map $(location {})".format(output_module_map_file),
    ]
    
    native.genrule(
        name = name_unfocused_builder,
        srcs = [":" + name],
        outs = [
            output_binary_file,
            output_info_plist_file,
            output_umbrella_header_file,
            output_module_header_file,
            output_module_map_file,
        ],
        tools = [
        	"//binaries:framework_builder"
        ],
        cmd = " ".join(command),

    )

    apple_dynamic_framework_import(
        name = name_unfocused,
        framework_imports = 
        [
          ":" + name_unfocused_builder,
        ],
        visibility = PUBLIC_VISIBILITY,
    )    