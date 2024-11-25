import os
import shutil
import re


_PLUGIN_NAME = "harmonic_scale_tuner"
_SOURCE_FOLDER_PATH = "../source"
_README_PATH = "../README.md"
_LICENSE_PATH = "../LICENSE"
_THUMBNAIL_PATH = "../thumbnail/HarmonicScaleTunerThumbnail.png"
_FILES_TO_COPY = [
    _LICENSE_PATH,
    _THUMBNAIL_PATH,
]


def main():
    try:
        shutil.copytree(_SOURCE_FOLDER_PATH, _PLUGIN_NAME, dirs_exist_ok=True)
        for file_path in _FILES_TO_COPY:
            file_name = file_path[file_path.rindex("/") + 1:]
            shutil.copyfile(file_path, f"{_PLUGIN_NAME}/{file_name}")
        logs_folder = f"{_PLUGIN_NAME}/logs"
        if not os.path.exists(logs_folder):
            os.makedirs(logs_folder)

        version_number = get_version_number()
        output_folder_name = f"{_PLUGIN_NAME}_{version_number}"
        temporary_folder = "tmp"
        shutil.copytree(_PLUGIN_NAME, f"{temporary_folder}/{_PLUGIN_NAME}", dirs_exist_ok=True)
        shutil.make_archive(output_folder_name, "zip", temporary_folder)
        shutil.rmtree(temporary_folder)

    except Exception as e:
        print(e)
        input()


def get_version_number() -> str:
    version_number_pattern = re.compile(r"version:\s*\"(.+)\";")
    for root, _, files in os.walk(_SOURCE_FOLDER_PATH):
        for file_name in files:
            if simplify_file_name(_PLUGIN_NAME) not in simplify_file_name(file_name):
                continue

            file_path = os.path.join(root, file_name)
            with open(file_path, "r") as file:
                for line in file:
                    match = version_number_pattern.match(line.strip())
                    if match:
                        return match.group(1)

    raise Exception("Could not get the version number.")


def simplify_file_name(file_name: str) -> str:
    return file_name.replace("_", "").lower()


if __name__ == "__main__":
    main()
