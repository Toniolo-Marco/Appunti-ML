# Venv per il codice Python

-   Durante lo sviluppo del progetto è stato utilizzato un ambiente virtuale per Python. Per creare l'ambiente virtuale eseguire i comandi (dentro la cartella `/code`):

    ```bash
    python3 -m venv .venv

    source .venv/bin/activate
    ```

-   Per installare le librerie eseguire il comando:

    ```bash
    pip install -r requirements.txt
    ```

-   Per uscire dall'ambiente virtuale eseguire il comando:

    ```bash
    deactivate
    ```

# Workflow per VS Code

-   Per compilare automaticamente il file `main.typ`, con i file dei capitoli aggiornati, è presente una task che controlla i file `.typ` modificati e ricompila solo il main. Questa task viene esguita all'apertura della cartella del progetto. È necessario avere installato `cargo` e `watchexec-cli`; rispettivamente con:

    ```bash
    curl https://sh.rustup.rs -sSf | sh

    cargo install watchexec-cli
    ```

-   Per avere una preview del file `main.typ` è utile utilizzare l'estensione 'Tinymist' di VS Code.
