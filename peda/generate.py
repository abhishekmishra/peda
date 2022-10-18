import os
import typer
import textwrap

app = typer.Typer()


@app.command()
def cmakeMinimal(projectName: str = "hello-world", mainFile: str = "main.cpp"):
    print(f"Creating {projectName} with file {mainFile}")
    os.mkdir(projectName)
    with open(os.path.join(projectName, 'CMakeLists.txt'), 'w') as cf:
        cf.write(textwrap.dedent(f"""
        cmake_minimum_required(VERSION 3.22)

        project({projectName})

        add_executable({projectName}
            {mainFile}
        )
        """))
