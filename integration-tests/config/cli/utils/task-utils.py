import time
from com.xebialabs.deployit.engine.api.execution import TaskExecutionState

max_retries = 600
sleep_interval = 0.5

def wait_for_report_task(task_id):
    retries = 1
    done = False

    while done != True:
        if retries > max_retries:
            raise AssertionError("Error waiting for report task: " + task_id)

        try:
            time.sleep(sleep_interval)
            task = proxies.report.getTask(task_id)
            print("task object: %s", task)
            assertNotNone(task)
            done = True
        finally:
            retries = retries + 1

def wait_for_task_state(task_id, expected_state):
    state = ''
    retries = 1

    while state != expected_state:
        if retries > max_retries:
            raise AssertionError("Error waiting for task state of task: " + task_id + ". Expected state: " + expected_state.name() + " current: " + task.state.name())
        try:
            time.sleep(sleep_interval)
            task = task2.get(task_id)
            state = task.state
        finally:
            retries = retries + 1

def wait_for_step_state(task_id, step_id, expected_state):
    state = ''
    retries = 1

    while state != expected_state:
        if retries > max_retries:
                    raise AssertionError("Error waiting for step state of task: " + task_id + ", step id: " + step_id + ". Expected state: " + expected_state.name() + " current: " + step.state.name())
        try:
            time.sleep(sleep_interval)
            step = task2.step(task_id, step_id)
            state = step.state
        finally:
            retries = retries + 1


def scheduleAndWait(task_id, date):
    if task2.get(task_id).state == TaskExecutionState.SCHEDULED:
        raise AssertionError('scheduleAndWait does not wait reliably if the task is already scheduled!')
    task2.schedule(task_id, date)
    wait_for_task_state(task_id, TaskExecutionState.SCHEDULED)

def abortAndWait(task_id):
    task2.abort(taskId)
    wait_for_task_state(task_id, TaskExecutionState.ABORTED)

def stopAndWait(task_id):
    task2.stop(taskId)
    wait_for_task_state(task_id, TaskExecutionState.STOPPED)

def wait_for_task_path_status(task_id, path, expected_state):
    state = ''
    retries = 1

    while state != expected_state:
        if retries > max_retries:
            raise AssertionError("Error waiting for task state of task: " + task_id + " on path: " + path + " . Expected state: " + expected_state + " current: " + state)
        try:
            time.sleep(sleep_interval)
            taskStatus = task2.getStatus(task_id, path)
            state = taskStatus.status()
        except:
            pass
        finally:
            retries = retries + 1
