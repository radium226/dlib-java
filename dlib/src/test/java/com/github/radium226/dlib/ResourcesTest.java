package com.github.radium226.dlib;

import com.github.radium226.io.Resource;
import org.junit.Test;

import java.io.IOException;

public class ResourcesTest {

    @Test
    public void testKnownFaces() throws IOException {
        System.out.println(Resource.byName("known-faces").getPath());

    }
}
