import time
from com.xebialabs.deployit.booter.remote.resteasy import DeployitClientException

attempts = 2
expected_number_of_workers = os.getenv('EXPECTED_NUMBER_OF_WORKERS')
if expected_number_of_workers:
  expected_number_of_workers = int(expected_number_of_workers)
else:
  expected_number_of_workers = 2
actual_number_of_workers = 0

while(attempts > 0):
  print("Left attempt # %s " % attempts)
  actual_number_of_workers = len(filter(lambda worker: worker.state == "CONNECTED", workers.list()))
  if expected_number_of_workers != actual_number_of_workers:
    time.sleep(10)
    attempts -= 1
  else:
    break

if (attempts == 0):
    fail("Expected to find %s number of workers, but actually is %s " % (expected_number_of_workers, actual_number_of_workers))
