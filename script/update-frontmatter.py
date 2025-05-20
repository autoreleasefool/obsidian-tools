import re
import os
import yaml
import sys

def update_yaml(yaml_data):
    """
    Function to update the YAML data.
    Modify this function as needed to perform updates.
    """
    return yaml_data

def process_file(file_path):
    """
    Process a single file: read, parse YAML, update, and save.
    """
    with open(file_path, 'r') as file:
        contents = file.read()

    # Split the file contents by "---" to extract YAML
    parts = contents.split('---')
    if len(parts) < 3:
        print(f"Skipping file {file_path}: No valid YAML found.")
        return

    yaml_content = parts[1]
    try:
        yaml_data = yaml.safe_load(yaml_content)
    except yaml.YAMLError as e:
        print(f"Error parsing YAML in file {file_path}: {e}")
        return

    # Update the YAML data
    updated_yaml_data = update_yaml(yaml_data)

    # Reconstruct the file contents
    updated_yaml_content = yaml.dump(updated_yaml_data, sort_keys=False, indent=2)
    updated_yaml_content = re.sub(r' ?null', '', updated_yaml_content)

    updated_contents = f"---\n{updated_yaml_content}---{'---'.join(parts[2:])}"

    # Save the updated contents back to the file
    with open(file_path, 'w') as file:
        file.write(updated_contents)
    # print(f"Updated file: {file_path}")

def process_directory(directory):
    """
    Recursively iterate over a directory and process each file.
    """
    for root, _, files in os.walk(directory):
        for file in (f for f in files if f.endswith('.md')):
            file_path = os.path.join(root, file)
            # print(f"Processing file: {file_path}")
            process_file(file_path)

if __name__ == "__main__":
    # Replace with the directory you want to process
    if len(sys.argv) < 2:
        print("Usage: python update-frontmatter.py <directory>")
        sys.exit(1)

    directory_to_process = sys.argv[1]
    process_directory(directory_to_process)