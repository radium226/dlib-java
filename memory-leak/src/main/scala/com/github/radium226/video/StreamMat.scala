package com.github.radium226.video

import cats._
import cats.effect._
import fs2._

import org.opencv.core._

import cats.implicits._
import cats.effect.implicits._

object StreamMat extends IOApp with FrameSyntax {

  override def run(arguments: List[String]): IO[ExitCode] = {
    val size = new Size(300, 180)
    IO(System.load("/usr/lib/libopencv_java420.so")) *> Stream.emit[IO, Frame[IO]](Frame.ones[IO](size))
      .repeat
      .take(50000)
      .map({ frame =>
        frame * 25
      })
      .zipWithIndex
      .evalMap({ case (frame, index) =>
        if (index % 1000 == 0) IO(println(s"index=${index} / frame=${frame}")).as(frame) else IO.pure(frame)
      })
      .flatMap(_.toBytes)
      .compile
      .drain
      .as(ExitCode.Success)

  }



}
