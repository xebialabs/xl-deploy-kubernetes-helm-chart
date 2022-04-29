### Checklist ##########################################################################################################

def create_user(username, role=None, permissions={}):
    if not role:
        role = username
    security.createUser(username, DEFAULT_PASSWORD)
    security.assignRole(role, [username])
    for perm, roots in permissions.items():
        if not roots:
            security.grant(perm, role)
        else:
            security.grant(perm, role, roots)

create_user('checklist-user1', permissions={'login': [], 'import#initial': ['Applications'], 'import#upgrade': ['Applications'], 'deploy#initial': ['Environments']})

### Deployment #########################################################################################################

yakDirectory = repository.create(factory.configurationItem("Environments/deployment-dir", "core.Directory"))

create_user('deployment-user', permissions={'login': [], 'read': ['Applications', 'Environments'], 'deploy#initial': ['Environments']})
create_user('deployment-task-listing-user', permissions={'login': [], 'read': ['Applications', 'Environments'], 'deploy#initial': [yakDirectory.id]})
create_user('deployment-task-listing-user2', permissions={'login': [], 'read': ['Applications', 'Environments'], 'deploy#initial': ['Environments', yakDirectory.id]})
create_user('deployment-task-assigning-user', permissions={'login': [], 'read': ['Applications', 'Environments'], 'deploy#initial': ['Environments'], 'task#assign': []})

### exportcis ##########################################################################################################

username = 'exportcis-nonAdmin'
createUser(username, permissions=['login'])

### history ############################################################################################################

security.createUser('alice-history', DEFAULT_PASSWORD)
security.createUser('bob-history', DEFAULT_PASSWORD)
security.createUser('mallory-history', DEFAULT_PASSWORD)
security.assignRole('users-history', ['alice-history', 'bob-history', 'mallory-history'])
security.grant('login', 'users-history')
security.grant('repo#edit','users-history', ['Infrastructure'])

### preview ############################################################################################################

create_user('user-without-task-preview', 'role-without-task-preview', {'login': [], 'read': ['Applications', 'Environments'], 'deploy#initial': ['Environments'], 'deploy#upgrade': ['Environments']})

### taskblock ############################################################################################################

securedDirectory = repository.create(factory.configurationItem("Environments/task-blocks-dir", "core.Directory"))

create_user('task-blocks-user2', 'deployer', {'login': [], 'read': ['Applications', 'Environments'], 'deploy#initial': ['Environments']})
create_user('task-blocks-task-listing-user', 'task-blocks-task-listing-role', {'login': [], 'read': ['Applications', 'Environments'], 'deploy#initial': [securedDirectory.id]})
create_user('task-blocks-task-listing-user2', 'task-blocks-task-listing-secured-role', {'login': [], 'read': ['Applications', 'Environments'], 'deploy#initial': ['Environments', securedDirectory.id]})
create_user('task-blocks-task-assigning-user', 'task-blocks-task-assigning-role', {'login': [], 'read': ['Applications', 'Environments'], 'deploy#initial': ['Environments'], 'task#assign': []})
create_user('task-blocks-task-takeover-user', 'task-blocks-task-takeover-role', {'login': [], 'read': ['Applications', 'Environments'], 'task#takeover': ['Environments']})

create_user('task-blocks-starter', permissions={'login': [], 'deploy#initial': [securedDirectory.id], 'deploy#upgrade': [securedDirectory.id], 'task#move_step': [], 'task#skip_step': []})
create_user('task-blocks-other_user', permissions={'login': [], 'deploy#initial': [securedDirectory.id], 'deploy#undeploy': [securedDirectory.id]})

### defaults #########################################################################################################

securedDirectory = repository.create(factory.configurationItem("Applications/credentials-folder", "core.Directory"))
securedDirectory = repository.create(factory.configurationItem("Applications/proxyServer-folder", "core.Directory"))
create_user('create-ci-user', 'create-ci', {'login': [],
                                            'read': ['Applications/credentials-folder', 'Applications/proxyServer-folder', 'Environments'],
                                            'repo#edit': ['Environments', 'Applications/credentials-folder', 'Applications/proxyServer-folder']})
