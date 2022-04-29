
attempts = 2
expected_version = os.getenv('EXPECTED_DEPLOYIT_VERSION')
actual_version = ''

while(attempts > 0):
  print("Left attempt # %s " % attempts)
  actual_version = deployit.info().version
  if actual_version.startswith(expected_version):
    break
  else:
    time.sleep(1)
    attempts -= 1

if (attempts == 0):
  fail("Expected to find %s version, but actually is %s" % (expected_version, actual_version))
else:
  print("Current version # %s " % actual_version)
