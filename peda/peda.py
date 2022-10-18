import typer
import peda.generate

app = typer.Typer()

app.add_typer(peda.generate.app, name="generate")

if __name__ == "__main__":
    app()
