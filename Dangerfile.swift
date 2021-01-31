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
