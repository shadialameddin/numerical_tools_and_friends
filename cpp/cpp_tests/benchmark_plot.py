
import numpy
import matplotlib.pyplot as plt
import json

if __name__ == "__main__":

    with open('benchmark_output.json', 'r') as input_file:
        json_file = json.load(input_file)

    plotting_data = {}

    for benchmark in json_file["benchmarks"]:
        plotting_data[benchmark["name"].split("/")[0]] = []

    lengths = []

    for benchmark in json_file["benchmarks"]:

        method, length = benchmark["name"].split("/")

        lengths.append(int(length))

        plotting_data[method].append(benchmark["bytes_per_second"])

    lengths = list(set(lengths))
    lengths.sort()

    # Convert to size in kB
    lengths = [i * 8 / 1e3 for i in lengths]

    plt.figure(1)
    plt.semilogx(lengths, [i / 1.0e9 for i in plotting_data["eigen_dot"]],
                 lengths, [i / 1.0e9 for i in plotting_data["std_inner_product"]])
    plt.legend(["Eigen", "Standard"])
    plt.xlabel('Vector size kB')
    plt.ylabel('GB/s')
    plt.title('Inner product')
    plt.grid(True)
    plt.axvline(x=32)
    plt.axvline(x=256)
    plt.axvline(x=3072)

    plt.figure(2)
    plt.semilogx(lengths, [i / 1.0e9 for i in plotting_data["eigen_sum"]],
                 lengths, [i / 1.0e9 for i in plotting_data["std_accumulate"]])
    plt.legend(["Eigen", "Standard"])
    plt.xlabel('Vector size kB')
    plt.ylabel('GB/s')
    plt.title('Vector sum')
    plt.grid(True)
    plt.axvline(x=32)
    plt.axvline(x=256)
    plt.axvline(x=3072)

    plt.show()
