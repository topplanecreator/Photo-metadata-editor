import tkinter as tk
from tkinter import ttk, filedialog, messagebox, simpledialog
from PIL import Image, ImageTk
import os
import metadata_handler as mh

class MetadataApp:
    def __init__(self, root):
        self.root = root
        self.root.title("📸 Photo Metadata Tool")
        self.root.geometry("1000x1800")
        self.root.minsize(800, 600)

        self.current_index = 0
        self.preview_enabled = tk.BooleanVar(value=True)
        self.tooltip_win = None
        self.last_tooltip_text = ""
        self.image_paths = []
        self.templates = mh.list_templates()

        self.fields = {
            "Title": tk.StringVar(),
            "Subject": tk.StringVar(),
            "Tags": tk.StringVar(),
            "Comments": tk.StringVar(),
            "Authors": tk.StringVar(),
            "Copyright": tk.StringVar()
        }

        self.template_var = tk.StringVar()
        self._setup_styles()
        self._build_ui()

    def _setup_styles(self):
        style = ttk.Style()
        style.configure("TLabel", font=("Segoe UI", 10))
        style.configure("TButton", font=("Segoe UI", 10), padding=5)
        style.configure("TEntry", font=("Segoe UI", 10))
        style.configure("TLabelframe.Label", font=("Segoe UI", 11, "bold"))

    def _build_ui(self):
        # Outer frame
        outer_frame = ttk.Frame(self.root)
        outer_frame.pack(fill="both", expand=True)

        # Add Canvas + Scrollbar
        canvas = tk.Canvas(outer_frame)
        scrollbar = ttk.Scrollbar(outer_frame, orient="vertical", command=canvas.yview)
        self.scrollable_frame = ttk.Frame(canvas)
        canvas.bind_all("<MouseWheel>", lambda e: canvas.yview_scroll(-1 * (e.delta // 120), "units"))

        self.scrollable_frame.bind(
            "<Configure>",
            lambda e: canvas.configure(scrollregion=canvas.bbox("all"))
        )

        canvas.create_window((0, 0), window=self.scrollable_frame, anchor="nw")
        canvas.configure(yscrollcommand=scrollbar.set)

        canvas.pack(side="left", fill="both", expand=True)
        scrollbar.pack(side="right", fill="y")

        # Store canvas to update preview
        self.canvas_container = canvas

        # Add all your UI inside `self.scrollable_frame` instead of `container`
        container = self.scrollable_frame  # Replace original reference

        # (Continue with your existing UI construction logic, now inside `container`)
        ...


        # Metadata Fields
        fields_frame = ttk.Labelframe(container, text="Metadata Fields", padding=10)
        fields_frame.pack(fill="x", padx=5, pady=10)

        for i, (label, var) in enumerate(self.fields.items()):
            ttk.Label(fields_frame, text=label).grid(row=i, column=0, sticky="e", padx=5, pady=4)
            ttk.Entry(fields_frame, textvariable=var, width=50).grid(row=i, column=1, sticky="ew", padx=5, pady=4)
            fields_frame.columnconfigure(1, weight=1)

        # Image Controls
        control_frame = ttk.Labelframe(container, text="Image Controls", padding=10)
        control_frame.pack(fill="x", padx=5, pady=10)

        ttk.Button(control_frame, text="📁 Select Images", command=self.select_images).grid(row=0, column=0, padx=5, pady=3)
        ttk.Button(control_frame, text="✏️ Rename Current Image", command=self.rename_current_image).grid(row=0, column=1, padx=5, pady=3)
        ttk.Button(control_frame, text="🧾 Batch Rename All", command=self.batch_rename_images).grid(row=0, column=2, padx=5, pady=3)




        # Template Controls
        template_frame = ttk.Labelframe(container, text="Templates", padding=10)
        template_frame.pack(fill="x", padx=5, pady=10)

        ttk.Button(template_frame, text="💾 Save Template", command=self.save_template).grid(row=0, column=0, sticky="w", padx=5, pady=4)
        ttk.Label(template_frame, text="Load/Delete Template:").grid(row=1, column=0, sticky="w", padx=5, pady=4)
        self.template_menu = ttk.Combobox(template_frame, textvariable=self.template_var, values=self.templates, state="readonly", width=40)
        self.template_menu.grid(row=1, column=1, sticky="ew", padx=5, pady=4)
        ttk.Button(template_frame, text="📂 Load", command=self.load_template).grid(row=2, column=0, sticky="ew", padx=5, pady=4)
        ttk.Button(template_frame, text="🗑️ Delete", command=self.delete_template).grid(row=2, column=1, sticky="e", padx=5, pady=4)

        # Status & Preview
        status_frame = ttk.Frame(container)
        status_frame.pack(fill="x", pady=(10, 0))
        ttk.Checkbutton(status_frame, text="Show Preview", variable=self.preview_enabled, command=self.toggle_preview).pack(side="left", padx=(0, 10))
        self.status = ttk.Label(status_frame, text="Ready", anchor="w")
        self.status.pack(side="left", fill="x", expand=True)

        # Image Preview
        preview_frame = ttk.Labelframe(container, text="Image Preview", padding=10)
        preview_frame.pack(fill="both", expand=True, padx=10, pady=(10, 0))
        self.canvas = tk.Canvas(preview_frame, bg="gray")
        self.canvas.pack(fill="both", expand=True)
        self.canvas.bind("<Configure>", self._redraw_preview)
        self.canvas_image_id = None

        # Navigation
        nav_frame = ttk.Frame(container)
        nav_frame.pack(pady=10)
        ttk.Button(nav_frame, text="🧹 Clear Metadata", command=self.clear_metadata).pack(side="left", padx=10)
        ttk.Button(nav_frame, text="⬅️ Prev", command=self.show_previous_image).pack(side="left", padx=5)
        ttk.Button(nav_frame, text="➡️ Next", command=self.show_next_image).pack(side="left", padx=5)
        ttk.Button(nav_frame, text="✅ Apply Metadata", command=self.apply_metadata).pack(side="right", padx=10)

    def _add_button_row(self, frame, buttons):
        for i, (text, cmd) in enumerate(buttons):
            ttk.Button(frame, text=text, command=cmd).grid(row=i, column=0, columnspan=2, sticky="ew", padx=5, pady=3)

    def select_images(self):
        files = filedialog.askopenfilenames(title="Select Images", filetypes=[("JPEG Images", "*.JPG *.jpg *.jpeg")])
        if files:
            self.image_paths = list(files)
            self.current_index = 0
            self.status.config(text=f"Selected {len(self.image_paths)} image(s)")
            self.show_preview(self.image_paths[self.current_index])

    def show_preview(self, image_path):
        try:
            canvas_width = self.canvas.winfo_width()
            canvas_height = self.canvas.winfo_height()
            if canvas_width < 10 or canvas_height < 10:
                return  # Skip early small sizes

            image = Image.open(image_path)
            image.thumbnail((canvas_width, canvas_height))
            self.preview_image = ImageTk.PhotoImage(image)

            self.canvas.delete("all")
            self.canvas_image_id = self.canvas.create_image(
                canvas_width // 2,
                canvas_height // 2,
                anchor="center",
                image=self.preview_image
            )

            self.status.config(text=f"Previewing: {os.path.basename(image_path)} ({self.current_index + 1}/{len(self.image_paths)})")

            self.canvas.tag_bind(self.canvas_image_id, "<Enter>", self.show_tooltip)
            self.canvas.tag_bind(self.canvas_image_id, "<Leave>", self.hide_tooltip)
            self.canvas.tag_bind(self.canvas_image_id, "<Motion>", self.show_tooltip)

        except Exception as e:
            self.canvas.delete("all")
            self.canvas.create_text(300, 300, text=f"Error loading image:\n{e}", fill="white")

    def rename_current_image(self):
        if not self.image_paths:
            messagebox.showwarning("No Image", "Please select images first.")
            return

        old_path = self.image_paths[self.current_index]
        directory, old_filename = os.path.split(old_path)
        base, ext = os.path.splitext(old_filename)

        new_name = simpledialog.askstring("Rename Image", "Enter new filename (without extension):", initialvalue=base)
        if not new_name:
            return  # User cancelled

        new_path = os.path.join(directory, new_name + ext)
        if os.path.exists(new_path):
            messagebox.showerror("File Exists", f"A file named '{new_name + ext}' already exists.")
            return

        try:
            os.rename(old_path, new_path)
            self.image_paths[self.current_index] = new_path
            self.status.config(text=f"✏️ Renamed to {new_name + ext}")
            self.show_preview(new_path)
        except Exception as e:
            messagebox.showerror("Rename Failed", f"Could not rename file:\n{e}")

    def batch_rename_images(self):
        if not self.image_paths:
            messagebox.showwarning("No Images", "Please select images first.")
            return

        base_name = simpledialog.askstring("Batch Rename", "Enter base filename (e.g. 2025-KYE-D3-P8):")
        if not base_name:
            return  # Cancelled

        directory = os.path.dirname(self.image_paths[0])
        ext = os.path.splitext(self.image_paths[0])[1].lower()
        renamed = []

        for idx, path in enumerate(self.image_paths, start=1):
            new_filename = f"{base_name}-{idx}{ext}"
            new_path = os.path.join(directory, new_filename)

            if os.path.exists(new_path):
                messagebox.showerror("File Exists", f"File '{new_filename}' already exists. Aborting rename.")
                return

            try:
                os.rename(path, new_path)
                renamed.append(new_path)
            except Exception as e:
                messagebox.showerror("Rename Failed", f"Failed to rename '{os.path.basename(path)}': {e}")
                return

        self.image_paths = renamed
        self.current_index = 0
        self.show_preview(self.image_paths[0])
        self.status.config(text=f"🧾 Renamed {len(self.image_paths)} images using base '{base_name}'")



    def _redraw_preview(self, event):
        if not self.image_paths or not self.preview_enabled.get():
            return
        self.show_preview(self.image_paths[self.current_index])

    def show_tooltip(self, event):
        if not self.preview_enabled.get() or not self.image_paths:
            return
        try:
            metadata = mh.read_metadata_from_image(self.image_paths[self.current_index])
        except Exception:
            return

        display_keys = list(self.fields.keys())
        lines = []
        for key in display_keys:
            val = metadata.get(key, "")
            if isinstance(val, (tuple, bytes)):
                try:
                    val = bytes(val).decode("utf-16le").rstrip('\x00')
                except:
                    val = str(val)
            val = str(val)
            if len(val) > 120:
                val = val[:117] + "..."
            lines.append(f"{key}: {val}" if val else f"{key}: (empty)")

        text = "\n".join(lines)
        if text == self.last_tooltip_text:
            return
        self.last_tooltip_text = text

        if self.tooltip_win:
            self.tooltip_win.destroy()

        self.tooltip_win = tk.Toplevel(self.root)
        self.tooltip_win.wm_overrideredirect(True)
        self.tooltip_win.attributes("-topmost", True)
        label = tk.Label(self.tooltip_win, text=text, justify="left",
                         background="#ffffe0", relief="solid", borderwidth=1,
                         font=("Segoe UI", 9))
        label.pack(ipadx=5, ipady=3)

        x = self.root.winfo_pointerx() + 20
        y = self.root.winfo_pointery() + 20
        self.tooltip_win.wm_geometry(f"+{x}+{y}")

    def hide_tooltip(self, _):
        if self.tooltip_win:
            self.tooltip_win.destroy()
            self.tooltip_win = None
            self.last_tooltip_text = ""

    def toggle_preview(self):
        if self.preview_enabled.get():
            self.canvas.pack(expand=True, fill="both")
        else:
            self.canvas.pack_forget()

    def show_next_image(self):
        if self.image_paths:
            self.current_index = (self.current_index + 1) % len(self.image_paths)
            self.show_preview(self.image_paths[self.current_index])

    def show_previous_image(self):
        if self.image_paths:
            self.current_index = (self.current_index - 1) % len(self.image_paths)
            self.show_preview(self.image_paths[self.current_index])

    def gather_metadata(self):
        return {key: var.get().strip() for key, var in self.fields.items()}

    def apply_metadata(self):
        if not self.image_paths:
            messagebox.showwarning("No Images", "Please select image files first.")
            return
        try:
            mh.apply_metadata_to_images(self.image_paths, self.gather_metadata())
            self.status.config(text="✅ Metadata applied successfully.")
        except Exception as e:
            messagebox.showerror("Error", f"Failed to apply metadata:\n{e}")

    def clear_metadata(self):
        if not self.image_paths:
            messagebox.showwarning("No Images", "Please select image files first.")
            return
        if messagebox.askyesno("Clear Metadata", f"Remove ALL metadata from {len(self.image_paths)} image(s)?"):
            mh.clear_metadata_from_images(self.image_paths)
            self.status.config(text="🧹 Metadata cleared successfully.")

    def save_template(self):
        metadata = self.gather_metadata()
        name = simpledialog.askstring("Template Name", "Enter a name for the template:")
        if name:
            mh.save_template(name, metadata)
            self.refresh_templates()
            self.template_var.set(name)
            self.status.config(text=f"💾 Template '{name}' saved.")

    def load_template(self):
        name = self.template_var.get()
        if not name:
            messagebox.showwarning("No Selection", "Please select a template to load.")
            return
        try:
            metadata = mh.load_template(name)
            for key in self.fields:
                self.fields[key].set(metadata.get(key, ""))
            self.status.config(text=f"📂 Template '{name}' loaded.")
        except FileNotFoundError:
            messagebox.showerror("Template Not Found", f"No template found with name '{name}'.")

    def delete_template(self):
        name = self.template_var.get()
        if not name:
            messagebox.showwarning("No Selection", "Please select a template to delete.")
            return
        if messagebox.askyesno("Delete Template", f"Are you sure you want to delete template '{name}'?"):
            try:
                os.remove(os.path.join(mh.TEMPLATE_DIR, f"{name}.json"))
                self.refresh_templates()
                self.template_var.set('')
                self.status.config(text=f"🗑️ Template '{name}' deleted.")
            except Exception as e:
                messagebox.showerror("Error", f"Failed to delete template: {e}")

    def refresh_templates(self):
        self.templates = mh.list_templates()
        self.template_menu['values'] = self.templates

    def view_metadata(self):
        file_path = filedialog.askopenfilename(title="Select Image to View Metadata", filetypes=[("JPEG Images",  "*.JPG*.jpg *.jpeg")])
        if not file_path:
            return
        try:
            data = mh.read_metadata_from_image(file_path)
            if not data:
                messagebox.showinfo("No Metadata", "No EXIF metadata found in this image.")
                return
            win = tk.Toplevel(self.root)
            win.title("Image Metadata")
            win.geometry("700x600")
            text = tk.Text(win, wrap="none", font=("Courier New", 10))
            scroll = ttk.Scrollbar(win, orient="vertical", command=text.yview)
            text.configure(yscrollcommand=scroll.set)
            for key, val in data.items():
                text.insert("end", f"{key}: {val}\n")
            text.pack(side="left", fill="both", expand=True)
            scroll.pack(side="right", fill="y")
        except Exception as e:
            messagebox.showerror("Error", f"Could not read metadata:\n{e}")


if __name__ == "__main__":
    root = tk.Tk()
    app = MetadataApp(root)
    root.mainloop()
