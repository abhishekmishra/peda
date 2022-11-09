import typer
import peda.generate
import peda.cmk

app = typer.Typer()

app.add_typer(peda.generate.app, name="generate")
app.add_typer(peda.cmk.app, name="cmk")

if __name__ == "__main__":
    app()
