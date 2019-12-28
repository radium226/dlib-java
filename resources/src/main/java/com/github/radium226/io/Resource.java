package com.github.radium226.io;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;

public class Resource {

    final public static ResourceLoader SYSTEM = resourceName -> System.class.getResource(resourceName);

    final public static ResourceLoader CONTEXT_CLASS_LOADER = resourceName -> Thread.currentThread().getContextClassLoader().getResource(resourceName);

    final public static ResourceLoader CURRENT = resourceName -> Resource.class.getResource(resourceName);

    final public static ResourceLoader LOCAL_FILE = resourceName -> {
        Path resourceFilePath = Paths.get(resourceName);
        if (Files.exists(resourceFilePath)) {
            try {
                return resourceFilePath.toUri().toURL();
            } catch (MalformedURLException e) {
                throw new IOException(e);
            }
        } else {
            return null;
        }
    };

    @FunctionalInterface
    public static interface ResourceLoader {

        URL loadResource(String resourceName) throws IOException;

    }

    public static List<ResourceLoader> resourceLoadersFor(String resourceName) {
        return Arrays.asList(LOCAL_FILE, CURRENT, CONTEXT_CLASS_LOADER, SYSTEM);
    }

    public static Resource byName(String resourceName) {
        return new Resource(resourceName);
    }

    private String name;

    public Resource(String name) {
        super();
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public URL getURL() throws IOException {
        URL lastURL = null;
        for (ResourceLoader resourceLoader : resourceLoadersFor(name)) {
            lastURL = resourceLoader.loadResource(name);

            if (lastURL != null) {
                break;
            }
        }

        if (lastURL == null) {
            throw new IOException("Unable to find " + name + " resource");
        }

        return lastURL;
    }

    public Path getPath() throws IOException {
        try {
            return new File(getURL().toURI()).toPath();
        } catch (URISyntaxException e) {
            throw new IOException(e);
        }
    }

    public Path copyToTempFolder() throws IOException {
        Path tempFolderPath = Paths.get(System.getProperty("java.io.tmpdir")).resolve(getClass().getSimpleName());
        if (!Files.exists(tempFolderPath)) {
            Files.createDirectories(tempFolderPath);
        }
        return copyTo(tempFolderPath);
    }

    public Path copyTo(Path folderPath) throws IOException {
        Path copiedFilePath = folderPath.resolve(getName());
        if (!Files.exists(copiedFilePath)) {
            Files.copy(getClass().getClassLoader().getResourceAsStream(getName()), copiedFilePath);
        }

        return copiedFilePath;
    }
}
