package com.xebialabs.deployit.integration.test;

import java.io.File;
import java.util.concurrent.atomic.AtomicReference;

/**
 */
public final class TemporaryDirectoryHolder {

    private TemporaryDirectoryHolder() {}

    private static final AtomicReference<File> FOLDERHOLDER = new AtomicReference<>();

    public static void init(File tempRoot) {
        FOLDERHOLDER.set(tempRoot);
    }

    public static void destroy() {
        FOLDERHOLDER.set(null);
    }

    public static File getTemporaryDirectory() {
        return FOLDERHOLDER.get();
    }
}
