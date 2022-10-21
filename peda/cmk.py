import glob
import os
import sys
import platform
import typer
import shutil

from .utils import runCommand

app = typer.Typer()


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


@app.command(
    context_settings={"allow_extra_args": True, "ignore_unknown_options": True}
)
def run(ctx: typer.Context, prog: str, buildDir: str = './build', buildConfig: str = 'Debug'):
    if prog == None:
        print("Program name missing", file=sys.stderr)
    else:
        # for extra_arg in ctx.args:
        #     print(f"Got extra arg: {extra_arg}")
        if platform.system() == 'Windows':
            winExePath = os.path.join(buildDir, buildConfig, prog + '.exe')
            # print(winExePath)
            runCommand([winExePath] + ctx.args)
        else:
            exePath = os.path.join(buildDir, prog)
            # print(exePath)
            runCommand([exePath] + ctx.args)