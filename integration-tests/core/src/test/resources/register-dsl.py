from java.util import UUID

dslRandomHostCis = []
dslRandomInfrastructureCis = []
dslRandomConfigurationCis = []
dslRandomEnvironmentCis = []
dslRandomDictCis = []
dslApplicationCis = []
dslFolderCis = []
dslImportedPackages = []

def importPackage(name):
    importedPackage = deployit.importPackage(name)
    dslImportedPackages.append(importedPackage.id)
    return importedPackage

def create_random_host(name, kind = "overthere.LocalHost", options = {"os" : os_family() }):
    server = repository.create(factory.configurationItem("Infrastructure/%s-%s" % (name, UUID.randomUUID().toString()), kind, options))
    dslRandomHostCis.append(server.id)
    return server

def create_lockManager(name, kind = "lock.Manager", options = { }):
    server = repository.create(factory.configurationItem("Infrastructure/%s-%s" % (name, UUID.randomUUID().toString()), kind, options))
    dslRandomHostCis.append(server.id)
    return server

def create_random_server(name, kind, options = {}, root = "Infrastructure"):
    server = repository.create(factory.configurationItem("%s/%s-%s" % (root, name, UUID.randomUUID().toString()), kind, options))
    dslRandomInfrastructureCis.append(server.id)
    return server

def create_random_yak_server(name = "yak", options = {}):
    return create_random_server(name, "yak.YakServer", options)

def create_random_dummy_server():
    return create_random_server('deployment-dummy', 'test-v3.DummyJeeServer', {'numberOfSteps': '10',
                                                                               'amountOfKBLogFiles': '2',
                                                                               'stepDelayTimeInMilliSeconds': '1000',
                                                                               'hostName': 'localhost'})

def create_random_environment(name, members, dictionaries = []):
    environment = repository.create(factory.configurationItem("Environments/%s-%s" % (name, UUID.randomUUID().toString()), "udm.Environment", {"members": members, "dictionaries": dictionaries}))
    dslRandomEnvironmentCis.append(environment.id)
    return environment

def create_random_environment_with_lock(name, members, dictionaries = []):
    environment = repository.create(factory.configurationItem('Environments/%s-%s' % (name, UUID.randomUUID().toString()), 'udm.Environment', {'members': members, 'dictionaries': dictionaries, 'allowConcurrentDeployments' : 'false', 'lockAllContainersInEnvironment' : 'true'}))
    dslRandomEnvironmentCis.append(environment.id)
    return environment

def create_random_dict(options = {}, kind = "udm.Dictionary"):
    dict = repository.create(factory.configurationItem("Environments/dict-%s" % UUID.randomUUID().toString(), kind, options))
    dslRandomDictCis.append(dict.id)
    return dict

def create_random_environment_with_yak_server(path = "env"):
    server = create_random_yak_server()
    return create_random_environment(path, [server.id])

def create_random_application(name, options = {}, salt = UUID.randomUUID().toString()):
    applicationCi = repository.create(factory.configurationItem('Applications/%s-%s' %(name, salt), 'udm.Application', options))
    dslApplicationCis.append(applicationCi.id)
    return applicationCi

def create_random_folder(name, root = 'Applications'):
    folderCi = repository.create(factory.configurationItem('%s/%s-%s' %(root, name, UUID.randomUUID().toString()), 'core.Directory', {}))
    dslFolderCis.append(folderCi.id)
    return folderCi

def create_random_configuration(name, kind, options = {}):
    configCi = repository.create(factory.configurationItem('Configuration/%s-%s' %(name, UUID.randomUUID().toString()), kind, options))
    dslRandomConfigurationCis.append(configCi.id)
    return configCi
