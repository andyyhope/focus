IS_FOCUS_ENABLED = True

FOCUSED_FRAMEWORKS_MAP = {
	# Focused and linked transitive deps
	":SwiftA": 1, # Base -> SwiftA
	":ObjcB" : 1, # Base -> SwiftA -> ObjcB
	
	# Focused but unlinked transitive dep
	":ZZZ" : 1, # Base -> ObjcA (unfocused, broken link) -> ZZZ
}