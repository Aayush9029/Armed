set -e

defaults delete com.apple.dt.Xcode IDEPackageOnlyUseVersionsFromResolvedFile
defaults delete com.apple.dt.Xcode IDEDisableAutomaticPackageResolution
defaults write com.apple.dt.Xcode IDESkipMacroFingerprintValidation -bool YES
