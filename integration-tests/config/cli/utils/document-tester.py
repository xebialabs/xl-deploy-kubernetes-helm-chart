import re, shutil, sys, tempfile

def isstart(line):
    return re.search('^\s*deployit>(.*)$', line)

def isend(line):
    return re.match('^\s*$', line)

def pyline(line):
    return re.search('^\s*deployit>(.*)$', line).group(1).strip()

def addpyexpr(tests, expr, tempDir):
    tests.append(expr.replace("/tmp/", (tempDir + "/").replace("\\", "/")))

#############
# Main

def executeDocumentation(path):
    tempDir = tempfile.mkdtemp()
    try:
        inFile = open(path)
        content = [ line.strip() for line in inFile.readlines() ]
        inFile.close()
    
        pythonTests = []
        inExpr = False
    
        currentExpr = ""
        for l in content:
            if inExpr:
                if isend(l):
                    inExpr = False
                    addpyexpr(pythonTests, currentExpr, tempDir)
                    continue
                elif isstart(l):
                    addpyexpr(pythonTests, currentExpr, tempDir)
                    currentExpr = pyline(l)
                else:
                    currentExpr = currentExpr + " " + l
            elif isstart(l):
                    inExpr = True
                    currentExpr = pyline(l)
    
        for e in pythonTests:
            print "-- Executing Py stmt: " + e
            exec(e)
    finally:
        shutil.rmtree(tempDir)
