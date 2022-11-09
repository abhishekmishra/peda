import subprocess
from rich import print
import importlib.util
import sys
import os
from importlib.machinery import SourceFileLoader

# see https://stackoverflow.com/a/43602645/9483968 for mechanism
# to load a source file (not ending with .py) as a python file.
# also see documentation at https://docs.python.org/3/library/importlib.html#importing-a-source-file-directly
def loadPedaUserConfig():
    """
    This method loada a special module called "peda_prj_cfg"
    from a special file in the current folder named ".peda"
    This module can specify additional commands which can be run
    by peda.

    It can also be used for other user customization.
    """
    file_path = os.path.abspath(".peda")
    module_name = "peda_prj_cfg"

    if os.path.exists(file_path):
        print(f"{file_path!r} exists")
    else:
        return
    
    if module_name in sys.modules:
        print(f"{module_name!r} already in sys.modules")
    elif (spec := importlib.util.spec_from_loader(module_name, SourceFileLoader(module_name,
        file_path))) is not None:
        module = importlib.util.module_from_spec(spec)
        sys.modules[module_name] = module
        spec.loader.exec_module(module)
        print("Loaded... ", module)
    else:
        print(f"can't find the {module_name!r} module")


def runCommand(cmdArr):
    print("[bold green]========================================================[/bold green]")
    print(f"[bold green underline]PEDA: :person_running: command: [/bold green underline]{cmdArr}")
    print("[bold green]========================OUTPUT==========================[/bold green]")
    res = subprocess.run(cmdArr)
    print("[bold green]=========================DONE===========================[/bold green]")
    return res
