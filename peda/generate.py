import os
import typer
import textwrap

app = typer.Typer()


@app.command()
def cmakeMinimal(projectName: str = "hello-world",
                 mainFile: str = "main.cpp", lang: str = "CXX"):
    print(f"Creating {projectName} with file {mainFile}")
    os.mkdir(projectName)
    with open(os.path.join(projectName, 'CMakeLists.txt'), 'w') as cf:
        cf.write(textwrap.dedent(f"""
        cmake_minimum_required(VERSION 3.22)

        # set the CPP standard to 17
        set(CMAKE_CXX_STANDARD 17)

        project({projectName} {lang})

        add_executable({projectName}
            {mainFile}
        )
        """).strip())

    if mainFile.lower().endswith('.cpp'):
        with open(os.path.join(projectName, mainFile), 'w') as pf:
            pf.write(textwrap.dedent("""
            #include <iostream>

            using namespace std;

            int main(int argc, char* argv[])
            {{
                cout << "hello world" << endl;
                return 0;
            }}
            """).strip())

    if mainFile.lower().endswith('.c'):
        with open(os.path.join(projectName, mainFile), 'w') as pf:
            pf.write(textwrap.dedent("""
            #include <stdio.h>

            int main(int argc, char* argv[])
            {{
                printf("hello world\n");
                return 0;
            }}
            """).strip())


@app.command()
def cppClass(className: str = None):
    with open(f'{className}.h', 'w') as hf:
        hf.write(textwrap.dedent(f"""
        #ifndef __{className.upper()}_H__
        #define __{className.upper()}_H__

        class {className} {{

        }};

        #endif //  __{className.upper()}_H__
        """).strip())

    with open(f'{className}.cpp', 'w') as cppf:
        cppf.write(textwrap.dedent(f"""
        #include "{className}.h"
        """).strip())
