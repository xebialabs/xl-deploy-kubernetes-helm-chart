#library containing utility functions for testing in jython
import os

DEFAULT_PASSWORD = 'Password_1'

def assertNone(object):
    if object is not None:
        raise AssertionError("expected None but is ", object)

def assertNotNone(object):
    if object is None:
        raise AssertionError("expected not None but is None")

def fail(message):
    raise AssertionError(message)

def assertTrue(condition, message = None):
    assertEquals(True, condition, message)

def assertFalse(condition, message = None):
    assertEquals(False, condition, message)

def assertEquals(expected, actual, message = None):
    msg = "Expected "
    if message != None:
        msg = message + ": " + msg
    if expected != actual:
        raise AssertionError(msg + str(expected) + " but was " + str(actual))

def assertNotEquals(expected, actual, message = None):
    msg = "Expected non equality of "
    if message != None:
        msg = message + ": " + msg
    if expected == actual:
        raise AssertionError(msg + str(expected) + " and " + str(actual))

def assertStepState(taskId, stepId, expectedState) :
    step = task2.step(taskId, stepId)
    assertNotNone(step)
    assertEquals(expectedState, step.state)

def assertTaskState(taskId, expectedState) :
    task = task2.get(taskId)
    assertNotNone(task)
    assertEquals(expectedState, task.state)

def switchUser(name):
    print "** Logging as user " + name
    security.logout()
    if name == 'admin':
        security.login(name, name)
    else:
        security.login(name, DEFAULT_PASSWORD)

def createUser(name, permissions=None, group=None, role=None):
    if permissions is None:
        permissions = []

    if group is None:
        group = name

    if role is None:
        role = name

    security.createUser(name, DEFAULT_PASSWORD)
    security.assignRole(name, [role])

    for p in permissions:
        if isinstance(p, tuple):
            if isinstance(p[1], list):
                security.grant(p[0], name, p[1])
            else:
                security.grant(p[0], name, [p[1]])
        else:
            security.grant(p, name)

def deploy(deployable, env) :
    print "** Deploying " + deployable.id + " into " + env.id
    depl = deployment.prepareInitial(deployable.id, env.id)
    depl = deployment.prepareAutoDeployeds(depl)
    taskId = deployment.createDeployTask(depl).id
    return depl, taskId

def should_fail(msg, operation, *args) :
    try:
        operation(*args)
    except:
        pass
    else:
        fail(msg)


def os_family() :
    import java.lang.System
    if "windows" in java.lang.System.getProperty('os.name').lower():
        return "WINDOWS"
    else:
        return "UNIX"

def parse_xml_content(xml_content):
    import xml.etree.ElementTree as ET
    return ET.fromstring(xml_content)

def remove_readonly(func, path, _):
    import os, stat
    os.chmod(path, stat.S_IWRITE)
    func(path)

def rmdir(dir):
    if os.path.exists(dir):
        import shutil
        shutil.rmtree(dir, onerror=remove_readonly)
