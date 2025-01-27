import os

def rename_files(directory):
    try:
        # List all files in the directory
        files = os.listdir(directory)
        
        for file_name in files:
            # Check if the file contains -R1 or -R2
            if '-R1' in file_name or '-R2' in file_name:
                # Replace -R1 and -R2 with _R1 and _R2
                new_name = file_name.replace('-R1', '_R1').replace('-R2', '_R2')
                
                # Get the full path of the files
                old_path = os.path.join(directory, file_name)
                new_path = os.path.join(directory, new_name)
                
                # Rename the file
                os.rename(old_path, new_path)
                print(f"Renamed: {file_name} -> {new_name}")
        
        print("Renaming completed.")
    
    except Exception as e:
        print(f"An error occurred: {e}")

# Specify your directory here
directory_path = "./3KO"  # Update with the correct path
rename_files(directory_path)
