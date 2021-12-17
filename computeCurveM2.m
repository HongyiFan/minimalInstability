function curve_points = computeCurveM2(P1,P2,w,h)
    cc = onlineStage(P1,P2);
    curve_points = curve_zeroLevelSet(cc,w,h)
end