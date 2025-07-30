#  Photo Metadata Tool

A simple and user-friendly EXIF metadata editor for JPEG images built with Python and Tkinter.  
Supports editing fields like Title, Subject, Tags, Comments, Authors, and Copyright, along with batch renaming and template saving/loading.

---

## ✨ Features

- View and edit metadata
- Hover preview of image metadata
- Batch rename images
- Save/load reusable metadata templates
- Clear all metadata from photos

---

##  Requirements

Make sure the following are installed:

###  Python 3

Check with:

```bash
python3 --version
```
Install via:
```bash
sudo apt install python3
```

##  Required Python libraries

Install using pip:
```bash
pip install pillow piexif
```
##  Installation
 1. Clone or Download
```
git clone https://github.com/yourname/photo-metadata-tool.git
```
```
cd photo-metadata-tool
```
Or download and unzip manually.
###  2. Optional: Install as a desktop app

To install into your Linux Mint menu:
```
chmod +x install.sh
./install.sh
```
This will:
    Copy the files to ~/.local/share/photo-metadata/
    Add a launcher to your system menu

####  3. Launch
Option A: From terminal

python3 main.py

Option B: From app menu

After running install.sh, look for Photo Metadata Tool in your app menu.
## How to Use

### 1. Select Images

Click 📁 Select Images to load one or more .jpg images.
### 2. Edit Metadata

Fill in fields like Title, Tags, Comments, etc.
### 3. Apply Metadata

Click ✅ Apply Metadata to embed the info into the selected images.
### 4. Rename Images

Use ✏️ Rename Current Image or 🧾 Batch Rename All for filename cleanup.
### 5. Save / Load Templates

Save commonly used metadata sets and reuse them anytime.
### 6. Clear Metadata

Use 🧹 Clear Metadata to strip all EXIF data.
### 7. Preview

Hover over the image to quickly see the embedded metadata.

## File Structure
```
photo-metadata-app/
├── main.py                 # Main Tkinter GUI
├── metadata_handler.py     # EXIF logic
├── install.sh              # Easy installer
├── photo-metadata.desktop  # Desktop launcher
├── icon.png                # App icon
├── templates/              # Auto-created folder for template JSON files
└── README.md               # You're here!
```
## Tested On

Linux Mint 21+

Python 3.8+

Works on other Linux distros with python3, pip, and GUI support.

## License

MIT License
🙌 Acknowledgments

    Pillow – image handling

    piexif – EXIF read/write