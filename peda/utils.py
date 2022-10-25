import subprocess
from rich import print

def runCommand(cmdArr):
    print("[bold green]========================================================[/bold green]")
    print(f"[bold green underline]PEDA: :person_running: command: [/bold green underline]{cmdArr}")
    print("[bold green]========================OUTPUT==========================[/bold green]")
    res = subprocess.run(cmdArr)
    print("[bold green]=========================DONE===========================[/bold green]")
    return res
