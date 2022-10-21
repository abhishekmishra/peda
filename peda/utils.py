import subprocess

def runCommand(cmdArr):
    print(cmdArr)
    return subprocess.run(cmdArr)