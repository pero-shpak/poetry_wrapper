# Poetry Install Wrapper :rocket:

Welcome to **Poetry Install Wrapper** — your ultimate tool for managing Python projects with Poetry, but with a twist!  :performing_arts: 
This script wraps around Poetry, adding some extra magic to make your life easier (and a bit more fun). :sparkles:

---

## What Does It Do? 🤔

This script is like a Swiss Army knife for Python projects using Poetry. It helps you:

1. **Automagically install Poetry** if it's not already installed.  
   (Because who has time to read installation docs? :sweat_smile:)

2. **Configure Poetry** to create virtual environments inside your project folder.  
   (No more hunting for `.venv` in obscure directories!)

3. **Add custom commands** to Poetry:
   - `poetry create`: Creates a new project with a virtual environment.  
   - `poetry clear`: Cleans up your project by removing the virtual environment and related files.  
   (Think of it as a "reset button" for your project. :broom:)

4. **Generate a `pyproject.toml`** with sensible defaults.  
   (Because starting from scratch is overrated.)

5. **Create a `.gitignore`** file to keep your virtual environment out of Git.  
   (Because nobody wants to commit their `.venv` by accident. :see_no_evil:)

---

## How to Use It? 🛠️

### Installation
1. Clone this repository or download the script.
2. Run the script in your terminal:
   ```bash
   bash poetry_install_wrapper.sh
Sit back and watch the magic happen. :sparkles:

Key Features and Commands
poetry create
Creates a new Poetry project with a virtual environment.
Usage:

bash
Copy
poetry create
Prompts you for a project name, description, and Python version.

Automatically generates a pyproject.toml and readme.md.

Sets up a virtual environment in the project folder.

poetry clear
Cleans up your project by removing the virtual environment and related files.
Usage:

bash
Copy
poetry clear
Deletes the .venv directory.

Removes pyproject.toml, poetry.lock, and .gitignore.

Perfect for when you want to start fresh (or pretend the last few hours never happened). :sweat_smile:

Why Use This Script? :shrug:`
It saves time. :hourglass_flowing_sand:
No more manually configuring Poetry or setting up virtual environments.

It's beginner-friendly. :hatching_chick:
Even if you've never used Poetry before, this script will guide you through the process.

It's fun! :tada:
Как использова
Who said managing Python projects has to be boring?

Pro Tips :bulb:
If you're feeling adventurous, customize the pyproject.toml after it's generated.

Use poetry clear responsibly. It's like a "delete" button — there's no undo! :warning:

If something breaks, just blame the script. It won't mind. :stuck_out_tongue_winking_eye:

Contributing
Found a bug? Have an idea for a new feature? Feel free to open an issue or submit a pull request.
(Or just send us a meme. We love memes. :frog:)

License
This project is licensed under the Do What the F* You Want to Public License**.
(Seriously, do whatever you want with it. Just don't blame us if it breaks. :wink:)

Happy coding! :rocket:
— The Poetry Install Wrapper Team :performing_arts:

