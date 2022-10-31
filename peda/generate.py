import sys
import os
import typer
import textwrap
from rich import print
from .utils import runCommand

app = typer.Typer()


@app.command()
def cmakeMinimal(projectName: str = "hello-world",
                 mainFile: str = "main.cpp", lang: str = "CXX", vscode: bool = True):
    print(f"Creating {projectName} with file {mainFile}")
    os.mkdir(projectName)
    if vscode:
        vscodedir = os.path.join(projectName, '.vscode')
        os.mkdir(vscodedir)
        with open(os.path.join(vscodedir, 'c_cpp_properties.json'), 'w') as cf:
            cf.write(textwrap.dedent("""
            {
                "configurations": [
                    {
                        "name": "Mac",
                        "includePath": [
                            "${workspaceFolder}/**",
                            "${vcpkgRoot}/x64-osx/include",
                            "/usr/local/include/SDL2"
                        ],
                        "defines": [],
                        "macFrameworkPath": [
                            "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks"
                        ],
                        "compilerPath": "/usr/bin/clang",
                        "cStandard": "c17",
                        "cppStandard": "c++17",
                        "intelliSenseMode": "macos-clang-x64",
                        "configurationProvider": "ms-vscode.makefile-tools"
                    },
                    {
                        "name": "Win32",
                        "includePath": [
                            "${workspaceFolder}/**",
                            "${vcpkgRoot}/x64-windows/include",
                            "${vcpkgRoot}/x86-windows/include",
                            "${vcpkgRoot}/x64-windows/include/SDL2"
                        ],
                        "defines": [
                            "_DEBUG",
                            "UNICODE",
                            "_UNICODE"
                        ],
                        "windowsSdkVersion": "10.0.19041.0",
                        "compilerPath": "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.33.31629/bin/Hostx64/x64/cl.exe",
                        "cStandard": "c17",
                        "cppStandard": "c++17",
                        "intelliSenseMode": "windows-msvc-x64",
                        "configurationProvider": "ms-vscode.makefile-tools"
                    },
                    {
                        "name": "Linux",
                        "includePath": [
                            "${workspaceFolder}/**",
                            "/usr/include/SDL2"
                        ],
                        "defines": [],
                        "compilerPath": "/bin/g++",
                        "cStandard": "c17",
                        "cppStandard": "c++17",
                        "intelliSenseMode": "linux-clang-x64"
                    }
                ],
                "version": 4
            }
            """).strip())

        with open(os.path.join(vscodedir, 'tasks.json'), 'w') as tf:
            tf.write(textwrap.dedent("""
            {
                // See https://go.microsoft.com/fwlink/?LinkId=733558
                // for the documentation about the tasks.json format
                "version": "2.0.0",
                "tasks": [
                    {
                        "label": "Generate CMake Build",
                        "type": "shell",
                        "command": "make genbuild",
                        "windows": {
                            "command": "pemk",
                            "args": [
                                "genbuild",
                                "-DCMAKE_TOOLCHAIN_FILE=D:/vcpkg/scripts/buildsystems/vcpkg.cmake"
                            ]
                        },
                        "group": "build",
                        "presentation": {
                            "echo": true,
                            "reveal": "always",
                            "focus": false,
                            "panel": "shared",
                            "showReuseMessage": true,
                            "clear": false
                        }
                    },
                    {
                        "label": "Delete CMake Build",
                        "type": "shell",
                        "command": "make delbuild",
                        "group": "build",
                        "presentation": {
                            "echo": true,
                            "reveal": "always",
                            "focus": false,
                            "panel": "shared",
                            "showReuseMessage": true,
                            "clear": false
                        }
                    },
                    {
                        "label": "Build Project",
                        "type": "shell",
                        "command": "make build",
                        "group": "build",
                        "presentation": {
                            "echo": true,
                            "reveal": "always",
                            "focus": false,
                            "panel": "shared",
                            "showReuseMessage": true,
                            "clear": false
                        }
                    },
                    {
                        "label": "Clean Project",
                        "type": "shell",
                        "command": "make clean",
                        "group": "build",
                        "presentation": {
                            "echo": true,
                            "reveal": "always",
                            "focus": false,
                            "panel": "shared",
                            "showReuseMessage": true,
                            "clear": false
                        }
                    },
                    {
                        "label": "Clean/build/run (All) Project",
                        "type": "shell",
                        "command": "make all",
                        "group": "build",
                        "presentation": {
                            "echo": true,
                            "reveal": "always",
                            "focus": false,
                            "panel": "shared",
                            "showReuseMessage": true,
                            "clear": false
                        }
                    },
                    {
                        "label": "Build Run Project",
                        "type": "shell",
                        "command": "make build run",
                        "group": "build",
                        "presentation": {
                            "echo": true,
                            "reveal": "always",
                            "focus": false,
                            "panel": "shared",
                            "showReuseMessage": true,
                            "clear": false
                        }
                    },
                    {
                        "label": "Run Project",
                        "type": "shell",
                        "command": "make run",
                        "presentation": {
                            "echo": true,
                            "reveal": "always",
                            "focus": false,
                            "panel": "shared",
                            "showReuseMessage": true,
                            "clear": false
                        }
                    }
                ]
            }
            """).strip())
    
    with open(os.path.join(projectName, 'CMakeLists.txt'), 'w') as cf:
        cf.write(textwrap.dedent(f"""
        cmake_minimum_required(VERSION 3.22)

        # set the CPP standard to 17
        set(CMAKE_CXX_STANDARD 17)
        set(CMAKE_CXX_STANDARD_REQUIRED ON)

        project({projectName} {lang})

        add_executable({projectName}
            {mainFile}
        )
        """).strip())

    with open(os.path.join(projectName, 'Makefile'), 'w') as cf:
        cf.write(textwrap.dedent(f"""
        .PHONY: all genbuild delbuild build run clean

        all: clean build run

        genbuild:
        \tpemk genbuild

        delbuild:
        \tpemk delbuild

        build:
        \tpemk build

        run:
        \tpemk run {projectName}

        clean:
        \tpemk clean
        """).strip())

    if mainFile.lower().endswith('.cpp'):
        with open(os.path.join(projectName, mainFile), 'w') as pf:
            pf.write(textwrap.dedent("""
            #include <iostream>

            using namespace std;

            int main(int argc, char* argv[])
            {
                cout << "hello world\\n";
                return 0;
            }""").strip())

    if mainFile.lower().endswith('.c'):
        with open(os.path.join(projectName, mainFile), 'w') as pf:
            pf.write(textwrap.dedent("""
            #include <stdio.h>

            int main(int argc, char* argv[])
            {
                printf("hello world\\n");
                return 0;
            }
            """).strip())

    os.chdir(projectName)
    runCommand(["make", "genbuild"])
    runCommand(["make", "all"])
    os.chdir('..')

    print(f"[green]Project {projectName} generated, built and run![/green]")


@app.command()
def cppClass(className: str = None):
    if className != None:
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
    else:
        print("[red]Class name cannot be empty[/red]", file=sys.stderr)
