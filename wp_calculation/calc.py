import argparse
import numpy as np
from tqdm import tqdm

HEADER_LINES = 5


def read_init_file(path):
    with open(path, "r") as f:
        header = [next(f) for _ in range(HEADER_LINES)]
    print(f"  Reading {path}...", flush=True)
    data = np.loadtxt(path, skiprows=HEADER_LINES, dtype=np.float64)
    return header, data


def subtract_files(file1, file2, output):
    print("\n[1/4] Loading file 1...")
    header1, data1 = read_init_file(file1)

    print("[2/4] Loading file 2...")
    header2, data2 = read_init_file(file2)

    if data1.shape != data2.shape:
        raise ValueError("Files have different number of data points!")

    ijk1 = data1[:, :3].astype(int)
    ijk2 = data2[:, :3].astype(int)

    if not np.array_equal(ijk1, ijk2):
        raise ValueError("Grid mismatch between files!")

    print("[3/4] Computing differences...")
    diff = np.round((data1[:, 3] - data2[:, 3]) / 0.1, 14)

    mask = (diff > 1) | (diff < 0)
    flagged = np.where(mask)[0]
    if len(flagged):
        print(f"  Checking {len(flagged)} out-of-range values...")
        for idx in tqdm(flagged, desc="  Warnings", unit="row"):
            i, j, k = ijk1[idx]
            print(f"\n  Warning at ({i},{j},{k}): diff = {diff[idx]}")
    else:
        print("  No out-of-range values found.")

    print("[4/4] Writing output...")
    with open(output, "w") as out:
        out.writelines(header1)
        lines = [f"{i} {j} {k} {d}\n"
                 for (i, j, k), d in tqdm(zip(ijk1, diff), total=len(diff),
                                           desc="  Writing", unit="row")]
        out.writelines(lines)

    print(f"\nDone. Output written to {output}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Subtract two Allpix .init files")
    parser.add_argument("file1")
    parser.add_argument("file2")
    parser.add_argument("--output", default="calc_result.init")
    args = parser.parse_args()
    subtract_files(args.file1, args.file2, args.output)
