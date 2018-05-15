package com.github.radium226.dlib;

import static org.junit.Assert.*;
import org.junit.Test;

import java.awt.*;

public class RectangleBuilderTest {

    @Test
    public void ensureBuildRectangleReturnsAWTRectangle() {
        DLib.loadLibrary();

        Rectangle expectedRectangle = new Rectangle(0, 0, 1, 1);
        Rectangle rectangle = RectangleBuilder.buildRectangle(0, 0, 1, 1);
        assertEquals(expectedRectangle, rectangle);
    }

}
