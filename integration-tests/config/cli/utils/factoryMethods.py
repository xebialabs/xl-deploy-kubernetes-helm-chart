from tempfile import mkdtemp

def createApp(appName, directory = ""):
    if directory == "":
        appId = "Applications/" + appName
    else:
        directoryId = "Applications/" + directory
        if not repository.exists(directoryId):
            repository.create(factory.configurationItem(directoryId, "core.Directory"))
        appId = directoryId + "/" + appName
    return repository.create(factory.configurationItem(appId, "udm.Application"))

def createPackage(applicationId, version = "1.0"):
    packageId = applicationId + "/" + version
    package = factory.configurationItem(packageId, "udm.DeploymentPackage", {'application': applicationId})
    return repository.create(package)

def createFile(packageId, ciName, fileName, content):
    targetPath = mkdtemp()
    file = factory.artifact(packageId + '/' + ciName, 'file.File', {}, content)
    file.filename = fileName
    createdArtifact = repository.create(file)
    createdArtifact.targetPath = targetPath
    createdArtifact.targetFileName = fileName
    createdArtifact.targetPathShared = "true"
    repository.update(createdArtifact)
    return createdArtifact

def createFileWithPlaceholders(packageId, ciName, fileName, content, placeholders, scanPlaceholders = True):
    targetPath = mkdtemp()
    file = factory.artifact(packageId + '/' + ciName, 'file.File', {}, content)
    file.filename = fileName
    createdArtifact = repository.create(file)
    createdArtifact.targetPath = targetPath
    createdArtifact.targetFileName = fileName
    createdArtifact.targetPathShared = "true"
    createdArtifact.scanPlaceholders = scanPlaceholders
    createdArtifact.placeholders = placeholders
    repository.update(createdArtifact)
    return createdArtifact

def createFolder(packageId, ciName, fileName):
    targetPath = mkdtemp()
    f = open('src/test/resources/testfiles/archive.zip', 'rb')
    file = factory.artifact(packageId + '/' + ciName, 'file.Folder', {}, f.read())
    file.filename = fileName
    createdArtifact = repository.create(file)
    createdArtifact.targetPath = targetPath
    createdArtifact.createTargetPath = "true"
    repository.update(createdArtifact)
    return createdArtifact

def createHost(hostName, directory = ""):
    if directory == "":
        hostId = "Infrastructure/" + hostName
    else:
        directoryId = "Infrastructure/" + directory
        if not repository.exists(directoryId):
            repository.create(factory.configurationItem(directoryId, "core.Directory"))
        hostId = directoryId + "/" + hostName
    return repository.create(factory.configurationItem(hostId, "overthere.LocalHost", {"os" : os_family() }))

def createEnvironment(environmentId, containers):
    return repository.create(factory.configurationItem("Environments/" + environmentId, "udm.Environment", {'members':map(lambda c: c.id, containers)}))
