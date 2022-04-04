#!/usr/bin/env python3

import argparse 
import os
import shutil
import tempfile
import zipfile
from typing import NamedTuple, List

class Outputs(NamedTuple):
	binary: str
	info_plist: str
	umbrella_header: str
	module_header: str
	module_map: str
	

class Args(NamedTuple):
	module: str
	inputs: List[str]
	outputs: Outputs

def _get_args() -> Args:
	parser = argparse.ArgumentParser()
	parser.add_argument("--module", type=str, required=True)
	parser.add_argument("--inputs", nargs='+', default=[], required=True)
	parser.add_argument("--output-binary", type=str, required=False)
	parser.add_argument("--output-info-plist", type=str, required=False)
	parser.add_argument("--output-umbrella-header", type=str, required=False)
	parser.add_argument("--output-module-header", type=str, required=False)
	parser.add_argument("--output-module-map", type=str, required=False)
	
	args = parser.parse_args()
	
	return Args(
		module=args.module,
		inputs=args.inputs,
		outputs=Outputs(
			binary=args.output_binary,
			info_plist=args.output_info_plist,
			umbrella_header=args.output_umbrella_header,
			module_header=args.output_module_header,
			module_map=args.output_module_map,
		)
	)
	
def _copy(src: str, dst: str):
	if os.path.exists(dst):
		os.remove(dst)
		
	if os.path.islink(src):
		linkto = os.readlink(src)
		os.symlink(linkto, dst)
	else:
		shutil.copy(src,dst)


def main():
	args = _get_args()
	
	for input in args.inputs:
		ext = os.path.splitext(input)[-1]
		filename = os.path.split(input)[-1]
		if filename == f"{args.module}.framework.zip":
			print(f"Found zip: {input}")
			tempdir = tempfile.mkdtemp(prefix=f"{args.module}_")
			with zipfile.ZipFile(input,"r") as zip_ref:
				zip_ref.extractall(tempdir)
				extracted_framework_dir = os.path.join(tempdir, f"{args.module}.framework")
				if not os.path.exists(extracted_framework_dir):
					raise Exception("Extracted framework doesn't exist")
				for fp in os.listdir(extracted_framework_dir):
					filename = os.path.split(fp)[-1]
					print("zip: " + filename)
					if filename == "Info.plist":
						_copy(input, args.outputs.info_plist)
					elif filename == args.module:
						_copy(input, args.outputs.binary)
					
		elif f"{args.module}.framework/Headers/" in input:
			print(f"Found headers: {input}")
			if filename == f"{args.module}.h":
				_copy(input, args.outputs.module_header)
			elif filename == f"{args.module}-umbrella.h":
				_copy(input, args.outputs.umbrella_header)
			
		elif f"{args.module}.framework/Modules/" in input:
			print(f"Found module: {input}")
			if filename == f"module.modulemap":
				_copy(input, args.outputs.module_map)
			

	
if __name__ == "__main__":
	main()