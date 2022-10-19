import os
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
