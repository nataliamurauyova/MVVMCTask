import Danger 
let danger = Danger()

let editedFiles = danger.git.modifiedFiles + danger.git.createdFiles
let editedAppFiles = editedFiles.filter {
    ($0.fileType == .swift  || $0.fileType == .m) &&
    $0.contains("/App")
}

if danger.github.pullRequest.user.login == "someStarngeUsername" {
    warn("Not this guy again!")
}

xcov.report(
   scheme: 'EasyPeasy',
   workspace: 'Example/EasyPeasy.xcworkspace',
   exclude_targets: 'Demo.app',
   minimum_coverage_percentage: 90
)
