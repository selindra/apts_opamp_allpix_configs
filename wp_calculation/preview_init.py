import argparse


def preview_init_file(path, n_lines=10):
    with open(path, "r") as f:
        lines = f.readlines()

    print(f"\nPreview of: {path}")
    print("-" * 60)

    for i, line in enumerate(lines[:n_lines]):
        print(f"{i+1:4d} | {line.rstrip()}")

    print("-" * 60)
    print(f"Showing first {min(n_lines, len(lines))} lines.")
    print(f"Total lines in file: {len(lines)}")

    analyze_file(path)


def analyze_file(path):
    header_lines = 0
    data_rows = 0

    min_vals = [float("inf")] * 4
    max_vals = [float("-inf")] * 4

    with open(path, "r") as f:
        for line in f:
            parts = line.strip().split()

            # Only treat lines with exactly 4 columns as data
            if len(parts) == 4:
                try:
                    values = [float(x) for x in parts]
                    data_rows += 1

                    for i in range(4):
                        if values[i] < min_vals[i]:
                            min_vals[i] = values[i]
                        if values[i] > max_vals[i]:
                            max_vals[i] = values[i]

                except ValueError:
                    header_lines += 1
            else:
                header_lines += 1

    print("\nFile statistics")
    print("-" * 60)
    print(f"Header lines: {header_lines}")
    print(f"Data rows (4 columns): {data_rows}")
    print("Number of columns (data): 4")

    print("\nColumn statistics:")
    for i in range(4):
        print(
            f"Column {i+1}: "
            f"min = {min_vals[i]:.6g}, "
            f"max = {max_vals[i]:.6g}"
        )


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Preview and analyze Allpix .init file")
    parser.add_argument("file", help="Path to .init file")
    parser.add_argument("--n", type=int, default=10,
                        help="Number of lines to preview (default: 10)")

    args = parser.parse_args()
    preview_init_file(args.file, args.n)