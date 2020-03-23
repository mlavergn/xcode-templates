###############################################
#
# Makefile
#
###############################################

.DEFAULT_GOAL := help

VERSION = 13.0.0

DEST ?= "NewProject"

#
# Users targets
#

# display usage info
help:
	@echo "Usage: make <objc:swift> DEST=<destination path>>"

# install the Objective-C template
objc:
	mkdir -p "${DEST}"
	tar cf - --exclude=.git -C ObjcTemplate . | (cd "${DEST}" && tar xvf - )

# install the Swift template
swift:
	mkdir -p "${DEST}"
	tar cf - --exclude=.git -C SwiftTemplate . | (cd "${DEST}" && tar xvf - )

#
# Test targets
#

# test the templates
test:
	@xcodebuild -project ObjcTemplate/Project.xcodeproj -scheme App -sdk iphonesimulator
	@xcodebuild -project SwiftTemplate/Project.xcodeproj -scheme App -sdk iphonesimulator

testobjc:
	$(MAKE) objc DEST=TestObjc
	xcodebuild -project TestObjc/Project.xcodeproj -scheme App -sdk iphonesimulator
	rm -rf TestObjc

testswift:
	$(MAKE) objc DEST=TestSwift
	xcodebuild -project TestSwift/Project.xcodeproj -scheme App -sdk iphonesimulator
	rm -rf TestSwift

#
# Development targets
#

github:
	open "https://github.com/mlavergn/xcode-templates"

# open the objc template
openobjc:
	open ObjcTemplate/Project.xcodeproj

# open the swift template
openswift:
	open SwiftTemplate/Project.xcodeproj

# open SourceTree in the project dir
st:
	open -a SourceTree .

# release template update
release:
	zip -r xctemplates.zip LICENSE README.md Makefile ObjcTemplate SwiftTemplate
	hub release create -m "${VERSION} - Xcode Templates" -a xctemplates.zip -t master "v${VERSION}"
	rm xctemplates.zip

