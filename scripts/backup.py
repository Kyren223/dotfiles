import os
import sys
import json
import subprocess
import time

folders_created = 0
folders_existed = 0
files_uploaded = 0
files_existed = 0
files_replaced = 0

def run_cmd(cmd):
    print(f"Running: {cmd}")
    p = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    if p.stderr:
        print(f"Error running command: {p.stderr}")
        raise Exception(f"Command failed: {cmd} - {p.stderr}")
    try:
        return json.loads(p.stdout)
    except json.JSONDecodeError:
        print(f"Non-JSON output: {p.stdout}")
        raise Exception(f"Invalid JSON from: {cmd}")

def get_listing(remote_id):
    cmd = f'internxt list --json --non-interactive --id="{remote_id}"'
    out = run_cmd(cmd)
    if out.get('success', False):
        return out['list']
    else:
        print(f"List failed: {out.get('message', 'Unknown error')}")
        raise Exception(f"Failed to list {remote_id}")

def find_folder_uuid(parent_id, name):
    listing = get_listing(parent_id)
    for folder in listing['folders']:
        if folder['plainName'] == name:
            print(f"Folder '{name}' exists in '{parent_id}', uuid: {folder['uuid']}")
            return folder['uuid']
    return None

def create_folder(parent_id, name):
    cmd = f'internxt create-folder --json --non-interactive --name="{name}" --id="{parent_id}"'
    out = run_cmd(cmd)
    if out.get('success', False):
        uuid = out['folder']['uuid']
        print(f"Created folder '{name}' in '{parent_id}', uuid: {uuid}")
        return uuid
    else:
        print(f"Failed to create folder '{name}': {out.get('message', 'Unknown error')}")
        raise Exception(f"Failed to create folder {name}")

def find_or_create_folder(parent_id, name):
    global folders_created, folders_existed
    uuid = find_folder_uuid(parent_id, name)
    if uuid:
        folders_existed += 1
        return uuid
    else:
        folders_created += 1
        return create_folder(parent_id, name)

def find_file_uuid(parent_uuid, full_name):
    stem, ext = os.path.splitext(full_name)
    ext = ext.lstrip('.')
    listing = get_listing(parent_uuid)
    for file in listing['files']:
        if file['plainName'] == stem and file.get('type', '') == ext:
            print(f"File '{full_name}' exists in '{parent_uuid}', uuid: {file['uuid']}")
            return file['uuid']
    return None

def upload_file(local_path, dest_uuid):
    cmd = f'internxt upload-file --json --non-interactive --file="{local_path}" --destination="{dest_uuid}"'
    out = run_cmd(cmd)
    if out.get('success', False):
        print(f"Uploaded '{local_path}' to '{dest_uuid}'")
        return True
    else:
        print(f"Failed to upload '{local_path}': {out.get('message', 'Unknown error')}")
        return False

def trash_file(file_uuid):
    cmd = f'internxt trash-file --json --non-interactive --id="{file_uuid}"'
    out = run_cmd(cmd)
    if out.get('success', False):
        print(f"Trashed file '{file_uuid}'")
        return True
    else:
        print(f"Failed to trash '{file_uuid}': {out.get('message', 'Unknown error')}")
        return False

def handle_file(local_path, dest_uuid, mode):
    global files_uploaded, files_existed, files_replaced
    full_name = os.path.basename(local_path)
    print(f"Handling file '{local_path}' in '{dest_uuid}' (mode: {mode})")
    existing_uuid = find_file_uuid(dest_uuid, full_name)
    if not existing_uuid:
        if upload_file(local_path, dest_uuid):
            files_uploaded += 1
    else:
        if mode == 'append':
            print(f"File '{full_name}' exists, skipping")
            files_existed += 1
        elif mode == 'replace':
            if trash_file(existing_uuid):
                if upload_file(local_path, dest_uuid):
                    files_replaced += 1
                else:
                    print(f"Failed to replace '{local_path}' after trashing")
            else:
                print(f"Failed to trash '{full_name}', skipping replacement")

def backup_dir(local_dir, remote_uuid, mode):
    print(f"Backing up directory '{local_dir}' to '{remote_uuid}'")
    for entry in os.listdir(local_dir):
        local_path = os.path.join(local_dir, entry)
        if os.path.isdir(local_path):
            sub_uuid = find_or_create_folder(remote_uuid, entry)
            backup_dir(local_path, sub_uuid, mode)
        elif os.path.isfile(local_path):
            handle_file(local_path, remote_uuid, mode)
        else:
            print(f"Skipping non-file/non-dir '{local_path}'")

def get_total_size(local_dir):
    total = 0
    for root, dirs, files in os.walk(local_dir):
        for f in files:
            fp = os.path.join(root, f)
            try:
                total += os.path.getsize(fp)
            except (OSError, PermissionError) as e:
                print(f"Error getting size of '{fp}': {e}")
    return total

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python backup.py <local_dir> <mode: append|replace>")
        sys.exit(1)
    local_root = sys.argv[1]
    mode = sys.argv[2].lower()
    if mode not in ['append', 'replace']:
        print("Invalid mode: must be 'append' or 'replace'")
        sys.exit(1)
    print(f"Local root directory: {local_root}")
    start_time = time.time()
    total_size = get_total_size(local_root)
    base_name = os.path.basename(os.path.abspath(local_root))
    root_parent = ""
    remote_root_uuid = find_or_create_folder(root_parent, base_name)
    backup_dir(local_root, remote_root_uuid, mode)
    end_time = time.time()
    total_time = end_time - start_time
    print("\nBackup Summary:")
    print(f"Folders created: {folders_created}")
    print(f"Folders existed: {folders_existed}")
    print(f"Files uploaded (new): {files_uploaded}")
    print(f"Files existed (skipped): {files_existed}")
    if mode == 'replace':
        print(f"Files replaced (trashed + uploaded): {files_replaced}")
    print(f"Total file size: {total_size / (1024**2):.2f} MB")
    print(f"Total time: {total_time / 60:.2f} minutes")
    if total_size > 0:
        time_per_gb = (total_time / 60) / (total_size / (1024**3))
        print(f"Time per GB: {time_per_gb:.2f} minutes/GB")
        megabits = total_size * 1024 * 128 # 128 is 1024/8
        print(f"Speed: {megabits / total_time}mbps")
    else:
        print("Time per GB: N/A (zero size)")
