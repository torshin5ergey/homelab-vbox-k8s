# deploy_vms.py - Deploy VirtualBox virtual machines using VBoxManage

import subprocess
import time
import sys
import os
import pprint as pp

import yaml
import pyinputplus as pyip


def load_config(config_file):
    """Read VMs yaml config file"""
    try:
        with open(config_file, "r", encoding="utf-8") as f:
            yaml_config = yaml.safe_load(f)
            return yaml_config
    except FileNotFoundError:
        print(f"Config file {config_file} not found")
        sys.exit()

def merge_configs(common: dict, custom: dict):
    """Recursively merge two configs (common+custom)"""
    merged = common.copy()
    for k, v in custom.items():
        if isinstance(v, dict) and k in merged:
            merged[k] = merge_configs(merged[k], v)
        else:
            merged[k] = v
    return merged


def wait_for_install(vm_name):
    print(f"Installing {vm_name}...", end="", flush=True)
    while True:
        result = subprocess.run(
            ["VBoxManage", "showvminfo", vm_name, "--machinereadable"],
            capture_output=True, # capture stdout and stderr
            text=True # return text instead of bytes
        )
        # Check if VM is poweroff (install completed)
        if "VMState=\"poweroff\"" in result.stdout:
            print(f"\nVM {vm_name} has been successfully installed!")
            break
        else:
            time.sleep(10) # wait 10 sec
            print(".", end="", flush=True) # immediate print to stdout (without buffering)


def create_vm(config):
    """Create and install VM"""
    # Create and register VM
    subprocess.run([
        "VBoxManage", "createvm",
        "--name", config["name"],
        "--ostype", config["ostype"],
        "--basefolder", config["basefolder"],
        "--register"
    ], check=True)

    # Setup VM storage
    subprocess.run([
        "VBoxManage", "createhd",
        "--filename", os.path.join(config["basefolder"], config["name"], f"{config['name']}.vdi"),
        "--size", str(config["hardware"]["storage"]),
        "--variant", "Standard",
        "--format", "VDI"
    ], check=True)

    # Add SATA Controller
    subprocess.run([
        "VBoxManage", "storagectl", config["name"],
        "--name", "SATA",
        "--add", "sata",
        "--bootable", "on",
        "--portcount", "2",
        "--hostiocache", "on"
    ])
    # Add IDE Storage Controller
    subprocess.run([
        "VBoxManage", "storagectl", config["name"],
        "--name", "IDE",
        "--add", "ide"
    ])
    # Attach SATA Controller
    subprocess.run([
        "VBoxManage", "storageattach", config["name"],
        "--storagectl", "SATA",
        "--port", "0",
        "--device", "0",
        "--type", "hdd",
        "--medium", os.path.join(config["basefolder"], config["name"], f"{config['name']}.vdi")
    ])
    # Attach IDE Controller
    subprocess.run([
        "VBoxManage", "storageattach", config["name"],
        "--storagectl", "IDE",
        "--port", "0",
        "--device", "0",
        "--type", "dvddrive",
        "--medium", config["iso_path"]
    ])

    # Define VM General Settings
    subprocess.run([
        "VBoxManage", "modifyvm", config["name"],
        "--cpus", str(config["hardware"]["cpus"]),
        "--memory", str(config["hardware"]["memory"]),
        "--vram", str(config["hardware"]["vram"]),
        "--ioapic", "on",
        "--boot1", "dvd", "--boot2", "disk", "--boot3", "none", "--boot4", "none",
        "--audio-driver", "none",
        "--usbohci", "on",
        "--mouse", "usbtablet",
        "--nic1", config["network"]["nic_type"]
    ])

    # VM auto install
    subprocess.run([
        "VBoxManage", "unattended", "install", config["name"],
        f"--user={config['credentials']['user']}",
        f"--password={config['credentials']['password']}",
        f"--country={config['advanced']['country']}",
        f"--time-zone={config['advanced']['time_zone']}",
        f"--language={config['advanced']['language']}",
        f"--iso={config['iso_path']}",
        "--post-install-command", config["advanced"]["post_install_command"],
        f"--start-vm={config['advanced']['start_vm']}"
    ])

    wait_for_install(config["name"])

if __name__ == "__main__":
    config = load_config("./cluster-test.yaml")

    print("Virtual Machine Setup Parameters:")
    pp.pprint(config)
    response = pyip.inputChoice(prompt="\nPerform these configurations?\n",
                                choices=["yes", "y", "true", "no", "n", "false"],
                                default="no",
                                blank=True,
                                caseSensitive=False,
                                strip=True
                               )
    if response in ("yes", "y", "true"):
        for vm_spec in config["vms"]:
            merged_config = merge_configs(config["common"], vm_spec)
            print(f"\nCreating VM: {merged_config['name']}")
            create_vm(merged_config)
        print(f"\nCreated VMs: {config['vms']}")
        print("\nAll VMs created successfully!")
    else:
        print("Apply canceled.")
        sys.exit()
