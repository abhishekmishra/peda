import glob
import os
import sys
import platform
import typer
import subprocess
import shutil

app = typer.Typer()


def runCommand(cmdArr):
    print(cmdArr)
    return subprocess.run(cmdArr)


@app.command()
def genbuild(buildDir: str = './build'):
    runCommand(["cmake", ".", "-B", buildDir])


@app.command()
def delbuild(buildDir: str = './build'):
    shutil.rmtree(buildDir)


@app.command()
def build(buildDir: str = './build'):
    runCommand(["cmake", "--build", buildDir])


@app.command()
def clean(buildDir: str = './build'):
    runCommand(["cmake", "--build", buildDir, "--target", "clean"])


@app.command()
def sln(buildDir: str = './build'):
    if platform.system() == 'Windows':
        # print("We are in windows")
        slns = glob.glob(buildDir + '/*.sln')
        # print(slns)
        if len(slns) > 0:
            #runCommand(["start", slns[0]])
            os.startfile(slns[0])
        else:
            print("No solution files found!", file=sys.stderr)

