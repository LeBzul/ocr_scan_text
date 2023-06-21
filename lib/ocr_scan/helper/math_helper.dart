import 'dart:math';
import 'dart:ui';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class MathHelper {
  /// Permet de determiner si deux segments se croisent
  static bool doSegmentsIntersect(Offset p1, Offset p2, Offset q1, Offset q2) {
    double dx1 = p2.dx - p1.dx;
    double dy1 = p2.dy - p1.dy;
    double dx2 = q2.dx - q1.dx;
    double dy2 = q2.dy - q1.dy;

    // crossProduct est le produit vectoriel des vecteurs formés par les segments.
    double crossProduct = dx1 * dy2 - dy1 * dx2;
    if (crossProduct == 0) {
      // Les segments sont parallèles, ils ne se croisent pas
      return false;
    }

    // t représente la position le long du segment p1-p2 où les segments se croisent.
    // Si t est compris entre 0 et 1, cela signifie que le point d'intersection est situé sur le segment p1-p2.
    double t1 = ((q1.dx - p1.dx) * dy2 - (q1.dy - p1.dy) * dx2) / crossProduct;
    // u représente la position le long du segment q1-q2 où les segments se croisent.
    // Si u est compris entre 0 et 1, cela signifie que le point d'intersection est situé sur le segment q1-q2.
    double u1 = ((q1.dx - p1.dx) * dy1 - (q1.dy - p1.dy) * dx1) / crossProduct;

    // On inverse les points p1 et q1 cela permet de vérifier si le segment q1-q2 est dans la direction opposée
    // par rapport au segment p1-p2. Cette inversion permet de corriger les signes des valeurs
    // de u et d'éviter des résultats incorrects dans certains cas spécifiques.
    double t2 = ((q1.dx - p1.dx) * dy2 - (q1.dy - p1.dy) * dx2) / crossProduct;
    double u2 = ((p1.dx - q1.dx) * dy1 - (p1.dy - q1.dy) * dx1) / crossProduct;

    if (t1 >= 0 && t1 <= 1 && u1 >= 0 && u1 <= 1 || t2 >= 0 && t2 <= 1 && u2 >= 0 && u2 <= 1) {
      // Les segments se croisent en un point
      return true;
    }

    // Les segments ne se croisent pas
    return false;
  }

  /// Retourne un angle entre 2 points
  static double retrieveAngle(Offset a, Offset b) {
    double blockAngle = atan2(
      b.dy - a.dy,
      b.dx - a.dx,
    );

    return blockAngle;
  }

  /// C'est assez compliqué d'obtenir l angle du document
  /// La valeur n'est pas du tout précise
  /// TODO : A VOIR POUR VIRER CA
  static double retrieveAngleOLD(List<TextBlock> allBlocks) {
    List<double> angleList = [];
    for (var block in allBlocks) {
      for (var line in block.lines) {
        double blockAngle = atan2(
          line.cornerPoints[1].y - line.cornerPoints[0].y,
          line.cornerPoints[1].x - line.cornerPoints[0].x,
        );
        angleList.add(blockAngle);
      }
    }

    angleList.sort();

    double tempAngle = 0;
    for (var angle in angleList) {
      tempAngle += angle;
    }

    return tempAngle / angleList.length;
/*
    int indexMedian = angleList.length ~/ 2;

    if (angleList.length % 2 == 1) {
      return angleList[indexMedian];
    } else {
      return (angleList[indexMedian - 1] + angleList[indexMedian]) / 2;
    }*/
  }
}