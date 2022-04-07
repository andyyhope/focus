load("@build_bazel_rules_ios//rules:framework.bzl", "apple_framework",)
load("@build_bazel_rules_ios//rules:apple_patched.bzl", "apple_dynamic_framework_import",)
load("//macros:focused_frameworks.bzl", "FOCUSED_FRAMEWORKS_MAP",)

IOS_MIN = "12.0"
PLATFORMS = {"ios": IOS_MIN}
PUBLIC_VISIBILITY = ["//visibility:public"]
UNFOCUSED_SUFFIX = "__unfocused"


def _augmented_deps(deps):
    augmented_deps = []
    for dep in deps:
        if FOCUSED_FRAMEWORKS_MAP.get(dep, 0) == 1:
            augmented_deps.append(dep)
        else:
            augmented_deps.append(dep + UNFOCUSED_SUFFIX)
            
    return augmented_deps


def focused_apple_framework(name, **kwargs):
    """Builds and packages an Apple framework.
    Args:
        name: The name of the framework.
        apple_library: The macro used to package sources into a library.
        **kwargs: Arguments passed to the apple_library and apple_framework_packaging rules as appropriate.
    """
    
    srcs = kwargs.pop("srcs", [])
    private_headers = kwargs.pop("private_headers", [])

    apple_framework(
        name = name,
        srcs = srcs,
        private_headers = private_headers,
        sdk_frameworks = kwargs.pop("sdk_frameworks", ["Foundation"]),
        platforms = kwargs.pop("platforms", PLATFORMS),
        visibility = kwargs.pop("visibility", PUBLIC_VISIBILITY),
        swift_version = kwargs.pop("swift_version", ""),
        link_dynamic = kwargs.pop("link_dynamic", True),
        bundle_id = kwargs.pop("bundle_id", "com.andyyhope.frameworks." + name),
        infoplists = kwargs.pop("infoplists", ["//__resources__:FrameworkDefaultInfoPlist"]),
        deps = _augmented_deps(kwargs.pop("deps", [])),
        **kwargs,
    )

    name_unfocused = name + UNFOCUSED_SUFFIX
    name_unfocused_builder = name_unfocused + "_builder"
    unfocused_framework = name + ".framework/"
    headers_dir = "Headers/"
    modules_dir = "Modules/"
    swift_module = ".swiftmodule"
    cpu_arch = "x86_64" # Note: Will need to add support for different CPU archs. Can do this by grabbing the current arch from the build command/setting

    output_binary_file = unfocused_framework + name
    output_info_plist_file = unfocused_framework + "Info.plist"
    output_module_map_file = unfocused_framework + modules_dir + "module.modulemap"
    output_swift_module_file = unfocused_framework + modules_dir + name + swift_module + "/" + cpu_arch + swift_module
    output_umbrella_header_file = unfocused_framework + headers_dir + name + "-umbrella.h"
    output_module_swift_header_file = unfocused_framework + headers_dir + name + "-Swift.h" # New
    output_exported_header_files = ["{}{}{}".format(unfocused_framework, headers_dir, src.split("/")[-1]) for src in srcs if src.endswith(".h") and "__internal__" not in src]
    
    name_exported_headers = name + "__exported_headers"
    native.filegroup(
        name = name_exported_headers,
        srcs = [src for src in srcs if src.endswith(".h") and "__internal__" not in src],
    )

    command=[
    	"$(location //binaries:framework_builder)",
    	"--module {}".format(name),
    	"--inputs $(locations :{})".format(name),
    	"--output-binary $(location {})".format(output_binary_file),
    	"--output-info-plist $(location {})".format(output_info_plist_file),
        "--output-module-map $(location {})".format(output_module_map_file),
    	"--output-umbrella-header $(location {})".format(output_umbrella_header_file),
    ]

    outputs = [
        output_binary_file,
        output_info_plist_file,
        output_module_map_file,
        output_umbrella_header_file,
    ]

    if len([src for src in srcs if src.endswith(".swift")]) > 0: # if contains swift
        command += [
            "--output-module-swift-header $(location {})".format(output_module_swift_header_file),
            "--output-swift-module $(location {})".format(output_swift_module_file),
        ]
        outputs += [
            output_module_swift_header_file,
            output_swift_module_file,
        ]
    
    if len([src for src in srcs if src.endswith(".h")]) > 0: # if contains ObjC
        command += [
            "--output-exported-headers $(locations {})".format(" ".join(output_exported_header_files)),
        ]
        outputs += output_exported_header_files
    
    native.genrule(
        name = name_unfocused_builder,
        srcs = [":" + name],
        outs = outputs,
        tools = [
            ":" + name_exported_headers,
        	"//binaries:framework_builder",

        ],
        cmd = " ".join(command),

    )

    apple_dynamic_framework_import(
        name = name_unfocused,
        framework_imports = [
          ":" + name_unfocused_builder,
        ],
        visibility = PUBLIC_VISIBILITY,
    )    
