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


def wait_for_install(vm_name):
    print("Installing...", end="", flush=True)
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
        "--name", config["vm"]["name"],
        "--ostype", config["vm"]["ostype"],
        "--basefolder", config["vm"]["basefolder"],
        "--register"
    ], check=True)

    # Setup VM storage
    subprocess.run([
        "VBoxManage", "createhd",
        "--filename", os.path.join(config["vm"]["basefolder"], config["vm"]["name"], f"{config['vm']['name']}.vdi"),
        "--size", str(config["vm"]["hardware"]["storage"]),
        "--variant", "Standard",
        "--format", "VDI"
    ], check=True)

    # Add SATA Controller
    subprocess.run([
        "VBoxManage", "storagectl", config["vm"]["name"],
        "--name", "SATA",
        "--add", "sata",
        "--bootable", "on",
        "--portcount", "2",
        "--hostiocache", "on"
    ])
    # Add IDE Storage Controller
    subprocess.run([
        "VBoxManage", "storagectl", config["vm"]["name"],
        "--name", "IDE",
        "--add", "ide"
    ])
    # Attach SATA Controller
    subprocess.run([
        "VBoxManage", "storageattach", config["vm"]["name"],
        "--storagectl", "SATA",
        "--port", "0",
        "--device", "0",
        "--type", "hdd",
        "--medium", os.path.join(config["vm"]["basefolder"], config["vm"]["name"], f"{config['vm']['name']}.vdi")
    ])
    # Attach IDE Controller
    subprocess.run([
        "VBoxManage", "storageattach", config["vm"]["name"],
        "--storagectl", "IDE",
        "--port", "0",
        "--device", "0",
        "--type", "dvddrive",
        "--medium", config["iso_path"]
    ])

    # Define VM General Settings
    subprocess.run([
        "VBoxManage", "modifyvm", config["vm"]["name"],
        "--cpus", str(config["vm"]["hardware"]["cpus"]),
        "--memory", str(config["vm"]["hardware"]["memory"]),
        "--vram", str(config["vm"]["hardware"]["vram"]),
        "--ioapic", "on",
        "--boot1", "dvd", "--boot2", "disk", "--boot3", "none", "--boot4", "none",
        "--audio-driver", "none",
        "--usbohci", "on",
        "--mouse", "usbtablet",
        "--nic1", "nat"
    ])

    # VM auto install
    subprocess.run([
        "VBoxManage", "unattended", "install", config["vm"]["name"],
        f"--user={config['vm']['credentials']['user']}",
        f"--password={config['vm']['credentials']['password']}",
        "--country=RU", "--time-zone='Europe/Moscow'",
        "--language=en-US",
        f"--iso={config['iso_path']}",
        "--post-install-command", "shutdown -h now",
        "--start-vm=gui"
    ])

    wait_for_install(config["vm"]["name"])

if __name__ == "__main__":
    config = load_config("./vmconfig.yaml")

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
        create_vm(config)
    else:
        print("Apply canceled.")
        sys.exit()
