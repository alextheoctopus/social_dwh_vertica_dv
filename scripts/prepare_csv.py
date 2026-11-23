
import csv
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent

SOURCE_DIR = BASE_DIR / "data"
TARGET_DIR = SOURCE_DIR / "clean"

TARGET_DIR.mkdir(exist_ok=True)

files = {
    "people.csv": 7,
    "groups.csv": 4,
    "chats.csv": 6,
}

for filename, expected_columns in files.items():

    source = SOURCE_DIR / filename
    target = TARGET_DIR / filename

    with open(source, "r", encoding="cp1251", newline="") as f:
        rows = list(csv.reader(f))

    cleaned_rows = []

    for row in rows:

        # Исправляем строки chats.csv с лишними кавычками
        if len(row) == 1:
            row = next(csv.reader([row[0]]))

        if len(row) != expected_columns:
            raise ValueError(
                f"{filename}: expected {expected_columns} columns, got {len(row)}"
            )

        cleaned_rows.append(row)

    with open(target, "w", encoding="utf-8", newline="") as f:
        writer = csv.writer(f)
        writer.writerows(cleaned_rows)

    print(f"{filename}: {len(cleaned_rows) - 1} records prepared")
