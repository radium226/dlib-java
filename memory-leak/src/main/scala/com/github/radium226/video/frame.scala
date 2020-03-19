package com.github.radium226.video

import _root_.org.opencv.core.{Core, CvType, Mat, Scalar, Size}
import _root_.fs2.Stream
import cats.implicits._
import cats.effect.Sync
import org.opencv.imgproc.Imgproc

class Frame[F[_]](private[video] val stream: Stream[F, Mat]) {

  private[video] def transform(f: (Mat, Mat) => Unit)(implicit F: Sync[F]): Frame[F] = {
    new Frame[F](Frame.empty[F].stream.flatMap({ resultMat =>
      stream.evalMap({ mat =>
        F.delay({
          f(mat, resultMat)
          resultMat
        })
      })
    }))
  }

}

object Frame {

  private[video] def lift[F[_]](block: => Mat, tag: String)(implicit F: Sync[F]): Frame[F] = {
    new Frame[F](Stream.bracket[F, Mat]({
      /*F.delay(println(s"Creating #${tag}... ")) *> */F.delay(block)
    })({ mat =>
      /*F.delay(println(s"Deleting #${tag}...")) *> */F.delay(mat.delete())
    }))
  }

  def fromBytes[F[_]](size: Size, bytes: Array[Byte])(implicit F: Sync[F]): Frame[F] = {
    lift[F]({
      val mat = new Mat(size, CvType.CV_8UC3)
      mat.put(0, 0, bytes)
      mat
    }, "fromBytes")
  }

  def empty[F[_]](implicit F: Sync[F]): Frame[F] = {
    lift[F](new Mat(), "empty")
  }

  def ones[F[_]](size: Size)(implicit F: Sync[F]): Frame[F] = {
    lift[F](Mat.ones(size, CvType.CV_8UC3), "ones")
  }

}

trait FrameSyntax {

  implicit class FrameOps[F[_]](frame: Frame[F]) {

    def toBytes(implicit F: Sync[F]): Stream[F, Array[Byte]] = {
      frame.stream.evalMap({ mat =>
        F.delay({
          val bytes = Array.ofDim[Byte](mat.width() * mat.height() * mat.channels())
          mat.get(0, 0, bytes)
          bytes
        })
      })
    }

    def *(scalar: Scalar)(implicit F: Sync[F]): Frame[F] = {
      frame.transform({ case (oldMat, newMat) =>
        Core.divide(oldMat, scalar, newMat)
      })
    }

    def *[T](t: T)(implicit numeric: Numeric[T], F: Sync[F]): Frame[F] = {
      frame * new Scalar(numeric.toDouble(t))
    }

    def resize(size: Size)(implicit F: Sync[F]): Frame[F] = {
      frame.transform({ case (oldMat, newMat) =>
        Imgproc.resize(oldMat, newMat, size)
      })
    }

  }

}
