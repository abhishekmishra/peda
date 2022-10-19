import os
import typer
import textwrap

app = typer.Typer()


@app.command()
def cmakeMinimal(projectName: str = "hello-world", mainFile: str = "main.cpp", lang: str = "CXX"):
    print(f"Creating {projectName} with file {mainFile}")
    os.mkdir(projectName)
    with open(os.path.join(projectName, 'CMakeLists.txt'), 'w') as cf:
        cf.write(textwrap.dedent(f"""
        cmake_minimum_required(VERSION 3.22)

        project({projectName} {lang})

        add_executable({projectName}
            {mainFile}
        )
        """))
    
    if mainFile.lower().endswith('.cpp'):
        with open(os.path.join(projectName, mainFile), 'w') as pf:
            pf.write(textwrap.dedent(f"""
            #include <iostream>

            using namespace std;

            int main(int argc, char* argv[]) 
            {{
                cout << "hello world" << endl;
                return 0;
            }}
            """))

    if mainFile.lower().endswith('.c'):
        with open(os.path.join(projectName, mainFile), 'w') as pf:
            pf.write(textwrap.dedent(f"""
            #include <stdio.h>

            int main(int argc, char* argv[]) 
            {{
                printf("hello world\n");
                return 0;
            }}
            """))
