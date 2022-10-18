import typer
import generate

app = typer.Typer()

app.add_typer(generate.app, name="generate")

if __name__ == "__main__":
    app()
