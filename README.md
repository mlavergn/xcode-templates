# Xcode Templates

Xcode bare bones templates without storyboards / XIBs / NIBs

## Usage

```bash
# Install a clean copy of the template using the install script

# Swift
make swift DEST=~/src/MyProject

# Objective-C
make objc DEST=~/src/MyProject

# Change the project naming in Xcode post-installation
# at both the project top-level and the target display name
```

## Manually (macOS)

To manually adapt a macOS project removing storyboards, follow these steps:

```bash
# optional set the project name in the environment, otherwise replace in commands below
export PROJECT=Demo

# remove the NSMainStoryboardFile plist entry
plutil -remove NSMainStoryboardFile ${PROJECT}/Info.plist

# remove the storyboard file
rm $PROJECT/Base.lproj/Main.storyboard

# create a main.swift
echo "import Cocoa\n\nlet delegate = AppDelegate()\nNSApplication.shared.delegate = delegate\n_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)" > $PROJECT/main.swift

# remove the NSApplicationMain decorator in AppDelegate.swift
sed -i '' 's/@NSApplicationMain//' $PROJECT/AppDelegate.swift
```

Note that there is no built-in way to modify Xcode projects from the CLI, so you will need to remove the reference to Main.storyboard and add a reference to main.swift via the Xcode UI.

These steps are contained in Makfile.macos and can be automated using:

```bash
make -f Makefile.macos PROJECT=MyProjectName
```
