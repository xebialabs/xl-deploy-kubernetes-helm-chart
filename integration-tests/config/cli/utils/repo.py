from asserts import assert_false
from asserts import assert_true
from org.python.core.util import StringUtil
from utils import extract_ids
from utils import if_none


def concat_id(parent_id, name):
    return "%(parent_id)s/%(name)s" % {'parent_id': parent_id, 'name': name}


def create_provisioning_package(blueprint_id, name, params=None):
    params = if_none(params, {})
    params['application'] = blueprint_id
    return repository.create(
        factory.configurationItem(concat_id(blueprint_id, name), "udm.ProvisioningPackage", params)
    )


def create_blueprint(blueprint_name, directory_id=None, params=None):
    params = if_none(params, {})
    directory_id = if_none(directory_id, "Applications")
    return repository.create(
        factory.configurationItem(concat_id(directory_id, blueprint_name), "udm.Application", params))


def create_template(package_id, name, type, instance_name=None, params=None):
    params = if_none(params, {})
    if instance_name is not None:
        params['instanceName'] = instance_name
    return repository.create(factory.configurationItem(concat_id(package_id, name), type, params))


def update(ci):
    repository.update(ci)


def create_dummy_provisionable(package_id, name, templates=None, provisioners=None, params=None):
    templates = if_none(templates, [])
    provisioners = if_none(provisioners, [])
    params = if_none(params, {})
    params['boundTemplates'] = extract_ids(templates)
    params['provisioners'] = extract_ids(provisioners)
    return repository.create(
        factory.configurationItem(concat_id(package_id, name), "dummy-provider.Provisionable", params))


def create_dummy_provider(name, params=None):
    params = if_none(params, {})
    return repository.create(
        factory.configurationItem(concat_id("Infrastructure", name), "dummy-provider.Provider", params))


def create_provisioning_environment_with_dictionaries(name, directory_id=None, providers=None, dictionaries=None,
                                                      params=None):
    params = if_none(params, {})
    members = if_none(providers, [])
    dictionaries = if_none(dictionaries, [])
    directory_id = if_none(directory_id, "Environments")
    params['members'] = extract_ids(members)
    params['dictionaries'] = extract_ids(dictionaries)
    return repository.create(
        factory.configurationItem(concat_id(directory_id, name), "udm.Environment", params))


def create_provisioning_environment(name, directory_id=None, providers=None, params=None, dir_path=None):
    params = if_none(params, {})
    members = if_none(providers, [])
    directory_id = if_none(directory_id, "Environments")
    params['members'] = extract_ids(members)
    if dir_path:
        params["directoryPath"] = dir_path
    return repository.create(
        factory.configurationItem(concat_id(directory_id, name), "udm.Environment", params))


def create_dummy_manifest(provisionable_id, name, content, host_template, params=None):
    params = if_none(params, {})
    manifest_id = concat_id(provisionable_id, name)
    params['hostTemplate'] = host_template.id
    artifact = factory.artifact(manifest_id, "dummy-provisioner.Manifest", params, StringUtil.toBytes(content))
    artifact.filename = name
    print artifact
    return repository.create(artifact)


def create_dummy_module(manifest_id, name):
    return repository.create(
        factory.configurationItem(concat_id(manifest_id, name), "dummy-provisioner.ModuleSpec", {}))


def create_directory(parent_dir, name):
    return repository.create(factory.configurationItem(concat_id(parent_dir, name), "core.Directory", {}))


def delete(cis):
    for id in extract_ids(cis):
        repository.delete(id)


def assert_exists(id):
    assert_true(repository.exists(id))


def assert_not_exists(id):
    assert_false(repository.exists(id))


def create_dictionary(dictionary_name, environment_id):
    dict = "Environments/%(dict_name)s" % {'dict_name': dictionary_name}
    print "dict"
    print dict
    return repository.create(
        factory.configurationItem(dict, 'udm.Dictionary', {'entries': {'ENV_NAME': environment_id}}))


def created_env(environment_name, provisioning_id, dir_path=None):
    if dir_path:
        return "Environments/%(dir_path)s/%(env_name)s-%(provisioning_id)s" % {'env_name': environment_name,
                                                                               'provisioning_id': provisioning_id,
                                                                               'dir_path': dir_path}
    return "Environments/%(env_name)s-%(provisioning_id)s" % {'env_name': environment_name,
                                                              'provisioning_id': provisioning_id}


def start_task(task_id):
    task2.start(task_id)

def archive_task(task_id):
    task2.archive(task_id)


def read_task(task_id):
    return task2.get(task_id)


def has_task_failed(task):
    return 'FAILED' in task.state.name()


def assert_for_repo_to_be_updated(deployed_app_id, retry_count=20, sleep_time=1):
    retries = 1
    while retries < retry_count:
        try:
            deployedYakApp = repository.read(deployed_app_id)
            assertNotNone(deployedYakApp)
            return "Success"
        except:
            retries = retries + 1
            time.sleep(sleep_time)

    raise AssertionError(
            "Repository Item %s was not found in the repository", deployed_app_id)
