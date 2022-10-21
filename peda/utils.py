import subprocess
from rich import print

def runCommand(cmdArr):
    print("[bold green underline]========================================================[/bold green underline]")
    print(f"[bold green underline]PEDA: :person_running: command: [/bold green underline]{cmdArr}")
    print("[bold green underline]========================OUTPUT==========================[/bold green underline]")
    res = subprocess.run(cmdArr)
    print("[bold green underline]=========================DONE===========================[/bold green underline]")
    return res
