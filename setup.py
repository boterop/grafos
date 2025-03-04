import os


def get_mix_project_name():
    with open("mix.exs", "r") as f:
        content = f.read()
        return content.split("app: ")[1].split(",")[0].strip().replace(":", "")


def capitalize(text):
    return " ".join([t.capitalize() for t in text.split(" ")])


original_name = get_mix_project_name()
capitalized_original_name = capitalize(original_name.replace("_", " ")).replace(" ", "")

root = ""
dirs = os.listdir(".")

name = (
    input(f"New project name (e.g. {original_name}): ")
    .strip()
    .replace(" ", "_")
    .lower()
)
capitalized_name = capitalize(name.replace("_", " ")).replace(" ", "")

ignored = open(".gitignore").read().splitlines()
ignored = [i.strip() for i in ignored if i.strip() != ""]
ignored = [i for i in ignored if i[0] not in ["#", "!"]]
ignored = map(lambda i: i if i[0] != "/" else i[1:], ignored)
ignored = map(lambda i: i if i[-1] != "/" else i[:-1], ignored)
ignored = list(ignored)
ignored.extend((".git", ".elixir_ls", "setup.py"))


def rename(path, original, new):
    os.rename(path, path.replace(original, new))


def rename_file(dirs, path):
    for file in dirs:
        absolute_path = os.path.join(path, file)
        try:
            should_ignore = len([i for i in ignored if absolute_path == i]) > 0
            if should_ignore:
                continue
            if os.path.isdir(absolute_path):
                rename_file(os.listdir(absolute_path), absolute_path)

            if os.path.isfile(absolute_path):
                rename_content(absolute_path)

            if original_name in file:
                rename(absolute_path, original_name, name)

            if capitalized_original_name in file:
                rename(absolute_path, capitalized_original_name, capitalized_name)
        except Exception as e:
            print(f"Error renaming {absolute_path}: {e}")


def rename_content(path):
    with open(path, "r") as f:
        content = f.read()
        content = content.replace(original_name, name)
        content = content.replace(capitalized_original_name, capitalized_name)
        with open(path, "w") as f:
            f.write(content)


rename_file(dirs, root)

print(f"Project renamed to {capitalized_name}")
