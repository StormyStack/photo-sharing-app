document.addEventListener("DOMContentLoaded", function () {
    const uploadForm = document.getElementById("uploadForm");
    const fileInput = document.getElementById("fileInput");
    const gallery = document.getElementById("gallery");
    const uploadButton = uploadForm.querySelector("button");
    const fileList = uploadForm.querySelector(".file-list");
    const errorMessage = document.getElementById("errorMessage");

    fileInput.addEventListener("change", function () {
        const files = this.files;
        fileList.innerHTML = "";
        errorMessage.classList.remove("visible");

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

    uploadForm.addEventListener("submit", async (event) => {
        event.preventDefault();
        const files = fileInput.files;

        console.log("Files object:", files);
        console.log("Number of files:", files ? files.length : "No files");

        if (!files || files.length === 0) {
            errorMessage.classList.add("visible");
            setTimeout(() => errorMessage.classList.remove("visible"), 3000);
            return;
        }

        const formData = new FormData();
        for (const file of files) {
            formData.append("file", file);
        }

        try {
            uploadButton.disabled = true;
            uploadButton.textContent = `Uploading ${files.length} File${files.length > 1 ? 's' : ''}...`;

            const response = await fetch("/upload", {
                method: "POST",
                body: formData,
            });

            const result = await response.json();
            if (response.ok) {
                alert(result.message || `${files.length} file${files.length > 1 ? 's' : ''} uploaded successfully!`);
            } else {
                throw new Error(result.error || "Unknown upload error");
            }

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

    async function loadImages() {
        try {
            gallery.innerHTML = "<p>Loading...</p>";
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

            images.forEach((image) => {
                const img = document.createElement("img");
                img.src = image.photo_url;
                img.classList.add("gallery-image");
                img.alt = "Gallery image";
                img.loading = "lazy";
                img.onerror = () => {
                    img.src = "/static/fallback-image.jpg";
                    console.error(`Failed to load image: ${image.photo_url}`);
                };
                gallery.appendChild(img);
            });
        } catch (error) {
            console.error("Error loading images:", error);
            gallery.innerHTML = "<p>Error loading gallery</p>";
        }
    }

    loadImages();
});