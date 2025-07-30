# metadata_handler.py

import os
import json
from PIL import Image
import piexif
from piexif import ExifIFD, ImageIFD

TEMPLATE_DIR = "templates"
os.makedirs(TEMPLATE_DIR, exist_ok=True)

# ----------------------------
# TEMPLATE MANAGEMENT
# ----------------------------

def save_template(template_name, metadata):
    """Save metadata as a reusable template (JSON)."""
    path = os.path.join(TEMPLATE_DIR, f"{template_name}.json")
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(metadata, f, indent=4)
    return path

def load_template(template_name):
    """Load a saved template into a metadata dictionary."""
    path = os.path.join(TEMPLATE_DIR, f"{template_name}.json")
    if not os.path.exists(path):
        raise FileNotFoundError(f"Template '{template_name}' not found.")
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f)

def list_templates():
    """Return a list of saved template names (no extension)."""
    return [f[:-5] for f in os.listdir(TEMPLATE_DIR) if f.endswith(".json")]

# ----------------------------
# METADATA APPLICATION
# ----------------------------

def apply_metadata_to_image(image_path, metadata):
    """Apply structured metadata to appropriate EXIF fields."""
    img = Image.open(image_path)

    try:
        exif_dict = piexif.load(img.info.get("exif", b""))
    except Exception:
        exif_dict = {"0th": {}, "Exif": {}, "GPS": {}, "1st": {}, "thumbnail": None}

    # Extract fields
    title = metadata.get("Title", "")
    subject = metadata.get("Subject", "")
    tags = metadata.get("Tags", "")
    comments = metadata.get("Comments", "")
    authors = metadata.get("Authors", "")
    copyright_str = metadata.get("Copyright", "")

    # Standard fields (UTF-8)
    exif_dict["0th"][ImageIFD.ImageDescription] = title.encode("utf-8", errors="replace")
    exif_dict["0th"][ImageIFD.Artist] = authors.encode("utf-8", errors="replace")
    exif_dict["0th"][ImageIFD.Copyright] = copyright_str.encode("utf-8", errors="replace")

    # Windows XP-specific tags (must be UTF-16LE + null)
    def encode_xp(val):
        return val.encode("utf-16le") + b"\x00\x00" if val else b""

    exif_dict["0th"][ImageIFD.XPSubject] = encode_xp(subject)
    exif_dict["0th"][ImageIFD.XPKeywords] = encode_xp(tags)

    # UserComment with ASCII prefix
    if comments:
        exif_dict["Exif"][ExifIFD.UserComment] = b"ASCII\x00\x00\x00" + comments.encode("utf-8", errors="replace")

    # Save new EXIF to file
    exif_bytes = piexif.dump(exif_dict)
    img.save(image_path, exif=exif_bytes)

def apply_metadata_to_images(image_paths, metadata):
    """Apply metadata to a list of image files."""
    for path in image_paths:
        try:
            apply_metadata_to_image(path, metadata)
        except Exception as e:
            print(f"❌ Failed to update {path}: {e}")

# ----------------------------
# READ METADATA
# ----------------------------

import piexif
from piexif import ExifIFD, ImageIFD

def read_metadata_from_image(path):
    try:
        exif_dict = piexif.load(path)
    except Exception as e:
        print(f"Error reading EXIF metadata: {e}")
        return {}

    metadata = {}

    # Helper to decode XP fields (UTF-16LE with trailing nulls)
    def decode_xp_field(value):
        if isinstance(value, (bytes, bytearray)):
            try:
                return value.decode('utf-16le').rstrip('\x00')
            except Exception:
                return value
        return value

    # 0th IFD tags
    zeroth = exif_dict.get("0th", {})
    exif = exif_dict.get("Exif", {})

    # Read stored fields if present
    title = zeroth.get(ImageIFD.ImageDescription)
    if title:
        metadata["Title"] = title.decode('utf-8', errors='replace') if isinstance(title, bytes) else title

    subject = zeroth.get(ImageIFD.XPSubject)
    if subject:
        metadata["Subject"] = decode_xp_field(subject)

    tags = zeroth.get(ImageIFD.XPKeywords)
    if tags:
        metadata["Tags"] = decode_xp_field(tags)

    copyright_str = zeroth.get(ImageIFD.Copyright)
    if copyright_str:
        metadata["Copyright"] = copyright_str.decode('utf-8', errors='replace') if isinstance(copyright_str, bytes) else copyright_str

    authors = zeroth.get(ImageIFD.Artist)
    if authors:
        metadata["Authors"] = authors.decode('utf-8', errors='replace') if isinstance(authors, bytes) else authors

    user_comment = exif.get(ExifIFD.UserComment)
    if user_comment and isinstance(user_comment, (bytes, bytearray)):
        # UserComment usually has a prefix "ASCII\0\0\0"
        try:
            if user_comment.startswith(b"ASCII\x00\x00\x00"):
                comment_text = user_comment[8:].decode('utf-8', errors='replace').rstrip('\x00')
                metadata["Comments"] = comment_text
            else:
                metadata["Comments"] = user_comment.decode('utf-8', errors='replace').rstrip('\x00')
        except Exception:
            metadata["Comments"] = str(user_comment)

    return metadata


def decode_metadata_value(value):
    if isinstance(value, tuple):
        try:
            return bytes(value).decode("utf-16le").rstrip('\x00')
        except:
            return str(value)
    elif isinstance(value, bytes):
        try:
            return value.decode("utf-8", errors="replace").rstrip('\x00')
        except:
            return str(value)
    return value




# ----------------------------
# CLEAR METADATA
# ----------------------------

def clear_metadata_from_image(image_path):
    """Remove all EXIF metadata from an image and preserve image content."""
    try:
        img = Image.open(image_path)
        img.save(image_path, exif=b"")
    except Exception as e:
        print(f"❌ Failed to clear metadata from {image_path}: {e}")

def clear_metadata_from_images(image_paths):
    """Remove EXIF metadata from a list of image files."""
    for path in image_paths:
        clear_metadata_from_image(path)
