document.addEventListener("DOMContentLoaded", function () {
    const uploadForm = document.getElementById("uploadForm");
    const fileInput = document.getElementById("fileInput");
    const gallery = document.getElementById("gallery");
    const uploadButton = uploadForm.querySelector("button");
    const fileList = uploadForm.querySelector(".file-list");
    const errorMessage = document.getElementById("errorMessage");

    // Update file list when files are selected
    fileInput.addEventListener("change", function () {
        const files = this.files;
        fileList.innerHTML = "";
        errorMessage.classList.remove("visible"); // Hide error when files change

        if (files && files.length > 0) {
            Array.from(files).forEach(file => {
                const fileDiv = document.createElement("div");
                fileDiv.className = "file-name";
                fileDiv.textContent = file.name;
                fileList.appendChild(fileDiv);
            });
            uploadButton.textContent = `Upload ${files.length} File${files.length > 1 ? 's' : ''}`;
        } else {
            uploadButton.textContent = "Upload";
        }
    });

    // Handle multiple file upload
    uploadForm.addEventListener("submit", async (event) => {
        event.preventDefault(); // Prevent form submission

        const files = fileInput.files;

        // Debug logs to confirm file state
        console.log("Files object:", files);
        console.log("Number of files:", files ? files.length : "No files");

        // Validation: Check if files are selected
        if (!files || files.length === 0) {
            errorMessage.classList.add("visible"); // Show error message
            setTimeout(() => errorMessage.classList.remove("visible"), 3000); // Hide after 3 seconds
            return;
        }

        const formData = new FormData();
        for (const file of files) {
            formData.append("files", file);
        }

        try {
            uploadButton.disabled = true;
            uploadButton.textContent = `Uploading ${files.length} File${files.length > 1 ? 's' : ''}...`;

            const response = await fetch("/upload", {
                method: "POST",
                body: formData,
            });

            if (!response.ok) {
                throw new Error(`Upload failed with status: ${response.status}`);
            }

            const result = await response.json();
            alert(result.message || `${files.length} file${files.length > 1 ? 's' : ''} uploaded successfully!`);
            uploadForm.reset();
            fileList.innerHTML = "";
            uploadButton.textContent = "Upload";
            await loadImages();
        } catch (error) {
            console.error("Error uploading files:", error);
            alert(`Upload failed: ${error.message}`);
        } finally {
            uploadButton.disabled = false;
        }
    });

    // Load images from server
    async function loadImages() {
        try {
            const response = await fetch("/images");
            if (!response.ok) {
                throw new Error("Failed to fetch images");
            }

            const images = await response.json();
            gallery.innerHTML = "";

            if (images.length === 0) {
                gallery.innerHTML = "<p>No images available</p>";
                return;
            }

            images.forEach((imageUrl) => {
                const img = document.createElement("img");
                img.src = imageUrl;
                img.classList.add("gallery-image");
                img.alt = "Gallery image";
                img.loading = "lazy";
                img.onerror = () => {
                    img.src = "path/to/fallback-image.jpg";
                    console.error(`Failed to load image: ${imageUrl}`);
                };
                gallery.appendChild(img);
            });
        } catch (error) {
            console.error("Error loading images:", error);
            gallery.innerHTML = "<p>Error loading gallery</p>";
        }
    }

    // Initial load
    loadImages();
});