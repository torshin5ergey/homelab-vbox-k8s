#! python
# node_name_generator.py - generates node names
# with pattern node-master, node-workerN

import sys
import json


def generate_node_names(count):
    node_names = {
            "0": "node-master"
    }
    for i in range(1, count):
        node_names[str(i)] = f"node-worker{i}"
    return node_names


def main():
    node_count = int(sys.argv[1])
    result = generate_node_names(node_count)
    print(json.dumps(result))

if __name__ == "__main__":
    main()
